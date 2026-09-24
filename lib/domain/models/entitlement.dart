import '../../core/enums.dart';

/// Snapshot of what the user is entitled to (plan + optional trial overlay).
class EntitlementState {
  const EntitlementState({
    required this.plan,
    required this.trialActive,
    this.trialEndsAt,
  });

  final Plan plan;
  final bool trialActive;
  final DateTime? trialEndsAt;
}
