import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'app_colors.dart';
import 'app_textstyles.dart';

/// Primary app theme for text, appbar, colorscheme, snackbar
class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Geist',
    scaffoldBackgroundColor: Colors.transparent,
    primaryColor: AppColors.neonGreen,

    textTheme: TextTheme(
      headlineSmall: AppTextStyles.cinzel24LG,
      headlineMedium: AppTextStyles.vidaLoka24T,
      headlineLarge: AppTextStyles.vidaLoka32T,
      bodyMedium: AppTextStyles.geist16LG,
      bodySmall: AppTextStyles.vidaLoka14LG,
      titleLarge: AppTextStyles.geist20LG,
      titleMedium: AppTextStyles.geist18T,
      labelMedium: AppTextStyles.vidaLoka14W,
      labelSmall: AppTextStyles.vidaLoka14Wthin,
      displaySmall: AppTextStyles.geist20LB,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBg,
      foregroundColor: AppColors.white,
      elevation: 0,
      titleTextStyle: AppTextStyles.vidaLoka24T,
    ),

    colorScheme: const ColorScheme.dark(
      primary: AppColors.turquise,
      secondary: AppColors.lightGrey,
      surface: AppColors.surface,
      onSurface: AppColors.white,
      onPrimary: AppColors.lightBlack,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.neonPink.withValues(alpha: 0.4),
      contentTextStyle: const TextStyle(color: AppColors.white),
      shape: RoundedRectangleBorder(borderRadius: borderRadius12),
      behavior: SnackBarBehavior.floating,
      elevation: 8,
    ),
  );
}
