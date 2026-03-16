import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/services/auth.dart';

Future<bool> performEmailSignin(
  BuildContext context, {
  required String email,
  required String password,
}) async {
  try {
    await AuthService().signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return true;
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${AppStrings.signinFail} $e')));
    }
    return false;
  }
}

Future<bool> performGoogleSignIn(BuildContext context) async {
  try {
    final user = await AuthService().signInWithGoogle(context);
    return user != null;
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppStrings.registerFailGoogle} $e')),
      );
    }
    return false;
  }
}

Future<bool> performRegister(
  BuildContext context, {
  required String email,
  required String password,
  required String name,
  required String phone,
}) async {
  try {
    await AuthService().registerWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );
    return true;
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${AppStrings.registerFail} $e')));
    }
    return false;
  }
}
