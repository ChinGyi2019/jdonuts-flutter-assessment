import '../../../../core/member/domain/member.dart';

enum AuthStep { onboarding, phone, otp, name, birthDate, welcome }

enum AuthMode { register, login }

class AuthState {
  const AuthState({
    this.step = AuthStep.onboarding,
    this.mode = AuthMode.register,
    this.phone = '',
    this.firstName = '',
    this.lastName = '',
    this.birthDate,
    this.loading = false,
    this.error,
    this.attempts = 0,
    this.resendAt,
    this.otpPhone,
    this.member,
  });
  final AuthStep step;
  final AuthMode mode;
  final String phone, firstName, lastName;
  final DateTime? birthDate;
  final bool loading;
  final String? error;
  final int attempts;
  final DateTime? resendAt;
  final String? otpPhone;
  final Member? member;

  bool get otpLocked => attempts >= 3;
  Duration remaining(DateTime now) {
    final duration = resendAt?.difference(now) ?? Duration.zero;
    return duration.isNegative ? Duration.zero : duration;
  }

  AuthState copyWith({
    AuthStep? step,
    AuthMode? mode,
    String? phone,
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    bool? loading,
    String? error,
    bool clearError = false,
    int? attempts,
    DateTime? resendAt,
    String? otpPhone,
    Member? member,
    bool clearMember = false,
  }) => AuthState(
    step: step ?? this.step,
    mode: mode ?? this.mode,
    phone: phone ?? this.phone,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    birthDate: birthDate ?? this.birthDate,
    loading: loading ?? this.loading,
    error: clearError ? null : error ?? this.error,
    attempts: attempts ?? this.attempts,
    resendAt: resendAt ?? this.resendAt,
    otpPhone: otpPhone ?? this.otpPhone,
    member: clearMember ? null : member ?? this.member,
  );
}
