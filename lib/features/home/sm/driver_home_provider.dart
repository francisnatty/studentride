import 'package:flutter/foundation.dart';
import 'package:studentride/features/home/data/model/get_available_rides.dart';
import 'package:studentride/features/home/data/repo/home_repo.dart';

enum DriverHomeStatus { idle, loading, loaded, error, actionLoading }

class DriverHomeProvider extends ChangeNotifier {
  final HomeRepo _homeRepo;
  DriverHomeStatus status = DriverHomeStatus.idle;
  String? error;
  List<RideData> requests = [];

  DriverHomeProvider(this._homeRepo);

  Future<void> load() async {
    status = DriverHomeStatus.loading;
    error = null;
    notifyListeners();

    final result = await _homeRepo.getAvailableRides();
    result.fold(
      (fail) {
        error = fail.message;
        status = DriverHomeStatus.error;
        notifyListeners();
      },
      (model) {
        requests = model.data;
        status = DriverHomeStatus.loaded;
        notifyListeners();
      },
    );
  }

  Future<bool> accept(String rideId) async {
    status = DriverHomeStatus.actionLoading;
    notifyListeners();
    final res = await _homeRepo.acceptRide(rideId: rideId);
    return res.fold(
      (f) {
        error = f.message;
        status = DriverHomeStatus.loaded;
        notifyListeners();
        return false;
      },
      (msg) {
        // Remove accepted ride from list (optional)
        requests.removeWhere((r) => r.id == rideId);
        status = DriverHomeStatus.loaded;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> reject(String rideId) async {
    status = DriverHomeStatus.actionLoading;
    notifyListeners();
    final res = await _homeRepo.rejectRide(rideId: rideId);
    return res.fold(
      (f) {
        error = f.message;
        status = DriverHomeStatus.loaded;
        notifyListeners();
        return false;
      },
      (msg) {
        requests.removeWhere((r) => r.id == rideId);
        status = DriverHomeStatus.loaded;
        notifyListeners();
        return true;
      },
    );
  }
}
