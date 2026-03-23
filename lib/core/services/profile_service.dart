import 'package:firebase_auth/firebase_auth.dart';
import 'package:zsquadfitness/core/services/database.dart';

class ProfileEditorService {
  Future<void> saveProfile({
    required User user,
    required String name,
    required String email,
    required String phone,
    required Map<String, dynamic>? existingUserData,
  }) async {
    if (name.isNotEmpty && name != (user.displayName ?? '')) {
      await user.updateDisplayName(name);
    }

    if (email.isEmpty && email != (user.email ?? '')) {
      await user.verifyBeforeUpdateEmail(email);
    }

    final userInfoMap = {
      'Name': name.isNotEmpty ? name : (existingUserData?['Name'] ?? ''),
      'Email': email.isNotEmpty ? email : (existingUserData?['Email'] ?? ''),
      'Phone': phone,
    };
    await DatabaseService().addUserData(userInfoMap, user.uid);
  }
}
