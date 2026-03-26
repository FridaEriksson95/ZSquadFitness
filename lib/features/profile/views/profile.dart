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
import 'package:zsquadfitness/shared/ui/extensions/context_extensions.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/features/profile/helpers/profile_stats_helper.dart';

/// Profile page with user info, edit/delete actions and role-based stats
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isDeleting = false;
  String _selectedStatsRange = AppStrings.latest4;
  final firestore = FirebaseFirestore.instance;

  /// Opens edit dialog and handles update/delete actions returned by the dialog
  Future<void> _openEditDialog(Map<String, dynamic>? data) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final res = await ProfileDialogHelper.openEditDialog(
      context,
      user: currentUser,
      userData: data,
    );

    if (!mounted || res == null) return;

    if (res.updated) {
      showAppSnackBar(context, message: AppStrings.profileUpdated);
    } else if (res.readyToDelete) {
      await _deleteAccount(password: res.password);
    }
  }

  /// Triggers authenticated account deletion flow and shows error on failure
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

    final statDropDownWidth = (context.screenWidth * 0.48).clamp(160.0, 230.0);
    final headerHeight = (context.screenHeight * 0.23).clamp(175.0, 230.0);
    final chartHeight = (context.screenHeight * 0.22).clamp(150.0, 210.0);

    return Scaffold(
      appBar: const CustomAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            gapH15,
            Text(AppStrings.profileTitle, style: AppTextStyles.cinzel24LG),
            divider300,
            gapH15,
            _buildProfileHeaderCard(currentUser, headerHeight: headerHeight),

            gapH15,
            _buildStatsCard(
              currentUser,
              statsDropdownWidth: statDropDownWidth,
              chartHeight: chartHeight,
            ),
            gapBottom,
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScaffold() => Scaffold(body: cpi);

  Widget _buildProfileHeaderCard(
    User currentUser, {
    required double headerHeight,
  }) {
    return BorderCard(
      padding: paddingZero,
      alpha: 0.1,
      child: _buildProfileUserStream(currentUser, headerHeight: headerHeight),
    );
  }

  Widget _buildProfileUserStream(
    User currentUser, {
    required double headerHeight,
  }) {
    return SimpleStreamView(
      stream: DatabaseService().getUserData(currentUser.uid),
      loading: Padding(padding: paddingAll24, child: cpi),
      empty: Padding(padding: paddingAll24, child: cpi),
      isEmpty: (doc) => !doc.exists,
      builder: (doc) {
        final data = doc.data();
        final welcomeName = data?['Name'] as String? ?? AppStrings.zsquader;
        return _buildProfileHeaderContent(
          currentUser,
          data,
          welcomeName,
          headerHeight: headerHeight,
        );
      },
    );
  }

  Widget _buildProfileHeaderContent(
    User currentUser,
    Map<String, dynamic>? data,
    String welcomeName, {
    required double headerHeight,
  }) {
    return Padding(
      padding: paddingOnlyT15,
      child: SizedBox(
        height: headerHeight,
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                logoBlack150,

                Expanded(
                  child: Padding(
                    padding: paddingOnlyT30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(welcomeName, style: AppTextStyles.geist18T),
                        gapH10,
                        Text(
                          data?['Phone'] as String? ?? '',
                          style: AppTextStyles.geist16W,
                        ),
                        Text(
                          currentUser.email ?? '',
                          style: AppTextStyles.geist16W,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Positioned(
              top: 0,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.edit_square, color: AppColors.lightGrey),
                onPressed: () => _openEditDialog(data),
              ),
            ),
            Positioned(
              right: 15,
              bottom: 10,
              child: SizedBox(
                width: (context.screenWidth * 0.30).clamp(100.0, 130.0),
                child: PrimaryButton(
                  text: AppStrings.logoutBtn,
                  color: AppColors.gold,
                  onPressed: () async {
                    await AuthService().signOut();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(
    User currentUser, {
    required double statsDropdownWidth,
    required double chartHeight,
  }) {
    return BorderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsHeader(statsDropdownWidth: statsDropdownWidth),
          gapH10,
          _buildStatsBody(currentUser, chartHeight: chartHeight),
        ],
      ),
    );
  }

  Widget _buildStatsHeader({required double statsDropdownWidth}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppStrings.statistics, style: AppTextStyles.vidaLoka32T),
        SizedBox(
          width: statsDropdownWidth,
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

  // Admin see monthly clients stats and users see completed classes stats
  Widget _buildStatsBody(User currentUser, {required double chartHeight}) {
    return SimpleStreamView(
      stream: DatabaseService().getUserData(currentUser.uid),
      loading: cpi,
      empty: cpi,
      isEmpty: (doc) => !doc.exists,
      builder: (doc) {
        final userData = doc.data();
        final isAdmin = userData?['isAdmin'] == true;

        return isAdmin
            ? _buildAdminStats(chartHeight: chartHeight)
            : _buildUserStats(currentUser, chartHeight: chartHeight);
      },
    );
  }

  Widget _buildAdminStats({required double chartHeight}) {
    final months = ProfileStatsHelper.rangeToMonths(
      _selectedStatsRange,
      AppStrings.latest2,
      AppStrings.latest3,
    );
    final buckets = ProfileStatsHelper.monthBuckets(months);

    return SimpleStreamView(
      stream: firestore.collection('classes').orderBy('dateRaw').snapshots(),
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
                height: chartHeight,
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

  Widget _buildUserStats(User currentUser, {required double chartHeight}) {
    return SimpleStreamView(
      stream: firestore
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
              SizedBox(
                height: chartHeight,
                child: ProfileWeeklyCharts(counts: counts),
              ),
            ],
          ),
        );
      },
    );
  }
}
