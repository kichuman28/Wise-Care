import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2D336B); // Deep Navy Blue
  static const Color primaryLight =
      Color(0xFF3A4186); // Lighter shade of primary
  static const Color primaryDark = Color(0xFF1E2245); // Darker shade of primary
  static const Color secondary = Color(0xFF7886C7); // Medium Blue-Purple
  static const Color tertiary = Color(0xFFA9B5DF); // Light Blue-Gray
  static const Color quaternary = Color(0xFFFFF2F2); // Very Light Pink
  static const Color accent = Color(0xFF64B6FF); // Bright accent blue
  static const Color success = Color(0xFF4CAF50); // Success green
  static const Color warning = Color(0xFFFFC107); // Warning yellow
  static const Color error = Color(0xFFE53935); // Error red

  static const Color background = Colors.white; // Pure white background
  static const Color surface = Colors.white;
  static const Color cardBackground = Color(0xFFF8F9FC); // Light gray for cards
  static const Color cardShadow = Color(0x1A000000); // Soft shadow
  static const Color divider = Color(0xFFE0E0E0); // Light divider

  static const Color text = Color(0xFF2D336B); // Primary text
  static const Color textSecondary = Color(0xFF666666); // Secondary text
  static const Color textTertiary = Color(0xFF9E9E9E); // Tertiary text

  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFF2D336B),
    Color(0xFF4250A2),
  ];
}

class AppTheme {
  // Common elevated button style
  static final _elevatedButtonStyle = ElevatedButton.styleFrom(
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  );

  // Common outlined button style
  static final _outlinedButtonStyle = OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    side: const BorderSide(color: AppColors.primary, width: 1.5),
    foregroundColor: AppColors.primary,
  );

  // Common text button style
  static final _textButtonStyle = TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    foregroundColor: AppColors.primary,
  );

  // Common input decoration
  static const _inputDecoration = InputDecorationTheme(
    fillColor: AppColors.cardBackground,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: AppColors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: AppColors.error, width: 1.5),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    hintStyle: TextStyle(
      color: AppColors.textTertiary,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Quicksand',
    brightness: Brightness.light,

    // Color scheme
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
      error: AppColors.error,
      onError: Colors.white,
    ),

    // Text theme with premium typography
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
        height: 1.3,
        letterSpacing: -0.5,
        fontFamily: 'Quicksand',
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
        height: 1.3,
        letterSpacing: -0.5,
        fontFamily: 'Quicksand',
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
        height: 1.3,
        letterSpacing: -0.25,
        fontFamily: 'Quicksand',
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
        height: 1.3,
        letterSpacing: -0.25,
        fontFamily: 'Quicksand',
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        height: 1.3,
        fontFamily: 'Quicksand',
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        height: 1.3,
        fontFamily: 'Quicksand',
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        height: 1.3,
        fontFamily: 'Quicksand',
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        height: 1.3,
        fontFamily: 'Quicksand',
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
        height: 1.5,
        fontFamily: 'Quicksand',
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.5,
        fontFamily: 'Quicksand',
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.5,
        fontFamily: 'Quicksand',
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        letterSpacing: 0.5,
        fontFamily: 'Quicksand',
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        letterSpacing: 0.5,
        fontFamily: 'Quicksand',
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
        fontFamily: 'Quicksand',
      ),
    ),

    // Card theme with soft shadows
    cardTheme: CardTheme(
      color: AppColors.cardBackground,
      elevation: 4,
      shadowColor: AppColors.cardShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // App bar theme
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.text,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        fontFamily: 'Quicksand',
      ),
      iconTheme: IconThemeData(
        color: AppColors.primary,
        size: 24,
      ),
    ),

    // Bottom navigation bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 8,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      selectedLabelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontFamily: 'Quicksand',
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'Quicksand',
      ),
      type: BottomNavigationBarType.fixed,
    ),

    // Floating action button theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: CircleBorder(),
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _elevatedButtonStyle,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: _outlinedButtonStyle,
    ),
    textButtonTheme: TextButtonThemeData(
      style: _textButtonStyle,
    ),

    // Input decoration theme
    inputDecorationTheme: _inputDecoration,

    // Dialog theme
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.background,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        fontFamily: 'Quicksand',
      ),
      contentTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
        fontFamily: 'Quicksand',
      ),
    ),

    // Divider theme
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),

    // Snackbar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primary,
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Quicksand',
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // Chip theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.cardBackground,
      selectedColor: AppColors.primary,
      disabledColor: AppColors.cardBackground.withOpacity(0.5),
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
        fontFamily: 'Quicksand',
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        fontFamily: 'Quicksand',
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  );

  // Dark theme implementation
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Quicksand',
    brightness: Brightness.dark,
    // Dark theme implementation would go here
    // This is a placeholder for future dark theme implementation
  );
}

class AppDecorations {
  static BoxDecoration gradientBox = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: AppColors.primaryGradient,
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withOpacity(0.3),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration cardBox = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: AppColors.cardShadow.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
