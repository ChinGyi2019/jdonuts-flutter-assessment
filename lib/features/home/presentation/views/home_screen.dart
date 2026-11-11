import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/connectivity/connectivity_monitor.dart';
import '../../../../core/connectivity/connectivity_providers.dart';
import '../../../../core/storage/catalog_refresh_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/home_catalog.dart';
import '../widgets/home_header.dart';
import '../widgets/home_product_section.dart';
import '../widgets/home_shops.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const _minimumSkeletonTime = Duration(milliseconds: 320);
  late final Timer _initialSkeletonTimer;
  bool _showInitialSkeleton = true;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    _initialSkeletonTimer = Timer(_minimumSkeletonTime, () {
      setState(() => _showInitialSkeleton = false);
    });
  }

  @override
  void dispose() {
    _initialSkeletonTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showSkeleton = _showInitialSkeleton || _refreshing;
    final offline =
        ref.watch(networkStatusProvider).value == NetworkStatus.offline;
    return ColoredBox(
      color: AppColors.catalogBackground,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Semantics(
            liveRegion: showSkeleton,
            label: showSkeleton
                ? AppLocalizations.of(context)!.loadingCatalog
                : null,
            child: RefreshIndicator.adaptive(
              onRefresh: _refresh,
              displacement: 100,
              child: ListView(
                key: const PageStorageKey('home-feed'),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom,
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  HomeHeader(showSkeleton: showSkeleton),
                  if (offline) const _OfflineBanner(),
                  const SizedBox(height: 20),
                  for (final section in HomeSection.values) ...[
                    HomeProductSection(section, showSkeleton: showSkeleton),
                    const SizedBox(height: 30),
                  ],
                  HomeShops(showSkeleton: showSkeleton),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() => _refreshing = true);
    final minimumDisplay = Future<void>.delayed(_minimumSkeletonTime);
    try {
      final result = await ref.read(catalogRefreshProvider).refresh();
      if (mounted && result.isLeft()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.refreshError)),
        );
      }
    } finally {
      await minimumDisplay;
      if (mounted) setState(() => _refreshing = false);
    }
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0xFFD5E9EB),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          const Icon(
            LucideIcons.wifiOff,
            size: 15,
            color: AppColors.catalogText,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.offlineCatalog,
              style: const TextStyle(color: AppColors.catalogText),
            ),
          ),
        ],
      ),
    ),
  );
}
