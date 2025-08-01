// // Add these helper functions to your HomePage class or create a separate utility file

// import 'dart:math';
// import 'package:geolocator/geolocator.dart';

// class BookingHelper {
//   // Calculate distance between two points using Haversine formula
//   static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const double earthRadius = 6371; // Earth's radius in kilometers
    
//     double dLat = _degreesToRadians(lat2 - lat1);
//     double dLon = _degreesToRadians(lon2 - lon1);
    
//     double a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
//         sin(dLon / 2) * sin(dLon / 2);
    
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
//     return earthRadius * c;
//   }
  
//   static double _degreesToRadians(double degrees) {
//     return degrees * pi / 180;
//   }
  
//   // Calculate estimated fare based on distance and vehicle type
//   static Map<String, dynamic> calculateFare(double distanceKm, String vehicleType) {
//     Map<String, Map<String, double>> rates = {
//       'motorcycle': {'base': 150, 'perKm': 80},
//       'tricycle': {'base': 200, 'perKm': 100},
//       'minibus': {'base': 300, 'perKm': 120},
//     };
    
//     double baseFare = rates[vehicleType]?['base'] ?? 150;
//     double perKmRate = rates[vehicleType]?['perKm'] ?? 80;
    
//     double totalFare = baseFare + (distanceKm * perKmRate);
    
//     return {
//       'distance': distanceKm,
//       'estimated_fare': totalFare.round(),
//       'base_fare': baseFare,
//       'distance_fare': (distanceKm * perKmRate).round(),
//     };
//   }
  
//   // Get estimated arrival time based on distance and vehicle type
//   static String getEstimatedTime(double distanceKm, String vehicleType) {
//     Map<String, double> avgSpeeds = {
//       'motorcycle': 25.0, // km/h in campus traffic
//       'tricycle': 20.0,
//       'minibus': 15.0,
//     };
    
//     double speed = avgSpeeds[vehicleType] ?? 20.0;
//     double timeInHours = distanceKm / speed;
//     int timeInMinutes = (timeInHours * 60).round();
    
//     // Add base waiting time
//     int waitingTime = vehicleType == 'motorcycle' ? 3 : 
//                      vehicleType == 'tricycle' ? 5 : 8;
    
//     int totalTime = timeInMinutes + waitingTime;
    
//     if (totalTime < 60) {
//       return '$totalTime mins';
//     } else {
//       int hours = totalTime ~/ 60;
//       int mins = totalTime % 60;
//       return '${hours}h ${mins}m';
//     }
//   }
// }

// // Enhanced ride confirmation sheet method for your HomePage
// Widget _buildEnhancedRideConfirmationSheet() {
//   if (_selectedLocationData == null) return Container();
  
//   // Calculate trip details
//   double distance = BookingHelper.calculateDistance(
//     _selectedLocationData!['current_location'].latitude,
//     _selectedLocationData!['current_location'].longitude,
//     _selectedLocationData!['destination'].latitude,
//     _selectedLocationData!['destination'].longitude,
//   );
  
//   Map<String, dynamic> fareDetails = BookingHelper.calculateFare(distance, _selectedVehicleType);
//   String estimatedTime = BookingHelper.getEstimatedTime(distance, _selectedVehicleType);
  
//   return Container(
//     padding: const EdgeInsets.all(20),
//     decoration: const BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//     ),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 40,
//           height: 4,
//           decoration: BoxDecoration(
//             color: Colors.grey[300],
//             borderRadius: BorderRadius.circular(2),
//           ),
//         ),
//         const SizedBox(height: 20),
//         const Text(
//           'Trip Summary',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF2D3748),
//           ),
//         ),
//         const SizedBox(height: 20),
        
//         // Trip Route Card
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.grey[50],
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   const Icon(Icons.my_location, color: Color(0xFF10B981), size: 16),
//                   const SizedBox(width: 8),
//                   const Text('Pickup Location', style: TextStyle(fontSize: 12, color: Colors.grey)),
//                 ],
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(left: 24),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     'Current Location',
//                     style: TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Container(
//                     width: 3,
//                     height: 20,
//                     color: Colors.grey[300],
//                     margin: const EdgeInsets.only(left: 6.5),
//                   ),
//                   const SizedBox(width: 20),
//                   Text(
//                     '${distance.toStringAsFixed(1)} km • $estimatedTime',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Color(0xFF667eea),
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   const Icon(Icons.location_on, color: Color(0xFFEF4444), size: 16),
//                   const SizedBox(width: 8),
//                   const Text('Destination', style: TextStyle(fontSize: 12, color: Colors.grey)),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 24),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     _selectedLocationData!['address'] ?? 'Selected Location',
//                     style: const TextStyle(fontWeight: FontWeight.w500),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
        
//         const SizedBox(height: 16),
        
//         // Vehicle and Fare Card
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             border: Border.all(color: const Color(0xFF667eea)),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF667eea).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                       _selectedVehicleType == 'motorcycle' ? Icons.motorcycle :
//                       _selectedVehicleType == 'tricycle' ? Icons.agriculture : Icons.directions_bus,
//                       color: const Color(0xFF667eea),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           _selectedVehicleType == 'motorcycle' ? 'Motorcycle' :
//                           _selectedVehicleType == 'tricycle' ? 'Tricycle' : 'Minibus',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         Text(
//                           'Estimated arrival: $estimatedTime',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         '₦${fareDetails['estimated_fare']}',
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF667eea),
//                         ),
//                       ),
//                       const Text(
//                         'Estimated fare',
//                         style: TextStyle(
//                           fontSize: 10,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
              
//               const SizedBox(height: 12),
//               const Divider(),
//               const SizedBox(height: 8),
              
//               // Fare breakdown
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Base fare', style: TextStyle(color: Colors.grey)),
//                   Text('₦${fareDetails['base_fare'].toInt()}'),
//                 ],
//               ),
//               const SizedBox(height: 4),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Distance (${distance.toStringAsFixed(1)} km)', 
//                        style: const TextStyle(color: Colors.grey)),
//                   Text('₦${fareDetails['distance_fare']}'),
//                 ],
//               ),
//             ],
//           ),
//         ),
        
//         const SizedBox(height: 24),
        
//         // Payment Method Selection
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.grey[50],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Row(
//             children: [
//               const Icon(Icons.payment, color: Color(0xFF667eea), size: 20),
//               const SizedBox(width: 8),
//               const Text('Payment: ', style: TextStyle(fontWeight: FontWeight.w500)),
//               const Text('Cash on arrival'),
//               const Spacer(),
//               Icon(Icons.keyboard_arrow_right, color: Colors.grey[400]),
//             ],
//           ),
//         ),
        
//         const SizedBox(height: 20),
        
//         // Confirm Button
//         SizedBox(
//           width: double.infinity,
//           height: 54,
//           child: ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _showRideBookedDialog(fareDetails);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF667eea),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 0,
//             ),
//             child: Text(
//               'Book Ride • ₦${fareDetails['estimated_fare']}',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
        
//         const SizedBox(height: 10),
        
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text(
//             'Cancel',
//             style: TextStyle(color: Colors.grey),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// void _showRideBookedDialog(Map<String, dynamic> fareDetails) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) => AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               color: const Color(0xFF10B981).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.check_circle,
//               color: Color(0xFF10B981),
//               size: 50,
//             ),
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'Ride Booked Successfully!',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 10),
//           Text(
//             'Fare: ₦${fareDetails['