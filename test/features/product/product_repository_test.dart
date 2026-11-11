import 'package:code_test_madivizion/core/error/failure.dart';
import 'package:code_test_madivizion/features/product/data/datasources/product_local_data_source.dart';
import 'package:code_test_madivizion/features/product/data/models/product_model.dart';
import 'package:code_test_madivizion/features/product/data/repositories/product_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _LocalProducts extends Mock implements ProductLocalDataSource {}

void main() {
  late _LocalProducts local;
  late ProductRepositoryImpl repository;
  const id = 'p_coconut';

  setUp(() {
    local = _LocalProducts();
    repository = ProductRepositoryImpl(local);
  });

  test(
    'maps a cached product to the detail entity with its image reference',
    () async {
      const model = ProductModel(
        id: id,
        code: 'JD022123',
        name: 'Coconut Donut',
        priceMmk: 3200,
        description: 'Coconut and chocolate.',
        isNew: true,
        imageAsset: 'assets/images/coconut-donut.webp',
      );
      when(
        () => local.watchById(id),
      ).thenAnswer((_) => Stream.value(right(model)));

      final result = await repository.watchById(id).first;
      final product = result.getRight().toNullable()!;
      expect(product.id, id);
      expect(product.priceMmk, 3200);
      expect(product.image.asset, model.imageAsset);
    },
  );

  test('passes a local storage failure through to callers', () async {
    const failure = StorageFailure('Could not load the product');
    when(
      () => local.watchById(id),
    ).thenAnswer((_) => Stream.value(left(failure)));

    final result = await repository.watchById(id).first;
    expect(result.getLeft().toNullable(), same(failure));
  });

  test('represents an unknown ID as an empty success', () async {
    when(
      () => local.watchById(id),
    ).thenAnswer((_) => Stream.value(right(null)));

    final result = await repository.watchById(id).first;
    expect(result.isRight(), isTrue);
    expect(result.getRight().toNullable(), isNull);
  });
}
