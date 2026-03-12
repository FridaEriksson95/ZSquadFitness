import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zsquadfitness/ui/constants/app_strings.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';

Future<void> openEmail(BuildContext context) async {
  final Uri emailUri = Uri(
    scheme: AppStrings.mailTo,
    path: AppStrings.zSquadMail,
    queryParameters: {AppStrings.subject: AppStrings.zSquadApp},
  );

  try {
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.neonPink.withValues(alpha: 0.5),
            content: Text(AppStrings.cantOpenEmail),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  } catch (e) {
    debugPrint('${AppStrings.errorOpeningEmail} $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.neonPink.withValues(alpha: 0.5),
          content: Text(AppStrings.errorOpeningEmailMessage),
        ),
      );
    }
  }
}
