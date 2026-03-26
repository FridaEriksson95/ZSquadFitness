import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/components/border_card.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

/// Summary section shown at the top of booking dialog
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
      padding: paddingH30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header Row: class identity, date/time and availability
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              logoBlack60,
              gapW20,

              Expanded(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      gapH10,
                      Text(
                        classData['title'] ?? AppStrings.zumba,
                        style: AppTextStyles.vidaLoka24G,
                      ),
                      Text(classData['date'] ?? AppStrings.noDate),
                      Text(classData['time'] ?? AppStrings.noTime),
                      if ((classData['room'] as String?)?.isNotEmpty == true)
                        Text(
                          '${AppStrings.roomNr}${classData['room']}',
                          style: AppTextStyles.geist14W.copyWith(fontSize: 10),
                        ),
                    ],
                  ),
                ),
              ),
              gapW12,

              BorderCard(
                padding: paddingAll8,
                margin: marginZero,
                color: AppColors.turquise.withValues(alpha: 0.2),
                border: buttonBorderW,
                boxShadow: [shadowLB, shadowGlass2B, shadowGlass3W],
                child: Column(
                  children: [
                    Text(bookedText, style: AppTextStyles.vidaLoka14LG),
                    Text(
                      '$spotsLeft ${AppStrings.available}',
                      style: AppTextStyles.geist18T.copyWith(
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

          // Location and pricing details
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: paddingOnlyT4,
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
                          style: AppTextStyles.geist18T.copyWith(
                            color: Colors.white,
                          ),
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
                      style: AppTextStyles.geist18T.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                gapH10,

                divider300,
              ],
            ),
          ),
          gapH5,

          // Hide long description when repeat booking section is selected
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
