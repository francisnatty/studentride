import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentride/core/widget/snackbar_helper.dart';
import 'package:studentride/features/home/sm/driver_status_provider.dart';

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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Status',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
    );
  }
}
