import '../../core/enums.dart';
import '../../domain/models/pin.dart';
import '../active_season_store.dart';

/// Creates [Pin]s with [Pin.seasonPhase] stamped from the hunter-set active
/// season at create time. Do not infer rut phase from the pin itself.
class PinIngestService {
  PinIngestService(this._seasonStore);

  final ActiveSeasonStore _seasonStore;

  Pin create({
    required String id,
    required PinType type,
    required double latitude,
    required double longitude,
    DateTime? createdAt,
    String? note,
  }) {
    return Pin(
      id: id,
      type: type,
      latitude: latitude,
      longitude: longitude,
      seasonPhase: _seasonStore.phase,
      createdAt: createdAt ?? DateTime.now().toUtc(),
      note: note,
    );
  }
}
