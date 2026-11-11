import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/viewmodels/auth_state.dart';
import '../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../features/auth/presentation/views/auth_screen.dart';
import '../features/auth/presentation/views/welcome_screen.dart';
import '../features/home/presentation/views/home_screen.dart';
import '../features/product/presentation/views/product_screen.dart';
import '../features/product/presentation/widgets/product_artwork.dart';
import '../features/rewards/presentation/views/rewards_screen.dart';
import '../features/settings/presentation/views/settings_screen.dart';
import 'screens.dart';
import 'session.dart';
import 'shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(sessionProvider, (_, _) => refresh.value++);
  final router = GoRouter(
    initialLocation: '/home',
    refreshListenable: refresh,
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      final location = state.uri;
      final isLoading = location.path == '/loading';
      final isOnboarding = location.path == '/onboarding';
      final isWelcome = location.path == '/welcome';
      final intended = location.queryParameters['from'];
      if (session.isLoading || session.hasError) {
        if (isLoading) return null;
        return Uri(
          path: '/loading',
          queryParameters: {'from': location.toString()},
        ).toString();
      }
      if (session.value == null) {
        if (isOnboarding) return null;
        if (isWelcome) {
          final registration = ref.read(authViewModelProvider);
          return registration.step == AuthStep.welcome &&
                  registration.member != null
              ? null
              : '/onboarding';
        }
        final target = isLoading ? intended : location.toString();
        return Uri(
          path: '/onboarding',
          queryParameters: target == null ? null : {'from': target},
        ).toString();
      }
      if (isWelcome) return '/home';
      if (isLoading || isOnboarding) return _safeDestination(intended);
      return null;
    },
    routes: [
      GoRoute(
        path: '/loading',
        builder: (_, _) => const SessionLoadingScreen(),
      ),
      GoRoute(path: '/onboarding', builder: (_, _) => const AuthScreen()),
      GoRoute(
        path: '/welcome',
        pageBuilder: (_, state) => NoTransitionPage(
          key: state.pageKey,
          child: Consumer(
            builder: (_, ref, _) {
              final registration = ref.watch(authViewModelProvider);
              return WelcomeScreen(
                loading: registration.loading,
                hasError: registration.error != null,
                onExplore: ref
                    .read(authViewModelProvider.notifier)
                    .finishWelcome,
              );
            },
          ),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/rewards',
                builder: (_, _) => const RewardsScreen(),
              ),
            ],
          ),
          _branch('/discover', AppPage.discover),
          _branch('/orders', AppPage.orders),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, _) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/product/:id',
        pageBuilder: (context, state) {
          final child = ProductScreen(
            id: state.pathParameters['id']!,
            selection: switch (state.extra) {
              final ProductSelection selection => selection,
              _ => null,
            },
          );
          return MediaQuery.disableAnimationsOf(context)
              ? NoTransitionPage(key: state.pageKey, child: child)
              : MaterialPage(key: state.pageKey, child: child);
        },
      ),
    ],
    errorBuilder: (_, _) => const NotFoundScreen(),
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});

String _safeDestination(String? value) {
  final uri = value == null ? null : Uri.tryParse(value);
  if (uri == null ||
      uri.hasAuthority ||
      uri.hasScheme ||
      !uri.path.startsWith('/') ||
      uri.path == '/loading' ||
      uri.path == '/onboarding' ||
      uri.path == '/welcome') {
    return '/home';
  }
  return uri.toString();
}

StatefulShellBranch _branch(String path, AppPage page) => StatefulShellBranch(
  routes: [
    GoRoute(
      path: path,
      builder: (_, _) => PlaceholderPage(page: page),
    ),
  ],
);
