import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/ui/components/booking_dialog.dart';
import 'package:zsquadfitness/ui/components/border_card.dart';
import 'package:zsquadfitness/ui/components/primary_button.dart';
import 'package:zsquadfitness/ui/constants/app_strings.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_assets.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';

class ClassCard extends StatefulWidget {
  final Map<String, dynamic> classData;
  final String classId;

  const ClassCard({super.key, required this.classData, required this.classId});

  @override
  State<ClassCard> createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final spotsLeft =
        (widget.classData['spotsTotal'] ?? 0) -
        (widget.classData['spotsBooked'] ?? 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (widget.classData['date'] ?? AppStrings.noDate).toUpperCase(),
          style: AppTextStyles.vG,
        ),
        gapH10,

        BorderCard(
          padding: paddingAll8,
          alpha: 0.07,
          boxShadow: [textFieldShadow],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 82,
                height: 75,
                child: Center(
                  child: Image.asset(AppAssets.logoBlack, fit: BoxFit.contain),
                ),
              ),
              gapW12,

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.classData['title'] ?? AppStrings.zumba,
                      style: AppTextStyles.vT,
                    ),
                    gapH5,
                    Text(
                      widget.classData['time'] ?? AppStrings.noTime,
                      style: AppTextStyles.bodyWhiteBold,
                    ),
                    gapH5,
                    Row(
                      children: [
                        Text(
                          '$spotsLeft',
                          style: AppTextStyles.bodyWhiteThin.copyWith(
                            color: AppColors.neonGreen,
                          ),
                        ),
                        Text(
                          AppStrings.spotsLeft,
                          style: AppTextStyles.bodyWhiteThin,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              gapW12,
              StreamBuilder<DocumentSnapshot>(
                stream: user != null
                    ? FirebaseFirestore.instance
                          .collection('users')
                          .doc(user?.uid)
                          .collection('bookings')
                          .doc(widget.classId)
                          .snapshots()
                    : null,
                builder: (context, snapshot) {
                  bool booked = false;
                  if (snapshot.hasData && snapshot.data!.exists) {
                    booked = true;
                  }

                  return SizedBox(
                    width: 100,
                    child: Padding(
                      padding: paddingOnlyTB,
                      child: PrimaryButton(
                        text: booked ? AppStrings.booked : AppStrings.book,
                        onPressed: booked
                            ? null
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (context) => BookingDialog(
                                    classId: widget.classId,
                                    classData: widget.classData,
                                  ),
                                );
                              },
                        color: booked
                            ? AppColors.lightGrey
                            : AppColors.neonGreen,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        gapH5,
      ],
    );
  }
}
