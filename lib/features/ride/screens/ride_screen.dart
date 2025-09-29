import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/model/get_rides_model.dart';
import '../sm/ride_provider.dart';

class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<RideProvider>();

    if (prov.status == RideLoadStatus.loading) {
      return const Scaffold(
        appBar: _AppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (prov.status == RideLoadStatus.error) {
      return Scaffold(
        appBar: const _AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  prov.errorMessage ?? 'Failed to load rides',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: prov.refresh,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final tabs = prov.tabs;
    // rebuild DefaultTabController when tabs change
    return DefaultTabController(
      key: ValueKey(tabs.join(',')),
      length: tabs.length,
      child: Scaffold(
        appBar: const _AppBar(),
        body: Column(
          children: [
            Material(
              color: Colors.white,
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                tabs: [for (final t in tabs) Tab(text: t)],
              ),
            ),
            const Divider(height: 1),
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
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<RideProvider>();
    return AppBar(
      title: Text('My Rides (${prov.total})'),
      actions: [
        IconButton(
          tooltip: 'Refresh',
          onPressed: prov.refresh,
          icon: const Icon(Icons.refresh),
        ),
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
      return const Center(child: Text('No rides yet.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
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

    return InkWell(
      onTap: () {
        // TODO: navigate to details / map preview
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFECECEC)),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              spreadRadius: 0,
              offset: Offset(0, 2),
              color: Color(0x11000000),
            ),
          ],
        ),
        child: Row(
          children: [
            // leading status chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _statusBg(data.status),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                _titleCase(data.status),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _statusFg(data.status),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // pickup → dropoff
                  Row(
                    children: [
                      const Icon(Icons.trip_origin, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          data.pickupAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.flag, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          data.dropoffAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // meta
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        prov.formatWhen(data.requestedAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        prov.formatFare(data.fare), // ₦ no kobo
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  static String _titleCase(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

  Color _statusBg(String s) {
    switch (s.toLowerCase()) {
      case 'accepted':
      case 'ongoing':
        return const Color(0xFFE8F5E9); // green-ish
      case 'pending':
        return const Color(0xFFFFF8E1); // amber-ish
      case 'completed':
        return const Color(0xFFE3F2FD); // blue-ish
      case 'cancelled':
      case 'declined':
        return const Color(0xFFFFEBEE); // red-ish
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
        return const Color(0xFF8D6E63);
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
