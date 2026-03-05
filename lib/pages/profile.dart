import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/services/auth.dart';
import 'package:zsquadfitness/services/database.dart';
import 'package:zsquadfitness/ui/components/border_card.dart';
import 'package:zsquadfitness/ui/components/custom_appbar.dart';
import 'package:zsquadfitness/ui/components/primary_button.dart';
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
      appBar: const CustomAppbar(showLogout: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('PROFIL', style: AppTextStyles.h1),
            SizedBox(
              width: 300,
              child: Divider(color: AppColors.neonGreen.withValues(alpha: 0.4)),
            ),
            gapH30,

            BorderCard(
              padding: EdgeInsets.zero,

              alpha: 0.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: StreamBuilder(
                          stream: DatabaseService().getUserData(user!.uid),
                          builder: (context, snapshot) {
                            String welcomeName = 'ZSquader';
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('ZSquader', style: AppTextStyles.hT);
                            }
                            if (snapshot.hasData && snapshot.data!.exists) {
                              final data =
                                  snapshot.data!.data()
                                      as Map<String, dynamic>?;
                              welcomeName =
                                  data?['Name'] as String? ?? 'ZSquader';
                            }
                            return Padding(
                              padding: paddingOnlyTsmall,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
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
                                            user!.email ?? '',
                                            style: AppTextStyles.bodyMedium,
                                          ),
                                          Text(
                                            user!.phoneNumber ?? '',
                                            style: AppTextStyles.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding: paddingAll8,
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: AppColors.lightGrey,
                          ),
                          onPressed: () {
                            //TODO Redigeringslogik
                          },
                        ),
                      ),
                    ],
                  ),
                  gapH10,

                  Align(
                    alignment: Alignment.bottomRight,
                    child: IntrinsicWidth(
                      child: Padding(
                        padding: paddingOnlyRB,
                        child: PrimaryButton(
                          text: 'Logga ut',
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

            gapH20,
            BorderCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Statistik', style: AppTextStyles.h3),
                      DropdownButton(
                        value: 'Senaste 4 veckorna',
                        items:
                            [
                                  'Senaste 4 veckorna',
                                  'Senaste 3 månaderna',
                                  '6 månader',
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
                  Text('Utförda pass: ', style: AppTextStyles.bodyWhiteDialog),
                  gapH10,
                  Container(
                    height: 150,
                    color: AppColors.lightBlack.withValues(alpha: 0.3),
                    child: Center(child: Text('Bar chart placeholder')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
