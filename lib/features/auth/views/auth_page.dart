import 'package:flutter/material.dart';
import 'package:zsquadfitness/features/auth/views/register.dart';
import 'package:zsquadfitness/features/auth/views/signin.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLogin = true;

  void toggleView() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return SignInPage(onToggle: toggleView);
    } else {
      return RegisterAccountPage(onToggle: toggleView);
    }
  }
}
