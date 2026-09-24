# Tactacam camera adapter (v1)

**Brand id:** `tactacam`

Covers Tactacam **REVEAL** cellular trail cameras (app: Tactacam REVEAL;
web portal historically at `account.revealcellcam.com`).

## Research summary (2026-09)

| Path | Status | Notes |
|------|--------|-------|
| Official public developer API | **None found** | Gallery, HD requests, settings are REVEAL-app / account portal only. No third-party SDK docs. |
| REVEAL cloud / app | Account-gated | Thumbnails push over cellular; HD on request. Users can download media to the phone photo library from the app. |
| Email / FTP push | **Not documented** | No email-to-gallery or FTP drop for REVEAL cellular units. |
| SD card / photo dump / filesystem import | **Available** | Optional Class 10 U3 SD card stores originals; pull card or save downloads from the REVEAL app to a folder Camfront can import. |

**Preference:** official API → email/FTP → photo dump.  
No public API / email-FTP → **v1 = photo dump**.

## Import path chosen: photo dump

Same shape as Moultrie: local folder via `extra['photoDumpPath']`.

### Live vs TODO

| Capability | Status |
|------------|--------|
| `brandId == tactacam` | **Live** |
| connect / disconnect with photo-dump path | **Live** |
| listEvents / watchEvents from dump | **Live** |
| thumbUrl / clipUrl as `file://` | **Live** for dump entries |
| REVEAL account OAuth / token | **TODO** — needs Nick credentials + Range Safety |
| Email/FTP ingest | **TODO** if Tactacam documents it |
| Unofficial API reverse-engineering | **Out of scope** |

## Test context (no secrets)

Nick’s personal Reveal cams **Kingstarnes1** and **KingStarnes2** are natural
test account / camera labels when auth or cloud import is ready. Use them only
as human-facing test context in docs or fixture folder names — **never** store
passwords, tokens, or plan credentials in source.

Example future credential shape (still photo-dump until OAuth lands):

```dart
CameraCredentials(
  brandId: 'tactacam',
  username: null, // e.g. REVEAL account email — supplied at runtime
  token: null,
  extra: {
    'photoDumpPath': '/path/to/reveal-export',
    'cameraId': 'Kingstarnes1', // optional label for a single-cam dump
  },
);
```
