import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/services/auth.dart';
import 'package:zsquadfitness/shared/ui/components/snackbar_utils.dart';

/// Wraps email/password sign in and surfaces errors via snackbar
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
      showAppSnackBar(context, message: '${AppStrings.signinFail} $e');
    }
    return false;
  }
}

/// Wraps Google sign in flow and returns success status or error Snackbar
Future<bool> performGoogleSignIn(BuildContext context) async {
  try {
    final user = await AuthService().signInWithGoogle(context);
    return user != null;
  } catch (e) {
    if (context.mounted) {
      showAppSnackBar(context, message: '${AppStrings.registerFailGoogle} $e');
    }
    return false;
  }
}

/// Wraps registration flow and shows user error snackbar on failure
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
      showAppSnackBar(context, message: '${AppStrings.registerFail} $e');
    }
    return false;
  }
}
