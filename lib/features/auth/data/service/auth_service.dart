import 'package:studentride/core/api/api.dart';
import 'package:studentride/core/helper/enum.dart';

import '../model/create_acct_params.dart';
import '../model/reset_password.dart';

abstract class AuthService {
  Future<ApiResponse> createAcct({required RegistrationModel params});
  Future<ApiResponse> login({required String email, required String password});
  Future<ApiResponse> verifyOtp({required String email, required String otp});
  Future<ApiResponse> resendOtp({required String email});
  Future<ApiResponse> updateFcmToken({required String fcm});
  Future<ApiResponse> forgotPassword({required String email});
  Future<ApiResponse> resetPassword({required ResetPasswordResponse payload});
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

  @override
  Future<ApiResponse> updateFcmToken({required String fcm}) async {
    final response = await apiClient.request(
      path: 'auth/fcm-token',
      method: MethodType.put,
      payload: {'fcmToken': fcm},
    );
    return response;
  }

  @override
  Future<ApiResponse> forgotPassword({required String email}) async {
    final response = await apiClient.request(path: 'auth/forgot-password', method: MethodType.post, payload: {
      'email': email
    }  );
  }

  @override
  Future<ApiResponse> resetPassword({required ResetPasswordResponse payload}) async{
    final response= await apiClient.request(path: '', method: method)

   
  }
}
