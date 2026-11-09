class EmpReturnModel {
  final EmpBody? body;
  final String? token;

  EmpReturnModel({this.body, this.token});

  factory EmpReturnModel.fromJson(Map<String, dynamic> json) => EmpReturnModel(
    body: json["body"] == null ? null : EmpBody.fromJson(json["body"] as Map<String, dynamic>),
    token: json["token"]?.toString() ?? json["accessToken"]?.toString() ?? json["jwt"]?.toString(),
  );

  Map<String, dynamic> toJson() => {"body": body?.toJson(), "token": token};
}

class EmpBody {
  final String id;
  final String name;
  final String? email;
  final String? password;
  final String? role;
  final bool? isFromOwner;
  final bool? activeStatus;
  final bool? isLogOut;
  final String? createdAt;
  final Shop? shop;

  EmpBody({
    required this.id,
    required this.name,
    this.email,
    this.password,
    this.role,
    this.isFromOwner,
    this.activeStatus,
    this.isLogOut,
    this.createdAt,
    this.shop,
  });

  factory EmpBody.fromJson(Map<String, dynamic> json) => EmpBody(
    id: json["id"]?.toString() ?? '',
    name: json["name"]?.toString() ?? '',
    email: json["email"]?.toString(),
    password: json["password"]?.toString(),
    role: json["role"]?.toString(),
    isFromOwner: json["isFromOwner"] as bool?,
    activeStatus: json["activeStatus"] as bool?,
    isLogOut: json["isLogOut"] as bool?,
    createdAt: json["createdAt"]?.toString(),
    shop: json["shop"] == null || json["shop"] is! Map<String, dynamic>
        ? null
        : Shop.fromJson(json["shop"] as Map<String, dynamic>),
  );

  static List<EmpBody> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map(
          (item) => EmpBody.fromJson(item as Map<String, dynamic>),
    )
        .toList();
  }

  EmpBody copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? role,
    bool? isFromOwner,
    bool? activeStatus,
    bool? isLogOut,
    String? createdAt,
    Shop? shop,
  }) {
    return EmpBody(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      isFromOwner: isFromOwner ?? this.isFromOwner,
      activeStatus: activeStatus ?? this.activeStatus,
      isLogOut: isLogOut ?? this.isLogOut,
      createdAt: createdAt ?? this.createdAt,
      shop: shop ?? this.shop,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "password": password,
    "role": role,
    "isFromOwner": isFromOwner,
    "activeStatus":activeStatus,
    "isLogOut": isLogOut,
    "createdAt": createdAt,
    "shop": shop?.toJson(),
  };
}

class Shop {
  final String id;
  final String? shopName;
  final String? shopCode;
  final String? shopEmail;
  final String? phone;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final String? licenseNumber;
  final String? gstNumber;
  final Verify? verifyStatus;
  final String? logoUrl;
  final bool? isOpen;
  final bool? isOwnerEmployee;
  final Owner? owner;
  final String? createdAt;

  Shop({
   required this.id,
    this.shopName,
    this.shopCode,
    this.shopEmail,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.licenseNumber,
    this.gstNumber,
    this.verifyStatus,
    this.logoUrl,
    this.isOpen,
    this.isOwnerEmployee,
    this.owner,
    this.createdAt,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
    id: json["id"]?.toString() ?? '',
    shopName: json["shopName"]?.toString(),
    shopCode: json["shopCode"]?.toString(),
    shopEmail: json["shopEmail"]?.toString(),
    phone: json["phone"]?.toString(),
    address: json["address"]?.toString(),
    city: json["city"]?.toString(),
    state: json["state"]?.toString(),
    pincode: json["pincode"]?.toString(),
    licenseNumber: json["licenseNumber"]?.toString(),
    gstNumber: json["gstNumber"]?.toString(),
    verifyStatus: Verify.values.firstWhere(
      (status) =>
          status.label.toLowerCase() == json['verifyStatus']?.toString().toLowerCase() ||
          status.name.toLowerCase() == json['verifyStatus']?.toString().toLowerCase(),
      orElse: () => Verify.pending,
    ),
    logoUrl: json["logoUrl"]?.toString(),
    isOpen: json["isOpen"] as bool?,
    isOwnerEmployee: json["isOwnerEmployee"] as bool?,
    owner: json["owner"] == null || json["owner"] is! Map<String, dynamic>
        ? null
        : Owner.fromJson(json["owner"] as Map<String, dynamic>),
    createdAt: json["createdAt"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "shopName": shopName,
    "shopCode": shopCode,
    "shopEmail": shopEmail,
    "phone": phone,
    "address": address,
    "city": city,
    "state": state,
    "pincode": pincode,
    "licenseNumber": licenseNumber,
    "gstNumber": gstNumber,
    "verifyStatus": verifyStatus,
    "logoUrl": logoUrl,
    "isOpen": isOpen,
    "isOwnerEmployee": isOwnerEmployee,
    "owner": owner?.toJson(),
    "createdAt": createdAt,
  };
}

enum Verify {
  pending('Pending'),
  verified('Verified'),
  rejected('Rejected');

  final String label;

  const Verify(this.label);
}

class Owner {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? role;
  final bool? isShopHave;
  final String? createdAt;

  Owner({
    this.id,
    this.name,
    this.email,
    this.password,
    this.role,
    this.isShopHave,
    this.createdAt,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    id: json["id"]?.toString(),
    name: json["name"]?.toString(),
    email: json["email"]?.toString(),
    password: json["password"]?.toString(),
    role: json["role"]?.toString(),
    isShopHave: json["isShopHave"],
    createdAt: json["createdAt"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "password": password,
    "role": role,
    "isShopHave": isShopHave,
    "createdAt": createdAt,
  };
}
