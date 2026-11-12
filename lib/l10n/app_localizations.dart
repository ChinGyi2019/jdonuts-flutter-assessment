import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_my.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('my'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'J\'Donuts'**
  String get appTitle;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Round food for every mood'**
  String get onboardingTitle;

  /// No description provided for @onboardingPending.
  ///
  /// In en, this message translates to:
  /// **'Sign in and registration are coming soon.'**
  String get onboardingPending;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @rewards.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get rewards;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out of your account?'**
  String get logoutConfirmationTitle;

  /// No description provided for @logoutConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'You’ll need to sign in again to access your account.'**
  String get logoutConfirmationMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loggingOut.
  ///
  /// In en, this message translates to:
  /// **'Logging out…'**
  String get loggingOut;

  /// No description provided for @logoutError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t log out. Try again.'**
  String get logoutError;

  /// No description provided for @profileLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading your member profile'**
  String get profileLoading;

  /// No description provided for @profilePoints.
  ///
  /// In en, this message translates to:
  /// **'{points, plural, one{{points} reward point} other{{points} reward points}}'**
  String profilePoints(int points);

  /// No description provided for @placeholder.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get placeholder;

  /// No description provided for @sessionError.
  ///
  /// In en, this message translates to:
  /// **'Could not restore your session.'**
  String get sessionError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'LET’S GET STARTED'**
  String get getStarted;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @loginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get loginPrompt;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @phoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneTitle;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get phoneLabel;

  /// No description provided for @phoneError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Myanmar phone number.'**
  String get phoneError;

  /// No description provided for @phonePrefixError.
  ///
  /// In en, this message translates to:
  /// **'Phone number must start with 09 or 9.'**
  String get phonePrefixError;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get continueLabel;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your number'**
  String get otpTitle;

  /// No description provided for @otpLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get otpLabel;

  /// No description provided for @otpError.
  ///
  /// In en, this message translates to:
  /// **'Incorrect code. Try again.'**
  String get otpError;

  /// No description provided for @otpLocked.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait until you can resend.'**
  String get otpLocked;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @resendCountdown.
  ///
  /// In en, this message translates to:
  /// **'resend in {time} min'**
  String resendCountdown(String time);

  /// No description provided for @unknownPhone.
  ///
  /// In en, this message translates to:
  /// **'Number not registered.'**
  String get unknownPhone;

  /// No description provided for @nameTitle.
  ///
  /// In en, this message translates to:
  /// **'What’s your name?'**
  String get nameTitle;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @nameError.
  ///
  /// In en, this message translates to:
  /// **'Use 1–50 letters and spaces.'**
  String get nameError;

  /// No description provided for @birthTitle.
  ///
  /// In en, this message translates to:
  /// **'What’s your date of birth?'**
  String get birthTitle;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @birthdayPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Select your Birthday'**
  String get birthdayPickerTitle;

  /// No description provided for @birthdayPickerSelect.
  ///
  /// In en, this message translates to:
  /// **'SELECT'**
  String get birthdayPickerSelect;

  /// No description provided for @loadingCatalog.
  ///
  /// In en, this message translates to:
  /// **'Loading catalog'**
  String get loadingCatalog;

  /// No description provided for @dateError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid date; you must be at least 13.'**
  String get dateError;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the world of J’donuts'**
  String get welcomeTitle;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'LET’S EXPLORE'**
  String get explore;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get notAvailable;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get terms;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy;

  /// No description provided for @social.
  ///
  /// In en, this message translates to:
  /// **'Continue with {provider}'**
  String social(String provider);

  /// No description provided for @authError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get authError;

  /// No description provided for @legalPrefix.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you acknowledge that you have read and agree to our'**
  String get legalPrefix;

  /// No description provided for @legalAnd.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get legalAnd;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'We’ve sent 6 digit OTP to {phone}'**
  String otpSent(String phone);

  /// No description provided for @otpResendPrompt.
  ///
  /// In en, this message translates to:
  /// **'Didn’t receive the code?'**
  String get otpResendPrompt;

  /// No description provided for @seasonalSpecials.
  ///
  /// In en, this message translates to:
  /// **'Seasonal specials'**
  String get seasonalSpecials;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular 🔥'**
  String get popular;

  /// No description provided for @orderAgain.
  ///
  /// In en, this message translates to:
  /// **'Order again'**
  String get orderAgain;

  /// No description provided for @offlineCatalog.
  ///
  /// In en, this message translates to:
  /// **'You’re offline'**
  String get offlineCatalog;

  /// No description provided for @memberTier.
  ///
  /// In en, this message translates to:
  /// **'{tier} member'**
  String memberTier(String tier);

  /// No description provided for @tierPointsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{points} points left to become {tier} Member'**
  String tierPointsRemaining(String points, String tier);

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'{count} notifications'**
  String notifications(int count);

  /// No description provided for @emptyMember.
  ///
  /// In en, this message translates to:
  /// **'Member profile unavailable.'**
  String get emptyMember;

  /// No description provided for @emptyBanners.
  ///
  /// In en, this message translates to:
  /// **'No offers right now.'**
  String get emptyBanners;

  /// No description provided for @bannerLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load offers.'**
  String get bannerLoadError;

  /// No description provided for @memberLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load your member profile.'**
  String get memberLoadError;

  /// No description provided for @emptyProducts.
  ///
  /// In en, this message translates to:
  /// **'No products in this section yet.'**
  String get emptyProducts;

  /// No description provided for @productSectionError.
  ///
  /// In en, this message translates to:
  /// **'Could not load this section.'**
  String get productSectionError;

  /// No description provided for @emptyShops.
  ///
  /// In en, this message translates to:
  /// **'No nearby shops to show.'**
  String get emptyShops;

  /// No description provided for @shopLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load nearby shops.'**
  String get shopLoadError;

  /// No description provided for @refreshError.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh the catalog.'**
  String get refreshError;

  /// No description provided for @nearbyShops.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{There is 1 J’Donut shop near you.} other{There are {count} J’Donut shops near you.}} 😊'**
  String nearbyShops(int count);

  /// No description provided for @nearbyShopsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby shops'**
  String get nearbyShopsTitle;

  /// No description provided for @exploreNow.
  ///
  /// In en, this message translates to:
  /// **'EXPLORE NOW'**
  String get exploreNow;

  /// No description provided for @orderOnline.
  ///
  /// In en, this message translates to:
  /// **'Order Online'**
  String get orderOnline;

  /// No description provided for @discountBadge.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off'**
  String discountBadge(int percent);

  /// No description provided for @moreInSection.
  ///
  /// In en, this message translates to:
  /// **'More in {section}'**
  String moreInSection(String section);

  /// No description provided for @newProduct.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newProduct;

  /// No description provided for @productDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'What’s this?'**
  String get productDescriptionTitle;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'ADD TO CART'**
  String get addToCart;

  /// No description provided for @cartItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Cart, empty} =1{Cart, 1 item} other{Cart, {count} items}}'**
  String cartItemCount(int count);

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get addedToCart;

  /// No description provided for @priceMmk.
  ///
  /// In en, this message translates to:
  /// **'{amount} MMK'**
  String priceMmk(String amount);

  /// No description provided for @decreaseQuantity.
  ///
  /// In en, this message translates to:
  /// **'Decrease quantity'**
  String get decreaseQuantity;

  /// No description provided for @increaseQuantity.
  ///
  /// In en, this message translates to:
  /// **'Increase quantity'**
  String get increaseQuantity;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity {count}'**
  String quantityLabel(int count);

  /// No description provided for @productLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load this product.'**
  String get productLoadError;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'This product could not be found.'**
  String get productNotFound;

  /// No description provided for @rewardsTitle.
  ///
  /// In en, this message translates to:
  /// **'J’ Donuts Rewards'**
  String get rewardsTitle;

  /// No description provided for @rewardsBadge.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewardsBadge;

  /// No description provided for @replayRewards.
  ///
  /// In en, this message translates to:
  /// **'Replay rewards animations'**
  String get replayRewards;

  /// No description provided for @replayChallenge.
  ///
  /// In en, this message translates to:
  /// **'Replay challenge progress'**
  String get replayChallenge;

  /// No description provided for @totalRewardPoints.
  ///
  /// In en, this message translates to:
  /// **'Total points'**
  String get totalRewardPoints;

  /// No description provided for @rewardsPointsTotal.
  ///
  /// In en, this message translates to:
  /// **'{points}'**
  String rewardsPointsTotal(int points);

  /// No description provided for @currentRewardTier.
  ///
  /// In en, this message translates to:
  /// **'You’re here now'**
  String get currentRewardTier;

  /// No description provided for @upcomingRewardTier.
  ///
  /// In en, this message translates to:
  /// **'You’ll be here soon'**
  String get upcomingRewardTier;

  /// No description provided for @nextRewardTier.
  ///
  /// In en, this message translates to:
  /// **'{points} pts Remaining\nto become {tier}'**
  String nextRewardTier(int points, String tier);

  /// No description provided for @earnMoreTab.
  ///
  /// In en, this message translates to:
  /// **'Eat more earn more'**
  String get earnMoreTab;

  /// No description provided for @giftTab.
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get giftTab;

  /// No description provided for @emptyGifts.
  ///
  /// In en, this message translates to:
  /// **'No gifts yet'**
  String get emptyGifts;

  /// No description provided for @emptyChallenges.
  ///
  /// In en, this message translates to:
  /// **'No challenges right now.'**
  String get emptyChallenges;

  /// No description provided for @rewardsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading rewards'**
  String get rewardsLoading;

  /// No description provided for @rewardsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load rewards.'**
  String get rewardsLoadError;

  /// No description provided for @earnReward.
  ///
  /// In en, this message translates to:
  /// **'EARN'**
  String get earnReward;

  /// No description provided for @challengeQuantity.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{target}'**
  String challengeQuantity(int completed, int target);

  /// No description provided for @challengePoints.
  ///
  /// In en, this message translates to:
  /// **'{points} pts'**
  String challengePoints(int points);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save language. Try again.'**
  String get languageSaveError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'my'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'my':
      return AppLocalizationsMy();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
