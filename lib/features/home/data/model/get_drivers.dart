class DriversResponse {
  final bool success;
  final int count;
  final List<Driver> drivers;

  DriversResponse({
    required this.success,
    required this.count,
    required this.drivers,
  });

  factory DriversResponse.fromJson(Map<String, dynamic> json) {
    return DriversResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      drivers:
          (json['drivers'] as List<dynamic>?)
              ?.map((e) => Driver.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'count': count,
    'drivers': drivers.map((e) => e.toJson()).toList(),
  };
}

class Driver {
  final DriverDetails driverDetails;
  final CurrentLocation currentLocation;
  final String id; // maps from "_id" or "id"
  final String name;
  final String phone;
  final String displayName;

  Driver({
    required this.driverDetails,
    required this.currentLocation,
    required this.id,
    required this.name,
    required this.phone,
    required this.displayName,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      driverDetails: DriverDetails.fromJson(json['driverDetails'] ?? {}),
      currentLocation: CurrentLocation.fromJson(json['currentLocation'] ?? {}),
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      displayName: json['displayName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'driverDetails': driverDetails.toJson(),
    'currentLocation': currentLocation.toJson(),
    'id': id,
    'name': name,
    'phone': phone,
    'displayName': displayName,
  };
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

  factory DriverDetails.fromJson(Map<String, dynamic> json) {
    return DriverDetails(
      isVerified: json['isVerified'] ?? false,
      rating: (json['rating'] ?? 0).toInt(),
      totalRides: (json['totalRides'] ?? 0).toInt(),
    );
  }

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

  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    return CurrentLocation(
      type: json['type'] ?? '',
      coordinates:
          (json['coordinates'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {'type': type, 'coordinates': coordinates};
}
