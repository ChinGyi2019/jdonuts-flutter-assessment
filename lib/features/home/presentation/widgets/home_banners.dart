import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/media/catalog_image.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/entrance.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../l10n/app_localizations.dart';
import '../../di/home_providers.dart';
import '../../domain/entities/home_catalog.dart';
import 'home_badge.dart';
import 'home_status.dart';

class HomeBanners extends ConsumerWidget {
  const HomeBanners({this.showSkeleton = false, super.key});

  final bool showSkeleton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final failure = HomeStatus(
      strings.bannerLoadError,
      onRetry: () => ref.invalidate(homeBannersProvider),
    );
    final banners = ref.watch(homeBannersProvider);
    if (showSkeleton) return const _BannerSkeleton();
    return banners.when(
      data: (result) => result.match(
        (_) => failure,
        (banners) => banners.isEmpty
            ? HomeStatus(strings.emptyBanners)
            : Entrance(order: 1, child: _BannerCarousel(banners)),
      ),
      error: (_, _) => failure,
      loading: _BannerSkeleton.new,
    );
  }
}

const _bannerViewportFraction = .82;

double _bannerHeight(BuildContext context) =>
    168 + (MediaQuery.textScalerOf(context).scale(18) - 18) * 3;

class _BannerSkeleton extends StatelessWidget {
  const _BannerSkeleton();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 24),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final height = _bannerHeight(context);
        return SkeletonShimmer(
          child: SizedBox(
            height: height,
            child: Row(
              children: [
                SkeletonBlock(
                  width: constraints.maxWidth * _bannerViewportFraction - 16,
                  height: height,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ClipRect(
                    child: OverflowBox(
                      alignment: Alignment.centerLeft,
                      maxWidth: constraints.maxWidth * _bannerViewportFraction,
                      child: SkeletonBlock(height: height),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class _BannerCarousel extends StatefulWidget {
  const _BannerCarousel(this.banners);

  final List<HomeBanner> banners;

  @override
  State<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  final _pages = PageController(viewportFraction: _bannerViewportFraction);
  Timer? _autoplay;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateAutoplay();
  }

  @override
  void didUpdateWidget(covariant _BannerCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.banners.length != widget.banners.length) _updateAutoplay();
  }

  void _updateAutoplay() {
    final motion =
        !MediaQuery.disableAnimationsOf(context) && TickerMode.of(context);
    if (!motion || widget.banners.length < 2) {
      _autoplay?.cancel();
      _autoplay = null;
    } else {
      _autoplay ??= Timer.periodic(AppMotion.bannerInterval, (_) => _advance());
    }
  }

  void _advance() {
    if (!_pages.hasClients || _pages.position.isScrollingNotifier.value) return;
    unawaited(
      _pages.nextPage(duration: AppMotion.bannerSlide, curve: AppMotion.curve),
    );
  }

  @override
  void dispose() {
    _autoplay?.cancel();
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 24),
    child: SizedBox(
      height: _bannerHeight(context),
      child: PageView.builder(
        controller: _pages,
        padEnds: false,
        itemCount: widget.banners.length == 1 ? 1 : null,
        itemBuilder: (_, index) {
          final position = index % widget.banners.length;
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _BannerCard(widget.banners[position], position.isEven),
          );
        },
      ),
    ),
  );
}

class _BannerCard extends StatelessWidget {
  const _BannerCard(this.banner, this.purple);

  final HomeBanner banner;
  final bool purple;

  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: purple ? const Color(0xFF5A56A3) : AppColors.catalogBlue,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
    ),
    child: Stack(
      fit: StackFit.expand,
      children: [
        const CustomPaint(painter: _SprinklePattern()),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Column(
            children: [
              HomeBadge(banner.badge, small: true),
              const SizedBox(height: 4),
              Text(
                banner.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.05,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(child: _image()),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _image() => FractionallySizedBox(
    widthFactor: .76,
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned.fill(
          top: 7,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
            child: CatalogImage(reference: banner.image),
          ),
        ),
        if (purple)
          const CircleAvatar(
            radius: 12,
            backgroundColor: Colors.white,
            child: Icon(
              LucideIcons.store,
              color: AppColors.catalogPink,
              size: 13,
            ),
          ),
      ],
    ),
  );
}

class _SprinklePattern extends CustomPainter {
  const _SprinklePattern();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: .14)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;
    for (var index = 0; index < 20; index++) {
      final start = Offset(
        size.width * ((index * 37) % 100) / 100,
        size.height * ((index * 63) % 100) / 100,
      );
      final end =
          start + Offset(index.isEven ? 13 : -6, index % 3 == 0 ? 8 : 17);
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SprinklePattern oldDelegate) => false;
}
