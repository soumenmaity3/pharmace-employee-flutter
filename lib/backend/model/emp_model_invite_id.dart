class EmpModelInviteId {
  final String inviteId;
  final String empEmail;
  final String empName;
  final RoleEmp empRole;
  final String shopId;
  final String ownerId;
  final Map<String, dynamic>? ownershipData;

  EmpModelInviteId({
    required this.inviteId,
    required this.empEmail,
    required this.empName,
    required this.empRole,
    required this.shopId,
    required this.ownerId,
    this.ownershipData,
  });

  // --- Convenience Getters for Shop & Owner Details ---
  Map<String, dynamic>? get shopDetails =>
      ownershipData?['shopDetails'] as Map<String, dynamic>?;

  Map<String, dynamic>? get ownerDetails =>
      ownershipData?['ownerDetails'] as Map<String, dynamic>?;

  String? get shopName => shopDetails?['shopName']?.toString();
  String? get shopCode => shopDetails?['shopCode']?.toString();
  String? get shopEmail => shopDetails?['shopEmail']?.toString();
  String? get shopPhone => shopDetails?['phone']?.toString();
  String? get shopAddress {
    final parts = [
      shopDetails?['address'],
      shopDetails?['city'],
      shopDetails?['state'],
      shopDetails?['pincode'],
    ].where((e) => e != null && e.toString().trim().isNotEmpty);
    return parts.isEmpty ? null : parts.join(', ');
  }

  String? get ownerName => ownerDetails?['name']?.toString();
  String? get ownerEmail => ownerDetails?['email']?.toString();

  factory EmpModelInviteId.fromJson(Map<String, dynamic> json) {
    return EmpModelInviteId(
      inviteId: json['inviteId'] ?? '',
      empEmail: json['empEmail'] ?? '',
      empName: json['empName'] ?? '',
      empRole: RoleEmp.fromString(json['empRole']),
      shopId: json['shopId'] ?? '',
      ownerId: json['ownerId'] ?? '',
      ownershipData: json['ownershipData'] as Map<String, dynamic>?,
    );
  }

  EmpModelInviteId copyWith({
    Map<String, dynamic>? ownershipData,
  }) {
    return EmpModelInviteId(
      inviteId: inviteId,
      empEmail: empEmail,
      empName: empName,
      empRole: empRole,
      shopId: shopId,
      ownerId: ownerId,
      ownershipData: ownershipData ?? this.ownershipData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empEmail': empEmail,
      'empName': empName,
      'empRole': empRole.value,
      'shopId': shopId,
      'inviteId': inviteId,
      'ownerId': ownerId,
      if (ownershipData != null) 'ownershipData': ownershipData,
    };
  }
}

enum RoleEmp {
  manager,
  pharmacist,
  cashier,
  staff;

  String get value {
    switch (this) {
      case RoleEmp.manager:
        return 'Manager';
      case RoleEmp.pharmacist:
        return 'Pharmacist';
      case RoleEmp.cashier:
        return 'Cashier';
      case RoleEmp.staff:
        return 'Staff';
    }
  }

  static RoleEmp fromString(String? role) {
    if (role == null) return RoleEmp.staff;
    return RoleEmp.values.firstWhere(
      (r) =>
          r.name.toLowerCase() == role.toLowerCase() ||
          r.value.toLowerCase() == role.toLowerCase(),
      orElse: () => RoleEmp.staff,
    );
  }
}
