import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'image_reference.dart';

class CatalogImage extends StatelessWidget {
  const CatalogImage({
    required this.reference,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.semanticLabel,
    super.key,
  });

  final ImageReference reference;
  final BoxFit fit;
  final Alignment alignment;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final url = reference.url;
    final image = url == null || url.isEmpty
        ? _asset()
        : CachedNetworkImage(
            imageUrl: url,
            fit: fit,
            alignment: alignment,
            placeholder: (_, _) => _asset(),
            errorWidget: (_, _, _) => _asset(),
          );
    return Semantics(
      image: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: image,
    );
  }

  Widget _asset() => Image.asset(
    reference.asset,
    fit: fit,
    alignment: alignment,
    excludeFromSemantics: true,
    errorBuilder: (_, _, _) => const Center(child: Icon(LucideIcons.imageOff)),
  );
}
