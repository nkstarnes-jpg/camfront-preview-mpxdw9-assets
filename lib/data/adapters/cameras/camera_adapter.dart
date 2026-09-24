import 'camera_credentials.dart';
import 'camera_event_draft.dart';

/// Brand-agnostic trail camera integration surface.
///
/// Implement per brand under `brands/` (v1: moultrie + tactacam).
/// Prefer official API > email/FTP > photo dump.
abstract class CameraAdapter {
  String get brandId;

  Future<void> connect(CameraCredentials creds);

  Stream<CameraEventDraft> watchEvents({DateTime? since});

  Future<List<CameraEventDraft>> listEvents({DateTime? since, int? limit});

  Future<Uri?> thumbUrl(String remoteId);

  Future<Uri?> clipUrl(String remoteId);

  Future<void> disconnect();
}
