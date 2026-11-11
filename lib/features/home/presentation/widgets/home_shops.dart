import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/media/catalog_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/entrance.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../l10n/app_localizations.dart';
import '../../di/home_providers.dart';
import '../../domain/entities/home_catalog.dart';
import 'home_status.dart';

class HomeShops extends ConsumerWidget {
  const HomeShops({this.showSkeleton = false, super.key});

  final bool showSkeleton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final failure = HomeStatus(
      strings.shopLoadError,
      onRetry: () => ref.invalidate(homeShopsProvider),
    );
    final shops = ref.watch(homeShopsProvider);
    if (showSkeleton) return const _ShopsSkeleton();
    return shops.when(
      data: (result) => result.match(
        (_) => _status(strings, failure),
        (shops) => shops.isEmpty
            ? _status(strings, HomeStatus(strings.emptyShops))
            : Entrance(order: 5, child: _ShopsPanel(shops)),
      ),
      error: (_, _) => _status(strings, failure),
      loading: _ShopsSkeleton.new,
    );
  }

  Widget _status(AppLocalizations strings, Widget status) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          strings.nearbyShopsTitle,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ),
      status,
    ],
  );
}

class _ShopsSkeleton extends StatelessWidget {
  const _ShopsSkeleton();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(28, 25, 28, 28),
    child: LayoutBuilder(
      builder: (context, constraints) => SkeletonShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonBlock(width: 210, height: 24, radius: 7),
            const SizedBox(height: 10),
            const SkeletonBlock(width: 150, height: 24, radius: 7),
            const SizedBox(height: 16),
            const SkeletonBlock(width: 118, height: 36, radius: 18),
            const SizedBox(height: 23),
            SkeletonBlock(
              width: (constraints.maxWidth + 56) * .75,
              height: (constraints.maxWidth + 56) * .375,
            ),
            const SizedBox(height: 10),
            const SkeletonBlock(width: 135, height: 14, radius: 5),
            const SizedBox(height: 8),
            const SkeletonBlock(width: 172, height: 12, radius: 5),
          ],
        ),
      ),
    ),
  );
}

class _ShopsPanel extends StatelessWidget {
  const _ShopsPanel(this.shops);

  final List<Shop> shops;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return ColoredBox(
      color: AppColors.catalogBlue,
      child: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: _Landscape())),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 25, 36, 23),
                child: _heading(strings),
              ),
              LayoutBuilder(
                builder: (context, constraints) =>
                    _list(context, (constraints.maxWidth * .75).clamp(0, 390)),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heading(AppLocalizations strings) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Semantics(
        header: true,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 270),
          child: Text(
            strings.nearbyShops(shops.length),
            style: const TextStyle(
              fontSize: 22,
              height: 1.15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
      DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Text(
            strings.exploreNow,
            style: const TextStyle(
              color: AppColors.catalogBlue,
              fontWeight: FontWeight.w800,
              letterSpacing: .65,
            ),
          ),
        ),
      ),
    ],
  );

  Widget _list(BuildContext context, double width) {
    double textHeight(String text, TextStyle style, {int? maxLines}) {
      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: DefaultTextStyle.of(context).style.merge(style),
        ),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
        maxLines: maxLines,
      )..layout(maxWidth: (width - 28).clamp(0, double.infinity));
      final height = painter.height;
      painter.dispose();
      return height;
    }

    final nameHeight = shops
        .map((shop) => textHeight(shop.name, _ShopCard.nameStyle, maxLines: 2))
        .reduce((a, b) => a > b ? a : b);
    final addressHeight = shops
        .map(
          (shop) =>
              textHeight(shop.address, _ShopCard.addressStyle, maxLines: 2),
        )
        .reduce((a, b) => a > b ? a : b);
    final orderHeight = textHeight(
      AppLocalizations.of(context)!.orderOnline,
      _ShopCard.orderStyle,
    );
    final cardHeight =
        28 + width * .50 + 9 + nameHeight + 5 + addressHeight + 8 + orderHeight;
    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        itemCount: shops.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (_, index) => SizedBox(
          width: width,
          child: _ShopCard(shops[index], imageHeight: width * .50),
        ),
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard(this.shop, {required this.imageHeight});

  final Shop shop;
  final double imageHeight;

  static const nameStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w800);
  static const addressStyle = TextStyle(
    fontSize: 12,
    color: AppColors.catalogText,
  );
  static const orderStyle = TextStyle(
    color: AppColors.catalogPink,
    fontSize: 13,
    fontWeight: FontWeight.w800,
  );

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: imageHeight,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: CatalogImage(reference: shop.image),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            shop.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: nameStyle,
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Text(
              shop.address,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: addressStyle,
            ),
          ),
          const SizedBox(height: 8),
          Text(AppLocalizations.of(context)!.orderOnline, style: orderStyle),
        ],
      ),
    ),
  );
}

class _Landscape extends CustomPainter {
  const _Landscape();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFFFF2DF);
    canvas.drawCircle(Offset(size.width * .93, 104), 68, paint);
    canvas.drawCircle(Offset(size.width * .72, 140), 60, paint);
    canvas.drawCircle(Offset(size.width * 1.04, 158), 81, paint);
    paint.color = const Color(0xFF7A9E5C);
    canvas.drawOval(
      Rect.fromLTWH(
        -size.width * .25,
        size.height * .52,
        size.width * 1.3,
        size.height * .74,
      ),
      paint,
    );
    paint.color = const Color(0xFFABC66E);
    canvas.drawOval(
      Rect.fromLTWH(
        size.width * .18,
        size.height * .74,
        size.width,
        size.height * .38,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _Landscape oldDelegate) => false;
}
