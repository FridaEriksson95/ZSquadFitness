import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/features/admin/views/admin_dashboard.dart';
import 'package:zsquadfitness/features/bookings/views/bookings.dart';
import 'package:zsquadfitness/features/home/views/home.dart';
import 'package:zsquadfitness/features/profile/views/profile.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';

class BottomNav extends StatefulWidget {
  static final GlobalKey<BottomNavState> globalKey = GlobalKey();

  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> {
  int currentTabIndex = 1;

  void switchToBookings() {
    setState(() {
      currentTabIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: user != null
          ? FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .snapshots()
          : null,
      builder: (context, snapshot) {
        bool isAdmin = false;
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data();
          isAdmin = data?['isAdmin'] == true;
        }
        return Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: currentTabIndex,
            children: [
              isAdmin
                  ? const AdminDashboard(key: PageStorageKey('admin'))
                  : const BookingsPage(key: PageStorageKey('bookings')),
              const HomePage(key: PageStorageKey('home')),
              const ProfilePage(key: PageStorageKey('profile')),
            ],
          ),
          bottomNavigationBar: CurvedNavigationBar(
            height: 70,
            backgroundColor: Colors.transparent,
            color: AppColors.lightBg,
            buttonBackgroundColor: const Color.fromRGBO(157, 255, 0, 0.18),
            animationDuration: duration500,
            index: currentTabIndex,
            onTap: (int index) {
              setState(() {
                currentTabIndex = index;
              });
            },
            items: [
              Padding(
                padding: paddingOnlyTB,
                child: Icon(
                  isAdmin
                      ? Icons.dashboard_rounded
                      : Icons.calendar_month_rounded,
                  size: 40,
                  color: currentTabIndex == 0
                      ? AppColors.neonGreen
                      : AppColors.lightGrey,
                ),
              ),
              Padding(
                padding: paddingOnlyTB,
                child: Icon(
                  Icons.home_rounded,
                  size: 40,
                  color: currentTabIndex == 1
                      ? AppColors.neonGreen
                      : AppColors.lightGrey,
                ),
              ),
              Padding(
                padding: paddingOnlyTB,
                child: Icon(
                  Icons.person_rounded,
                  size: 40,
                  color: currentTabIndex == 2
                      ? AppColors.neonGreen
                      : AppColors.lightGrey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
