import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zsquadfitness/pages/home.dart';
import 'package:zsquadfitness/services/database.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> getCurrentMember() async {
    return auth.currentUser;
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential result = await auth.signInWithCredential(credential);

    User userDetails = result.user!;
    Map<String, dynamic> userInfoMap = {
      "Name": userDetails.displayName,
      "Email": userDetails.email,
      "Id": userDetails.uid,
    };
    await DatabaseService().addUserData(userInfoMap, userDetails.uid);
  }

  Future<void> signOut() async {
    await auth.signOut();
    await GoogleSignIn().signOut();
  }
}
