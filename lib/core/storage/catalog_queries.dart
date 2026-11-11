import 'package:fpdart/fpdart.dart';

import '../error/failure.dart';
import 'catalog_seeder.dart';
import 'local_result.dart';

Stream<Either<Failure, T>> watchLocal<T>(
  CatalogSeeder seeder,
  String message,
  Stream<T> Function() query,
) async* {
  final seeded = await seeder.ensureSeeded();
  final failure = seeded.getLeft().toNullable();
  if (failure != null) {
    yield left(failure);
    return;
  }

  try {
    await for (final value in query()) {
      yield right(value);
    }
  } catch (_) {
    yield left(StorageFailure(message));
  }
}

Future<Either<Failure, T>> readLocal<T>(
  CatalogSeeder seeder,
  String message,
  Future<T> Function() operation,
) async {
  final seeded = await seeder.ensureSeeded();
  return seeded.match(
    (failure) async => left(failure),
    (_) => localResult(message, operation),
  );
}
