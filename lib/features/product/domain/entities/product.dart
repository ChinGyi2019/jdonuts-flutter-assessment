import '../../../../core/media/image_reference.dart';

final class Product {
  const Product({
    required this.id,
    required this.code,
    required this.name,
    required this.priceMmk,
    required this.description,
    required this.isNew,
    this.discountPercent,
    required this.image,
  });

  final String id;
  final String code;
  final String name;
  final int priceMmk;
  final String description;
  final bool isNew;
  final int? discountPercent;
  final ImageReference image;
}
