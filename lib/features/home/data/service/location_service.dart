// geolocator/permissions: handled by `location` package
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;

class LocationService {
  final loc.Location _location = loc.Location();

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

  String? _joinNonEmpty(List<String?> items) {
    final filtered =
        items.where((s) => s != null && s!.trim().isNotEmpty).cast<String>();
    if (filtered.isEmpty) return null;
    return filtered.join(' ');
  }
}
