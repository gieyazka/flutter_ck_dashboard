class UsernameAppwrite {
  final String username;
  final String userId;
  final String firstname;
  final String lastname;
  final int? point;
  final String? email;
  final String? phone;
  final bool? active;
  final String? type;
  final String? address;
  final String? profile;
  final String? customerId;
  final String? birthDate;
  final int? totalSpender;
  final int? userOtp;
  final String? otpRef;
  final String? birthTime;
  final int? topupPoint;
  final String? gender;
  final String? idCard;
  final bool? isKYC;
  final String? refCode;
  final bool? isVerify;
  final bool? isUseRegister;
  final String? influencer;
  final String? passcodeStaff;
  final String? fcm;
  final String id; // corresponds to $id

  final List<UserRole>? userRoles;

  const UsernameAppwrite({
    required this.username,
    required this.userId,
    required this.firstname,
    required this.lastname,
    this.point,
    this.email,
    this.phone,
    this.active,
    this.type,
    this.address,
    this.profile,
    this.customerId,
    this.birthDate,
    this.totalSpender,
    this.userOtp,
    this.otpRef,
    this.birthTime,
    this.topupPoint,
    this.gender,
    this.idCard,
    this.isKYC,
    this.refCode,
    this.isVerify,
    this.isUseRegister,
    this.influencer,
    this.passcodeStaff,
    this.fcm,
    required this.id,
    this.userRoles,
  });

  factory UsernameAppwrite.fromJson(Map<String, dynamic> json) {
    return UsernameAppwrite(
      username: json['username'] as String,
      userId: json['userId'] as String,
      id: json[r'$id'] as String,

      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      point: (json['point'] as num).toInt(),
      email: json['email'] as String,
      phone: json['phone'] as String,
      active: json['active'] as bool,
      type: json['type'] as String,
      address: json['address'] as String,
      profile: json['profile'] as String?,
      customerId: json['customerId'] as String?,
      birthDate: json['birthDate'] as String?,
      totalSpender: (json['totalSpender'] as num).toInt(),
      userOtp: int.tryParse(json['user_otp']?.toString() ?? '') ?? 0,
      otpRef: json['otp_ref'] as String,
      birthTime: (json['birthTime'] as String).isEmpty
          ? null
          : json['birthTime'] as String,
      topupPoint: (json['topup_point'] as num).toInt(),
      gender: json['gender'] as String?,
      idCard: json['idCard'] as String?,
      isKYC: json['isKYC'] as bool,
      refCode: json['ref_code'] as String?,
      isVerify: json['isVerify'] as bool,
      isUseRegister: json['isUseRegister'] as bool,
      influencer: json['influencer'] as String?,
      passcodeStaff: json['passcode_staff'] as String,
      fcm: json['fcm'] as String?,
      userRoles: (json['user_roles'] as List)
          .map((e) => UserRole.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'userId': userId,
      'firstname': firstname,
      'lastname': lastname,
      'point': point,
      'email': email,
      'phone': phone,
      'active': active,
      'type': type,
      'address': address,
      'profile': profile,
      'customerId': customerId,
      'birthDate': birthDate,
      'totalSpender': totalSpender,
      'user_otp': userOtp,
      'otp_ref': otpRef,
      'birthTime': birthTime ?? '',
      'topup_point': topupPoint,
      'gender': gender,
      'idCard': idCard,
      'isKYC': isKYC,
      'ref_code': refCode,
      'isVerify': isVerify,
      'isUseRegister': isUseRegister,
      'influencer': influencer,
      'passcode_staff': passcodeStaff,
      'fcm': fcm,
      r'$id': id,
      'user_roles': userRoles?.map((e) => e.toJson()).toList(),
    };
  }
}

class UserRole {
  final String name;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> permissions;
  final String databaseId;
  final String collectionId;

  const UserRole({
    required this.name,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.permissions,
    required this.databaseId,
    required this.collectionId,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      name: json['name'] as String,
      id: json[r'$id'] as String,
      createdAt: DateTime.parse(json[r'$createdAt'] as String),
      updatedAt: DateTime.parse(json[r'$updatedAt'] as String),
      permissions: (json[r'$permissions'] as List).cast<dynamic>(),
      databaseId: json[r'$databaseId'] as String,
      collectionId: json[r'$collectionId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      r'$id': id,
      r'$createdAt': createdAt.toIso8601String(),
      r'$updatedAt': updatedAt.toIso8601String(),
      r'$permissions': permissions,
      r'$databaseId': databaseId,
      r'$collectionId': collectionId,
    };
  }
}

class LotteryDateAppwrite {
  final DateTime dateTime;
  final bool active;
  final DateTime startTime;
  final DateTime endTime;
  final bool isEmergency;
  final int userCount;
  final String id; // corresponds to $id

  const LotteryDateAppwrite({
    required this.dateTime,
    required this.active,
    required this.startTime,
    required this.endTime,
    required this.isEmergency,
    required this.userCount,
    required this.id,
  });

  factory LotteryDateAppwrite.fromJson(Map<String, dynamic> json) {
    return LotteryDateAppwrite(
      id: json[r'$id'] as String,
      dateTime: DateTime.parse(json['datetime'] as String),
      active: json['active'] as bool,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      isEmergency: json['is_emergency'] as bool,
      userCount: (json['userCount'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date_time': dateTime.toIso8601String(),
      'active': active,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'is_emergency': isEmergency,
      'userCount': userCount,

      r'$id': id,
    };
  }
}
