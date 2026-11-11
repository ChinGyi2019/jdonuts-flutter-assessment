import 'dart:async';

import 'package:code_test_madivizion/core/error/failure.dart';
import 'package:code_test_madivizion/core/member/domain/member.dart';
import 'package:code_test_madivizion/features/auth/di/auth_providers.dart';
import 'package:code_test_madivizion/features/auth/domain/repositories/auth_repository.dart';
import 'package:code_test_madivizion/features/auth/presentation/viewmodels/auth_state.dart';
import 'package:code_test_madivizion/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

class StubAuth implements AuthRepository {
  int checks = 0;
  @override
  Future<Either<Failure, Member?>> findMember(String phone) async {
    checks++;
    return right(null);
  }

  @override
  Future<Either<Failure, bool>> verifyOtp(String otp) async =>
      right(otp == '123456');
  @override
  Future<Either<Failure, Member>> register(MemberRegistration registration) =>
      throw UnimplementedError();
}

class PendingRegistration extends StubAuth {
  int registrations = 0;
  final result = Completer<Either<Failure, Member>>();
  @override
  Future<Either<Failure, Member>> register(MemberRegistration registration) {
    registrations++;
    return result.future;
  }
}

class BirthDateViewModel extends AuthViewModel {
  @override
  AuthState build() => AuthState(
    step: AuthStep.birthDate,
    phone: '09254135592',
    firstName: 'Aye',
    birthDate: DateTime(2000),
  );
}

void main() {
  test('double submission sends one registration request', () async {
    final fake = PendingRegistration();
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(fake),
        authViewModelProvider.overrideWith(BirthDateViewModel.new),
      ],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(authViewModelProvider, (_, _) {});
    addTearDown(subscription.close);
    final vm = container.read(authViewModelProvider.notifier);
    final first = vm.submitRegistration(DateTime(2026));
    await vm.submitRegistration(DateTime(2026));
    expect(fake.registrations, 1);
    expect(container.read(authViewModelProvider).loading, isTrue);
    fake.result.complete(left(const UnexpectedFailure('failed')));
    await first;
  });
  test('locks after three wrong codes until the resend deadline', () async {
    final fake = StubAuth();
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(fake)],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(authViewModelProvider, (_, _) {});
    addTearDown(subscription.close);
    final vm = container.read(authViewModelProvider.notifier);
    vm.start(AuthMode.register);
    vm.setPhone('09254135592');
    await Future.wait([vm.submitPhone(), vm.submitPhone()]);
    expect(fake.checks, 1);
    expect(container.read(authViewModelProvider).step, AuthStep.otp);
    for (var i = 0; i < 3; i++) {
      await vm.submitOtp('111111');
    }
    var state = container.read(authViewModelProvider);
    expect(state.otpLocked, isTrue);
    final deadline = state.resendAt;
    vm.back();
    await vm.submitPhone();
    state = container.read(authViewModelProvider);
    expect(state.otpLocked, isTrue);
    expect(state.resendAt, deadline);
    vm.resend(state.resendAt!.subtract(const Duration(seconds: 1)));
    expect(container.read(authViewModelProvider).otpLocked, isTrue);
    vm.resend(state.resendAt!);
    state = container.read(authViewModelProvider);
    expect(state.otpLocked, isFalse);
    await vm.submitOtp('123456');
    expect(container.read(authViewModelProvider).step, AuthStep.name);
  });

  test('unknown login number remains on phone step', () async {
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(StubAuth())],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(authViewModelProvider, (_, _) {});
    addTearDown(subscription.close);
    final vm = container.read(authViewModelProvider.notifier);
    vm.start(AuthMode.login);
    vm.setPhone('09254135592');
    await vm.submitPhone();
    expect(container.read(authViewModelProvider).error, 'unknown_phone');
    expect(container.read(authViewModelProvider).step, AuthStep.phone);
  });
}
