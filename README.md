# SaruSaru Daisakusen: unofficial English translation

English text for the [SaruSaru recompilation](https://github.com/jackgllghr/bigmission-recomp)
of **Saru! Get You! SaruSaru Daisakusen** (UCJS10060, version 1.00).

**This is an unofficial, machine-made draft.** Every entry marked
`origin: machine_translation` and `review_status: draft` has not been reviewed
by a person. It is not affiliated with, endorsed by, or sponsored by Sony
Interactive Entertainment, which owns the game and its original text.

This repository is kept apart from the recompilation on purpose. The port
itself ships no game text or translation; players opt in to this translation
from the launcher, which downloads a pack built from these catalogs.

## Contents

| File | Contents |
| --- | --- |
| `english-menu.json` | Title, main menu, save/load and Options labels, strings and help lines; 65 in-game action/control prompts and stage, results, collection (including the Monkey Book headings), Capsule Shop, pause and Gachi King UI |
| `english-gameplay-v1.json` | Character, enemy, stage and area names, plus 207 monkey names and their Monkey Book kinds, descriptions and actions |
| `english-dialogue-v1.json` | Tutorial and story dialogue pages |
| `subtitles/<movie>.en.srt` | Subtitles for the cutscene movies `m01`-`m16`, transcribed from their audio and machine-translated |

The catalogs hold English text, identifiers and SHA-256 hashes of the original
text only, and the subtitles English text and timings only; they contain no
Japanese text, game assets or code. The subtitles are drafts too, not reviewed
against the movies; the recompilation's `docs/movie-subtitles.md` describes
making and checking them.

## Building the pack

The pack is built with the recompilation's tools, from your own copy of the
game (the disc is only read for hashes and string offsets):

```sh
cd ../bigmission-recomp
python3 profiles/sarusaru/tools/build_menu_translation.py '/path/to/game.iso' \
  --gameplay-catalog ../sarusaru-translations/english-gameplay-v1.json \
  --dialogue-catalog ../sarusaru-translations/english-dialogue-v1.json \
  --subtitles ../sarusaru-translations/subtitles
```

The tools find this checkout beside `bigmission-recomp`, or wherever
`SARUSARU_TRANSLATIONS` points.

## Publishing

`scripts/publish.sh` builds the pack and publishes it as a release tagged
`english-<commit>` (a no-op if that release exists). The release notes give the
launcher's configure flags:

```sh
scripts/publish.sh '/path/to/game.iso'            # build and publish
scripts/publish.sh '/path/to/game.iso' --dry-run  # build and print the flags only
```

It needs `gh` logged in and Pillow (set `PYTHON` to an interpreter that has it).
The launcher pins the pack's URL, SHA-256 and size at build time, so after
publishing, set the printed `SARUSARU_ENGLISH_PACK_*` values as the defaults in
the recompilation's `profiles/sarusaru/CMakeLists.txt` (see its profile README).

`.github/workflows/publish.yml` runs the script on every push to `main` that
changes a catalog or the subtitles. The pack contains data read from the disc, so the job runs
only on a self-hosted runner labelled `sarusaru-iso` that has a copy; the ISO is
never uploaded. To set it up:

1. Add a self-hosted runner (Settings → Actions → Runners) on the machine with
   the disc, with the extra label `sarusaru-iso`.
2. Add a repository variable `SARUSARU_ISO` with the ISO's path on that machine.

## Licence

No licence is granted. The translation is derived from text owned by Sony
Interactive Entertainment; it is offered as an unofficial fan translation for
players who own the game, and will be withdrawn on request from the rights
holder.
