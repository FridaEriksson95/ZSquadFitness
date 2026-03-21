import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/gaps.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius24,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 24),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.45, 1.0],
              colors: [
                color,
                color.withValues(alpha: 8.0),
                color.withValues(alpha: 0.3),
              ],
            ),
            borderRadius: borderRadius24,
            border: buttonGlassBorder,
            boxShadow: [shadowGlass1, shadowGlass2, shadowGlass3],
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style:
                ElevatedButton.styleFrom(
                  backgroundColor: color.withValues(alpha: 0.25),
                  foregroundColor: AppColors.lightBlack,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  padding: paddingAll8,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius24),
                ).copyWith(
                  overlayColor: WidgetStateProperty.all(
                    Colors.white.withValues(alpha: 0.15),
                  ),
                ),
            child: Text(
              text,
              style: AppTextStyles.buttonText.copyWith(
                color: AppColors.lightBlack,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
