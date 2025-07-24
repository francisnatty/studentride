// validators.dart
class FormValidators {
  static String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First name is required';
    }
    if (value.trim().length < 2) {
      return 'First name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'First name can only contain letters';
    }
    return null;
  }

  static String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Last name is required';
    }
    if (value.trim().length < 2) {
      return 'Last name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Last name can only contain letters';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-digit characters for validation
    String cleanNumber = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Handle both formats: 07066667888 and 7066667888
    if (cleanNumber.startsWith('0')) {
      cleanNumber = cleanNumber.substring(1);
    }

    if (cleanNumber.length < 10) {
      return 'Phone number must be at least 10 digits';
    }

    if (cleanNumber.length > 10) {
      return 'Phone number cannot exceed 10 digits';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Helper method to clean phone number for API
  static String cleanPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    // Remove leading zero if present
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
    }

    return cleaned;
  }

  // Helper method to format phone number for display
  static String formatPhoneNumber(String phoneNumber) {
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    // Add leading zero if not present for display
    if (!cleaned.startsWith('0') && cleaned.length == 10) {
      cleaned = '0$cleaned';
    }

    // Format as 070-6666-7888
    if (cleaned.length == 11) {
      return '${cleaned.substring(0, 3)}-${cleaned.substring(3, 7)}-${cleaned.substring(7)}';
    }

    return cleaned;
  }
}
