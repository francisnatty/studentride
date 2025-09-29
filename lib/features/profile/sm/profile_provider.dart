// lib/features/profile/presentation/provider/profile_provider.dart

import 'package:flutter/material.dart';
import 'package:studentride/core/utils/logger/debug_logger.dart';
import 'package:studentride/features/profile/data/model/get_profile_model.dart';
import 'package:studentride/features/profile/data/repo/profile_repo.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileProvider extends ChangeNotifier {
  final ProfileRepo _profileRepo;

  ProfileProvider(this._profileRepo);

  ProfileResponse? _profileResponse;
  ProfileStatus _status = ProfileStatus.initial;
  String? _errorMessage;

  // Getters
  ProfileResponse? get profileResponse => _profileResponse;
  UserModel? get userModel => _profileResponse?.data?.user;
  ProfileStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == ProfileStatus.loading;
  bool get hasError => _status == ProfileStatus.error;
  bool get hasData => _profileResponse != null;

  // Check if user is a driver
  bool get isDriver => userModel?.role?.toLowerCase() == 'driver';

  bool get isPassenger => userModel?.role?.toLowerCase() == 'passenger';

  Future<void> fetchProfile({bool forceRefresh = false}) async {
    try {
      // If not forcing refresh and we have cached data, use it
      if (!forceRefresh && _profileResponse != null) {
        DebugLogger.log('Profile Provider', 'Using cached profile data');
        return;
      }

      _status = ProfileStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final result = await _profileRepo.getProfile(forceRefresh: forceRefresh);

      result.fold(
        (failure) {
          _status = ProfileStatus.error;
          _errorMessage = failure.message ?? 'Failed to load profile';
          DebugLogger.log('Profile Provider Error', _errorMessage!);
          notifyListeners();
        },
        (response) {
          _profileResponse = response;
          _status = ProfileStatus.success;
          _errorMessage = null;
          DebugLogger.log('Profile Provider', 'Profile loaded successfully');
          notifyListeners();
        },
      );
    } catch (e) {
      _status = ProfileStatus.error;
      _errorMessage = 'An unexpected error occurred: $e';
      DebugLogger.log('Profile Provider Exception', e.toString());
      notifyListeners();
    }
  }

  /// Clear profile data (useful for logout)
  void clearProfile() {
    _profileResponse = null;
    _status = ProfileStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }

  /// Update profile locally (after editing)
  void updateLocalProfile(UserModel updatedUser) {
    if (_profileResponse != null) {
      _profileResponse = ProfileResponse(
        success: _profileResponse!.success,
        data: UserData(user: updatedUser),
      );
      notifyListeners();
    }
  }
}
