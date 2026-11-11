import '../../../../core/media/image_reference.dart';
import '../../domain/entities/reward_challenge.dart';
import '../../domain/entities/reward_tier.dart';

final class TierModel {
  const TierModel({
    required this.id,
    required this.name,
    required this.minimumPoints,
  });

  factory TierModel.fromJson(Map<String, Object?> json) => TierModel(
    id: json['id'] as String,
    name: json['name'] as String,
    minimumPoints: json['minimumPoints'] as int,
  );

  factory TierModel.fromEntity(RewardTier tier) => TierModel(
    id: tier.id,
    name: tier.name,
    minimumPoints: tier.minimumPoints,
  );

  final String id;
  final String name;
  final int minimumPoints;

  RewardTier toEntity() =>
      RewardTier(id: id, name: name, minimumPoints: minimumPoints);
}

final class ChallengeModel {
  const ChallengeModel({
    required this.id,
    required this.title,
    required this.artwork,
    required this.completedQuantity,
    required this.targetQuantity,
    required this.rewardPoints,
    required this.position,
    required this.imageAsset,
    this.imageUrl,
  });

  factory ChallengeModel.fromJson(Map<String, Object?> json) => ChallengeModel(
    id: json['id'] as String,
    title: json['title'] as String,
    artwork: ChallengeArtwork.values.byName(json['artwork'] as String),
    completedQuantity: json['completedQuantity'] as int,
    targetQuantity: json['targetQuantity'] as int,
    rewardPoints: json['rewardPoints'] as int,
    position: json['position'] as int,
    imageAsset: json['imageAsset'] as String,
    imageUrl: json['imageUrl'] as String?,
  );

  factory ChallengeModel.fromEntity(RewardChallenge challenge) =>
      ChallengeModel(
        id: challenge.id,
        title: challenge.title,
        artwork: challenge.artwork,
        completedQuantity: challenge.completedQuantity,
        targetQuantity: challenge.targetQuantity,
        rewardPoints: challenge.rewardPoints,
        position: challenge.position,
        imageAsset: challenge.image.asset,
        imageUrl: challenge.image.url,
      );

  final String id;
  final String title;
  final ChallengeArtwork artwork;
  final int completedQuantity;
  final int targetQuantity;
  final int rewardPoints;
  final int position;
  final String imageAsset;
  final String? imageUrl;

  RewardChallenge toEntity() => RewardChallenge(
    id: id,
    title: title,
    artwork: artwork,
    completedQuantity: completedQuantity,
    targetQuantity: targetQuantity,
    rewardPoints: rewardPoints,
    position: position,
    image: ImageReference(asset: imageAsset, url: imageUrl),
  );
}
