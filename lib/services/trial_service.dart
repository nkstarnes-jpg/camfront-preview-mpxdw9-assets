import 'entitlements.dart';

/// Trial overlay helpers. Trial grants Sanctuary-level gates for
/// [EntitlementConstants.trialSanctuaryDays] days. No trial-reset UX.
class TrialService {
  const TrialService();

  int get trialLengthDays => EntitlementConstants.trialSanctuaryDays;

  /// Whether [now] falls within an active trial window.
  bool isActive({required DateTime startedAt, required DateTime now}) {
    final ends = startedAt.add(Duration(days: trialLengthDays));
    return !now.isBefore(startedAt) && now.isBefore(ends);
  }
}
