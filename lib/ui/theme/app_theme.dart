import 'package:flutter/material.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'app_colors.dart';
import 'app_textstyles.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Geist',
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.neonGreen,

    textTheme: TextTheme(
      headlineSmall: AppTextStyles.h1,
      headlineMedium: AppTextStyles.h2,
      headlineLarge: AppTextStyles.h3,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      titleLarge: AppTextStyles.hG,
      titleMedium: AppTextStyles.hT,
      labelMedium: AppTextStyles.bodyWhiteBold,
      labelSmall: AppTextStyles.bodyWhiteThin,
      displaySmall: AppTextStyles.buttonText,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBg,
      foregroundColor: AppColors.white,
      elevation: 0,
      titleTextStyle: AppTextStyles.h2,
    ),

    colorScheme: const ColorScheme.dark(
      primary: AppColors.turquise,
      secondary: AppColors.lightGrey,
      surface: AppColors.surface,
      onSurface: AppColors.white,
      onPrimary: AppColors.lightBlack,
    ),

  );
}
