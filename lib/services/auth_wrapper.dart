import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zsquadfitness/pages/auth_page.dart';
import 'package:zsquadfitness/pages/phone_required.dart';
import 'package:zsquadfitness/services/database.dart';
import 'package:zsquadfitness/ui/components/bottom_nav.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (!authSnapshot.hasData || authSnapshot.data == null) {
          return AuthPage();
        }
        final user = authSnapshot.data!;
        return StreamBuilder<DocumentSnapshot>(
          stream: DatabaseService().getUserData(user.uid),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            final data = userSnapshot.data?.data() as Map<String, dynamic>?;
            final phone = data?['Phone'] as String?;
            final isGoogleUser = user.providerData.any(
              (p) => p.providerId == 'google.com',
            );

            if (isGoogleUser && (phone == null || phone.isEmpty)) {
              return PhoneRequiredPage(userId: user.uid);
            }
            return BottomNav(key: BottomNav.globalKey);
          },
        );
      },
    );
  }
}
