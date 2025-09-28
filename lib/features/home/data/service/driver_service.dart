import 'package:studentride/core/api/response/api_response.dart';
import 'package:studentride/core/helper/enum.dart';
import 'package:studentride/core/utils/logger/local_storage.dart';

import '../../../../core/api/client/dio_client.dart';

abstract class DriverService {
  Future<ApiResponse> toggleAvailiability({required bool status});
  Future<ApiResponse> getDriverAvailability();
}

class DriverServiceImpl extends DriverService {
  final apiClient = DioClient();
  final local = LocalStorageImpl();

  @override
  Future<ApiResponse> toggleAvailiability({required bool status}) async {
    final login = await local.getLoginResponse();
    apiClient.setToken(login!.data.token);

    final response = await apiClient.request(
      path: 'drivers/toggle-availability',
      payload: {'online': status},
      method: MethodType.put,
    );

    return response;
  }

  @override
  Future<ApiResponse> getDriverAvailability() async {
    final login = await local.getLoginResponse();
    apiClient.setToken(login!.data.token);
    final response = await apiClient.request(
      path: 'drivers/availability',
      method: MethodType.get,
    );

    return response;
  }
}
