import 'package:dio/dio.dart';

import 'api_failure.dart';

class CustomError {
  final String? message;
  CustomError({required this.message});

  factory CustomError.fromJson(Map<dynamic, dynamic> data) {
    return CustomError(message: data['message']);
  }
}

// class CustomHandler {
//   static String getError({required Object error}) {
//     if (error is DioException) {
//       // print(error.type);
//       // print(error.response!.realUri);
//       if (error.response != null && error.response?.data is Map) {
//         var err = CustomError.fromJson(error.response?.data);
//         return err.message ?? 'Something went wrong';
//       } else {
//         if (error.type == DioExceptionType.connectionError) {
//           return 'Check your internet connection';
//         } else if (error.type == DioExceptionType.connectionTimeout ||
//             error.type == DioExceptionType.sendTimeout ||
//             error.type == DioExceptionType.receiveTimeout) {
//           return 'Request took too long';
//         } else if (error.type == DioExceptionType.cancel) {
//           return 'Request was cancelled';
//         } else {
//           return 'An unexpected error occurred';
//         }
//       }
//     }
//     return 'Something went wrong';
//   }
//}

// class CustomHandlerObject {
//   static Failure getError({required Object error}) {
//     if (error is DioException) {
//       print(error.response!.statusCode);
//       if (error.response != null && error.response?.data is Map) {
//         var err = CustomError.fromJson(error.response?.data);

//         return InputFailure(message: err.message);
//       } else {
//         if (error.type == DioExceptionType.connectionError) {
//           return NetworkFailure();
//         } else if (error.type == DioExceptionType.connectionTimeout ||
//             error.type == DioExceptionType.sendTimeout ||
//             error.type == DioExceptionType.receiveTimeout) {
//           return TimeoutFailure();
//         } else if (error.type == DioExceptionType.cancel) {
//           return TimeoutFailure();
//         } else {
//           return UnknownFailure();
//         }
//       }
//     }
//     return UnknownFailure();
//   }
// }

class CustomHandlerObject {
  static Failure getError({required Object error}) {
    try {
      if (error is DioException) {
        print(error.response?.statusCode);
        // print(error.response)
        print(error.requestOptions.path);
        if (error.response != null) {
          var responseData = error.response?.data;

          // Check if responseData is a Map as expected
          if (responseData is Map) {
            var err = CustomError.fromJson(responseData);
            return InputFailure(message: err.message);
          } else {
            // Handle unexpected data type in response
            // print("Unexpected data type: ${responseData.runtimeType}");
            return UnknownFailure();
          }
        } else {
          if (error.type == DioExceptionType.connectionError) {
            return NetworkFailure();
          } else if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            return TimeoutFailure();
          } else if (error.type == DioExceptionType.cancel) {
            return TimeoutFailure();
          } else {
            return UnknownFailure();
          }
        }
      }
    } catch (e) {
      // print("Error during error handling: $e");
      return UnknownFailure();
    }

    return UnknownFailure();
  }
}
