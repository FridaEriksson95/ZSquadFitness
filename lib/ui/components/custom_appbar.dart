import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/admin/admin_dashboard.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_assets.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';
import 'package:zsquadfitness/utils/email_launcher.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 153,
      titleSpacing: 0,
      centerTitle: true,
      title: Image.asset(
        AppAssets.logoText,
        height: 350,
        width: 300,
        fit: BoxFit.contain,
      ),

      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: paddingAll8,
              child: StreamBuilder<DocumentSnapshot>(
                stream: user != null
                    ? FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .snapshots()
                    : null,
                builder: (context, snapshot) {
                  bool isAdmin = false;

                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>?;

                    isAdmin = data?['isAdmin'] == true;
                  }

                  return IconButton(
                    icon: Icon(
                      isAdmin
                          ? Icons.add_circle_outline_rounded
                          : Icons.email_rounded,
                      color: AppColors.neonGreen.withValues(alpha: 0.8),
                      size: 32,
                    ),
                    onPressed: () {
                      if (isAdmin) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminDashboard(),
                          ),
                        );
                      } else {
                        openEmail(context);
                      }
                    },
                    tooltip: isAdmin ? 'Ladda upp pass' : 'Kontakta oss',
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(153);
}
