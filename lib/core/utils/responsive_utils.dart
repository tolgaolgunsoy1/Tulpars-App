import 'package:flutter/material.dart';

/// Utility class for responsive design
class ResponsiveUtils {
  static const double mobileMaxWidth = 650;
  static const double tabletMaxWidth = 1024;

  /// Check if the device is mobile
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMaxWidth;

  /// Check if the device is tablet
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileMaxWidth &&
      MediaQuery.of(context).size.width < tabletMaxWidth;

  /// Check if the device is desktop
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMaxWidth;

  /// Get responsive value based on screen size
  static T responsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  /// Get responsive font size
  static double responsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 375.0; // Base width for iPhone 6/7/8
    return baseSize * scaleFactor.clamp(0.8, 1.5);
  }

  /// Get responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    return responsiveValue(
      context: context,
      mobile: const EdgeInsets.all(16),
      tablet: const EdgeInsets.all(24),
      desktop: const EdgeInsets.all(32),
    );
  }

  /// Get responsive margin
  static EdgeInsets responsiveMargin(BuildContext context) {
    return responsiveValue(
      context: context,
      mobile: const EdgeInsets.all(8),
      tablet: const EdgeInsets.all(16),
      desktop: const EdgeInsets.all(24),
    );
  }

  /// Get responsive border radius
  static double responsiveBorderRadius(BuildContext context) {
    return responsiveValue(
      context: context,
      mobile: 8,
      tablet: 12,
      desktop: 16,
    );
  }

  /// Get responsive elevation
  static double responsiveElevation(BuildContext context) {
    return responsiveValue(
      context: context,
      mobile: 2,
      tablet: 4,
      desktop: 8,
    );
  }

  /// Get responsive icon size
  static double responsiveIconSize(BuildContext context, double baseSize) {
    return responsiveValue(
      context: context,
      mobile: baseSize * 0.8,
      tablet: baseSize,
      desktop: baseSize * 1.2,
    );
  }

  /// Get responsive spacing
  static double responsiveSpacing(BuildContext context, double baseSpacing) {
    return responsiveValue(
      context: context,
      mobile: baseSpacing * 0.8,
      tablet: baseSpacing,
      desktop: baseSpacing * 1.2,
    );
  }
}

/// Extension methods for responsive design
extension ResponsiveExtension on BuildContext {
  bool get isMobile => ResponsiveUtils.isMobile(this);
  bool get isTablet => ResponsiveUtils.isTablet(this);
  bool get isDesktop => ResponsiveUtils.isDesktop(this);

  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) =>
      ResponsiveUtils.responsiveValue(
        context: this,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      );

  double responsiveFontSize(double baseSize) =>
      ResponsiveUtils.responsiveFontSize(this, baseSize);

  EdgeInsets get responsivePadding => ResponsiveUtils.responsivePadding(this);
  EdgeInsets get responsiveMargin => ResponsiveUtils.responsiveMargin(this);

  double get responsiveBorderRadius =>
      ResponsiveUtils.responsiveBorderRadius(this);

  double get responsiveElevation => ResponsiveUtils.responsiveElevation(this);

  double responsiveIconSize(double baseSize) =>
      ResponsiveUtils.responsiveIconSize(this, baseSize);

  double responsiveSpacing(double baseSpacing) =>
      ResponsiveUtils.responsiveSpacing(this, baseSpacing);
}
