import 'dart:convert';

import '../../features/home/data/models/home_catalog_models.dart';
import '../../features/product/data/models/product_model.dart';
import '../../features/rewards/data/models/reward_models.dart';
import '../member/data/member_model.dart';

const demoMemberId = 'member_demo';

final class CatalogSeed {
  const CatalogSeed({
    required this.revision,
    required this.products,
    required this.banners,
    required this.sections,
    required this.shops,
    required this.member,
    required this.tiers,
    required this.challenges,
  });

  factory CatalogSeed.decode(String source) {
    final json = jsonDecode(source) as Map<String, Object?>;
    final seed = CatalogSeed(
      revision: json['revision'] as int,
      products: _rows(json, 'products', ProductModel.fromJson),
      banners: _rows(json, 'banners', BannerModel.fromJson),
      sections: _rows(json, 'sections', SectionProductModel.fromJson),
      shops: _rows(json, 'shops', ShopModel.fromJson),
      member: MemberModel.fromJson(json['member'] as Map<String, Object?>),
      tiers: _rows(json, 'tiers', TierModel.fromJson),
      challenges: _rows(json, 'challenges', ChallengeModel.fromJson),
    );
    if (seed.revision < 1 || seed.member.id != demoMemberId) {
      throw const FormatException('Invalid catalog revision or member ID');
    }
    return seed;
  }

  final int revision;
  final List<ProductModel> products;
  final List<BannerModel> banners;
  final List<SectionProductModel> sections;
  final List<ShopModel> shops;
  final MemberModel member;
  final List<TierModel> tiers;
  final List<ChallengeModel> challenges;
}

List<T> _rows<T>(
  Map<String, Object?> json,
  String key,
  T Function(Map<String, Object?>) decode,
) => (json[key] as List<Object?>)
    .map((row) => decode(row as Map<String, Object?>))
    .toList(growable: false);
