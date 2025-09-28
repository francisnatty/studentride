class ResetPasswordResponse {
  final String email;
  final String token;
  final String newPassword;

  ResetPasswordResponse({
    required this.email,
    required this.token,
    required this.newPassword,
  });

  /// Create from JSON
  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      email: json['email'] as String,
      token: json['token'] as String,
      newPassword: json['newPassword'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'email': email, 'token': token, 'newPassword': newPassword};
  }
}
