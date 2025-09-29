// lib/features/profile/data/repository/profile_repo.dart

import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:studentride/core/helper/type_def.dart';
import 'package:studentride/core/utils/logger/debug_logger.dart';
import 'package:studentride/features/profile/data/model/get_profile_model.dart';
import 'package:studentride/features/profile/data/service/profile_service.dart';

import '../../../../core/utils/logger/local_storage.dart';

abstract class ProfileRepo {
  ApiResult<ProfileResponse> getProfile({bool forceRefresh = false});
  Future<void> clearCachedProfile();
}

class ProfileRepoImpl implements ProfileRepo {
  final ProfileServiceImpl profileService;
  final LocalStorage localStorage;

  ProfileRepoImpl({required this.profileService, required this.localStorage});

  @override
  ApiResult<ProfileResponse> getProfile({bool forceRefresh = false}) async {
    try {
      // Try to get cached profile first if not forcing refresh
      if (!forceRefresh) {
        final cachedProfile = await _getCachedProfile();
        if (cachedProfile != null) {
          DebugLogger.log('Profile Repo', 'Returning cached profile');
          return Right(cachedProfile);
        }
      }

      // Fetch from API
      final response = await profileService.getProfile();
      DebugLogger.log('Profile Repo API Response', response.rawJson);

      if (response.success!) {
        // Cache the profile
        await _cacheProfile(response.data!);
        return Right(response.data!);
      } else {
        return Left(response.failure!);
      }
    } catch (e) {
      DebugLogger.log('Profile Repo Exception', e.toString());
      // Try to return cached profile on error
      final cachedProfile = await _getCachedProfile();
      if (cachedProfile != null) {
        DebugLogger.log('Profile Repo', 'Returning cached profile after error');
        return Right(cachedProfile);
      }
      rethrow;
    }
  }

  @override
  Future<void> clearCachedProfile() async {
    await localStorage.storage.delete(key: profileKey);
    DebugLogger.log('Profile Repo', 'Cached profile cleared');
  }

  /// Cache profile to local storage
  Future<void> _cacheProfile(ProfileResponse profile) async {
    try {
      final jsonString = jsonEncode(profile.toJson());
      await localStorage.storage.write(key: profileKey, value: jsonString);
      DebugLogger.log('Profile Repo', 'Profile cached successfully');
    } catch (e) {
      DebugLogger.log('Profile Repo Cache Error', e.toString());
    }
  }

  /// Get cached profile from local storage
  Future<ProfileResponse?> _getCachedProfile() async {
    try {
      final jsonString = await localStorage.storage.read(key: profileKey);
      if (jsonString == null) return null;

      final jsonMap = jsonDecode(jsonString);
      return ProfileResponse.fromJson(jsonMap);
    } catch (e) {
      DebugLogger.log('Profile Repo Get Cache Error', e.toString());
      return null;
    }
  }
}
