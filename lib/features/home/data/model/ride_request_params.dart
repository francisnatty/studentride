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

class RideRequest {
  final Location pickupLocation;
  final Location dropoffLocation;

  RideRequest({required this.pickupLocation, required this.dropoffLocation});

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    return RideRequest(
      pickupLocation: Location.fromJson(json['pickupLocation']),
      dropoffLocation: Location.fromJson(json['dropoffLocation']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickupLocation': pickupLocation.toJson(),
      'dropoffLocation': dropoffLocation.toJson(),
    };
  }
}
