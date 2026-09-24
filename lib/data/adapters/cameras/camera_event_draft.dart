/// Draft event from a [CameraAdapter] before domain persistence / season stamp.
class CameraEventDraft {
  const CameraEventDraft({
    required this.remoteId,
    required this.brandId,
    required this.capturedAt,
    this.latitude,
    this.longitude,
    this.thumbRemoteId,
    this.clipRemoteId,
    this.rawMeta = const {},
  });

  final String remoteId;
  final String brandId;
  final DateTime capturedAt;
  final double? latitude;
  final double? longitude;
  final String? thumbRemoteId;
  final String? clipRemoteId;
  final Map<String, Object?> rawMeta;
}
