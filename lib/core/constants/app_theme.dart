import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    const text = TextStyle(fontFamily: 'Inter', color: AppColors.textPrimary);
    final typography = TextTheme(
      displaySmall: text.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.18,
        letterSpacing: -1.2,
      ),
      headlineLarge: text.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.22,
        letterSpacing: -1,
      ),
      headlineMedium: text.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -.8,
      ),
      headlineSmall: text.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -.6,
      ),
      titleLarge: text.copyWith(
        fontSize: 21,
        fontWeight: FontWeight.w600,
        height: 1.35,
        letterSpacing: -.5,
      ),
      titleMedium: text.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: -.2,
      ),
      titleSmall: text.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      bodyLarge: text.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
      bodyMedium: text.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.55,
      ),
      bodySmall: text.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textMuted,
      ),
      labelLarge: text.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      labelMedium: text.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      labelSmall: text.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
    );
    return ThemeData(
      fontFamily: 'Inter',
      visualDensity: VisualDensity.standard,
      splashFactory: InkSparkle.splashFactory,
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryNavy,
      scaffoldBackgroundColor: AppColors.scaffoldBg,
      canvasColor: AppColors.white,
      cardColor: AppColors.surfaceNavy,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryNavy,
        secondary: AppColors.amberDark,
        surface: AppColors.surfaceNavy,
        onPrimary: AppColors.white,
        onSecondary: AppColors.primaryNavy,
        onSurface: AppColors.textPrimary,
        error: AppColors.danger,
      ),
      textTheme: typography,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNavy,
          foregroundColor: AppColors.white,
          elevation: 0,
          shadowColor: AppColors.primaryNavy.withValues(alpha: 0.2),
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryNavy,
          side: const BorderSide(color: AppColors.borderMedium, width: 1.5),
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.amberDeep,
          textStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIconColor: AppColors.textMuted,
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          color: AppColors.textMuted,
          fontSize: 14,
        ),
        labelStyle: TextStyle(
          fontFamily: 'Inter',
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderMedium),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderMedium),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primaryNavy,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.borderNavy, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.amberDark;
          }
          return Colors.transparent;
        }),
        checkColor: const WidgetStatePropertyAll(AppColors.white),
        side: const BorderSide(color: AppColors.borderMedium, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryNavy,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.white,
        selectedColor: AppColors.primaryNavy,
        side: const BorderSide(color: AppColors.borderNavy),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        labelStyle: WidgetStateTextStyle.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? Colors.white
                : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryNavy,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.amberLight,
        height: 80,
        surfaceTintColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 23,
            color: states.contains(WidgetState.selected)
                ? AppColors.primaryNavy
                : AppColors.textMuted,
          ),
        ),
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderNavy,
        thickness: 1,
        space: 24,
      ),
    );
  }

  // Alias for backward compatibility
  static ThemeData get darkTheme => lightTheme;
}
