import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zsquadfitness/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zsquadfitness/services/auth_wrapper.dart';
import 'package:zsquadfitness/ui/theme/app_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: const Locale('sv', 'SE'),
      home: const AuthWrapper(),
    );
  }
}
