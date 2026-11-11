import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../../../l10n/app_localizations.dart';

enum RewardsTab { challenges, gift }

class RewardsTabs extends StatelessWidget {
  const RewardsTabs({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final RewardsTab selected;
  final ValueChanged<RewardsTab> onSelected;

  static const _height = 48.0;
  static const _pillHeight = 34.0;
  static const _gap = 5.0;
  static const _text = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    fontFamily: AppTheme.fontFamily,
  );

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return SizedBox(
      height: _height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned.fill(
            top: _height / 2,
            child: ColoredBox(color: AppColors.catalogBackground),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, box) => _pills(context, box.maxWidth, [
                strings.earnMoreTab,
                strings.giftTab,
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pills(BuildContext context, double width, List<String> labels) {
    if (width <= _gap) return const SizedBox.shrink();
    final giftWidth = math.min(_width(context, labels[1]), width * .38);
    final challengesWidth = math.min(
      _width(context, labels[0]),
      width - giftWidth - _gap,
    );
    final widths = [challengesWidth, giftWidth];
    return SizedBox(
      width: widths[0] + widths[1] + _gap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              _track(widths[0]),
              const SizedBox(width: _gap),
              _track(widths[1]),
            ],
          ),
          AnimatedPositionedDirectional(
            duration: AppMotion.duration(context, AppMotion.standard),
            curve: AppMotion.curve,
            start: selected == RewardsTab.challenges ? 0 : widths[0] + _gap,
            top: (_height - _pillHeight) / 2,
            width: widths[selected.index],
            height: _pillHeight,
            child: _pill(AppColors.catalogBlue),
          ),
          Row(
            children: [
              _tab(RewardsTab.challenges, labels[0], widths[0]),
              const SizedBox(width: _gap),
              _tab(RewardsTab.gift, labels[1], widths[1]),
            ],
          ),
        ],
      ),
    );
  }

  double _width(BuildContext context, String label) {
    final painter = TextPainter(
      text: TextSpan(text: label, style: _text),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final width = painter.width + 29;
    painter.dispose();
    return width;
  }

  Widget _track(double width) => SizedBox(
    width: width,
    height: _pillHeight,
    child: _pill(AppColors.catalogBackground),
  );

  Widget _tab(RewardsTab tab, String label, double width) => SizedBox(
    width: width,
    height: _height,
    child: Semantics(
      selected: selected == tab,
      child: PressScale(
        child: TextButton(
          onPressed: () => onSelected(tab),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            foregroundColor: selected == tab
                ? Colors.white
                : AppColors.catalogText,
            textStyle: selected == tab
                ? _text
                : _text.copyWith(fontWeight: FontWeight.w400),
          ),
          child: Text(label, textAlign: TextAlign.center),
        ),
      ),
    ),
  );

  Widget _pill(Color color) => DecoratedBox(
    decoration: ShapeDecoration(
      color: color,
      shape: const StadiumBorder(
        side: BorderSide(color: Colors.white, width: 2),
      ),
    ),
  );
}
