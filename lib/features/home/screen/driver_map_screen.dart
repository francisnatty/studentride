import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:studentride/features/home/data/model/get_available_rides.dart';
import '../sm/driver_home_provider.dart';

class DriverMapScreen extends StatefulWidget {
  final RideData ride;
  final LatLng? driverLocation; // pass actual location if available
  final LatLng pickupLatLng;
  final LatLng dropoffLatLng;
  final String pickupAddress;
  final String dropOffAddress;

  const DriverMapScreen({
    super.key,
    required this.ride,
    required this.driverLocation,
    required this.pickupLatLng,
    required this.dropoffLatLng,
    required this.pickupAddress,
    required this.dropOffAddress,
  });

  @override
  State<DriverMapScreen> createState() => _DriverMapScreenState();
}

class _DriverMapScreenState extends State<DriverMapScreen> {
  GoogleMapController? _controller;
  bool _actionBusy = false;

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<DriverHomeProvider>();
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('pickup'),
        position: widget.pickupLatLng,
        infoWindow: const InfoWindow(title: 'Pickup'),
      ),
      Marker(
        markerId: const MarkerId('dropoff'),
        position: widget.dropoffLatLng,
        infoWindow: const InfoWindow(title: 'Dropoff'),
      ),
      if (widget.driverLocation != null)
        Marker(
          markerId: const MarkerId('driver'),
          position: widget.driverLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(title: 'You'),
        ),
    };

    final lines = <Polyline>{
      if (widget.driverLocation != null)
        Polyline(
          polylineId: const PolylineId('driver_to_pickup'),
          points: [widget.driverLocation!, widget.pickupLatLng],
          width: 5,
        ),
      Polyline(
        polylineId: const PolylineId('pickup_to_dropoff'),
        points: [widget.pickupLatLng, widget.dropoffLatLng],
        width: 4,
      ),
    };

    final bounds = _boundsFor([
      if (widget.driverLocation != null) widget.driverLocation!,
      widget.pickupLatLng,
      widget.dropoffLatLng,
    ]);

    final fare = NumberFormat.currency(symbol: '₦').format(widget.ride.fare);
    final driverToPickupKm =
        widget.driverLocation == null
            ? null
            : _haversineKm(widget.driverLocation!, widget.pickupLatLng);
    final pickupToDropKm = _haversineKm(
      widget.pickupLatLng,
      widget.dropoffLatLng,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Ride Preview')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.pickupLatLng,
              zoom: 14,
            ),
            markers: markers,
            polylines: lines,
            onMapCreated: (c) {
              _controller = c;
              if (bounds != null) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  _controller?.animateCamera(
                    CameraUpdate.newLatLngBounds(bounds, 64),
                  );
                });
              }
            },
            myLocationButtonEnabled: true,
            myLocationEnabled: false, // set true if you wired location perms
            compassEnabled: true,
          ),

          // Info card
          Positioned(
            left: 16,
            right: 16,
            bottom: 92, // leave space for action bar
            child: _InfoCard(
              fare: fare,
              driverToPickupKm: driverToPickupKm,
              pickupToDropKm: pickupToDropKm,
              passengerName: widget.ride.passenger!.name,
            ),
          ),

          // Accept / Reject bar
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          _actionBusy
                              ? null
                              : () async {
                                await _handleReject(context, prov);
                              },
                      child:
                          _actionBusy
                              ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed:
                          _actionBusy
                              ? null
                              : () async {
                                await _handleAccept(context, prov);
                              },
                      child:
                          _actionBusy
                              ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAccept(
    BuildContext context,
    DriverHomeProvider prov,
  ) async {
    setState(() => _actionBusy = true);
    final ok = await prov.accept(widget.ride.id);
    if (!mounted) return;
    setState(() => _actionBusy = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Ride accepted' : prov.error ?? 'Failed')),
    );

    if (ok) {
      // a) Just pop back:
      Navigator.of(context).pop();

      // b) Or hard switch to DriverHome and clear back stack:
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (_) => const DriverHomeScreen()),
      //   (route) => false,
      // );
    }
  }

  Future<void> _handleReject(
    BuildContext context,
    DriverHomeProvider prov,
  ) async {
    setState(() => _actionBusy = true);
    final ok = await prov.reject(widget.ride.id);
    if (!mounted) return;
    setState(() => _actionBusy = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Ride rejected' : prov.error ?? 'Failed')),
    );

    if (ok) {
      Navigator.of(context).pop();
    }
  }

  double _haversineKm(LatLng a, LatLng b) {
    const R = 6371.0; // km
    final dLat = _deg2rad(b.latitude - a.latitude);
    final dLon = _deg2rad(b.longitude - a.longitude);
    final lat1 = _deg2rad(a.latitude);
    final lat2 = _deg2rad(b.latitude);

    final h =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
    return R * c;
  }

  double _deg2rad(double d) => d * math.pi / 180;

  LatLngBounds? _boundsFor(List<LatLng> points) {
    if (points.isEmpty) return null;
    double? x0, x1, y0, y1;
    for (final p in points) {
      if (x0 == null) {
        x0 = x1 = p.latitude;
        y0 = y1 = p.longitude;
      } else {
        if (p.latitude > x1!) x1 = p.latitude;
        if (p.latitude < x0) x0 = p.latitude;
        if (p.longitude > y1!) y1 = p.longitude;
        if (p.longitude < y0!) y0 = p.longitude;
      }
    }
    return LatLngBounds(
      southwest: LatLng(x0!, y0!),
      northeast: LatLng(x1!, y1!),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String fare;
  final double? driverToPickupKm;
  final double pickupToDropKm;
  final String passengerName;

  const _InfoCard({
    required this.fare,
    required this.driverToPickupKm,
    required this.pickupToDropKm,
    required this.passengerName,
  });

  @override
  Widget build(BuildContext context) {
    final dp =
        driverToPickupKm == null
            ? '—'
            : '${driverToPickupKm!.toStringAsFixed(2)} km';
    final pd = '${pickupToDropKm.toStringAsFixed(2)} km';

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              passengerName,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.directions_walk, size: 18),
                const SizedBox(width: 6),
                Text('To pickup: $dp'),
                const Spacer(),
                const Icon(Icons.flag, size: 18),
                const SizedBox(width: 6),
                Text('Trip: $pd'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.attach_money, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Fare: $fare',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
