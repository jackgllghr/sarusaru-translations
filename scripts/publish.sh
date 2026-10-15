#!/usr/bin/env bash
# Build the English pack from the catalogs and publish it as a GitHub release.
#
#   scripts/publish.sh /path/to/game.iso [--dry-run]
#
# Environment:
#   SARUSARU_RECOMP  sarusaru-recomp checkout (default: ../sarusaru-recomp)
#   PYTHON           interpreter with Pillow installed (default: python3)
#   GH_TOKEN         used by gh when not logged in (CI)
#
# The release is tagged english-<commit>, so publishing the same catalogs twice
# is a no-op. The pack contains data read from the disc; the ISO itself is never
# uploaded.
set -euo pipefail

here=$(cd "$(dirname "$0")/.." && pwd)
iso=${1:?usage: scripts/publish.sh /path/to/game.iso [--dry-run]}
dry_run=${2:-}
recomp=${SARUSARU_RECOMP:-$here/../sarusaru-recomp}
python=${PYTHON:-python3}

[[ -f $iso ]] || { echo "publish: no ISO at $iso" >&2; exit 1; }
[[ -f $recomp/profiles/sarusaru/tools/build_menu_translation.py ]] ||
  { echo "publish: no sarusaru-recomp checkout at $recomp" >&2; exit 1; }
if [[ -n $(git -C "$here" status --porcelain -- '*.json') ]]; then
  echo "publish: catalogs have uncommitted changes" >&2
  exit 1
fi

commit=$(git -C "$here" rev-parse --short=12 HEAD)
recomp_commit=$(git -C "$recomp" rev-parse --short=12 HEAD)
tag=english-$commit
asset=english-$commit.sstp
repo=${GITHUB_REPOSITORY:-jackgllghr/sarusaru-translations}

if [[ $dry_run != --dry-run ]] && gh release view "$tag" -R "$repo" >/dev/null 2>&1; then
  echo "publish: $tag already exists"
  exit 0
fi

out=$(mktemp -d)
trap 'rm -rf "$out"' EXIT
SARUSARU_TRANSLATIONS=$here "$python" "$recomp/profiles/sarusaru/tools/build_menu_translation.py" "$iso" \
  --catalog "$here/english-menu.json" \
  --gameplay-catalog "$here/english-gameplay-v1.json" \
  --dialogue-catalog "$here/english-dialogue-v1.json" \
  --output "$out/$asset"

sha256=$(shasum -a 256 "$out/$asset" | cut -d' ' -f1)
size=$(wc -c <"$out/$asset" | tr -d ' ')
url=https://github.com/$repo/releases/download/$tag/$asset

cat >"$out/notes.md" <<EOF
Unofficial, unreviewed machine translation, built from catalogs at $commit
with sarusaru-recomp $recomp_commit.

Configure a launcher build with:

\`\`\`sh
-DSARUSARU_ENGLISH_PACK_URL=$url \\
-DSARUSARU_ENGLISH_PACK_SHA256=$sha256 \\
-DSARUSARU_ENGLISH_PACK_SIZE=$size
\`\`\`
EOF

if [[ -n ${GITHUB_OUTPUT:-} ]]; then
  { echo "url=$url"; echo "sha256=$sha256"; echo "size=$size"; echo "tag=$tag"; } >>"$GITHUB_OUTPUT"
fi
if [[ $dry_run == --dry-run ]]; then
  cat "$out/notes.md"
  exit 0
fi
gh release create "$tag" "$out/$asset" -R "$repo" --target "$(git -C "$here" rev-parse HEAD)" \
  --title "English pack $commit" --notes-file "$out/notes.md" --latest
echo "Published $url"
