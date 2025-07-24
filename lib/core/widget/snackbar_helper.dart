import 'package:flutter/material.dart';

class SnackBarHelper {
  // Private constructor to prevent instantiation
  SnackBarHelper._();

  /// Shows a success snackbar with green background
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    double? bottomMargin,
  }) {
    _showSnackBar(
      context,
      message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
      duration: duration,
      bottomMargin: bottomMargin,
    );
  }

  /// Shows an error snackbar with red background
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    double? bottomMargin,
  }) {
    _showSnackBar(
      context,
      message,
      backgroundColor: Colors.red,
      icon: Icons.error,
      duration: duration,
      bottomMargin: bottomMargin,
    );
  }

  /// Shows a warning snackbar with orange background
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    double? bottomMargin,
  }) {
    _showSnackBar(
      context,
      message,
      backgroundColor: Colors.orange,
      icon: Icons.warning,
      duration: duration,
      bottomMargin: bottomMargin,
    );
  }

  /// Shows an info snackbar with blue background
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    double? bottomMargin,
  }) {
    _showSnackBar(
      context,
      message,
      backgroundColor: Colors.blue,
      icon: Icons.info,
      duration: duration,
      bottomMargin: bottomMargin,
    );
  }

  /// Generic method to show snackbar based on success/error state
  static void showByState(
    BuildContext context,
    String message, {
    required bool isSuccess,
    Duration? duration,
    double? bottomMargin,
  }) {
    if (isSuccess) {
      showSuccess(
        context,
        message,
        duration: duration ?? const Duration(seconds: 3),
        bottomMargin: bottomMargin,
      );
    } else {
      showError(
        context,
        message,
        duration: duration ?? const Duration(seconds: 4),
        bottomMargin: bottomMargin,
      );
    }
  }

  /// Private method that handles the actual snackbar creation
  static void _showSnackBar(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    double? bottomMargin,
  }) {
    // Don't show if context is not mounted
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.only(
          bottom: bottomMargin ?? 80,
          left: 16,
          right: 16,
        ),
      ),
    );
  }

  /// Custom snackbar with action button
  static void showWithAction(
    BuildContext context,
    String message, {
    required String actionLabel,
    required VoidCallback onActionPressed,
    bool isError = false,
    Duration duration = const Duration(seconds: 5),
    double? bottomMargin,
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.only(
          bottom: bottomMargin ?? 80,
          left: 16,
          right: 16,
        ),
        action: SnackBarAction(
          label: actionLabel,
          textColor: Colors.white,
          onPressed: onActionPressed,
        ),
      ),
    );
  }

  /// Clear any existing snackbars
  static void clear(BuildContext context) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
    }
  }
}
