import '../core/enums.dart';

/// Hard-gate constants. **Single flip points** — do not scatter magic numbers.
class EntitlementConstants {
  EntitlementConstants._();

  static const int forecastDaysScout = 1;
  static const int forecastDaysStand = 10;
  // ignore: constant_identifier_names
  static const int FORECAST_DAYS_SANCTUARY = 16;
  static const int forecastDaysSanctuary = FORECAST_DAYS_SANCTUARY;
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

  bool get _sanctuaryTier =>
      trialActive || plan == Plan.sanctuary;

  bool get _standOrAbove =>
      _sanctuaryTier || plan == Plan.stand;

  int get forecastDays {
    if (_sanctuaryTier) return EntitlementConstants.forecastDaysSanctuary;
    if (plan == Plan.stand) return EntitlementConstants.forecastDaysStand;
    return EntitlementConstants.forecastDaysScout;
  }

  bool get signPins => _standOrAbove;
  bool get movementWeather => _standOrAbove;
  bool get publicLand => true;
  bool get parcelData => false;
  bool get offlineAdvanced => _sanctuaryTier;
  bool get multiArea => _sanctuaryTier;
}

typedef EntitlementGate = Entitlements;
