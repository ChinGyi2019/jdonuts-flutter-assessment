import 'package:flutter/material.dart';

abstract final class AppMotion {
  static const standard = Duration(milliseconds: 250);
  static const press = Duration(milliseconds: 100);
  static const entrance = Duration(milliseconds: 650);
  static const stagger = Duration(milliseconds: 100);
  static const donutFloat = Duration(seconds: 9);
  static const welcomeScroll = Duration(seconds: 32);
  static const bannerInterval = Duration(seconds: 5);
  static const bannerSlide = Duration(milliseconds: 420);
  static const shimmer = Duration(milliseconds: 1200);
  static const rewardsIntro = Duration(milliseconds: 1500);
  static const rewardsArtwork = Duration(milliseconds: 820);
  static const rewardsListDelay = Duration(milliseconds: 380);
  static const rewardsEarnCue = Duration(milliseconds: 640);
  static const rewardsCountCurve = Curves.easeOutQuart;
  static const rewardsPopCurve = Curves.easeOutBack;
  static const curve = Curves.easeInOut;
  static const entranceFade = Curves.easeOutCubic;
  static const entranceSlide = Curves.easeOutBack;

  static Duration duration(BuildContext context, Duration value) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : value;
}
