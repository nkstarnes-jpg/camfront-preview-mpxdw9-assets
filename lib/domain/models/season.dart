import '../../core/enums.dart';

/// Hunter-configured active season.
///
/// **Stamping rule:** when a new [CameraEvent] or [Pin] is created, copy
/// `seasonPhase` from the hunter-set active season at create time. Do not
/// recompute from date or camera metadata later for historical records.
class ActiveSeason {
  const ActiveSeason({
    required this.phase,
    this.label,
    this.updatedAt,
  });

  final SeasonPhase phase;
  final String? label;
  final DateTime? updatedAt;
}
