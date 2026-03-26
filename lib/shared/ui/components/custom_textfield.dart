import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

/// Customized TextField for reuse purpose
class CustomTextfield extends StatelessWidget {
  final String labelText;
  final TextStyle? labelStyle;
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
    this.labelStyle,
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
      decoration: boxTextFieldGreenish,
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
        style: AppTextStyles.geist16LG,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: labelStyle ?? AppTextStyles.geist16LG,
          filled: true,
          fillColor: AppColors.greenish.withValues(alpha: 0.03),
          border: outlineInputBorderTF,
          enabledBorder: outlineInputBorderTF,
          focusedBorder: outlineInputBorderTF,
          prefixIcon: prefixIcon,
          contentPadding: paddingAll15,
        ),
      ),
    );
  }
}
