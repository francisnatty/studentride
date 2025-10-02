import 'package:studentride/core/api/api.dart';
import 'package:studentride/core/helper/enum.dart';
import 'package:studentride/features/wallet/data/model/get_transaction_model.dart';

import '../../../../core/utils/logger/local_storage.dart';

abstract class WalletService {
  Future<ApiResponse> getWallet();
  Future<ApiResponse<WalletTransaction>> getTransactions();
  Future<ApiResponse> fundWallet({required int amt});
  Future<ApiResponse> withdrawMoney({required int amt});
}

class WalletServiceImpl implements WalletService {
  final apiClient = DioClient();
  final local = LocalStorageImpl();
  @override
  Future<ApiResponse> getWallet() async {
    final login = await local.getLoginResponse();
    apiClient.setToken(login!.data.token);
    final response = await apiClient.request(
      path: 'wallet/balance',
      method: MethodType.get,
    );
    return response;
  }

  @override
  Future<ApiResponse> fundWallet({required int amt}) async {
    final login = await local.getLoginResponse();
    apiClient.setToken(login!.data.token);
    final response = await apiClient.request(
      path: 'wallet/fundwallet',
      method: MethodType.post,
    );

    return response;
  }

  @override
  Future<ApiResponse<WalletTransaction>> getTransactions() async {
    final login = await local.getLoginResponse();
    apiClient.setToken(login!.data.token);
    final response = await apiClient.request(
      path: 'wallet/transactions',
      method: MethodType.get,
      fromJsonT: (json) => WalletTransaction.fromJson(json),
    );

    return response;
  }

  @override
  Future<ApiResponse> withdrawMoney({required int amt}) async {
    final login = await local.getLoginResponse();
    apiClient.setToken(login!.data.token);
    // TODO: implement withdrawMoney
    throw UnimplementedError();
  }
}
