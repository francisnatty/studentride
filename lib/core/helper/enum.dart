enum MethodType { get, post, put, delete, patch }

enum UserRole { passenger, driver, unknown }

UserRole parseRole(String? raw) {
  switch (raw?.toLowerCase()) {
    case 'passenger':
      return UserRole.passenger;
    case 'driver':
      return UserRole.driver;
    default:
      return UserRole.unknown;
  }
}

enum SessionStatus { unknown, loading, unauthenticated, authenticated }
