import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../../../l10n/app_localizations.dart';

class ProductQuantity extends StatelessWidget {
  const ProductQuantity({
    required this.quantity,
    required this.onChange,
    super.key,
  });

  static const minimum = 1;

  final int quantity;
  final ValueChanged<int> onChange;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.catalogBackground,
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(44),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _button(
              LucideIcons.minus,
              strings.decreaseQuantity,
              quantity <= minimum ? null : () => onChange(quantity - 1),
            ),
            _count(context, strings.quantityLabel(quantity)),
            _button(
              LucideIcons.plus,
              strings.increaseQuantity,
              () => onChange(quantity + 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _count(BuildContext context, String label) => Semantics(
    label: label,
    liveRegion: true,
    excludeSemantics: true,
    child: Container(
      constraints: const BoxConstraints(minWidth: 50),
      alignment: Alignment.center,
      child: ClipRect(
        child: AnimatedSwitcher(
          duration: AppMotion.duration(context, AppMotion.standard),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween(begin: const Offset(0, .44), end: Offset.zero)
                  .chain(CurveTween(curve: AppMotion.entranceFade))
                  .animate(animation),
              child: child,
            ),
          ),
          child: Text(
            '$quantity',
            key: ValueKey(quantity),
            style: const TextStyle(
              color: AppColors.catalogText,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    ),
  );

  Widget _button(IconData icon, String tooltip, VoidCallback? onPressed) =>
      PressScale(
        child: IconButton(
          tooltip: tooltip,
          onPressed: onPressed,
          icon: CircleAvatar(
            radius: 16,
            backgroundColor: onPressed == null
                ? AppColors.catalogBlue.withValues(alpha: .55)
                : AppColors.catalogBlue,
            child: Icon(icon, size: 21, color: Colors.white),
          ),
        ),
      );
}
