import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/active_member.dart';
import '../../../../core/media/catalog_image.dart';
import '../../../../core/member/domain/member.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/entrance.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../rewards/di/rewards_providers.dart';
import '../../../rewards/domain/entities/reward_tier.dart';
import 'home_banners.dart';
import 'home_status.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({this.showSkeleton = false, super.key});

  final bool showSkeleton;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ClipRRect(
    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(27)),
    child: ColoredBox(
      color: AppColors.catalogPeach,
      child: Stack(
        children: [
          const Positioned(right: -34, top: 63, child: _TierWatermark()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: MediaQuery.paddingOf(context).top + 18),
              _profile(context, ref),
              const SizedBox(height: 16),
              HomeBanners(showSkeleton: showSkeleton),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _profile(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final failure = HomeStatus(
      strings.memberLoadError,
      onRetry: () => ref.invalidate(activeMemberProvider),
    );
    final progress = ref
        .watch(memberTierProgressProvider)
        .value
        ?.getOrElse((_) => null);
    final member = ref.watch(activeMemberProvider);
    if (showSkeleton) return const _ProfileSkeleton();
    return member.when(
      data: (result) => result.match(
        (_) => failure,
        (member) => member == null
            ? HomeStatus(strings.emptyMember)
            : Entrance(child: _MemberProfile(member, progress)),
      ),
      error: (_, _) => failure,
      loading: _ProfileSkeleton.new,
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: SkeletonShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(4),
                child: SkeletonBlock(width: 64, height: 64, radius: 32),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBlock(width: 126, height: 26, radius: 7),
                    SizedBox(height: 8),
                    SkeletonBlock(width: 84, height: 13, radius: 5),
                  ],
                ),
              ),
              SizedBox(width: 12),
              SkeletonBlock(width: 44, height: 32),
            ],
          ),
          SizedBox(height: 12),
          SkeletonBlock(width: 192, height: 24),
        ],
      ),
    ),
  );
}

class _MemberProfile extends StatelessWidget {
  const _MemberProfile(this.member, this.progress);

  final Member member;
  final TierProgress? progress;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final tier = progress?.current;
    final remaining = progress?.pointsRemaining;
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.go('/settings'),
                  child: Row(
                    children: [
                      Padding(padding: const EdgeInsets.all(4), child: _avatar()),
                      const SizedBox(width: 10),
                      Expanded(child: _name(strings, tier)),
                    ],
                  ),
                ),
              ),
              _Notifications(member.notificationCount),
            ],
          ),
          if (remaining != null && progress?.next != null)
            Padding(
              padding: const EdgeInsets.only(top: 12, right: 24),
              child: _pointsPill(
                strings.tierPointsRemaining(
                  NumberFormat.decimalPattern(
                    strings.localeName,
                  ).format(remaining),
                  progress!.next!.name,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _avatar() => Container(
    width: 64,
    height: 64,
    padding: const EdgeInsets.all(4),
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: SweepGradient(
        colors: [Color(0xFFE5A15E), Color(0x00E5A15E), Color(0xFFE5A15E)],
      ),
    ),
    child: ClipOval(child: CatalogImage(reference: member.image)),
  );

  Widget _name(AppLocalizations strings, RewardTier? tier) => Padding(
    padding: const EdgeInsets.only(top: 5, right: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          member.displayName,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            height: 1.12,
            color: AppColors.catalogText,
          ),
        ),
        if (tier != null)
          Text(
            strings.memberTier(tier.name),
            style: const TextStyle(fontSize: 14),
          ),
      ],
    ),
  );

  Widget _pointsPill(String label) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    ),
  );
}

class _Notifications extends StatelessWidget {
  const _Notifications(this.count);

  final int count;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: AppLocalizations.of(context)!.notifications(count),
    excludeSemantics: true,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        color: AppColors.catalogOrange,
        border: Border.fromBorderSide(BorderSide(color: Colors.white)),
        borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.bell, color: Colors.white, size: 20),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

class _TierWatermark extends StatelessWidget {
  const _TierWatermark();

  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: -.49,
    child: Container(
      width: 176,
      height: 188,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(39),
        border: Border.all(color: Colors.white, width: 4),
        gradient: const LinearGradient(
          colors: [Color(0xFFDAA775), Color(0xFFF5DCC2), Color(0xFFFDEAD9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 27),
      child: Transform.rotate(
        angle: .49,
        child: const Icon(LucideIcons.star, size: 39, color: Color(0xFFAB927A)),
      ),
    ),
  );
}
