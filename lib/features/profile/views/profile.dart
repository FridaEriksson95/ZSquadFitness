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
  String _selectedStatsRange = AppStrings.latest4;

  int _rangeToMonths(String range) {
    if (range == AppStrings.latest2) return 2;
    if (range == AppStrings.latest3) return 3;
    return 4;
  }

  List<DateTime> _monthBuckets(int months) {
    final now = DateTime.now();
    final buckets = <DateTime>[];
    for (int i = months - 1; i >= 0; i--) {
      buckets.add(DateTime(now.year, now.month - i, 1));
    }
    return buckets;
  }

  String _monthLabelSv(DateTime d) {
    const names = [
      'jan',
      'feb',
      'mar',
      'apr',
      'maj',
      'jun',
      'jul',
      'aug',
      'sep',
      'okt',
      'nov',
      'dec',
    ];
    return names[d.month - 1];
  }

  List<int> _monthlyClientCounts(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    List<DateTime> buckets,
  ) {
    final counts = List<int>.filled(buckets.length, 0);
    final now = DateTime.now();

    final first = buckets.first;
    final firstKey = first.year * 12 + first.month;

    for (final doc in docs) {
      final data = doc.data();
      final ts = data['dateRaw'] as Timestamp?;
      if (ts == null) continue;

      final date = ts.toDate();
      if (date.isAfter(now)) continue;

      final key = date.year * 12 + date.month;
      final idx = key - firstKey;
      if (idx < 0 || idx >= counts.length) continue;

      final booked = (data['spotsBooked'] ?? 0) as int;
      counts[idx] += booked;
    }
    return counts;
  }

  Widget _buildMonthlyBarChart(List<int> counts, List<DateTime> buckets) {
    final maxCount = counts.isEmpty
        ? 1
        : counts.reduce((a, b) => a > b ? a : b);
    final maxY = maxCount < 2 ? 2 : maxCount;
    const chartHeight = 140.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(counts.length, (i) {
        final h = (counts[i] / maxY * chartHeight);

        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedContainer(
                duration: duration350,
                height: h.clamp(4.0, chartHeight),
                margin: marginHorizon6,
                decoration: BoxDecoration(
                  color: AppColors.turquise,
                  borderRadius: borderRadius6,
                ),
              ),
              gapH10,
              Text(
                _monthLabelSv(buckets[i]),
                style: AppTextStyles.bodyWhiteSmall,
              ),
            ],
          ),
        );
      }),
    );
  }

  int _rangeToWeeks(String range) {
    if (range == AppStrings.latest2) return 8;
    if (range == AppStrings.latest3) return 12;
    return 4;
  }

  List<int> _weeklyCompletedCounts(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    int weeks,
  ) {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: 7 * weeks));
    final counts = List<int>.filled(weeks, 0);

    for (final doc in docs) {
      final data = doc.data();
      final ts = data['dateRaw'] as Timestamp?;
      if (ts == null) continue;

      final date = ts.toDate();
      if (date.isAfter(now) || date.isBefore(start)) continue;

      final diffDays = now.difference(date).inDays;
      final weekFromNow = (diffDays / 7).floor();
      if (weekFromNow < 0 || weekFromNow >= weeks) continue;

      final chartIndex = weeks - 1 - weekFromNow;
      counts[chartIndex] += 1;
    }

    return counts;
  }

  Widget _buildWeeklyBarChart(List<int> counts) {
    final maxCount = counts.isEmpty
        ? 1
        : counts.reduce((a, b) => a > b ? a : b);
    final maxY = maxCount < 2 ? 2 : maxCount;
    const chartHeight = 140.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(counts.length, (i) {
        final value = counts[i];
        final h = (value / maxY) * chartHeight;

        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedContainer(
                duration: duration350,
                height: h.clamp(4.0, chartHeight),
                margin: marginHorizon6,
                decoration: BoxDecoration(
                  color: AppColors.turquise,
                  borderRadius: borderRadius6,
                ),
              ),
              gapH5,
              Text('v${i + 1}', style: AppTextStyles.bodyWhiteSmall),
            ],
          ),
        );
      }),
    );
  }

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
      return Scaffold(body: cpi);
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Scaffold(body: cpi);
    }

    return Scaffold(
      appBar: const CustomAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            gapH15,
            Text(AppStrings.profileTitle, style: AppTextStyles.h1),
            divider300,
            gapH15,

            BorderCard(
              padding: paddingZero,
              alpha: 0.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: DatabaseService().getUserData(currentUser.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(padding: paddingAll24, child: cpi);
                      }
                      if (snapshot.hasError ||
                          !snapshot.hasData ||
                          !snapshot.data!.exists) {
                        return Padding(padding: paddingAll24, child: cpi);
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
                                          gapH15,
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: IntrinsicWidth(
                                              child: Padding(
                                                padding: paddingOnlyBs,
                                                child: PrimaryButton(
                                                  text: AppStrings.logoutBtn,
                                                  color: AppColors.neonPink,
                                                  onPressed: () async {
                                                    await AuthService()
                                                        .signOut();
                                                  },
                                                ),
                                              ),
                                            ),
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
                          value: _selectedStatsRange,
                          fontSize: 14,
                          items:
                              [
                                    AppStrings.latest4,
                                    AppStrings.latest2,
                                    AppStrings.latest3,
                                  ]
                                  .map(
                                    (choice) => DropdownMenuItem(
                                      value: choice,
                                      child: Text(choice),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (choice) {
                            if (choice == null) return;
                            setState(() => _selectedStatsRange = choice);
                          },
                        ),
                      ),
                    ],
                  ),
                  gapH10,

                  StreamBuilder<DocumentSnapshot>(
                    stream: DatabaseService().getUserData(currentUser.uid),
                    builder: (context, userSnap) {
                      final userData =
                          userSnap.data?.data() as Map<String, dynamic>?;
                      final isAdmin = userData?['isAdmin'] == true;

                      if (isAdmin) {
                        final months = _rangeToMonths(_selectedStatsRange);
                        final buckets = _monthBuckets(months);

                        return StreamBuilder<
                          QuerySnapshot<Map<String, dynamic>>
                        >(
                          stream: FirebaseFirestore.instance
                              .collection('classes')
                              .orderBy('dateRaw')
                              .snapshots(),
                          builder: (context, classSnap) {
                            if (classSnap.connectionState ==
                                ConnectionState.waiting) {
                              return cpi;
                            }

                            final classDocs = classSnap.data?.docs ?? [];

                            final monthlyCounts = _monthlyClientCounts(
                              classDocs,
                              buckets,
                            );
                            final totalClients = monthlyCounts.fold<int>(
                              0,
                              (sums, v) => sums + v,
                            );

                            return Container(
                              width: double.infinity,
                              padding: paddingAll8,
                              decoration: BoxDecoration(
                                color: AppColors.lightBlack.withValues(
                                  alpha: 0.25,
                                ),
                                borderRadius: borderRadius12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${AppStrings.clients}: $totalClients',
                                    style: AppTextStyles.bodyWhiteDialog,
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 180,
                                    child: _buildMonthlyBarChart(
                                      monthlyCounts,
                                      buckets,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }

                      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUser.uid)
                            .collection('bookings')
                            .orderBy('dateRaw')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return cpi;
                          }

                          final docs = snapshot.data?.docs ?? [];
                          final weeks = _rangeToWeeks(_selectedStatsRange);
                          final counts = _weeklyCompletedCounts(docs, weeks);
                          final totalCompleted = counts.fold<int>(
                            0,
                            (sums, v) => sums + v,
                          );

                          return Container(
                            width: double.infinity,
                            padding: paddingAll8,
                            decoration: BoxDecoration(
                              color: AppColors.lightBlack.withValues(
                                alpha: 0.25,
                              ),
                              borderRadius: borderRadius12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppStrings.completedClasses}: $totalCompleted',
                                  style: AppTextStyles.bodyWhiteDialog,
                                ),
                                gapH10,
                                SizedBox(
                                  height: 180,
                                  child: _buildWeeklyBarChart(counts),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
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
