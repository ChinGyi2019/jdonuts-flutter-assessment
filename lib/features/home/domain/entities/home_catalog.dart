import '../../../../core/media/image_reference.dart';

enum HomeSection { seasonalSpecials, popular, orderAgain }

final class HomeBanner {
  const HomeBanner({
    required this.id,
    required this.title,
    required this.badge,
    required this.position,
    required this.image,
  });

  final String id;
  final String title;
  final String badge;
  final int position;
  final ImageReference image;
}

final class Shop {
  const Shop({
    required this.id,
    required this.name,
    required this.address,
    required this.position,
    required this.image,
  });

  final String id;
  final String name;
  final String address;
  final int position;
  final ImageReference image;
}
