import 'package:flutter/material.dart';

class ResponsiveSize {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeAreaHorizontal;
  static late double safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static bool _isInitialized = false;

  // Initialize the ResponsiveSize with context - can be called once in main.dart
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - safeAreaVertical) / 100;
    _isInitialized = true;
  }

  // Alternative method to initialize with MediaQueryData directly
  static void initWithData(MediaQueryData mediaQueryData) {
    _mediaQueryData = mediaQueryData;
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - safeAreaVertical) / 100;
    _isInitialized = true;
  }

  // Check if ResponsiveSize has been initialized
  static bool get isInitialized => _isInitialized;

  // Get screen width
  static double get width => screenWidth;

  // Get screen height
  static double get height => screenHeight;

  // Get percentage of screen width
  static double widthPercent(double percent) => screenWidth * (percent / 100);

  // Get percentage of screen height
  static double heightPercent(double percent) => screenHeight * (percent / 100);

  // Get safe area width percentage
  static double safeWidthPercent(double percent) =>
      safeBlockHorizontal * percent;

  // Get safe area height percentage
  static double safeHeightPercent(double percent) =>
      safeBlockVertical * percent;

  // Screen breakpoints
  static bool get isMobile => screenWidth < 768;
  static bool get isTablet => screenWidth >= 768 && screenWidth < 1024;
  static bool get isDesktop => screenWidth >= 1024;

  // Responsive text sizes
  static double get smallText {
    if (isMobile) return screenWidth * 0.035; // ~14px on 400px screen
    if (isTablet) return screenWidth * 0.025; // ~19px on 768px screen
    return screenWidth * 0.018; // ~18px on 1024px screen
  }

  static double get mediumText {
    if (isMobile) return screenWidth * 0.04; // ~16px on 400px screen
    if (isTablet) return screenWidth * 0.028; // ~21px on 768px screen
    return screenWidth * 0.02; // ~20px on 1024px screen
  }

  static double get largeText {
    if (isMobile) return screenWidth * 0.05; // ~20px on 400px screen
    if (isTablet) return screenWidth * 0.035; // ~27px on 768px screen
    return screenWidth * 0.025; // ~26px on 1024px screen
  }

  static double get extraLargeText {
    if (isMobile) return screenWidth * 0.06; // ~24px on 400px screen
    if (isTablet) return screenWidth * 0.042; // ~32px on 768px screen
    return screenWidth * 0.03; // ~31px on 1024px screen
  }

  // Custom responsive text size
  static double responsiveText(
    double mobileSize,
    double tabletSize,
    double desktopSize,
  ) {
    if (isMobile) return screenWidth * (mobileSize / 100);
    if (isTablet) return screenWidth * (tabletSize / 100);
    return screenWidth * (desktopSize / 100);
  }

  // Scale font size based on screen width
  static double scaledText(double baseSize) {
    double scaleFactor = screenWidth / 375; // 375 is iPhone 6/7/8 width
    return baseSize * scaleFactor;
  }

  // Get responsive padding/margin
  static double get smallPadding => screenWidth * 0.02;
  static double get mediumPadding => screenWidth * 0.04;
  static double get largePadding => screenWidth * 0.06;

  // Get responsive border radius
  static double get smallRadius => screenWidth * 0.02;
  static double get mediumRadius => screenWidth * 0.03;
  static double get largeRadius => screenWidth * 0.04;

  // Custom responsive value
  static double responsive(
    double mobileValue,
    double tabletValue,
    double desktopValue,
  ) {
    if (isMobile) return mobileValue;
    if (isTablet) return tabletValue;
    return desktopValue;
  }
}

// Extension to make it even easier to use - returns actual pixel values
extension ResponsiveSizeExtension on num {
  // Width and height as actual pixel values (not percentages)
  double get w =>
      ResponsiveSize.screenWidth * (toDouble() / ResponsiveSize.screenWidth);
  double get h =>
      ResponsiveSize.screenHeight * (toDouble() / ResponsiveSize.screenHeight);

  // More intuitive - actual pixel values based on screen dimensions
  double get width =>
      toDouble() *
      (ResponsiveSize.screenWidth / 375); // Scale based on iPhone 6/7/8 width
  double get height =>
      toDouble() *
      (ResponsiveSize.screenHeight / 812); // Scale based on iPhone X height

  // Percentage-based (original functionality)
  double get wp => ResponsiveSize.widthPercent(toDouble());
  double get hp => ResponsiveSize.heightPercent(toDouble());
  double get swp => ResponsiveSize.safeWidthPercent(toDouble());
  double get shp => ResponsiveSize.safeHeightPercent(toDouble());

  // Direct pixel values scaled to current screen
  double get px => toDouble() * ResponsiveSize.screenWidth / 375;
  double get py => toDouble() * ResponsiveSize.screenHeight / 812;
}
