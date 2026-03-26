import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zsquadfitness/core/services/auth_wrapper.dart';
import 'package:zsquadfitness/shared/ui/components/noise_overlay.dart';
import 'package:zsquadfitness/shared/ui/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDateFormatting('sv_SE', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Main file to set local timezone and overlay for background
  /// wrapped with AuthWrapper to navigate through pages
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: const Locale('sv', 'SE'),
      supportedLocales: const [Locale('sv', 'SE'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Stack(
          children: [
            const Positioned.fill(child: backgroundGradient1),

            Positioned.fill(child: backgroundGradient2),
            child ?? const SizedBox.shrink(),
            Positioned.fill(
              child: NoiseOverlay(opacity: 0.5, density: 6500, seed: 42),
            ),
          ],
        );
      },
      home: const AuthWrapper(),
    );
  }
}
