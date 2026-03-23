import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/services/auth.dart';
import 'package:zsquadfitness/core/services/database.dart';
import 'package:zsquadfitness/features/profile/helpers/edit_dialog.dart';
import 'package:zsquadfitness/features/profile/widgets/profile_monthly_charts.dart';
import 'package:zsquadfitness/features/profile/widgets/profile_weekly_charts.dart';
import 'package:zsquadfitness/shared/ui/components/border_card.dart';
import 'package:zsquadfitness/shared/ui/components/custom_appbar.dart';
import 'package:zsquadfitness/shared/ui/components/custom_dropdownfield.dart';
import 'package:zsquadfitness/shared/ui/components/primary_button.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/shared/ui/components/snackbar_utils.dart';
import 'package:zsquadfitness/shared/ui/components/stream_builder_view.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/features/profile/helpers/profile_stats_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isDeleting = false;
  String _selectedStatsRange = AppStrings.latest4;

  Future<void> _openEditDialog(Map<String, dynamic>? data) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final res = await ProfileDialogHelper.openEditDialog(
      context,
      user: currentUser,
      userData: data,
    );

    if (res == null) return;

    if (res.updated) {
      showAppSnackBar(context, message: AppStrings.profileUpdated);
    } else if (res.readyToDelete) {
      await _deleteAccount(password: res.password);
    }
  }

  Future<void> _deleteAccount({String? password}) async {
    try {
      setState(() => _isDeleting = true);

      await AuthService().deleteAccount(password: password);
    } catch (e) {
      if (mounted) {
        showAppSnackBar(context, message: '${AppStrings.failedToDelete} $e');
        setState(() => _isDeleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDeleting) return _buildLoadingScaffold();

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return _buildLoadingScaffold();

    return Scaffold(
      appBar: const CustomAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            gapH15,
            Text(AppStrings.profileTitle, style: AppTextStyles.cinzel24LG),
            divider300,
            gapH15,
            _buildProfileHeaderCard(currentUser),

            gapH15,
            _buildStatsCard(currentUser),
            gapBottom,
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScaffold() => Scaffold(body: cpi);

  Widget _buildProfileHeaderCard(User currentUser) {
    return BorderCard(
      padding: paddingZero,
      alpha: 0.1,
      child: _buildProfileUserStream(currentUser),
    );
  }

  Widget _buildProfileUserStream(User currentUser) {
    return SimpleStreamView(
      stream: DatabaseService().getUserData(currentUser.uid),
      loading: Padding(padding: paddingAll24, child: cpi),
      empty: Padding(padding: paddingAll24, child: cpi),
      isEmpty: (doc) => !doc.exists,
      builder: (doc) {
        final data = doc.data() as Map<String, dynamic>?;
        final welcomeName = data?['Name'] as String? ?? AppStrings.zsquader;
        return _buildProfileHeaderContent(currentUser, data, welcomeName);
      },
    );
  }

  Widget _buildProfileHeaderContent(
    User currentUser,
    Map<String, dynamic>? data,
    String welcomeName,
  ) {
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
                logoBlack150,

                Expanded(
                  child: Padding(
                    padding: paddingOnlyT,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(welcomeName, style: AppTextStyles.geist18T),
                        Text(
                          data?['Phone'] as String? ?? '',
                          style: AppTextStyles.geist14W,
                        ),
                        Text(
                          currentUser.email ?? '',
                          style: AppTextStyles.geist14W,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 190,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit_square,
                    color: AppColors.lightGrey,
                  ),
                  onPressed: () => _openEditDialog(data),
                ),
                gapH65,
                Padding(
                  padding: paddingOnlyRTB,
                  child: SizedBox(
                    width: 120,
                    child: PrimaryButton(
                      text: AppStrings.logoutBtn,
                      color: AppColors.neonPink,
                      onPressed: () async {
                        await AuthService().signOut();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(User currentUser) {
    return BorderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildStatsHeader(), gapH10, _buildStatsBody(currentUser)],
      ),
    );
  }

  Widget _buildStatsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppStrings.statistics, style: AppTextStyles.vidaLoka32T),
        SizedBox(
          width: 200,
          child: CustomDropdownfield<String>(
            value: _selectedStatsRange,
            fontSize: 14,
            items: [AppStrings.latest4, AppStrings.latest2, AppStrings.latest3]
                .map(
                  (choice) =>
                      DropdownMenuItem(value: choice, child: Text(choice)),
                )
                .toList(),
            onChanged: (choice) {
              if (choice == null) return;
              setState(() => _selectedStatsRange = choice);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatsBody(User currentUser) {
    return SimpleStreamView(
      stream: DatabaseService().getUserData(currentUser.uid),
      loading: cpi,
      empty: cpi,
      isEmpty: (doc) => !doc.exists,
      builder: (doc) {
        final userData = doc.data() as Map<String, dynamic>?;
        final isAdmin = userData?['isAdmin'] == true;

        return isAdmin ? _buildAdminStats() : _buildUserStats(currentUser);
      },
    );
  }

  Widget _buildAdminStats() {
    final months = ProfileStatsHelper.rangeToMonths(
      _selectedStatsRange,
      AppStrings.latest2,
      AppStrings.latest3,
    );
    final buckets = ProfileStatsHelper.monthBuckets(months);

    return SimpleStreamView(
      stream: FirebaseFirestore.instance
          .collection('classes')
          .orderBy('dateRaw')
          .snapshots(),
      loading: cpi,
      empty: cpi,
      isEmpty: (_) => false,
      builder: (classSnap) {
        final classDocs = classSnap.docs;

        final monthlyCounts = ProfileStatsHelper.monthlyClientCounts(
          classDocs,
          buckets,
        );
        final totalClients = monthlyCounts.fold<int>(0, (sums, v) => sums + v);

        return Container(
          width: double.infinity,
          padding: paddingAll8,
          decoration: boxDecorLightB,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppStrings.clients}: $totalClients',
                style: AppTextStyles.geist22W,
              ),
              gapH10,
              SizedBox(
                height: 180,
                child: ProfileMonthlyCharts(
                  counts: monthlyCounts,
                  buckets: buckets,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserStats(User currentUser) {
    return SimpleStreamView(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('bookings')
          .orderBy('dateRaw')
          .snapshots(),
      loading: cpi,
      empty: cpi,
      isEmpty: (_) => false,
      builder: (snapshot) {
        final docs = snapshot.docs;
        final weeks = ProfileStatsHelper.rangeToWeeks(
          _selectedStatsRange,
          AppStrings.latest2,
          AppStrings.latest3,
        );
        final counts = ProfileStatsHelper.weeklyCompletedCounts(docs, weeks);
        final totalCompleted = counts.fold<int>(0, (sums, v) => sums + v);

        return Container(
          width: double.infinity,
          padding: paddingAll8,
          decoration: boxDecorLightB,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppStrings.completedClasses}: $totalCompleted',
                style: AppTextStyles.geist22W,
              ),
              gapH10,
              SizedBox(height: 180, child: ProfileWeeklyCharts(counts: counts)),
            ],
          ),
        );
      },
    );
  }
}
