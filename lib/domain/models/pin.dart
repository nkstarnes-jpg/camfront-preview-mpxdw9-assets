import '../../core/enums.dart';

/// Map pin placed by the hunter.
///
/// [seasonPhase] is stamped from the hunter-set active season at create time
/// (see [ActiveSeason] docs). Do not infer rut phase from the pin itself.
class Pin {
  const Pin({
    required this.id,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.seasonPhase,
    required this.createdAt,
    this.note,
  });

  final String id;
  final PinType type;
  final double latitude;
  final double longitude;

  /// Stamped from hunter-set active_season at create time.
  final SeasonPhase seasonPhase;
  final DateTime createdAt;
  final String? note;
}
