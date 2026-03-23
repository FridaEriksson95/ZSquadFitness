import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/features/bookings/views/booking_dialog.dart';
import 'package:zsquadfitness/shared/ui/components/border_card.dart';
import 'package:zsquadfitness/shared/ui/components/primary_button.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/components/stream_builder_view.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

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
          style: AppTextStyles.vidaLoka20LG,
        ),
        gapH10,

        BorderCard(
          padding: paddingAll8,
          alpha: 0.07,
          boxShadow: [textFieldShadow],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              logoBlack82,
              gapW12,

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.classData['title'] ?? AppStrings.zumba,
                      style: AppTextStyles.vidaLoka18T,
                    ),
                    gapH5,
                    Text(
                      widget.classData['time'] ?? AppStrings.noTime,
                      style: AppTextStyles.vidaLoka14W,
                    ),
                    gapH5,
                    Row(
                      children: [
                        Text(
                          '$spotsLeft',
                          style: AppTextStyles.vidaLoka14Wthin.copyWith(
                            color: AppColors.neonGreen,
                          ),
                        ),
                        Text(
                          AppStrings.spotsLeft,
                          style: AppTextStyles.vidaLoka14Wthin,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              gapW12,

              if (user == null)
                _buildBookButton(context, booked: false)
              else
                SimpleStreamView<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.uid)
                      .collection('bookings')
                      .where('classId', isEqualTo: widget.classId)
                      .limit(1)
                      .snapshots(),
                  loading: _buildBookButton(context, booked: false),
                  empty: _buildBookButton(context, booked: false),
                  isEmpty: (qs) => qs.docs.isEmpty,

                  builder: (_) => _buildBookButton(context, booked: true),
                ),
            ],
          ),
        ),
        gapH5,
      ],
    );
  }

  Widget _buildBookButton(BuildContext context, {required bool booked}) {
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
                      parentContext: context,
                      classId: widget.classId,
                      classData: widget.classData,
                    ),
                  );
                },
          color: booked ? AppColors.lightGrey : AppColors.neonGreen,
        ),
      ),
    );
  }
}
