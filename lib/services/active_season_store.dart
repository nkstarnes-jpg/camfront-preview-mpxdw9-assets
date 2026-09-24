import 'package:flutter/foundation.dart';

import '../core/enums.dart';
import '../domain/models/season.dart';

/// Holds the hunter-set active [SeasonPhase] used when stamping new events/pins.
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
  ActiveSeason? _persisted;

  ActiveSeason get current => _current;
  SeasonPhase get phase => _current.phase;

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

  Future<void> save() async {
    _persisted = _current;
  }

  Future<void> load() async {
    final snap = _persisted;
    if (snap != null) {
      _current = snap;
      notifyListeners();
    }
  }

  void clearPersistedForTest() {
    _persisted = null;
  }
}
