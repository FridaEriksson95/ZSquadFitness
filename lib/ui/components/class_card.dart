import 'package:flutter/material.dart';
import 'package:zsquadfitness/ui/components/primary_button.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_assets.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';

class ClassCard extends StatelessWidget {
  final String date;
  final String time;
  final int spotsLeft;
  final bool isBooked;
  final VoidCallback? onBookTap;

  const ClassCard({
    super.key,
    required this.date,
    required this.time,
    required this.spotsLeft,
    required this.isBooked,
    this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date.toUpperCase(), style: AppTextStyles.vG),
        gapH15,

        Container(
          padding: paddingAll15,
          decoration: BoxDecoration(
            color: AppColors.lightBlack.withValues(alpha: 0.45),
            borderRadius: borderRadiusBig,
            border: borderCard,
            boxShadow: [textFieldShadow],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,

                child: Center(
                  child: Image.asset(
                    AppAssets.logoBlack,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              gapW12,

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Zumba', style: AppTextStyles.vT),
                    gapH5,
                    Text(time, style: AppTextStyles.bodyWhiteBold),
                    gapH5,
                    Row(
                      children: [
                        Text(
                          '$spotsLeft',
                          style: AppTextStyles.bodyWhiteThin.copyWith(
                            color: AppColors.neonGreen,
                          ),
                        ),
                        Text(
                          ' platser kvar',
                          style: AppTextStyles.bodyWhiteThin,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              gapW12,
              SizedBox(
                width: 100,
                child: Padding(
                  padding: paddingOnlyTB,
                  child: PrimaryButton(
                    text: isBooked ? 'BOKAD' : 'BOKA',
                    onPressed: isBooked ? null : onBookTap,
                    color: isBooked ? AppColors.lightGrey : AppColors.neonGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
        gapH10,
      ],
    );
  }
}
