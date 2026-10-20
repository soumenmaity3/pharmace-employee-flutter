class EmpReturnModel {
  final EmpBody? body;
  final String? token;

  EmpReturnModel({this.body, this.token});

  factory EmpReturnModel.fromJson(Map<String, dynamic> json) => EmpReturnModel(
    body: json["body"] == null ? null : EmpBody.fromJson(json["body"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {"body": body?.toJson(), "token": token};
}

class EmpBody {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final bool isFromOwner;
  final String createdAt;
  final Shop? shop;

  EmpBody({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.isFromOwner,
    required this.createdAt,
    this.shop,
  });

  factory EmpBody.fromJson(Map<String, dynamic> json) => EmpBody(
    id: json["id"]!.toString(),
    name: json["name"]!.toString(),
    email: json["email"]!.toString(),
    password: json["password"]!.toString(),
    role: json["role"]!.toString(),
    isFromOwner: json["isFromOwner"],
    createdAt: json["createdAt"]!.toString(),
    shop: json["shop"] == null ? null : Shop.fromJson(json["shop"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "password": password,
    "role": role,
    "isFromOwner": isFromOwner,
    "createdAt": createdAt,
    "shop": shop?.toJson(),
  };
}

class Shop {
  final String? id;
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
    this.id,
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
    id: json["id"]?.toString(),
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
      (status) => status.label == json['verifyStatus'],
      orElse: () => Verify.pending,
    ),
    logoUrl: json["logoUrl"]?.toString(),
    isOpen: json["isOpen"],
    isOwnerEmployee: json["isOwnerEmployee"],
    owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
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
