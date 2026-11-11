import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/active_member.dart';
import '../../../../core/media/catalog_image.dart';
import '../../../../core/member/domain/member.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../rewards/di/rewards_providers.dart';

class SettingsProfileCard extends ConsumerWidget {
  const SettingsProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final failure = _ProfileStatus(
      strings.memberLoadError,
      onRetry: () => ref.invalidate(activeMemberProvider),
    );
    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        side: BorderSide(color: Color(0xFFDCE2E4)),
      ),
      child: ref
          .watch(activeMemberProvider)
          .when(
            skipLoadingOnRefresh: false,
            loading: () => Semantics(
              label: strings.profileLoading,
              liveRegion: true,
              child: const _ProfileLoading(),
            ),
            error: (_, _) => failure,
            data: (result) => result.match((_) => failure, (member) {
              if (member == null) return _ProfileStatus(strings.emptyMember);
              final tier = ref
                  .watch(memberTierProgressProvider)
                  .value
                  ?.getOrElse((_) => null)
                  ?.current;
              return _ProfileDetails(member, tierName: tier?.name);
            }),
          ),
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails(this.member, {required this.tierName});

  final Member member;
  final String? tierName;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [_identity(), _rewards(AppLocalizations.of(context)!)],
  );

  Widget _identity() {
    final phone = member.phone;
    const avatarSize = 68.0;
    const avatarGap = 14.0;
    final avatar = ExcludeSemantics(
      child: Container(
        width: avatarSize,
        height: avatarSize,
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
        ),
        child: ClipOval(child: CatalogImage(reference: member.image)),
      ),
    );
    final identity = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            member.displayName,
            style: const TextStyle(
              color: AppColors.catalogText,
              fontSize: 23,
              height: 1.15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (phone != null && phone.isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(
            phone,
            textDirection: TextDirection.ltr,
            style: const TextStyle(color: AppColors.catalogText, fontSize: 14),
          ),
        ],
      ],
    );
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.welcomeBackground, AppColors.catalogPeach],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final minTextWidth = MediaQuery.textScalerOf(context).scale(15) * 8;
            if (constraints.maxWidth < avatarSize + avatarGap + minTextWidth) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [avatar, const SizedBox(height: 12), identity],
              );
            }
            return Row(
              children: [
                avatar,
                const SizedBox(width: avatarGap),
                Expanded(child: identity),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _rewards(AppLocalizations strings) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    child: Row(
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.welcomeBackground,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Icon(
              LucideIcons.crown,
              color: AppColors.catalogText,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (tierName case final name?)
                Text(
                  strings.memberTier(name),
                  style: const TextStyle(
                    color: AppColors.catalogText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              Text(
                strings.profilePoints(member.points),
                style: const TextStyle(
                  color: AppColors.catalogMuted,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ProfileLoading extends StatelessWidget {
  const _ProfileLoading();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(20),
    child: SkeletonShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBlock(width: 68, height: 68, radius: 34),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBlock(width: 142, height: 24, radius: 7),
                    SizedBox(height: 8),
                    SkeletonBlock(width: 108, height: 14, radius: 5),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          SkeletonBlock(width: 152, height: 36),
        ],
      ),
    ),
  );
}

class _ProfileStatus extends StatelessWidget {
  const _ProfileStatus(this.message, {this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(message, style: const TextStyle(color: AppColors.catalogText)),
        if (onRetry != null)
          TextButton(
            onPressed: onRetry,
            child: Text(AppLocalizations.of(context)!.retry),
          ),
      ],
    ),
  );
}
