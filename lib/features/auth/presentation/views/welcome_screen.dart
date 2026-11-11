import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/entrance.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/auth_visuals.dart';
import '../widgets/donut_intro_layout.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    required this.onExplore,
    this.loading = false,
    this.hasError = false,
    super.key,
  });

  final VoidCallback onExplore;
  final bool loading;
  final bool hasError;

  @override
  Widget build(BuildContext context) =>
      DonutIntroLayout.welcome(footer: _footer(context));

  Widget _footer(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Entrance(
          order: 5,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              strings.welcomeTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.catalogText,
                fontSize: 29,
                fontWeight: FontWeight.w800,
                height: 1.55,
                letterSpacing: -.65,
              ),
            ),
          ),
        ),
        const SizedBox(height: 34),
        if (hasError) Text(strings.authError, textAlign: TextAlign.center),
        Entrance(
          order: 6,
          child: AuthPrimaryButton(
            label: strings.explore,
            loading: loading,
            onPressed: onExplore,
          ),
        ),
      ],
    );
  }
}

@Preview(name: 'Welcome', size: Size(390, 844))
Widget welcomePreview() => MaterialApp(
  theme: AppTheme.light,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: WelcomeScreen(onExplore: () {}),
);
