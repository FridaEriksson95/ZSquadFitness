import 'package:flutter/material.dart';
import 'package:zsquadfitness/features/bookings/views/booking_dialog.dart';
import 'package:zsquadfitness/shared/ui/components/border_card.dart';
import 'package:zsquadfitness/shared/ui/components/primary_button.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

class ClassCard extends StatelessWidget {
  final Map<String, dynamic> classData;
  final String classId;
  final bool isBooked;

  const ClassCard({
    super.key,
    required this.classData,
    required this.classId,
    required this.isBooked,
  });

  @override
  Widget build(BuildContext context) {
    final spotsLeft =
        (classData['spotsTotal'] ?? 0) - (classData['spotsBooked'] ?? 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (classData['date'] ?? AppStrings.noDate).toUpperCase(),
          style: AppTextStyles.vidaLoka22T,
        ),
        gapH5,

        BorderCard(
          padding: paddingAll10,
          alpha: 0.07,
          boxShadow: [shadowGreenish],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              logoBlack82,
              gapW12,

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classData['title'] ?? AppStrings.zumba,
                      style: AppTextStyles.vidaLoka20G,
                    ),
                    Text(
                      classData['time'] ?? AppStrings.noTime,
                      style: AppTextStyles.vidaLoka16W,
                    ),
                    gapH10,
                    Row(
                      children: [
                        Text(
                          '$spotsLeft',
                          style: AppTextStyles.vidaLoka14Wthin.copyWith(
                            color: AppColors.neonGreen,
                          ),
                        ),
                        Text(
                          AppStrings.spotsLeft,
                          style: AppTextStyles.vidaLoka14Wthin,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              gapW12,

              _buildBookButton(context, booked: isBooked),
            ],
          ),
        ),
        gapH5,
      ],
    );
  }

  // Widget to show "boka" or "bokad" depending on state
  Widget _buildBookButton(BuildContext context, {required bool booked}) {
    return SizedBox(
      width: 100,
      child: Padding(
        padding: paddingOnlyTB,
        child: PrimaryButton(
          text: booked ? AppStrings.booked : AppStrings.book,
          onPressed: booked
              ? null
              : () {
                  showDialog(
                    context: context,
                    builder: (context) => BookingDialog(
                      parentContext: context,
                      classId: classId,
                      classData: classData,
                    ),
                  );
                },
          color: booked ? AppColors.lightGrey : AppColors.neonGreen,
        ),
      ),
    );
  }
}
