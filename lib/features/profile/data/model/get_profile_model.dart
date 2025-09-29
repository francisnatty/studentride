class ProfileResponse {
  final bool success;
  final UserData? data;

  ProfileResponse({required this.success, this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {"success": success, "data": data?.toJson()};
  }
}

class UserData {
  final UserModel? user;

  UserData({this.user});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() => {"user": user?.toJson()};
}

class UserModel {
  final Profile? profile;
  final DriverDetails? driverDetails;
  final CurrentLocation? currentLocation;
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final String? fcmToken;
  final bool? isActive;
  final bool? isOnline;
  final bool? emailVerified;
  final bool? phoneVerified;
  final String? emailOtp;
  final String? otpExpiresAt;
  final String? createdAt;
  final String? updatedAt;
  final String? displayName;

  UserModel({
    this.profile,
    this.driverDetails,
    this.currentLocation,
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.fcmToken,
    this.isActive,
    this.isOnline,
    this.emailVerified,
    this.phoneVerified,
    this.emailOtp,
    this.otpExpiresAt,
    this.createdAt,
    this.updatedAt,
    this.displayName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      profile:
          json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      driverDetails:
          json['driverDetails'] != null
              ? DriverDetails.fromJson(json['driverDetails'])
              : null,
      currentLocation:
          json['currentLocation'] != null
              ? CurrentLocation.fromJson(json['currentLocation'])
              : null,
      id: json['_id'] ?? json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      fcmToken: json['fcmToken'],
      isActive: json['isActive'],
      isOnline: json['isOnline'],
      emailVerified: json['emailVerified'],
      phoneVerified: json['phoneVerified'],
      emailOtp: json['emailOtp'],
      otpExpiresAt: json['otpExpiresAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      displayName: json['displayName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "profile": profile?.toJson(),
      "driverDetails": driverDetails?.toJson(),
      "currentLocation": currentLocation?.toJson(),
      "_id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "role": role,
      "fcmToken": fcmToken,
      "isActive": isActive,
      "isOnline": isOnline,
      "emailVerified": emailVerified,
      "phoneVerified": phoneVerified,
      "emailOtp": emailOtp,
      "otpExpiresAt": otpExpiresAt,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "displayName": displayName,
    };
  }
}

class Profile {
  final String? avatar;

  Profile({this.avatar});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(avatar: json['avatar']);
  }

  Map<String, dynamic> toJson() => {"avatar": avatar};
}

class DriverDetails {
  final bool? isVerified;
  final int? rating;
  final int? totalRides;

  DriverDetails({this.isVerified, this.rating, this.totalRides});

  factory DriverDetails.fromJson(Map<String, dynamic> json) {
    return DriverDetails(
      isVerified: json['isVerified'],
      rating: json['rating'],
      totalRides: json['totalRides'],
    );
  }

  Map<String, dynamic> toJson() => {
    "isVerified": isVerified,
    "rating": rating,
    "totalRides": totalRides,
  };
}

class CurrentLocation {
  final String? type;
  final List<double>? coordinates;

  CurrentLocation({this.type, this.coordinates});

  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    return CurrentLocation(
      type: json['type'],
      coordinates:
          json['coordinates'] != null
              ? List<double>.from(
                json['coordinates'].map((x) => (x as num).toDouble()),
              )
              : [],
    );
  }

  Map<String, dynamic> toJson() => {"type": type, "coordinates": coordinates};
}
