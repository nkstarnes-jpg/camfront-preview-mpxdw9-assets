import '../../core/enums.dart';

/// Entitlement-safe Sign Reader export row.
///
/// **Fields only:** geo (lat/lng), type, timestamp, season_phase, camera_id.
/// Callers must not join weather for Scout — use [MovementWeatherJoin], which
/// returns null / throws [EntitlementDeniedError] when movement weather is off.
class SignReaderExport {
  const SignReaderExport({
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.timestamp,
    required this.seasonPhase,
    this.cameraId,
  });

  final double? latitude;
  final double? longitude;

  /// Detection type (camera) or pin type export name.
  final String type;
  final DateTime timestamp;
  final SeasonPhase seasonPhase;

  /// Nullable for pins (no camera).
  final String? cameraId;

  /// Wire shape for Sign Reader — only the allowed fields.
  Map<String, Object?> toExportMap() {
    return <String, Object?>{
      'geo': <String, Object?>{
        'lat': latitude,
        'lng': longitude,
      },
      'type': type,
      'timestamp': timestamp.toUtc().toIso8601String(),
      'season_phase': seasonPhase.exportName,
      'camera_id': cameraId,
    };
  }
}
