import 'package:flutter/material.dart';

class ResponsiveUtils {
  // Private constructor
  ResponsiveUtils._();
  
  // Get screen size
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
  
  // Height utilities
  static double heightPercent(BuildContext context, double percent) {
    return MediaQuery.of(context).size.height * percent / 100;
  }
  
  // Width utilities
  static double widthPercent(BuildContext context, double percent) {
    return MediaQuery.of(context).size.width * percent / 100;
  }
  
  // Additional useful utilities
  static double height(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }
  
  static double width(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }
  
  // For responsive font sizes
  static double fontSize(BuildContext context, double percent) {
    return widthPercent(context, percent) * 0.8;
  }
  
  // Check device type
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600;
  }
  
  static bool isMobile(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < 600;
  }
}