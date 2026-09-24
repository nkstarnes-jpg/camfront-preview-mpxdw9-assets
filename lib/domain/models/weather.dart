/// Lightweight weather / forecast stub for entitlement gating later.
class WeatherSnapshot {
  const WeatherSnapshot({
    required this.observedAt,
    this.temperatureF,
    this.windMph,
    this.conditions,
  });

  final DateTime observedAt;
  final double? temperatureF;
  final double? windMph;
  final String? conditions;
}

class ForecastDay {
  const ForecastDay({
    required this.date,
    this.highF,
    this.lowF,
    this.conditions,
  });

  final DateTime date;
  final double? highF;
  final double? lowF;
  final String? conditions;
}
