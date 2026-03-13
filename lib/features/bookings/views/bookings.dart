import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/shared/ui/components/border_card.dart';
import 'package:zsquadfitness/shared/ui/components/confirmation_dialog.dart';
import 'package:zsquadfitness/shared/ui/components/custom_appbar.dart';
import 'package:zsquadfitness/shared/ui/components/primary_button.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps.dart';
import 'package:zsquadfitness/shared/ui/theme/app_assets.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _cancelBooking(BuildContext context, String classId) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final classRef = FirebaseFirestore.instance
          .collection('classes')
          .doc(classId);

      final classSnap = await transaction.get(classRef);
      final data = classSnap.data();

      final booked = data?['spotsBooked'] ?? 0;
      if (booked > 0) {
        transaction.update(classRef, {'spotsBooked': booked - 1});
      }

      final bookingRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('bookings')
          .doc(classId);
      transaction.delete(bookingRef);
    });

    if (!context.mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(AppStrings.confirmCancel)));
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: const CustomAppbar(),
        body: const Center(child: Text(AppStrings.loginRequired)),
      );
    }

    return Scaffold(
      appBar: const CustomAppbar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection('bookings')
            .orderBy('date')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                AppStrings.noBookings,
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
            );
          }

          return Column(
            children: [
              gapH15,
              Text(AppStrings.yourBookings, style: AppTextStyles.h1),
              SizedBox(
                width: 300,
                child: Divider(
                  color: AppColors.neonGreen.withValues(alpha: 0.4),
                ),
              ),
              gapH15,

              Expanded(
                child: ListView.builder(
                  padding: paddingOnlyLRT,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final bookingDoc = snapshot.data!.docs[index];
                    final bookingData =
                        bookingDoc.data() as Map<String, dynamic>;

                    final classId = bookingData['classId'] as String?;

                    if (classId == null) {
                      return const ListTile(
                        title: Text(AppStrings.errorBooking),
                      );
                    }

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('classes')
                          .doc(classId)
                          .get(),
                      builder: (context, classSnapshot) {
                        if (classSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ListTile(
                            title: CircularProgressIndicator(),
                          );
                        }

                        if (!classSnapshot.hasData ||
                            !classSnapshot.data!.exists) {
                          return const ListTile(
                            title: Text(AppStrings.removedBooking),
                          );
                        }

                        final classData =
                            classSnapshot.data!.data() as Map<String, dynamic>;

                        return Padding(
                          padding: paddingOnlyTB,
                          child: BorderCard(
                            padding: paddingAll8,
                            margin: EdgeInsets.zero,
                            alpha: 0.07,
                            boxShadow: [textFieldShadow],
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 82,
                                  height: 75,
                                  child: Center(
                                    child: Image.asset(
                                      AppAssets.logoBlack,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                gapW12,

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        classData['title'] ?? AppStrings.zumba,
                                        style: AppTextStyles.vT,
                                      ),
                                      gapH5,
                                      Text(
                                        classData['date'] ?? AppStrings.noDate,
                                        style: AppTextStyles.bodyWhiteBold,
                                      ),
                                      gapH5,
                                      Text(
                                        classData['time'] ?? AppStrings.noTime,
                                        style: AppTextStyles.bodyWhiteBold,
                                      ),
                                      gapH5,
                                      Text(
                                        classData['locationName'] ??
                                            AppStrings.noPlace,
                                        style: AppTextStyles.bodyNeongreen,
                                      ),
                                      gapH5,
                                    ],
                                  ),
                                ),
                                gapW12,

                                SizedBox(
                                  width: 110,
                                  child: Padding(
                                    padding: paddingOnlyT,
                                    child: IntrinsicWidth(
                                      child: PrimaryButton(
                                        text: AppStrings.cancelBooking,
                                        color: AppColors.neonPink,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                ConfirmationDialog(
                                                  type: ConfirmationType
                                                      .cancelBooking,
                                                  onConfirm: () =>
                                                      _cancelBooking(
                                                        context,
                                                        classId,
                                                      ),
                                                  onCancel: () =>
                                                      Navigator.pop(context),
                                                ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
