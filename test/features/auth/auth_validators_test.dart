import 'package:code_test_madivizion/features/auth/domain/usecases/auth_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('normalizes phone numbers and rejects invalid formats', () {
    expect(normalizeMyanmarPhone('0925 413-5592'), '+959254135592');
    expect(normalizeMyanmarPhone('09254135592'), '+959254135592');
    expect(normalizeMyanmarPhone('+959254135592'), '+959254135592');
    expect(normalizeMyanmarPhone('+95 0925-413-5592'), '+959254135592');
    expect(normalizeMyanmarPhone('9${'1' * 7}'), '+959${'1' * 7}');
    expect(normalizeMyanmarPhone('9${'1' * 9}'), '+959${'1' * 9}');
    for (final value in [
      '',
      '009254135592',
      '81234567',
      '9123456',
      '91234567890',
    ]) {
      expect(normalizeMyanmarPhone(value), isNull, reason: value);
    }
  });

  test('checks names including Myanmar combining marks', () {
    expect(isValidName('  မြန်မာ  '), isTrue);
    expect(isValidName('Élodie Doe'), isTrue);
    expect(isValidName('', required: false), isTrue);
    expect(isValidName(''), isFalse);
    expect(isValidName('A1'), isFalse);
    expect(isValidName('a' * 50), isTrue);
    expect(isValidName('a' * 51), isFalse);
  });

  test('checks OTP and calendar dates including age boundary', () {
    expect(isValidOtp('123456'), isTrue);
    expect(isValidOtp('12345a'), isFalse);
    final today = DateTime(2026, 11, 11);
    DateTime? date(int y, int m, int d) =>
        validateBirthDate(year: y, month: m, day: d, today: today);
    expect(date(2013, 11, 11), isNotNull);
    expect(date(2013, 11, 12), isNull);
    expect(date(2012, 2, 29), isNotNull);
    expect(date(2011, 2, 29), isNull);
    expect(date(2000, 4, 31), isNull);
    expect(date(2027, 1, 1), isNull);
  });
}
