import 'package:flutter/material.dart';
import 'app_colors.dart';

/// All differrent textstyles used for the app
class AppTextStyles {
  //-----------Heading-------------//
  static const TextStyle cinzel24LG = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 24,
    fontWeight: FontWeight.w100,
    color: AppColors.lightGrey,
  );

  //-----------VidaLoka Turquise-------------//
  static TextStyle vidaLoka22T = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.turquise.withValues(alpha: 0.78),
    shadows: [
      Shadow(
        color: AppColors.turquise.withValues(alpha: 0.7),
        blurRadius: 13,
        offset: const Offset(0.5, 0.2),
      ),
    ],
  );

  static TextStyle vidaLoka24T = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.turquise.withValues(alpha: 0.78),
  );

  static TextStyle vidaLoka32T = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.turquise,
    shadows: [
      Shadow(
        color: AppColors.turquise.withValues(alpha: 0.7),
        blurRadius: 13,
        offset: const Offset(0.5, 0.2),
      ),
    ],
  );

  //-----------Geist Turquise-------------//
  static TextStyle geist18T = TextStyle(
    fontFamily: 'Geist',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.turquise.withValues(alpha: 0.78),
  );

  //-----------Geist Lightgrey-------------//
  static const TextStyle geist14LG = TextStyle(
    fontFamily: 'Geist',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.lightGrey,
  );

  static const TextStyle geist16LG = TextStyle(
    fontFamily: 'Geist',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.lightGrey,
  );

  static const TextStyle geist20LG = TextStyle(
    fontFamily: 'Geist',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.lightGrey,
  );

  //-----------VidaLoka Lightgrey-------------//
  static const TextStyle vidaLoka14LG = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.lightGrey,
  );

  static const TextStyle vidaLoka16LG = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.lightGrey,
  );

  static const TextStyle vidaLoka20LG = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.lightGrey,
  );

  //-----------VidaLoka White-------------//
  static const TextStyle vidaLoka14W = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle vidaLoka14Wthin = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 14,
    color: AppColors.white,
  );

  static const TextStyle vidaLoka16W = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  //-----------Gesit White-------------//
  static const TextStyle geist14W = TextStyle(
    fontFamily: 'Geist',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle geist16W = TextStyle(
    fontFamily: 'Geist',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle geist18W = TextStyle(
    fontFamily: 'Geist',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle geist22W = TextStyle(
    fontFamily: 'Geist',
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  //-----------VidaLoka Neongreen-------------//
  static const TextStyle vidaLoka11NG = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 11,
    color: AppColors.neonGreen,
  );

  //-----------Geist LightBlack-------------//
  static const TextStyle geist20LB = TextStyle(
    fontFamily: 'Geist',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.lightBlack,
  );

  //-----------VidaLoka Gold-------------//
  static TextStyle vidaLoka18G = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.gold.withValues(alpha: 0.58),
  );

  static TextStyle vidaLoka20G = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.gold.withValues(alpha: 0.58),
  );

  static TextStyle vidaLoka24G = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.gold.withValues(alpha: 0.58),
  );

  static TextStyle vidaLoka32G = TextStyle(
    fontFamily: 'VidaLoka',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.gold.withValues(alpha: 0.4),
    shadows: [
      Shadow(
        color: AppColors.gold.withValues(alpha: 0.4),
        blurRadius: 10,
        offset: const Offset(0.3, 0.2),
      ),
    ],
  );
}
