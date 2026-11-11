import 'package:code_test_madivizion/core/media/catalog_image.dart';
import 'package:code_test_madivizion/features/product/data/models/product_model.dart';
import 'package:code_test_madivizion/features/product/presentation/widgets/product_artwork.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ProductModel model(String asset) => ProductModel(
    id: 'product',
    code: 'code',
    name: 'Donuts',
    priceMmk: 1000,
    description: 'Donuts',
    isNew: false,
    imageAsset: asset,
  );

  testWidgets(
    'seasonal detail uses a clean rounded photograph without a fade',
    (tester) async {
      for (final asset in ['assorted-box', 'festive-box']) {
        final product = model('assets/images/$asset.webp').toEntity();
        await tester.pumpWidget(
          MaterialApp(home: ProductArtwork(product: product, isolated: true)),
        );
        expect(find.byType(ShaderMask), findsNothing);
        expect(
          tester
              .widget<CatalogImage>(find.byType(CatalogImage))
              .reference
              .asset,
          'assets/images/$asset.webp',
        );
        expect(await rootBundle.load('assets/images/$asset.webp'), isNotNull);
      }
    },
  );

  testWidgets('popular artwork retains its existing fade', (tester) async {
    final product = model('assets/images/coconut-donut.webp').toEntity();
    await tester.pumpWidget(
      MaterialApp(home: ProductArtwork(product: product, isolated: true)),
    );
    expect(find.byType(ShaderMask), findsOneWidget);
  });
}
