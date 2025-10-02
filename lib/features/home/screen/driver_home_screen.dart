import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../sm/driver_home_provider.dart';
import 'package:studentride/features/home/data/model/get_available_rides.dart';

import 'driver_map_screen.dart';
import 'widgets/driver_status_toggle.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DriverHomeProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<DriverHomeProvider>();
    final isLoading = prov.status == DriverHomeStatus.loading;
    final isAction = prov.status == DriverHomeStatus.actionLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Driver'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed:
                isLoading
                    ? null
                    : () => context.read<DriverHomeProvider>().load(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status/header card
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: _StatusHeader(
                busy: isAction,
                error: prov.error,
                total: prov.requests.length,
              ),
            ),

            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ImprovedDriverStatusToggle(),
            ),

            SizedBox(height: 10),
            // Requests list
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : prov.requests.isEmpty
                      ? const _EmptyState()
                      : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemBuilder:
                            (_, i) => _RideCard(data: prov.requests[i]),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: prov.requests.length,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusHeader extends StatelessWidget {
  final bool busy;
  final String? error;
  final int total;
  const _StatusHeader({
    required this.busy,
    required this.error,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: primary.withOpacity(.09),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.directions_bike, color: primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error != null ? 'Error: $error' : 'Requests available: $total',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          if (busy) const SizedBox(width: 8),
          if (busy)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No ride requests right now.\nPull to refresh in a bit.',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  final RideData data;
  const _RideCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('MMM d, HH:mm');
    final when = df.format(data.requestedAt);

    final fareText = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    ).format(data.fare);

    final pickup = data.pickupLocation.coordinates;
    final dropoff = data.dropoffLocation.coordinates;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => DriverMapScreen(
                    ride: data,
                    driverLocation: null,
                    pickupLatLng: LatLng(pickup[1], pickup[0]),
                    dropoffLatLng: LatLng(dropoff[1], dropoff[0]),
                    pickupAddress: data.pickupAddress,
                    dropOffAddress: data.dropoffAddress,
                  ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade600],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 28),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.passenger!.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              when,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Fare Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade600],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      fareText,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Divider
              Divider(color: Colors.grey.shade200, height: 1),

              const SizedBox(height: 16),

              // Locations
              _LocationRow(
                icon: Icons.trip_origin,
                iconColor: Colors.green,
                label: 'Pickup',
                address: data.pickupAddress,
              ),
              const SizedBox(height: 12),
              _LocationRow(
                icon: Icons.location_on,
                iconColor: Colors.red,
                label: 'Drop-off',
                address: data.dropoffAddress,
              ),

              const SizedBox(height: 20),

              // Action Buttons
              _AcceptRejectButtons(rideId: data.id),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String address;

  const _LocationRow({
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
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                address,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AcceptRejectButtons extends StatelessWidget {
  final String rideId;
  const _AcceptRejectButtons({required this.rideId});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<DriverHomeProvider>();
    final busy = prov.status == DriverHomeStatus.actionLoading;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed:
                busy
                    ? null
                    : () async {
                      final ok = await context
                          .read<DriverHomeProvider>()
                          .reject(rideId);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ok
                                ? 'Ride rejected'
                                : prov.error ?? 'Failed to reject',
                          ),
                          backgroundColor: ok ? Colors.orange : Colors.red,
                        ),
                      );
                    },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: Colors.grey.shade300, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Reject',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed:
                busy
                    ? null
                    : () async {
                      final ok = await context
                          .read<DriverHomeProvider>()
                          .accept(rideId);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ok
                                ? 'Ride accepted'
                                : prov.error ?? 'Failed to accept',
                          ),
                          backgroundColor: ok ? Colors.green : Colors.red,
                        ),
                      );
                    },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Accept Ride',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// class _RideCard extends StatelessWidget {
//   final RideData data;
//   const _RideCard({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     final df = DateFormat('MMM d, HH:mm');
//     final when = df.format(data.requestedAt);

//     // ✅ fare already in naira, no division
//     final fareText = NumberFormat.currency(
//       locale: 'en_NG',
//       symbol: '₦',
//       decimalDigits: 2,
//     ).format(data.fare);

//     final pickup = data.pickupLocation.coordinates;
//     final dropoff = data.dropoffLocation.coordinates;

//     final pickupAddress = data.pickupAddress;
//     final dropOffaddress = data.dropoffAddress;

//     return InkWell(
//       borderRadius: BorderRadius.circular(16),
//       onTap: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder:
//                 (_) => DriverMapScreen(
//                   ride: data,
//                   driverLocation: null,
//                   pickupLatLng: LatLng(pickup[1], pickup[0]),
//                   dropoffLatLng: LatLng(dropoff[1], dropoff[0]),
//                   pickupAddress: data.pickupAddress,
//                   dropOffAddress: data.dropoffAddress,
//                 ),
//           ),
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade50,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.grey.shade200),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const CircleAvatar(radius: 22, child: Icon(Icons.person)),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     data.passenger!.name,
//                     style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Requested: $when',
//                     style: GoogleFonts.poppins(
//                       fontSize: 10,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.location_on,
//                         size: 16,
//                         color: Colors.green,
//                       ),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           pickupAddress,
//                           style: GoogleFonts.poppins(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       const Icon(Icons.flag, size: 16, color: Colors.red),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           dropOffaddress,
//                           style: GoogleFonts.poppins(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Fare: $fareText',
//                     style: GoogleFonts.roboto(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 15,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 12),
//             _AcceptRejectButtons(rideId: data.id),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _AcceptRejectButtons extends StatelessWidget {
//   final String rideId;
//   const _AcceptRejectButtons({required this.rideId});

//   @override
//   Widget build(BuildContext context) {
//     final prov = context.watch<DriverHomeProvider>();
//     final busy = prov.status == DriverHomeStatus.actionLoading;

//     return Column(
//       children: [
//         ElevatedButton(
//           onPressed:
//               busy
//                   ? null
//                   : () async {
//                     final ok = await context.read<DriverHomeProvider>().accept(
//                       rideId,
//                     );
//                     if (!context.mounted) return;
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           ok
//                               ? 'Ride accepted'
//                               : prov.error ?? 'Failed to accept',
//                         ),
//                       ),
//                     );
//                   },
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//           child: const Text('Accept'),
//         ),
//         const SizedBox(height: 8),
//         OutlinedButton(
//           onPressed:
//               busy
//                   ? null
//                   : () async {
//                     final ok = await context.read<DriverHomeProvider>().reject(
//                       rideId,
//                     );
//                     if (!context.mounted) return;
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           ok
//                               ? 'Ride rejected'
//                               : prov.error ?? 'Failed to reject',
//                         ),
//                       ),
//                     );
//                   },
//           child: const Text('Reject'),
//         ),
//       ],
//     );
//   }
// }
