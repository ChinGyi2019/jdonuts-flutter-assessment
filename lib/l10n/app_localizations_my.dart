// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Burmese (`my`).
class AppLocalizationsMy extends AppLocalizations {
  AppLocalizationsMy([String locale = 'my']) : super(locale);

  @override
  String get appTitle => 'J\'Donuts';

  @override
  String get onboardingTitle =>
      'စိတ်ကြိုက်ရွေးချယ် အဝင်ပြေဖို့ ဝိုင်းဝိုင်းလေးတွေ စားကြစို့';

  @override
  String get onboardingPending =>
      'အကောင့်ဝင်ခြင်းနှင့် အကောင့်သစ်ဖွင့်ခြင်းများကို မကြာမီ အသုံးပြုနိုင်တော့မည်။';

  @override
  String get home => 'ပင်မ';

  @override
  String get rewards => 'လက်ဆောင်';

  @override
  String get discover => 'ရှာဖွေရန်';

  @override
  String get orders => 'အမှာစာများ';

  @override
  String get settings => 'ဆက်တင်များ';

  @override
  String get logout => 'အကောင့်ထွက်ရန်';

  @override
  String get loggingOut => 'အကောင့်ထွက်နေသည်…';

  @override
  String get logoutError => 'အကောင့်ထွက်၍ မရပါ။ ထပ်မံကြိုးစားပါ။';

  @override
  String get profileLoading => 'အဖွဲ့ဝင် ပရိုဖိုင်ကို ရယူနေသည်';

  @override
  String profilePoints(int points) {
    final intl.NumberFormat pointsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String pointsString = pointsNumberFormat.format(points);

    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '$pointsString ရမှတ်',
      one: '$pointsString ရမှတ်',
    );
    return '$_temp0';
  }

  @override
  String get placeholder => 'မကြာမီ လာမည်';

  @override
  String get sessionError => 'ယခင် အသုံးပြုမှုအား ပြန်လည်ရယူ၍ မရပါ။';

  @override
  String get retry => 'ထပ်မံကြိုးစားရန်';

  @override
  String get product => 'မုန့်အမျိုးအစား';

  @override
  String get pageNotFound => 'စာမျက်နှာ ရှာမတွေ့ပါ';

  @override
  String get getStarted => 'စတင်လိုက်ရအောင်';

  @override
  String get logIn => 'အကောင့်ဝင်ရန်';

  @override
  String get loginPrompt => 'အကောင့်ရှိပြီးသားလား။';

  @override
  String get register => 'အကောင့်သစ်ဖွင့်ရန်';

  @override
  String get phoneTitle => 'သင့်ဖုန်းနံပါတ် ထည့်ပါ';

  @override
  String get phoneLabel => 'ဖုန်းနံပါတ်';

  @override
  String get phoneError => 'မှန်ကန်သော မြန်မာဖုန်းနံပါတ် ရိုက်ထည့်ပါ။';

  @override
  String get phonePrefixError => 'ဖုန်းနံပါတ်သည် 09 သို့မဟုတ် 9 ဖြင့် စရပါမည်။';

  @override
  String get continueLabel => 'ဆက်လက်လုပ်ဆောင်ရန်';

  @override
  String get otpTitle => 'သင့်ဖုန်းနံပါတ်ကို အတည်ပြုပါ';

  @override
  String get otpLabel => 'အတည်ပြုကုဒ်';

  @override
  String get otpError => 'အတည်ပြုကုဒ် မှားယွင်းနေပါသည်။ ထပ်မံကြိုးစားပါ။';

  @override
  String get otpLocked =>
      'အကြိမ်အရေအတွက် အများလွန်းနေပါသည်။ ပြန်လည်မပို့မီ ခဏစောင့်ပါ။';

  @override
  String get resend => 'ပြန်လည်ပို့မည်';

  @override
  String resendCountdown(String time) {
    return '$time မိနစ်အကြာတွင် ပြန်လည်ပို့မည်';
  }

  @override
  String get unknownPhone => 'ဤနံပါတ်ဖြင့် အကောင့်မရှိသေးပါ။';

  @override
  String get nameTitle => 'သင့်အမည် ဘယ်လိုခေါ်ပါသလဲ။';

  @override
  String get firstName => 'အမည်ရှေ့ပိုင်း';

  @override
  String get lastName => 'အမည်နောက်ပိုင်း';

  @override
  String get nameError => 'စာလုံးနှင့် စာခြားကွက် (၁-၅၀) ခုအတွင်း အသုံးပြုပါ။';

  @override
  String get birthTitle => 'သင့်မွေးသက္ကရာဇ် ဘယ်တော့လဲ။';

  @override
  String get month => 'လ';

  @override
  String get day => 'ရက်';

  @override
  String get year => 'နှစ်';

  @override
  String get birthdayPickerTitle => 'သင့်မွေးနေ့ ရွေးချယ်ပါ';

  @override
  String get birthdayPickerSelect => 'ရွေးချယ်ရန်';

  @override
  String get loadingCatalog => 'ပစ္စည်းစာရင်းများ ရယူနေသည်';

  @override
  String get dateError =>
      'မှန်ကန်သော ရက်စွဲ ထည့်ပါ (အနည်းဆုံး အသက် ၁၃ နှစ် ရှိရမည်)။';

  @override
  String get welcomeTitle => 'J’Donuts ကမ္ဘာမှ ကြိုဆိုပါသည်';

  @override
  String get explore => 'စတင်ကြည့်ရှုကြစို့';

  @override
  String get notAvailable => 'မကြာမီ လာမည်';

  @override
  String get terms => 'အသုံးပြုမှု စည်းမျဉ်းများ';

  @override
  String get privacy => 'ကိုယ်ရေးအချက်အလက် မူဝါဒ';

  @override
  String social(String provider) {
    return '$provider ဖြင့် ဆက်လက်လုပ်ဆောင်ရန်';
  }

  @override
  String get authError => 'မှားယွင်းမှုတစ်ခု ဖြစ်ပေါ်နေပါသည်။ ထပ်မံကြိုးစားပါ။';

  @override
  String get legalPrefix => 'ဆက်လက်လုပ်ဆောင်ခြင်းဖြင့် ကျွန်ုပ်တို့၏';

  @override
  String get legalAnd => 'နှင့်';

  @override
  String otpSent(String phone) {
    return '$phone သို့ ၆ လုံးပါ OTP စာတို ပို့ပြီးပါပြီ';
  }

  @override
  String get otpResendPrompt => 'အတည်ပြုကုဒ် မရရှိဘူးလား။';

  @override
  String get seasonalSpecials => 'ရာသီပေါ် အထူးမုန့်များ';

  @override
  String get popular => 'လူကြိုက်များ 🔥';

  @override
  String get orderAgain => 'ထပ်မံမှာယူရန်';

  @override
  String get offlineCatalog => 'အင်တာနက် ချိတ်ဆက်ထားခြင်းမရှိပါ';

  @override
  String memberTier(String tier) {
    return '$tier အဖွဲ့ဝင်';
  }

  @override
  String tierPointsRemaining(String points, String tier) {
    return '$tier အဖွဲ့ဝင် ဖြစ်လာရန် $points မှတ် လိုသေးသည်';
  }

  @override
  String notifications(int count) {
    return 'အကြောင်းကြားချက် $count ခု';
  }

  @override
  String get emptyMember => 'အဖွဲ့ဝင် ပရိုဖိုင် မရှိသေးပါ။';

  @override
  String get emptyBanners => 'လက်ရှိတွင် ပရိုမိုးရှင်း မရှိသေးပါ။';

  @override
  String get bannerLoadError => 'ပရိုမိုးရှင်းများ ရယူ၍ မရပါ။';

  @override
  String get memberLoadError => 'အဖွဲ့ဝင် ပရိုဖိုင်ကို ရယူ၍ မရပါ။';

  @override
  String get emptyProducts => 'ဤကဏ္ဍတွင် မုန့်များ မရှိသေးပါ။';

  @override
  String get productSectionError => 'ဤကဏ္ဍကို ရယူ၍ မရပါ။';

  @override
  String get emptyShops => 'အနီးအနားတွင် ဆိုင်များ မရှိပါ။';

  @override
  String get shopLoadError => 'အနီးအနားရှိ ဆိုင်များကို ရယူ၍ မရပါ။';

  @override
  String get refreshError => 'စာရင်းများကို ပြန်လည်ရယူ၍ မရပါ။';

  @override
  String nearbyShops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'သင့်အနီးတွင် J’Donut ဆိုင် $count ဆိုင် ရှိပါသည်။',
      one: 'သင့်အနီးတွင် J’Donut ဆိုင် ၁ ဆိုင် ရှိပါသည်။',
    );
    return '$_temp0 😊';
  }

  @override
  String get nearbyShopsTitle => 'အနီးအနားရှိ ဆိုင်များ';

  @override
  String get exploreNow => 'ခုပဲ ကြည့်ရှုမည်';

  @override
  String get orderOnline => 'အွန်လိုင်းမှ မှာယူရန်';

  @override
  String discountBadge(int percent) {
    return '$percent% လျှော့စျေး';
  }

  @override
  String moreInSection(String section) {
    return '$section တွင် ထပ်မံကြည့်ရန်';
  }

  @override
  String get newProduct => 'အသစ်';

  @override
  String get productDescriptionTitle => 'အသေးစိတ် အချက်အလက်';

  @override
  String get addToCart => 'စျေးဝယ်လှည်းထဲထည့်မည်';

  @override
  String cartItemCount(int count) {
    return 'စျေးဝယ်လှည်း၊ ပစ္စည်း $count ခု';
  }

  @override
  String get addedToCart => 'စျေးဝယ်လှည်းထဲ ထည့်ပြီးပါပြီ';

  @override
  String priceMmk(String amount) {
    return '$amount ကျပ်';
  }

  @override
  String get decreaseQuantity => 'အရေအတွက် လျှော့ရန်';

  @override
  String get increaseQuantity => 'အရေအတွက် တိုးရန်';

  @override
  String quantityLabel(int count) {
    return 'အရေအတွက် $count';
  }

  @override
  String get productLoadError => 'ဤမုန့်အကြောင်း အချက်အလက်များကို ရယူ၍ မရပါ။';

  @override
  String get productNotFound => 'ဤမုန့်ကို ရှာမတွေ့ပါ။';

  @override
  String get rewardsTitle => 'J’ Donuts အထူးဆုများ';

  @override
  String get rewardsBadge => 'ဆုလက်ဆောင်များ';

  @override
  String get replayRewards => 'ဆုလက်ဆောင် အန်နီမေးရှင်း ပြန်ပြရန်';

  @override
  String get replayChallenge => 'စိန်ခေါ်မှု တိုးတက်မှုကို ပြန်ပြရန်';

  @override
  String get totalRewardPoints => 'စုစုပေါင်း ရမှတ်';

  @override
  String rewardsPointsTotal(int points) {
    final intl.NumberFormat pointsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String pointsString = pointsNumberFormat.format(points);

    return '$pointsString';
  }

  @override
  String get currentRewardTier => 'လက်ရှိ ရောက်ရှိနေသည့် အဆင့်';

  @override
  String get upcomingRewardTier => 'မကြာမီ ရောက်ရှိမည့် အဆင့်';

  @override
  String nextRewardTier(int points, String tier) {
    final intl.NumberFormat pointsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String pointsString = pointsNumberFormat.format(points);

    return '$tier ဖြစ်လာရန်\n$pointsString မှတ် လိုသေးသည်';
  }

  @override
  String get earnMoreTab => 'ပိုစား ပိုရ';

  @override
  String get giftTab => 'လက်ဆောင်';

  @override
  String get emptyGifts => 'လက်ဆောင် မရှိသေးပါ';

  @override
  String get emptyChallenges => 'လက်ရှိတွင် စိန်ခေါ်မှုများ မရှိသေးပါ';

  @override
  String get rewardsLoading => 'ဆုလက်ဆောင်များ ရယူနေသည်';

  @override
  String get rewardsLoadError => 'ဆုလက်ဆောင်များကို ရယူ၍ မရပါ။';

  @override
  String get earnReward => 'ရမှတ်ယူမည်';

  @override
  String challengeQuantity(int completed, int target) {
    return '$completed/$target';
  }

  @override
  String challengePoints(int points) {
    final intl.NumberFormat pointsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String pointsString = pointsNumberFormat.format(points);

    return '$pointsString မှတ်';
  }

  @override
  String get language => 'ဘာသာစကား';

  @override
  String get languageSaveError =>
      'ဘာသာစကားကို သိမ်းဆည်း၍ မရပါ။ ထပ်မံကြိုးစားပါ။';
}
