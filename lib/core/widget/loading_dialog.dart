import 'package:flutter/material.dart';

import 'package:loading_indicator/loading_indicator.dart';

import '../constants/colors.dart';

class LoadingDialog {
  static void show(BuildContext context, {String message = "Loading..."}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            // Ensures the dialog is centered
            child: Material(
              color: Colors.transparent, // Removes extra background color
              child: Container(
                height: 100,
                width: 100,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballClipRotate,
                    colors: [AppColors.primary],
                    strokeWidth: 3,
                    backgroundColor: Colors.transparent,
                    pathBackgroundColor: AppColors.primary.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
