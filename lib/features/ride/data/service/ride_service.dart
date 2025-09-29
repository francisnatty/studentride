import 'package:studentride/core/helper/enum.dart';

import '../../../../core/api/api.dart';
import '../../../../core/utils/logger/debug_logger.dart';
import '../../../../core/utils/logger/local_storage.dart';
import '../model/get_rides_model.dart';

abstract class RideService {
  Future<ApiResponse<GetAllRideModel>> getAllRides();
}

class RideServiceImpl implements RideService {
  final apiClient = DioClient();
  final local = LocalStorageImpl();
  @override
  Future<ApiResponse<GetAllRideModel>> getAllRides() async {
    final login = await local.getLoginResponse();
    apiClient.setToken(login!.data.token);

    final response = await apiClient.request(
      path: 'rides/user/all',
      method: MethodType.get,
      fromJsonT: (json) => GetAllRideModel.fromMap(json),
    );

    DebugLogger.log('get all rides service', response.rawJson);

    return response;
  }
}
