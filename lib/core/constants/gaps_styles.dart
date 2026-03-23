import 'package:flutter/material.dart';
import 'package:zsquadfitness/shared/ui/theme/app_assets.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';

const gapH5 = SizedBox(height: 5.0);
const gapH10 = SizedBox(height: 10.0);
const gapH15 = SizedBox(height: 15.0);
const gapH20 = SizedBox(height: 20.0);
const gapH30 = SizedBox(height: 30.0);
const gapH65 = SizedBox(height: 65.0);
const gapBottom = SizedBox(height: 120);

const gapW5 = SizedBox(width: 5.0);
const gapW10 = SizedBox(width: 10.0);
const gapW12 = SizedBox(width: 12.0);
const gapW35 = SizedBox(width: 35.0);
const gapW48 = SizedBox(width: 48.0);
const gapW70 = SizedBox(width: 70.0);

final divider300 = SizedBox(
  width: 300,
  child: Divider(color: AppColors.neonGreen.withValues(alpha: 0.4)),
);

final divider360 = SizedBox(
  width: 360,
  child: Divider(color: AppColors.neonGreen.withValues(alpha: 0.4)),
);

final divider250 = SizedBox(
  width: 250,
  child: Divider(color: AppColors.greenish),
);

final dividerGreenish = SizedBox(
  width: 250,
  child: Divider(color: AppColors.greenish),
);

const paddingH16 = EdgeInsets.symmetric(horizontal: 16.0);
const paddingH20 = EdgeInsets.symmetric(horizontal: 20.0);
const paddingV16 = EdgeInsets.symmetric(vertical: 16.0);
const paddingV20 = EdgeInsets.symmetric(vertical: 20.0);
const paddingV40 = EdgeInsets.symmetric(vertical: 40.0);
const paddingVH = EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0);
const paddingAll8 = EdgeInsets.all(8.0);
const paddingAll12 = EdgeInsets.all(12.0);
const paddingAll15 = EdgeInsets.all(15.0);
const paddingAll24 = EdgeInsets.all(24.0);
const paddingOnlyTB = EdgeInsets.only(top: 13.0, bottom: 8.0);
const paddingOnlyBxs = EdgeInsets.only(bottom: 5.0);
const paddingOnlyBs = EdgeInsets.only(bottom: 10.0);
const paddingOnlyBm = EdgeInsets.only(bottom: 16.0);
const paddingOnlyL = EdgeInsets.only(left: 40.0);
const paddingOnlyLsmall = EdgeInsets.only(left: 23.0);
const paddingOnlyLxsmall = EdgeInsets.only(left: 8.0);
const paddingOnlyL5 = EdgeInsets.only(left: 5.0);
const paddingOnlyLRT = EdgeInsets.only(left: 20.0, right: 20.0, top: 7.0);
const paddingOnlyLR = EdgeInsets.only(left: 13.0, right: 13.0);
const paddingOnlyRTB = EdgeInsets.only(top: 16.0, right: 15.0, bottom: 10.0);
const paddingOnlyT = EdgeInsets.only(top: 30.0);
const paddingOnlyTsmall = EdgeInsets.only(top: 15.0);
const paddingOnlyTSmall = EdgeInsets.only(top: 4.0);
const paddingOnlyR = EdgeInsets.only(right: 25.0);
const paddingOnlyRB = EdgeInsets.only(right: 25.0, bottom: 9.0);
const paddingOnlyRT = EdgeInsets.only(right: 22.0, top: 18.0);
const paddingZero = EdgeInsets.zero;

const marginAll5 = EdgeInsets.all(5.0);
const marginAll8 = EdgeInsets.all(8.0);
const marginOnlyRL = EdgeInsets.only(left: 10.0, right: 10.0);
const marginOnlyB = EdgeInsets.only(bottom: 12.0);
const marginHorizon = EdgeInsets.symmetric(horizontal: 10.0);
const marginHorizon6 = EdgeInsets.symmetric(horizontal: 6.0);
const marginHV = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
const marginZero = EdgeInsets.zero;

const duration300 = Duration(milliseconds: 300);
const duration350 = Duration(milliseconds: 350);
const duration500 = Duration(milliseconds: 500);
const durationDays90 = Duration(days: 90);

final borderRadius24 = BorderRadius.circular(24.0);
final borderRadius12 = BorderRadius.circular(12.0);
final borderRadius6 = BorderRadius.circular(6.0);

final shadow = BoxShadow(
  color: AppColors.lightBg.withValues(alpha: 0.20),
  blurRadius: 7,
  spreadRadius: 0,
  offset: const Offset(0, 9),
);

final textFieldShadow = BoxShadow(
  color: AppColors.greenish.withValues(alpha: 0.25),
  blurRadius: 8,
  spreadRadius: 0,
  offset: Offset(0, 6),
);

final shadowGlass1 = BoxShadow(
  color: Colors.black.withValues(alpha: 0.45),
  blurRadius: 24,
  spreadRadius: 4,
  offset: const Offset(0, 10),
);

final shadowGlass2 = BoxShadow(
  color: Colors.black.withValues(alpha: 0.25),
  blurRadius: 24,
  spreadRadius: -6,
  offset: const Offset(-6, -6),
);

final shadowGlass3 = BoxShadow(
  color: Colors.black.withValues(alpha: 0.35),
  blurRadius: 12,
  spreadRadius: 0,
  offset: const Offset(0, 6),
);

final shadowCard = BoxShadow(
  color: AppColors.neonGreen.withValues(alpha: 0.35),
  blurRadius: 20,
  spreadRadius: 4,
  offset: const Offset(0, 0),
);

final shadow1 = BoxShadow(
  color: Colors.black38,
  blurRadius: 10,
  offset: Offset(0, 4),
);

final buttonGlassBorder = Border.all(
  color: AppColors.lightGrey.withValues(alpha: 0.25),
  width: 1.4,
);

final borderCard = Border.all(
  color: AppColors.neonGreen.withValues(alpha: 0.2),
  width: 1,
);

final cpi = Center(child: CircularProgressIndicator());

final boxDecorLightB = BoxDecoration(
  color: AppColors.lightBlack.withValues(alpha: 0.25),
  borderRadius: borderRadius12,
);

final boxDecorDark = BoxDecoration(
  color: AppColors.dark.withValues(alpha: 1.5),
);

final boxStatisticCharts = BoxDecoration(
  color: AppColors.turquise,
  borderRadius: borderRadius6,
);

final googleSignInGradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: const [0.0, 0.45, 1.0],
    colors: [
      AppColors.neonGreen,
      AppColors.neonGreen.withValues(alpha: 8.0),
      AppColors.neonGreen.withValues(alpha: 0.5),
    ],
  ),
  borderRadius: borderRadius24,
  border: buttonGlassBorder,
  boxShadow: [shadowGlass1, shadowGlass2, shadowGlass3],
);

final boxBGLoginPage = BoxDecoration(
  color: Colors.transparent,
  borderRadius: borderRadius24,
  border: Border.all(color: AppColors.greenish, width: 1.5),
  boxShadow: [shadow],
);

final boxBGRegisterPage = BoxDecoration(
  color: Colors.transparent,
  borderRadius: borderRadius24,
  border: Border.all(color: AppColors.greenish, width: 1.5),
  boxShadow: [shadow],
);

final googleImage = Image.asset(
  AppAssets.googleLogo,
  height: 30,
  width: 30,
  fit: BoxFit.fitHeight,
);

final logoBlack300 = Image.asset(
  AppAssets.logoBlack,
  height: 300,
  width: 300,
  fit: BoxFit.contain,
);

final logoBlack150 = SizedBox(
  width: 150,
  height: 150,
  child: Image.asset(AppAssets.logoBlack, fit: BoxFit.fill),
);

final logoBlack120 = Image.asset(
  AppAssets.logoBlack,
  height: 120,
  width: 120,
  fit: BoxFit.contain,
);

final logoBlack60 = SizedBox(
  width: 60,
  height: 90,
  child: Center(
    child: Image.asset(
      AppAssets.logoBlack,
      width: 60,
      height: 90,
      fit: BoxFit.cover,
    ),
  ),
);

final logoBlack82 = SizedBox(
  width: 82,
  height: 75,
  child: Center(child: Image.asset(AppAssets.logoBlack, fit: BoxFit.contain)),
);

final bgLoginRegister = BoxDecoration(
  image: DecorationImage(
    image: AssetImage(AppAssets.background),
    fit: BoxFit.cover,
    alignment: Alignment.center,
  ),
);

final boxTextField = BoxDecoration(
  borderRadius: borderRadius12,
  border: Border.all(color: AppColors.greenish, width: 1.5),
  boxShadow: [textFieldShadow],
);

final colorSchemeTimeDate = ColorScheme.dark(
  primary: AppColors.neonGreen,
  onPrimary: AppColors.dark,
  surface: AppColors.dark,
  onSurface: AppColors.white,
);

final inputDropDown = InputDecoration(
  filled: true,
  fillColor: AppColors.lightBlack.withValues(alpha: 0.6),
  border: OutlineInputBorder(
    borderRadius: borderRadius12,
    borderSide: BorderSide.none,
  ),
  contentPadding: paddingVH,
);

final outlineInputBorderTF = OutlineInputBorder(
  borderRadius: borderRadius12,
  borderSide: BorderSide.none,
);


