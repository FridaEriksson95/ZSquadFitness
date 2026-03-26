import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/core/services/auth.dart';
import 'package:zsquadfitness/shared/ui/components/custom_textfield.dart';
import 'package:zsquadfitness/shared/ui/components/primary_button.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

/// Opens a reset password dialog and send Firebase reset email
Future<void> showResetPasswordDialog(BuildContext context) async {
  final TextEditingController resetEmailController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  bool emailSent = false;

  await showDialog(
    context: context,
    builder: (dialogContext) {
      // Dialog state with loading, error, sent that's handled inside the dialog
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: borderRadius24),
            contentPadding: paddingAll24,
            backgroundColor: AppColors.background.withValues(alpha: 0.9),
            titlePadding: paddingOnlyLRT,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  emailSent ? AppStrings.emailSent : AppStrings.forgotPW,
                  style: AppTextStyles.vidaLoka32T.copyWith(
                    color: AppColors.neonGreen,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  icon: const Icon(Icons.close, color: AppColors.neonPink),
                  padding: paddingOnlyL40,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            content: emailSent
                ? Padding(
                    padding: paddingOnlyB10,
                    child: Text(
                      AppStrings.checkEmail,
                      style: AppTextStyles.geist16LG,
                      textAlign: TextAlign.center,
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.submitEmailLink,
                        style: AppTextStyles.vidaLoka14LG,
                      ),
                      gapH15,
                      CustomTextfield(
                        labelText: AppStrings.email,
                        keyboardType: TextInputType.emailAddress,
                        controller: resetEmailController,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.lightGrey,
                        ),
                      ),
                      if (errorMessage != null) ...[
                        gapH10,
                        Text(
                          errorMessage!,
                          style: AppTextStyles.vidaLoka14LG.copyWith(
                            color: AppColors.darkRed,
                          ),
                        ),
                      ],
                    ],
                  ),
            actionsPadding: paddingOnlyLRT,
            actions: [
              PrimaryButton(
                text: emailSent
                    ? (isLoading
                          ? AppStrings.sendingAgainLoad
                          : AppStrings.sendAgain)
                    : (isLoading
                          ? AppStrings.sendingLoad
                          : AppStrings.sendLink),
                color: AppColors.turquise,
                // Validates input, triggers reset email then show sent/error state
                onPressed: isLoading
                    ? null
                    : () async {
                        final email = resetEmailController.text.trim();

                        if (email.isEmpty) {
                          setDialogState(() {
                            errorMessage = AppStrings.errorSubmitEmail;
                          });
                          return;
                        }

                        setDialogState(() {
                          isLoading = true;
                          errorMessage = null;
                        });

                        try {
                          await AuthService().sendPasswordResetEmail(email);
                          setDialogState(() {
                            emailSent = true;
                            isLoading = false;
                          });
                        } catch (e) {
                          setDialogState(() {
                            errorMessage = e.toString().replaceFirst(
                              AppStrings.exception,
                              '',
                            );
                            isLoading = false;
                          });
                        }
                      },
              ),

              gapH20,
            ],
          );
        },
      );
    },
  );

  resetEmailController.dispose();
}
