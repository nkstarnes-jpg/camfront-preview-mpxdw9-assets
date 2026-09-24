import '../core/errors.dart';
import '../domain/models/camera_event.dart';
import '../domain/models/weather.dart';
import 'entitlements.dart';

/// Joined movement + weather payload (Stand / Sanctuary / trial only).
class MovementWeatherJoined {
  const MovementWeatherJoined({
    required this.event,
    required this.weather,
  });

  final CameraEvent event;
  final WeatherSnapshot weather;
}

/// Hard gate: Scout NEVER gets movement_weather joins.
///
/// - [tryJoin] → `null` when [Entitlements.movementWeather] is false
/// - [join] → throws [EntitlementDeniedError] for Scout / denied plans
class MovementWeatherJoin {
  const MovementWeatherJoin(this.entitlements);

  final Entitlements entitlements;

  /// Returns null for Scout (and any plan without movement weather).
  MovementWeatherJoined? tryJoin({
    required CameraEvent event,
    required WeatherSnapshot weather,
  }) {
    if (!entitlements.movementWeather) return null;
    return MovementWeatherJoined(event: event, weather: weather);
  }

  /// Throws [EntitlementDeniedError] when movement weather is not entitled.
  MovementWeatherJoined join({
    required CameraEvent event,
    required WeatherSnapshot weather,
  }) {
    if (!entitlements.movementWeather) {
      throw const EntitlementDeniedError('movement_weather');
    }
    return MovementWeatherJoined(event: event, weather: weather);
  }
}
