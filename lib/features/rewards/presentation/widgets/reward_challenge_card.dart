import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/reward_challenge.dart';
import 'reward_challenge_art.dart';

class RewardChallengeCard extends StatefulWidget {
  const RewardChallengeCard({
    required this.challenge,
    required this.delay,
    super.key,
  });

  final RewardChallenge challenge;
  final Duration delay;

  @override
  State<RewardChallengeCard> createState() => _RewardChallengeCardState();
}

class _RewardChallengeCardState extends State<RewardChallengeCard>
    with SingleTickerProviderStateMixin {
  late final _artStart = widget.delay + AppMotion.standard;
  late final _artEnd = _artStart + AppMotion.rewardsArtwork;
  late final _end = widget.challenge.isComplete
      ? _artEnd + AppMotion.rewardsEarnCue
      : _artEnd;
  late final _timeline = AnimationController(vsync: this, duration: _end);
  late final _entrance = _interval(
    widget.delay,
    widget.delay + AppMotion.entrance,
  );
  late final _art = _interval(_artStart, _artEnd);
  late final _cue = _interval(_artEnd, _end);
  bool? _reducedMotion;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduced = MediaQuery.disableAnimationsOf(context);
    if (_reducedMotion == reduced) return;
    if (reduced) {
      _timeline.value = 1;
    } else if (_reducedMotion == null) {
      _timeline.forward();
    }
    _reducedMotion = reduced;
  }

  Animation<double> _interval(Duration start, Duration end) => _timeline.drive(
    CurveTween(
      curve: Interval(
        start.inMicroseconds / _end.inMicroseconds,
        end.inMicroseconds / _end.inMicroseconds,
      ),
    ),
  );

  @override
  void dispose() {
    _timeline.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _entrance.drive(CurveTween(curve: AppMotion.entranceFade)),
    child: SlideTransition(
      position: _entrance
          .drive(CurveTween(curve: AppMotion.entranceSlide))
          .drive(Tween(begin: const Offset(0, .11), end: Offset.zero)),
      child: RepaintBoundary(child: _card(context)),
    ),
  );

  Widget _card(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 158),
    padding: const EdgeInsets.fromLTRB(26, 17, 16, 17),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) => Row(
        children: [
          SizedBox(
            width: math.min(116, constraints.maxWidth * .34),
            child: RewardChallengeArt(
              challenge: widget.challenge,
              entrance: _art,
            ),
          ),
          SizedBox(
            width: constraints.maxWidth < 245
                ? 14
                : constraints.maxWidth * .105,
          ),
          Expanded(child: _details(context)),
        ],
      ),
    ),
  );

  Widget _details(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final challenge = widget.challenge;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          challenge.title,
          style: const TextStyle(
            fontSize: 15,
            height: 1.28,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          strings.challengeQuantity(
            challenge.completedQuantity,
            challenge.targetQuantity,
          ),
          style: const TextStyle(fontSize: 12.5),
        ),
        const SizedBox(height: 15),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 15,
          runSpacing: 4,
          children: [
            _earnButton(strings, challenge.isComplete),
            Text(
              strings.challengePoints(challenge.rewardPoints),
              style: const TextStyle(fontSize: 12.5),
            ),
          ],
        ),
      ],
    );
  }

  Widget _earnButton(AppLocalizations strings, bool complete) {
    final button = TextButton(
      onPressed: complete ? () {} : null,
      style: TextButton.styleFrom(
        minimumSize: const Size(67, 46),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white,
        backgroundColor: AppColors.catalogBlue,
        disabledBackgroundColor: AppColors.rewardsDisabled,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: .9,
        ),
      ),
      child: Text(strings.earnReward),
    );
    if (!complete) return button;
    return ScaleTransition(
      scale: _cue.drive(_EarnPulse()),
      child: PressScale(child: button),
    );
  }
}

class _EarnPulse extends Animatable<double> {
  @override
  double transform(double t) =>
      1 + .075 * math.pow(math.sin(t * math.pi * 2), 2) * (1 - .45 * t);
}
