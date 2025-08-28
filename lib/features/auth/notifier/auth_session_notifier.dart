import 'package:flutter/foundation.dart';
import '../../../core/helper/enum.dart';
import '../../../core/utils/logger/local_storage.dart';
import '../data/model/login_response.dart';

class AuthSessionNotifier extends ChangeNotifier {
  final LocalStorage _storage;

  SessionStatus _status = SessionStatus.unknown;
  SessionStatus get status => _status;

  LoginResponse? _login;
  LoginResponse? get login => _login;

  UserRole get role => parseRole(_login?.data.user.role);
  bool get isPassenger => role == UserRole.passenger;
  bool get isDriver => role == UserRole.driver;
  bool get isAuthenticated => _status == SessionStatus.authenticated;

  AuthSessionNotifier({required LocalStorage storage}) : _storage = storage;

  Future<void> bootstrap() async {
    _set(SessionStatus.loading);
    try {
      final saved = await _storage.getLoginResponse();
      if (saved == null) {
        _login = null;
        _set(SessionStatus.unauthenticated);
        return;
      }
      _login = saved;
      _set(SessionStatus.authenticated);
      //  await _roleBootstrap();
    } catch (_) {
      _login = null;
      _set(SessionStatus.unauthenticated);
    }
  }

  Future<void> onLoggedIn(LoginResponse lr) async {
    _set(SessionStatus.loading);
    _login = lr;
    await _storage.saveLoginResponse(lr);
    _set(SessionStatus.authenticated);
    // await _roleBootstrap();
  }

  Future<void> logout() async {
    _set(SessionStatus.loading);
    await _storage.clearAllData();
    _login = null;
    _set(SessionStatus.unauthenticated);
  }

  Future<void> refreshFromStorage() async {
    final saved = await _storage.getLoginResponse();
    _login = saved;
    notifyListeners();
  }

  // Future<void> _roleBootstrap() async {
  //   try {
  //     // Passenger: nothing to preload (safe no-op)
  //     if (isDriver) {
  //       // Only run if you passed a DriverRepo
  //       await _driverRepo?.preloadDriverHome();
  //     }
  //   } finally {
  //     notifyListeners();
  //   }
  // }

  void _set(SessionStatus s) {
    _status = s;
    notifyListeners();
  }
}
