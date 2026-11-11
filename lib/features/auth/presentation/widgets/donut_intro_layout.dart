import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';
import 'donut_artwork.dart';

class DonutIntroLayout extends StatelessWidget {
  const DonutIntroLayout.onboarding({required this.footer, super.key})
    : welcome = false;

  const DonutIntroLayout.welcome({required this.footer, super.key})
    : welcome = true;

  final Widget footer;
  final bool welcome;

  @override
  Widget build(BuildContext context) {
    final background = welcome
        ? AppColors.welcomeBackground
        : AppColors.authBackground;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: background,
        body: LayoutBuilder(
          builder: (_, constraints) => _body(constraints.maxHeight, background),
        ),
      ),
    );
  }

  Widget _body(double height, Color background) {
    final artHeight = height * (welcome ? .78 : .56);
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: artHeight,
                child: DonutArtwork(
                  scrollColumns: welcome,
                  background: background,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _safeFooter(height),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _safeFooter(double height) => SafeArea(
    top: false,
    minimum: EdgeInsets.only(
      left: welcome ? 32 : 0,
      right: welcome ? 32 : 0,
      bottom: welcome ? height * .078 : 8,
    ),
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: welcome ? 456 : 520),
      child: footer,
    ),
  );
}
