class RegistrationModel {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String role;
  final String? matricNumber; // For passengers
  final String? nin; // For drivers

  RegistrationModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
    this.matricNumber,
    this.nin,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
    };

    // Add role-specific fields
    if (role == 'passenger' && matricNumber != null) {
      json['matricNumber'] = matricNumber;
    }

    if (role == 'driver' && nin != null) {
      json['nin'] = nin;
    }

    return json;
  }
}
