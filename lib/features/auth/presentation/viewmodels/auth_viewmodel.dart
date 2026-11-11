import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/session.dart';
import '../../../../core/member/domain/member.dart';
import '../../di/auth_providers.dart';
import '../../domain/usecases/auth_validators.dart';
import 'auth_state.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  static const resendDelay = Duration(minutes: 5);
  @override
  AuthState build() => const AuthState();

  void start(AuthMode mode) => state = state.copyWith(
    step: AuthStep.phone,
    mode: mode,
    clearError: true,
    clearMember: true,
  );
  void setPhone(String value) =>
      state = state.copyWith(phone: value, clearError: true);
  void setNames(String first, String last) => state = state.copyWith(
    firstName: first,
    lastName: last,
    clearError: true,
  );
  void setBirthDate(DateTime value) =>
      state = state.copyWith(birthDate: value, clearError: true);

  void back() {
    if (state.loading) return;
    final previous = switch (state.step) {
      AuthStep.onboarding => AuthStep.onboarding,
      AuthStep.phone => AuthStep.onboarding,
      AuthStep.otp => AuthStep.phone,
      AuthStep.name => AuthStep.otp,
      AuthStep.birthDate => AuthStep.name,
      AuthStep.welcome => AuthStep.welcome,
    };
    state = state.copyWith(step: previous, clearError: true);
  }

  Future<void> submitPhone() async {
    final phone = normalizeMyanmarPhone(state.phone);
    if (state.loading || phone == null) return;
    state = state.copyWith(loading: true, clearError: true);
    final result = await ref.read(authRepositoryProvider).findMember(phone);
    if (!ref.mounted) return;
    result.match(
      (failure) =>
          state = state.copyWith(loading: false, error: failure.message),
      (member) {
        if (state.mode == AuthMode.login && member == null) {
          state = state.copyWith(loading: false, error: 'unknown_phone');
        } else {
          state = state.copyWith(
            member: member,
            clearMember: member == null,
            step: AuthStep.otp,
            attempts: state.otpPhone == phone ? state.attempts : 0,
            resendAt: state.otpPhone == phone
                ? state.resendAt
                : DateTime.now().add(resendDelay),
            otpPhone: phone,
            loading: false,
          );
        }
      },
    );
  }

  Future<void> submitOtp(String otp) async {
    if (state.loading || state.otpLocked || !isValidOtp(otp)) return;
    state = state.copyWith(loading: true, clearError: true);
    final result = await ref.read(authRepositoryProvider).verifyOtp(otp);
    if (!ref.mounted) return;
    await result.match(
      (failure) async =>
          state = state.copyWith(loading: false, error: failure.message),
      (valid) async {
        if (!valid) {
          state = state.copyWith(
            loading: false,
            attempts: state.attempts + 1,
            error: 'invalid_otp',
          );
        } else if (state.mode == AuthMode.register) {
          state = state.copyWith(loading: false, step: AuthStep.name);
        } else {
          try {
            await ref.read(sessionProvider.notifier).signIn(state.member!.id);
            if (ref.mounted) state = state.copyWith(loading: false);
          } catch (_) {
            if (ref.mounted) {
              state = state.copyWith(loading: false, error: 'session_error');
            }
          }
        }
      },
    );
  }

  void resend(DateTime now) {
    if (state.loading || state.remaining(now) > Duration.zero) return;
    state = state.copyWith(
      attempts: 0,
      resendAt: now.add(resendDelay),
      clearError: true,
    );
  }

  void submitName() {
    if (!isValidName(state.firstName) ||
        !isValidName(state.lastName, required: false)) {
      return;
    }
    state = state.copyWith(
      firstName: state.firstName.trim(),
      lastName: state.lastName.trim(),
      step: AuthStep.birthDate,
      clearError: true,
    );
  }

  Future<void> submitRegistration(DateTime now) async {
    final date = state.birthDate;
    if (state.step != AuthStep.birthDate ||
        state.loading ||
        date == null ||
        validateBirthDate(
              month: date.month,
              day: date.day,
              year: date.year,
              today: now,
            ) ==
            null) {
      return;
    }
    state = state.copyWith(loading: true, clearError: true);
    final result = await ref
        .read(authRepositoryProvider)
        .register(
          MemberRegistration(
            phone: normalizeMyanmarPhone(state.phone)!,
            firstName: state.firstName,
            lastName: state.lastName.isEmpty ? null : state.lastName,
            birthDate: date,
          ),
        );
    if (!ref.mounted) return;
    result.match(
      (failure) =>
          state = state.copyWith(loading: false, error: failure.message),
      (member) => state = state.copyWith(
        loading: false,
        member: member,
        step: AuthStep.welcome,
      ),
    );
  }

  Future<void> finishWelcome() async {
    if (state.loading || state.member == null) return;
    state = state.copyWith(loading: true, clearError: true);
    try {
      await ref.read(sessionProvider.notifier).signIn(state.member!.id);
      if (ref.mounted) state = state.copyWith(loading: false);
    } catch (_) {
      if (ref.mounted) {
        state = state.copyWith(loading: false, error: 'session_error');
      }
    }
  }
}
