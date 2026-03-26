import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/services/profile_service.dart';
import 'package:zsquadfitness/features/profile/helpers/delete_account_dialog.dart';
import 'package:zsquadfitness/shared/ui/components/custom_textfield.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';
import 'package:zsquadfitness/core/utils/phone_validator.dart';

class EditProfileDialog extends StatefulWidget {
  final User user;
  final Map<String, dynamic>? userData;

  const EditProfileDialog({
    super.key,
    required this.user,
    required this.userData,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  final _profileEditorService = ProfileEditorService();
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final data = widget.userData ?? {};
    _nameController = TextEditingController(
      text: (data['Name'] as String?) ?? widget.user.displayName ?? '',
    );
    _emailController = TextEditingController(
      text: (data['Email'] as String?) ?? widget.user.email ?? '',
    );
    _phoneController = TextEditingController(
      text: (data['Phone'] as String?) ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

/// Validates email and phone inputs before saving profile changes
  String? _validateInputs({required String email, required String phone}) {
    if (email.isEmpty) return AppStrings.submitEmail;
    if (phone.isEmpty) return AppStrings.phoneReq;
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return AppStrings.errorEmail;
    }
    return validatePhone(phone);
  }

/// Saves profile updates and closes dialog on success
  Future<void> _save() async {
    setState(() {
      _isSaving = true;
      _error = null;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isSaving = false;
        _error = AppStrings.loginRequired;
      });
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    final validationError = _validateInputs(email: email, phone: phone);
    if (validationError != null) {
      setState(() {
        _isSaving = false;
        _error = validationError;
      });
      return;
    }

    try {
      await _profileEditorService.saveProfile(
        user: user,
        name: name,
        email: email,
        phone: phone,
        existingUserData: widget.userData,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isSaving = false;
      });
    }
  }

/// Opens delete account confirmation and returns delete action to parent page
  Future<void> _confirmDeleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final res = await DeleteAccountDialogHelper.show(context, user: user);
    if (res == null || !mounted) return;

    Navigator.of(
      context,
      rootNavigator: true,
    ).pop({'action': 'readyToDelete', 'password': res.password});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppStrings.editProfileTitle,
        style: AppTextStyles.vidaLoka24T,
      ),
      backgroundColor: AppColors.background.withValues(alpha: 1.0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextfield(
              labelText: AppStrings.name,
              labelStyle: AppTextStyles.geist18T,
              controller: _nameController,
            ),
            gapH10,
            CustomTextfield(
              labelText: AppStrings.email,
              labelStyle: AppTextStyles.geist18T,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            gapH10,
            CustomTextfield(
              labelText: AppStrings.phone,
              labelStyle: AppTextStyles.geist18T,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            if (_error != null) ...[
              gapH5,
              Text(
                _error!,
                style: AppTextStyles.vidaLoka14LG.copyWith(
                  color: AppColors.neonPink,
                ),
              ),
            ],
            gapH15,
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: _isSaving ? null : _confirmDeleteAccount,
                style: TextButton.styleFrom(
                  padding: paddingOnlyL8,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  AppStrings.deleteAccountCaps,
                  style: AppTextStyles.geist14W.copyWith(
                    color: AppColors.darkRed,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.darkRed,
                    decorationThickness: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context, false),
          child: Text(
            AppStrings.cancel,
            style: AppTextStyles.geist14W.copyWith(color: AppColors.neonPink),
          ),
        ),
        TextButton(
          onPressed: _isSaving ? null : _save,
          child: Text(
            _isSaving ? AppStrings.saving : AppStrings.save,
            style: AppTextStyles.geist14W.copyWith(color: AppColors.neonGreen),
          ),
        ),
      ],
    );
  }
}
