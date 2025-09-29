import 'package:studentride/core/api/api.dart';
import 'package:studentride/core/helper/enum.dart';
import 'package:studentride/features/profile/data/model/get_profile_model.dart';

import '../../../../core/utils/logger/local_storage.dart';

abstract class ProfileService {
  Future<ApiResponse<ProfileResponse>> getProfile();
}

class ProfileServiceImpl implements ProfileService {
  final apiClient = DioClient();
  final local = LocalStorageImpl();

  @override
  Future<ApiResponse<ProfileResponse>> getProfile() async {
    final login = await local.getLoginResponse();
    apiClient.setToken(login!.data.token);

    final response = await apiClient.request(
      path: 'auth/profile',
      method: MethodType.get,
      fromJsonT: (json) => ProfileResponse.fromJson(json),
    );

    return response;
  }
}
