import 'package:code_test_madivizion/core/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme font configuration', () {
    test('uses Poppins as the primary font family', () {
      expect(AppTheme.fontFamily, 'Poppins');
      final theme = AppTheme.light;
      expect(theme.textTheme.bodyMedium?.fontFamily, 'Poppins');
      expect(theme.textTheme.headlineMedium?.fontFamily, 'Poppins');
    });
  });
}
