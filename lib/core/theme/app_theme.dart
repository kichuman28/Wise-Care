import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2D336B); // Dark Navy Blue
  static const Color secondary = Color(0xFF7886C7); // Medium Blue-Purple
  static const Color tertiary = Color(0xFFA9B5DF); // Light Blue-Gray
  static const Color quaternary = Color(0xFFFFF2F2); // Very Light Pink

  static const Color background = Color(0xFFFFF2F2); // Using quaternary as background
  static const Color surface = Colors.white;
  static const Color text = Color(0xFF2D336B); // Using primary for text
  static const Color textSecondary = Color(0xFF7886C7); // Using secondary for secondary text
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      background: AppColors.background,
      surface: AppColors.surface,
      onBackground: AppColors.text,
      onSurface: AppColors.text,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: AppColors.primary,
      error: Colors.red,
      onError: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.text,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: Colors.white,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
