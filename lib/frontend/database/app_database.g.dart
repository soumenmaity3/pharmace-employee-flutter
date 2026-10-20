// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EmployeeTableTable extends EmployeeTable
    with TableInfo<$EmployeeTableTable, EmployeeTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Manager'),
  );
  static const VerificationMeta _isFromOwnerMeta = const VerificationMeta(
    'isFromOwner',
  );
  @override
  late final GeneratedColumn<bool> isFromOwner = GeneratedColumn<bool>(
    'is_from_owner',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_from_owner" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _shopIdMeta = const VerificationMeta('shopId');
  @override
  late final GeneratedColumn<String> shopId = GeneratedColumn<String>(
    'shop_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    role,
    isFromOwner,
    shopId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmployeeTableData> instance, {
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
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('is_from_owner')) {
      context.handle(
        _isFromOwnerMeta,
        isFromOwner.isAcceptableOrUnknown(
          data['is_from_owner']!,
          _isFromOwnerMeta,
        ),
      );
    }
    if (data.containsKey('shop_id')) {
      context.handle(
        _shopIdMeta,
        shopId.isAcceptableOrUnknown(data['shop_id']!, _shopIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmployeeTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      isFromOwner: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_from_owner'],
      )!,
      shopId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shop_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EmployeeTableTable createAlias(String alias) {
    return $EmployeeTableTable(attachedDatabase, alias);
  }
}

class EmployeeTableData extends DataClass
    implements Insertable<EmployeeTableData> {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isFromOwner;
  final String? shopId;
  final String createdAt;
  const EmployeeTableData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isFromOwner,
    this.shopId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['role'] = Variable<String>(role);
    map['is_from_owner'] = Variable<bool>(isFromOwner);
    if (!nullToAbsent || shopId != null) {
      map['shop_id'] = Variable<String>(shopId);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  EmployeeTableCompanion toCompanion(bool nullToAbsent) {
    return EmployeeTableCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      role: Value(role),
      isFromOwner: Value(isFromOwner),
      shopId: shopId == null && nullToAbsent
          ? const Value.absent()
          : Value(shopId),
      createdAt: Value(createdAt),
    );
  }

  factory EmployeeTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      role: serializer.fromJson<String>(json['role']),
      isFromOwner: serializer.fromJson<bool>(json['isFromOwner']),
      shopId: serializer.fromJson<String?>(json['shopId']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'role': serializer.toJson<String>(role),
      'isFromOwner': serializer.toJson<bool>(isFromOwner),
      'shopId': serializer.toJson<String?>(shopId),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  EmployeeTableData copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    bool? isFromOwner,
    Value<String?> shopId = const Value.absent(),
    String? createdAt,
  }) => EmployeeTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    role: role ?? this.role,
    isFromOwner: isFromOwner ?? this.isFromOwner,
    shopId: shopId.present ? shopId.value : this.shopId,
    createdAt: createdAt ?? this.createdAt,
  );
  EmployeeTableData copyWithCompanion(EmployeeTableCompanion data) {
    return EmployeeTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      role: data.role.present ? data.role.value : this.role,
      isFromOwner: data.isFromOwner.present
          ? data.isFromOwner.value
          : this.isFromOwner,
      shopId: data.shopId.present ? data.shopId.value : this.shopId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('isFromOwner: $isFromOwner, ')
          ..write('shopId: $shopId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, email, role, isFromOwner, shopId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.role == this.role &&
          other.isFromOwner == this.isFromOwner &&
          other.shopId == this.shopId &&
          other.createdAt == this.createdAt);
}

class EmployeeTableCompanion extends UpdateCompanion<EmployeeTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> role;
  final Value<bool> isFromOwner;
  final Value<String?> shopId;
  final Value<String> createdAt;
  final Value<int> rowid;
  const EmployeeTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.role = const Value.absent(),
    this.isFromOwner = const Value.absent(),
    this.shopId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeTableCompanion.insert({
    required String id,
    required String name,
    required String email,
    this.role = const Value.absent(),
    this.isFromOwner = const Value.absent(),
    this.shopId = const Value.absent(),
    required String createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       email = Value(email),
       createdAt = Value(createdAt);
  static Insertable<EmployeeTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? role,
    Expression<bool>? isFromOwner,
    Expression<String>? shopId,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (isFromOwner != null) 'is_from_owner': isFromOwner,
      if (shopId != null) 'shop_id': shopId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? email,
    Value<String>? role,
    Value<bool>? isFromOwner,
    Value<String?>? shopId,
    Value<String>? createdAt,
    Value<int>? rowid,
  }) {
    return EmployeeTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isFromOwner: isFromOwner ?? this.isFromOwner,
      shopId: shopId ?? this.shopId,
      createdAt: createdAt ?? this.createdAt,
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
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (isFromOwner.present) {
      map['is_from_owner'] = Variable<bool>(isFromOwner.value);
    }
    if (shopId.present) {
      map['shop_id'] = Variable<String>(shopId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('isFromOwner: $isFromOwner, ')
          ..write('shopId: $shopId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShopTableTable extends ShopTable
    with TableInfo<$ShopTableTable, ShopTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShopTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shopNameMeta = const VerificationMeta(
    'shopName',
  );
  @override
  late final GeneratedColumn<String> shopName = GeneratedColumn<String>(
    'shop_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shopEmailMeta = const VerificationMeta(
    'shopEmail',
  );
  @override
  late final GeneratedColumn<String> shopEmail = GeneratedColumn<String>(
    'shop_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shopCodeMeta = const VerificationMeta(
    'shopCode',
  );
  @override
  late final GeneratedColumn<String> shopCode = GeneratedColumn<String>(
    'shop_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
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
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pincodeMeta = const VerificationMeta(
    'pincode',
  );
  @override
  late final GeneratedColumn<String> pincode = GeneratedColumn<String>(
    'pincode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _licenseNumberMeta = const VerificationMeta(
    'licenseNumber',
  );
  @override
  late final GeneratedColumn<String> licenseNumber = GeneratedColumn<String>(
    'license_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gstNumberMeta = const VerificationMeta(
    'gstNumber',
  );
  @override
  late final GeneratedColumn<String> gstNumber = GeneratedColumn<String>(
    'gst_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _verifyStatusMeta = const VerificationMeta(
    'verifyStatus',
  );
  @override
  late final GeneratedColumn<String> verifyStatus = GeneratedColumn<String>(
    'verify_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Pending'),
  );
  static const VerificationMeta _isOwnerEmployeeMeta = const VerificationMeta(
    'isOwnerEmployee',
  );
  @override
  late final GeneratedColumn<bool> isOwnerEmployee = GeneratedColumn<bool>(
    'is_owner_employee',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_owner_employee" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _logoUrlMeta = const VerificationMeta(
    'logoUrl',
  );
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
    'logo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isOpenMeta = const VerificationMeta('isOpen');
  @override
  late final GeneratedColumn<bool> isOpen = GeneratedColumn<bool>(
    'is_open',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_open" IN (0, 1))',
    ),
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shopName,
    shopEmail,
    shopCode,
    phone,
    address,
    city,
    state,
    pincode,
    licenseNumber,
    gstNumber,
    verifyStatus,
    isOwnerEmployee,
    logoUrl,
    isOpen,
    ownerId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shop_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShopTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('shop_name')) {
      context.handle(
        _shopNameMeta,
        shopName.isAcceptableOrUnknown(data['shop_name']!, _shopNameMeta),
      );
    } else if (isInserting) {
      context.missing(_shopNameMeta);
    }
    if (data.containsKey('shop_email')) {
      context.handle(
        _shopEmailMeta,
        shopEmail.isAcceptableOrUnknown(data['shop_email']!, _shopEmailMeta),
      );
    } else if (isInserting) {
      context.missing(_shopEmailMeta);
    }
    if (data.containsKey('shop_code')) {
      context.handle(
        _shopCodeMeta,
        shopCode.isAcceptableOrUnknown(data['shop_code']!, _shopCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_shopCodeMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('pincode')) {
      context.handle(
        _pincodeMeta,
        pincode.isAcceptableOrUnknown(data['pincode']!, _pincodeMeta),
      );
    } else if (isInserting) {
      context.missing(_pincodeMeta);
    }
    if (data.containsKey('license_number')) {
      context.handle(
        _licenseNumberMeta,
        licenseNumber.isAcceptableOrUnknown(
          data['license_number']!,
          _licenseNumberMeta,
        ),
      );
    }
    if (data.containsKey('gst_number')) {
      context.handle(
        _gstNumberMeta,
        gstNumber.isAcceptableOrUnknown(data['gst_number']!, _gstNumberMeta),
      );
    }
    if (data.containsKey('verify_status')) {
      context.handle(
        _verifyStatusMeta,
        verifyStatus.isAcceptableOrUnknown(
          data['verify_status']!,
          _verifyStatusMeta,
        ),
      );
    }
    if (data.containsKey('is_owner_employee')) {
      context.handle(
        _isOwnerEmployeeMeta,
        isOwnerEmployee.isAcceptableOrUnknown(
          data['is_owner_employee']!,
          _isOwnerEmployeeMeta,
        ),
      );
    }
    if (data.containsKey('logo_url')) {
      context.handle(
        _logoUrlMeta,
        logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta),
      );
    }
    if (data.containsKey('is_open')) {
      context.handle(
        _isOpenMeta,
        isOpen.isAcceptableOrUnknown(data['is_open']!, _isOpenMeta),
      );
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShopTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShopTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      shopName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shop_name'],
      )!,
      shopEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shop_email'],
      )!,
      shopCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shop_code'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      pincode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pincode'],
      )!,
      licenseNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license_number'],
      ),
      gstNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gst_number'],
      ),
      verifyStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verify_status'],
      )!,
      isOwnerEmployee: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_owner_employee'],
      )!,
      logoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_url'],
      ),
      isOpen: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_open'],
      ),
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      ),
    );
  }

  @override
  $ShopTableTable createAlias(String alias) {
    return $ShopTableTable(attachedDatabase, alias);
  }
}

class ShopTableData extends DataClass implements Insertable<ShopTableData> {
  final String id;
  final String shopName;
  final String shopEmail;
  final String shopCode;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String? licenseNumber;
  final String? gstNumber;
  final String verifyStatus;
  final bool isOwnerEmployee;
  final String? logoUrl;
  final bool? isOpen;
  final String? ownerId;
  const ShopTableData({
    required this.id,
    required this.shopName,
    required this.shopEmail,
    required this.shopCode,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.licenseNumber,
    this.gstNumber,
    required this.verifyStatus,
    required this.isOwnerEmployee,
    this.logoUrl,
    this.isOpen,
    this.ownerId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shop_name'] = Variable<String>(shopName);
    map['shop_email'] = Variable<String>(shopEmail);
    map['shop_code'] = Variable<String>(shopCode);
    map['phone'] = Variable<String>(phone);
    map['address'] = Variable<String>(address);
    map['city'] = Variable<String>(city);
    map['state'] = Variable<String>(state);
    map['pincode'] = Variable<String>(pincode);
    if (!nullToAbsent || licenseNumber != null) {
      map['license_number'] = Variable<String>(licenseNumber);
    }
    if (!nullToAbsent || gstNumber != null) {
      map['gst_number'] = Variable<String>(gstNumber);
    }
    map['verify_status'] = Variable<String>(verifyStatus);
    map['is_owner_employee'] = Variable<bool>(isOwnerEmployee);
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    if (!nullToAbsent || isOpen != null) {
      map['is_open'] = Variable<bool>(isOpen);
    }
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<String>(ownerId);
    }
    return map;
  }

  ShopTableCompanion toCompanion(bool nullToAbsent) {
    return ShopTableCompanion(
      id: Value(id),
      shopName: Value(shopName),
      shopEmail: Value(shopEmail),
      shopCode: Value(shopCode),
      phone: Value(phone),
      address: Value(address),
      city: Value(city),
      state: Value(state),
      pincode: Value(pincode),
      licenseNumber: licenseNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(licenseNumber),
      gstNumber: gstNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(gstNumber),
      verifyStatus: Value(verifyStatus),
      isOwnerEmployee: Value(isOwnerEmployee),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      isOpen: isOpen == null && nullToAbsent
          ? const Value.absent()
          : Value(isOpen),
      ownerId: ownerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerId),
    );
  }

  factory ShopTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShopTableData(
      id: serializer.fromJson<String>(json['id']),
      shopName: serializer.fromJson<String>(json['shopName']),
      shopEmail: serializer.fromJson<String>(json['shopEmail']),
      shopCode: serializer.fromJson<String>(json['shopCode']),
      phone: serializer.fromJson<String>(json['phone']),
      address: serializer.fromJson<String>(json['address']),
      city: serializer.fromJson<String>(json['city']),
      state: serializer.fromJson<String>(json['state']),
      pincode: serializer.fromJson<String>(json['pincode']),
      licenseNumber: serializer.fromJson<String?>(json['licenseNumber']),
      gstNumber: serializer.fromJson<String?>(json['gstNumber']),
      verifyStatus: serializer.fromJson<String>(json['verifyStatus']),
      isOwnerEmployee: serializer.fromJson<bool>(json['isOwnerEmployee']),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      isOpen: serializer.fromJson<bool?>(json['isOpen']),
      ownerId: serializer.fromJson<String?>(json['ownerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shopName': serializer.toJson<String>(shopName),
      'shopEmail': serializer.toJson<String>(shopEmail),
      'shopCode': serializer.toJson<String>(shopCode),
      'phone': serializer.toJson<String>(phone),
      'address': serializer.toJson<String>(address),
      'city': serializer.toJson<String>(city),
      'state': serializer.toJson<String>(state),
      'pincode': serializer.toJson<String>(pincode),
      'licenseNumber': serializer.toJson<String?>(licenseNumber),
      'gstNumber': serializer.toJson<String?>(gstNumber),
      'verifyStatus': serializer.toJson<String>(verifyStatus),
      'isOwnerEmployee': serializer.toJson<bool>(isOwnerEmployee),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'isOpen': serializer.toJson<bool?>(isOpen),
      'ownerId': serializer.toJson<String?>(ownerId),
    };
  }

  ShopTableData copyWith({
    String? id,
    String? shopName,
    String? shopEmail,
    String? shopCode,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? pincode,
    Value<String?> licenseNumber = const Value.absent(),
    Value<String?> gstNumber = const Value.absent(),
    String? verifyStatus,
    bool? isOwnerEmployee,
    Value<String?> logoUrl = const Value.absent(),
    Value<bool?> isOpen = const Value.absent(),
    Value<String?> ownerId = const Value.absent(),
  }) => ShopTableData(
    id: id ?? this.id,
    shopName: shopName ?? this.shopName,
    shopEmail: shopEmail ?? this.shopEmail,
    shopCode: shopCode ?? this.shopCode,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    city: city ?? this.city,
    state: state ?? this.state,
    pincode: pincode ?? this.pincode,
    licenseNumber: licenseNumber.present
        ? licenseNumber.value
        : this.licenseNumber,
    gstNumber: gstNumber.present ? gstNumber.value : this.gstNumber,
    verifyStatus: verifyStatus ?? this.verifyStatus,
    isOwnerEmployee: isOwnerEmployee ?? this.isOwnerEmployee,
    logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
    isOpen: isOpen.present ? isOpen.value : this.isOpen,
    ownerId: ownerId.present ? ownerId.value : this.ownerId,
  );
  ShopTableData copyWithCompanion(ShopTableCompanion data) {
    return ShopTableData(
      id: data.id.present ? data.id.value : this.id,
      shopName: data.shopName.present ? data.shopName.value : this.shopName,
      shopEmail: data.shopEmail.present ? data.shopEmail.value : this.shopEmail,
      shopCode: data.shopCode.present ? data.shopCode.value : this.shopCode,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
      pincode: data.pincode.present ? data.pincode.value : this.pincode,
      licenseNumber: data.licenseNumber.present
          ? data.licenseNumber.value
          : this.licenseNumber,
      gstNumber: data.gstNumber.present ? data.gstNumber.value : this.gstNumber,
      verifyStatus: data.verifyStatus.present
          ? data.verifyStatus.value
          : this.verifyStatus,
      isOwnerEmployee: data.isOwnerEmployee.present
          ? data.isOwnerEmployee.value
          : this.isOwnerEmployee,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      isOpen: data.isOpen.present ? data.isOpen.value : this.isOpen,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShopTableData(')
          ..write('id: $id, ')
          ..write('shopName: $shopName, ')
          ..write('shopEmail: $shopEmail, ')
          ..write('shopCode: $shopCode, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('pincode: $pincode, ')
          ..write('licenseNumber: $licenseNumber, ')
          ..write('gstNumber: $gstNumber, ')
          ..write('verifyStatus: $verifyStatus, ')
          ..write('isOwnerEmployee: $isOwnerEmployee, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('isOpen: $isOpen, ')
          ..write('ownerId: $ownerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    shopName,
    shopEmail,
    shopCode,
    phone,
    address,
    city,
    state,
    pincode,
    licenseNumber,
    gstNumber,
    verifyStatus,
    isOwnerEmployee,
    logoUrl,
    isOpen,
    ownerId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShopTableData &&
          other.id == this.id &&
          other.shopName == this.shopName &&
          other.shopEmail == this.shopEmail &&
          other.shopCode == this.shopCode &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.city == this.city &&
          other.state == this.state &&
          other.pincode == this.pincode &&
          other.licenseNumber == this.licenseNumber &&
          other.gstNumber == this.gstNumber &&
          other.verifyStatus == this.verifyStatus &&
          other.isOwnerEmployee == this.isOwnerEmployee &&
          other.logoUrl == this.logoUrl &&
          other.isOpen == this.isOpen &&
          other.ownerId == this.ownerId);
}

class ShopTableCompanion extends UpdateCompanion<ShopTableData> {
  final Value<String> id;
  final Value<String> shopName;
  final Value<String> shopEmail;
  final Value<String> shopCode;
  final Value<String> phone;
  final Value<String> address;
  final Value<String> city;
  final Value<String> state;
  final Value<String> pincode;
  final Value<String?> licenseNumber;
  final Value<String?> gstNumber;
  final Value<String> verifyStatus;
  final Value<bool> isOwnerEmployee;
  final Value<String?> logoUrl;
  final Value<bool?> isOpen;
  final Value<String?> ownerId;
  final Value<int> rowid;
  const ShopTableCompanion({
    this.id = const Value.absent(),
    this.shopName = const Value.absent(),
    this.shopEmail = const Value.absent(),
    this.shopCode = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.pincode = const Value.absent(),
    this.licenseNumber = const Value.absent(),
    this.gstNumber = const Value.absent(),
    this.verifyStatus = const Value.absent(),
    this.isOwnerEmployee = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.isOpen = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShopTableCompanion.insert({
    required String id,
    required String shopName,
    required String shopEmail,
    required String shopCode,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String pincode,
    this.licenseNumber = const Value.absent(),
    this.gstNumber = const Value.absent(),
    this.verifyStatus = const Value.absent(),
    this.isOwnerEmployee = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.isOpen = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       shopName = Value(shopName),
       shopEmail = Value(shopEmail),
       shopCode = Value(shopCode),
       phone = Value(phone),
       address = Value(address),
       city = Value(city),
       state = Value(state),
       pincode = Value(pincode);
  static Insertable<ShopTableData> custom({
    Expression<String>? id,
    Expression<String>? shopName,
    Expression<String>? shopEmail,
    Expression<String>? shopCode,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? city,
    Expression<String>? state,
    Expression<String>? pincode,
    Expression<String>? licenseNumber,
    Expression<String>? gstNumber,
    Expression<String>? verifyStatus,
    Expression<bool>? isOwnerEmployee,
    Expression<String>? logoUrl,
    Expression<bool>? isOpen,
    Expression<String>? ownerId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shopName != null) 'shop_name': shopName,
      if (shopEmail != null) 'shop_email': shopEmail,
      if (shopCode != null) 'shop_code': shopCode,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (pincode != null) 'pincode': pincode,
      if (licenseNumber != null) 'license_number': licenseNumber,
      if (gstNumber != null) 'gst_number': gstNumber,
      if (verifyStatus != null) 'verify_status': verifyStatus,
      if (isOwnerEmployee != null) 'is_owner_employee': isOwnerEmployee,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (isOpen != null) 'is_open': isOpen,
      if (ownerId != null) 'owner_id': ownerId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShopTableCompanion copyWith({
    Value<String>? id,
    Value<String>? shopName,
    Value<String>? shopEmail,
    Value<String>? shopCode,
    Value<String>? phone,
    Value<String>? address,
    Value<String>? city,
    Value<String>? state,
    Value<String>? pincode,
    Value<String?>? licenseNumber,
    Value<String?>? gstNumber,
    Value<String>? verifyStatus,
    Value<bool>? isOwnerEmployee,
    Value<String?>? logoUrl,
    Value<bool?>? isOpen,
    Value<String?>? ownerId,
    Value<int>? rowid,
  }) {
    return ShopTableCompanion(
      id: id ?? this.id,
      shopName: shopName ?? this.shopName,
      shopEmail: shopEmail ?? this.shopEmail,
      shopCode: shopCode ?? this.shopCode,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      gstNumber: gstNumber ?? this.gstNumber,
      verifyStatus: verifyStatus ?? this.verifyStatus,
      isOwnerEmployee: isOwnerEmployee ?? this.isOwnerEmployee,
      logoUrl: logoUrl ?? this.logoUrl,
      isOpen: isOpen ?? this.isOpen,
      ownerId: ownerId ?? this.ownerId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shopName.present) {
      map['shop_name'] = Variable<String>(shopName.value);
    }
    if (shopEmail.present) {
      map['shop_email'] = Variable<String>(shopEmail.value);
    }
    if (shopCode.present) {
      map['shop_code'] = Variable<String>(shopCode.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (pincode.present) {
      map['pincode'] = Variable<String>(pincode.value);
    }
    if (licenseNumber.present) {
      map['license_number'] = Variable<String>(licenseNumber.value);
    }
    if (gstNumber.present) {
      map['gst_number'] = Variable<String>(gstNumber.value);
    }
    if (verifyStatus.present) {
      map['verify_status'] = Variable<String>(verifyStatus.value);
    }
    if (isOwnerEmployee.present) {
      map['is_owner_employee'] = Variable<bool>(isOwnerEmployee.value);
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (isOpen.present) {
      map['is_open'] = Variable<bool>(isOpen.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShopTableCompanion(')
          ..write('id: $id, ')
          ..write('shopName: $shopName, ')
          ..write('shopEmail: $shopEmail, ')
          ..write('shopCode: $shopCode, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('pincode: $pincode, ')
          ..write('licenseNumber: $licenseNumber, ')
          ..write('gstNumber: $gstNumber, ')
          ..write('verifyStatus: $verifyStatus, ')
          ..write('isOwnerEmployee: $isOwnerEmployee, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('isOpen: $isOpen, ')
          ..write('ownerId: $ownerId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EmployeeTableTable employeeTable = $EmployeeTableTable(this);
  late final $ShopTableTable shopTable = $ShopTableTable(this);
  late final EmployeeDao employeeDao = EmployeeDao(this as AppDatabase);
  late final ShopDao shopDao = ShopDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    employeeTable,
    shopTable,
  ];
}

typedef $$EmployeeTableTableCreateCompanionBuilder =
    EmployeeTableCompanion Function({
      required String id,
      required String name,
      required String email,
      Value<String> role,
      Value<bool> isFromOwner,
      Value<String?> shopId,
      required String createdAt,
      Value<int> rowid,
    });
typedef $$EmployeeTableTableUpdateCompanionBuilder =
    EmployeeTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> email,
      Value<String> role,
      Value<bool> isFromOwner,
      Value<String?> shopId,
      Value<String> createdAt,
      Value<int> rowid,
    });

class $$EmployeeTableTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeeTableTable> {
  $$EmployeeTableTableFilterComposer({
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

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFromOwner => $composableBuilder(
    column: $table.isFromOwner,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shopId => $composableBuilder(
    column: $table.shopId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmployeeTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeeTableTable> {
  $$EmployeeTableTableOrderingComposer({
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

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFromOwner => $composableBuilder(
    column: $table.isFromOwner,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shopId => $composableBuilder(
    column: $table.shopId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmployeeTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeeTableTable> {
  $$EmployeeTableTableAnnotationComposer({
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

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<bool> get isFromOwner => $composableBuilder(
    column: $table.isFromOwner,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shopId =>
      $composableBuilder(column: $table.shopId, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EmployeeTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmployeeTableTable,
          EmployeeTableData,
          $$EmployeeTableTableFilterComposer,
          $$EmployeeTableTableOrderingComposer,
          $$EmployeeTableTableAnnotationComposer,
          $$EmployeeTableTableCreateCompanionBuilder,
          $$EmployeeTableTableUpdateCompanionBuilder,
          (
            EmployeeTableData,
            BaseReferences<
              _$AppDatabase,
              $EmployeeTableTable,
              EmployeeTableData
            >,
          ),
          EmployeeTableData,
          PrefetchHooks Function()
        > {
  $$EmployeeTableTableTableManager(_$AppDatabase db, $EmployeeTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<bool> isFromOwner = const Value.absent(),
                Value<String?> shopId = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmployeeTableCompanion(
                id: id,
                name: name,
                email: email,
                role: role,
                isFromOwner: isFromOwner,
                shopId: shopId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String email,
                Value<String> role = const Value.absent(),
                Value<bool> isFromOwner = const Value.absent(),
                Value<String?> shopId = const Value.absent(),
                required String createdAt,
                Value<int> rowid = const Value.absent(),
              }) => EmployeeTableCompanion.insert(
                id: id,
                name: name,
                email: email,
                role: role,
                isFromOwner: isFromOwner,
                shopId: shopId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EmployeeTableTable, EmployeeTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $EmployeeTableTable,
                    EmployeeTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmployeeTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmployeeTableTable,
      EmployeeTableData,
      $$EmployeeTableTableFilterComposer,
      $$EmployeeTableTableOrderingComposer,
      $$EmployeeTableTableAnnotationComposer,
      $$EmployeeTableTableCreateCompanionBuilder,
      $$EmployeeTableTableUpdateCompanionBuilder,
      (
        EmployeeTableData,
        BaseReferences<_$AppDatabase, $EmployeeTableTable, EmployeeTableData>,
      ),
      EmployeeTableData,
      PrefetchHooks Function()
    >;
typedef $$ShopTableTableCreateCompanionBuilder = ShopTableCompanion Function({
  required String id,
  required String shopName,
  required String shopEmail,
  required String shopCode,
  required String phone,
  required String address,
  required String city,
  required String state,
  required String pincode,
  Value<String?> licenseNumber,
  Value<String?> gstNumber,
  Value<String> verifyStatus,
  Value<bool> isOwnerEmployee,
  Value<String?> logoUrl,
  Value<bool?> isOpen,
  Value<String?> ownerId,
  Value<int> rowid,
});
typedef $$ShopTableTableUpdateCompanionBuilder = ShopTableCompanion Function({
  Value<String> id,
  Value<String> shopName,
  Value<String> shopEmail,
  Value<String> shopCode,
  Value<String> phone,
  Value<String> address,
  Value<String> city,
  Value<String> state,
  Value<String> pincode,
  Value<String?> licenseNumber,
  Value<String?> gstNumber,
  Value<String> verifyStatus,
  Value<bool> isOwnerEmployee,
  Value<String?> logoUrl,
  Value<bool?> isOpen,
  Value<String?> ownerId,
  Value<int> rowid,
});

class $$ShopTableTableFilterComposer
    extends Composer<_$AppDatabase, $ShopTableTable> {
  $$ShopTableTableFilterComposer({
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

  ColumnFilters<String> get shopName => $composableBuilder(
    column: $table.shopName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shopEmail => $composableBuilder(
    column: $table.shopEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shopCode => $composableBuilder(
    column: $table.shopCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pincode => $composableBuilder(
    column: $table.pincode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get licenseNumber => $composableBuilder(
    column: $table.licenseNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gstNumber => $composableBuilder(
    column: $table.gstNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verifyStatus => $composableBuilder(
    column: $table.verifyStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOwnerEmployee => $composableBuilder(
    column: $table.isOwnerEmployee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOpen => $composableBuilder(
    column: $table.isOpen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShopTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ShopTableTable> {
  $$ShopTableTableOrderingComposer({
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

  ColumnOrderings<String> get shopName => $composableBuilder(
    column: $table.shopName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shopEmail => $composableBuilder(
    column: $table.shopEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shopCode => $composableBuilder(
    column: $table.shopCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pincode => $composableBuilder(
    column: $table.pincode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get licenseNumber => $composableBuilder(
    column: $table.licenseNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gstNumber => $composableBuilder(
    column: $table.gstNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verifyStatus => $composableBuilder(
    column: $table.verifyStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOwnerEmployee => $composableBuilder(
    column: $table.isOwnerEmployee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOpen => $composableBuilder(
    column: $table.isOpen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShopTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShopTableTable> {
  $$ShopTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get shopName =>
      $composableBuilder(column: $table.shopName, builder: (column) => column);

  GeneratedColumn<String> get shopEmail =>
      $composableBuilder(column: $table.shopEmail, builder: (column) => column);

  GeneratedColumn<String> get shopCode =>
      $composableBuilder(column: $table.shopCode, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get pincode =>
      $composableBuilder(column: $table.pincode, builder: (column) => column);

  GeneratedColumn<String> get licenseNumber => $composableBuilder(
    column: $table.licenseNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gstNumber =>
      $composableBuilder(column: $table.gstNumber, builder: (column) => column);

  GeneratedColumn<String> get verifyStatus => $composableBuilder(
    column: $table.verifyStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOwnerEmployee => $composableBuilder(
    column: $table.isOwnerEmployee,
    builder: (column) => column,
  );

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumn<bool> get isOpen =>
      $composableBuilder(column: $table.isOpen, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);
}

class $$ShopTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShopTableTable,
          ShopTableData,
          $$ShopTableTableFilterComposer,
          $$ShopTableTableOrderingComposer,
          $$ShopTableTableAnnotationComposer,
          $$ShopTableTableCreateCompanionBuilder,
          $$ShopTableTableUpdateCompanionBuilder,
          (
            ShopTableData,
            BaseReferences<_$AppDatabase, $ShopTableTable, ShopTableData>,
          ),
          ShopTableData,
          PrefetchHooks Function()
        > {
  $$ShopTableTableTableManager(_$AppDatabase db, $ShopTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShopTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShopTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShopTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> shopName = const Value.absent(),
                Value<String> shopEmail = const Value.absent(),
                Value<String> shopCode = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String> pincode = const Value.absent(),
                Value<String?> licenseNumber = const Value.absent(),
                Value<String?> gstNumber = const Value.absent(),
                Value<String> verifyStatus = const Value.absent(),
                Value<bool> isOwnerEmployee = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
                Value<bool?> isOpen = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShopTableCompanion(
                id: id,
                shopName: shopName,
                shopEmail: shopEmail,
                shopCode: shopCode,
                phone: phone,
                address: address,
                city: city,
                state: state,
                pincode: pincode,
                licenseNumber: licenseNumber,
                gstNumber: gstNumber,
                verifyStatus: verifyStatus,
                isOwnerEmployee: isOwnerEmployee,
                logoUrl: logoUrl,
                isOpen: isOpen,
                ownerId: ownerId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String shopName,
                required String shopEmail,
                required String shopCode,
                required String phone,
                required String address,
                required String city,
                required String state,
                required String pincode,
                Value<String?> licenseNumber = const Value.absent(),
                Value<String?> gstNumber = const Value.absent(),
                Value<String> verifyStatus = const Value.absent(),
                Value<bool> isOwnerEmployee = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
                Value<bool?> isOpen = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShopTableCompanion.insert(
                id: id,
                shopName: shopName,
                shopEmail: shopEmail,
                shopCode: shopCode,
                phone: phone,
                address: address,
                city: city,
                state: state,
                pincode: pincode,
                licenseNumber: licenseNumber,
                gstNumber: gstNumber,
                verifyStatus: verifyStatus,
                isOwnerEmployee: isOwnerEmployee,
                logoUrl: logoUrl,
                isOpen: isOpen,
                ownerId: ownerId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShopTableTable, ShopTableData>(table),
                  BaseReferences<_$AppDatabase, $ShopTableTable, ShopTableData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShopTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShopTableTable,
      ShopTableData,
      $$ShopTableTableFilterComposer,
      $$ShopTableTableOrderingComposer,
      $$ShopTableTableAnnotationComposer,
      $$ShopTableTableCreateCompanionBuilder,
      $$ShopTableTableUpdateCompanionBuilder,
      (
        ShopTableData,
        BaseReferences<_$AppDatabase, $ShopTableTable, ShopTableData>,
      ),
      ShopTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EmployeeTableTableTableManager get employeeTable =>
      $$EmployeeTableTableTableManager(_db, _db.employeeTable);
  $$ShopTableTableTableManager get shopTable =>
      $$ShopTableTableTableManager(_db, _db.shopTable);
}
