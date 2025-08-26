import 'package:studentride/core/helper/enum.dart';
import 'package:studentride/core/utils/logger/local_storage.dart';
import 'package:studentride/features/home/data/model/request_ride_response.dart';

import '../../../../core/api/api.dart';
import '../model/ride_request_params.dart';

abstract class HomeService {
  Future<ApiResponse<RideResponse>> requestRide({
    required RideRequestParams params,
  });
  Future<ApiResponse> farePreview({required RideRequestParams params});
}

class HomeServiceImpl implements HomeService {
  final apiClient = DioClient();
  final local = LocalStorageImpl();
  @override
  Future<ApiResponse<RideResponse>> requestRide({
    required RideRequestParams params,
  }) async {
    final login = await local.getLoginResponse();
    apiClient.setToken(login!.data.token);
    final response = await apiClient.request(
      path: 'rides/request',
      method: MethodType.post,
      payload: params.toJson(),
      fromJsonT: (json) => RideResponse.fromJson(json),
    );

    return response;
  }

  @override
  Future<ApiResponse> farePreview({required RideRequestParams params}) async {
    final login = await local.getLoginResponse();
    apiClient.setToken(login!.data.token);

    final response = await apiClient.request(
      path: 'rides/preview-fare',
      method: MethodType.get,
      queryParameters: {
        'pickupLat': params.pickupLocation.coordinates[0],
        'pickupLng': params.pickupLocation.coordinates[1],
        'dropoffLat': params.dropoffLocation.coordinates[0],
        'dropoffLng': params.dropoffLocation.coordinates[1],
      },
    );

    return response;
  }
}
