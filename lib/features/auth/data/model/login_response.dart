class LoginResponse {
  final bool success;
  final String message;
  final LoginData data;

  LoginResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    success: json['success'],
    message: json['message'],
    data: LoginData.fromJson(json['data']),
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

class LoginData {
  final User user;
  final String token;

  LoginData({required this.user, required this.token});

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      LoginData(user: User.fromJson(json['user']), token: json['token']);

  Map<String, dynamic> toJson() => {'user': user.toJson(), 'token': token};
}

class User {
  final Profile profile;
  final DriverDetails driverDetails;
  final CurrentLocation currentLocation;
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final bool isActive;
  final bool isOnline;
  final bool emailVerified;
  final bool phoneVerified;
  final String createdAt;
  final String updatedAt;
  final String displayName;

  User({
    required this.profile,
    required this.driverDetails,
    required this.currentLocation,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
    required this.isOnline,
    required this.emailVerified,
    required this.phoneVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.displayName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    profile: Profile.fromJson(json['profile']),
    driverDetails: DriverDetails.fromJson(json['driverDetails']),
    currentLocation: CurrentLocation.fromJson(json['currentLocation']),
    id: json['_id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    role: json['role'],
    isActive: json['isActive'],
    isOnline: json['isOnline'],
    emailVerified: json['emailVerified'],
    phoneVerified: json['phoneVerified'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
    displayName: json['displayName'],
  );

  Map<String, dynamic> toJson() => {
    'profile': profile.toJson(),
    'driverDetails': driverDetails.toJson(),
    'currentLocation': currentLocation.toJson(),
    '_id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role,
    'isActive': isActive,
    'isOnline': isOnline,
    'emailVerified': emailVerified,
    'phoneVerified': phoneVerified,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'displayName': displayName,
  };
}

class Profile {
  final String? avatar;

  Profile({this.avatar});

  factory Profile.fromJson(Map<String, dynamic> json) =>
      Profile(avatar: json['avatar']);

  Map<String, dynamic> toJson() => {'avatar': avatar};
}

class DriverDetails {
  final bool isVerified;
  final int rating;
  final int totalRides;

  DriverDetails({
    required this.isVerified,
    required this.rating,
    required this.totalRides,
  });

  factory DriverDetails.fromJson(Map<String, dynamic> json) => DriverDetails(
    isVerified: json['isVerified'],
    rating: json['rating'],
    totalRides: json['totalRides'],
  );

  Map<String, dynamic> toJson() => {
    'isVerified': isVerified,
    'rating': rating,
    'totalRides': totalRides,
  };
}

class CurrentLocation {
  final String type;
  final List<double> coordinates;

  CurrentLocation({required this.type, required this.coordinates});

  factory CurrentLocation.fromJson(Map<String, dynamic> json) =>
      CurrentLocation(
        type: json['type'],
        coordinates: List<double>.from(
          json['coordinates'].map((x) => x.toDouble()),
        ),
      );

  Map<String, dynamic> toJson() => {'type': type, 'coordinates': coordinates};
}
