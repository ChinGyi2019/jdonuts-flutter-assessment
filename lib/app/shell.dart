import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../core/theme/app_motion.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/press_scale.dart';
import '../l10n/app_localizations.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: navigationShell.currentIndex == 0,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop && navigationShell.currentIndex != 0) {
        navigationShell.goBranch(0);
      }
    },
    child: Scaffold(
      body: NotificationListener<NavigationNotification>(
        onNotification: (notification) {
          if (navigationShell.currentIndex != 0 && !notification.canHandlePop) {
            const NavigationNotification(canHandlePop: true).dispatch(context);
            return true;
          }
          return false;
        },
        child: navigationShell,
      ),
      bottomNavigationBar: _NavigationBar(
        selected: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    ),
  );
}

class _NavigationBar extends StatelessWidget {
  const _NavigationBar({required this.selected, required this.onTap});

  final int selected;
  final ValueChanged<int> onTap;

  static const _barHeight = 64.0;
  static const _pillHeight = 39.0;
  static const _pillInset = 2.0;
  static const _iconSize = 20.0;
  static const _labelGap = 4.0;
  static const _labelStyle = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static const _icons = [
    LucideIcons.house,
    LucideIcons.crown,
    LucideIcons.donut,
    LucideIcons.wallet,
    LucideIcons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final labels = [
      strings.home,
      strings.rewards,
      strings.discover,
      strings.orders,
      strings.settings,
    ];
    return ColoredBox(
      color: AppColors.catalogBackground,
      child: Stack(
        children: [
          Positioned.fill(
            top: _barHeight / 2,
            child: const ColoredBox(color: AppColors.catalogPink),
          ),
          _panel(labels),
        ],
      ),
    );
  }

  Widget _panel(List<String> labels) => Center(
    heightFactor: 1,
    child: Container(
      constraints: const BoxConstraints(maxWidth: 600),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.catalogBlue,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        border: const Border(
          top: BorderSide(color: Colors.white, width: 1.5),
          left: BorderSide(color: Colors.white, width: 1.5),
          right: BorderSide(color: Colors.white, width: 1.5),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x260F172A),
            blurRadius: 22,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        left: false,
        right: false,
        child: SizedBox(
          height: _barHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final insets = MediaQuery.paddingOf(context);
              final panelWidth = constraints.maxWidth;
              final panelInset =
                  (MediaQuery.sizeOf(context).width - panelWidth) / 2;
              final padding = math.max(
                6.0,
                math.max(insets.left, insets.right) - panelInset,
              );
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: _layout(
                  context,
                  labels,
                  math.max(0.0, panelWidth - 2 * padding),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );

  Widget _layout(BuildContext context, List<String> labels, double width) {
    final active = _activeWidth(context, labels[selected], width);
    final inactive = (width - active) / (_icons.length - 1);
    final duration = AppMotion.duration(context, AppMotion.standard);
    // Recreate implicit animations if reduced motion is toggled mid-flight.
    final motionKey = ValueKey(duration);
    double start(int index) =>
        index <= selected ? index * inactive : (index - 1) * inactive + active;
    return Stack(
      children: [
        AnimatedPositionedDirectional(
          key: motionKey,
          duration: duration,
          curve: AppMotion.curve,
          start: start(selected) + _pillInset,
          top: (_barHeight - _pillHeight) / 2,
          height: _pillHeight,
          width: math.max(0.0, active - 2 * _pillInset),
          child: const IgnorePointer(
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: AppColors.catalogPink,
                shape: StadiumBorder(side: BorderSide(color: Colors.white)),
              ),
            ),
          ),
        ),
        for (var index = 0; index < _icons.length; index++)
          AnimatedPositionedDirectional(
            key: ValueKey((index, duration)),
            duration: duration,
            curve: AppMotion.curve,
            start: start(index),
            top: 4,
            bottom: 4,
            width: index == selected ? active : inactive,
            child: _item(index, labels[index], duration),
          ),
      ],
    );
  }

  double _activeWidth(BuildContext context, String label, double width) {
    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: DefaultTextStyle.of(context).style.merge(_labelStyle),
      ),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    final naturalWidth =
        painter.width + _iconSize + _labelGap + 26 + 2 * _pillInset;
    painter.dispose();
    final equalWidth = width / _icons.length;
    final limit = math.max(equalWidth, width - 44 * (_icons.length - 1));
    return naturalWidth.clamp(equalWidth, limit);
  }

  Widget _item(int index, String label, Duration duration) => Semantics(
    button: true,
    selected: index == selected,
    label: label,
    onTap: () => onTap(index),
    excludeSemantics: true,
    child: PressScale(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(index),
          borderRadius: BorderRadius.circular(26),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TweenAnimationBuilder<double>(
              duration: duration,
              curve: AppMotion.curve,
              tween: Tween(end: index == selected ? 1.0 : 0.0),
              child: Icon(_icons[index], color: Colors.white, size: _iconSize),
              builder: (context, progress, icon) =>
                  _itemContent(progress, icon!, label),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _itemContent(double progress, Widget icon, String label) {
    const labelFade = Interval(.25, .85, curve: Curves.easeOut);
    final lift = 6 * progress * (1 - progress);
    return LayoutBuilder(
      builder: (context, constraints) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.translate(
            offset: Offset(0, -lift),
            child: Transform.scale(
              scale: 1 + .08 * progress,
              child: SizedBox(
                width: math.min(constraints.maxWidth, _iconSize),
                child: FittedBox(fit: BoxFit.scaleDown, child: icon),
              ),
            ),
          ),
          if (progress > 0)
            Flexible(
              child: ClipRect(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: progress,
                  child: Opacity(
                    opacity: labelFade.transform(progress),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: _labelGap,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(label, maxLines: 1, style: _labelStyle),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
