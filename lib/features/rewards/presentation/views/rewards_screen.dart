import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/active_member.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../l10n/app_localizations.dart';
import '../../di/rewards_providers.dart';
import '../../domain/entities/reward_challenge.dart';
import '../viewmodels/rewards_viewmodel.dart';
import '../widgets/reward_challenge_card.dart';
import '../widgets/rewards_header.dart';
import '../widgets/rewards_tabs.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(rewardsViewModelProvider);
    final strings = AppLocalizations.of(context)!;
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: ColoredBox(
          color: AppColors.catalogBackground,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: DefaultTextStyle.merge(
                style: const TextStyle(color: AppColors.rewardsText),
                child: _content(data, strings, ref),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(
    AsyncValue<RewardsState?> state,
    AppLocalizations strings,
    WidgetRef ref,
  ) => state.when(
    data: (data) => data == null
        ? _RewardsStatus(message: strings.emptyMember)
        : _RewardsPresentation(data: data),
    error: (_, _) => _RewardsStatus(
      message: strings.rewardsLoadError,
      onRetry: () => _retry(ref),
    ),
    loading: () =>
        _RewardsStatus(message: strings.rewardsLoading, loading: true),
  );

  void _retry(WidgetRef ref) {
    ref.invalidate(activeMemberProvider);
    ref.invalidate(rewardTiersProvider);
    ref.invalidate(rewardChallengesProvider);
  }
}

class _RewardsPresentation extends StatefulWidget {
  const _RewardsPresentation({required this.data});

  final RewardsState data;

  @override
  State<_RewardsPresentation> createState() => _RewardsPresentationState();
}

class _RewardsPresentationState extends State<_RewardsPresentation>
    with SingleTickerProviderStateMixin {
  late final _intro = AnimationController(
    vsync: this,
    duration: AppMotion.rewardsIntro,
  );
  final _scroll = ScrollController();
  var _tab = RewardsTab.challenges;
  var _sequence = 0;
  var _active = false;
  var _delayCards = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final active = TickerMode.of(context);
    if (active && !_active) {
      _reset();
      _scrollToTop();
    }
    if (MediaQuery.disableAnimationsOf(context)) _intro.value = 1;
    if (!active) _intro.stop();
    _active = active;
  }

  void _reset() {
    _tab = RewardsTab.challenges;
    _delayCards = true;
    _sequence++;
    if (!MediaQuery.disableAnimationsOf(context)) _intro.forward(from: 0);
  }

  void _replay() {
    if (MediaQuery.disableAnimationsOf(context)) {
      _select(RewardsTab.challenges);
    } else {
      setState(_reset);
    }
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _active && _scroll.hasClients && _scroll.offset != 0) {
        _scroll.jumpTo(0);
      }
    });
  }

  void _select(RewardsTab tab) {
    if (tab == _tab) return;
    setState(() {
      _tab = tab;
      _delayCards = false;
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
    controller: _scroll,
    padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 24),
    children: [
      RewardsHeader(data: widget.data, animation: _intro, onReplay: _replay),
      ColoredBox(
        color: Colors.white,
        child: RewardsTabs(selected: _tab, onSelected: _select),
      ),
      _deck(context),
    ],
  );

  Widget _deck(BuildContext context) => AnimatedSwitcher(
    duration: AppMotion.duration(context, AppMotion.standard),
    switchInCurve: AppMotion.entranceFade,
    switchOutCurve: AppMotion.curve,
    transitionBuilder: (child, animation) => FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: animation.drive(
          Tween(begin: const Offset(0, .035), end: Offset.zero),
        ),
        child: child,
      ),
    ),
    layoutBuilder: (current, previous) => Stack(
      alignment: Alignment.topCenter,
      children: [
        for (final child in previous)
          IgnorePointer(child: ExcludeSemantics(child: child)),
        ?current,
      ],
    ),
    child: Padding(
      key: ValueKey(_tab),
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
      child: _tab == RewardsTab.gift
          ? const _GiftEmpty()
          : _challenges(context, widget.data.challenges),
    ),
  );

  Widget _challenges(BuildContext context, List<RewardChallenge> challenges) {
    if (challenges.isEmpty) {
      return _DeckMessage(
        message: AppLocalizations.of(context)!.emptyChallenges,
      );
    }
    return Column(
      children: [
        for (final (index, challenge) in challenges.indexed) ...[
          if (index > 0) const SizedBox(height: 16),
          RewardChallengeCard(
            key: ValueKey((_sequence, challenge.id, challenge.isComplete)),
            challenge: challenge,
            delay:
                (_delayCards ? AppMotion.rewardsListDelay : Duration.zero) +
                AppMotion.stagger * index,
          ),
        ],
      ],
    );
  }
}

class _GiftEmpty extends StatelessWidget {
  const _GiftEmpty();

  @override
  Widget build(BuildContext context) => _DeckMessage(
    message: AppLocalizations.of(context)!.emptyGifts,
    icon: LucideIcons.gift,
  );
}

class _DeckMessage extends StatelessWidget {
  const _DeckMessage({required this.message, this.icon});

  final String message;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(
      minHeight: 158,
      minWidth: double.infinity,
    ),
    alignment: Alignment.center,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, color: AppColors.catalogBlue, size: 48),
          const SizedBox(height: 10),
        ],
        Text(message, textAlign: TextAlign.center),
      ],
    ),
  );
}

class _RewardsStatus extends StatelessWidget {
  const _RewardsStatus({
    required this.message,
    this.loading = false,
    this.onRetry,
  });

  final String message;
  final bool loading;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.only(top: 12),
    children: [
      const RewardsHeading(),
      const SizedBox(height: 40),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            if (loading) const Skeleton(height: 225),
            const SizedBox(height: 12),
            Semantics(
              liveRegion: true,
              child: Text(message, textAlign: TextAlign.center),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: Text(AppLocalizations.of(context)!.retry),
              ),
          ],
        ),
      ),
    ],
  );
}
