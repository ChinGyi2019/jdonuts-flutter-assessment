import 'dart:async';

import 'package:code_test_madivizion/app/active_member.dart';
import 'package:code_test_madivizion/app/session.dart';
import 'package:code_test_madivizion/core/member/di/member_providers.dart';
import 'package:code_test_madivizion/core/member/domain/member.dart';
import 'package:code_test_madivizion/core/storage/app_database.dart';
import 'package:code_test_madivizion/core/storage/catalog_seeder.dart';
import 'package:code_test_madivizion/core/storage/storage_providers.dart';
import 'package:code_test_madivizion/features/rewards/di/rewards_providers.dart';
import 'package:code_test_madivizion/features/rewards/domain/entities/reward_tier.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'the active member and tier progress update from the registered row',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          catalogSeederProvider.overrideWithValue(
            CatalogSeeder(
              database,
              () => rootBundle.loadString('assets/data/catalog.json'),
            ),
          ),
          sessionStoreProvider.overrideWithValue(_TestSessionStore()),
        ],
      );
      addTearDown(container.dispose);
      await container.read(sessionProvider.future);
      final repository = container.read(memberRepositoryProvider);
      final registration = MemberRegistration(
        phone: '+959254135592',
        firstName: 'Hnin',
        birthDate: DateTime(2001, 3, 9),
      );
      final member = (await repository.register(
        registration,
      )).getRight().toNullable()!;
      final repeated = (await repository.register(
        registration,
      )).getRight().toNullable()!;
      expect(repeated.id, member.id);

      final silver = _waitForTier(container, 'silver');
      await container.read(sessionProvider.notifier).signIn(member.id);
      expect((await silver)?.pointsRemaining, 500);
      final active = await container.read(activeMemberProvider.future);
      expect(active.getRight().toNullable()?.id, member.id);

      final gold = _waitForTier(container, 'gold');
      await (database.update(database.members)
            ..where((row) => row.id.equals(member.id)))
          .write(const MembersCompanion(points: Value(680500)));
      expect((await gold)?.points, 680500);
    },
  );
}

Future<TierProgress?> _waitForTier(ProviderContainer container, String tier) {
  final result = Completer<TierProgress?>();
  final subscription = container.listen(memberTierProgressProvider, (_, next) {
    final progress = next.value?.getRight().toNullable();
    if (progress?.current?.id == tier && !result.isCompleted) {
      result.complete(progress);
    }
  }, fireImmediately: true);
  return result.future
      .timeout(const Duration(seconds: 4))
      .whenComplete(subscription.close);
}

final class _TestSessionStore implements SessionStore {
  @override
  Future<String?> readMemberId() async => null;

  @override
  Future<void> writeMemberId(String memberId) async {}

  @override
  Future<void> clear() async {}
}
