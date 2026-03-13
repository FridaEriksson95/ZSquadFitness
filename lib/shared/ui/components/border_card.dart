import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/gaps.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';

class BorderCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? alpha;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final Color? color;

  const BorderCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.alpha,
    this.boxShadow,
    this.border,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? marginAll5,
      padding: padding ?? paddingAll15,
      decoration: BoxDecoration(
        color: color ?? AppColors.dark.withValues(alpha: alpha),
        borderRadius: borderRadiusBig,
        border: border ?? borderCard,
        boxShadow: boxShadow ?? [shadow],
      ),
      child: child,
    );
  }
}
