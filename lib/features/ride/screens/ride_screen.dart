import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studentride/core/helper/transition.dart';
import 'package:studentride/core/widget/snackbar_helper.dart';
import '../data/model/get_rides_model.dart';
import '../sm/ride_provider.dart';
import 'ride_details.dart';

class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<RideProvider>();

    if (prov.status == RideLoadStatus.loading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: _AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (prov.status == RideLoadStatus.error) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: _AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Color(0xFFC62828),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  prov.errorMessage ?? 'Failed to load rides',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF424242),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: prov.refresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final tabs = prov.tabs;
    return DefaultTabController(
      key: ValueKey(tabs.join(',')),
      length: tabs.length,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: _AppBar(),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                isScrollable: true,
                labelColor: const Color(0xFF1A1A1A),
                unselectedLabelColor: const Color(0xFF9E9E9E),
                labelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                indicatorColor: const Color(0xFF1A1A1A),
                indicatorWeight: 3,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                tabs: [for (final t in tabs) Tab(text: t)],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
            Expanded(
              child: TabBarView(
                children: [for (final t in tabs) _RideList(tabLabel: t)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final prov = context.watch<RideProvider>();
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF1A1A1A),
      title: Text(
        'My Rides',
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${prov.total}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        IconButton(
          tooltip: 'Refresh',
          onPressed: prov.refresh,
          icon: const Icon(Icons.refresh_rounded),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _RideList extends StatelessWidget {
  final String tabLabel;
  const _RideList({required this.tabLabel});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<RideProvider>();
    final items = prov.byTab(tabLabel);

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_car_outlined,
                size: 64,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No rides yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your $tabLabel rides will appear here',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => _RideCard(data: items[i]),
    );
  }
}

class _RideCard extends StatelessWidget {
  final RideModel data;
  const _RideCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final prov = context.read<RideProvider>();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        onTap: () {
          final status = data.status;
          if (status == 'requested') {
            SnackBarHelper.showWarning(context, 'NO RIDER YET');
          } else {
            context.pushRight(RideDetailsScreen(ride: data));
          }
        },
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
              // Header: Status + Fare
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _statusBg(data.status),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _statusIcon(data.status),
                          size: 14,
                          color: _statusFg(data.status),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _titleCase(data.status),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _statusFg(data.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    prov.formatFare(data.fare),
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Route visualization
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vertical line with dots
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 32,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5252),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),

                  // Addresses
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.pickupAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF424242),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          data.dropoffAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF424242),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Footer: Time + View details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        prov.formatWhen(data.requestedAt),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'View details',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _titleCase(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

  IconData _statusIcon(String s) {
    switch (s.toLowerCase()) {
      case 'accepted':
        return Icons.check_circle_rounded;
      case 'ongoing':
        return Icons.local_shipping_rounded;
      case 'pending':
        return Icons.schedule_rounded;
      case 'completed':
        return Icons.check_circle_outline_rounded;
      case 'cancelled':
      case 'declined':
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
    }
  }

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
