// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../sm/booking_provider.dart';
import '../sm/driver_provider.dart';
import '../widgets/booking_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final driversProvider = context.watch<DriversProvider>();

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

              // Search
              GestureDetector(
                onTap: () => _showBookingBottomSheet(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Where are you going to",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Icon(Icons.search),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A3D62),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Campus Ride Discount Offer",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "50% Off",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0A3D62),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("Claim Discount"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

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
                        return _DriverCard(
                          name: driver.displayName,
                          rating: driver.driverDetails.rating,
                          isAvailable:
                              driver
                                  .driverDetails
                                  .isVerified, // change to your logic
                          onBook: () => _showBookingBottomSheet(context),
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

  void _showBookingBottomSheet(BuildContext context) {
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
}

class _DriverCard extends StatelessWidget {
  final String name;
  final int rating;
  final bool isAvailable;
  final VoidCallback onBook;

  const _DriverCard({
    required this.name,
    required this.rating,
    required this.isAvailable,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(' $rating'),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isAvailable ? Colors.green : Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Available",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3D62),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                ),
                onPressed: isAvailable ? onBook : onBook,
                child: const Text("Book Ride"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
