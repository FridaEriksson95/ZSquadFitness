import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 24,
    fontWeight: FontWeight.w100,
    color: AppColors.lightGrey,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.turquise,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.turquise,
  );

  static TextStyle hT = TextStyle(
    fontFamily: 'Geist',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.turquise,
  );

  static const TextStyle hG = TextStyle(
    fontFamily: 'Geist',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.lightGrey,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.lightGrey,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.lightGrey,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: 'Geist',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.lightBlack,
  );

  static const TextStyle bodyWhiteBold = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle bodyWhiteThin = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 14,
    color: AppColors.white,
  );

  static const BoxShadow shadow = BoxShadow(
    color: Colors.black38,
    blurRadius: 10,
    offset: Offset(0, 4),
  );
}
