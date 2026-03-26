import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zsquadfitness/features/profile/views/edit_profile_dialog.dart';

/// Parsed result from EditProfileDialog actions
class EditProfileResult {
  final bool updated;
  final bool readyToDelete;
  final String? password;

  const EditProfileResult({
    this.updated = false,
    this.readyToDelete = false,
    this.password,
  });
}

/// Opens edit dialog and maps raw dialog output to a typed result object
class ProfileDialogHelper {
  static Future<EditProfileResult?> openEditDialog(
    BuildContext context, {
    required User user,
    required Map<String, dynamic>? userData,
  }) async {
    final result = await showDialog(
      context: context,
      builder: (_) => EditProfileDialog(user: user, userData: userData),
    );

    if (result == true) {
      return const EditProfileResult(updated: true);
    }

    if (result is Map<String, dynamic> && result['action'] == 'readyToDelete') {
      return EditProfileResult(
        readyToDelete: true,
        password: result['password'] as String?,
      );
    }
    return null;
  }
}
