final class RewardTier {
  const RewardTier({
    required this.id,
    required this.name,
    required this.minimumPoints,
  });

  final String id;
  final String name;
  final int minimumPoints;
}

final class TierProgress {
  const TierProgress({
    required this.current,
    required this.next,
    required this.points,
  });

  factory TierProgress.fromTiers(int points, List<RewardTier> tiers) {
    RewardTier? current;
    RewardTier? next;
    for (final tier in tiers) {
      if (tier.minimumPoints <= points) {
        current = tier;
      } else {
        next = tier;
        break;
      }
    }
    return TierProgress(current: current, next: next, points: points);
  }

  final RewardTier? current;
  final RewardTier? next;
  final int points;

  int? get pointsRemaining =>
      next == null ? null : next!.minimumPoints - points;

  double get fraction {
    if (next == null) return current == null ? 0 : 1;
    final lowerBound = current?.minimumPoints ?? 0;
    return ((points - lowerBound) / (next!.minimumPoints - lowerBound)).clamp(
      0.0,
      1.0,
    );
  }
}
