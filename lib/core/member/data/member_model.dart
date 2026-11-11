import '../../media/image_reference.dart';
import '../domain/member.dart';

final class MemberModel {
  const MemberModel({
    required this.id,
    required this.firstName,
    this.lastName,
    this.phone,
    this.birthDate,
    required this.points,
    required this.notificationCount,
    required this.rewardsBadgeCount,
    required this.imageAsset,
    this.imageUrl,
  });

  factory MemberModel.fromJson(Map<String, Object?> json) => MemberModel(
    id: json['id'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String?,
    phone: json['phone'] as String?,
    birthDate: json['birthDate'] as String?,
    points: json['points'] as int,
    notificationCount: json['notificationCount'] as int,
    rewardsBadgeCount: json['rewardsBadgeCount'] as int,
    imageAsset: json['imageAsset'] as String,
    imageUrl: json['imageUrl'] as String?,
  );

  factory MemberModel.fromEntity(Member member) => MemberModel(
    id: member.id,
    firstName: member.firstName,
    lastName: member.lastName,
    phone: member.phone,
    birthDate: member.birthDate?.toIso8601String().split('T').first,
    points: member.points,
    notificationCount: member.notificationCount,
    rewardsBadgeCount: member.rewardsBadgeCount,
    imageAsset: member.image.asset,
    imageUrl: member.image.url,
  );

  final String id;
  final String firstName;
  final String? lastName;
  final String? phone;
  final String? birthDate;
  final int points;
  final int notificationCount;
  final int rewardsBadgeCount;
  final String imageAsset;
  final String? imageUrl;

  Member toEntity() => Member(
    id: id,
    firstName: firstName,
    lastName: lastName,
    phone: phone,
    birthDate: birthDate == null ? null : DateTime.parse(birthDate!),
    points: points,
    notificationCount: notificationCount,
    rewardsBadgeCount: rewardsBadgeCount,
    image: ImageReference(asset: imageAsset, url: imageUrl),
  );
}
