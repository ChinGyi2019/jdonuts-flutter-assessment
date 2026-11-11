import 'package:flutter/material.dart';

abstract final class AppColors {
  static const cream = Color(0xFFFFF9F0);
  static const brown = Color(0xFF4C251B);
  static const pink = Color(0xFFF2A9A5);
  static const white = Colors.white;
  static const muted = Color(0xFF8C746D);
  static const catalogBackground = Color(0xFFEBEEEE);
  static const catalogText = Color(0xFF202933);
  static const catalogMuted = Color(0xFF65737E);
  static const catalogOrange = Color(0xFFFF7D21);
  static const catalogBlue = Color(0xFF51C9E5);
  static const catalogPink = Color(0xFFF4509C);
  static const catalogPeach = Color(0xFFFDEAD9);
  static const rewardsText = Color(0xFF1B1C1C);
  static const rewardsDisabled = Color(0xFFE5E5E5);
  static const welcomeBackground = Color(0xFFFAEDF3);
  static const authBackground = Color(0xFFFCEEF4);
  static const authText = Color(0xFF293039);
  static const authMuted = Color(0xFF8996A4);
  static const authPink = Color(0xFFF14F9C);
  static const authTimer = Color(0xFFAC2565);
  static const authBlue = Color(0xFF58C9E3);
  static const authBlueLight = Color(0xFFACE4F2);
  static const authPeach = Color(0xFFFFE3D7);
  static const authLavender = Color(0xFFDAD5F1);
}

abstract final class AppSpacing {
  static const small = 8.0;
  static const medium = 16.0;
  static const large = 24.0;
}

abstract final class AppTheme {
  static const fontFamily = 'Poppins';

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brown,
      surface: AppColors.cream,
    ),
    scaffoldBackgroundColor: AppColors.cream,
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.brown,
      ),
      bodyMedium: TextStyle(color: AppColors.brown),
    ).apply(fontFamily: fontFamily),
  );
}
