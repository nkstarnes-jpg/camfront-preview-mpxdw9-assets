/// Sanctuary-level trial overlay. Not a [Plan] enum value.
class Trial {
  const Trial({
    required this.startedAt,
    required this.endsAt,
    required this.active,
  });

  final DateTime startedAt;
  final DateTime endsAt;
  final bool active;

  Duration get remaining => endsAt.difference(DateTime.now());
}
