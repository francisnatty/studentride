import 'package:dartz/dartz.dart';
import 'package:studentride/core/helper/type_def.dart';
import 'package:studentride/core/utils/logger/debug_logger.dart';
import 'package:studentride/features/home/data/service/home_service.dart';
import '../model/get_available_rides.dart';
import '../model/request_ride_response.dart';
import '../model/ride_request_params.dart';

abstract class HomeRepo {
  ApiResult<RideResponse> requestRide({required RideRequestParams params});
  ApiResult<Map<String, dynamic>> farePreview({
    required RideRequestParams params,
  });

  ApiResult<String> acceptRide({required String rideId});
  ApiResult<String> rejectRide({required String rideId});
  ApiResult<GetAvailableRideModel> getAvailableRides();
}

class HomeRepoImpl implements HomeRepo {
  final homeService = HomeServiceImpl();
  @override
  ApiResult<Map<String, dynamic>> farePreview({
    required RideRequestParams params,
  }) async {
    final response = await homeService.farePreview(params: params);
    if (response.success!) {
      DebugLogger.log('fare', response.rawJson);
      final data = {
        'fare': response.rawJson['data']['estimatedFare'],
        'distance': response.rawJson['data']['distanceKM'],
      };

      print(data);

      return Right(data);
    } else {
      return Left(response.failure!);
    }
  }

  @override
  ApiResult<RideResponse> requestRide({
    required RideRequestParams params,
  }) async {
    final response = await homeService.requestRide(params: params);
    if (response.success!) {
      return Right(response.data!);
    } else {
      return Left(response.failure!);
    }
  }

  @override
  ApiResult<String> acceptRide({required String rideId}) async {
    final response = await homeService.acceptRide(rideId: rideId);
    DebugLogger.log('accept ride', response.rawJson);
    if (response.success!) {
      return Right(response.rawJson['message']);
    } else {
      return Left(response.failure!);
    }
  }

  @override
  ApiResult<String> rejectRide({required String rideId}) async {
    final response = await homeService.acceptRide(rideId: rideId);
    DebugLogger.log('decline ride', response.rawJson);
    if (response.success!) {
      return Right(response.rawJson['message']);
    } else {
      return Left(response.failure!);
    }
  }

  @override
  ApiResult<GetAvailableRideModel> getAvailableRides() async {
    final response = await homeService.getAvailableRides();
    DebugLogger.log('get available rides', response.rawJson);
    if (response.success!) {
      return Right(response.data!);
    } else {
      return Left(response.failure!);
    }
  }
}
