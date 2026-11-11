import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class HomeBadge extends StatelessWidget {
  const HomeBadge(this.label, {this.small = false, super.key});

  final String label;
  final bool small;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: AppColors.catalogOrange,
      border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(40),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 12,
        vertical: small ? 3 : 6,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: small ? 11 : 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}
