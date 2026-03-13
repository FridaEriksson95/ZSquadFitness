import 'package:flutter/material.dart';
import 'package:zsquadfitness/utils/components/border_card.dart';
import 'package:zsquadfitness/utils/components/primary_button.dart';
import 'package:zsquadfitness/ui/constants/app_strings.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';

enum ConfirmationType { cancelBooking, bookingSuccess }

class ConfirmationDialog extends StatelessWidget {
  final ConfirmationType type;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.type,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCancel = type == ConfirmationType.cancelBooking;

    final String title = isCancel
        ? AppStrings.confirmCancelBooking
        : AppStrings.bookingSuccess;
    final String message = isCancel
        ? AppStrings.confirmCancelBelow
        : AppStrings.seeYou;

    final String buttonText = isCancel
        ? AppStrings.cancelBooking
        : AppStrings.yourBooking;
    final Color buttonColor = isCancel
        ? AppColors.neonPink
        : AppColors.neonGreen;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: borderRadiusBig),
      backgroundColor: Colors.transparent,
      insetPadding: paddingVH,
      child: BorderCard(
        margin: EdgeInsets.zero,
        alpha: 0.55,
        boxShadow: [shadowGlass1, shadowGlass2, shadowGlass3],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: isCancel ? AppColors.neonPink : AppColors.mediumGrey,
                  size: 28,
                ),
                gapW12,
                Expanded(
                  child: Text(title, style: AppTextStyles.bodyWhiteDialog),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.darkRed,
                    size: 28,
                  ),
                  onPressed: onCancel ?? () => Navigator.pop(context),
                ),
              ],
            ),

            Padding(
              padding: paddingOnlyR,
              child: Text(
                message,
                style: AppTextStyles.bodyWhiteDialog.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                ),
              ),
            ),
            gapH30,

            Align(
              alignment: Alignment.bottomRight,
              child: IntrinsicWidth(
                child: PrimaryButton(
                  text: buttonText,
                  color: buttonColor,
                  onPressed:
                      onConfirm ??
                      () {
                        Navigator.pop(context);
                      },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
