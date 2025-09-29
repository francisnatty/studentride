import 'package:dartz/dartz.dart';
import 'package:studentride/core/utils/logger/debug_logger.dart';
import 'package:studentride/features/ride/data/service/ride_service.dart';
import '../../../../core/helper/type_def.dart';
import '../model/get_rides_model.dart';

abstract class RideRepo {
  ApiResult<GetAllRideModel> getAllRides();
}

class RideRepoImpl implements RideRepo {
  final rideService = RideServiceImpl();
  @override
  ApiResult<GetAllRideModel> getAllRides() async {
    final response = await rideService.getAllRides();
    DebugLogger.log('get all rides', response.rawJson);
    if (response.success!) {
      return Right(response.data!);
    } else {
      return Left(response.failure!);
    }
  }
}
