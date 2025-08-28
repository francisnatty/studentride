class GetAvailableModel {
  final bool success;
  final List<RideData> data;

  GetAvailableModel({required this.success, required this.data});

  factory GetAvailableModel.fromJson(Map<String, dynamic> json) {
    return GetAvailableModel(
      success: json['success'] ?? false,
      data:
          (json['data'] as List<dynamic>)
              .map((e) => RideData.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.map((e) => e.toJson()).toList(),
  };
}

class RideData {
  final Location pickupLocation;
  final Location dropoffLocation;
  final String id;
  final Passenger passenger;
  final dynamic driver; // nullable, may later become a Driver model
  final String status;
  final int fare;
  final DateTime requestedAt;
  final int v;

  RideData({
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.id,
    required this.passenger,
    this.driver,
    required this.status,
    required this.fare,
    required this.requestedAt,
    required this.v,
  });

  factory RideData.fromJson(Map<String, dynamic> json) {
    return RideData(
      pickupLocation: Location.fromJson(json['pickupLocation']),
      dropoffLocation: Location.fromJson(json['dropoffLocation']),
      id: json['_id'],
      passenger: Passenger.fromJson(json['passenger']),
      driver: json['driver'],
      status: json['status'],
      fare: json['fare'],
      requestedAt: DateTime.parse(json['requestedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() => {
    "pickupLocation": pickupLocation.toJson(),
    "dropoffLocation": dropoffLocation.toJson(),
    "_id": id,
    "passenger": passenger.toJson(),
    "driver": driver,
    "status": status,
    "fare": fare,
    "requestedAt": requestedAt.toIso8601String(),
    "__v": v,
  };
}

class Passenger {
  final String id;
  final String name;
  final String phone;
  final String displayName;

  Passenger({
    required this.id,
    required this.name,
    required this.phone,
    required this.displayName,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
      displayName: json['displayName'],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "phone": phone,
    "displayName": displayName,
  };
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates:
          (json['coordinates'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {"type": type, "coordinates": coordinates};
}
