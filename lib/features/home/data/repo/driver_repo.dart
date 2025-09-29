import 'package:dartz/dartz.dart';
import 'package:studentride/core/utils/logger/debug_logger.dart';
import 'package:studentride/features/home/data/service/driver_service.dart';

import '../../../../core/helper/type_def.dart';

abstract class DriverRepo {
  ApiResult<String> toggleAvailiability({required bool status});
  ApiResult<bool> getDriverAvailability();
}

class DriverRepoImpl implements DriverRepo {
  final driverService = DriverServiceImpl();
  @override
  ApiResult<bool> getDriverAvailability() async {
    final response = await driverService.getDriverAvailability();
    DebugLogger.log('get availability', response.rawJson);
    if (response.success!) {
      final isOnline = response.rawJson['isOnline'];

      return Right(isOnline);
    } else {
      return Left(response.failure!);
    }
  }

  @override
  ApiResult<String> toggleAvailiability({required bool status}) async {
    final response = await driverService.toggleAvailiability(status: status);
    DebugLogger.log('toogle availability', response.rawJson);
    if (response.success!) {
      final message = response.rawJson['message'];
      return Right(message);
    } else {
      return Left(response.failure!);
    }
  }
}
