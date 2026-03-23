import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/services/database.dart';
import 'package:zsquadfitness/core/utils/query_docs_helper.dart';
import 'package:zsquadfitness/shared/ui/components/custom_appbar.dart';
import 'package:zsquadfitness/features/home/views/home_card.dart';
import 'package:zsquadfitness/features/home/views/week_calendar.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/components/stream_builder_view.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final uid = user?.uid;

    return Scaffold(
      appBar: const CustomAppbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            gapH20,
            Padding(
              padding: paddingH16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (uid == null)
                    const Text(
                      AppStrings.welcomeDots,
                      style: AppTextStyles.cinzel24LG,
                    )
                  else
                    SimpleStreamView<DocumentSnapshot>(
                      stream: DatabaseService().getUserData(uid),
                      loading: const Text(
                        AppStrings.welcomeDots,
                        style: AppTextStyles.cinzel24LG,
                      ),
                      empty: const Text(
                        '${AppStrings.welcome}, ${AppStrings.zsquader}!',
                        style: AppTextStyles.cinzel24LG,
                      ),
                      isEmpty: (doc) => !doc.exists,
                      builder: (doc) {
                        final data = doc.data() as Map<String, dynamic>?;
                        final welcomeName =
                            data?['Name'] as String? ?? AppStrings.zsquader;

                        return Text(
                          '${AppStrings.welcome}, $welcomeName!',
                          style: AppTextStyles.cinzel24LG,
                        );
                      },
                    ),

                  gapH5,
                  Text(
                    AppStrings.bookClassText,
                    style: AppTextStyles.vidaLoka24T,
                  ),
                ],
              ),
            ),
            gapH20,

            SimpleStreamView<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('classes')
                  .orderBy('dateRaw')
                  .snapshots(),
              loading: cpi,
              empty: const Center(
                child: Padding(
                  padding: paddingAll24,
                  child: Text(
                    AppStrings.noClasses,
                    style: AppTextStyles.geist22W,
                  ),
                ),
              ),
              isEmpty: (qs) => qs.docs.isEmpty,
              builder: (qs) {
                final upcoming = QueryDocsHelper.upcomingOnly(qs.docs);

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
