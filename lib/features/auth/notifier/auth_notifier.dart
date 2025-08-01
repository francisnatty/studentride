import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:studentride/core/widget/loading_dialog.dart';
import 'package:studentride/core/widget/snackbar_helper.dart';

import '../data/model/create_acct_params.dart';
import '../data/repo/auth_repo.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthRepo authRepo;

  AuthNotifier({required this.authRepo});

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _setError(String? msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  void _setSuccess(bool val) {
    _isSuccess = val;
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _setLoading(true);
    LoadingDialog.show(context);
    // _setError(null);
    // _setSuccess(false);

    final result = await authRepo.login(email: email, password: password);

    LoadingDialog.hide(context);

    result.fold(
      (failure) {
        SnackBarHelper.showError(context, failure.message);
      },
      (_) {
        SnackBarHelper.showSuccess(context, 'Login Successfull');
      },
    );

    _setLoading(false);
  }

  Future<void> createAccount(RegistrationModel model) async {
    _setLoading(true);
    _setError(null);
    _setSuccess(false);

    final result = await authRepo.createAcct(params: model);

    result.fold(
      (failure) => _setError(failure.message),
      (_) => _setSuccess(true),
    );

    _setLoading(false);
  }

  void reset() {
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();
  }

  Future<void> verifyOtp({
    required BuildContext context,
    required String email,
    required String otp,
  }) async {
    LoadingDialog.show(context);

    final result = await authRepo.verifyOtp(email: email, otp: otp);

    if (!context.mounted) return;

    LoadingDialog.hide(context);

    result.fold(
      (failure) {
        SnackBarHelper.showError(context, failure.message);
      },
      (success) {
        SnackBarHelper.showSuccess(context, success);
      },
    );
  }

  Future<void> resendOtp({
    required BuildContext context,
    required String email,
  }) async {
    LoadingDialog.show(context);

    final result = await authRepo.resendOtp(email: email);

    if (!context.mounted) return;

    LoadingDialog.hide(context);

    result.fold(
      (failure) {
        SnackBarHelper.showError(context, failure.message);
      },
      (success) {
        SnackBarHelper.showSuccess(context, success);
      },
    );
  }
}
