class RideResponse {
  final bool success;
  final String message;
  final RideData data;

  RideResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RideResponse.fromJson(Map<String, dynamic> json) {
    return RideResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: RideData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class RideData {
  final String passenger;
  final String? driver;
  final int fare;
  final Location pickupLocation;
  final Location dropoffLocation;
  final String status;
  final String id;
  final DateTime requestedAt;
  final int v;

  RideData({
    required this.passenger,
    this.driver,
    required this.fare,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.status,
    required this.id,
    required this.requestedAt,
    required this.v,
  });

  factory RideData.fromJson(Map<String, dynamic> json) {
    return RideData(
      passenger: json['passenger'] as String,
      driver: json['driver'] as String?, // can be null
      fare: json['fare'] as int,
      pickupLocation: Location.fromJson(json['pickupLocation']),
      dropoffLocation: Location.fromJson(json['dropoffLocation']),
      status: json['status'] as String,
      id: json['_id'] as String,
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      v: json['__v'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'passenger': passenger,
      'driver': driver,
      'fare': fare,
      'pickupLocation': pickupLocation.toJson(),
      'dropoffLocation': dropoffLocation.toJson(),
      'status': status,
      '_id': id,
      'requestedAt': requestedAt.toIso8601String(),
      '__v': v,
    };
  }
}

class Location {
  final String type;
  final List<double> coordinates; // [longitude, latitude]

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] as String,
      coordinates:
          (json['coordinates'] as List)
              .map((c) => (c as num).toDouble())
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates};
  }
}
