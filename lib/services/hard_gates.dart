import '../core/enums.dart';
import 'entitlements.dart';

/// Convenience hard-gate checks used by features before unlocking UI.
class HardGates {
  const HardGates(this.entitlements);

  final Entitlements entitlements;

  bool get canUseSignPins => entitlements.signPins;
  bool get canUseMovementWeather => entitlements.movementWeather;
  bool get canUsePublicLand => entitlements.publicLand;
  bool get canUseParcelData => entitlements.parcelData;
  bool get canUseOfflineAdvanced => entitlements.offlineAdvanced;
  bool get canUseMultiArea => entitlements.multiArea;
  int get forecastDays => entitlements.forecastDays;

  /// Night Watch P0 / pin edit gate.
  ///
  /// Scout (and post-trial Scout) may only edit **blind** | **stand**.
  /// Sign types (tracks, rub, scrape, pinch_point, funnel, …) require
  /// Stand, Sanctuary, or an active Sanctuary trial.
  bool canEditPinType(PinType type) =>
      HardGates.canEditPinTypeFor(
        plan: entitlements.plan,
        trialActive: entitlements.trialActive,
        type: type,
      );

  /// Static form matching Range Safety: `canEditPinType(plan, trialActive, type)`.
  static bool canEditPinTypeFor({
    required Plan plan,
    required bool trialActive,
    required PinType type,
  }) {
    if (type.isStructurePin) return true;
    return Entitlements(plan: plan, trialActive: trialActive).signPins;
  }
}

/// Top-level alias for docs / call sites that want the free function shape.
bool canEditPinType(Plan plan, bool trialActive, PinType type) =>
    HardGates.canEditPinTypeFor(
      plan: plan,
      trialActive: trialActive,
      type: type,
    );
