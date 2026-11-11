import 'package:code_test_madivizion/core/media/catalog_image.dart';
import 'package:code_test_madivizion/core/media/image_reference.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the bundled product image in a provider scope', (
    tester,
  ) async {
    const asset = 'assets/images/coconut-donut.webp';
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Center(
            child: SizedBox.square(
              dimension: 96,
              child: CatalogImage(
                reference: ImageReference(asset: asset),
                semanticLabel: 'Coconut Donut',
              ),
            ),
          ),
        ),
      ),
    );

    final context = tester.element(find.byType(CatalogImage));
    await tester.runAsync(
      () => precacheImage(const AssetImage(asset), context),
    );
    await tester.pump();
    final rendered = tester.widget<RawImage>(find.byType(RawImage));
    expect(rendered.image, isNotNull);
    expect(find.bySemanticsLabel('Coconut Donut'), findsOneWidget);
  });

  testWidgets('shows an error icon when the bundled image is missing', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CatalogImage(
          reference: ImageReference(asset: 'assets/images/missing.webp'),
        ),
      ),
    );

    await tester.runAsync(() async {
      final context = tester.element(find.byType(CatalogImage));
      await precacheImage(
        const AssetImage('assets/images/missing.webp'),
        context,
        onError: (_, _) {},
      );
    });
    await tester.pumpAndSettle();
    expect(find.byIcon(LucideIcons.imageOff), findsOneWidget);
  });
}
