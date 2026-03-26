import 'package:flutter/material.dart';
import 'package:zsquadfitness/shared/ui/components/border_card.dart';
import 'package:zsquadfitness/shared/ui/components/primary_button.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

/// Confirmation Dialog popup for both succeded booking or cancel booking
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
      shape: RoundedRectangleBorder(borderRadius: borderRadius24),
      backgroundColor: Colors.transparent,
      insetPadding: paddingVH,
      child: BorderCard(
        margin: marginZero,
        alpha: 0.55,
        boxShadow: [shadowGlass1B, shadowGlass2B, shadowGlass3W],
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
                Expanded(child: Text(title, style: AppTextStyles.geist22W)),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.neonPink,
                    size: 28,
                  ),
                  onPressed: onCancel ?? () => Navigator.pop(context),
                ),
              ],
            ),

            Padding(
              padding: paddingOnlyR25,
              child: Text(
                message,
                style: AppTextStyles.geist22W.copyWith(
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
