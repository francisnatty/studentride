// lib/widgets/booking_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../screen/map_select_screen.dart';
import '../sm/booking_provider.dart';
import '../data/service/location_service.dart';

class BookingBottomSheet extends StatefulWidget {
  const BookingBottomSheet({super.key});

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  // NEW: cache selected addresses for display
  String? _pickupAddress;
  String? _destinationAddress;

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            // prevent overflow on small screens
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Book a Ride',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        bookingProvider.reset();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ===== FROM =====
                const Text(
                  'From',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),

                // NEW: dropdown of predefined pickup locations
                // DropdownButtonFormField<Map<String, dynamic>>(
                //   value: null,
                //   decoration: InputDecoration(
                //     hintText: 'Choose a pickup location',
                //     contentPadding: const EdgeInsets.symmetric(
                //       horizontal: 12,
                //       vertical: 14,
                //     ),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //   ),
                //   items:
                //       bookingProvider.popularPickupLocations
                //           .map<DropdownMenuItem<Map<String, dynamic>>>((
                //             location,
                //           ) {
                //             return DropdownMenuItem(
                //               value: location,
                //               child: Text(location['name']),
                //             );
                //           })
                //           .toList(),
                //   onChanged: (location) async {
                //     if (location == null) return;
                //     bookingProvider.setPickupLocation(
                //       location['name'],
                //       location['coordinates'],
                //     );
                //     // NEW: reverse geocode + display full address
                //     final coords = location['coordinates'] as LatLng;
                //     final address = await LocationService()
                //         .getAddressFromLatLng(coords);
                //     setState(() => _pickupAddress = address);
                //   },
                // ),
                const SizedBox(height: 10),

                // NEW: select on map button (pickup)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    //  padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextButton.icon(
                      onPressed:
                          () => _pickOnMap(
                            isPickup: true,
                            bookingProvider: bookingProvider,
                          ),
                      icon: const Icon(Icons.map),
                      label: const Text('Select pickup on map'),
                    ),
                  ),
                ),

                // Display selected pickup address
                if (bookingProvider.pickupLocation != null ||
                    _pickupAddress != null) ...[
                  const SizedBox(height: 8),
                  _SelectedAddressTile(
                    label: bookingProvider.pickupLocation ?? 'Pickup',
                    address: _pickupAddress ?? 'Location selected',
                    accent: const Color(0xFF0A3D62),
                  ),
                ],

                const SizedBox(height: 24),

                // ===== TO =====
                const Text(
                  'To',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    //  padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextButton.icon(
                      onPressed:
                          () => _pickOnMap(
                            isPickup: false,
                            bookingProvider: bookingProvider,
                          ),
                      icon: const Icon(Icons.map_outlined),
                      label: const Text('Select destination on map'),
                    ),
                  ),
                ),

                // Destination display (kept your container but now shows full address)
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          bookingProvider.destinationLocation != null
                              ? const Color(0xFF0A3D62)
                              : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _destinationAddress ??
                              bookingProvider.destinationLocation ??
                              "Where are you going to",
                          style: TextStyle(
                            color:
                                (bookingProvider.destinationLocation != null ||
                                        _destinationAddress != null)
                                    ? Colors.black
                                    : Colors.grey,
                          ),
                        ),
                      ),
                      const Icon(Icons.map, color: Color(0xFF0A3D62)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _canContinue(bookingProvider)
                            ? () => _handleContinue(bookingProvider)
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A3D62),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _buildButtonContent(bookingProvider),
                  ),
                ),

                // Error message
                if (bookingProvider.state == BookingState.error) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            bookingProvider.errorMessage ?? 'An error occurred',
                            style: TextStyle(color: Colors.red.shade600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickOnMap({
    required bool isPickup,
    required BookingProvider bookingProvider,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MapSelectScreen(isFromBookingFlow: true),
      ),
    );

    // result is a Map { 'latLng': LatLng, 'name': String?, 'address': String }
    if (result is Map && result['latLng'] is LatLng) {
      final LatLng pos = result['latLng'];
      final String address =
          (result['address'] as String?) ?? '${pos.latitude}, ${pos.longitude}';
      final String? name = result['name'] as String?;

      if (isPickup) {
        bookingProvider.setPickupLocation(name ?? 'Selected pickup', pos);
        setState(() => _pickupAddress = address);
      } else {
        bookingProvider.setDestinationLocation(
          name ?? 'Selected destination',
          pos,
        );
        setState(() => _destinationAddress = address);
      }
    }
  }

  bool _canContinue(BookingProvider provider) {
    return provider.pickupLocation != null &&
        provider.destinationLocation != null &&
        provider.state != BookingState.loadingFarePreview;
  }

  Widget _buildButtonContent(BookingProvider provider) {
    switch (provider.state) {
      case BookingState.loadingFarePreview:
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
            SizedBox(width: 8),
            Text('Getting fare...'),
          ],
        );
      case BookingState.farePreviewLoaded:
        return const Text('View Fare Details');
      default:
        return const Text('Continue');
    }
  }

  void _handleContinue(BookingProvider provider) {
    if (provider.state == BookingState.farePreviewLoaded) {
      _showFarePreview();
    } else {
      provider.getFarePreview();
    }
  }

  void _showFarePreview() {
    // Use the current widget context as the safe parent
    final parentContext = context;

    // Read latest provider state now (so we don't capture a stale instance)
    final booking = parentContext.read<BookingProvider>();
    final fareData = booking.farePreview!;
    final pickup = _pickupAddress ?? booking.pickupLocation!;
    final destination = _destinationAddress ?? booking.destinationLocation!;

    showModalBottomSheet(
      context: parentContext,
      useRootNavigator: true, // decouple from this sheet
      builder:
          (sheetCtx) => FarePreviewBottomSheet(
            fareData: fareData,
            pickupLocation: pickup,
            destinationLocation: destination,
            onConfirm: () async {
              // Close ONLY the fare preview
              Navigator.of(sheetCtx).pop();

              // Read provider from a fresh, still-mounted context
              final b = parentContext.read<BookingProvider>();

              // Do the async request BEFORE popping the booking sheet
              await b.requestRide(context: parentContext);

              if (!mounted) return;

              // Show status on the ROOT navigator (not tied to this sheet)
              _showRideRequestStatus();
            },
          ),
    );
  }

  void _showRideRequestStatus() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true, // <- decouple from any inner sheet
      isDismissible: false,
      enableDrag: false,
      builder: (_) => RideRequestStatusSheet(),
    );
  }
}

class FarePreviewBottomSheet extends StatelessWidget {
  final Map<String, dynamic> fareData;
  final String pickupLocation; // now can be full address
  final String destinationLocation; // now can be full address
  final VoidCallback onConfirm;

  const FarePreviewBottomSheet({
    super.key,
    required this.fareData,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Trip Summary',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Route info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.radio_button_checked,
                      color: Color(0xFF0A3D62),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(pickupLocation)),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  height: 20,
                  width: 2,
                  color: Colors.grey.shade300,
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(destinationLocation)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Fare details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Distance'),
                    Text('${fareData['distance']} km'),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Fare',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₦${fareData['fare']}',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0A3D62),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A3D62),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Confirm Ride'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class RideRequestStatusSheet extends StatelessWidget {
  const RideRequestStatusSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (provider.state == BookingState.requestingRide) ...[
                const CircularProgressIndicator(color: Color(0xFF0A3D62)),
                const SizedBox(height: 16),
                const Text('Requesting your ride...'),
              ] else if (provider.state == BookingState.rideRequested) ...[
                const Icon(Icons.check_circle, color: Colors.green, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Ride Requested Successfully!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Looking for nearby riders...'),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      provider.reset();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A3D62),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('OK'),
                  ),
                ),
              ] else if (provider.state == BookingState.error) ...[
                const Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  provider.errorMessage ?? 'An error occurred',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final provider = context.read<BookingProvider>();
                      provider.reset();

                      // Close status sheet
                      Navigator.of(context).pop();

                      // Then try to close underlying booking sheet if it's still there
                      Navigator.of(context).maybePop();
                    },

                    child: const Text('Try Again'),
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

// Small helper widget for neat address display
class _SelectedAddressTile extends StatelessWidget {
  final String label;
  final String address;
  final Color accent;

  const _SelectedAddressTile({
    required this.label,
    required this.address,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.place, color: accent, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(address, style: const TextStyle(color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
