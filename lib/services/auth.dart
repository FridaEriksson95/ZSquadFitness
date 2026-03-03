import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zsquadfitness/services/database.dart';

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
        "Name": userDetails.displayName ?? 'Användare',
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
          errorMessage = 'Eposten används redan.';
          break;
        case 'weak-password':
          errorMessage = 'Lösenordet är för svagt (minst 8 tecken)';
          break;
        case 'invalid-email':
          errorMessage = 'Ogiltig epost.';
          break;
        default:
          errorMessage = 'Registrering misslyckades: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Okänt fel vid registrering: $e');
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
          errorMessage = 'Ingen användare med denna epost.';
          break;
        case 'wrong-password':
          errorMessage = 'Fel lösenord.';
          break;
        case 'invalid-email':
          errorMessage = 'Ogiltig epost.';
          break;
        case 'user-disabled':
          errorMessage = 'Kontot är avstängt.';
          break;
        default:
          errorMessage = 'Inloggning misslyckades: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Okänt fel vid inloggning: $e');
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
          errorMessage = 'Ingen användare med denna epost registrerad.';
          break;
        case 'invalid-email':
          errorMessage = 'Ogiltig epost';
          break;
        default:
          errorMessage = 'Kunde inte skicka återställningslänk: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Okänt fel: $e');
    }
  }
}
