import 'package:dartz/dartz.dart';

import '../api/error/api_failure.dart';

typedef ApiResult<T> = Future<Either<Failure, T>>;
