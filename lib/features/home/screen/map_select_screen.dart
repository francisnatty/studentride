import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/location_service.dart';

class MapSelectScreen extends StatefulWidget {
  const MapSelectScreen({super.key});

  @override
  State<MapSelectScreen> createState() => _MapSelectScreenState();
}

class _MapSelectScreenState extends State<MapSelectScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentPosition;
  LatLng? _destinationPosition;
  Set<Marker> _markers = {};
  bool _showPredefinedLocations = true;

  // FUTMINNA coordinates (approximate center of campus)
  static const LatLng _futminnaCenter = LatLng(9.6485, 6.4477);

  // Predefined locations around FUTMINNA
  final List<Map<String, dynamic>> _predefinedLocations = [
    // Faculties
    {
      'id': 'seet',
      'name': 'School of Engineering & Engineering Technology (SEET)',
      'position': LatLng(9.6520, 6.4450),
      'category': 'Faculty',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    },
    {
      'id': 'slt',
      'name': 'School of Life Sciences (SLS)',
      'position': LatLng(9.6470, 6.4490),
      'category': 'Faculty',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    },
    {
      'id': 'sict',
      'name': 'School of Information & Communication Technology (SICT)',
      'position': LatLng(9.6500, 6.4480),
      'category': 'Faculty',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    },
    {
      'id': 'spgs',
      'name': 'School of Physical Sciences (SPS)',
      'position': LatLng(9.6460, 6.4460),
      'category': 'Faculty',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    },
    {
      'id': 'saat',
      'name': 'School of Agriculture & Agricultural Technology (SAAT)',
      'position': LatLng(9.6440, 6.4500),
      'category': 'Faculty',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    },
    {
      'id': 'ses',
      'name': 'School of Environmental Sciences (SES)',
      'position': LatLng(9.6510, 6.4510),
      'category': 'Faculty',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    },

    // Administrative Buildings
    {
      'id': 'admin',
      'name': 'Administrative Block',
      'position': LatLng(9.6485, 6.4477),
      'category': 'Administrative',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    },
    {
      'id': 'library',
      'name': 'University Library',
      'position': LatLng(9.6475, 6.4485),
      'category': 'Administrative',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    },
    {
      'id': 'senate',
      'name': 'Senate Building',
      'position': LatLng(9.6490, 6.4470),
      'category': 'Administrative',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    },

    // Student Facilities
    {
      'id': 'student_affairs',
      'name': 'Student Affairs Division',
      'position': LatLng(9.6480, 6.4475),
      'category': 'Student Services',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    },
    {
      'id': 'clinic',
      'name': 'University Health Centre',
      'position': LatLng(9.6465, 6.4485),
      'category': 'Student Services',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    },
    {
      'id': 'sports_complex',
      'name': 'Sports Complex',
      'position': LatLng(9.6450, 6.4520),
      'category': 'Recreation',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    },

    // Hostels
    {
      'id': 'gidankwano',
      'name': 'Gidankwano Hostel',
      'position': LatLng(9.6530, 6.4430),
      'category': 'Accommodation',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
    },
    {
      'id': 'kpakungu',
      'name': 'Kpakungu Hostel',
      'position': LatLng(9.6540, 6.4440),
      'category': 'Accommodation',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
    },
    {
      'id': 'bariki',
      'name': 'Bariki Hostel',
      'position': LatLng(9.6520, 6.4420),
      'category': 'Accommodation',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
    },

    // Popular Eateries and Shops
    {
      'id': 'cafeteria',
      'name': 'Main Cafeteria',
      'position': LatLng(9.6485, 6.4485),
      'category': 'Food',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    },
    {
      'id': 'mama_put1',
      'name': 'Mama Put (Near SEET)',
      'position': LatLng(9.6525, 6.4445),
      'category': 'Food',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    },
    {
      'id': 'mama_put2',
      'name': 'Mama Put (Near Hostels)',
      'position': LatLng(9.6535, 6.4435),
      'category': 'Food',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    },
    {
      'id': 'student_center',
      'name': 'Student Centre (Snacks & Drinks)',
      'position': LatLng(9.6480, 6.4480),
      'category': 'Food',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    },
    {
      'id': 'bookshop',
      'name': 'University Bookshop',
      'position': LatLng(9.6475, 6.4475),
      'category': 'Shopping',
      'icon': BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueMagenta,
      ),
    },

    // Gates and Entrances
    {
      'id': 'main_gate',
      'name': 'Main Gate',
      'position': LatLng(9.6460, 6.4440),
      'category': 'Entrance',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    },
    {
      'id': 'back_gate',
      'name': 'Back Gate (Bosso)',
      'position': LatLng(9.6520, 6.4540),
      'category': 'Entrance',
      'icon': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    },

    // Nearby Popular Places
    {
      'id': 'bosso_market',
      'name': 'Bosso Market',
      'position': LatLng(9.6550, 6.4550),
      'category': 'Shopping',
      'icon': BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueMagenta,
      ),
    },
    {
      'id': 'gbaiko_market',
      'name': 'Gbaiko Market',
      'position': LatLng(9.6400, 6.4400),
      'category': 'Shopping',
      'icon': BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueMagenta,
      ),
    },
  ];

  @override
  void initState() {
    super.initState();
    _initLocation();
    _loadPredefinedMarkers();
  }

  Future<void> _initLocation() async {
    final locData = await LocationService().getCurrentLocation();
    if (locData != null) {
      setState(() {
        _currentPosition = LatLng(locData.latitude!, locData.longitude!);
        _destinationPosition = _currentPosition;
      });
    } else {
      // Fallback to FUTMINNA center if location service fails
      setState(() {
        _currentPosition = _futminnaCenter;
        _destinationPosition = _futminnaCenter;
      });
    }
  }

  void _loadPredefinedMarkers() {
    setState(() {
      _markers =
          _predefinedLocations.map((location) {
            return Marker(
              markerId: MarkerId(location['id']),
              position: location['position'],
              icon: location['icon'],
              infoWindow: InfoWindow(
                title: location['name'],
                snippet: location['category'],
              ),
              onTap: () {
                setState(() {
                  _destinationPosition = location['position'];
                });
              },
            );
          }).toSet();
    });
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _destinationPosition = position;
    });
  }

  void _confirmDestination() {
    Navigator.pop(context, _destinationPosition);
  }

  void _togglePredefinedLocations() {
    setState(() {
      _showPredefinedLocations = !_showPredefinedLocations;
      if (_showPredefinedLocations) {
        _loadPredefinedMarkers();
      } else {
        _markers.clear();
      }
    });
  }

  void _moveToLocation(LatLng position) async {
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(position, 17));
    setState(() {
      _destinationPosition = position;
    });
  }

  Widget _buildLocationsList() {
    final categories = <String, List<Map<String, dynamic>>>{};
    for (var location in _predefinedLocations) {
      final category = location['category'] as String;
      categories.putIfAbsent(category, () => []).add(location);
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'Popular Locations',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children:
                  categories.entries.map((entry) {
                    return ExpansionTile(
                      title: Text(entry.key),
                      children:
                          entry.value.map((location) {
                            return ListTile(
                              dense: true,
                              title: Text(
                                location['name'],
                                style: const TextStyle(fontSize: 14),
                              ),
                              onTap:
                                  () => _moveToLocation(location['position']),
                            );
                          }).toList(),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Destination"),
        actions: [
          IconButton(
            icon: Icon(
              _showPredefinedLocations
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: _togglePredefinedLocations,
            tooltip:
                _showPredefinedLocations ? 'Hide Locations' : 'Show Locations',
          ),
        ],
      ),
      body:
          _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition!,
                      zoom: 15,
                    ),
                    onMapCreated:
                        (controller) => _controller.complete(controller),
                    markers: {
                      ..._markers,
                      if (_destinationPosition != null)
                        Marker(
                          markerId: const MarkerId("selected_destination"),
                          position: _destinationPosition!,
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRose,
                          ),
                          infoWindow: const InfoWindow(
                            title: "Selected Destination",
                            snippet: "Tap 'Confirm' to select this location",
                          ),
                        ),
                    },
                    onTap: _onMapTapped,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                    mapToolbarEnabled: false,
                  ),

                  // Location List Panel
                  if (_showPredefinedLocations)
                    Positioned(
                      bottom: 80,
                      left: 0,
                      right: 0,
                      child: _buildLocationsList(),
                    ),

                  // Confirm Button
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _confirmDestination,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0A3D62),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text("Confirm Destination"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FloatingActionButton.small(
                          onPressed: () async {
                            final controller = await _controller.future;
                            controller.animateCamera(
                              CameraUpdate.newLatLngZoom(_futminnaCenter, 15),
                            );
                          },
                          backgroundColor: const Color(0xFF0A3D62),
                          child: const Icon(Icons.home, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  // Legend
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Legend:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          _buildLegendItem(Colors.blue, 'Faculties'),
                          _buildLegendItem(Colors.orange, 'Food'),
                          _buildLegendItem(Colors.cyan, 'Hostels'),
                          _buildLegendItem(Colors.green, 'Services'),
                          _buildLegendItem(Colors.pink, 'Selected'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
