import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  GoogleMapController? mapController;
  LatLng? selectedLocation;
  String? selectedAddress;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  LatLng _currentLatLng = const LatLng(6.5244, 3.3792); // Default: Lagos

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLatLng = LatLng(position.latitude, position.longitude);
    });
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_currentLatLng, 15),
    );
  }

  Future<void> _selectLocation(LatLng latLng) async {
    final placemarks = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );
    final place = placemarks.first;
    setState(() {
      selectedLocation = latLng;
      selectedAddress =
          '${place.street}, ${place.locality}, ${place.administrativeArea}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Destination")),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => mapController = controller,
            initialCameraPosition: CameraPosition(
              target: _currentLatLng,
              zoom: 14,
            ),
            myLocationEnabled: true,
            onTap: _selectLocation,
            markers:
                selectedLocation != null
                    ? {
                      Marker(
                        markerId: const MarkerId('destination'),
                        position: selectedLocation!,
                      ),
                    }
                    : {},
          ),
          if (selectedAddress != null)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                ),
                child: Text(
                  selectedAddress!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton:
          selectedLocation != null
              ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pop(context, {
                    'latLng': selectedLocation,
                    'address': selectedAddress,
                  });
                },
                label: const Text("Confirm"),
                icon: const Icon(Icons.check),
              )
              : null,
    );
  }
}
