import 'package:studentride/core/api/api.dart';
import 'package:studentride/core/helper/enum.dart';

import '../../../../core/utils/logger/local_storage.dart';

abstract class WalletService {
  Future<ApiResponse> getWallet();
  Future<ApiResponse> getTransactions();
  Future<ApiResponse> fundWallet({required int amt});
}

class WalletServiceImpl implements WalletService {
  final apiClient = DioClient();
  final local = LocalStorageImpl();
  @override
  Future<ApiResponse> getWallet() async {
    final response = await apiClient.request(
      path: 'wallet/balance',
      method: MethodType.get,
    );
    return response;
  }

  @override
  Future<ApiResponse> fundWallet({required int amt}) async {
    final response = await apiClient.request(
      path: 'wallet/fundwallet',
      method: MethodType.post,
    );

    return response;
  }

  @override
  Future<ApiResponse> getTransactions() {
    // TODO: implement getTransactions
    throw UnimplementedError();
  }
}
