import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';

class CustomDropdownfield<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final double fontSize;

  const CustomDropdownfield({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      style: TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
      borderRadius: borderRadius24,
      dropdownColor: AppColors.lightBg,
      decoration: inputDropDown,
      items: items,
      onChanged: onChanged,
    );
  }
}
