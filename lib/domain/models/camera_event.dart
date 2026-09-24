import '../../core/enums.dart';

/// Persisted / domain camera event (after adapter draft is accepted).
///
/// [seasonPhase] is stamped from the hunter-set active season at create time
/// (see [ActiveSeason] docs). Do not re-stamp on sync updates.
class CameraEvent {
  const CameraEvent({
    required this.id,
    required this.remoteId,
    required this.brandId,
    required this.capturedAt,
    required this.seasonPhase,
    this.cameraId,
    this.detectionType = 'detection',
    this.latitude,
    this.longitude,
    this.thumbUri,
    this.clipUri,
  });

  final String id;
  final String remoteId;
  final String brandId;

  /// Physical camera identity when known (Sign Reader `camera_id`).
  final String? cameraId;

  /// Detection / event type label for Sign Reader `type` (not ML class yet).
  final String detectionType;
  final DateTime capturedAt;

  /// Stamped from hunter-set active_season at create time.
  final SeasonPhase seasonPhase;
  final double? latitude;
  final double? longitude;
  final Uri? thumbUri;
  final Uri? clipUri;
}
