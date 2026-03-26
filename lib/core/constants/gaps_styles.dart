import 'package:flutter/material.dart';
import 'package:zsquadfitness/shared/ui/theme/app_assets.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';

//Gaps and styles for borders, dividers, boxdecorations etc.

//------------Gap Heights-------------//

const gapH5 = SizedBox(height: 5.0);
const gapH10 = SizedBox(height: 10.0);
const gapH15 = SizedBox(height: 15.0);
const gapH20 = SizedBox(height: 20.0);
const gapH30 = SizedBox(height: 30.0);
const gapH65 = SizedBox(height: 65.0);
const gapBottom = SizedBox(height: 120);

//-----------Gap Widths-------------//

const gapW5 = SizedBox(width: 5.0);
const gapW10 = SizedBox(width: 10.0);
const gapW12 = SizedBox(width: 12.0);
const gapW20 = SizedBox(width: 20.0);
const gapW35 = SizedBox(width: 35.0);
const gapW48 = SizedBox(width: 48.0);
const gapW70 = SizedBox(width: 70.0);

//-----------Dividers-------------//

final divider250 = SizedBox(
  width: 250,
  child: Divider(color: AppColors.neonGreen.withValues(alpha: 0.4)),
);

final divider300 = SizedBox(
  width: 300,
  child: Divider(color: AppColors.neonGreen.withValues(alpha: 0.4)),
);

final divider330 = SizedBox(
  width: 330,
  child: Divider(color: AppColors.neonGreen.withValues(alpha: 0.4)),
);

final divider360 = SizedBox(
  width: 360,
  child: Divider(color: AppColors.neonGreen.withValues(alpha: 0.4)),
);

final dividerGreenish = SizedBox(
  width: 250,
  child: Divider(color: AppColors.greenish),
);

final divider360Greenish = SizedBox(
  width: 360,
  child: Divider(color: AppColors.greenish),
);

//-----------Padding Horizontal-------------//
const paddingH10 = EdgeInsets.symmetric(horizontal: 10.0);
const paddingH16 = EdgeInsets.symmetric(horizontal: 16.0);
const paddingH20 = EdgeInsets.symmetric(horizontal: 20.0);
const paddingH30 = EdgeInsets.symmetric(horizontal: 30.0);
//-----------Padding Vertical-------------//
const paddingV16 = EdgeInsets.symmetric(vertical: 16.0);
const paddingV20 = EdgeInsets.symmetric(vertical: 20.0);
const paddingV40 = EdgeInsets.symmetric(vertical: 40.0);
//-----------Padding Horizontal & Vertical-------------//
const paddingVH = EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0);
//-----------Padding All-------------//
const paddingAll8 = EdgeInsets.all(8.0);
const paddingAll10 = EdgeInsets.all(10.0);
const paddingAll12 = EdgeInsets.all(12.0);
const paddingAll15 = EdgeInsets.all(15.0);
const paddingAll24 = EdgeInsets.all(24.0);
//-----------Padding Only Top-------------//
const paddingOnlyT4 = EdgeInsets.only(top: 4.0);
const paddingOnlyT15 = EdgeInsets.only(top: 15.0);
const paddingOnlyT30 = EdgeInsets.only(top: 30.0);
//-----------Padding Only Right-------------//
const paddingOnlyR25 = EdgeInsets.only(right: 25.0);
//-----------Padding Only Left-------------//
const paddingOnlyL5 = EdgeInsets.only(left: 5.0);
const paddingOnlyL8 = EdgeInsets.only(left: 8.0);
const paddingOnlyL23 = EdgeInsets.only(left: 23.0);
const paddingOnlyL40 = EdgeInsets.only(left: 40.0);
//-----------Padding Only Bottom-------------//
const paddingOnlyB5 = EdgeInsets.only(bottom: 5.0);
const paddingOnlyB10 = EdgeInsets.only(bottom: 10.0);
const paddingOnlyB16 = EdgeInsets.only(bottom: 16.0);
//-----------Padding Only-------------//
const paddingOnlyLR = EdgeInsets.only(left: 13.0, right: 13.0);
const paddingOnlyTB = EdgeInsets.only(top: 13.0, bottom: 8.0);
const paddingOnlyRB = EdgeInsets.only(right: 25.0, bottom: 9.0);
const paddingOnlyRT = EdgeInsets.only(right: 22.0, top: 18.0);
const paddingOnlyLRT = EdgeInsets.only(left: 20.0, right: 20.0, top: 7.0);
const paddingOnlyRTB = EdgeInsets.only(right: 15.0, top: 16.0, bottom: 10.0);
//-----------Padding Zero-------------//
const paddingZero = EdgeInsets.zero;

//-----------Margin All-------------//
const marginAll5 = EdgeInsets.all(5.0);
const marginAll8 = EdgeInsets.all(8.0);
//-----------Margin Only-------------//
const marginOnlyB = EdgeInsets.only(bottom: 12.0);
const marginOnlyRL = EdgeInsets.only(left: 10.0, right: 10.0);
//-----------Margin Horizontal-------------//
const marginHorizon = EdgeInsets.symmetric(horizontal: 10.0);
const marginHorizon6 = EdgeInsets.symmetric(horizontal: 6.0);

const marginHV = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
//-----------Margin Zero-------------//
const marginZero = EdgeInsets.zero;

//-----------Durations-------------//
const duration120 = Duration(milliseconds: 120);
const duration300 = Duration(milliseconds: 300);
const duration350 = Duration(milliseconds: 350);
const duration500 = Duration(milliseconds: 500);
const durationDays90 = Duration(days: 90);

//-----------BorderRadius-------------//
final borderRadius6 = BorderRadius.circular(6.0);
final borderRadius12 = BorderRadius.circular(12.0);
final borderRadius24 = BorderRadius.circular(24.0);

//-----------BoxShadows-------------//
final shadowLB = BoxShadow(
  color: AppColors.lightBg.withValues(alpha: 0.20),
  blurRadius: 7,
  spreadRadius: 0,
  offset: const Offset(0, 9),
);

final shadowGreenish = BoxShadow(
  color: AppColors.greenish.withValues(alpha: 0.25),
  blurRadius: 8,
  spreadRadius: 0,
  offset: Offset(0, 6),
);

final shadowGlass1B = BoxShadow(
  color: Colors.black.withValues(alpha: 0.45),
  blurRadius: 24,
  spreadRadius: 4,
  offset: const Offset(0, 10),
);

final shadowGlass2B = BoxShadow(
  color: Colors.black.withValues(alpha: 0.50),
  blurRadius: 14,
  spreadRadius: 0,
  offset: const Offset(0, 8),
);

final shadowGlass3W = BoxShadow(
  color: Colors.white.withValues(alpha: 0.08),
  blurRadius: 8,
  spreadRadius: -4,
  offset: const Offset(-2, -2),
);

final shadowGlass4NG = BoxShadow(
  color: AppColors.neonGreen.withValues(alpha: 0.30),
  blurRadius: 16,
  spreadRadius: 0.2,
  offset: const Offset(0, 4),
);

final shadowCardNG = BoxShadow(
  color: AppColors.neonGreen.withValues(alpha: 0.35),
  blurRadius: 20,
  spreadRadius: 4,
  offset: const Offset(0, 0),
);

final shadowB38 = BoxShadow(
  color: Colors.black38,
  blurRadius: 10,
  offset: Offset(0, 4),
);

//-----------Borders-------------//
final buttonBorderW = Border.all(
  color: AppColors.white.withValues(alpha: 0.20),
  width: 1.4,
);

final borderCardNG = Border.all(
  color: AppColors.neonGreen.withValues(alpha: 0.2),
  width: 1,
);

//-----------BoxDecorations-------------//
final boxDecorLightB = BoxDecoration(
  color: AppColors.lightBlack.withValues(alpha: 0.25),
  borderRadius: borderRadius12,
);

final boxDecorDark = BoxDecoration(
  color: AppColors.dark.withValues(alpha: 1.5),
);

final boxStatisticChartsT = BoxDecoration(
  color: AppColors.turquise,
  borderRadius: borderRadius6,
);

final googleSignInGradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: const [0.0, 0.15, 0.53, 1.2],
    colors: [
      AppColors.neonGreen.withValues(alpha: 1.0),
      AppColors.neonGreen.withValues(alpha: 0.96),
      AppColors.neonGreen.withValues(alpha: 0.62),
      AppColors.dark.withValues(alpha: 0.94),
    ],
  ),
  borderRadius: borderRadius24,
  border: buttonBorderW,
  boxShadow: [shadowGlass4NG, shadowGlass2B],
);

final boxBGTransparent = BoxDecoration(
  color: Colors.transparent,
  borderRadius: borderRadius24,
  border: Border.all(color: AppColors.greenish, width: 1.5),
  boxShadow: [shadowLB],
);

final boxTextFieldGreenish = BoxDecoration(
  borderRadius: borderRadius12,
  border: Border.all(color: AppColors.greenish, width: 1.5),
  boxShadow: [shadowGreenish],
);

const backgroundGradient1 = DecoratedBox(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.backgroundGradient1,
        AppColors.background,
        AppColors.backgroundGradient2,
      ],
    ),
  ),
);

final backgroundGradient2 = DecoratedBox(
  decoration: BoxDecoration(
    gradient: RadialGradient(
      center: const Alignment(0, 0.2),
      radius: 1.1,
      colors: [AppColors.neonGreen.withValues(alpha: 0.14), Colors.transparent],
    ),
  ),
);

//-----------Image Assets-------------//
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

final logoBlack82 = SizedBox(
  width: 82,
  height: 78,
  child: Center(child: Image.asset(AppAssets.logoBlack, fit: BoxFit.contain)),
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

final bgLoginRegister = BoxDecoration(
  image: DecorationImage(
    image: AssetImage(AppAssets.background),
    fit: BoxFit.cover,
    alignment: Alignment.center,
  ),
);

//-----------Input decorations-------------//
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

final outlinedButtonNG = OutlinedButton.styleFrom(
  foregroundColor: AppColors.neonGreen,
  side: BorderSide(color: AppColors.neonGreen),
);

//-----------Lines-------------//
final goldLineLeft = Container(
  height: 1,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.transparent, AppColors.gold.withValues(alpha: 0.45)],
    ),
  ),
);

final goldLineRight = Expanded(
  child: Container(
    height: 1,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.gold.withValues(alpha: 0.45), Colors.transparent],
      ),
    ),
  ),
);

//-----------ColorScheme-------------//
final colorSchemeTimeDate = ColorScheme.dark(
  primary: AppColors.neonGreen,
  onPrimary: AppColors.dark,
  surface: AppColors.dark,
  onSurface: AppColors.white,
);

//-----------Circular Progressor-------------//
final cpi = Center(child: CircularProgressIndicator());
