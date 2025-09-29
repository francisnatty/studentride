// geolocator/permissions: handled by `location` package
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:http/http.dart' as http;

class LocationService {
  final loc.Location _location = loc.Location();

  String googleApiKey = 'AIzaSyBJPz4C1l2I8jgUl-KT0lRR1nM4_wlM_tM';

  Future<loc.LocationData?> getCurrentLocation() async {
    // Ensure service (GPS) is enabled
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return null;
    }

    // Check permission
    loc.PermissionStatus permission = await _location.hasPermission();
    if (permission == loc.PermissionStatus.denied) {
      permission = await _location.requestPermission();
    }

    // If permanently denied, bail out
    if (permission == loc.PermissionStatus.deniedForever ||
        permission != loc.PermissionStatus.granted) {
      return null;
    }

    // Optionally: set desired accuracy (default is balanced)
    // await _location.changeSettings(accuracy: loc.LocationAccuracy.high);

    // Get current location
    return _location.getLocation();
  }

  Future<String?> getAddressFromCoordinates(double lat, double lng) async {
    try {
      final List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        lat,
        lng,
      );

      if (placemarks.isEmpty) return null;

      final p = placemarks.first;

      // Compose a readable address, skipping empty parts
      final parts =
          <String?>[
                _joinNonEmpty([p.street, p.subLocality]),
                _joinNonEmpty([p.locality, p.administrativeArea]),
                p.postalCode,
                p.country,
              ]
              .where((s) => s != null && s!.trim().isNotEmpty)
              .cast<String>()
              .toList();

      return parts.join(', ');
    } catch (e) {
      // Use your logger instead of print in production
      print('Error getting address for ($lat,$lng): $e');
      return null;
    }
  }

  // Future<String> getAddressFromLatLng(LatLng latLng) async {
  //   try {
  //     final placemarks = await geo.placemarkFromCoordinates(
  //       latLng.latitude,
  //       latLng.longitude,
  //     );
  //     if (placemarks.isEmpty) return '${latLng.latitude}, ${latLng.longitude}';
  //     final p = placemarks.first;
  //     final line = [
  //       if ((p.street ?? '').trim().isNotEmpty) p.street,
  //       if ((p.locality ?? '').trim().isNotEmpty) p.locality,
  //       if ((p.administrativeArea ?? '').trim().isNotEmpty)
  //         p.administrativeArea,
  //       if ((p.country ?? '').trim().isNotEmpty) p.country,
  //     ].where((e) => e != null && e!.trim().isNotEmpty).join(', ');
  //     return line.isNotEmpty ? line : '${latLng.latitude}, ${latLng.longitude}';
  //   } catch (_) {
  //     return '${latLng.latitude}, ${latLng.longitude}';
  //   }
  // }

  Future<String> getAddressFromLatLng(LatLng latLng) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$googleApiKey',
    );

    final resp = await http.get(url);
    if (resp.statusCode != 200)
      return '${latLng.latitude}, ${latLng.longitude}';

    final data = json.decode(resp.body);
    if (data['status'] == 'OK' &&
        data['results'] != null &&
        data['results'].isNotEmpty) {
      // formatted_address is what Google shows in Maps
      return data['results'][0]['formatted_address'];
    }

    return '${latLng.latitude}, ${latLng.longitude}';
  }

  String? _joinNonEmpty(List<String?> items) {
    final filtered =
        items.where((s) => s != null && s!.trim().isNotEmpty).cast<String>();
    if (filtered.isEmpty) return null;
    return filtered.join(' ');
  }
}
