import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the application.
/// Implements Contemporary Craft Minimalism design with Warm Neutral Foundation colors.
class AppTheme {
  AppTheme._();

  // Color Specifications - Warm Neutral Foundation
  static const Color primary =
      Color(0xFF4A2E1E); // Deep brown for headers and primary actions
  static const Color secondary = Color(0xFFF8F1E7); // Warm beige background
  static const Color accent =
      Color(0xFF74B49B); // Teal for AI suggestions and success states
  static const Color alert =
      Color(0xFFF28B82); // Coral for warnings and destructive actions
  static const Color highlight =
      Color(0xFFC9B6E4); // Lavender for selected states and progress
  static const Color surface =
      Color(0xFFFFFFFF); // Pure white for cards and input fields
  static const Color textPrimary =
      Color(0xFF2C1810); // Dark brown for primary text
  static const Color textSecondary =
      Color(0xFF6B4E3D); // Medium brown for secondary text
  static const Color border =
      Color(0xFFE5D5C8); // Light brown for subtle dividers
  static const Color disabled =
      Color(0xFFA08B7A); // Muted brown for inactive elements

  // Dark theme variations
  static const Color primaryDark = Color(0xFF8B6F47);
  static const Color secondaryDark = Color(0xFF2C2419);
  static const Color surfaceDark = Color(0xFF1A1611);
  static const Color textPrimaryDark = Color(0xFFF8F1E7);
  static const Color textSecondaryDark = Color(0xFFD4C4B0);
  static const Color borderDark = Color(0xFF3D3529);

  /// Light theme - Contemporary Craft Minimalism
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: surface,
      primaryContainer: primary.withValues(alpha: 0.1),
      onPrimaryContainer: primary,
      secondary: accent,
      onSecondary: surface,
      secondaryContainer: accent.withValues(alpha: 0.1),
      onSecondaryContainer: accent,
      tertiary: highlight,
      onTertiary: surface,
      tertiaryContainer: highlight.withValues(alpha: 0.1),
      onTertiaryContainer: highlight,
      error: alert,
      onError: surface,
      surface: surface,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: border,
      outlineVariant: border.withValues(alpha: 0.5),
      shadow: textPrimary.withValues(alpha: 0.1),
      scrim: textPrimary.withValues(alpha: 0.5),
      inverseSurface: textPrimary,
      onInverseSurface: surface,
      inversePrimary: primaryDark,
    ),
    scaffoldBackgroundColor: secondary,
    cardColor: surface,
    dividerColor: border,

    // AppBar Theme - Clean, purposeful interface
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      foregroundColor: surface,
      elevation: 2.0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: surface,
      ),
      iconTheme: const IconThemeData(
        color: surface,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: surface,
        size: 24,
      ),
    ),

    // Card Theme - Adaptive card layouts with 16px radius
    cardTheme: CardTheme(
      color: surface,
      elevation: 2.0,
      shadowColor: textPrimary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.all(8.0),
    ),

    // Bottom Navigation Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 4.0,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Floating Action Button - Smart contextual placement
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accent,
      foregroundColor: surface,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button Themes - 12px border radius for gentle shapes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: surface,
        backgroundColor: primary,
        elevation: 2.0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: primary, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // Text Theme - Typography standards implementation
    textTheme: _buildTextTheme(isLight: true),

    // Input Decoration - Clear visual boundaries for precise work
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surface,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: border, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: alert, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: alert, width: 2),
      ),
      labelStyle: GoogleFonts.poppins(
        color: textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.poppins(
        color: disabled,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      prefixIconColor: textSecondary,
      suffixIconColor: textSecondary,
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accent;
        }
        return disabled;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accent.withValues(alpha: 0.3);
        }
        return disabled.withValues(alpha: 0.3);
      }),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accent;
        }
        return surface;
      }),
      checkColor: WidgetStateProperty.all(surface),
      side: const BorderSide(color: border, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accent;
        }
        return disabled;
      }),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: accent,
      linearTrackColor: border,
      circularTrackColor: border,
    ),

    // Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: accent,
      thumbColor: accent,
      overlayColor: accent.withValues(alpha: 0.2),
      inactiveTrackColor: border,
      valueIndicatorColor: primary,
      valueIndicatorTextStyle: GoogleFonts.poppins(
        color: surface,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Tab Bar Theme - Progressive disclosure navigation
    tabBarTheme: TabBarTheme(
      labelColor: primary,
      unselectedLabelColor: textSecondary,
      indicatorColor: primary,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Tooltip Theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.poppins(
        color: surface,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // SnackBar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimary,
      contentTextStyle: GoogleFonts.poppins(
        color: surface,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: surface,
      selectedColor: highlight.withValues(alpha: 0.2),
      labelStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      side: const BorderSide(color: border, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ), dialogTheme: DialogThemeData(backgroundColor: surface),
  );

  /// Dark theme - Contemporary Craft Minimalism (Dark Mode)
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: textPrimaryDark,
      primaryContainer: primaryDark.withValues(alpha: 0.2),
      onPrimaryContainer: textPrimaryDark,
      secondary: accent,
      onSecondary: surfaceDark,
      secondaryContainer: accent.withValues(alpha: 0.2),
      onSecondaryContainer: textPrimaryDark,
      tertiary: highlight,
      onTertiary: surfaceDark,
      tertiaryContainer: highlight.withValues(alpha: 0.2),
      onTertiaryContainer: textPrimaryDark,
      error: alert,
      onError: surfaceDark,
      surface: surfaceDark,
      onSurface: textPrimaryDark,
      onSurfaceVariant: textSecondaryDark,
      outline: borderDark,
      outlineVariant: borderDark.withValues(alpha: 0.5),
      shadow: Colors.black.withValues(alpha: 0.2),
      scrim: Colors.black.withValues(alpha: 0.5),
      inverseSurface: surface,
      onInverseSurface: textPrimary,
      inversePrimary: primary,
    ),
    scaffoldBackgroundColor: secondaryDark,
    cardColor: surfaceDark,
    dividerColor: borderDark,

    // AppBar Theme - Dark mode
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: textPrimaryDark,
      elevation: 2.0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      iconTheme: IconThemeData(
        color: textPrimaryDark,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: textPrimaryDark,
        size: 24,
      ),
    ),

    // Card Theme - Dark mode
    cardTheme: CardTheme(
      color: surfaceDark,
      elevation: 2.0,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.all(8.0),
    ),

    // Bottom Navigation Theme - Dark mode
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primaryDark,
      unselectedItemColor: textSecondaryDark,
      type: BottomNavigationBarType.fixed,
      elevation: 4.0,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Text Theme - Dark mode
    textTheme: _buildTextTheme(isLight: false),

    // Input Decoration - Dark mode
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderDark, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderDark, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryDark, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: alert, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: alert, width: 2),
      ),
      labelStyle: GoogleFonts.poppins(
        color: textSecondaryDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.poppins(
        color: disabled,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      prefixIconColor: textSecondaryDark,
      suffixIconColor: textSecondaryDark,
    ),

    // Additional dark theme configurations...
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accent,
      foregroundColor: surfaceDark,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: surfaceDark,
        backgroundColor: primaryDark,
        elevation: 2.0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ), dialogTheme: DialogThemeData(backgroundColor: surfaceDark),
  );

  /// Helper method to build text theme based on brightness
  /// Implements Typography Standards with Playfair Display and Poppins
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHigh = isLight ? textPrimary : textPrimaryDark;
    final Color textMedium = isLight ? textSecondary : textSecondaryDark;
    final Color textDisabledColor = disabled;

    return TextTheme(
      // Display styles - Playfair Display for headings
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: textHigh,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 45,
        fontWeight: FontWeight.w600,
        color: textHigh,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textHigh,
      ),

      // Headline styles - Playfair Display
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textHigh,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textHigh,
      ),
      headlineSmall: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textHigh,
      ),

      // Title styles - Playfair Display
      titleLarge: GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textHigh,
      ),
      titleMedium: GoogleFonts.playfairDisplay(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textHigh,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.playfairDisplay(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textHigh,
        letterSpacing: 0.1,
      ),

      // Body styles - Poppins for extended reading
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHigh,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHigh,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMedium,
        letterSpacing: 0.4,
      ),

      // Label styles - Poppins for captions and labels
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHigh,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMedium,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w300,
        color: textDisabledColor,
        letterSpacing: 0.5,
      ),
    );
  }

  /// Data/Monospace text style for measurements and coordinates
  static TextStyle dataTextStyle(
      {required bool isLight, double fontSize = 14}) {
    return GoogleFonts.robotoMono(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: isLight ? textPrimary : textPrimaryDark,
      letterSpacing: 0.25,
    );
  }

  /// Data text style variants
  static TextStyle dataTextStyleMedium(
      {required bool isLight, double fontSize = 14}) {
    return GoogleFonts.robotoMono(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: isLight ? textPrimary : textPrimaryDark,
      letterSpacing: 0.25,
    );
  }
}
