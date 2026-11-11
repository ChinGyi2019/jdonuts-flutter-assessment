import '../../../../core/media/image_reference.dart';
import '../../domain/entities/product.dart';

final class ProductModel {
  const ProductModel({
    required this.id,
    required this.code,
    required this.name,
    required this.priceMmk,
    required this.description,
    required this.isNew,
    this.discountPercent,
    required this.imageAsset,
    this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, Object?> json) => ProductModel(
    id: json['id'] as String,
    code: json['code'] as String,
    name: json['name'] as String,
    priceMmk: json['priceMmk'] as int,
    description: json['description'] as String,
    isNew: json['isNew'] as bool,
    discountPercent: json['discountPercent'] as int?,
    imageAsset: json['imageAsset'] as String,
    imageUrl: json['imageUrl'] as String?,
  );

  factory ProductModel.fromEntity(Product product) => ProductModel(
    id: product.id,
    code: product.code,
    name: product.name,
    priceMmk: product.priceMmk,
    description: product.description,
    isNew: product.isNew,
    discountPercent: product.discountPercent,
    imageAsset: product.image.asset,
    imageUrl: product.image.url,
  );

  final String id;
  final String code;
  final String name;
  final int priceMmk;
  final String description;
  final bool isNew;
  final int? discountPercent;
  final String imageAsset;
  final String? imageUrl;

  Product toEntity() => Product(
    id: id,
    code: code,
    name: name,
    priceMmk: priceMmk,
    description: description,
    isNew: isNew,
    discountPercent: discountPercent,
    image: ImageReference(
      asset: imageAsset,
      url: imageUrl,
      detailAsset: _detailArtwork[imageAsset],
    ),
  );
}

// Seasonal photographs use a clean, rounded crop on the detail screen.
const _detailArtwork = {
  'assets/images/assorted-box.webp': 'assets/images/assorted-box.webp',
  'assets/images/festive-box.webp': 'assets/images/festive-box.webp',
};
