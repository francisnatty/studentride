import 'package:studentride/core/api/api.dart';
import 'package:studentride/core/helper/enum.dart';

import '../model/create_acct_params.dart';

abstract class AuthService {
  Future<ApiResponse> createAcct({required RegistrationModel params});
  Future<ApiResponse> login({required String email, required String password});
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
}
