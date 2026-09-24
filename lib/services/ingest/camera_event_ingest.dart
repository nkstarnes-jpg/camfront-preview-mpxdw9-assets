import '../../data/adapters/cameras/camera_event_draft.dart';
import '../../domain/models/camera_event.dart';
import '../active_season_store.dart';

/// Accepts [CameraEventDraft]s and stamps [CameraEvent.seasonPhase] from the
/// hunter-set active season at create time. Does not re-stamp on later syncs.
class CameraEventIngestService {
  CameraEventIngestService(this._seasonStore);

  final ActiveSeasonStore _seasonStore;

  /// Creates a domain [CameraEvent], stamping [seasonPhase] from [ActiveSeasonStore].
  CameraEvent fromDraft(
    CameraEventDraft draft, {
    required String id,
    String? cameraId,
    String detectionType = 'detection',
    Uri? thumbUri,
    Uri? clipUri,
  }) {
    return CameraEvent(
      id: id,
      remoteId: draft.remoteId,
      brandId: draft.brandId,
      cameraId: cameraId,
      detectionType: detectionType,
      capturedAt: draft.capturedAt,
      seasonPhase: _seasonStore.phase,
      latitude: draft.latitude,
      longitude: draft.longitude,
      thumbUri: thumbUri,
      clipUri: clipUri,
    );
  }
}
