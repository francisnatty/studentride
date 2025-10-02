// ignore_for_file: public_member_api_docs, sort_constructors_first
class RegistrationModel {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String role;
  final String? matricNumber; // For passengers
  final String? nin; // For drivers
  final String? vehicleType; // ✅ NEW for drivers (motorcycle / tricycle)

  RegistrationModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
    this.matricNumber,
    this.nin,
    this.vehicleType,
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

    if (role == 'driver') {
      if (nin != null) json['nin'] = nin;
      if (vehicleType != null) json['vehicleType'] = vehicleType;
    }

    return json;
  }

  @override
  String toString() {
    return 'RegistrationModel(name: $name, email: $email, phone: $phone, password: $password, role: $role, matricNumber: $matricNumber, nin: $nin, vehicleType: $vehicleType)';
  }
}
