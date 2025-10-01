import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../auth/notifier/auth_session.dart';
import '../data/model/get_rides_model.dart';
import '../sm/ride_provider.dart';

class RideDetailsScreen extends StatefulWidget {
  final RideModel ride;

  const RideDetailsScreen({super.key, required this.ride});

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  GoogleMapController? _mapController;
  bool _isCompletingRide = false;

  @override
  Widget build(BuildContext context) {
    final authSession = context.watch<AuthSession>();
    final rideProvider = context.watch<RideProvider>();
    final isPassenger = authSession.isPassenger;
    final canComplete =
        isPassenger && widget.ride.status.toLowerCase() == 'accepted';

    // Parse coordinates (assuming ride model has pickup/dropoff lat/lng)
    final pickupLatLng = LatLng(
      widget.ride.pickupLocation.lat ?? 0.0,
      widget.ride.pickupLocation.lng ?? 0.0,
    );
    final dropoffLatLng = LatLng(
      widget.ride.dropoffLocation.lat ?? 0.0,
      widget.ride.dropoffLocation.lng ?? 0.0,
    );

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('pickup'),
        position: pickupLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: 'Pickup Location',
          snippet: widget.ride.pickupAddress,
        ),
      ),
      Marker(
        markerId: const MarkerId('dropoff'),
        position: dropoffLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: 'Dropoff Location',
          snippet: widget.ride.dropoffAddress,
        ),
      ),
    };

    final polylines = <Polyline>{
      Polyline(
        polylineId: const PolylineId('route'),
        points: [pickupLatLng, dropoffLatLng],
        color: const Color(0xFF1A73E8),
        width: 5,
        patterns: [PatternItem.dot, PatternItem.gap(10)],
      ),
    };

    final distance = _calculateDistance(pickupLatLng, dropoffLatLng);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: pickupLatLng,
              zoom: 13,
            ),
            markers: markers,
            polylines: polylines,
            onMapCreated: (controller) {
              _mapController = controller;
              _fitMapBounds(pickupLatLng, dropoffLatLng);
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            mapToolbarEnabled: false,
          ),

          // Top Info Card
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Column(
                children: [
                  // App Bar
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                          color: const Color(0xFF1A1A1A),
                        ),
                        Expanded(
                          child: Text(
                            'Ride Details',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _statusBg(widget.ride.status),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _titleCase(widget.ride.status),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _statusFg(widget.ride.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Ride Info Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Fare and Distance
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Fare',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  rideProvider.formatFare(widget.ride.fare),
                                  style: GoogleFonts.roboto(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF1A73E8),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F4FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.route_rounded,
                                    color: const Color(0xFF1A73E8),
                                    size: 24,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${distance.toStringAsFixed(2)} km',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1A73E8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(height: 1),
                        const SizedBox(height: 20),

                        // Route Details
                        _RoutePoint(
                          icon: Icons.radio_button_checked,
                          iconColor: const Color(0xFF4CAF50),
                          label: 'Pickup',
                          address: widget.ride.pickupAddress,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 11),
                          height: 32,
                          width: 2,
                          color: const Color(0xFFE0E0E0),
                        ),
                        _RoutePoint(
                          icon: Icons.location_on,
                          iconColor: const Color(0xFFFF5252),
                          label: 'Dropoff',
                          address: widget.ride.dropoffAddress,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Card
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Driver/Passenger Info (if available)
                    if (widget.ride.driver!.name != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A73E8),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  widget.ride.driver!.name![0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isPassenger ? 'Your Driver' : 'Passenger',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.ride.driver!.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (widget.ride.driver!.phone != null)
                              IconButton(
                                onPressed: () {
                                  // Launch phone dialer
                                  // launch('tel:${widget.ride.driverPhone}');
                                },
                                icon: const Icon(Icons.phone),
                                color: const Color(0xFF1A73E8),
                              ),
                          ],
                        ),
                      ),

                    // Time Info
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 20,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Requested ${rideProvider.formatWhen(widget.ride.requestedAt)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // Complete Ride Button (only for accepted rides by passengers)
                    if (canComplete) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                              _isCompletingRide
                                  ? null
                                  : () => _completeRide(context, rideProvider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            disabledBackgroundColor: Colors.grey[300],
                          ),
                          child:
                              _isCompletingRide
                                  ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                  : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Mark as Completed',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _completeRide(
    BuildContext context,
    RideProvider rideProvider,
  ) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Complete Ride?'),
            content: const Text(
              'Have you reached your destination? This will mark the ride as completed.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                ),
                child: const Text('Confirm'),
              ),
            ],
          ),
    );

    if (confirmed != true) return;

    setState(() => _isCompletingRide = true);

    // Call the API to complete the ride
    final success = await rideProvider.commpleteRide(
      rideId: widget.ride.id,
      context: context,
    );

    if (!mounted) return;

    setState(() => _isCompletingRide = false);

    // if (success) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Ride completed successfully!'),
    //       backgroundColor: Color(0xFF4CAF50),
    //     ),
    //   );

    //   // Refresh rides list and pop back
    //   await rideProvider.refresh();
    //   if (mounted) Navigator.of(context).pop();
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(rideProvider.errorMessage ?? 'Failed to complete ride'),
    //       backgroundColor: const Color(0xFFFF5252),
    //     ),
    //   );
    // }
  }

  void _fitMapBounds(LatLng pickup, LatLng dropoff) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_mapController != null) {
        final bounds = LatLngBounds(
          southwest: LatLng(
            math.min(pickup.latitude, dropoff.latitude),
            math.min(pickup.longitude, dropoff.longitude),
          ),
          northeast: LatLng(
            math.max(pickup.latitude, dropoff.latitude),
            math.max(pickup.longitude, dropoff.longitude),
          ),
        );
        _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 100),
        );
      }
    });
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const R = 6371.0; // Earth's radius in km
    final dLat = _deg2rad(end.latitude - start.latitude);
    final dLon = _deg2rad(end.longitude - start.longitude);
    final lat1 = _deg2rad(start.latitude);
    final lat2 = _deg2rad(end.latitude);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * math.pi / 180;

  String _titleCase(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

  Color _statusBg(String s) {
    switch (s.toLowerCase()) {
      case 'accepted':
      case 'ongoing':
        return const Color(0xFFE8F5E9);
      case 'pending':
        return const Color(0xFFFFF8E1);
      case 'completed':
        return const Color(0xFFE3F2FD);
      case 'cancelled':
      case 'declined':
        return const Color(0xFFFFEBEE);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  Color _statusFg(String s) {
    switch (s.toLowerCase()) {
      case 'accepted':
      case 'ongoing':
        return const Color(0xFF2E7D32);
      case 'pending':
        return const Color(0xFFF57C00);
      case 'completed':
        return const Color(0xFF1565C0);
      case 'cancelled':
      case 'declined':
        return const Color(0xFFC62828);
      default:
        return const Color(0xFF616161);
    }
  }
}

class _RoutePoint extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String address;

  const _RoutePoint({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                address,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
