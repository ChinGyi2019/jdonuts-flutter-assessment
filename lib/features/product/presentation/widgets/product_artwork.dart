import 'package:flutter/material.dart';

import '../../../../core/media/catalog_image.dart';
import '../../../../core/media/image_reference.dart';
import '../../domain/entities/product.dart';

class ProductArtwork extends StatelessWidget {
  const ProductArtwork({
    required this.product,
    this.heroTag,
    this.isolated = false,
    super.key,
  });

  final Product product;
  final Object? heroTag;
  final bool isolated;

  @override
  Widget build(BuildContext context) {
    final detailAsset = isolated ? product.image.detailAsset : null;
    final image = CatalogImage(
      reference: detailAsset == null
          ? product.image
          : ImageReference(asset: detailAsset),
      semanticLabel: product.name,
      fit: isolated ? BoxFit.contain : BoxFit.cover,
    );
    final artwork = isolated && detailAsset == null
        ? ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (bounds) => const RadialGradient(
              colors: [Colors.white, Colors.white, Colors.transparent],
              stops: [0, .73, 1],
            ).createShader(bounds),
            child: image,
          )
        : detailAsset == null
        ? image
        : Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: image,
              ),
            ),
          );
    if (heroTag == null || MediaQuery.disableAnimationsOf(context)) {
      return artwork;
    }
    return Hero(tag: heroTag!, child: artwork);
  }
}

class ProductSelection {
  const ProductSelection({required this.product, required this.heroTag});

  final Product product;
  final Object heroTag;
}
