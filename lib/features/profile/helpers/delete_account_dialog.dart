import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';

/// Result object returned from delete-account confirmation dialog
class DeleteAccountDialog {
  final String? password;

  const DeleteAccountDialog({this.password});
}

/// Opens confirmation dialog and collects password for password based users
class DeleteAccountDialogHelper {
  static Future<DeleteAccountDialog?> show(
    BuildContext context, {
    required User user,
  }) async {
    final providerIds = user.providerData.map((p) => p.providerId).toSet();
    final isPasswordUser = providerIds.contains('password');

    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final ok = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) {
        String? dialogError;

        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            backgroundColor: AppColors.background,
            title: Text(AppStrings.deleteAccount),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    AppStrings.deleteInfo,
                    style: TextStyle(color: AppColors.lightGrey),
                    textAlign: TextAlign.center,
                  ),
                  if (isPasswordUser) ...[
                    const SizedBox(height: 16),
                    Form(
                      key: formKey,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: AppStrings.confirmPW,
                          errorText: dialogError,
                        ),
                        validator: (v) => (v == null || v.isEmpty)
                            ? AppStrings.submitPW
                            : null,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(
                  AppStrings.cancel,
                  style: TextStyle(color: AppColors.neonPink),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (isPasswordUser && !formKey.currentState!.validate()) {
                    return;
                  }
                  Navigator.pop(dialogContext, true);
                },

                child: Text(
                  AppStrings.delete,
                  style: TextStyle(color: AppColors.darkRed),
                ),
              ),
            ],
          ),
        );
      },
    );

    // Dispose controller after dialog frame completes to avoid dispose-timing issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      passwordController.dispose();
    });

    if (ok != true) return null;
    return DeleteAccountDialog(
      password: isPasswordUser ? passwordController.text.trim() : null,
    );
  }
}
