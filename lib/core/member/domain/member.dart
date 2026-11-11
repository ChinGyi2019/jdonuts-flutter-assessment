import '../../media/image_reference.dart';

final class Member {
  const Member({
    required this.id,
    required this.firstName,
    this.lastName,
    this.phone,
    this.birthDate,
    required this.points,
    required this.notificationCount,
    required this.rewardsBadgeCount,
    required this.image,
  });

  final String id;
  final String firstName;
  final String? lastName;
  final String? phone;
  final DateTime? birthDate;
  final int points;
  final int notificationCount;
  final int rewardsBadgeCount;
  final ImageReference image;

  String get displayName => [firstName, ?lastName].join(' ');
}

/// A normalized phone number and validated profile supplied by registration.
final class MemberRegistration {
  const MemberRegistration({
    required this.phone,
    required this.firstName,
    this.lastName,
    required this.birthDate,
  });

  final String phone;
  final String firstName;
  final String? lastName;
  final DateTime birthDate;
}
