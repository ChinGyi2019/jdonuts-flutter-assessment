// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products
    with TableInfo<$ProductsTable, ProductModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMmkMeta = const VerificationMeta(
    'priceMmk',
  );
  @override
  late final GeneratedColumn<int> priceMmk = GeneratedColumn<int>(
    'price_mmk',
    aliasedName,
    false,
    check: () => ComparableExpr(priceMmk).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  @override
  late final GeneratedColumn<bool> isNew = GeneratedColumn<bool>(
    'is_new',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_new" IN (0, 1))',
    ),
  );
  static const VerificationMeta _discountPercentMeta = const VerificationMeta(
    'discountPercent',
  );
  @override
  late final GeneratedColumn<int> discountPercent = GeneratedColumn<int>(
    'discount_percent',
    aliasedName,
    true,
    check: () => ComparableExpr(discountPercent).isBetweenValues(1, 100),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageAssetMeta = const VerificationMeta(
    'imageAsset',
  );
  @override
  late final GeneratedColumn<String> imageAsset = GeneratedColumn<String>(
    'image_asset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    priceMmk,
    description,
    isNew,
    discountPercent,
    imageAsset,
    imageUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price_mmk')) {
      context.handle(
        _priceMmkMeta,
        priceMmk.isAcceptableOrUnknown(data['price_mmk']!, _priceMmkMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMmkMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('is_new')) {
      context.handle(
        _isNewMeta,
        isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta),
      );
    } else if (isInserting) {
      context.missing(_isNewMeta);
    }
    if (data.containsKey('discount_percent')) {
      context.handle(
        _discountPercentMeta,
        discountPercent.isAcceptableOrUnknown(
          data['discount_percent']!,
          _discountPercentMeta,
        ),
      );
    }
    if (data.containsKey('image_asset')) {
      context.handle(
        _imageAssetMeta,
        imageAsset.isAcceptableOrUnknown(data['image_asset']!, _imageAssetMeta),
      );
    } else if (isInserting) {
      context.missing(_imageAssetMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      priceMmk: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_mmk'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      isNew: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_new'],
      )!,
      discountPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_percent'],
      ),
      imageAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_asset'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class ProductsCompanion extends UpdateCompanion<ProductModel> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> name;
  final Value<int> priceMmk;
  final Value<String> description;
  final Value<bool> isNew;
  final Value<int?> discountPercent;
  final Value<String> imageAsset;
  final Value<String?> imageUrl;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.priceMmk = const Value.absent(),
    this.description = const Value.absent(),
    this.isNew = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.imageAsset = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String code,
    required String name,
    required int priceMmk,
    required String description,
    required bool isNew,
    this.discountPercent = const Value.absent(),
    required String imageAsset,
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       name = Value(name),
       priceMmk = Value(priceMmk),
       description = Value(description),
       isNew = Value(isNew),
       imageAsset = Value(imageAsset);
  static Insertable<ProductModel> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<int>? priceMmk,
    Expression<String>? description,
    Expression<bool>? isNew,
    Expression<int>? discountPercent,
    Expression<String>? imageAsset,
    Expression<String>? imageUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (priceMmk != null) 'price_mmk': priceMmk,
      if (description != null) 'description': description,
      if (isNew != null) 'is_new': isNew,
      if (discountPercent != null) 'discount_percent': discountPercent,
      if (imageAsset != null) 'image_asset': imageAsset,
      if (imageUrl != null) 'image_url': imageUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? name,
    Value<int>? priceMmk,
    Value<String>? description,
    Value<bool>? isNew,
    Value<int?>? discountPercent,
    Value<String>? imageAsset,
    Value<String?>? imageUrl,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      priceMmk: priceMmk ?? this.priceMmk,
      description: description ?? this.description,
      isNew: isNew ?? this.isNew,
      discountPercent: discountPercent ?? this.discountPercent,
      imageAsset: imageAsset ?? this.imageAsset,
      imageUrl: imageUrl ?? this.imageUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (priceMmk.present) {
      map['price_mmk'] = Variable<int>(priceMmk.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isNew.present) {
      map['is_new'] = Variable<bool>(isNew.value);
    }
    if (discountPercent.present) {
      map['discount_percent'] = Variable<int>(discountPercent.value);
    }
    if (imageAsset.present) {
      map['image_asset'] = Variable<String>(imageAsset.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('priceMmk: $priceMmk, ')
          ..write('description: $description, ')
          ..write('isNew: $isNew, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('imageAsset: $imageAsset, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$ProductModelInsertable implements Insertable<ProductModel> {
  ProductModel _object;
  _$ProductModelInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(_object.id),
      code: Value(_object.code),
      name: Value(_object.name),
      priceMmk: Value(_object.priceMmk),
      description: Value(_object.description),
      isNew: Value(_object.isNew),
      discountPercent: Value(_object.discountPercent),
      imageAsset: Value(_object.imageAsset),
      imageUrl: Value(_object.imageUrl),
    ).toColumns(false);
  }
}

extension ProductModelToInsertable on ProductModel {
  _$ProductModelInsertable toInsertable() {
    return _$ProductModelInsertable(this);
  }
}

class $BannersTable extends Banners with TableInfo<$BannersTable, BannerModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BannersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _badgeMeta = const VerificationMeta('badge');
  @override
  late final GeneratedColumn<String> badge = GeneratedColumn<String>(
    'badge',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _imageAssetMeta = const VerificationMeta(
    'imageAsset',
  );
  @override
  late final GeneratedColumn<String> imageAsset = GeneratedColumn<String>(
    'image_asset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    badge,
    position,
    imageAsset,
    imageUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'banners';
  @override
  VerificationContext validateIntegrity(
    Insertable<BannerModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('badge')) {
      context.handle(
        _badgeMeta,
        badge.isAcceptableOrUnknown(data['badge']!, _badgeMeta),
      );
    } else if (isInserting) {
      context.missing(_badgeMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('image_asset')) {
      context.handle(
        _imageAssetMeta,
        imageAsset.isAcceptableOrUnknown(data['image_asset']!, _imageAssetMeta),
      );
    } else if (isInserting) {
      context.missing(_imageAssetMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BannerModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BannerModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      badge: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}badge'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      imageAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_asset'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
    );
  }

  @override
  $BannersTable createAlias(String alias) {
    return $BannersTable(attachedDatabase, alias);
  }
}

class BannersCompanion extends UpdateCompanion<BannerModel> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> badge;
  final Value<int> position;
  final Value<String> imageAsset;
  final Value<String?> imageUrl;
  final Value<int> rowid;
  const BannersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.badge = const Value.absent(),
    this.position = const Value.absent(),
    this.imageAsset = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BannersCompanion.insert({
    required String id,
    required String title,
    required String badge,
    required int position,
    required String imageAsset,
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       badge = Value(badge),
       position = Value(position),
       imageAsset = Value(imageAsset);
  static Insertable<BannerModel> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? badge,
    Expression<int>? position,
    Expression<String>? imageAsset,
    Expression<String>? imageUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (badge != null) 'badge': badge,
      if (position != null) 'position': position,
      if (imageAsset != null) 'image_asset': imageAsset,
      if (imageUrl != null) 'image_url': imageUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BannersCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? badge,
    Value<int>? position,
    Value<String>? imageAsset,
    Value<String?>? imageUrl,
    Value<int>? rowid,
  }) {
    return BannersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      badge: badge ?? this.badge,
      position: position ?? this.position,
      imageAsset: imageAsset ?? this.imageAsset,
      imageUrl: imageUrl ?? this.imageUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (badge.present) {
      map['badge'] = Variable<String>(badge.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (imageAsset.present) {
      map['image_asset'] = Variable<String>(imageAsset.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BannersCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('badge: $badge, ')
          ..write('position: $position, ')
          ..write('imageAsset: $imageAsset, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$BannerModelInsertable implements Insertable<BannerModel> {
  BannerModel _object;
  _$BannerModelInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return BannersCompanion(
      id: Value(_object.id),
      title: Value(_object.title),
      badge: Value(_object.badge),
      position: Value(_object.position),
      imageAsset: Value(_object.imageAsset),
      imageUrl: Value(_object.imageUrl),
    ).toColumns(false);
  }
}

extension BannerModelToInsertable on BannerModel {
  _$BannerModelInsertable toInsertable() {
    return _$BannerModelInsertable(this);
  }
}

class $ShopsTable extends Shops with TableInfo<$ShopsTable, ShopModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShopsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _imageAssetMeta = const VerificationMeta(
    'imageAsset',
  );
  @override
  late final GeneratedColumn<String> imageAsset = GeneratedColumn<String>(
    'image_asset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    address,
    position,
    imageAsset,
    imageUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shops';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShopModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('image_asset')) {
      context.handle(
        _imageAssetMeta,
        imageAsset.isAcceptableOrUnknown(data['image_asset']!, _imageAssetMeta),
      );
    } else if (isInserting) {
      context.missing(_imageAssetMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShopModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShopModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      imageAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_asset'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
    );
  }

  @override
  $ShopsTable createAlias(String alias) {
    return $ShopsTable(attachedDatabase, alias);
  }
}

class ShopsCompanion extends UpdateCompanion<ShopModel> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> address;
  final Value<int> position;
  final Value<String> imageAsset;
  final Value<String?> imageUrl;
  final Value<int> rowid;
  const ShopsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.position = const Value.absent(),
    this.imageAsset = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShopsCompanion.insert({
    required String id,
    required String name,
    required String address,
    required int position,
    required String imageAsset,
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       address = Value(address),
       position = Value(position),
       imageAsset = Value(imageAsset);
  static Insertable<ShopModel> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<int>? position,
    Expression<String>? imageAsset,
    Expression<String>? imageUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (position != null) 'position': position,
      if (imageAsset != null) 'image_asset': imageAsset,
      if (imageUrl != null) 'image_url': imageUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShopsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? address,
    Value<int>? position,
    Value<String>? imageAsset,
    Value<String?>? imageUrl,
    Value<int>? rowid,
  }) {
    return ShopsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      position: position ?? this.position,
      imageAsset: imageAsset ?? this.imageAsset,
      imageUrl: imageUrl ?? this.imageUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (imageAsset.present) {
      map['image_asset'] = Variable<String>(imageAsset.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShopsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('position: $position, ')
          ..write('imageAsset: $imageAsset, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$ShopModelInsertable implements Insertable<ShopModel> {
  ShopModel _object;
  _$ShopModelInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return ShopsCompanion(
      id: Value(_object.id),
      name: Value(_object.name),
      address: Value(_object.address),
      position: Value(_object.position),
      imageAsset: Value(_object.imageAsset),
      imageUrl: Value(_object.imageUrl),
    ).toColumns(false);
  }
}

extension ShopModelToInsertable on ShopModel {
  _$ShopModelInsertable toInsertable() {
    return _$ShopModelInsertable(this);
  }
}

class $SectionProductsTable extends SectionProducts
    with TableInfo<$SectionProductsTable, SectionProductModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SectionProductsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumnWithTypeConverter<HomeSection, String> section =
      GeneratedColumn<String>(
        'section',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<HomeSection>($SectionProductsTable.$convertersection);
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [section, productId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'section_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<SectionProductModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {section, productId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {section, position},
  ];
  @override
  SectionProductModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SectionProductModel(
      section: $SectionProductsTable.$convertersection.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}section'],
        )!,
      ),
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $SectionProductsTable createAlias(String alias) {
    return $SectionProductsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<HomeSection, String, String> $convertersection =
      const EnumNameConverter<HomeSection>(HomeSection.values);
}

class SectionProductsCompanion extends UpdateCompanion<SectionProductModel> {
  final Value<HomeSection> section;
  final Value<String> productId;
  final Value<int> position;
  final Value<int> rowid;
  const SectionProductsCompanion({
    this.section = const Value.absent(),
    this.productId = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SectionProductsCompanion.insert({
    required HomeSection section,
    required String productId,
    required int position,
    this.rowid = const Value.absent(),
  }) : section = Value(section),
       productId = Value(productId),
       position = Value(position);
  static Insertable<SectionProductModel> custom({
    Expression<String>? section,
    Expression<String>? productId,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (section != null) 'section': section,
      if (productId != null) 'product_id': productId,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SectionProductsCompanion copyWith({
    Value<HomeSection>? section,
    Value<String>? productId,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return SectionProductsCompanion(
      section: section ?? this.section,
      productId: productId ?? this.productId,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (section.present) {
      map['section'] = Variable<String>(
        $SectionProductsTable.$convertersection.toSql(section.value),
      );
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SectionProductsCompanion(')
          ..write('section: $section, ')
          ..write('productId: $productId, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$SectionProductModelInsertable
    implements Insertable<SectionProductModel> {
  SectionProductModel _object;
  _$SectionProductModelInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return SectionProductsCompanion(
      section: Value(_object.section),
      productId: Value(_object.productId),
      position: Value(_object.position),
    ).toColumns(false);
  }
}

extension SectionProductModelToInsertable on SectionProductModel {
  _$SectionProductModelInsertable toInsertable() {
    return _$SectionProductModelInsertable(this);
  }
}

class $MembersTable extends Members with TableInfo<$MembersTable, MemberModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<String> birthDate = GeneratedColumn<String>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    check: () => ComparableExpr(points).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notificationCountMeta = const VerificationMeta(
    'notificationCount',
  );
  @override
  late final GeneratedColumn<int> notificationCount = GeneratedColumn<int>(
    'notification_count',
    aliasedName,
    false,
    check: () => ComparableExpr(notificationCount).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rewardsBadgeCountMeta = const VerificationMeta(
    'rewardsBadgeCount',
  );
  @override
  late final GeneratedColumn<int> rewardsBadgeCount = GeneratedColumn<int>(
    'rewards_badge_count',
    aliasedName,
    false,
    check: () => ComparableExpr(rewardsBadgeCount).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageAssetMeta = const VerificationMeta(
    'imageAsset',
  );
  @override
  late final GeneratedColumn<String> imageAsset = GeneratedColumn<String>(
    'image_asset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    firstName,
    lastName,
    phone,
    birthDate,
    points,
    notificationCount,
    rewardsBadgeCount,
    imageAsset,
    imageUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'members';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemberModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('notification_count')) {
      context.handle(
        _notificationCountMeta,
        notificationCount.isAcceptableOrUnknown(
          data['notification_count']!,
          _notificationCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationCountMeta);
    }
    if (data.containsKey('rewards_badge_count')) {
      context.handle(
        _rewardsBadgeCountMeta,
        rewardsBadgeCount.isAcceptableOrUnknown(
          data['rewards_badge_count']!,
          _rewardsBadgeCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rewardsBadgeCountMeta);
    }
    if (data.containsKey('image_asset')) {
      context.handle(
        _imageAssetMeta,
        imageAsset.isAcceptableOrUnknown(data['image_asset']!, _imageAssetMeta),
      );
    } else if (isInserting) {
      context.missing(_imageAssetMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemberModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemberModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_date'],
      ),
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      notificationCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_count'],
      )!,
      rewardsBadgeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rewards_badge_count'],
      )!,
      imageAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_asset'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
    );
  }

  @override
  $MembersTable createAlias(String alias) {
    return $MembersTable(attachedDatabase, alias);
  }
}

class MembersCompanion extends UpdateCompanion<MemberModel> {
  final Value<String> id;
  final Value<String> firstName;
  final Value<String?> lastName;
  final Value<String?> phone;
  final Value<String?> birthDate;
  final Value<int> points;
  final Value<int> notificationCount;
  final Value<int> rewardsBadgeCount;
  final Value<String> imageAsset;
  final Value<String?> imageUrl;
  final Value<int> rowid;
  const MembersCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.phone = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.points = const Value.absent(),
    this.notificationCount = const Value.absent(),
    this.rewardsBadgeCount = const Value.absent(),
    this.imageAsset = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MembersCompanion.insert({
    required String id,
    required String firstName,
    this.lastName = const Value.absent(),
    this.phone = const Value.absent(),
    this.birthDate = const Value.absent(),
    required int points,
    required int notificationCount,
    required int rewardsBadgeCount,
    required String imageAsset,
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       firstName = Value(firstName),
       points = Value(points),
       notificationCount = Value(notificationCount),
       rewardsBadgeCount = Value(rewardsBadgeCount),
       imageAsset = Value(imageAsset);
  static Insertable<MemberModel> custom({
    Expression<String>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? phone,
    Expression<String>? birthDate,
    Expression<int>? points,
    Expression<int>? notificationCount,
    Expression<int>? rewardsBadgeCount,
    Expression<String>? imageAsset,
    Expression<String>? imageUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (phone != null) 'phone': phone,
      if (birthDate != null) 'birth_date': birthDate,
      if (points != null) 'points': points,
      if (notificationCount != null) 'notification_count': notificationCount,
      if (rewardsBadgeCount != null) 'rewards_badge_count': rewardsBadgeCount,
      if (imageAsset != null) 'image_asset': imageAsset,
      if (imageUrl != null) 'image_url': imageUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MembersCompanion copyWith({
    Value<String>? id,
    Value<String>? firstName,
    Value<String?>? lastName,
    Value<String?>? phone,
    Value<String?>? birthDate,
    Value<int>? points,
    Value<int>? notificationCount,
    Value<int>? rewardsBadgeCount,
    Value<String>? imageAsset,
    Value<String?>? imageUrl,
    Value<int>? rowid,
  }) {
    return MembersCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      points: points ?? this.points,
      notificationCount: notificationCount ?? this.notificationCount,
      rewardsBadgeCount: rewardsBadgeCount ?? this.rewardsBadgeCount,
      imageAsset: imageAsset ?? this.imageAsset,
      imageUrl: imageUrl ?? this.imageUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<String>(birthDate.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (notificationCount.present) {
      map['notification_count'] = Variable<int>(notificationCount.value);
    }
    if (rewardsBadgeCount.present) {
      map['rewards_badge_count'] = Variable<int>(rewardsBadgeCount.value);
    }
    if (imageAsset.present) {
      map['image_asset'] = Variable<String>(imageAsset.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MembersCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('phone: $phone, ')
          ..write('birthDate: $birthDate, ')
          ..write('points: $points, ')
          ..write('notificationCount: $notificationCount, ')
          ..write('rewardsBadgeCount: $rewardsBadgeCount, ')
          ..write('imageAsset: $imageAsset, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$MemberModelInsertable implements Insertable<MemberModel> {
  MemberModel _object;
  _$MemberModelInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return MembersCompanion(
      id: Value(_object.id),
      firstName: Value(_object.firstName),
      lastName: Value(_object.lastName),
      phone: Value(_object.phone),
      birthDate: Value(_object.birthDate),
      points: Value(_object.points),
      notificationCount: Value(_object.notificationCount),
      rewardsBadgeCount: Value(_object.rewardsBadgeCount),
      imageAsset: Value(_object.imageAsset),
      imageUrl: Value(_object.imageUrl),
    ).toColumns(false);
  }
}

extension MemberModelToInsertable on MemberModel {
  _$MemberModelInsertable toInsertable() {
    return _$MemberModelInsertable(this);
  }
}

class $RewardTiersTable extends RewardTiers
    with TableInfo<$RewardTiersTable, TierModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RewardTiersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minimumPointsMeta = const VerificationMeta(
    'minimumPoints',
  );
  @override
  late final GeneratedColumn<int> minimumPoints = GeneratedColumn<int>(
    'minimum_points',
    aliasedName,
    false,
    check: () => ComparableExpr(minimumPoints).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, minimumPoints];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reward_tiers';
  @override
  VerificationContext validateIntegrity(
    Insertable<TierModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('minimum_points')) {
      context.handle(
        _minimumPointsMeta,
        minimumPoints.isAcceptableOrUnknown(
          data['minimum_points']!,
          _minimumPointsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minimumPointsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TierModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TierModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      minimumPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minimum_points'],
      )!,
    );
  }

  @override
  $RewardTiersTable createAlias(String alias) {
    return $RewardTiersTable(attachedDatabase, alias);
  }
}

class RewardTiersCompanion extends UpdateCompanion<TierModel> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> minimumPoints;
  final Value<int> rowid;
  const RewardTiersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.minimumPoints = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RewardTiersCompanion.insert({
    required String id,
    required String name,
    required int minimumPoints,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       minimumPoints = Value(minimumPoints);
  static Insertable<TierModel> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? minimumPoints,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (minimumPoints != null) 'minimum_points': minimumPoints,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RewardTiersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? minimumPoints,
    Value<int>? rowid,
  }) {
    return RewardTiersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      minimumPoints: minimumPoints ?? this.minimumPoints,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (minimumPoints.present) {
      map['minimum_points'] = Variable<int>(minimumPoints.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RewardTiersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('minimumPoints: $minimumPoints, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$TierModelInsertable implements Insertable<TierModel> {
  TierModel _object;
  _$TierModelInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return RewardTiersCompanion(
      id: Value(_object.id),
      name: Value(_object.name),
      minimumPoints: Value(_object.minimumPoints),
    ).toColumns(false);
  }
}

extension TierModelToInsertable on TierModel {
  _$TierModelInsertable toInsertable() {
    return _$TierModelInsertable(this);
  }
}

class $RewardChallengesTable extends RewardChallenges
    with TableInfo<$RewardChallengesTable, ChallengeModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RewardChallengesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ChallengeArtwork, String>
  artwork = GeneratedColumn<String>(
    'artwork',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ChallengeArtwork>($RewardChallengesTable.$converterartwork);
  static const VerificationMeta _completedQuantityMeta = const VerificationMeta(
    'completedQuantity',
  );
  @override
  late final GeneratedColumn<int> completedQuantity = GeneratedColumn<int>(
    'completed_quantity',
    aliasedName,
    false,
    check: () => ComparableExpr(
      completedQuantity,
    ).isBetween(const Constant(0), targetQuantity),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetQuantityMeta = const VerificationMeta(
    'targetQuantity',
  );
  @override
  late final GeneratedColumn<int> targetQuantity = GeneratedColumn<int>(
    'target_quantity',
    aliasedName,
    false,
    check: () => ComparableExpr(targetQuantity).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rewardPointsMeta = const VerificationMeta(
    'rewardPoints',
  );
  @override
  late final GeneratedColumn<int> rewardPoints = GeneratedColumn<int>(
    'reward_points',
    aliasedName,
    false,
    check: () => ComparableExpr(rewardPoints).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _imageAssetMeta = const VerificationMeta(
    'imageAsset',
  );
  @override
  late final GeneratedColumn<String> imageAsset = GeneratedColumn<String>(
    'image_asset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    artwork,
    completedQuantity,
    targetQuantity,
    rewardPoints,
    position,
    imageAsset,
    imageUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reward_challenges';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChallengeModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('completed_quantity')) {
      context.handle(
        _completedQuantityMeta,
        completedQuantity.isAcceptableOrUnknown(
          data['completed_quantity']!,
          _completedQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedQuantityMeta);
    }
    if (data.containsKey('target_quantity')) {
      context.handle(
        _targetQuantityMeta,
        targetQuantity.isAcceptableOrUnknown(
          data['target_quantity']!,
          _targetQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetQuantityMeta);
    }
    if (data.containsKey('reward_points')) {
      context.handle(
        _rewardPointsMeta,
        rewardPoints.isAcceptableOrUnknown(
          data['reward_points']!,
          _rewardPointsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rewardPointsMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('image_asset')) {
      context.handle(
        _imageAssetMeta,
        imageAsset.isAcceptableOrUnknown(data['image_asset']!, _imageAssetMeta),
      );
    } else if (isInserting) {
      context.missing(_imageAssetMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChallengeModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChallengeModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      artwork: $RewardChallengesTable.$converterartwork.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}artwork'],
        )!,
      ),
      completedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_quantity'],
      )!,
      targetQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_quantity'],
      )!,
      rewardPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reward_points'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      imageAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_asset'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
    );
  }

  @override
  $RewardChallengesTable createAlias(String alias) {
    return $RewardChallengesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ChallengeArtwork, String, String>
  $converterartwork = const EnumNameConverter<ChallengeArtwork>(
    ChallengeArtwork.values,
  );
}

class RewardChallengesCompanion extends UpdateCompanion<ChallengeModel> {
  final Value<String> id;
  final Value<String> title;
  final Value<ChallengeArtwork> artwork;
  final Value<int> completedQuantity;
  final Value<int> targetQuantity;
  final Value<int> rewardPoints;
  final Value<int> position;
  final Value<String> imageAsset;
  final Value<String?> imageUrl;
  final Value<int> rowid;
  const RewardChallengesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.artwork = const Value.absent(),
    this.completedQuantity = const Value.absent(),
    this.targetQuantity = const Value.absent(),
    this.rewardPoints = const Value.absent(),
    this.position = const Value.absent(),
    this.imageAsset = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RewardChallengesCompanion.insert({
    required String id,
    required String title,
    required ChallengeArtwork artwork,
    required int completedQuantity,
    required int targetQuantity,
    required int rewardPoints,
    required int position,
    required String imageAsset,
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       artwork = Value(artwork),
       completedQuantity = Value(completedQuantity),
       targetQuantity = Value(targetQuantity),
       rewardPoints = Value(rewardPoints),
       position = Value(position),
       imageAsset = Value(imageAsset);
  static Insertable<ChallengeModel> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? artwork,
    Expression<int>? completedQuantity,
    Expression<int>? targetQuantity,
    Expression<int>? rewardPoints,
    Expression<int>? position,
    Expression<String>? imageAsset,
    Expression<String>? imageUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (artwork != null) 'artwork': artwork,
      if (completedQuantity != null) 'completed_quantity': completedQuantity,
      if (targetQuantity != null) 'target_quantity': targetQuantity,
      if (rewardPoints != null) 'reward_points': rewardPoints,
      if (position != null) 'position': position,
      if (imageAsset != null) 'image_asset': imageAsset,
      if (imageUrl != null) 'image_url': imageUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RewardChallengesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<ChallengeArtwork>? artwork,
    Value<int>? completedQuantity,
    Value<int>? targetQuantity,
    Value<int>? rewardPoints,
    Value<int>? position,
    Value<String>? imageAsset,
    Value<String?>? imageUrl,
    Value<int>? rowid,
  }) {
    return RewardChallengesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      artwork: artwork ?? this.artwork,
      completedQuantity: completedQuantity ?? this.completedQuantity,
      targetQuantity: targetQuantity ?? this.targetQuantity,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      position: position ?? this.position,
      imageAsset: imageAsset ?? this.imageAsset,
      imageUrl: imageUrl ?? this.imageUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (artwork.present) {
      map['artwork'] = Variable<String>(
        $RewardChallengesTable.$converterartwork.toSql(artwork.value),
      );
    }
    if (completedQuantity.present) {
      map['completed_quantity'] = Variable<int>(completedQuantity.value);
    }
    if (targetQuantity.present) {
      map['target_quantity'] = Variable<int>(targetQuantity.value);
    }
    if (rewardPoints.present) {
      map['reward_points'] = Variable<int>(rewardPoints.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (imageAsset.present) {
      map['image_asset'] = Variable<String>(imageAsset.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RewardChallengesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('artwork: $artwork, ')
          ..write('completedQuantity: $completedQuantity, ')
          ..write('targetQuantity: $targetQuantity, ')
          ..write('rewardPoints: $rewardPoints, ')
          ..write('position: $position, ')
          ..write('imageAsset: $imageAsset, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$ChallengeModelInsertable implements Insertable<ChallengeModel> {
  ChallengeModel _object;
  _$ChallengeModelInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return RewardChallengesCompanion(
      id: Value(_object.id),
      title: Value(_object.title),
      artwork: Value(_object.artwork),
      completedQuantity: Value(_object.completedQuantity),
      targetQuantity: Value(_object.targetQuantity),
      rewardPoints: Value(_object.rewardPoints),
      position: Value(_object.position),
      imageAsset: Value(_object.imageAsset),
      imageUrl: Value(_object.imageUrl),
    ).toColumns(false);
  }
}

extension ChallengeModelToInsertable on ChallengeModel {
  _$ChallengeModelInsertable toInsertable() {
    return _$ChallengeModelInsertable(this);
  }
}

class $CatalogVersionsTable extends CatalogVersions
    with TableInfo<$CatalogVersionsTable, CatalogVersion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogVersionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, revision];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_versions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogVersion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogVersion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogVersion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  $CatalogVersionsTable createAlias(String alias) {
    return $CatalogVersionsTable(attachedDatabase, alias);
  }
}

class CatalogVersion extends DataClass implements Insertable<CatalogVersion> {
  final int id;
  final int revision;
  const CatalogVersion({required this.id, required this.revision});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  CatalogVersionsCompanion toCompanion(bool nullToAbsent) {
    return CatalogVersionsCompanion(id: Value(id), revision: Value(revision));
  }

  factory CatalogVersion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogVersion(
      id: serializer.fromJson<int>(json['id']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'revision': serializer.toJson<int>(revision),
    };
  }

  CatalogVersion copyWith({int? id, int? revision}) =>
      CatalogVersion(id: id ?? this.id, revision: revision ?? this.revision);
  CatalogVersion copyWithCompanion(CatalogVersionsCompanion data) {
    return CatalogVersion(
      id: data.id.present ? data.id.value : this.id,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogVersion(')
          ..write('id: $id, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, revision);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogVersion &&
          other.id == this.id &&
          other.revision == this.revision);
}

class CatalogVersionsCompanion extends UpdateCompanion<CatalogVersion> {
  final Value<int> id;
  final Value<int> revision;
  const CatalogVersionsCompanion({
    this.id = const Value.absent(),
    this.revision = const Value.absent(),
  });
  CatalogVersionsCompanion.insert({
    this.id = const Value.absent(),
    required int revision,
  }) : revision = Value(revision);
  static Insertable<CatalogVersion> custom({
    Expression<int>? id,
    Expression<int>? revision,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revision != null) 'revision': revision,
    });
  }

  CatalogVersionsCompanion copyWith({Value<int>? id, Value<int>? revision}) {
    return CatalogVersionsCompanion(
      id: id ?? this.id,
      revision: revision ?? this.revision,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogVersionsCompanion(')
          ..write('id: $id, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $BannersTable banners = $BannersTable(this);
  late final $ShopsTable shops = $ShopsTable(this);
  late final $SectionProductsTable sectionProducts = $SectionProductsTable(
    this,
  );
  late final $MembersTable members = $MembersTable(this);
  late final $RewardTiersTable rewardTiers = $RewardTiersTable(this);
  late final $RewardChallengesTable rewardChallenges = $RewardChallengesTable(
    this,
  );
  late final $CatalogVersionsTable catalogVersions = $CatalogVersionsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    banners,
    shops,
    sectionProducts,
    members,
    rewardTiers,
    rewardChallenges,
    catalogVersions,
  ];
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String code,
      required String name,
      required int priceMmk,
      required String description,
      required bool isNew,
      Value<int?> discountPercent,
      required String imageAsset,
      Value<String?> imageUrl,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> name,
      Value<int> priceMmk,
      Value<String> description,
      Value<bool> isNew,
      Value<int?> discountPercent,
      Value<String> imageAsset,
      Value<String?> imageUrl,
      Value<int> rowid,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, ProductModel> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SectionProductsTable, List<SectionProductModel>>
  _sectionProductsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sectionProducts,
    aliasName: $_aliasNameGenerator(
      db.products.id,
      db.sectionProducts.productId,
    ),
  );

  $$SectionProductsTableProcessedTableManager get sectionProductsRefs {
    final manager = $$SectionProductsTableTableManager(
      $_db,
      $_db.sectionProducts,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sectionProductsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceMmk => $composableBuilder(
    column: $table.priceMmk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isNew => $composableBuilder(
    column: $table.isNew,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sectionProductsRefs(
    Expression<bool> Function($$SectionProductsTableFilterComposer f) f,
  ) {
    final $$SectionProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sectionProducts,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionProductsTableFilterComposer(
            $db: $db,
            $table: $db.sectionProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceMmk => $composableBuilder(
    column: $table.priceMmk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isNew => $composableBuilder(
    column: $table.isNew,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get priceMmk =>
      $composableBuilder(column: $table.priceMmk, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isNew =>
      $composableBuilder(column: $table.isNew, builder: (column) => column);

  GeneratedColumn<int> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  Expression<T> sectionProductsRefs<T extends Object>(
    Expression<T> Function($$SectionProductsTableAnnotationComposer a) f,
  ) {
    final $$SectionProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sectionProducts,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.sectionProducts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          ProductModel,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (ProductModel, $$ProductsTableReferences),
          ProductModel,
          PrefetchHooks Function({bool sectionProductsRefs})
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> priceMmk = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<bool> isNew = const Value.absent(),
                Value<int?> discountPercent = const Value.absent(),
                Value<String> imageAsset = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                code: code,
                name: name,
                priceMmk: priceMmk,
                description: description,
                isNew: isNew,
                discountPercent: discountPercent,
                imageAsset: imageAsset,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String name,
                required int priceMmk,
                required String description,
                required bool isNew,
                Value<int?> discountPercent = const Value.absent(),
                required String imageAsset,
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                code: code,
                name: name,
                priceMmk: priceMmk,
                description: description,
                isNew: isNew,
                discountPercent: discountPercent,
                imageAsset: imageAsset,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sectionProductsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sectionProductsRefs) db.sectionProducts,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sectionProductsRefs)
                    await $_getPrefetchedData<
                      ProductModel,
                      $ProductsTable,
                      SectionProductModel
                    >(
                      currentTable: table,
                      referencedTable: $$ProductsTableReferences
                          ._sectionProductsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ProductsTableReferences(
                        db,
                        table,
                        p0,
                      ).sectionProductsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.productId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      ProductModel,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (ProductModel, $$ProductsTableReferences),
      ProductModel,
      PrefetchHooks Function({bool sectionProductsRefs})
    >;
typedef $$BannersTableCreateCompanionBuilder =
    BannersCompanion Function({
      required String id,
      required String title,
      required String badge,
      required int position,
      required String imageAsset,
      Value<String?> imageUrl,
      Value<int> rowid,
    });
typedef $$BannersTableUpdateCompanionBuilder =
    BannersCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> badge,
      Value<int> position,
      Value<String> imageAsset,
      Value<String?> imageUrl,
      Value<int> rowid,
    });

class $$BannersTableFilterComposer
    extends Composer<_$AppDatabase, $BannersTable> {
  $$BannersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get badge => $composableBuilder(
    column: $table.badge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BannersTableOrderingComposer
    extends Composer<_$AppDatabase, $BannersTable> {
  $$BannersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get badge => $composableBuilder(
    column: $table.badge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BannersTableAnnotationComposer
    extends Composer<_$AppDatabase, $BannersTable> {
  $$BannersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get badge =>
      $composableBuilder(column: $table.badge, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);
}

class $$BannersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BannersTable,
          BannerModel,
          $$BannersTableFilterComposer,
          $$BannersTableOrderingComposer,
          $$BannersTableAnnotationComposer,
          $$BannersTableCreateCompanionBuilder,
          $$BannersTableUpdateCompanionBuilder,
          (
            BannerModel,
            BaseReferences<_$AppDatabase, $BannersTable, BannerModel>,
          ),
          BannerModel,
          PrefetchHooks Function()
        > {
  $$BannersTableTableManager(_$AppDatabase db, $BannersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BannersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BannersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BannersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> badge = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> imageAsset = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BannersCompanion(
                id: id,
                title: title,
                badge: badge,
                position: position,
                imageAsset: imageAsset,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String badge,
                required int position,
                required String imageAsset,
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BannersCompanion.insert(
                id: id,
                title: title,
                badge: badge,
                position: position,
                imageAsset: imageAsset,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BannersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BannersTable,
      BannerModel,
      $$BannersTableFilterComposer,
      $$BannersTableOrderingComposer,
      $$BannersTableAnnotationComposer,
      $$BannersTableCreateCompanionBuilder,
      $$BannersTableUpdateCompanionBuilder,
      (BannerModel, BaseReferences<_$AppDatabase, $BannersTable, BannerModel>),
      BannerModel,
      PrefetchHooks Function()
    >;
typedef $$ShopsTableCreateCompanionBuilder =
    ShopsCompanion Function({
      required String id,
      required String name,
      required String address,
      required int position,
      required String imageAsset,
      Value<String?> imageUrl,
      Value<int> rowid,
    });
typedef $$ShopsTableUpdateCompanionBuilder =
    ShopsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> address,
      Value<int> position,
      Value<String> imageAsset,
      Value<String?> imageUrl,
      Value<int> rowid,
    });

class $$ShopsTableFilterComposer extends Composer<_$AppDatabase, $ShopsTable> {
  $$ShopsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShopsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShopsTable> {
  $$ShopsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShopsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShopsTable> {
  $$ShopsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);
}

class $$ShopsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShopsTable,
          ShopModel,
          $$ShopsTableFilterComposer,
          $$ShopsTableOrderingComposer,
          $$ShopsTableAnnotationComposer,
          $$ShopsTableCreateCompanionBuilder,
          $$ShopsTableUpdateCompanionBuilder,
          (ShopModel, BaseReferences<_$AppDatabase, $ShopsTable, ShopModel>),
          ShopModel,
          PrefetchHooks Function()
        > {
  $$ShopsTableTableManager(_$AppDatabase db, $ShopsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShopsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShopsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShopsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> imageAsset = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShopsCompanion(
                id: id,
                name: name,
                address: address,
                position: position,
                imageAsset: imageAsset,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String address,
                required int position,
                required String imageAsset,
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShopsCompanion.insert(
                id: id,
                name: name,
                address: address,
                position: position,
                imageAsset: imageAsset,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShopsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShopsTable,
      ShopModel,
      $$ShopsTableFilterComposer,
      $$ShopsTableOrderingComposer,
      $$ShopsTableAnnotationComposer,
      $$ShopsTableCreateCompanionBuilder,
      $$ShopsTableUpdateCompanionBuilder,
      (ShopModel, BaseReferences<_$AppDatabase, $ShopsTable, ShopModel>),
      ShopModel,
      PrefetchHooks Function()
    >;
typedef $$SectionProductsTableCreateCompanionBuilder =
    SectionProductsCompanion Function({
      required HomeSection section,
      required String productId,
      required int position,
      Value<int> rowid,
    });
typedef $$SectionProductsTableUpdateCompanionBuilder =
    SectionProductsCompanion Function({
      Value<HomeSection> section,
      Value<String> productId,
      Value<int> position,
      Value<int> rowid,
    });

final class $$SectionProductsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SectionProductsTable,
          SectionProductModel
        > {
  $$SectionProductsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(db.sectionProducts.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SectionProductsTableFilterComposer
    extends Composer<_$AppDatabase, $SectionProductsTable> {
  $$SectionProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<HomeSection, HomeSection, String>
  get section => $composableBuilder(
    column: $table.section,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SectionProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $SectionProductsTable> {
  $$SectionProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get section => $composableBuilder(
    column: $table.section,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SectionProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SectionProductsTable> {
  $$SectionProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<HomeSection, String> get section =>
      $composableBuilder(column: $table.section, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SectionProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SectionProductsTable,
          SectionProductModel,
          $$SectionProductsTableFilterComposer,
          $$SectionProductsTableOrderingComposer,
          $$SectionProductsTableAnnotationComposer,
          $$SectionProductsTableCreateCompanionBuilder,
          $$SectionProductsTableUpdateCompanionBuilder,
          (SectionProductModel, $$SectionProductsTableReferences),
          SectionProductModel,
          PrefetchHooks Function({bool productId})
        > {
  $$SectionProductsTableTableManager(
    _$AppDatabase db,
    $SectionProductsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SectionProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SectionProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SectionProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<HomeSection> section = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SectionProductsCompanion(
                section: section,
                productId: productId,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required HomeSection section,
                required String productId,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => SectionProductsCompanion.insert(
                section: section,
                productId: productId,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SectionProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable:
                                    $$SectionProductsTableReferences
                                        ._productIdTable(db),
                                referencedColumn:
                                    $$SectionProductsTableReferences
                                        ._productIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SectionProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SectionProductsTable,
      SectionProductModel,
      $$SectionProductsTableFilterComposer,
      $$SectionProductsTableOrderingComposer,
      $$SectionProductsTableAnnotationComposer,
      $$SectionProductsTableCreateCompanionBuilder,
      $$SectionProductsTableUpdateCompanionBuilder,
      (SectionProductModel, $$SectionProductsTableReferences),
      SectionProductModel,
      PrefetchHooks Function({bool productId})
    >;
typedef $$MembersTableCreateCompanionBuilder =
    MembersCompanion Function({
      required String id,
      required String firstName,
      Value<String?> lastName,
      Value<String?> phone,
      Value<String?> birthDate,
      required int points,
      required int notificationCount,
      required int rewardsBadgeCount,
      required String imageAsset,
      Value<String?> imageUrl,
      Value<int> rowid,
    });
typedef $$MembersTableUpdateCompanionBuilder =
    MembersCompanion Function({
      Value<String> id,
      Value<String> firstName,
      Value<String?> lastName,
      Value<String?> phone,
      Value<String?> birthDate,
      Value<int> points,
      Value<int> notificationCount,
      Value<int> rewardsBadgeCount,
      Value<String> imageAsset,
      Value<String?> imageUrl,
      Value<int> rowid,
    });

class $$MembersTableFilterComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notificationCount => $composableBuilder(
    column: $table.notificationCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rewardsBadgeCount => $composableBuilder(
    column: $table.rewardsBadgeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MembersTableOrderingComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notificationCount => $composableBuilder(
    column: $table.notificationCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rewardsBadgeCount => $composableBuilder(
    column: $table.rewardsBadgeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<int> get notificationCount => $composableBuilder(
    column: $table.notificationCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rewardsBadgeCount => $composableBuilder(
    column: $table.rewardsBadgeCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);
}

class $$MembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MembersTable,
          MemberModel,
          $$MembersTableFilterComposer,
          $$MembersTableOrderingComposer,
          $$MembersTableAnnotationComposer,
          $$MembersTableCreateCompanionBuilder,
          $$MembersTableUpdateCompanionBuilder,
          (
            MemberModel,
            BaseReferences<_$AppDatabase, $MembersTable, MemberModel>,
          ),
          MemberModel,
          PrefetchHooks Function()
        > {
  $$MembersTableTableManager(_$AppDatabase db, $MembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String?> lastName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> birthDate = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<int> notificationCount = const Value.absent(),
                Value<int> rewardsBadgeCount = const Value.absent(),
                Value<String> imageAsset = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MembersCompanion(
                id: id,
                firstName: firstName,
                lastName: lastName,
                phone: phone,
                birthDate: birthDate,
                points: points,
                notificationCount: notificationCount,
                rewardsBadgeCount: rewardsBadgeCount,
                imageAsset: imageAsset,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String firstName,
                Value<String?> lastName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> birthDate = const Value.absent(),
                required int points,
                required int notificationCount,
                required int rewardsBadgeCount,
                required String imageAsset,
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MembersCompanion.insert(
                id: id,
                firstName: firstName,
                lastName: lastName,
                phone: phone,
                birthDate: birthDate,
                points: points,
                notificationCount: notificationCount,
                rewardsBadgeCount: rewardsBadgeCount,
                imageAsset: imageAsset,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MembersTable,
      MemberModel,
      $$MembersTableFilterComposer,
      $$MembersTableOrderingComposer,
      $$MembersTableAnnotationComposer,
      $$MembersTableCreateCompanionBuilder,
      $$MembersTableUpdateCompanionBuilder,
      (MemberModel, BaseReferences<_$AppDatabase, $MembersTable, MemberModel>),
      MemberModel,
      PrefetchHooks Function()
    >;
typedef $$RewardTiersTableCreateCompanionBuilder =
    RewardTiersCompanion Function({
      required String id,
      required String name,
      required int minimumPoints,
      Value<int> rowid,
    });
typedef $$RewardTiersTableUpdateCompanionBuilder =
    RewardTiersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> minimumPoints,
      Value<int> rowid,
    });

class $$RewardTiersTableFilterComposer
    extends Composer<_$AppDatabase, $RewardTiersTable> {
  $$RewardTiersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minimumPoints => $composableBuilder(
    column: $table.minimumPoints,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RewardTiersTableOrderingComposer
    extends Composer<_$AppDatabase, $RewardTiersTable> {
  $$RewardTiersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minimumPoints => $composableBuilder(
    column: $table.minimumPoints,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RewardTiersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RewardTiersTable> {
  $$RewardTiersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get minimumPoints => $composableBuilder(
    column: $table.minimumPoints,
    builder: (column) => column,
  );
}

class $$RewardTiersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RewardTiersTable,
          TierModel,
          $$RewardTiersTableFilterComposer,
          $$RewardTiersTableOrderingComposer,
          $$RewardTiersTableAnnotationComposer,
          $$RewardTiersTableCreateCompanionBuilder,
          $$RewardTiersTableUpdateCompanionBuilder,
          (
            TierModel,
            BaseReferences<_$AppDatabase, $RewardTiersTable, TierModel>,
          ),
          TierModel,
          PrefetchHooks Function()
        > {
  $$RewardTiersTableTableManager(_$AppDatabase db, $RewardTiersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RewardTiersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RewardTiersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RewardTiersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> minimumPoints = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardTiersCompanion(
                id: id,
                name: name,
                minimumPoints: minimumPoints,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int minimumPoints,
                Value<int> rowid = const Value.absent(),
              }) => RewardTiersCompanion.insert(
                id: id,
                name: name,
                minimumPoints: minimumPoints,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RewardTiersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RewardTiersTable,
      TierModel,
      $$RewardTiersTableFilterComposer,
      $$RewardTiersTableOrderingComposer,
      $$RewardTiersTableAnnotationComposer,
      $$RewardTiersTableCreateCompanionBuilder,
      $$RewardTiersTableUpdateCompanionBuilder,
      (TierModel, BaseReferences<_$AppDatabase, $RewardTiersTable, TierModel>),
      TierModel,
      PrefetchHooks Function()
    >;
typedef $$RewardChallengesTableCreateCompanionBuilder =
    RewardChallengesCompanion Function({
      required String id,
      required String title,
      required ChallengeArtwork artwork,
      required int completedQuantity,
      required int targetQuantity,
      required int rewardPoints,
      required int position,
      required String imageAsset,
      Value<String?> imageUrl,
      Value<int> rowid,
    });
typedef $$RewardChallengesTableUpdateCompanionBuilder =
    RewardChallengesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<ChallengeArtwork> artwork,
      Value<int> completedQuantity,
      Value<int> targetQuantity,
      Value<int> rewardPoints,
      Value<int> position,
      Value<String> imageAsset,
      Value<String?> imageUrl,
      Value<int> rowid,
    });

class $$RewardChallengesTableFilterComposer
    extends Composer<_$AppDatabase, $RewardChallengesTable> {
  $$RewardChallengesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ChallengeArtwork, ChallengeArtwork, String>
  get artwork => $composableBuilder(
    column: $table.artwork,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get completedQuantity => $composableBuilder(
    column: $table.completedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetQuantity => $composableBuilder(
    column: $table.targetQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rewardPoints => $composableBuilder(
    column: $table.rewardPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RewardChallengesTableOrderingComposer
    extends Composer<_$AppDatabase, $RewardChallengesTable> {
  $$RewardChallengesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artwork => $composableBuilder(
    column: $table.artwork,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedQuantity => $composableBuilder(
    column: $table.completedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetQuantity => $composableBuilder(
    column: $table.targetQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rewardPoints => $composableBuilder(
    column: $table.rewardPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RewardChallengesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RewardChallengesTable> {
  $$RewardChallengesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ChallengeArtwork, String> get artwork =>
      $composableBuilder(column: $table.artwork, builder: (column) => column);

  GeneratedColumn<int> get completedQuantity => $composableBuilder(
    column: $table.completedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetQuantity => $composableBuilder(
    column: $table.targetQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rewardPoints => $composableBuilder(
    column: $table.rewardPoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);
}

class $$RewardChallengesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RewardChallengesTable,
          ChallengeModel,
          $$RewardChallengesTableFilterComposer,
          $$RewardChallengesTableOrderingComposer,
          $$RewardChallengesTableAnnotationComposer,
          $$RewardChallengesTableCreateCompanionBuilder,
          $$RewardChallengesTableUpdateCompanionBuilder,
          (
            ChallengeModel,
            BaseReferences<
              _$AppDatabase,
              $RewardChallengesTable,
              ChallengeModel
            >,
          ),
          ChallengeModel,
          PrefetchHooks Function()
        > {
  $$RewardChallengesTableTableManager(
    _$AppDatabase db,
    $RewardChallengesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RewardChallengesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RewardChallengesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RewardChallengesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<ChallengeArtwork> artwork = const Value.absent(),
                Value<int> completedQuantity = const Value.absent(),
                Value<int> targetQuantity = const Value.absent(),
                Value<int> rewardPoints = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> imageAsset = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardChallengesCompanion(
                id: id,
                title: title,
                artwork: artwork,
                completedQuantity: completedQuantity,
                targetQuantity: targetQuantity,
                rewardPoints: rewardPoints,
                position: position,
                imageAsset: imageAsset,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required ChallengeArtwork artwork,
                required int completedQuantity,
                required int targetQuantity,
                required int rewardPoints,
                required int position,
                required String imageAsset,
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardChallengesCompanion.insert(
                id: id,
                title: title,
                artwork: artwork,
                completedQuantity: completedQuantity,
                targetQuantity: targetQuantity,
                rewardPoints: rewardPoints,
                position: position,
                imageAsset: imageAsset,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RewardChallengesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RewardChallengesTable,
      ChallengeModel,
      $$RewardChallengesTableFilterComposer,
      $$RewardChallengesTableOrderingComposer,
      $$RewardChallengesTableAnnotationComposer,
      $$RewardChallengesTableCreateCompanionBuilder,
      $$RewardChallengesTableUpdateCompanionBuilder,
      (
        ChallengeModel,
        BaseReferences<_$AppDatabase, $RewardChallengesTable, ChallengeModel>,
      ),
      ChallengeModel,
      PrefetchHooks Function()
    >;
typedef $$CatalogVersionsTableCreateCompanionBuilder =
    CatalogVersionsCompanion Function({Value<int> id, required int revision});
typedef $$CatalogVersionsTableUpdateCompanionBuilder =
    CatalogVersionsCompanion Function({Value<int> id, Value<int> revision});

class $$CatalogVersionsTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogVersionsTable> {
  $$CatalogVersionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogVersionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogVersionsTable> {
  $$CatalogVersionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogVersionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogVersionsTable> {
  $$CatalogVersionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);
}

class $$CatalogVersionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogVersionsTable,
          CatalogVersion,
          $$CatalogVersionsTableFilterComposer,
          $$CatalogVersionsTableOrderingComposer,
          $$CatalogVersionsTableAnnotationComposer,
          $$CatalogVersionsTableCreateCompanionBuilder,
          $$CatalogVersionsTableUpdateCompanionBuilder,
          (
            CatalogVersion,
            BaseReferences<
              _$AppDatabase,
              $CatalogVersionsTable,
              CatalogVersion
            >,
          ),
          CatalogVersion,
          PrefetchHooks Function()
        > {
  $$CatalogVersionsTableTableManager(
    _$AppDatabase db,
    $CatalogVersionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogVersionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogVersionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogVersionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> revision = const Value.absent(),
              }) => CatalogVersionsCompanion(id: id, revision: revision),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required int revision}) =>
                  CatalogVersionsCompanion.insert(id: id, revision: revision),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogVersionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogVersionsTable,
      CatalogVersion,
      $$CatalogVersionsTableFilterComposer,
      $$CatalogVersionsTableOrderingComposer,
      $$CatalogVersionsTableAnnotationComposer,
      $$CatalogVersionsTableCreateCompanionBuilder,
      $$CatalogVersionsTableUpdateCompanionBuilder,
      (
        CatalogVersion,
        BaseReferences<_$AppDatabase, $CatalogVersionsTable, CatalogVersion>,
      ),
      CatalogVersion,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$BannersTableTableManager get banners =>
      $$BannersTableTableManager(_db, _db.banners);
  $$ShopsTableTableManager get shops =>
      $$ShopsTableTableManager(_db, _db.shops);
  $$SectionProductsTableTableManager get sectionProducts =>
      $$SectionProductsTableTableManager(_db, _db.sectionProducts);
  $$MembersTableTableManager get members =>
      $$MembersTableTableManager(_db, _db.members);
  $$RewardTiersTableTableManager get rewardTiers =>
      $$RewardTiersTableTableManager(_db, _db.rewardTiers);
  $$RewardChallengesTableTableManager get rewardChallenges =>
      $$RewardChallengesTableTableManager(_db, _db.rewardChallenges);
  $$CatalogVersionsTableTableManager get catalogVersions =>
      $$CatalogVersionsTableTableManager(_db, _db.catalogVersions);
}
