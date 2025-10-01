import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dartz/dartz.dart';

import '../data/model/get_rides_model.dart';
import '../data/repo/ride_repo.dart';
// <- GetAllRideModel, RideModel

enum RideLoadStatus { idle, loading, error }

class RideProvider extends ChangeNotifier {
  final RideRepo repo;
  RideProvider(this.repo);

  RideLoadStatus status = RideLoadStatus.idle;
  String? errorMessage;

  GetAllRideModel? _response;
  List<RideModel> get rides => _response?.rides ?? [];
  int get total => _response?.total ?? 0;

  /// Tabs: 'All' + discovered statuses (sorted by our preferred order)
  List<String> get tabs {
    final set = <String>{};
    for (final r in rides) {
      if ((r.status).trim().isNotEmpty) set.add(r.status.toLowerCase());
    }
    final ordered = _sortStatuses(set.toList());
    return ['All', ...ordered.map(_titleCase)];
  }

  /// Map per status (lowercase key) -> list of rides
  Map<String, List<RideModel>> get groupedByStatus {
    final map = <String, List<RideModel>>{};
    for (final r in rides) {
      final key = r.status.toLowerCase();
      map.putIfAbsent(key, () => []).add(r);
    }
    // sort each group by most recent requestedAt
    for (final key in map.keys) {
      map[key]!.sort((a, b) => b.requestedAt.compareTo(a.requestedAt));
    }
    return map;
  }

  Future<void> load() async {
    status = RideLoadStatus.loading;
    errorMessage = null;
    notifyListeners();

    final result = await repo.getAllRides();
    result.fold(
      (failure) {
        status = RideLoadStatus.error;
        errorMessage = failure.message ?? failure.toString();
        notifyListeners();
      },
      (data) {
        _response = data;
        status = RideLoadStatus.idle;
        notifyListeners();
      },
    );
  }

  Future<void> commpleteRide({
    required String rideId,
    required BuildContext context,
  }) async {}

  Future<void> refresh() => load();

  /// Returns list for a given tab label ("All" or a status title-cased)
  List<RideModel> byTab(String tabLabel) {
    if (tabLabel == 'All') {
      final all = [...rides];
      all.sort((a, b) => b.requestedAt.compareTo(a.requestedAt));
      return all;
    }
    final key = tabLabel.toLowerCase();
    return groupedByStatus[key] ?? const [];
  }

  /// Preferred status order if present
  static const _desiredOrder = [
    'accepted',
    'pending',
    'ongoing',
    'completed',
    'cancelled',
    'declined',
    'expired',
  ];

  List<String> _sortStatuses(List<String> statuses) {
    final known =
        statuses.where((s) => _desiredOrder.contains(s)).toList()..sort(
          (a, b) =>
              _desiredOrder.indexOf(a).compareTo(_desiredOrder.indexOf(b)),
        );
    final unknown =
        statuses.where((s) => !_desiredOrder.contains(s)).toList()..sort();
    return [...known, ...unknown];
  }

  String _titleCase(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

  /// Helper for currency (no kobo)
  String formatFare(int fare) {
    final nf = NumberFormat.currency(symbol: '₦', decimalDigits: 0);
    return nf.format(fare);
  }

  String formatWhen(DateTime dt) {
    final df = DateFormat('MMM d, HH:mm');
    return df.format(dt);
  }
}
