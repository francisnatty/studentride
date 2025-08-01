import 'package:dartz/dartz.dart';
import 'package:studentride/core/utils/logger/debug_logger.dart';

import '../../../../core/helper/type_def.dart';
import '../model/create_acct_params.dart';
import '../service/auth_service.dart';

abstract class AuthRepo {
  ApiResult<String> createAcct({required RegistrationModel params});
  ApiResult<String> login({required String email, required String password});
  ApiResult<String> verifyOtp({required String email, required String otp});
  ApiResult<String> resendOtp({required String email});
}

class AuthRepoImpl implements AuthRepo {
  final authService = AuthServiceImpl();

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
      return Right('success');
    } else {
      return Left(response.failure!);
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
}
