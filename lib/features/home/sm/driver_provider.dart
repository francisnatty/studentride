// lib/features/home/sm/drivers_provider.dart
import 'package:flutter/foundation.dart';
import '../data/model/get_drivers.dart';
import '../data/repo/driver_repo.dart';

enum DriversStatus { idle, loading, error }

class DriversProvider extends ChangeNotifier {
  final DriverRepo repo;
  DriversProvider({required this.repo});

  DriversStatus status = DriversStatus.idle;
  List<Driver> drivers = [];
  String? error;

  Future<void> fetchDrivers() async {
    status = DriversStatus.loading;
    notifyListeners();

    final result = await repo.getDrivers();
    result.fold(
      (failure) {
        error = failure.toString();
        status = DriversStatus.error;
        notifyListeners();
      },
      (response) {
        drivers = response.drivers;
        status = DriversStatus.idle;
        notifyListeners();
      },
    );
  }
}
