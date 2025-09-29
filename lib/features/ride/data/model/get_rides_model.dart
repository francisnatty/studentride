import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetAllRideModel {
  final bool success;
  final int total;
  final List<RideModel> rides;

  GetAllRideModel({
    required this.success,
    required this.total,
    required this.rides,
  });

  factory GetAllRideModel.fromMap(Map<String, dynamic> map) {
    final list = (map['rides'] as List?) ?? const [];
    return GetAllRideModel(
      success: map['success'] as bool? ?? false,
      total: map['total'] as int? ?? list.length,
      rides:
          list
              .whereType<Map<String, dynamic>>()
              .map(RideModel.fromMap)
              .toList(),
    );
  }

  factory GetAllRideModel.fromJson(String source) =>
      GetAllRideModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() => {
    'success': success,
    'total': total,
    'rides': rides.map((e) => e.toMap()).toList(),
  };

  String toJson() => json.encode(toMap());
}

class RideModel {
  final String id;
  final UserMini passenger;
  final UserMini? driver; // <- nullable now
  final int fare;
  final GeoPointModel pickupLocation;
  final GeoPointModel dropoffLocation;
  final String pickupAddress;
  final String dropoffAddress;
  final String status;
  final DateTime requestedAt;
  final int v;

  RideModel({
    required this.id,
    required this.passenger,
    required this.driver,
    required this.fare,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.status,
    required this.requestedAt,
    required this.v,
  });

  factory RideModel.fromMap(Map<String, dynamic> map) {
    final driverRaw = map['driver'];
    return RideModel(
      id: map['_id'] as String? ?? '',
      passenger: UserMini.fromMap(
        (map['passenger'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      driver:
          driverRaw is Map
              ? UserMini.fromMap(driverRaw.cast<String, dynamic>())
              : null, // <- safe
      fare: (map['fare'] as num?)?.toInt() ?? 0,
      pickupLocation: GeoPointModel.fromMap(
        (map['pickupLocation'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      dropoffLocation: GeoPointModel.fromMap(
        (map['dropoffLocation'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      pickupAddress: map['pickupAddress'] as String? ?? '',
      dropoffAddress: map['dropoffAddress'] as String? ?? '',
      status: map['status'] as String? ?? '',
      requestedAt:
          DateTime.tryParse(map['requestedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      v: (map['__v'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    '_id': id,
    'passenger': passenger.toMap(),
    'driver': driver?.toMap(), // <- nullable
    'fare': fare,
    'pickupLocation': pickupLocation.toMap(),
    'dropoffLocation': dropoffLocation.toMap(),
    'pickupAddress': pickupAddress,
    'dropoffAddress': dropoffAddress,
    'status': status,
    'requestedAt': requestedAt.toIso8601String(),
    '__v': v,
  };
}

class UserMini {
  final String id;
  final String name;
  final String phone;
  final String? fcmToken;

  UserMini({
    required this.id,
    required this.name,
    required this.phone,
    this.fcmToken,
  });

  factory UserMini.fromMap(Map<String, dynamic> map) => UserMini(
    id: map['_id'] as String? ?? '',
    name: map['name'] as String? ?? '',
    phone: map['phone'] as String? ?? '',
    fcmToken: map['fcmToken'] as String?,
  );

  Map<String, dynamic> toMap() => {
    '_id': id,
    'name': name,
    'phone': phone,
    'fcmToken': fcmToken,
  };
}

class GeoPointModel {
  final String type; // usually "Point"
  final List<double> coordinates; // [lng, lat]

  GeoPointModel({required this.type, required this.coordinates})
    : assert(
        coordinates.length == 2,
        'GeoPointModel.coordinates must be [lng, lat]',
      );

  double get lng => coordinates.isNotEmpty ? coordinates[0] : 0.0;
  double get lat => coordinates.length > 1 ? coordinates[1] : 0.0;

  LatLng toLatLng() => LatLng(lat, lng);

  factory GeoPointModel.fromMap(Map<String, dynamic> map) {
    final raw = (map['coordinates'] as List?) ?? const [];
    final coords = raw.map((e) => (e as num?)?.toDouble() ?? 0.0).toList();
    final normalized = coords.length >= 2 ? coords.sublist(0, 2) : [0.0, 0.0];
    return GeoPointModel(
      type: map['type'] as String? ?? 'Point',
      coordinates: normalized,
    );
  }

  Map<String, dynamic> toMap() => {'type': type, 'coordinates': coordinates};
}
