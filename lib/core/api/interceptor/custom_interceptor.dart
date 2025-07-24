import 'package:dio/dio.dart';
import '../../utils/logger/local_storage.dart';

class CustomInterceptor extends Interceptor {
  final Dio dio;

  CustomInterceptor({required this.dio});

  LocalStorage localStorage = LocalStorageImpl();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      //logout

      // if (navigatorKey.currentContext != null) {
      //   //showCustomDialog(context: navigatorKey.currentContext!, child: Container(child: Container(),));
      //   navigatorKey.currentState?.context.read<AuthStatusCubit>().logoutUser();
      //   navigatorKey.currentState?.pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => const OnboardingNew()),
      //     (Route<dynamic> route) => false,
      //   );
      // }

      // final response = await _refreshTokenRequest();
      // if (response?.statusCode == 200) {
      //   var newAccessToken = response!.data['token'];
      //   DebugLogger.log('PRINT ACCESSTOKEN', newAccessToken);

      //   final options = err.requestOptions;
      //   options.headers['Authorization'] = 'Bearer $newAccessToken';
      //   final retryResponse = await dio.request(options.path,
      //       options: Options(
      //         method: options.method,
      //         headers: options.headers,
      //       ));

      //   return handler.resolve(retryResponse);
      // }
    }
    handler.next(err);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  //   Future<Response?> _refreshTokenRequest() async {
  //     final refreshToken = await localStorage.getRefreshToke();

  //     try {
  //       final response = await dio.post(
  //           'https://sina-62043178b88f.herokuapp.com/api/refresh-token',
  //           data: {'refreshToken': refreshToken});
  //       if (response is Map) {
  //         var ii = response.data['message'];
  //         DebugLogger.log('response', ii);
  //       }
  //       DebugLogger.log('REFRESH TOKEN ERROR', response);
  //       return response;
  //     } catch (e) {
  //       DebugLogger.log('REFRESH TOKEN ERROR', e.toString());
  //       return null;
  //     }
  //   }
  // }
}
