import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:code_test_madivizion/core/error/failure.dart';
import 'package:code_test_madivizion/core/member/data/member_local_data_source.dart';
import 'package:code_test_madivizion/core/member/domain/member.dart';
import 'package:code_test_madivizion/core/storage/app_database.dart';
import 'package:code_test_madivizion/core/storage/catalog_seed.dart';
import 'package:code_test_madivizion/core/storage/catalog_seeder.dart';
import 'package:code_test_madivizion/features/home/data/datasources/home_catalog_local_data_source.dart';
import 'package:code_test_madivizion/features/home/domain/entities/home_catalog.dart';
import 'package:code_test_madivizion/features/product/data/datasources/product_local_data_source.dart';
import 'package:code_test_madivizion/features/rewards/data/datasources/rewards_local_data_source.dart';
import 'package:code_test_madivizion/features/rewards/domain/entities/reward_tier.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase database;
  late CatalogSeeder seeder;
  late String bundle;
  late String source;

  setUp(() async {
    bundle = await rootBundle.loadString('assets/data/catalog.json');
  });

  group('catalog seeding', () {
    setUp(() {
      source = bundle;
      database = AppDatabase(NativeDatabase.memory());
      seeder = CatalogSeeder(database, () async => source);
    });

    tearDown(() => database.close());

    test(
      'cold readers seed the bundled catalog and all artwork offline',
      () async {
        final home = HomeCatalogLocalDataSource(database, seeder);
        final products = ProductLocalDataSource(database, seeder);
        final rewards = RewardsLocalDataSource(database, seeder);
        final members = MemberLocalDataSource(database, seeder);

        final reads = await (
          home.watchBanners().first,
          home.watchShops().first,
          home.watchSection(HomeSection.popular).first,
          products.watchById('p_coconut').first,
          rewards.watchTiers().first,
          rewards.watchChallenges().first,
          members.watch(demoMemberId).first,
        ).wait;
        expect(reads.$1.getRight().toNullable()!.map((b) => b.id), [
          'b_central',
          'b_seasonal',
        ]);
        expect(reads.$2.getRight().toNullable(), hasLength(4));
        expect(reads.$3.getRight().toNullable()!.map((p) => p.id), [
          'p_strawberry',
          'p_dalgona',
          'p_coconut',
        ]);
        final coconut = reads.$4.getRight().toNullable()!;
        expect(coconut.code, 'JD022123');
        expect(coconut.priceMmk, 3200);
        expect(coconut.isNew, isTrue);

        final member = reads.$7.getRight().toNullable()!;
        final tiers = reads.$5.getRight().toNullable()!.map(
          (t) => t.toEntity(),
        );
        final progress = TierProgress.fromTiers(member.points, tiers.toList());
        expect(progress.current?.id, 'silver');
        expect(progress.next?.id, 'gold');
        expect(progress.pointsRemaining, 500);
        expect(progress.fraction, 0.75);
        expect(member.points, 680000);
        expect(member.rewardsBadgeCount, 3);
        expect(
          reads.$6.getRight().toNullable()!.map(
            (c) => (c.completedQuantity, c.targetQuantity),
          ),
          [(4, 4), (1, 4), (9, 12)],
        );

        final seed = CatalogSeed.decode(bundle);
        final assets = {
          for (final row in seed.products) row.imageAsset,
          for (final row in seed.banners) row.imageAsset,
          for (final row in seed.shops) row.imageAsset,
          for (final row in seed.challenges) row.imageAsset,
          seed.member.imageAsset,
        };
        for (final asset in assets) {
          expect((await rootBundle.load(asset)).lengthInBytes, greaterThan(0));
        }
      },
    );

    test(
      'a newer bundle updates product watchers and preserves the member',
      () async {
        final members = MemberLocalDataSource(database, seeder);
        final registered = await members.register(_registration);
        final id = registered.getRight().toNullable()!.id;
        await database
            .update(database.members)
            .write(const MembersCompanion(points: Value(680100)));
        final products = ProductLocalDataSource(database, seeder);
        final updates = StreamIterator(products.watchById('p_coconut'));
        addTearDown(updates.cancel);
        expect(await updates.moveNext(), isTrue);
        expect(updates.current.getRight().toNullable()?.priceMmk, 3200);

        source = _revised(bundle, price: 3900);
        expect((await seeder.reconcile()).isRight(), isTrue);
        expect(await updates.moveNext(), isTrue);
        expect(updates.current.getRight().toNullable()?.priceMmk, 3900);
        expect((await seeder.reconcile()).isRight(), isTrue);
        expect(await updates.moveNext(), isTrue);
        expect(updates.current.getRight().toNullable()?.priceMmk, 3900);

        final member = (await members.watch(id).first).getRight().toNullable()!;
        expect(member.firstName, _registration.firstName);
        expect(member.points, 680100);
      },
    );

    test(
      'an invalid refresh rolls back its writes and keeps cached reads',
      () async {
        expect((await seeder.ensureSeeded()).isRight(), isTrue);
        source = _revised(bundle, price: 3900, invalidSection: true);
        final failure = await seeder.reconcile();
        expect(failure.getLeft().toNullable(), isA<StorageFailure>());

        final reopenedSeeder = CatalogSeeder(database, () async => source);
        final products = ProductLocalDataSource(database, reopenedSeeder);
        final coconut = await products.watchById('p_coconut').first;
        expect(coconut.getRight().toNullable()?.priceMmk, 3200);
        expect(
          (await database.select(database.catalogVersions).getSingle())
              .revision,
          CatalogSeed.decode(bundle).revision,
        );
      },
    );

    test(
      'an invalid first seed returns a typed failure and can be retried',
      () async {
        source = _revised(bundle, price: 3900, invalidSection: true);
        final products = ProductLocalDataSource(database, seeder);
        final failed = await products.watchById('p_coconut').first;
        expect(failed.getLeft().toNullable(), isA<StorageFailure>());
        expect(await database.select(database.products).get(), isEmpty);

        source = bundle;
        final coconut = await products.watchById('p_coconut').first;
        expect(coconut.getRight().toNullable()?.priceMmk, 3200);
      },
    );
  });

  test(
    'upgrades a v1 file, reseeds challenges, and keeps registrations',
    () async {
      final temp = await Directory.systemTemp.createTemp('jdonuts-database-');
      addTearDown(() => temp.delete(recursive: true));
      final file = File('${temp.path}/database.sqlite');
      final original = AppDatabase(NativeDatabase(file));
      final originalSeeder = CatalogSeeder(original, () async => bundle);
      final originalMembers = MemberLocalDataSource(original, originalSeeder);
      final member = (await originalMembers.register(
        _registration,
      )).getRight().toNullable()!;
      await original.customStatement('DROP TABLE reward_challenges');
      await original.customStatement('PRAGMA user_version = 1');
      await original.close();

      final migrated = AppDatabase(NativeDatabase(file));
      addTearDown(migrated.close);
      final migratedSeeder = CatalogSeeder(migrated, () async => bundle);
      final rewards = RewardsLocalDataSource(migrated, migratedSeeder);
      final members = MemberLocalDataSource(migrated, migratedSeeder);
      final challenges = await rewards.watchChallenges().first;
      expect(challenges.getRight().toNullable(), hasLength(3));
      final restored = (await members.findByPhone(
        _registration.phone,
      )).getRight().toNullable()!;
      expect(restored.id, member.id);
      expect(restored.toEntity().birthDate, _registration.birthDate);
    },
  );
}

final _registration = MemberRegistration(
  phone: '+959254135592',
  firstName: 'Hnin',
  birthDate: DateTime(2001, 3, 9),
);

String _revised(
  String original, {
  required int price,
  bool invalidSection = false,
}) {
  final json = jsonDecode(original) as Map<String, Object?>;
  json['revision'] = (json['revision'] as int) + 1;
  final products = json['products'] as List<Object?>;
  (products.first as Map<String, Object?>)['priceMmk'] = price;
  if (invalidSection) {
    final sections = json['sections'] as List<Object?>;
    (sections.first as Map<String, Object?>)['productId'] = 'p_missing';
  }
  return jsonEncode(json);
}
