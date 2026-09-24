# Moultrie camera adapter (v1)

**Brand id:** `moultrie`

## Research summary (2026-09)

| Path | Status | Notes |
|------|--------|-------|
| Official public developer API | **None found** | Photos land in Moultrie App / `app.moultriemobile.com`. No documented OAuth/SDK for third parties. |
| Moultrie Mobile / Mobile AI cloud | Account-gated UI only | Cellular EDGE/AI cams upload to Moultrie cloud. Community scrapers exist — **not** used here. |
| Email / FTP push | **Not documented** for modern Mobile cellular units | |
| SD card / photo dump / filesystem import | **Available** | SD cards (older units) or user-exported gallery folders. Moultrie web “Import Images” expects local files — same shape. |

**Preference:** official API → email/FTP → photo dump.  
No public API / email-FTP → **v1 = photo dump**.

## Import path chosen: photo dump

`MoultrieAdapter` reads media from a local directory at connect time:

- `CameraCredentials.extra['photoDumpPath']` — dump / SD export folder
- Optional `extra['cameraId']` — fixed camera id; else subdirectory names → `rawMeta['cameraId']`
- Extensions: `.jpg`, `.jpeg`, `.png`, `.mp4`, `.mov`
- Timestamps: `YYYY-MM-DD@HH-MM-SS` filename pattern, else mtime

### Live vs TODO

| Capability | Status |
|------------|--------|
| `brandId == moultrie` | **Live** |
| connect / disconnect with photo-dump path | **Live** |
| listEvents / watchEvents from dump | **Live** |
| thumbUrl / clipUrl as `file://` | **Live** for dump entries |
| Moultrie Mobile OAuth / account token | **TODO** — Nick credentials + Range Safety; no official API yet |
| Email/FTP ingest | **TODO** placeholder if docs appear |
| Cloud gallery scrape | **Out of scope** |

## Credentials (no secrets in code)

```dart
CameraCredentials(
  brandId: 'moultrie',
  username: null, // future account email
  token: null,    // future OAuth/session
  extra: {
    'photoDumpPath': '/path/to/export-or-sdcard',
    'cameraId': 'optional-fixed-camera-id',
  },
);
```

Select via `CameraAdapterRegistry` — never hardcode account secrets.
