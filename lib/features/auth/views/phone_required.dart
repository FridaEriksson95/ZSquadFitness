import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';
import 'package:zsquadfitness/shared/ui/components/custom_appbar.dart';
import 'package:zsquadfitness/shared/ui/components/custom_textfield.dart';
import 'package:zsquadfitness/shared/ui/components/primary_button.dart';
import 'package:zsquadfitness/core/utils/phone_validator.dart';

class PhoneRequiredPage extends StatefulWidget {
  final String userId;

  const PhoneRequiredPage({super.key, required this.userId});

  @override
  State<PhoneRequiredPage> createState() => _PhoneRequiredPageState();
}

class _PhoneRequiredPageState extends State<PhoneRequiredPage> {
  final _controller = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final phone = _controller.text.trim();
    final error = validatePhone(phone);
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    setState(() => _saving = true);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .update({'Phone': phone});
    setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: CustomAppbar(),
        body: Center(
          child: Padding(
            padding: paddingOnlyLRT.copyWith(bottom: 130),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.needPhoneNr,
                  style: AppTextStyles.bodyWhiteDialog,
                  textAlign: TextAlign.center,
                ),
                gapH15,
                CustomTextfield(
                  labelText: AppStrings.phone,
                  controller: _controller,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(
                    Icons.phone_android_rounded,
                    color: AppColors.lightGrey,
                  ),
                  restrictToDigits: true,
                ),
                gapH30,
                PrimaryButton(
                  text: AppStrings.save,
                  color: AppColors.neonGreen,
                  onPressed: _saving ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
