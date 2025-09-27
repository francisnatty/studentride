import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:studentride/core/utils/logger/debug_logger.dart';
import 'package:studentride/features/auth/data/model/login_response.dart';
import 'package:studentride/features/auth/data/model/reset_password.dart';

import '../../../../core/helper/type_def.dart';
import '../../../../core/utils/logger/local_storage.dart';
import '../model/create_acct_params.dart';
import '../service/auth_service.dart';

abstract class AuthRepo {
  ApiResult<String> createAcct({required RegistrationModel params});
  ApiResult<String> login({required String email, required String password});
  ApiResult<String> verifyOtp({required String email, required String otp});
  ApiResult<String> resendOtp({required String email});
  ApiResult<String> forgotPassword({required String email});
  ApiResult<String> resetPassword({required ResetPasswordResponse payload});
}

class AuthRepoImpl implements AuthRepo {
  final authService = AuthServiceImpl();
  final local = LocalStorageImpl();

  @override
  ApiResult<String> createAcct({required RegistrationModel params}) async {
    final response = await authService.createAcct(params: params);

    if (response.success!) {
      return Right('success');
    } else {
      return Left(response.failure!);
    }
  }

  @override
  ApiResult<String> login({
    required String email,
    required String password,
  }) async {
    final response = await authService.login(email: email, password: password);

    DebugLogger.log('login', response.rawJson);

    if (response.success!) {
      await local.saveLoginResponse(LoginResponse.fromJson(response.rawJson));

      //update FCM TOKEN
      _updateFcmToken();

      return Right('success');
    } else {
      return Left(response.failure!);
    }
  }

  void _updateFcmToken() async {
    try {
      // Get FCM token from Firebase
      final fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken != null && fcmToken.isNotEmpty) {
        DebugLogger.log('FCM Token', fcmToken);

        // Update in backend
        final response = await authService.updateFcmToken(fcm: fcmToken);

        if (response.success!) {
          DebugLogger.log('FCM Update', 'Token updated successfully');
        } else {
          DebugLogger.log(
            'FCM Update Failed',
            response.failure?.message ?? 'Unknown error',
          );
        }
      }
    } catch (e) {
      DebugLogger.log('FCM Error', e.toString());
    }
  }

  @override
  ApiResult<String> resendOtp({required String email}) async {
    final response = await authService.resendOtp(email: email);
    DebugLogger.log('resend otp', response.rawJson);

    if (response.success!) {
      String message = response.rawJson['message'];

      return Right(message);
    } else {
      return left(response.failure!);
    }
  }

  @override
  ApiResult<String> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await authService.verifyOtp(email: email, otp: otp);
    DebugLogger.log('verify otp', response.rawJson);

    if (response.success!) {
      String message = response.rawJson['message'];

      return Right(message);
    } else {
      return left(response.failure!);
    }
  }

  @override
  ApiResult<String> forgotPassword({required String email}) async {
    final response = await authService.forgotPassword(email: email);
    DebugLogger.log('forgot password', response.rawJson);

    if (response.success!) {
      String message = response.rawJson['message'];

      return Right(message);
    } else {
      return left(response.failure!);
    }
  }

  @override
  ApiResult<String> resetPassword({
    required ResetPasswordResponse payload,
  }) async {
    final response = await authService.resetPassword(payload: payload);
    DebugLogger.log('reset password', response.rawJson);

    if (response.success!) {
      String message = response.rawJson['message'];

      return Right(message);
    } else {
      return left(response.failure!);
    }
  }
}
