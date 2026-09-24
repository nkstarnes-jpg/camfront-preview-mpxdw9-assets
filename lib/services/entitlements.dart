import '../core/enums.dart';

/// Hard-gate constants. **Single flip points** — do not scatter magic numbers.
///
/// [forecastDaysSanctuary] / [FORECAST_DAYS_SANCTUARY]: Nick is confirming the
/// final Sanctuary/trial forecast horizon. Default **16** until confirmed.
/// Change only this constant (and re-run tests) when Nick locks the number.
class EntitlementConstants {
  EntitlementConstants._();

  /// Scout plan forecast horizon (days).
  static const int forecastDaysScout = 1;

  /// Stand plan forecast horizon (days).
  static const int forecastDaysStand = 10;

  /// Sanctuary + active trial forecast horizon (days).
  /// HOLD — Nick confirming; this is the single flip point. Default 16.
  // ignore: constant_identifier_names — intentional alias for Range Safety / docs
  static const int FORECAST_DAYS_SANCTUARY = 16;

  /// Preferred Dart-style alias for [FORECAST_DAYS_SANCTUARY].
  static const int forecastDaysSanctuary = FORECAST_DAYS_SANCTUARY;

  /// Trial length granting Sanctuary-level access (days).
  static const int trialSanctuaryDays = 7;
}

/// Resolves hard gates for a [Plan] plus optional Sanctuary trial overlay.
class Entitlements {
  const Entitlements({
    required this.plan,
    this.trialActive = false,
  });

  final Plan plan;
  final bool trialActive;

  /// Effective tier for gates that treat trial like Sanctuary.
  bool get _sanctuaryTier =>
      trialActive || plan == Plan.sanctuary;

  bool get _standOrAbove =>
      _sanctuaryTier || plan == Plan.stand;

  /// Forecast days allowed. Scout=1, Stand=10, Sanctuary/trial = [forecastDaysSanctuary].
  int get forecastDays {
    if (_sanctuaryTier) return EntitlementConstants.forecastDaysSanctuary;
    if (plan == Plan.stand) return EntitlementConstants.forecastDaysStand;
    return EntitlementConstants.forecastDaysScout;
  }

  /// Sign pins (rubs, scrapes, etc.). Scout false; Stand+ and trial true.
  bool get signPins => _standOrAbove;

  /// Movement / weather correlation. Scout false; else true.
  bool get movementWeather => _standOrAbove;

  /// Public land layers — all plans.
  bool get publicLand => true;

  /// Private parcel polygons / owner data — **false for ALL plans including trial (v1)**.
  bool get parcelData => false;

  /// Advanced offline packs — trial / Sanctuary only.
  bool get offlineAdvanced => _sanctuaryTier;

  /// Multi-area / multi-property — trial / Sanctuary only.
  bool get multiArea => _sanctuaryTier;
}

/// Alias used in some docs / Range Safety notes.
typedef EntitlementGate = Entitlements;
