import 'package:dio/dio.dart';

import '../../helper/enum.dart';
import '../../utils/logger/debug_logger.dart';
import '../api.dart';

class DioClient implements ApiClient {
  late Dio _client;

  DioClient() {
    _client = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:5000/api/',
        //  baseUrl: 'http://192.168.137.191/api/',

        //   baseUrl: 'http://10.0.2.2:5000/api/',
        contentType: Headers.formUrlEncodedContentType,
        headers: {'X-Requested-With': 'XMLHttpRequest'},
        connectTimeout: Duration(seconds: 15),
        receiveTimeout: Duration(seconds: 15),
      ),
    );
  }

  @override
  void removeToken() {
    _client.options.headers.remove('Authorization');
  }

  @override
  void setToken(String token) {
    _client.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  Future<ApiResponse<T>> request<T>({
    required String path,
    required MethodType method,
    Map<String, dynamic>? payload,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? rawData,
    Map<String, String>? headers,
    T Function(Map<String, dynamic> json)? fromJsonT,
    bool? showLoader,
  }) async {
    ApiResponse<T> apiResponse;
    Response response;

    try {
      // Create options with custom headers if provided
      Options? options;
      if (headers != null) {
        options = Options(headers: headers);
      }

      switch (method) {
        case MethodType.get:
          response = await _client.get(
            path,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case MethodType.post:
          response = await _client.post(path, data: payload, options: options);
          break;
        case MethodType.put:
          response = await _client.put(path, data: payload, options: options);
          break;
        case MethodType.delete:
          response = await _client.delete(path, options: options);
          break;
        case MethodType.patch:
          response = await _client.patch(path, data: payload, options: options);
          break;
      }

      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      apiResponse = ApiResponse(
        data: fromJsonT?.call(response.data),
        rawJson: response.data,
        statusCode: response.statusCode.toString(),
        success:
            response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300,
      );

      return apiResponse;
    } catch (e) {
      DebugLogger.log('DIO ERROR', e.toString());
      var err = CustomHandlerObject.getError(error: e);
      apiResponse = ApiResponse(success: false, failure: err);
      return apiResponse;
    }
  }

  // File upload method with proper configuration
  // File upload method with proper configuration
  Future<ApiResponse<T>> uploadFile<T>({
    required String path,
    required FormData formData,
    Map<String, String>? headers,
    T Function(Map<String, dynamic> json)? fromJsonT,
    ProgressCallback? onSendProgress,
  }) async {
    ApiResponse<T> apiResponse;
    Response response;

    try {
      // Merge headers with existing client headers (including Authorization)
      final mergedHeaders = {
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        // Include existing headers from client (like Authorization)
        ..._client.options.headers.cast<String, String>(),
        // Override with any custom headers
        ...?headers,
      };

      final options = Options(
        headers: mergedHeaders,
        // Remove content-type to let Dio set it automatically for multipart
        contentType: null,
      );

      response = await _client.post(
        path,
        data: formData,
        options: options,
        onSendProgress: onSendProgress,
      );

      print('Upload Status Code: ${response.statusCode}');
      print('Upload Response Data: ${response.data}');

      apiResponse = ApiResponse(
        data: fromJsonT?.call(response.data),
        rawJson: response.data,
        statusCode: response.statusCode.toString(),
        success:
            response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300,
      );

      return apiResponse;
    } catch (e) {
      DebugLogger.log('FILE UPLOAD ERROR', e.toString());
      var err = CustomHandlerObject.getError(error: e);
      apiResponse = ApiResponse(success: false, failure: err);
      return apiResponse;
    }
  }

  @override
  String handleException(Exception exception) {
    throw UnimplementedError();
  }
}
