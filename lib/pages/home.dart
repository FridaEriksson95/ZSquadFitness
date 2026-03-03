import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/services/database.dart';
import 'package:zsquadfitness/ui/components/custom_appbar.dart';
import 'package:zsquadfitness/ui/components/home_card.dart';
import 'package:zsquadfitness/ui/components/week_calendar.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(showLogout: false),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapH30,
            Padding(
              padding: paddingH20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder(
                    stream: DatabaseService().getUserData(user!.uid),
                    builder: (context, snapshot) {
                      String welcomeName = 'ZSquader';
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          'VÄLKOMMEN...',
                          style: AppTextStyles.h1,
                        );
                      }
                      if (snapshot.hasData && snapshot.data!.exists) {
                        final data =
                            snapshot.data!.data() as Map<String, dynamic>?;
                        welcomeName = data?['Name'] as String? ?? 'ZSquader';
                      }
                      return Text(
                        'VÄLKOMMEN, $welcomeName!',
                        style: AppTextStyles.h1,
                      );
                    },
                  ),

                  gapH5,
                  Text('Boka ditt nästa Zumbapass💃', style: AppTextStyles.h2),
                ],
              ),
            ),
            gapH20,

            const WeekCalendar(),
            gapH10,

            HomeCard(),

            gapBottom,
          ],
        ),
      ),
    );
  }
}
