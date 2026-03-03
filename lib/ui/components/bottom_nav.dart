import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/pages/bookings.dart';
import 'package:zsquadfitness/pages/home.dart';
import 'package:zsquadfitness/pages/profile.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentTabIndex,
        children: const [BookingsPage(), HomePage(), ProfilePage()],
      ),
      bottomNavigationBar: Padding(
        padding: paddingOnlyBm,
        child: CurvedNavigationBar(
          height: 65,
          backgroundColor: Colors.transparent,
          color: AppColors.lightBg,
          buttonBackgroundColor: const Color.fromRGBO(157, 255, 0, 0.18),
          animationDuration: const Duration(milliseconds: 500),
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
                Icons.calendar_month_rounded,
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
      ),
    );
  }
}
