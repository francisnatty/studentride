import 'package:studentride/core/api/api.dart';
import 'package:studentride/core/helper/enum.dart';

import '../model/create_acct_params.dart';

abstract class AuthService {
  Future<ApiResponse> createAcct({required RegistrationModel params});
  Future<ApiResponse> login({required String email, required String password});
  Future<ApiResponse> verifyOtp({required String email, required String otp});
  Future<ApiResponse> resendOtp({required String email});
}

class AuthServiceImpl implements AuthService {
  final apiClient = DioClient();
  @override
  Future<ApiResponse> createAcct({required RegistrationModel params}) async {
    final response = await apiClient.request(
      path: 'auth/register',
      method: MethodType.post,
      payload: params.toJson(),
    );
    return response;
  }

  @override
  Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    final data = {'email': email, 'password': password};

    final response = await apiClient.request(
      path: 'auth/login',
      method: MethodType.post,
      payload: data,
    );

    return response;
  }

  @override
  Future<ApiResponse> resendOtp({required String email}) async {
    final response = await apiClient.request(
      path: 'auth/resend-otp',
      method: MethodType.post,
      payload: {'email': email},
    );

    return response;
  }

  @override
  Future<ApiResponse> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await apiClient.request(
      path: 'auth/verify-email-otp',
      method: MethodType.post,
      payload: {'email': email, 'otp': otp},
    );

    return response;
  }
}
