import 'package:dartz/dartz.dart';
import 'package:studentride/core/helper/type_def.dart';
import 'package:studentride/core/utils/logger/debug_logger.dart';
import 'package:studentride/features/wallet/data/service/wallet_service.dart';

import '../model/get_transaction_model.dart';

abstract class WalletRepo {
  ApiResult<int> getWallet();
  ApiResult<WalletTransaction> getTransactions();
  ApiResult<int> fundWallet({required int amt});
  ApiResult<int> withdrawMoney({required int amt});
}

class WalletRepoImpl implements WalletRepo {
  final walletService = WalletServiceImpl();

  @override
  ApiResult<int> fundWallet({required int amt}) async {
    final response = await walletService.fundWallet(amt: amt);
    DebugLogger.log('fund wallet', response.rawJson);
    if (response.success!) {
      final balance = response.rawJson['balance'];
      return Right(balance);
    } else {
      return Left(response.failure!);
    }
  }

  @override
  ApiResult<WalletTransaction> getTransactions() async {
    final response = await walletService.getTransactions();

    DebugLogger.log('get transaction', response.rawJson);

    if (response.success!) {
      return Right(response.data!);
    } else {
      return Left(response.failure!);
    }
  }

  @override
  ApiResult<int> getWallet() async {
    final response = await walletService.getWallet();
    DebugLogger.log('get wallet', response.rawJson);
    if (response.success!) {
      final balance = response.rawJson['data']['balance'];
      return Right(balance);
    } else {
      return Left(response.failure!);
    }
  }

  @override
  ApiResult<int> withdrawMoney({required int amt}) async {
    final response = await walletService.withdrawMoney(amt: amt);
    DebugLogger.log('fund wallet', response.rawJson);
    if (response.success!) {
      final balance = response.rawJson['balance'];
      return Right(balance);
    } else {
      return Left(response.failure!);
    }
  }
}
