import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  double widthPercent(double percent) => screenWidth * percent;
  double heightPercent(double percent) => screenHeight * percent;
}
