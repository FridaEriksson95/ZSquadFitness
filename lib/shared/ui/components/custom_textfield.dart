import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zsquadfitness/core/constants/gaps.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

class CustomTextfield extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool restrictToDigits;

  const CustomTextfield({
    super.key,
    required this.labelText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.focusNode,
    this.restrictToDigits = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius12,
        border: Border.all(color: AppColors.greenish, width: 1.5),
        boxShadow: [textFieldShadow],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        textInputAction: textInputAction,
        focusNode: focusNode,
        onChanged: onChanged,
        inputFormatters: restrictToDigits
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(12),
              ]
            : null,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: AppTextStyles.bodyMedium,
          filled: true,
          fillColor: AppColors.greenish.withValues(alpha: 0.03),
          border: OutlineInputBorder(
            borderRadius: borderRadius12,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius12,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius12,
            borderSide: BorderSide.none,
          ),
          prefixIcon: prefixIcon,
          contentPadding: paddingAll15,
        ),
      ),
    );
  }
}
