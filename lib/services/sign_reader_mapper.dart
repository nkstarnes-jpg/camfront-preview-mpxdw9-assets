import '../domain/models/camera_event.dart';
import '../domain/models/pin.dart';
import '../domain/models/sign_reader_export.dart';

/// Maps domain records to entitlement-safe [SignReaderExport] rows.
///
/// Exposes **only**: geo, type, timestamp, season_phase, camera_id.
/// Does not attach weather — Scout must never receive movement_weather joins
/// (see [MovementWeatherJoin]).
class SignReaderMapper {
  const SignReaderMapper();

  /// How to get export from a [CameraEvent]:
  /// `const SignReaderMapper().fromCameraEvent(event)`.
  SignReaderExport fromCameraEvent(CameraEvent event) {
    return SignReaderExport(
      latitude: event.latitude,
      longitude: event.longitude,
      type: event.detectionType,
      timestamp: event.capturedAt,
      seasonPhase: event.seasonPhase,
      cameraId: event.cameraId,
    );
  }

  /// Pins export with [SignReaderExport.cameraId] null.
  /// [PinType.pinchPoint] / [PinType.funnel] stay hunter labels in `type`.
  SignReaderExport fromPin(Pin pin) {
    return SignReaderExport(
      latitude: pin.latitude,
      longitude: pin.longitude,
      type: pin.type.exportName,
      timestamp: pin.createdAt,
      seasonPhase: pin.seasonPhase,
      cameraId: null,
    );
  }

  List<SignReaderExport> fromCameraEvents(Iterable<CameraEvent> events) =>
      events.map(fromCameraEvent).toList(growable: false);

  List<SignReaderExport> fromPins(Iterable<Pin> pins) =>
      pins.map(fromPin).toList(growable: false);
}
