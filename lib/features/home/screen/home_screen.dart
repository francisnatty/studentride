// // lib/screens/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../data/model/get_drivers.dart';
// import '../sm/booking_provider.dart';
// import '../sm/driver_provider.dart';
// import '../widgets/booking_sheet.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final driversProvider = context.watch<DriversProvider>();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ——— top area ———
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Logo",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.notifications_none),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 "Hi, Natty Dev",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//               ),
//               const Text(
//                 "Good Day",
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//               const SizedBox(height: 16),

//               // Search
//               GestureDetector(
//                 onTap: () => _showBookingBottomSheet(context),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 16,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade100,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Where are you going to",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                       Icon(Icons.search),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Banner
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF0A3D62),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Campus Ride Discount Offer",
//                       style: TextStyle(color: Colors.white, fontSize: 14),
//                     ),
//                     const SizedBox(height: 4),
//                     const Text(
//                       "50% Off",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: const Color(0xFF0A3D62),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       onPressed: () {},
//                       child: const Text("Claim Discount"),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),

//               Text(
//                 'Available Riders',
//                 style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
//               ),

//               // ——— driver list ———
//               Expanded(
//                 child: Builder(
//                   builder: (context) {
//                     if (driversProvider.status == DriversStatus.loading) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     if (driversProvider.status == DriversStatus.error) {
//                       return Center(
//                         child: Text('Error: ${driversProvider.error}'),
//                       );
//                     }
//                     if (driversProvider.drivers.isEmpty) {
//                       return const Center(child: Text('No drivers available'));
//                     }

//                     return ListView.builder(
//                       padding: const EdgeInsets.only(top: 8, bottom: 16),
//                       itemCount: driversProvider.drivers.length,
//                       itemBuilder: (context, index) {
//                         final driver = driversProvider.drivers[index];
//                         return Padding(
//                           padding: EdgeInsets.symmetric(vertical: 15),
//                           child: DriverCard(
//                             driver: driver,
//                             // name: driver.displayName,
//                             // rating: driver.driverDetails.rating,
//                             // isAvailable:
//                             //     driver
//                             //         .driverDetails
//                             //         .isVerified, // change to your logic
//                             // onBook: () => _showBookingBottomSheet(context),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showBookingBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder:
//           (context) => ChangeNotifierProvider(
//             create: (_) => BookingProvider(),
//             child: const BookingBottomSheet(),
//           ),
//     );
//   }
// }

// class DriverCard extends StatelessWidget {
//   final Driver driver;
//   final VoidCallback? onTap;

//   const DriverCard({Key? key, required this.driver, this.onTap})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       elevation: 0,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             border: Border.all(color: const Color(0xFFE8E8E8)),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header: Avatar + Name + Verified Badge
//               Row(
//                 children: [
//                   // Avatar with online indicator
//                   Stack(
//                     children: [
//                       Container(
//                         width: 56,
//                         height: 56,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           gradient: LinearGradient(
//                             colors: [
//                               Theme.of(context).primaryColor,
//                               Theme.of(context).primaryColor.withOpacity(0.7),
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             _getInitials(driver.displayName),
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         right: 2,
//                         bottom: 2,
//                         child: Container(
//                           width: 14,
//                           height: 14,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF4CAF50),
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.white, width: 2),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(width: 12),

//                   // Name and verification
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Flexible(
//                               child: Text(
//                                 driver.displayName,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0xFF1A1A1A),
//                                 ),
//                               ),
//                             ),
//                             if (driver.driverDetails.isVerified) ...[
//                               const SizedBox(width: 6),
//                               Container(
//                                 padding: const EdgeInsets.all(2),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFF2196F3),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const Icon(
//                                   Icons.check,
//                                   size: 12,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           driver.phone,
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.grey[600],
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Rating badge
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFFFF8E1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(
//                           Icons.star_rounded,
//                           size: 16,
//                           color: Color(0xFFFFA000),
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           driver.driverDetails.rating.toString(),
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFFF57C00),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 16),

//               // Divider
//               Container(height: 1, color: const Color(0xFFF5F5F5)),

//               const SizedBox(height: 16),

//               // Stats row
//               Row(
//                 children: [
//                   Expanded(
//                     child: _StatItem(
//                       icon: Icons.local_taxi_rounded,
//                       label: 'Total Rides',
//                       value: _formatNumber(driver.driverDetails.totalRides),
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                   Container(
//                     width: 1,
//                     height: 40,
//                     color: const Color(0xFFF5F5F5),
//                   ),
//                   Expanded(
//                     child: _StatItem(
//                       icon: Icons.location_on_rounded,
//                       label: 'Location',
//                       value: _getLocationStatus(driver.currentLocation),
//                       color: const Color(0xFF4CAF50),
//                     ),
//                   ),
//                   Container(
//                     width: 1,
//                     height: 40,
//                     color: const Color(0xFFF5F5F5),
//                   ),
//                   Expanded(
//                     child: _StatItem(
//                       icon:
//                           driver.driverDetails.isVerified
//                               ? Icons.verified_rounded
//                               : Icons.info_rounded,
//                       label: 'Status',
//                       value:
//                           driver.driverDetails.isVerified
//                               ? 'Verified'
//                               : 'Pending',
//                       color:
//                           driver.driverDetails.isVerified
//                               ? const Color(0xFF2196F3)
//                               : Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),

//               if (onTap != null) ...[
//                 const SizedBox(height: 16),

//                 // View details link
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       'View details',
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     Icon(
//                       Icons.arrow_forward_rounded,
//                       size: 16,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ],
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _getInitials(String name) {
//     final parts = name.trim().split(' ');
//     if (parts.isEmpty) return '?';
//     if (parts.length == 1) return parts[0][0].toUpperCase();
//     return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
//   }

//   String _formatNumber(int number) {
//     if (number >= 1000) {
//       return '${(number / 1000).toStringAsFixed(1)}k';
//     }
//     return number.toString();
//   }

//   String _getLocationStatus(CurrentLocation location) {
//     if (location.coordinates.isEmpty) return 'Unknown';
//     return 'Active';
//   }
// }

// class _StatItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   final Color color;

//   const _StatItem({
//     required this.icon,
//     required this.label,
//     required this.value,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Icon(icon, size: 20, color: color),
//         const SizedBox(height: 6),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF1A1A1A),
//           ),
//         ),
//         const SizedBox(height: 2),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 11,
//             color: Colors.grey[600],
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }

// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../wallet/screens/wallet_screen.dart';
import '../../wallet/sm/wallet_provider.dart';
import '../data/model/get_drivers.dart';
import '../sm/booking_provider.dart';
import '../sm/driver_provider.dart';

import '../widgets/booking_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final driversProvider = context.watch<DriversProvider>();
    final walletProvider = context.watch<WalletProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ——— top area ———
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Logo",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "Hi, Natty Dev",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const Text(
                "Good Day",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // Wallet Banner (Replaced Discount Banner)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ChangeNotifierProvider.value(
                            value: walletProvider,
                            child: const WalletScreen(),
                          ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0A3D62), Color(0xFF1E5F8C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0A3D62).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.account_balance_wallet,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Wallet Balance",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            walletProvider.isLoading
                                ? const SizedBox(
                                  height: 28,
                                  width: 28,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  "₦${_formatBalance(walletProvider.balance)}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Text(
                                  "View Details",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.wallet,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Available Riders',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),

              // ——— driver list ———
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (driversProvider.status == DriversStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (driversProvider.status == DriversStatus.error) {
                      return Center(
                        child: Text('Error: ${driversProvider.error}'),
                      );
                    }
                    if (driversProvider.drivers.isEmpty) {
                      return const Center(child: Text('No drivers available'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      itemCount: driversProvider.drivers.length,
                      itemBuilder: (context, index) {
                        final driver = driversProvider.drivers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: DriverCard(
                            driver: driver,
                            onTap:
                                () => _showBookingBottomSheet(context, driver),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBookingBottomSheet(BuildContext context, Driver driver) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => ChangeNotifierProvider(
            create: (_) => BookingProvider(),
            child: const BookingBottomSheet(),
          ),
    );
  }

  String _formatBalance(double balance) {
    return balance
        .toStringAsFixed(2)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}

class DriverCard extends StatelessWidget {
  final Driver driver;
  final VoidCallback? onTap;

  const DriverCard({Key? key, required this.driver, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE8E8E8)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Avatar + Name + Verified Badge
              Row(
                children: [
                  // Avatar with online indicator
                  Stack(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _getInitials(driver.displayName),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),

                  // Name and verification
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                driver.displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                            if (driver.driverDetails.isVerified) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2196F3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          driver.phone,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Rating badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: Color(0xFFFFA000),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          driver.driverDetails.rating.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFF57C00),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Divider
              Container(height: 1, color: const Color(0xFFF5F5F5)),

              const SizedBox(height: 16),

              // Stats row
              Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      icon: Icons.local_taxi_rounded,
                      label: 'Total Rides',
                      value: _formatNumber(driver.driverDetails.totalRides),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: const Color(0xFFF5F5F5),
                  ),
                  Expanded(
                    child: _StatItem(
                      icon: Icons.location_on_rounded,
                      label: 'Location',
                      value: _getLocationStatus(driver.currentLocation),
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: const Color(0xFFF5F5F5),
                  ),
                  Expanded(
                    child: _StatItem(
                      icon:
                          driver.driverDetails.isVerified
                              ? Icons.verified_rounded
                              : Icons.info_rounded,
                      label: 'Status',
                      value:
                          driver.driverDetails.isVerified
                              ? 'Verified'
                              : 'Pending',
                      color:
                          driver.driverDetails.isVerified
                              ? const Color(0xFF2196F3)
                              : Colors.grey,
                    ),
                  ),
                ],
              ),

              if (onTap != null) ...[
                const SizedBox(height: 16),

                // Book Ride Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A3D62),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_car, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Book Ride',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
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
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }

  String _getLocationStatus(CurrentLocation location) {
    if (location.coordinates.isEmpty) return 'Unknown';
    return 'Active';
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
