import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zsquadfitness/core/services/database.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? get currentUser => auth.currentUser;

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential result = await auth.signInWithCredential(credential);

      final User userDetails = result.user!;
      final userInfoMap = {
        "Name": userDetails.displayName ?? AppStrings.zsquader,
        "Email": userDetails.email,
        "Id": userDetails.uid,
        'createdAt': DateTime.now().toIso8601String(),
      };
      await DatabaseService().addUserData(userInfoMap, userDetails.uid);

      return userDetails;
    } on FirebaseAuthException {
      return null;
    }
  }

  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User userDetails = result.user!;
      await userDetails.updateDisplayName(name.trim());

      final userInfoMap = {
        "Name": name.trim(),
        "Email": userDetails.email,
        "Id": userDetails.uid,
        "Phone": phone.trim(),
        'createdAt': DateTime.now().toIso8601String(),
      };
      await DatabaseService().addUserData(userInfoMap, userDetails.uid);

      return userDetails;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = AppStrings.emailInUse;
          break;
        case 'weak-password':
          errorMessage = AppStrings.weakPW;
          break;
        case 'invalid-email':
          errorMessage = AppStrings.errorEmail;
          break;
        default:
          errorMessage = '${AppStrings.registerFail}  ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('${AppStrings.unknownError} $e');
    }
  }

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User userDetails = result.user!;

      return userDetails;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = AppStrings.noUser;
          break;
        case 'wrong-password':
          errorMessage = AppStrings.wrongPW;
          break;
        case 'invalid-email':
          errorMessage = AppStrings.errorEmail;
          break;
        case 'user-disabled':
          errorMessage = AppStrings.accountClosed;
          break;
        default:
          errorMessage = '${AppStrings.signinFail}  ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('${AppStrings.unknownError} $e');
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    await GoogleSignIn().signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = AppStrings.noUser;
          break;
        case 'invalid-email':
          errorMessage = AppStrings.errorEmail;
          break;
        default:
          errorMessage = '${AppStrings.failResetLink} ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('${AppStrings.unknownError} $e');
    }
  }

  Future<void> deleteAccount({String? password}) async {
    final user = auth.currentUser;
    if (user == null) throw Exception(AppStrings.loginRequired);

    final providerIds = user.providerData.map((p) => p.providerId).toSet();

    if (providerIds.contains('password')) {
      if (password == null || password.isEmpty) {
        throw Exception(AppStrings.pwReq);
      }
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(cred);
    } else if (providerIds.contains('google.com')) {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw Exception(AppStrings.googleSignInCancel);

      final googleAuth = await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await user.reauthenticateWithCredential(cred);
    }

    final callable = FirebaseFunctions.instanceFor(
      region: 'europe-west1',
    ).httpsCallable('deleteUserAccountData');

    await callable.call();

    await signOut();
  }
}
