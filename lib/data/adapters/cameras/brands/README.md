# Camera brand adapters

**v1 product brands: Moultrie + Tactacam**

| Brand id   | Folder         | v1 import path                         |
|------------|----------------|----------------------------------------|
| `moultrie` | `moultrie/`    | Photo dump / filesystem import         |
| `tactacam` | `tactacam/`    | Photo dump / filesystem import         |

## Integration preference (in order)

1. Official brand API / SDK
2. Email / FTP ingest
3. Photo dump / manual import

Neither brand publishes a public official third-party API (as of 2026-09 research).
Modern cellular units push to closed mobile/web galleries; email/FTP is not a
documented path. v1 therefore implements **photo dump** for both brands.
See each brand README for live vs TODO (OAuth / credentials).

## Test context (Tactacam)

Nick's personal Reveal cams **Kingstarnes1** / **KingStarnes2** are natural
account/camera names for a future auth/import step. Document only — **do not**
hardcode secrets or passwords in this tree.
