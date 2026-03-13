import 'package:flutter/material.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';

const gapH5 = SizedBox(height: 5.0);
const gapH10 = SizedBox(height: 10.0);
const gapH15 = SizedBox(height: 15.0);
const gapH20 = SizedBox(height: 20.0);
const gapH30 = SizedBox(height: 30.0);
const gapBottom = SizedBox(height: 120);

const gapW5 = SizedBox(width: 5.0);
const gapW10 = SizedBox(width: 10.0);
const gapW12 = SizedBox(width: 12.0);
const gapW35 = SizedBox(width: 35.0);
const gapW48 = SizedBox(width: 48.0);
const gapW70 = SizedBox(width: 70.0);

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
const paddingOnlyLRT = EdgeInsets.only(left: 20.0, right: 20.0, top: 7.0);
const paddingOnlyLR = EdgeInsets.only(left: 13.0, right: 13.0);
const paddingOnlyT = EdgeInsets.only(top: 30.0);
const paddingOnlyTsmall = EdgeInsets.only(top: 15.0);
const paddingOnlyTSmall = EdgeInsets.only(top: 4.0);
const paddingOnlyR = EdgeInsets.only(right: 25.0);
const paddingOnlyRB = EdgeInsets.only(right: 25.0, bottom: 9.0);

const marginAll5 = EdgeInsets.all(5.0);
const marginAll8 = EdgeInsets.all(8.0);
const marginOnlyRL = EdgeInsets.only(left: 10, right: 10);
const marginOnlyB = EdgeInsets.only(bottom: 12.0);
const marginHorizon = EdgeInsets.symmetric(horizontal: 10);
const marginHV = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

final borderRadiusBig = BorderRadius.circular(24);
final borderRadiusSmall = BorderRadius.circular(12);

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
