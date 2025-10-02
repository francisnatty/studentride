import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studentride/core/widget/snackbar_helper.dart';
import 'package:studentride/features/home/sm/driver_status_provider.dart';

import '../../data/model/get_available_rides.dart';
import '../../sm/driver_home_provider.dart';
import '../driver_map_screen.dart';

class DriverStatusToggle extends StatefulWidget {
  const DriverStatusToggle({super.key});

  @override
  State<DriverStatusToggle> createState() => _DriverStatusToggleState();
}

class _DriverStatusToggleState extends State<DriverStatusToggle> {
  @override
  void initState() {
    super.initState();
    // Load availability when this widget appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DriverAvailabilityProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<DriverAvailabilityProvider>();
    final busy =
        prov.status == DriverAvailabilityStatus.loading ||
        prov.status == DriverAvailabilityStatus.actionLoading;

    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Status',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          CupertinoSwitch(
            value: prov.isOnline ?? false, // default false until loaded
            activeTrackColor: Colors.green,
            inactiveTrackColor: Colors.orange,
            onChanged:
                busy
                    ? null
                    : (bool value) async {
                      final ok = await context
                          .read<DriverAvailabilityProvider>()
                          .toggle(value);
                      if (!mounted) return;
                      if (ok) {
                        if (value) {
                          if (!mounted) return;
                          SnackBarHelper.showSuccess(
                            context,
                            'You are now ONLINE and available for rides',
                          );
                        } else {
                          SnackBarHelper.showWarning(
                            context,
                            'You are now OFFLINE and unavailable for rides',
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              prov.error ?? 'Failed to update status',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
          ),
        ],
      ),
    );
  }
}

class ImprovedDriverStatusToggle extends StatelessWidget {
  const ImprovedDriverStatusToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<DriverAvailabilityProvider>();
    final busy =
        prov.status == DriverAvailabilityStatus.loading ||
        prov.status == DriverAvailabilityStatus.actionLoading;
    final isOnline = prov.isOnline ?? false;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isOnline
                  ? [Colors.green.shade50, Colors.green.shade100]
                  : [Colors.orange.shade50, Colors.orange.shade100],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isOnline ? Colors.green : Colors.orange).withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isOnline ? Icons.toggle_on : Icons.toggle_off,
              color: isOnline ? Colors.green : Colors.orange,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Availability Status',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isOnline ? 'Online' : 'Offline',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color:
                        isOnline
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isOnline,
            activeColor: Colors.green,
            inactiveThumbColor: Colors.orange,
            inactiveTrackColor: Colors.orange.shade200,
            onChanged:
                busy
                    ? null
                    : (value) async {
                      final ok = await context
                          .read<DriverAvailabilityProvider>()
                          .toggle(value);
                      if (!context.mounted) return;
                      if (ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              value
                                  ? 'You are now ONLINE and available for rides'
                                  : 'You are now OFFLINE and unavailable for rides',
                            ),
                            backgroundColor:
                                value ? Colors.green : Colors.orange,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              prov.error ?? 'Failed to update status',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
          ),
        ],
      ),
    );
  }
}
