// lib/widgets/booking_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../screen/map_select_screen.dart';
import '../sm/booking_provider.dart';

class BookingBottomSheet extends StatefulWidget {
  const BookingBottomSheet({super.key});

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

              // From section
              const Text(
                'From',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),

              // Popular pickup locations
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    bookingProvider.popularPickupLocations.map((location) {
                      final isSelected =
                          bookingProvider.pickupLocation == location['name'];
                      return GestureDetector(
                        onTap: () {
                          bookingProvider.setPickupLocation(
                            location['name'],
                            location['coordinates'],
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xFF0A3D62)
                                    : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? const Color(0xFF0A3D62)
                                      : Colors.transparent,
                            ),
                          ),
                          child: Text(
                            location['name'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),

              const SizedBox(height: 24),

              // To section
              const Text(
                'To',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),

              // Destination input
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MapSelectScreen()),
                  );

                  if (result != null) {
                    final LatLng selectedDestination = result;
                    bookingProvider.setDestinationFromMap(selectedDestination);
                  }
                },
                child: Container(
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
                          bookingProvider.destinationLocation ??
                              "Where are you going to",
                          style: TextStyle(
                            color:
                                bookingProvider.destinationLocation != null
                                    ? Colors.black
                                    : Colors.grey,
                          ),
                        ),
                      ),
                      const Icon(Icons.map, color: Color(0xFF0A3D62)),
                    ],
                  ),
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
        );
      },
    );
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
      _showFarePreview(provider);
    } else {
      provider.getFarePreview();
    }
  }

  void _showFarePreview(BookingProvider provider) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => FarePreviewBottomSheet(
            fareData: provider.farePreview!,
            pickupLocation: provider.pickupLocation!,
            destinationLocation: provider.destinationLocation!,
            onConfirm: () {
              Navigator.pop(context); // Close fare preview
              Navigator.pop(context); // Close booking sheet
              provider.requestRide();
              _showRideRequestStatus(provider);
            },
          ),
    );
  }

  void _showRideRequestStatus(BookingProvider provider) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => RideRequestStatusSheet(),
    );
  }
}

class FarePreviewBottomSheet extends StatelessWidget {
  final Map<String, dynamic> fareData;
  final String pickupLocation;
  final String destinationLocation;
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

          // Title
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A3D62),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Confirm button
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
                      provider.reset();
                      Navigator.pop(context);
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
