import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../error/failure.dart';
import 'local_result.dart';

class HiveSettings {
  static const _boxName = 'app_settings';
  Future<Box<dynamic>>? _opening;

  Future<Box<dynamic>> _box() => _opening ??= _open();

  Future<Box<dynamic>> _open() async {
    try {
      await Hive.initFlutter();
      return await Hive.openBox<dynamic>(_boxName);
    } catch (_) {
      _opening = null;
      rethrow;
    }
  }

  Future<Either<Failure, T?>> read<T>(String key) =>
      localResult('Could not read app settings', () async {
        return (await _box()).get(key) as T?;
      });

  Future<Either<Failure, Unit>> write<T>(String key, T value) =>
      localResult('Could not save app settings', () async {
        await (await _box()).put(key, value);
        return unit;
      });

  Future<void> close() async {
    final opening = _opening;
    if (opening == null) return;
    final result = await localResult(
      'Could not open app settings',
      () => opening,
    );
    await result.getRight().toNullable()?.close();
  }
}
