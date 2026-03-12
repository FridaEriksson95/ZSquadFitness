import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/services/database.dart';
import 'package:zsquadfitness/ui/components/custom_appbar.dart';
import 'package:zsquadfitness/ui/components/home_card.dart';
import 'package:zsquadfitness/ui/components/week_calendar.dart';
import 'package:zsquadfitness/ui/constants/app_strings.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  List<QueryDocumentSnapshot> _upcomingClasses(QuerySnapshot snapshot) {
    final now = DateTime.now();
    return snapshot.docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final ts = data['dateRaw'] as Timestamp?;
      if (ts == null) return false;
      return !ts.toDate().isBefore(now);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
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
                      String welcomeName = AppStrings.zsquader;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          AppStrings.welcomeDots,
                          style: AppTextStyles.h1,
                        );
                      }
                      if (snapshot.hasData && snapshot.data!.exists) {
                        final data =
                            snapshot.data!.data() as Map<String, dynamic>?;
                        welcomeName =
                            data?['Name'] as String? ?? AppStrings.zsquader;
                      }
                      return Text(
                        '${AppStrings.welcome}, $welcomeName!',
                        style: AppTextStyles.h1,
                      );
                    },
                  ),

                  gapH5,
                  Text(AppStrings.bookClassText, style: AppTextStyles.h2),
                ],
              ),
            ),
            gapH20,

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('classes')
                  .orderBy('dateRaw')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: paddingAll24,
                      child: Text(
                        AppStrings.noClasses,
                        style: AppTextStyles.bodyWhiteDialog,
                      ),
                    ),
                  );
                }
                final upcoming = _upcomingClasses(snapshot.data!);

                return Column(
                  children: [
                    WeekCalendar(
                      key: const PageStorageKey('week_calendar'),
                      classes: upcoming,
                    ),
                    gapH10,
                    HomeCard(classes: upcoming),
                  ],
                );
              },
            ),
            gapBottom,
            gapH5,
          ],
        ),
      ),
    );
  }
}
