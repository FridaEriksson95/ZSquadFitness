import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/services/database.dart';
import 'package:zsquadfitness/shared/ui/components/custom_textfield.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps.dart';
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

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
      _error = null;
    });

    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
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

    if (email.isEmpty) {
      setState(() {
        _isSaving = false;
        _error = AppStrings.submitEmail;
      });
      return;
    }

    if (phone.isEmpty) {
      setState(() {
        _isSaving = false;
        _error = AppStrings.phoneReq;
      });
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        _isSaving = false;
        _error = AppStrings.errorEmail;
      });
      return;
    }

    final phoneError = validatePhone(phone);
    if (phoneError != null) {
      setState(() {
        _isSaving = false;
        _error = phoneError;
      });
      return;
    }

    try {
      if (name.isNotEmpty && name != (user.displayName ?? '')) {
        await user.updateDisplayName(name);
      }
      if (email.isNotEmpty && email != (user.email ?? '')) {
        await user.verifyBeforeUpdateEmail(email);
      }

      final userInfoMap = {
        'Name': name.isNotEmpty ? name : (widget.userData?['Name'] ?? ''),
        'Email': email.isNotEmpty ? email : (widget.userData?['Email'] ?? ''),
        'Phone': phone,
      };
      await DatabaseService().addUserData(userInfoMap, user.uid);

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isSaving = false;
      });
    }
  }

  Future<void> _confirmDeleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

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

    void disposeLater(TextEditingController c) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        c.dispose();
      });
    }

    if (ok != true) {
      disposeLater(passwordController);
      return;
    }
    final password = isPasswordUser ? passwordController.text.trim() : null;
    disposeLater(passwordController);

    if (!mounted) return;

    Navigator.of(
      context,
      rootNavigator: true,
    ).pop({'action': 'readyToDelete', 'password': password});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppStrings.editProfileTitle, style: AppTextStyles.h2),
      backgroundColor: AppColors.background.withValues(alpha: 1.0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextfield(
              labelText: AppStrings.name,
              controller: _nameController,
            ),
            gapH10,
            CustomTextfield(
              labelText: AppStrings.email,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            gapH10,
            CustomTextfield(
              labelText: AppStrings.phone,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            if (_error != null) ...[
              gapH5,
              Text(
                _error!,
                style: AppTextStyles.bodySmall.copyWith(
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
                  padding: paddingOnlyLxsmall,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  AppStrings.deleteAccountCaps,
                  style: AppTextStyles.bodyWhiteSmall.copyWith(
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
            style: AppTextStyles.bodyWhiteSmall.copyWith(
              color: AppColors.neonPink,
            ),
          ),
        ),

        TextButton(
          onPressed: _isSaving ? null : _save,
          child: Text(
            _isSaving ? AppStrings.saving : AppStrings.save,
            style: AppTextStyles.bodyWhiteSmall.copyWith(
              color: AppColors.neonGreen,
            ),
          ),
        ),
      ],
    );
  }
}
