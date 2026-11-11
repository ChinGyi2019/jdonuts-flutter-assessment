import 'package:fpdart/fpdart.dart';

import '../error/failure.dart';

Future<Either<Failure, T>> localResult<T>(
  String message,
  Future<T> Function() operation,
) async {
  try {
    return right(await operation());
  } catch (_) {
    return left(StorageFailure(message));
  }
}
