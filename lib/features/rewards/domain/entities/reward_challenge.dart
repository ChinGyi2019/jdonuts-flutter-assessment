import '../../../../core/media/image_reference.dart';

enum ChallengeArtwork { donut, coffee }

final class RewardChallenge {
  const RewardChallenge({
    required this.id,
    required this.title,
    required this.artwork,
    required this.completedQuantity,
    required this.targetQuantity,
    required this.rewardPoints,
    required this.position,
    required this.image,
  });

  final String id;
  final String title;
  final ChallengeArtwork artwork;
  final int completedQuantity;
  final int targetQuantity;
  final int rewardPoints;
  final int position;
  final ImageReference image;

  bool get isComplete => completedQuantity >= targetQuantity;
  double get progress => (completedQuantity / targetQuantity).clamp(0.0, 1.0);
}
