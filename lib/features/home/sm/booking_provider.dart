// lib/providers/booking_provider.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/widget/snackbar_helper.dart';
import '../data/model/request_ride_response.dart';
import '../data/model/ride_request_params.dart';
import '../data/repo/home_repo.dart';

enum BookingState {
  initial,
  selectingDestination,
  loadingFarePreview,
  farePreviewLoaded,
  requestingRide,
  rideRequested,
  error,
}

class BookingProvider with ChangeNotifier {
  final HomeRepo _homeRepo = HomeRepoImpl();

  BookingState _state = BookingState.initial;
  String? _pickupLocation;
  String? _destinationLocation;
  LatLng? _pickupCoordinates;
  LatLng? _destinationCoordinates;
  Map<String, dynamic>? _farePreview;
  String? _errorMessage;
  RideResponse? _rideResponse;

  // Getters
  BookingState get state => _state;
  String? get pickupLocation => _pickupLocation;
  String? get destinationLocation => _destinationLocation;
  LatLng? get pickupCoordinates => _pickupCoordinates;
  LatLng? get destinationCoordinates => _destinationCoordinates;
  Map<String, dynamic>? get farePreview => _farePreview;
  String? get errorMessage => _errorMessage;
  RideResponse? get rideResponse => _rideResponse;

  // Popular pickup locations for FUTMINNA
  final List<Map<String, dynamic>> _popularPickupLocations = [
    {'name': 'Campus', 'coordinates': LatLng(9.6485, 6.4477)},
    {'name': 'Campus gate', 'coordinates': LatLng(9.6460, 6.4440)},
    {'name': 'Library', 'coordinates': LatLng(9.6475, 6.4485)},
    {'name': 'Alex Hostel', 'coordinates': LatLng(9.6530, 6.4430)},
  ];

  List<Map<String, dynamic>> get popularPickupLocations =>
      _popularPickupLocations;

  void setPickupLocation(String location, LatLng coordinates) {
    _pickupLocation = location;
    _pickupCoordinates = coordinates;
    notifyListeners();
  }

  void setDestinationLocation(String location, LatLng coordinates) {
    _destinationLocation = location;
    _destinationCoordinates = coordinates;
    notifyListeners();
  }

  void setDestinationFromMap(LatLng coordinates) {
    _destinationCoordinates = coordinates;
    _destinationLocation = "Selected Location";
    notifyListeners();
  }

  Future<void> getFarePreview() async {
    if (_pickupCoordinates == null || _destinationCoordinates == null) {
      _setError("Please select both pickup and destination locations");
      return;
    }

    _setState(BookingState.loadingFarePreview);

    final params = RideRequestParams(
      pickupLocation: RLocation(
        type: "Point",
        coordinates: [
          _pickupCoordinates!.longitude,
          _pickupCoordinates!.latitude,
        ],
      ),
      dropoffLocation: RLocation(
        type: "Point",
        coordinates: [
          _destinationCoordinates!.longitude,
          _destinationCoordinates!.latitude,
        ],
      ),
      fare: 0, // Will be calculated by backend
    );

    final result = await _homeRepo.farePreview(params: params);

    result.fold(
      (failure) {
        _setError(failure.message);
      },
      (data) {
        _farePreview = data;
        _setState(BookingState.farePreviewLoaded);
      },
    );
  }

  Future<void> requestRide({required BuildContext context}) async {
    if (_farePreview == null ||
        _pickupCoordinates == null ||
        _destinationCoordinates == null) {
      _setError("Missing required information for ride request");
      return;
    }

    _setState(BookingState.requestingRide);

    final params = RideRequestParams(
      pickupLocation: RLocation(
        type: "Point",
        coordinates: [
          _pickupCoordinates!.longitude,
          _pickupCoordinates!.latitude,
        ],
      ),
      dropoffLocation: RLocation(
        type: "Point",
        coordinates: [
          _destinationCoordinates!.longitude,
          _destinationCoordinates!.latitude,
        ],
      ),
      fare: (_farePreview!['fare'] as num).toDouble(),
    );

    final result = await _homeRepo.requestRide(params: params);

    result.fold(
      (failure) {
        _setError(failure.message);
      },
      (response) {
        _rideResponse = response;
        _setState(BookingState.rideRequested);
        Navigator.pop(context);
        SnackBarHelper.showSuccess(context, response.message);
      },
    );
  }

  void reset() {
    _state = BookingState.initial;
    _pickupLocation = null;
    _destinationLocation = null;
    _pickupCoordinates = null;
    _destinationCoordinates = null;
    _farePreview = null;
    _errorMessage = null;
    _rideResponse = null;
    notifyListeners();
  }

  void _setState(BookingState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _setState(BookingState.error);
  }
}
