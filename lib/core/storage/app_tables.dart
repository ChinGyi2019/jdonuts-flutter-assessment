// Drift generates column checks from self-references in the schema.
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

import '../../features/home/data/models/home_catalog_models.dart';
import '../../features/home/domain/entities/home_catalog.dart';
import '../../features/product/data/models/product_model.dart';
import '../../features/rewards/data/models/reward_models.dart';
import '../../features/rewards/domain/entities/reward_challenge.dart';
import '../member/data/member_model.dart';

@UseRowClass(ProductModel, generateInsertable: true)
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get code => text().unique()();
  TextColumn get name => text()();
  IntColumn get priceMmk => integer().check(priceMmk.isBiggerOrEqualValue(0))();
  TextColumn get description => text()();
  BoolColumn get isNew => boolean()();
  IntColumn get discountPercent =>
      integer().nullable().check(discountPercent.isBetweenValues(1, 100))();
  TextColumn get imageAsset => text()();
  TextColumn get imageUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(BannerModel, generateInsertable: true)
class Banners extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get badge => text()();
  IntColumn get position => integer().unique()();
  TextColumn get imageAsset => text()();
  TextColumn get imageUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(ShopModel, generateInsertable: true)
class Shops extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get address => text()();
  IntColumn get position => integer().unique()();
  TextColumn get imageAsset => text()();
  TextColumn get imageUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(SectionProductModel, generateInsertable: true)
class SectionProducts extends Table {
  TextColumn get section => textEnum<HomeSection>()();
  TextColumn get productId => text().references(Products, #id)();
  IntColumn get position => integer()();

  @override
  Set<Column> get primaryKey => {section, productId};

  @override
  List<Set<Column>> get uniqueKeys => [
    {section, position},
  ];
}

@UseRowClass(MemberModel, generateInsertable: true)
class Members extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text().nullable()();
  TextColumn get phone => text().nullable().unique()();
  TextColumn get birthDate => text().nullable()();
  IntColumn get points => integer().check(points.isBiggerOrEqualValue(0))();
  IntColumn get notificationCount =>
      integer().check(notificationCount.isBiggerOrEqualValue(0))();
  IntColumn get rewardsBadgeCount =>
      integer().check(rewardsBadgeCount.isBiggerOrEqualValue(0))();
  TextColumn get imageAsset => text()();
  TextColumn get imageUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(TierModel, generateInsertable: true)
class RewardTiers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get minimumPoints =>
      integer().unique().check(minimumPoints.isBiggerOrEqualValue(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(ChallengeModel, generateInsertable: true)
class RewardChallenges extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get artwork => textEnum<ChallengeArtwork>()();
  IntColumn get completedQuantity => integer().check(
    completedQuantity.isBetween(const Constant(0), targetQuantity),
  )();
  IntColumn get targetQuantity =>
      integer().check(targetQuantity.isBiggerThanValue(0))();
  IntColumn get rewardPoints =>
      integer().check(rewardPoints.isBiggerOrEqualValue(0))();
  IntColumn get position => integer().unique()();
  TextColumn get imageAsset => text()();
  TextColumn get imageUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class CatalogVersions extends Table {
  IntColumn get id => integer()();
  IntColumn get revision => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
