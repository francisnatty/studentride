class RLocation {
  final String type;
  final List<double> coordinates; // [longitude, latitude]

  RLocation({required this.type, required this.coordinates});

  factory RLocation.fromJson(Map<String, dynamic> json) {
    return RLocation(
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

class RideRequestParams {
  final RLocation pickupLocation;
  final RLocation dropoffLocation;
  final double fare;

  RideRequestParams({
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.fare,
  });

  factory RideRequestParams.fromJson(Map<String, dynamic> json) {
    return RideRequestParams(
      pickupLocation: RLocation.fromJson(json['pickupLocation']),
      dropoffLocation: RLocation.fromJson(json['dropoffLocation']),
      fare: json['fare'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickupLocation': pickupLocation.toJson(),
      'dropoffLocation': dropoffLocation.toJson(),
      'fare': fare,
    };
  }
}
