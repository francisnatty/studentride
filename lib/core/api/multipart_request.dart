// import 'package:dio/dio.dart';
// import 'package:foodlify_hub/core/storage/local_storage.dart';

// import 'response/api_response.dart';
// import 'error/custom_error.dart';

// class ApiService {
//   final Dio dio;
//   LocalStorage localStorage;

//   ApiService({required this.dio, required this.localStorage}) {
//     dio.options.headers['Content-Type'] = 'multipart/form-data';
//   }

//   Future<String?> _getToken() async {
//     return await localStorage.getAcessToken();
//   }

//   Future<ApiResponse> _makeMultipartRequest({
//     required String url,
//     required Map<String, dynamic> payload,
//   }) async {
//     String? token = await _getToken();

//     dio.options.headers['Authorization'] = 'Bearer $token';

//     try {
//       final response = await dio.post(url, data: FormData.fromMap(payload));
//       return ApiResponse(
//         data: response.data,
//         statusCode: response.statusCode.toString(),
//         success: true,
//       );
//     } catch (e) {
//       return ApiResponse(
//         success: false,
//         statusMessage: CustomHandler.getError(error: e),
//       );
//     }
//   }

// //   Future<ApiResponse> addFood({
// //     required String title,
// //     required String category,
// //     required int price,
// //     required String description,
// //     required File image,
// //     required String collection,
// //   }) async {
// //     String addFoodUrl = 'http://52.22.165.202:8090/api/v1/restaurant/add_food';

// //     final Map<String, dynamic> payload = {
// //       'title': title,
// //       'category': category,
// //       'price': price,
// //       'description': description,
// //       'image': await MultipartFile.fromFile(image.path,
// //           filename: image.path.split('/').last),
// //       'collection': collection,
// //     };

// //     return await _makeMultipartRequest(url: addFoodUrl, payload: payload);
// //   }
// }



// // class LocalStorage {
// //   Future<String?> getAcessToken() async {
// //     // Implement token storage and retrieval logic here
// //     return 'your_access_token';
// //   }
// // }

// // final localStorage = LocalStorage();
// // final apiService = ApiService(dio: Dio());


