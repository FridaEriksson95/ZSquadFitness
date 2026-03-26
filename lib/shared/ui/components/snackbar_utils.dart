import 'package:flutter/material.dart';

///SnackBar helper for reuse purpose
void showAppSnackBar(
  BuildContext context, {
  required String message,
  Color? backgroundColor,
  Duration? duration,
}) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: duration ?? const Duration(seconds: 4),
    ),
  );
}
