import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/shared/ui/components/snackbar_utils.dart';

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
        showAppSnackBar(context, message: AppStrings.cantOpenEmail);
      }
    }
  } catch (e) {
    debugPrint('${AppStrings.errorOpeningEmail} $e');
    if (context.mounted) {
      showAppSnackBar(context, message: AppStrings.errorOpeningEmailMessage);
    }
  }
}

Future<void> openEmailToClients(
  BuildContext context, {
  required List<String> emails,
  String? subject,
}) async {
  final validEmails = emails
      .where((e) => e.isNotEmpty && e != AppStrings.unknown && e.contains('@'))
      .toList();
  if (validEmails.isEmpty) {
    if (context.mounted) {
      showAppSnackBar(context, message: AppStrings.noEmailsToSendTo);
    }
    return;
  }
  final emailUri = Uri(
    scheme: AppStrings.mailTo,
    path: validEmails.join(','),
    queryParameters: subject != null ? {'subject': subject} : null,
  );
  try {
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        showAppSnackBar(context, message: AppStrings.cantOpenEmail);
      }
    }
  } catch (e) {
    debugPrint('${AppStrings.errorOpeningEmail} $e');
    if (context.mounted) {
      showAppSnackBar(context, message: AppStrings.errorOpeningEmailMessage);
    }
  }
}
