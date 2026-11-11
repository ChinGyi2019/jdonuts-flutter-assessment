import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';

import '../../error/failure.dart';
import '../../storage/app_database.dart';
import '../../storage/catalog_queries.dart';
import '../../storage/catalog_seed.dart';
import '../../storage/catalog_seeder.dart';
import '../domain/member.dart';
import 'member_model.dart';

class MemberLocalDataSource {
  MemberLocalDataSource(this._db, this._seeder);

  final AppDatabase _db;
  final CatalogSeeder _seeder;

  Stream<Either<Failure, MemberModel?>> watch(String id) => watchLocal(
    _seeder,
    'Could not load the member',
    () => (_db.select(
      _db.members,
    )..where((member) => member.id.equals(id))).watchSingleOrNull(),
  );

  Future<Either<Failure, MemberModel?>> findByPhone(String phone) => readLocal(
    _seeder,
    'Could not look up the member',
    () => _byPhone(phone).getSingleOrNull(),
  );

  Future<Either<Failure, MemberModel>> register(MemberRegistration profile) =>
      readLocal(_seeder, 'Could not save the member', () {
        return _db.transaction(() async {
          final existing = await _byPhone(profile.phone).getSingleOrNull();
          if (existing != null) return existing;
          final member = await _newMember(profile);
          await _db.into(_db.members).insert(member.toInsertable());
          return member;
        });
      });

  Selectable<MemberModel> _byPhone(String phone) =>
      _db.select(_db.members)..where((member) => member.phone.equals(phone));

  Future<MemberModel> _newMember(MemberRegistration profile) async {
    final defaults = await (_db.select(
      _db.members,
    )..where((member) => member.id.equals(demoMemberId))).getSingle();
    final id = await _db
        .customSelect("SELECT 'member_' || lower(hex(randomblob(16))) AS id")
        .getSingle();
    return MemberModel(
      id: id.read<String>('id'),
      firstName: profile.firstName,
      lastName: profile.lastName,
      phone: profile.phone,
      birthDate: profile.birthDate.toIso8601String().split('T').first,
      points: defaults.points,
      notificationCount: defaults.notificationCount,
      rewardsBadgeCount: defaults.rewardsBadgeCount,
      imageAsset: defaults.imageAsset,
      imageUrl: defaults.imageUrl,
    );
  }
}
