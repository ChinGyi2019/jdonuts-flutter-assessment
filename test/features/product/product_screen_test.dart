import 'dart:async';

import 'package:code_test_madivizion/core/error/failure.dart';
import 'package:code_test_madivizion/core/media/image_reference.dart';
import 'package:code_test_madivizion/features/product/presentation/widgets/product_artwork.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:code_test_madivizion/core/widgets/skeleton.dart';
import 'package:code_test_madivizion/features/product/di/product_providers.dart';
import 'package:code_test_madivizion/features/product/domain/entities/product.dart';
import 'package:code_test_madivizion/features/product/presentation/views/product_screen.dart';
import 'package:code_test_madivizion/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  testWidgets(
    'shows a skeleton, then handles failure and retry for a missing ID',
    (tester) async {
      final response = Completer<Either<Failure, Product?>>();
      var requests = 0;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productByIdProvider('missing').overrideWith((_) {
              requests++;
              return requests == 1
                  ? Stream.fromFuture(response.future)
                  : Stream.value(right(null));
            }),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: ProductScreen(id: 'missing'),
          ),
        ),
      );
      expect(find.byType(Skeleton), findsWidgets);
      response.complete(left(const StorageFailure('Failed')));
      await tester.pumpAndSettle();
      expect(find.text('Could not load this product.'), findsOneWidget);
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(find.text('This product could not be found.'), findsOneWidget);
      expect(find.text('ADD TO CART'), findsNothing);
    },
  );

  testWidgets('shows a discount only when the product has one', (tester) async {
    Future<void> showProduct({int? discount, required bool isNew}) async {
      final product = Product(
        id: 'discount',
        code: 'P1',
        name: 'Example product',
        priceMmk: 1000,
        description: 'Example description',
        isNew: isNew,
        discountPercent: discount,
        image: const ImageReference(asset: 'assets/images/coconut-donut.webp'),
      );
      await tester.pumpWidget(
        ProviderScope(
          key: ValueKey(discount),
          overrides: [
            productByIdProvider(
              'discount',
            ).overrideWith((_) => Stream.value(right(product))),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: ProductScreen(id: 'discount'),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    await showProduct(discount: 50, isNew: true);
    expect(find.text('50% off'), findsOneWidget);
    expect(find.text('New'), findsOneWidget);
    await showProduct(isNew: false);
    expect(find.text('50% off'), findsNothing);
    expect(find.text('New'), findsNothing);
  });

  for (final asset in ['assorted-box', 'festive-box']) {
    for (final reduceMotion in [false, true]) {
      testWidgets(
        '$asset detail fits a compact screen at 1.3 text scale, reduced motion: $reduceMotion',
        (tester) async {
          tester.view.physicalSize = const Size(320, 568);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          final product = Product(
            id: asset,
            code: 'P1',
            name: asset,
            priceMmk: 1000,
            description: 'Seasonal donuts',
            isNew: false,
            image: ImageReference(asset: 'assets/images/$asset.webp'),
          );
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                productByIdProvider(
                  asset,
                ).overrideWith((_) => Stream.value(right(product))),
              ],
              child: MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    disableAnimations: reduceMotion,
                    textScaler: const TextScaler.linear(1.3),
                  ),
                  child: child!,
                ),
                home: ProductScreen(id: asset),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.byType(ProductArtwork), findsOneWidget);
          expect(find.text(asset), findsOneWidget);
          await tester.ensureVisible(find.text('ADD TO CART'));
          expect(find.text('ADD TO CART').hitTestable(), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  for (final reduceMotion in [false, true]) {
    testWidgets(
      'add to cart ${reduceMotion ? 'respects reduced motion' : 'flies artwork to the cart'}',
      (tester) async {
        const product = Product(
          id: '1',
          code: 'P1',
          name: 'Example product',
          priceMmk: 1000,
          description: 'Example description',
          isNew: false,
          image: ImageReference(asset: 'assets/images/missing.png'),
        );
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              productByIdProvider(
                '1',
              ).overrideWith((_) => Stream.value(right(product))),
            ],
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(disableAnimations: reduceMotion),
                child: child!,
              ),
              home: const ProductScreen(id: '1'),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byIcon(LucideIcons.shoppingCart), findsOneWidget);
        expect(find.byType(ProductArtwork), findsOneWidget);
        expect(
          tester.widget<Badge>(find.byType(Badge)).isLabelVisible,
          isFalse,
        );
        await tester.tap(find.text('ADD TO CART'));
        await tester.pump();
        expect(
          find.descendant(of: find.byType(Badge), matching: find.text('1')),
          findsOneWidget,
        );
        if (reduceMotion) {
          expect(find.byType(ProductArtwork), findsOneWidget);
        } else {
          expect(find.byType(ProductArtwork), findsNWidgets(2));
          final start = tester.getCenter(find.byType(ProductArtwork).last);
          final startSize = tester.getSize(find.byType(ProductArtwork).last);
          await tester.pump(const Duration(milliseconds: 350));
          final middle = tester.getCenter(find.byType(ProductArtwork).last);
          expect(middle.dy, lessThan(start.dy));
          expect(
            tester.getSize(find.byType(ProductArtwork).last).width,
            lessThan(startSize.width),
          );
        }
        await tester.pumpAndSettle();
        expect(find.byType(ProductArtwork), findsOneWidget);
        expect(find.text('Added to cart'), findsOneWidget);
        ScaffoldMessenger.of(
          tester.element(find.byType(ProductScreen)),
        ).hideCurrentSnackBar();
        await tester.pumpAndSettle();
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -220),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip('Increase quantity'));
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip('Increase quantity'));
        await tester.pumpAndSettle();
        expect(
          find.descendant(of: find.byType(Badge), matching: find.text('1')),
          findsOneWidget,
        );
        await tester.tap(find.text('ADD TO CART'));
        await tester.pump();
        expect(
          find.descendant(of: find.byType(Badge), matching: find.text('4')),
          findsOneWidget,
        );
        await tester.pumpAndSettle();
        tester
            .state<NavigatorState>(find.byType(Navigator))
            .push(
              MaterialPageRoute<void>(
                builder: (_) => const ProductScreen(id: '1'),
              ),
            );
        await tester.pumpAndSettle();
        expect(
          find.descendant(of: find.byType(Badge), matching: find.text('4')),
          findsOneWidget,
        );
      },
    );
  }
}
