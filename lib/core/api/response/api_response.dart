// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../api.dart';

class ApiResponse<T> {
  T? data;
  dynamic rawJson;
  String? statusCode;
  bool? success;
  String? statusMessage;
  Failure? failure;

  ApiResponse({
    this.data,
    this.statusCode,
    this.success,
    this.statusMessage,
    this.rawJson,
    this.failure,
  });

  @override
  String toString() {
    return 'ApiResponse(data: $data, rawJson: $rawJson, statusCode: $statusCode, success: $success, statusMessage: $statusMessage, failure: $failure)';
  }

  // factory ApiResponse.fromError(String message, String statusCode) {
  //   return ApiResponse(
  //     success: false,
  //     statusCode: statusCode,
  //     statusMessage: message,
  //   );
  // }
}
