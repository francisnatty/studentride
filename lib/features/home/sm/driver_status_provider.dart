import 'package:flutter/foundation.dart';
import 'package:studentride/features/home/data/repo/driver_repo.dart';

enum DriverAvailabilityStatus { idle, loading, actionLoading, error }

class DriverAvailabilityProvider extends ChangeNotifier {
  final DriverRepo repo;

  DriverAvailabilityProvider(this.repo);

  DriverAvailabilityStatus status = DriverAvailabilityStatus.idle;
  bool? isOnline; // null while loading first time
  String? error;

  Future<void> load() async {
    status = DriverAvailabilityStatus.loading;
    notifyListeners();

    final result = await repo.getDriverAvailability();
    result.fold(
      (failure) {
        error = failure.toString();
        status = DriverAvailabilityStatus.error;
        notifyListeners();
      },
      (value) {
        isOnline = value;
        error = null;
        status = DriverAvailabilityStatus.idle;
        notifyListeners();
      },
    );
  }

  /// Returns true if toggling succeeded (and updates [isOnline])
  Future<bool> toggle(bool value) async {
    status = DriverAvailabilityStatus.actionLoading;
    notifyListeners();

    final result = await repo.toggleAvailiability(status: value);
    return result.fold(
      (failure) {
        error = failure.toString();
        status = DriverAvailabilityStatus.idle;
        notifyListeners();
        return false;
      },
      (_) {
        isOnline = value;
        error = null;
        status = DriverAvailabilityStatus.idle;
        notifyListeners();
        return true;
      },
    );
  }
}
