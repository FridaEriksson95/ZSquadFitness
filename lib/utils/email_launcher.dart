import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';

Future<void> openEmail(BuildContext context) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: 'info.zsquadfitness@gmail.com',
    queryParameters: {'subject': 'ZSquadAppen'},
  );

  try {
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.neonPink.withValues(alpha: 0.5),
            content: Text(
              'Kunde inte öppna mejlappen. Skriv manuellt till info.zsquadfitness@gmail.com',
            ),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  } catch (e) {
    debugPrint('Fel vid öppning av mejl: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.neonPink.withValues(alpha: 0.5),
          content: Text('Kunde inte öppna mejl. Kontrollera din mejl app.'),
        ),
      );
    }
  }
}
