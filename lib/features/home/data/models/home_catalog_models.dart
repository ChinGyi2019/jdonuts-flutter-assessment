import '../../../../core/media/image_reference.dart';
import '../../domain/entities/home_catalog.dart';

final class BannerModel {
  const BannerModel({
    required this.id,
    required this.title,
    required this.badge,
    required this.position,
    required this.imageAsset,
    this.imageUrl,
  });

  factory BannerModel.fromJson(Map<String, Object?> json) => BannerModel(
    id: json['id'] as String,
    title: json['title'] as String,
    badge: json['badge'] as String,
    position: json['position'] as int,
    imageAsset: json['imageAsset'] as String,
    imageUrl: json['imageUrl'] as String?,
  );

  factory BannerModel.fromEntity(HomeBanner banner) => BannerModel(
    id: banner.id,
    title: banner.title,
    badge: banner.badge,
    position: banner.position,
    imageAsset: banner.image.asset,
    imageUrl: banner.image.url,
  );

  final String id;
  final String title;
  final String badge;
  final int position;
  final String imageAsset;
  final String? imageUrl;

  HomeBanner toEntity() => HomeBanner(
    id: id,
    title: title,
    badge: badge,
    position: position,
    image: ImageReference(asset: imageAsset, url: imageUrl),
  );
}

final class ShopModel {
  const ShopModel({
    required this.id,
    required this.name,
    required this.address,
    required this.position,
    required this.imageAsset,
    this.imageUrl,
  });

  factory ShopModel.fromJson(Map<String, Object?> json) => ShopModel(
    id: json['id'] as String,
    name: json['name'] as String,
    address: json['address'] as String,
    position: json['position'] as int,
    imageAsset: json['imageAsset'] as String,
    imageUrl: json['imageUrl'] as String?,
  );

  factory ShopModel.fromEntity(Shop shop) => ShopModel(
    id: shop.id,
    name: shop.name,
    address: shop.address,
    position: shop.position,
    imageAsset: shop.image.asset,
    imageUrl: shop.image.url,
  );

  final String id;
  final String name;
  final String address;
  final int position;
  final String imageAsset;
  final String? imageUrl;

  Shop toEntity() => Shop(
    id: id,
    name: name,
    address: address,
    position: position,
    image: ImageReference(asset: imageAsset, url: imageUrl),
  );
}

final class SectionProductModel {
  const SectionProductModel({
    required this.section,
    required this.productId,
    required this.position,
  });

  factory SectionProductModel.fromJson(Map<String, Object?> json) =>
      SectionProductModel(
        section: HomeSection.values.byName(json['section'] as String),
        productId: json['productId'] as String,
        position: json['position'] as int,
      );

  final HomeSection section;
  final String productId;
  final int position;
}
