import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/product.dart';
import 'product_artwork.dart';
import 'product_purchase_bar.dart';
import 'product_quantity.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    required this.product,
    required this.onAddToCart,
    this.heroTag,
    super.key,
  });

  final Product product;
  final void Function(Product, int, GlobalKey) onAddToCart;
  final Object? heroTag;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _quantity = ProductQuantity.minimum;
  final _artworkKey = GlobalKey();

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 9, 24, 12),
          child: Column(
            children: [
              _productPanel(context),
              const SizedBox(height: 38),
              _Description(widget.product.description),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 25),
        child: ProductPurchaseBar(
          total: _price(context, _quantity * widget.product.priceMmk),
          onAdd: () =>
              widget.onAddToCart(widget.product, _quantity, _artworkKey),
        ),
      ),
    ],
  );

  Widget _productPanel(BuildContext context) => Stack(
    alignment: Alignment.bottomCenter,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 34),
        child: _ProductCard(
          product: widget.product,
          price: _price(context, widget.product.priceMmk),
          heroTag: widget.heroTag,
          artworkKey: _artworkKey,
        ),
      ),
      ProductQuantity(
        quantity: _quantity,
        onChange: (value) => setState(() => _quantity = value),
      ),
    ],
  );

  String _price(BuildContext context, int amount) {
    final strings = AppLocalizations.of(context)!;
    return strings.priceMmk(
      NumberFormat.decimalPattern(strings.localeName).format(amount),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.price,
    required this.artworkKey,
    this.heroTag,
  });

  final Product product;
  final String price;
  final GlobalKey artworkKey;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(17, 16, 17, 38),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _code(context),
        Text(
          product.name,
          style: const TextStyle(
            color: Color(0xFF181A1C),
            fontSize: 31,
            height: 1.1,
            fontWeight: FontWeight.w800,
            letterSpacing: -.65,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          price,
          style: const TextStyle(
            color: AppColors.catalogText,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (_, constraints) => SizedBox(
            key: artworkKey,
            height: (constraints.maxWidth * .86).clamp(142.0, 285.0),
            width: double.infinity,
            child: ProductArtwork(
              product: product,
              heroTag: heroTag,
              isolated: true,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _code(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          product.code,
          style: const TextStyle(color: AppColors.catalogMuted),
        ),
      ),
      Flexible(
        child: Wrap(
          alignment: WrapAlignment.end,
          spacing: 6,
          runSpacing: 4,
          children: [
            if (product.isNew) _badge(AppLocalizations.of(context)!.newProduct),
            if (product.discountPercent case final percent?)
              _badge(AppLocalizations.of(context)!.discountBadge(percent)),
          ],
        ),
      ),
    ],
  );

  Widget _badge(String label) => DecoratedBox(
    decoration: BoxDecoration(
      color: AppColors.catalogOrange,
      borderRadius: BorderRadius.circular(9),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}

class _Description extends StatelessWidget {
  const _Description(this.description);

  final String description;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.textScalerOf(context).scale(72),
          child: _heading(
            AppLocalizations.of(context)!.productDescriptionTitle,
          ),
        ),
        const VerticalDivider(width: 14, thickness: 1.5, color: Colors.white),
        Expanded(
          child: Text(
            description,
            style: const TextStyle(
              color: AppColors.catalogMuted,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _heading(String title) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const CircleAvatar(
        radius: 9,
        backgroundColor: Color(0xFF8EBE4E),
        child: Icon(LucideIcons.circleHelp, color: Colors.white, size: 12),
      ),
      const SizedBox(height: 4),
      Text(
        title,
        style: const TextStyle(
          color: AppColors.catalogText,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );
}
