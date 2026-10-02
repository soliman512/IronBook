import 'package:flutter/material.dart';

import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_radius.dart';
import 'package:ironbook/core/constants/app_spacing.dart';
import 'package:ironbook/core/constants/app_text_styles.dart';

abstract final class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.accent,
      onSecondary: AppColors.primary,
      surface: AppColors.background,
      onSurface: AppColors.primary,
      error: AppColors.danger,
      onError: AppColors.white,
      outline: AppColors.inputBorder,
    ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayHero,
      headlineMedium: AppTextStyles.authHeader,
      titleLarge: AppTextStyles.screenTitle,
      titleMedium: AppTextStyles.planCardTitle,
      bodyLarge: AppTextStyles.bodyText,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.specialBodyMedium,
      labelLarge: AppTextStyles.buttonText,
      labelSmall: AppTextStyles.monoLabel,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.screenTitle,
    ),
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 1,
      shadowColor: AppColors.primary.withValues(alpha: 0.04),
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.button,
        vertical: AppSpacing.md,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.inputBorder),
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.danger),
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.danger),
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        textStyle: AppTextStyles.buttonText,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.button,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.inputBorder),
        textStyle: AppTextStyles.buttonText,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.button,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.buttonText,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.secondary,
      elevation: 0,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: AppSpacing.screen,
    ),
  );
}
