import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/entrance.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/presentation/widgets/product_artwork.dart';
import '../../di/home_providers.dart';
import '../../domain/entities/home_catalog.dart';
import 'home_badge.dart';
import 'home_status.dart';

class HomeProductSection extends ConsumerWidget {
  const HomeProductSection(
    this.section, {
    this.showSkeleton = false,
    super.key,
  });

  final HomeSection section;
  final bool showSkeleton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final failure = HomeStatus(
      strings.productSectionError,
      onRetry: () => ref.invalidate(homeSectionProvider(section)),
    );
    final title = switch (section) {
      HomeSection.seasonalSpecials => strings.seasonalSpecials,
      HomeSection.popular => strings.popular,
      HomeSection.orderAgain => strings.orderAgain,
    };
    final products = ref.watch(homeSectionProvider(section));
    if (showSkeleton) return _status(title, _ProductSkeleton(section));
    return products.when(
      data: (result) => result.match(
        (_) => _status(title, failure),
        (products) => products.isEmpty
            ? _status(title, HomeStatus(strings.emptyProducts))
            : Entrance(
                order: section.index + 2,
                child: _ProductRow(section, title, products),
              ),
      ),
      error: (_, _) => _status(title, failure),
      loading: () => _status(title, _ProductSkeleton(section)),
    );
  }

  Widget _status(String title, Widget body) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_SectionHeading(title), body],
  );
}

double _tileWidth(double available, HomeSection section) =>
    (available * (section == HomeSection.seasonalSpecials ? .625 : .415)).clamp(
      0.0,
      section == HomeSection.seasonalSpecials ? 325.0 : 216.0,
    );

double _tileImageHeight(double width, HomeSection section) =>
    width *
    switch (section) {
      HomeSection.seasonalSpecials => .67,
      HomeSection.popular => 1.5,
      HomeSection.orderAgain => 1,
    };

double _rowHeight(BuildContext context, double imageHeight) =>
    imageHeight + 12 + MediaQuery.textScalerOf(context).scale(16) * 2.7;

class _ProductSkeleton extends StatelessWidget {
  const _ProductSkeleton(this.section);

  final HomeSection section;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = _tileWidth(constraints.maxWidth, section);
      final imageHeight = _tileImageHeight(width, section);
      return SkeletonShimmer(
        child: SizedBox(
          height: _rowHeight(context, imageHeight),
          child: ListView.separated(
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: 3,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (_, _) => SizedBox(
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBlock(height: imageHeight),
                  const SizedBox(height: 8),
                  SkeletonBlock(width: width * .72, height: 13, radius: 5),
                  const SizedBox(height: 6),
                  SkeletonBlock(width: width * .42, height: 10, radius: 5),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _ProductRow extends StatefulWidget {
  const _ProductRow(this.section, this.title, this.products);

  final HomeSection section;
  final String title;
  final List<Product> products;

  @override
  State<_ProductRow> createState() => _ProductRowState();
}

class _ProductRowState extends State<_ProductRow> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _advance() {
    if (!_scroll.hasClients) return;
    final position = _scroll.position;
    final end = position.maxScrollExtent;
    final next = position.extentAfter < 1
        ? 0.0
        : (position.pixels + position.viewportDimension * .7).clamp(0.0, end);
    final duration = AppMotion.duration(context, AppMotion.standard);
    if (duration == Duration.zero) {
      _scroll.jumpTo(next);
    } else {
      _scroll.animateTo(next, duration: duration, curve: AppMotion.curve);
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = _tileWidth(constraints.maxWidth, widget.section);
      final height = _tileImageHeight(width, widget.section);
      return Column(
        children: [
          _SectionHeading(widget.title, onMore: _advance),
          _list(width, height),
        ],
      );
    },
  );

  Widget _list(double width, double height) => SizedBox(
    height: _rowHeight(context, height),
    child: ListView.separated(
      controller: _scroll,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: widget.products.length,
      separatorBuilder: (_, _) => const SizedBox(width: 16),
      itemBuilder: (_, index) => SizedBox(
        width: width,
        child: _ProductTile(
          widget.products[index],
          section: widget.section,
          imageHeight: height,
        ),
      ),
    ),
  );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading(this.title, {this.onMore});

  final String title;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(28, 0, 22, 5),
    child: Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.catalogText,
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: -.45,
              ),
            ),
          ),
        ),
        if (onMore != null)
          IconButton(
            tooltip: AppLocalizations.of(context)!.moreInSection(title),
            onPressed: onMore,
            icon: const CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: Icon(
                LucideIcons.chevronRight,
                size: 19,
                color: AppColors.catalogText,
              ),
            ),
          )
        else
          const SizedBox(height: 48),
      ],
    ),
  );
}

class _ProductTile extends StatelessWidget {
  const _ProductTile(
    this.product, {
    required this.section,
    required this.imageHeight,
  });

  final Product product;
  final HomeSection section;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    final heroTag = (section, product.id);
    return PressScale(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(
          '/product/${Uri.encodeComponent(product.id)}',
          extra: ProductSelection(product: product, heroTag: heroTag),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _image(context, heroTag),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 7, 4, 0),
              child: Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.catalogText,
                  fontSize: 15,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _image(BuildContext context, Object heroTag) => ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: SizedBox(
      height: imageHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Colors.white),
          ProductArtwork(
            product: product,
            heroTag: heroTag,
            isolated: section == HomeSection.popular,
          ),
          if (product.discountPercent case final percent?)
            Positioned(
              right: 7,
              bottom: 7,
              child: HomeBadge(
                AppLocalizations.of(context)!.discountBadge(percent),
              ),
            ),
        ],
      ),
    ),
  );
}
