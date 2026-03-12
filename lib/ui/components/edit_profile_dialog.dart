import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/services/database.dart';
import 'package:zsquadfitness/ui/components/custom_textfield.dart';
import 'package:zsquadfitness/ui/constants/app_strings.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppStrings.editProfileTitle, style: AppTextStyles.h2),
      backgroundColor: AppColors.background.withValues(alpha: 1.0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextfield(labelText: 'Namn', controller: _nameController),
            gapH10,
            CustomTextfield(
              labelText: 'Epost',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            gapH10,
            CustomTextfield(
              labelText: 'Telefonnummer',
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
