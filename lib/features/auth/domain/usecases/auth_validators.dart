const minimumRegistrationAge = 13;

/// Returns the canonical Myanmar number (+959xxxxxxxx), or null for invalid input.
///
/// After +95, strips spaces, dashes, and one leading 0.
/// The result must be 9 followed by 7 to 9 digits.
String? normalizeMyanmarPhone(String input) {
  var local = input.replaceAll(RegExp(r'[\s-]'), '');
  if (local.startsWith('+95')) {
    local = local.substring(3);
  } else if (local.startsWith('959')) {
    local = local.substring(2);
  }
  if (local.startsWith('0')) local = local.substring(1);
  if (!RegExp(r'^9[0-9]{7,9}$').hasMatch(local)) return null;
  return '+95$local';
}

bool isValidOtp(String value) => RegExp(r'^[0-9]{6}$').hasMatch(value);

bool isValidName(String value, {bool required = true}) {
  final name = value.trim();
  if (name.isEmpty) return !required;
  if (name.runes.length > 50) return false;
  return RegExp(r'^[\p{L}\p{M} ]+$', unicode: true).hasMatch(name);
}

DateTime? validateBirthDate({
  required int month,
  required int day,
  required int year,
  required DateTime today,
}) {
  if (year < 1 || month < 1 || month > 12 || day < 1 || day > 31) return null;
  final date = DateTime(year, month, day);
  if (date.year != year || date.month != month || date.day != day) return null;
  final now = DateTime(today.year, today.month, today.day);
  if (date.isAfter(now)) return null;
  var age = now.year - year;
  if (now.month < month || (now.month == month && now.day < day)) age--;
  return age >= minimumRegistrationAge ? date : null;
}
