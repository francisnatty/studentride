import 'package:flutter/material.dart';
import '../../../core/utils/logger/local_storage.dart';
import '../../../features/auth/data/model/login_response.dart';

enum AuthState { loading, authenticated, unauthenticated }

enum UserRole { passenger, driver }

class AuthSession extends ChangeNotifier {
  final LocalStorage _localStorage;

  AuthSession({required LocalStorage localStorage})
    : _localStorage = localStorage {
    _checkAuthStatus();
  }

  AuthState _authState = AuthState.loading;
  LoginResponse? _loginResponse;
  UserRole? _userRole;

  // Getters
  AuthState get authState => _authState;
  LoginResponse? get loginResponse => _loginResponse;
  UserRole? get userRole => _userRole;
  bool get isAuthenticated => _authState == AuthState.authenticated;
  bool get isDriver => _userRole == UserRole.driver;
  bool get isPassenger => _userRole == UserRole.passenger;
  User? get currentUser => _loginResponse?.data.user;

  /// Check authentication status on app startup
  Future<void> _checkAuthStatus() async {
    try {
      _authState = AuthState.loading;
      notifyListeners();

      final loginResponse = await _localStorage.getLoginResponse();

      if (loginResponse != null && loginResponse.success) {
        await _setAuthenticatedState(loginResponse);
      } else {
        await _setUnauthenticatedState();
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
      await _setUnauthenticatedState();
    }
  }

  /// Login user and save response
  Future<bool> login(LoginResponse loginResponse) async {
    try {
      if (loginResponse.success) {
        await _localStorage.saveLoginResponse(loginResponse);
        await _localStorage.saveAcessToken(loginResponse.data.token);
        await _setAuthenticatedState(loginResponse);
        return true;
      } else {
        await _setUnauthenticatedState();
        return false;
      }
    } catch (e) {
      debugPrint('Error during login: $e');
      await _setUnauthenticatedState();
      return false;
    }
  }

  /// Logout user and clear all data
  Future<void> logout() async {
    try {
      await _localStorage.clearAllData();
      await _setUnauthenticatedState();
    } catch (e) {
      debugPrint('Error during logout: $e');
      // Still set unauthenticated state even if clearing fails
      await _setUnauthenticatedState();
    }
  }

  /// Refresh authentication state (useful for token refresh)
  Future<void> refreshAuthState() async {
    await _checkAuthStatus();
  }

  /// Update user profile data
  Future<void> updateUserProfile(User updatedUser) async {
    if (_loginResponse != null) {
      final updatedLoginResponse = LoginResponse(
        success: _loginResponse!.success,
        message: _loginResponse!.message,
        data: LoginData(user: updatedUser, token: _loginResponse!.data.token),
      );

      await _localStorage.saveLoginResponse(updatedLoginResponse);
      _loginResponse = updatedLoginResponse;
      notifyListeners();
    }
  }

  /// Set authenticated state
  Future<void> _setAuthenticatedState(LoginResponse loginResponse) async {
    _loginResponse = loginResponse;
    _userRole = _getUserRoleFromResponse(loginResponse);
    _authState = AuthState.authenticated;
    notifyListeners();
  }

  /// Set unauthenticated state
  Future<void> _setUnauthenticatedState() async {
    _loginResponse = null;
    _userRole = null;
    _authState = AuthState.unauthenticated;
    notifyListeners();
  }

  /// Determine user role from login response
  UserRole _getUserRoleFromResponse(LoginResponse loginResponse) {
    final role = loginResponse.data.user.role.toLowerCase();
    switch (role) {
      case 'driver':
        return UserRole.driver;
      case 'passenger':
      default:
        return UserRole.passenger;
    }
  }

  /// Get appropriate home route based on user role
  String getHomeRoute() {
    if (!isAuthenticated) return '/login';

    switch (_userRole) {
      case UserRole.driver:
        return '/driver-home';
      case UserRole.passenger:
        return '/passenger-home';
      case null:
        return '/login';
    }
  }

  /// Get navigation items based on user role
  List<NavigationItem> getNavigationItems() {
    if (!isAuthenticated) return [];

    switch (_userRole) {
      case UserRole.driver:
        return _getDriverNavigationItems();
      case UserRole.passenger:
        return _getPassengerNavigationItems();
      case null:
        return [];
    }
  }

  List<NavigationItem> _getDriverNavigationItems() {
    return [
      NavigationItem(icon: Icons.home, label: 'Home', route: '/driver-home'),
      NavigationItem(
        icon: Icons.directions_car,
        label: 'My Rides',
        route: '/driver-rides',
      ),
      NavigationItem(
        icon: Icons.account_balance_wallet,
        label: 'Earnings',
        route: '/driver-earnings',
      ),
      NavigationItem(
        icon: Icons.person,
        label: 'Profile',
        route: '/driver-profile',
      ),
    ];
  }

  List<NavigationItem> _getPassengerNavigationItems() {
    return [
      NavigationItem(icon: Icons.home, label: 'Home', route: '/passenger-home'),
      NavigationItem(
        icon: Icons.history,
        label: 'Trip History',
        route: '/passenger-history',
      ),
      NavigationItem(
        icon: Icons.payment,
        label: 'Payment',
        route: '/passenger-payment',
      ),
      NavigationItem(
        icon: Icons.person,
        label: 'Profile',
        route: '/passenger-profile',
      ),
    ];
  }
}

/// Navigation item model
class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
