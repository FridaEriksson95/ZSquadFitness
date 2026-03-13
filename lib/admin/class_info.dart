import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/utils/components/custom_appbar.dart';
import 'package:zsquadfitness/ui/constants/app_strings.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';

class ClassInfoPage extends StatefulWidget {
  final Map<String, dynamic> classData;
  final String classId;

  const ClassInfoPage({
    super.key,
    required this.classId,
    required this.classData,
  });

  @override
  State<ClassInfoPage> createState() => _ClassInfoPageState();
}

class _ClassInfoPageState extends State<ClassInfoPage> {
  int get spotsLeft =>
      (widget.classData['spotsTotal'] ?? 0) -
      (widget.classData['spotsBooked'] ?? 0);
  String get bookedText =>
      '${widget.classData['spotsBooked'] ?? 0}/${widget.classData['spotsTotal'] ?? 25}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(AppStrings.classInfoTitle, style: AppTextStyles.h1),
            SizedBox(
              width: 330,
              child: Divider(color: AppColors.neonGreen.withValues(alpha: 0.4)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                gapH10,
                Text(
                  widget.classData['title'] ?? AppStrings.zumba,
                  style: AppTextStyles.hT,
                ),
                gapH5,
                Text(widget.classData['date'] ?? AppStrings.noDate),
                Text(widget.classData['time'] ?? AppStrings.noTime),
                Text(bookedText, style: AppTextStyles.bodySmall),
                Text(
                  '$spotsLeft ${AppStrings.available}',
                  style: AppTextStyles.hT.copyWith(
                    color: AppColors.neonGreen.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
                gapH15,
                Text(AppStrings.bookedInClass, style: AppTextStyles.h1),
                SizedBox(
                  width: 200,
                  child: Divider(
                    color: AppColors.neonGreen.withValues(alpha: 0.4),
                  ),
                ),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collectionGroup('bookings')
                      .where('classId', isEqualTo: widget.classId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: paddingAll24,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasError) {
                      return Padding(
                        padding: paddingAll24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.couldntLoadBookings,
                              style: AppTextStyles.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${snapshot.error}',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    final bookingDocs = snapshot.data!.docs;
                    if (bookingDocs.isEmpty) {
                      return Center(
                        child: Text(
                          AppStrings.noOneBooked,
                          style: AppTextStyles.bodyMedium,
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: bookingDocs.length,
                      itemBuilder: (context, index) {
                        final userId =
                            bookingDocs[index].reference.parent.parent!.id;
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .get(),
                          builder: (context, userSnap) {
                            final data =
                                userSnap.data?.data() as Map<String, dynamic>?;
                            final name =
                                data?['Name'] as String? ?? AppStrings.unknown;
                            final phone =
                                data?['Phone'] as String? ?? AppStrings.unknown;
                            final email =
                                data?['Email'] as String? ?? AppStrings.unknown;
                            return ListTile(
                              leading: Text(name),
                              title: Text(phone),
                              subtitle: Text(email),
                              onTap: () {},
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
