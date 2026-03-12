import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/services/auth.dart';
import 'package:zsquadfitness/services/database.dart';
import 'package:zsquadfitness/ui/components/border_card.dart';
import 'package:zsquadfitness/ui/components/custom_appbar.dart';
import 'package:zsquadfitness/ui/components/edit_profile_dialog.dart';
import 'package:zsquadfitness/ui/components/primary_button.dart';
import 'package:zsquadfitness/ui/constants/app_strings.dart';
import 'package:zsquadfitness/ui/theme/app_assets.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
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
                    stream: DatabaseService().getUserData(user!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          AppStrings.zsquader,
                          style: AppTextStyles.hT,
                        );
                      }
                      if (snapshot.hasError) {
                        return Text(
                          AppStrings.noProfileData,
                          style: AppTextStyles.hT.copyWith(
                            color: AppColors.neonPink,
                          ),
                        );
                      }

                      String welcomeName = AppStrings.zsquader;
                      Map<String, dynamic>? data;

                      if (snapshot.hasData && snapshot.data!.exists) {
                        data = snapshot.data!.data() as Map<String, dynamic>?;
                        welcomeName =
                            data?['Name'] as String? ?? AppStrings.zsquader;
                      }

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
                                            user!.email ?? '',
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
                                onPressed: () async {
                                  final currentUser =
                                      FirebaseAuth.instance.currentUser;
                                  if (currentUser == null) return;

                                  final updated = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => EditProfileDialog(
                                      user: currentUser,
                                      userData: data,
                                    ),
                                  );

                                  if (updated == true && mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          AppStrings.profileUpdated,
                                        ),
                                      ),
                                    );
                                  }
                                },
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
                      DropdownButton(
                        value: AppStrings.latest4,
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
