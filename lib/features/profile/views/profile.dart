import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zsquadfitness/core/services/auth.dart';
import 'package:zsquadfitness/core/services/database.dart';
import 'package:zsquadfitness/shared/ui/components/border_card.dart';
import 'package:zsquadfitness/shared/ui/components/custom_appbar.dart';
import 'package:zsquadfitness/features/profile/views/edit_profile_dialog.dart';
import 'package:zsquadfitness/shared/ui/components/custom_dropdownfield.dart';
import 'package:zsquadfitness/shared/ui/components/primary_button.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/shared/ui/components/snackbar_utils.dart';
import 'package:zsquadfitness/shared/ui/theme/app_assets.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';
import 'package:zsquadfitness/core/constants/gaps.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isDeleting = false;

  Future<void> _openEditDialog(Map<String, dynamic>? data) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final result = await showDialog<dynamic>(
      context: context,
      builder: (_) => EditProfileDialog(user: currentUser, userData: data),
    );

    if (result is Map<String, dynamic> && result['action'] == 'readyToDelete') {
      if (!mounted) return;
      setState(() => _isDeleting = true);

      await Future<void>.delayed(Duration.zero);

      await _deleteAccount(password: result['password'] as String?);
      return;
    }

    if (result == true && mounted) {
      showAppSnackBar(context, message: AppStrings.profileUpdated);
    }
  }

  Future<void> _deleteAccount({String? password}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

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

      await AuthService().signOut();
    } catch (e) {
      if (mounted) {
        showAppSnackBar(context, message: '${AppStrings.failedToDelete} $e');
        setState(() => _isDeleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDeleting) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: const CustomAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            gapH15,
            Text(AppStrings.profileTitle, style: AppTextStyles.h1),
            SizedBox(
              width: 300,
              child: Divider(color: AppColors.neonGreen.withValues(alpha: 0.4)),
            ),
            gapH15,

            BorderCard(
              padding: EdgeInsets.zero,
              alpha: 0.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: DatabaseService().getUserData(currentUser.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: paddingAll24,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (snapshot.hasError ||
                          !snapshot.hasData ||
                          !snapshot.data!.exists) {
                        return const Padding(
                          padding: paddingAll24,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final data =
                          snapshot.data!.data() as Map<String, dynamic>?;
                      final welcomeName =
                          data?['Name'] as String? ?? AppStrings.zsquader;

                      return Padding(
                        padding: paddingOnlyTsmall,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Image.asset(
                                      AppAssets.logoBlack,
                                      fit: BoxFit.fill,
                                    ),
                                  ),

                                  Expanded(
                                    child: Padding(
                                      padding: paddingOnlyT,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            welcomeName,
                                            style: AppTextStyles.hT,
                                          ),
                                          Text(
                                            data?['Phone'] as String? ?? '',
                                            style: AppTextStyles.bodyWhiteSmall,
                                          ),
                                          Text(
                                            currentUser.email ?? '',
                                            style: AppTextStyles.bodyWhiteSmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: paddingAll8,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.edit_square,
                                  color: AppColors.lightGrey,
                                ),
                                onPressed: () => _openEditDialog(data),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: IntrinsicWidth(
                      child: Padding(
                        padding: paddingOnlyRB,
                        child: PrimaryButton(
                          text: AppStrings.logoutBtn,
                          color: AppColors.neonPink,
                          onPressed: () async {
                            await AuthService().signOut();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            gapH15,
            BorderCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.statistics, style: AppTextStyles.h3),
                      SizedBox(
                        width: 200,
                        child: CustomDropdownfield<String>(
                          value: AppStrings.latest4,
                          fontSize: 14,
                          items:
                              [
                                    AppStrings.latest4,
                                    AppStrings.latest3,
                                    AppStrings.latest6,
                                  ]
                                  .map(
                                    (choice) => DropdownMenuItem(
                                      value: choice,
                                      child: Text(choice),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (choice) {
                            //TODO
                          },
                        ),
                      ),
                    ],
                  ),
                  gapH10,
                  Text(
                    AppStrings.completedClasses,
                    style: AppTextStyles.bodyWhiteDialog,
                  ),
                  gapH10,
                  Container(
                    height: 150,
                    color: AppColors.lightBlack.withValues(alpha: 0.3),
                    child: Center(child: Text('Bar chart placeholder')),
                  ),
                ],
              ),
            ),
            gapBottom,
          ],
        ),
      ),
    );
  }
}
