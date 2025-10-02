class GetAvailableRideModel {
  final bool success;
  final List<RideData> data;

  GetAvailableRideModel({required this.success, required this.data});

  factory GetAvailableRideModel.fromJson(Map<String, dynamic> json) {
    final rawData = (json['data'] as List?) ?? const [];
    return GetAvailableRideModel(
      success: (json['success'] as bool?) ?? false,
      data:
          rawData
              .map((e) => RideData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class RideData {
  final Location pickupLocation;
  final Location dropoffLocation;
  final String id;
  final Passenger? passenger; // <-- make nullable
  final dynamic driver; // keep as is
  final int fare;
  final String pickupAddress;
  final String dropoffAddress;
  final String status;
  final DateTime requestedAt;
  final int v;

  RideData({
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.id,
    this.passenger, // nullable
    this.driver,
    required this.fare,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.status,
    required this.requestedAt,
    required this.v,
  });

  factory RideData.fromJson(Map<String, dynamic> json) {
    return RideData(
      pickupLocation: Location.fromJson(json['pickupLocation']),
      dropoffLocation: Location.fromJson(json['dropoffLocation']),
      id: json['_id'] as String,
      passenger:
          json['passenger'] != null
              ? Passenger.fromJson(json['passenger'])
              : null, // ✅ safely handle null
      driver: json['driver'],
      fare: (json['fare'] as num).toInt(),
      pickupAddress: (json['pickupAddress'] as String?) ?? '',
      dropoffAddress: (json['dropoffAddress'] as String?) ?? '',
      status: json['status'] as String,
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      v: (json['__v'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'pickupLocation': pickupLocation.toJson(),
    'dropoffLocation': dropoffLocation.toJson(),
    '_id': id,
    'passenger': passenger?.toJson(), // ✅ null-safe
    'driver': driver,
    'fare': fare,
    'pickupAddress': pickupAddress,
    'dropoffAddress': dropoffAddress,
    'status': status,
    'requestedAt': requestedAt.toIso8601String(),
    '__v': v,
  };
}

class Passenger {
  /// Backend may send both "_id" and "id" (same value). We keep both:
  final String backendId; // value of "_id"
  final String id; // value of "id" (fallback to backendId if missing)
  final String name;
  final String phone;
  final String displayName;

  Passenger({
    required this.backendId,
    required this.id,
    required this.name,
    required this.phone,
    required this.displayName,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    final backendId = json['_id'] as String? ?? '';
    final id = json['id'] as String? ?? backendId;
    return Passenger(
      backendId: backendId,
      id: id,
      name: (json['name'] as String?) ?? '',
      phone: (json['phone'] as String?) ?? '',
      displayName: (json['displayName'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': backendId,
    'id': id,
    'name': name,
    'phone': phone,
    'displayName': displayName,
  };
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates})
    : assert(coordinates.length == 2, 'coordinates must be length 2');

  factory Location.fromJson(Map<String, dynamic> json) {
    final coords = (json['coordinates'] as List)
        .map((e) => (e as num).toDouble())
        .toList(growable: false);
    return Location(
      type: (json['type'] as String?) ?? 'Point',
      coordinates: coords,
    );
  }

  Map<String, dynamic> toJson() => {'type': type, 'coordinates': coordinates};
}
