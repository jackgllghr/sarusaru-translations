# SaruSaru Daisakusen: unofficial English translation

English text for the [SaruSaru recompilation](https://github.com/jackgllghr/sarusaru-recomp)
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
| `english-menu.json` | Title, main menu, save/load and Options labels, strings and help lines; 65 in-game action/control prompts and stage, results, collection, Capsule Shop, pause and Gachi King UI |
| `english-gameplay-v1.json` | Character, enemy, stage and area names, plus 207 monkey names |
| `english-dialogue-v1.json` | Tutorial and story dialogue pages |

The catalogs hold English text, identifiers and SHA-256 hashes of the original
text only; they contain no Japanese text, game assets or code.

## Building the pack

The pack is built with the recompilation's tools, from your own copy of the
game (the disc is only read for hashes and string offsets):

```sh
cd ../sarusaru-recomp
python3 profiles/sarusaru/tools/build_menu_translation.py '/path/to/game.iso' \
  --gameplay-catalog ../sarusaru-translations/english-gameplay-v1.json \
  --dialogue-catalog ../sarusaru-translations/english-dialogue-v1.json
```

The tools find this checkout beside `sarusaru-recomp`, or wherever
`SARUSARU_TRANSLATIONS` points. Publish the built `.sstp` as a release asset
here, then configure the launcher with its URL, SHA-256 and size (see the
recompilation's profile README).

## Licence

No licence is granted. The translation is derived from text owned by Sony
Interactive Entertainment; it is offered as an unofficial fan translation for
players who own the game, and will be withdrawn on request from the rights
holder.
