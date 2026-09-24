import '../../../../../core/errors.dart';
import '../../camera_adapter.dart';
import '../../camera_credentials.dart';
import '../../camera_event_draft.dart';
import '../../photo_dump_source.dart';

/// Tactacam v1 [CameraAdapter] — **photo-dump / filesystem import**.
///
/// No public official Tactacam API was found. Cloud OAuth and email/FTP are
/// stubbed as TODO; see `README.md` in this folder.
class TactacamAdapter implements CameraAdapter {
  TactacamAdapter({
    PhotoDumpSource? photoDumpSource,
  }) : _photoDumpSource =
            photoDumpSource ?? const FilesystemPhotoDumpSource();

  static const String brandIdValue = 'tactacam';

  /// Credential.extra key for the local dump / SD-card export folder.
  static const String photoDumpPathKey = 'photoDumpPath';

  /// Optional fixed camera id when the dump is for a single camera.
  static const String cameraIdKey = 'cameraId';

  final PhotoDumpSource _photoDumpSource;

  bool _connected = false;
  String? _photoDumpPath;
  String? _fixedCameraId;
  final Map<String, PhotoDumpEntry> _byRemoteId = {};

  @override
  String get brandId => brandIdValue;

  bool get isConnected => _connected;

  @override
  Future<void> connect(CameraCredentials creds) async {
    if (creds.brandId != brandIdValue) {
      throw CameraAdapterError(
        'TactacamAdapter expected brandId "$brandIdValue", got "${creds.brandId}"',
      );
    }

    final path = creds.extra[photoDumpPathKey]?.trim();
    if (path == null || path.isEmpty) {
      throw const CameraAdapterError(
        'Tactacam v1 requires extra["photoDumpPath"]. '
        'Cloud OAuth/API is TODO (no public official API documented).',
      );
    }

    _photoDumpPath = path;
    _fixedCameraId = creds.extra[cameraIdKey];
    _byRemoteId.clear();
    _connected = true;
  }

  @override
  Future<void> disconnect() async {
    _connected = false;
    _photoDumpPath = null;
    _fixedCameraId = null;
    _byRemoteId.clear();
  }

  @override
  Future<List<CameraEventDraft>> listEvents({
    DateTime? since,
    int? limit,
  }) async {
    _ensureConnected();
    final path = _photoDumpPath!;
    final entries = await _photoDumpSource.listEntries(path);
    _byRemoteId
      ..clear()
      ..addEntries(
        entries.map((e) => MapEntry(_remoteIdFor(e), e)),
      );

    var drafts = entries.map(_toDraft).toList()
      ..sort((a, b) => a.capturedAt.compareTo(b.capturedAt));

    if (since != null) {
      drafts = drafts.where((d) => !d.capturedAt.isBefore(since)).toList();
    }
    if (limit != null && limit >= 0 && drafts.length > limit) {
      drafts = drafts.sublist(0, limit);
    }
    return drafts;
  }

  @override
  Stream<CameraEventDraft> watchEvents({DateTime? since}) async* {
    final events = await listEvents(since: since);
    for (final event in events) {
      yield event;
    }
  }

  @override
  Future<Uri?> thumbUrl(String remoteId) async {
    _ensureConnected();
    final entry = _byRemoteId[remoteId];
    if (entry == null) return null;
    return Uri.file(entry.absolutePath);
  }

  @override
  Future<Uri?> clipUrl(String remoteId) async {
    _ensureConnected();
    final entry = _byRemoteId[remoteId];
    if (entry == null) return null;
    final lower = entry.fileName.toLowerCase();
    if (lower.endsWith('.mp4') || lower.endsWith('.mov')) {
      return Uri.file(entry.absolutePath);
    }
    return null;
  }

  void _ensureConnected() {
    if (!_connected || _photoDumpPath == null) {
      throw const CameraAdapterError('TactacamAdapter is not connected');
    }
  }

  CameraEventDraft _toDraft(PhotoDumpEntry entry) {
    final remoteId = _remoteIdFor(entry);
    final cameraId = _fixedCameraId ?? entry.cameraId;
    final capturedAt = _parseCapturedAt(entry) ??
        entry.modifiedAt ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

    return CameraEventDraft(
      remoteId: remoteId,
      brandId: brandIdValue,
      capturedAt: capturedAt,
      thumbRemoteId: remoteId,
      clipRemoteId: _isVideo(entry.fileName) ? remoteId : null,
      rawMeta: {
        'cameraId': cameraId,
        'fileName': entry.fileName,
        'absolutePath': entry.absolutePath,
        'importPath': 'photo_dump',
      },
    );
  }

  static String _remoteIdFor(PhotoDumpEntry entry) =>
      'tactacam-dump:${entry.absolutePath}';

  static bool _isVideo(String fileName) {
    final lower = fileName.toLowerCase();
    return lower.endsWith('.mp4') || lower.endsWith('.mov');
  }

  static DateTime? _parseCapturedAt(PhotoDumpEntry entry) {
    final match = RegExp(
      r'(\d{4})-(\d{2})-(\d{2})[@_T ](\d{2})[-:](\d{2})[-:](\d{2})',
    ).firstMatch(entry.fileName);
    if (match == null) return null;
    return DateTime.utc(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
      int.parse(match.group(4)!),
      int.parse(match.group(5)!),
      int.parse(match.group(6)!),
    );
  }
}
