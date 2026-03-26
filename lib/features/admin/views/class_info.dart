import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/core/utils/email_launcher.dart';
import 'package:zsquadfitness/features/admin/helpers/class_info_booked_users.dart';
import 'package:zsquadfitness/shared/ui/components/confirmation_dialog.dart';
import 'package:zsquadfitness/shared/ui/components/snackbar_utils.dart';
import 'package:zsquadfitness/shared/ui/components/stream_builder_view.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

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

  /// Subject used for email all and single client email actions
  String get _emailSubject =>
      '${widget.classData['title'] ?? ''} - ${widget.classData['date'] ?? ''}'
          .replaceAll(' ', '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(AppStrings.classInfoTitle, style: AppTextStyles.cinzel24LG),
            divider330,
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                gapH10,
                Text(
                  widget.classData['title'] ?? AppStrings.zumba,
                  style: AppTextStyles.vidaLoka24G,
                ),
                gapH5,
                Text(widget.classData['date'] ?? AppStrings.noDate),
                Text(widget.classData['time'] ?? AppStrings.noTime),
                Text(bookedText, style: AppTextStyles.vidaLoka14LG),
                Text(
                  '$spotsLeft ${AppStrings.available}',
                  style: AppTextStyles.geist18T.copyWith(
                    color: AppColors.neonGreen.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
                gapH15,
                Text(AppStrings.bookedInClass, style: AppTextStyles.cinzel24LG),
                divider250,

                // Stream all bookings for this class, and display each row with user data
                SimpleStreamView<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collectionGroup('bookings')
                      .where('classId', isEqualTo: widget.classId)
                      .snapshots(),
                  loading: cpi,
                  empty: Center(
                    child: Text(
                      AppStrings.noOneBooked,
                      style: AppTextStyles.geist16LG,
                    ),
                  ),
                  isEmpty: (qs) => qs.docs.isEmpty,
                  builder: (qs) {
                    final bookingDocs = qs.docs;

                    return FutureBuilder<List<BookedUserRow>>(
                      future: ClassInfoBookedUsersHelper.loadBookedUsers(
                        bookingDocs,
                      ),
                      builder: (context, usersSnap) {
                        if (usersSnap.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(padding: paddingAll24, child: cpi);
                        }

                        final rows = usersSnap.data ?? [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: paddingAll8,
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  final emails =
                                      ClassInfoBookedUsersHelper.extractValidEmails(
                                        rows,
                                      );

                                  if (!context.mounted) return;
                                  await openEmailToClients(
                                    context,
                                    emails: emails,
                                    subject: _emailSubject,
                                  );
                                },
                                icon: Icon(
                                  Icons.email_outlined,
                                  color: AppColors.neonGreen,
                                ),
                                label: Text(AppStrings.emailAllBooked),
                                style: outlinedButtonNG,
                              ),
                            ),

                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: rows.length,
                              itemBuilder: (context, index) {
                                final row = rows[index];

                                return _buildClientRow(
                                  context,
                                  name: row.name,
                                  phone: row.phone,
                                  email: row.email,
                                  bookingRef: row.bookingRef,
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            gapBottom,
          ],
        ),
      ),
    );
  }

  /// Remove a booking and decrement class spotsBooked
  Future<void> _removeClient(
    BuildContext context, {
    required DocumentReference bookingRef,
  }) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final classRef = FirebaseFirestore.instance
            .collection('classes')
            .doc(widget.classId);
        final classSnap = await transaction.get(classRef);
        final booked = classSnap.data()?['spotsBooked'] ?? 0;
        if (booked > 0) {
          transaction.update(classRef, {'spotsBooked': booked - 1});
        }
        transaction.delete(bookingRef);
      });
      if (context.mounted) {
        showAppSnackBar(context, message: AppStrings.confirmCancel);
      }
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, message: '${AppStrings.bookingFailed} $e');
      }
    }
  }

  /// Build client row with client info and email all
  Widget _buildClientRow(
    BuildContext context, {
    required String name,
    required String phone,
    required String email,
    required DocumentReference bookingRef,
  }) {
    return Padding(
      padding: paddingOnlyLR,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_3_outlined,
                size: 18,
                color: AppColors.turquise,
              ),
              gapW5,
              Text(name, style: AppTextStyles.vidaLoka22T),
            ],
          ),
          gapH5,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.phone_iphone_outlined,
                size: 18,
                color: AppColors.lightGrey,
              ),
              gapW5,
              Text(phone, style: AppTextStyles.geist14LG),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  onTap:
                      (email.isEmpty ||
                          email == AppStrings.unknown ||
                          !email.contains('@'))
                      ? null
                      : () async {
                          if (context.mounted) {
                            await openEmailToClients(
                              context,
                              emails: [email],
                              subject: _emailSubject,
                            );
                          }
                        },
                  borderRadius: borderRadius6,

                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.mail_outline,
                        size: 18,
                        color:
                            (email.isEmpty ||
                                email == AppStrings.unknown ||
                                !email.contains('@'))
                            ? AppColors.mediumGrey
                            : AppColors.neonGreen,
                      ),
                      gapW5,
                      Flexible(
                        child: Text(
                          email,
                          style: AppTextStyles.geist14LG,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              IconButton(
                icon: Icon(
                  Icons.delete_forever_rounded,
                  color: AppColors.neonPink,
                  size: 22,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ConfirmationDialog(
                      type: ConfirmationType.cancelBooking,
                      onConfirm: () async {
                        Navigator.pop(context);
                        await _removeClient(context, bookingRef: bookingRef);
                      },
                      onCancel: () => Navigator.pop(context),
                    ),
                  );
                },
                padding: paddingOnlyR25,
                constraints: BoxConstraints(minWidth: 36, minHeight: 36),
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          Center(child: divider360Greenish),
        ],
      ),
    );
  }
}
