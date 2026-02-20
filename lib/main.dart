import 'package:flutter/material.dart';
import 'package:zsquadfitness/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zsquadfitness/pages/signup.dart';
import 'package:zsquadfitness/services/auth_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AuthWrapper());
  }
}
