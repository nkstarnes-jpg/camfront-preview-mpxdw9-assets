import 'package:flutter/foundation.dart';

import '../core/enums.dart';
import '../domain/models/season.dart';

/// Holds the hunter-set active [SeasonPhase] used when stamping new events/pins.
///
/// In-memory with a simple persistence placeholder ([load] / [save]). Swap the
/// placeholder for local storage later without changing ingest callers.
///
/// Extends [ChangeNotifier] so Map / Cameras shells rebuild when the hunter
/// saves a new season phase.
class ActiveSeasonStore extends ChangeNotifier {
  ActiveSeasonStore({
    SeasonPhase initialPhase = SeasonPhase.earlySeason,
    String? initialLabel,
  }) : _current = ActiveSeason(
          phase: initialPhase,
          label: initialLabel,
          updatedAt: DateTime.now().toUtc(),
        );

  ActiveSeason _current;

  /// Last value written by [save] — persistence placeholder only.
  ActiveSeason? _persisted;

  ActiveSeason get current => _current;

  SeasonPhase get phase => _current.phase;

  /// Hunter sets the active season (not inferred from cameras/pins).
  void setPhase(SeasonPhase phase, {String? label, DateTime? updatedAt}) {
    _current = ActiveSeason(
      phase: phase,
      label: label ?? _current.label,
      updatedAt: updatedAt ?? DateTime.now().toUtc(),
    );
    notifyListeners();
  }

  void setActiveSeason(ActiveSeason season) {
    _current = season;
    notifyListeners();
  }

  /// Persistence placeholder: remember current season in memory.
  Future<void> save() async {
    _persisted = _current;
  }

  /// Persistence placeholder: restore last [save], or no-op if never saved.
  Future<void> load() async {
    final snap = _persisted;
    if (snap != null) {
      _current = snap;
      notifyListeners();
    }
  }

  /// Test / DI helper — clears persistence placeholder without changing current.
  void clearPersistedForTest() {
    _persisted = null;
  }
}
