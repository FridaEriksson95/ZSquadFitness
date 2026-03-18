import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps.dart';
import 'package:zsquadfitness/shared/ui/components/border_card.dart';
import 'package:zsquadfitness/shared/ui/theme/app_assets.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

class BookingDialogSummary extends StatelessWidget {
  final Map<String, dynamic> classData;
  final String bookedText;
  final int spotsLeft;
  final bool repeatBooking;

  const BookingDialogSummary({
    super.key,
    required this.classData,
    required this.bookedText,
    required this.spotsLeft,
    required this.repeatBooking,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingH20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
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
              ),

              Expanded(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gapH10,
                      Text(
                        classData['title'] ?? AppStrings.zumba,
                        style: AppTextStyles.hT,
                      ),
                      gapH5,
                      Text(classData['date'] ?? AppStrings.noDate),
                      Text(classData['time'] ?? AppStrings.noTime),
                      if ((classData['room'] as String?)?.isNotEmpty == true)
                        Text(
                          '${AppStrings.roomNr}${classData['room']}',
                          style: AppTextStyles.bodyWhiteSmall.copyWith(
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              gapW12,

              BorderCard(
                padding: paddingAll8,
                margin: EdgeInsets.zero,
                color: AppColors.turquise.withValues(alpha: 0.2),
                border: buttonGlassBorder,
                boxShadow: [shadow, shadowGlass2, shadowGlass3],
                child: Column(
                  children: [
                    Text(bookedText, style: AppTextStyles.bodySmall),
                    Text(
                      '$spotsLeft ${AppStrings.available}',
                      style: AppTextStyles.hT.copyWith(
                        color: AppColors.neonGreen.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          gapH20,
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: paddingOnlyTSmall,
                      child: Icon(
                        Icons.pin_drop_rounded,
                        color: AppColors.gold,
                        size: 20,
                      ),
                    ),
                    gapW5,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classData['locationName'] ?? AppStrings.noLocation,
                          style: AppTextStyles.hT.copyWith(color: Colors.white),
                        ),
                        gapH5,
                        Text(
                          classData['locationAddress'] ?? AppStrings.noAddress,
                          style: TextStyle(fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                  ],
                ),

                gapH10,

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.phonelink_ring_rounded,
                      color: AppColors.gold,
                      size: 20,
                    ),
                    gapW5,
                    Text(
                      '${classData['priceSingle'] ?? AppStrings.priceSingle} ${AppStrings.perClass}  |  ${classData['price10Card'] ?? AppStrings.tenCard} ${AppStrings.perTenCard} ',
                      style: AppTextStyles.hT.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                gapH10,

                SizedBox(
                  width: 300,
                  child: Divider(
                    color: AppColors.neonGreen.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          gapH5,

          if (!repeatBooking) ...[
            Text(
              classData['description'] ?? AppStrings.noDesc,
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            gapH15,
          ],
        ],
      ),
    );
  }
}
