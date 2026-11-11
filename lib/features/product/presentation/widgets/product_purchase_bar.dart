import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../../../l10n/app_localizations.dart';

class ProductPurchaseBar extends StatelessWidget {
  const ProductPurchaseBar({
    required this.total,
    required this.onAdd,
    super.key,
  });

  final String total;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return PressScale(
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.catalogBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        onPressed: () {
          onAdd();
          _showConfirmation(context, strings.addedToCart);
        },
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 2,
          children: [
            Text(strings.addToCart),
            const SizedBox(
              height: 20,
              child: VerticalDivider(width: 1, color: Color(0x99FFFFFF)),
            ),
            Text(total),
          ],
        ),
      ),
    );
  }

  void _showConfirmation(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              const Icon(LucideIcons.circleCheck, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
  }
}
