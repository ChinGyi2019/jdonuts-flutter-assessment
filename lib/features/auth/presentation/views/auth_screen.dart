import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoLocalizations;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/usecases/auth_validators.dart';
import '../viewmodels/auth_state.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/auth_visuals.dart';
import '../widgets/birthday_picker_sheet.dart';
import '../widgets/donut_intro_layout.dart';
import '../widgets/otp_field.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});
  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final phone = TextEditingController(),
      first = TextEditingController(),
      last = TextEditingController();
  final otp = TextEditingController();
  final phoneFocus = FocusNode(), firstFocus = FocusNode();
  late final TapGestureRecognizer termsTap;
  late final TapGestureRecognizer privacyTap;
  Timer? timer;
  bool phoneTouched = false, firstTouched = false;

  @override
  void initState() {
    super.initState();
    termsTap = TapGestureRecognizer()..onTap = _placeholder;
    privacyTap = TapGestureRecognizer()..onTap = _placeholder;
    phoneFocus.addListener(() {
      if (!phoneFocus.hasFocus && mounted) {
        setState(() {
          phoneTouched = true;
        });
      }
    });
    firstFocus.addListener(() {
      if (!firstFocus.hasFocus && mounted) setState(() => firstTouched = true);
    });
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && ref.read(authViewModelProvider).step == AuthStep.otp) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    termsTap.dispose();
    privacyTap.dispose();
    for (final focus in [phoneFocus, firstFocus]) {
      focus.dispose();
    }
    for (final controller in [phone, first, last, otp]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);
    final vm = ref.read(authViewModelProvider.notifier);
    ref.listen(authViewModelProvider.select((state) => state.step), (_, step) {
      if (step == AuthStep.welcome) {
        Router.neglect(context, () => context.go('/welcome'));
      }
    });
    final strings = AppLocalizations.of(context)!;
    return PopScope(
      canPop: state.step == AuthStep.onboarding,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) vm.back();
      },
      child: switch (state.step) {
        AuthStep.welcome => const SizedBox.shrink(),
        AuthStep.onboarding => DonutIntroLayout.onboarding(
          footer: _onboardingActions(state, vm, strings),
        ),
        _ => _formScreen(state, vm, strings),
      },
    );
  }

  Widget _formScreen(
    AuthState state,
    AuthViewModel vm,
    AppLocalizations s,
  ) => Scaffold(
    backgroundColor: AppColors.authBackground,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      _header(state, vm),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: AppMotion.duration(
                            context,
                            AppMotion.standard,
                          ),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween(
                                    begin: const Offset(.045, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              ),
                          child: _form(state, vm, s),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _header(AuthState state, AuthViewModel vm) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(7),
          child: InkWell(
            borderRadius: BorderRadius.circular(7),
            onTap: state.loading ? null : vm.back,
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                LucideIcons.arrowLeft,
                size: 21,
                color: AppColors.authText,
              ),
            ),
          ),
        ),
        AuthProgress(
          step: state.step.index,
          birthDateSelected: _isValidBirthDate(state.birthDate, DateTime.now()),
        ),
      ],
    ),
  );

  void _startAuth(AuthViewModel vm, AuthMode mode) {
    setState(() {
      phoneTouched = false;
    });
    vm.start(mode);
  }

  Widget _onboardingActions(
    AuthState state,
    AuthViewModel vm,
    AppLocalizations s,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              AuthEntrance(
                order: 2,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 290),
                  child: _heading(s.onboardingTitle, center: true),
                ),
              ),
              const SizedBox(height: 28),
              AuthEntrance(
                order: 4,
                child: AuthPrimaryButton(
                  label: s.getStarted,
                  loading: state.loading,
                  onPressed: () => _startAuth(vm, AuthMode.register),
                ),
              ),
              ...[
                const SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(s.loginPrompt, style: _bodyStyle),
                    TextButton(
                      onPressed: () => _startAuth(vm, AuthMode.login),
                      child: Text(
                        s.logIn,
                        style: const TextStyle(
                          color: AppColors.authPink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _social(
                      'Google',
                      Image.asset(
                        'assets/images/ic_google.webp',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    _social(
                      'Apple',
                      Image.asset(
                        'assets/images/ic_apple.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    _social(
                      'Facebook',
                      Image.asset(
                        'assets/images/ic_facebook.webp',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
              ],
              _error(state, s),
            ],
          ),
        ),
        _legal(s),
      ],
    );
  }

  Widget _form(AuthState state, AuthViewModel vm, AppLocalizations s) =>
      Padding(
        key: ValueKey(state.step),
        padding: const EdgeInsets.fromLTRB(32, 34, 32, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ..._fields(state, vm, s),
            const Spacer(),
            _error(state, s),
            AuthPrimaryButton(
              label: s.continueLabel,
              loading: state.loading,
              onPressed: _submit(state, vm),
            ),
            _legal(s),
          ],
        ),
      );

  List<Widget> _fields(AuthState state, AuthViewModel vm, AppLocalizations s) =>
      switch (state.step) {
        AuthStep.phone => _phoneFields(state, vm, s),
        AuthStep.otp => _otpFields(state, vm, s),
        AuthStep.name => _nameFields(vm, s),
        AuthStep.birthDate => _birthFields(state, vm, s),
        _ => [],
      };

  List<Widget> _phoneFields(
    AuthState state,
    AuthViewModel vm,
    AppLocalizations s,
  ) => [
    _heading(s.phoneTitle),
    const SizedBox(height: 30),
    _input(
      phone,
      s.phoneLabel,
      focus: phoneFocus,
      keyboard: TextInputType.phone,
      prefix: phone.text.startsWith('+95') ? null : '+95   ',
      onChanged: (value) {
        vm.setPhone(value);
        setState(() {});
      },
      error: _phoneError(s),
    ),
    if (state.error == 'unknown_phone')
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(s.unknownPhone, style: _bodyStyle),
          TextButton(
            onPressed: () {
              setState(() {
                phoneTouched = false;
              });
              vm.start(AuthMode.register);
            },
            child: Text(s.register),
          ),
        ],
      ),
  ];

  List<Widget> _otpFields(
    AuthState state,
    AuthViewModel vm,
    AppLocalizations s,
  ) {
    final seconds = (state.remaining(DateTime.now()).inMilliseconds / 1000)
        .ceil();
    final time =
        '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
    return [
      _heading(s.otpTitle),
      const SizedBox(height: 12),
      Text(
        s.otpSent(normalizeMyanmarPhone(state.phone) ?? state.phone),
        style: _bodyStyle,
      ),
      const SizedBox(height: 32),
      OtpField(
        controller: otp,
        label: s.otpLabel,
        enabled: !state.otpLocked && !state.loading,
        attempts: state.attempts,
        error: state.otpLocked
            ? s.otpLocked
            : state.error == 'invalid_otp'
            ? s.otpError
            : null,
        onChanged: (_) => setState(() {}),
      ),
      const SizedBox(height: 18),
      if (seconds > 0)
        _countdown(s, time)
      else ...[
        Text(s.otpResendPrompt, style: _bodyStyle),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: AppColors.authPink,
            ),
            onPressed: seconds == 0 && !state.loading
                ? () {
                    vm.resend(DateTime.now());
                    otp.clear();
                  }
                : null,
            child: Text(s.resend),
          ),
        ),
      ],
    ];
  }

  Widget _countdown(AppLocalizations s, String time) {
    const placeholder = '\uFFFC';
    final parts = s.resendCountdown(placeholder).split(placeholder);
    return Text.rich(
      TextSpan(
        style: _bodyStyle,
        children: [
          TextSpan(text: '${s.otpResendPrompt}\n'),
          TextSpan(text: parts.first),
          for (final part in parts.skip(1)) ...[
            TextSpan(
              text: time,
              style: const TextStyle(
                color: AppColors.authTimer,
                fontWeight: FontWeight.w600,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            TextSpan(text: part),
          ],
        ],
      ),
    );
  }

  List<Widget> _nameFields(AuthViewModel vm, AppLocalizations s) => [
    _heading(s.nameTitle),
    const SizedBox(height: 30),
    _input(
      first,
      s.firstName,
      focus: firstFocus,
      onChanged: (_) => vm.setNames(first.text, last.text),
      error: firstTouched && !isValidName(first.text) ? s.nameError : null,
    ),
    const SizedBox(height: 16),
    _input(
      last,
      s.lastName,
      onChanged: (_) => vm.setNames(first.text, last.text),
      error: last.text.isNotEmpty && !isValidName(last.text, required: false)
          ? s.nameError
          : null,
    ),
  ];

  List<Widget> _birthFields(
    AuthState state,
    AuthViewModel vm,
    AppLocalizations s,
  ) {
    final date = state.birthDate;
    final dates = CupertinoLocalizations.of(context);
    final fields = [
      (
        s.month,
        date == null ? null : dates.datePickerStandaloneMonth(date.month),
      ),
      (s.day, date == null ? null : dates.datePickerDayOfMonth(date.day)),
      (s.year, date == null ? null : dates.datePickerYear(date.year)),
    ];
    final VoidCallback? openPicker = state.loading
        ? null
        : () async {
            final selected = await showBirthdayPicker(context, date: date);
            if (mounted && selected != null) vm.setBirthDate(selected);
          };
    return [
      _heading(s.birthTitle),
      const SizedBox(height: 30),
      for (final (label, value) in fields) ...[
        Semantics(
          button: true,
          label: label,
          value: value,
          enabled: openPicker != null,
          child: Material(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(7),
            child: InkWell(
              borderRadius: BorderRadius.circular(7),
              onTap: openPicker,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 21,
                ),
                child: ExcludeSemantics(
                  child: Text(
                    value ?? label,
                    style: TextStyle(
                      color: value == null
                          ? AppColors.authMuted
                          : AppColors.authText,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
      if (date != null && !_isValidBirthDate(date, DateTime.now()))
        Text(
          s.dateError,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
    ];
  }

  bool _isValidBirthDate(DateTime? date, DateTime today) =>
      date != null &&
      validateBirthDate(
            month: date.month,
            day: date.day,
            year: date.year,
            today: today,
          ) !=
          null;

  VoidCallback? _submit(AuthState state, AuthViewModel vm) =>
      switch (state.step) {
        AuthStep.phone =>
          _hasPhoneValidationError ? null : () => _onPhoneContinue(vm),
        AuthStep.otp =>
          isValidOtp(otp.text) && !state.otpLocked
              ? () async {
                  await vm.submitOtp(otp.text);
                  if (mounted &&
                      ref.read(authViewModelProvider).error == 'invalid_otp') {
                    setState(otp.clear);
                  }
                }
              : null,
        AuthStep.name =>
          isValidName(first.text) && isValidName(last.text, required: false)
              ? vm.submitName
              : null,
        AuthStep.birthDate =>
          _isValidBirthDate(state.birthDate, DateTime.now())
              ? () => vm.submitRegistration(DateTime.now())
              : null,
        _ => null,
      };

  bool get _hasPhoneValidationError =>
      phoneTouched && normalizeMyanmarPhone(phone.text) == null;

  String? _phoneError(AppLocalizations s) {
    if (!_hasPhoneValidationError) return null;
    final value = phone.text.replaceAll(RegExp(r'[\s-]'), '');
    if (value.isEmpty ||
        value.startsWith('09') ||
        value.startsWith('9') ||
        value.startsWith('+95')) {
      return s.phoneError;
    }
    return s.phonePrefixError;
  }

  void _onPhoneContinue(AuthViewModel vm) {
    if (normalizeMyanmarPhone(phone.text) != null) {
      vm.submitPhone();
    } else {
      setState(() {
        phoneTouched = true;
      });
      phoneFocus.unfocus();
    }
  }

  Widget _input(
    TextEditingController controller,
    String hint, {
    FocusNode? focus,
    TextInputType? keyboard,
    String? prefix,
    String? error,
    ValueChanged<String>? onChanged,
  }) => TextField(
    controller: controller,
    focusNode: focus,
    keyboardType: keyboard,
    onChanged: onChanged,
    style: const TextStyle(color: AppColors.authText, fontSize: 16),
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: prefix == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 18, right: 12),
              child: Text(
                prefix.trim(),
                style: const TextStyle(
                  color: AppColors.authMuted,
                  fontSize: 16,
                ),
              ),
            ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      errorText: error,
      filled: true,
      fillColor: AppColors.white,
      hintStyle: const TextStyle(color: AppColors.authMuted),
      prefixStyle: const TextStyle(color: AppColors.authMuted, fontSize: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 21),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide.none,
      ),
    ),
  );

  TextStyle get _bodyStyle =>
      const TextStyle(color: AppColors.authText, fontSize: 13, height: 1.4);
  Widget _heading(String text, {bool center = false}) => Text(
    text,
    textAlign: center ? TextAlign.center : TextAlign.start,
    style: const TextStyle(
      color: AppColors.authText,
      fontSize: 30,
      height: 1.08,
      fontWeight: FontWeight.w800,
      letterSpacing: -.5,
    ),
  );
  Widget _error(AuthState state, AppLocalizations s) =>
      state.error == null ||
          state.error == 'invalid_otp' ||
          state.error == 'unknown_phone'
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            s.authError,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        );
  Widget _social(String label, Widget child) =>
      IconButton(tooltip: label, onPressed: _placeholder, icon: child);
  void _placeholder() => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(AppLocalizations.of(context)!.notAvailable)),
  );
  Widget _legal(AppLocalizations s) => Padding(
    padding: const EdgeInsets.only(top: 28, bottom: 24, left: 16, right: 16),
    child: Text.rich(
      TextSpan(
        style: const TextStyle(
          color: AppColors.authMuted,
          fontSize: 11,
          height: 1.45,
        ),
        children: [
          TextSpan(text: '${s.legalPrefix} '),
          TextSpan(
            text: s.terms,
            style: const TextStyle(color: AppColors.authPink),
            recognizer: termsTap,
          ),
          TextSpan(text: ' ${s.legalAnd} '),
          TextSpan(
            text: '${s.privacy}.',
            style: const TextStyle(color: AppColors.authPink),
            recognizer: privacyTap,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    ),
  );
}
