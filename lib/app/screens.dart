import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'session.dart';

enum AppPage { discover, orders }

class SessionLoadingScreen extends ConsumerWidget {
  const SessionLoadingScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: session.hasError
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(strings.sessionError),
                  TextButton(
                    onPressed: () => ref.invalidate(sessionProvider),
                    child: Text(strings.retry),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}

class OnboardingPlaceholder extends StatelessWidget {
  const OnboardingPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.catalogBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  strings.onboardingTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.catalogText,
                    fontWeight: FontWeight.w800,
                    height: 2,
                    letterSpacing: -.65,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.medium),
                Text(strings.onboardingPending, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({required this.page, super.key});
  final AppPage page;
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final title = switch (page) {
      AppPage.discover => strings.discover,
      AppPage.orders => strings.orders,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.catalogBackground,
      ),
      backgroundColor: AppColors.catalogBackground,
      body: Center(child: Text(strings.placeholder)),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Text(AppLocalizations.of(context)!.pageNotFound)),
  );
}
