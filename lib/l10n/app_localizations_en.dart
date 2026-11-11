// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'J\'Donuts';

  @override
  String get onboardingTitle => 'Round food for every mood';

  @override
  String get onboardingPending => 'Sign in and registration are coming soon.';

  @override
  String get home => 'Home';

  @override
  String get rewards => 'Reward';

  @override
  String get discover => 'Discover';

  @override
  String get orders => 'Orders';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Log out';

  @override
  String get loggingOut => 'Logging out…';

  @override
  String get logoutError => 'Couldn’t log out. Try again.';

  @override
  String get profileLoading => 'Loading your member profile';

  @override
  String profilePoints(int points) {
    final intl.NumberFormat pointsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String pointsString = pointsNumberFormat.format(points);

    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '$pointsString reward points',
      one: '$pointsString reward point',
    );
    return '$_temp0';
  }

  @override
  String get placeholder => 'Coming soon';

  @override
  String get sessionError => 'Could not restore your session.';

  @override
  String get retry => 'Try again';

  @override
  String get product => 'Product';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get getStarted => 'LET’S GET STARTED';

  @override
  String get logIn => 'Log In';

  @override
  String get loginPrompt => 'Already have an account?';

  @override
  String get register => 'Register';

  @override
  String get phoneTitle => 'Enter your phone number';

  @override
  String get phoneLabel => 'Mobile number';

  @override
  String get phoneError => 'Enter a valid Myanmar phone number.';

  @override
  String get phonePrefixError => 'Phone number must start with 09 or 9.';

  @override
  String get continueLabel => 'CONTINUE';

  @override
  String get otpTitle => 'Verify your number';

  @override
  String get otpLabel => 'Verification code';

  @override
  String get otpError => 'Incorrect code. Try again.';

  @override
  String get otpLocked => 'Too many attempts. Wait until you can resend.';

  @override
  String get resend => 'Resend';

  @override
  String resendCountdown(String time) {
    return 'resend in $time min';
  }

  @override
  String get unknownPhone => 'Number not registered.';

  @override
  String get nameTitle => 'What’s your name?';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get nameError => 'Use 1–50 letters and spaces.';

  @override
  String get birthTitle => 'What’s your date of birth?';

  @override
  String get month => 'Month';

  @override
  String get day => 'Day';

  @override
  String get year => 'Year';

  @override
  String get birthdayPickerTitle => 'Select your Birthday';

  @override
  String get birthdayPickerSelect => 'SELECT';

  @override
  String get loadingCatalog => 'Loading catalog';

  @override
  String get dateError => 'Enter a valid date; you must be at least 13.';

  @override
  String get welcomeTitle => 'Welcome to the world of J’donuts';

  @override
  String get explore => 'LET’S EXPLORE';

  @override
  String get notAvailable => 'Coming soon';

  @override
  String get terms => 'Terms of Use';

  @override
  String get privacy => 'Privacy Policy';

  @override
  String social(String provider) {
    return 'Continue with $provider';
  }

  @override
  String get authError => 'Something went wrong. Please try again.';

  @override
  String get legalPrefix =>
      'By continuing, you acknowledge that you have read and agree to our';

  @override
  String get legalAnd => 'and';

  @override
  String otpSent(String phone) {
    return 'We’ve sent 6 digit OTP to $phone';
  }

  @override
  String get otpResendPrompt => 'Didn’t receive the code?';

  @override
  String get seasonalSpecials => 'Seasonal specials';

  @override
  String get popular => 'Popular 🔥';

  @override
  String get orderAgain => 'Order again';

  @override
  String get offlineCatalog => 'You’re offline';

  @override
  String memberTier(String tier) {
    return '$tier member';
  }

  @override
  String tierPointsRemaining(String points, String tier) {
    return '$points points left to become $tier Member';
  }

  @override
  String notifications(int count) {
    return '$count notifications';
  }

  @override
  String get emptyMember => 'Member profile unavailable.';

  @override
  String get emptyBanners => 'No offers right now.';

  @override
  String get bannerLoadError => 'Could not load offers.';

  @override
  String get memberLoadError => 'Could not load your member profile.';

  @override
  String get emptyProducts => 'No products in this section yet.';

  @override
  String get productSectionError => 'Could not load this section.';

  @override
  String get emptyShops => 'No nearby shops to show.';

  @override
  String get shopLoadError => 'Could not load nearby shops.';

  @override
  String get refreshError => 'Could not refresh the catalog.';

  @override
  String nearbyShops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'There are $count J’Donut shops near you.',
      one: 'There is 1 J’Donut shop near you.',
    );
    return '$_temp0 😊';
  }

  @override
  String get nearbyShopsTitle => 'Nearby shops';

  @override
  String get exploreNow => 'EXPLORE NOW';

  @override
  String get orderOnline => 'Order Online';

  @override
  String discountBadge(int percent) {
    return '$percent% off';
  }

  @override
  String moreInSection(String section) {
    return 'More in $section';
  }

  @override
  String get newProduct => 'New';

  @override
  String get productDescriptionTitle => 'What’s this?';

  @override
  String get addToCart => 'ADD TO CART';

  @override
  String cartItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cart, $count items',
      one: 'Cart, 1 item',
      zero: 'Cart, empty',
    );
    return '$_temp0';
  }

  @override
  String get addedToCart => 'Added to cart';

  @override
  String priceMmk(String amount) {
    return '$amount MMK';
  }

  @override
  String get decreaseQuantity => 'Decrease quantity';

  @override
  String get increaseQuantity => 'Increase quantity';

  @override
  String quantityLabel(int count) {
    return 'Quantity $count';
  }

  @override
  String get productLoadError => 'Could not load this product.';

  @override
  String get productNotFound => 'This product could not be found.';

  @override
  String get rewardsTitle => 'J’ Donuts Rewards';

  @override
  String get rewardsBadge => 'Rewards';

  @override
  String get replayRewards => 'Replay rewards animations';

  @override
  String get replayChallenge => 'Replay challenge progress';

  @override
  String get totalRewardPoints => 'Total points';

  @override
  String rewardsPointsTotal(int points) {
    final intl.NumberFormat pointsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String pointsString = pointsNumberFormat.format(points);

    return '$pointsString';
  }

  @override
  String get currentRewardTier => 'You’re here now';

  @override
  String get upcomingRewardTier => 'You’ll be here soon';

  @override
  String nextRewardTier(int points, String tier) {
    final intl.NumberFormat pointsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String pointsString = pointsNumberFormat.format(points);

    return '$pointsString pts Remaining\nto become $tier';
  }

  @override
  String get earnMoreTab => 'Eat more earn more';

  @override
  String get giftTab => 'Gift';

  @override
  String get emptyGifts => 'No gifts yet';

  @override
  String get emptyChallenges => 'No challenges right now.';

  @override
  String get rewardsLoading => 'Loading rewards';

  @override
  String get rewardsLoadError => 'Could not load rewards.';

  @override
  String get earnReward => 'EARN';

  @override
  String challengeQuantity(int completed, int target) {
    return '$completed/$target';
  }

  @override
  String challengePoints(int points) {
    final intl.NumberFormat pointsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String pointsString = pointsNumberFormat.format(points);

    return '$pointsString pts';
  }

  @override
  String get language => 'Language';

  @override
  String get languageSaveError => 'Could not save language. Try again.';
}
