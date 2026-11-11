import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/storage/storage_providers.dart';

part 'language_preference.g.dart';

@Riverpod(keepAlive: true)
class LanguagePreference extends _$LanguagePreference {
  static const _key = 'language_code';

  @override
  Future<Locale?> build() async {
    final result = await ref.watch(hiveSettingsProvider).read<String>(_key);
    return result.fold((_) => null, (code) {
      return code == 'en' || code == 'my' ? Locale(code!) : null;
    });
  }

  Future<bool> setLanguage(String code) async {
    if (code != 'en' && code != 'my') return false;
    final result = await ref.read(hiveSettingsProvider).write(_key, code);
    return result.fold((_) => false, (_) {
      state = AsyncData(Locale(code));
      return true;
    });
  }
}
