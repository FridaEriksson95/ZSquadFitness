import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps.dart';
import 'package:zsquadfitness/core/utils/email_launcher.dart';
import 'package:zsquadfitness/shared/ui/components/confirmation_dialog.dart';
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
                  style: AppTextStyles.h2,
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

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        Padding(
                          padding: paddingAll8,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final emails = <String>[];
                              for (final doc in bookingDocs) {
                                final userId = doc.reference.parent.parent!.id;
                                final userSnap = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(userId)
                                    .get();
                                final data = userSnap.data();
                                final email = data?['Email'] as String? ?? '';
                                if (email.isNotEmpty &&
                                    email != AppStrings.unknown) {
                                  emails.add(email);
                                }
                              }
                              if (context.mounted) {
                                await openEmailToClients(
                                  context,
                                  emails: emails,
                                  subject:
                                      '${widget.classData['title'] ?? ''} - ${widget.classData['date'] ?? ''}'
                                          .replaceAll(' ', ''),
                                );
                              }
                            },
                            icon: Icon(
                              Icons.email_outlined,
                              color: AppColors.neonGreen,
                            ),
                            label: Text(AppStrings.emailAllBooked),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.neonGreen,
                              side: BorderSide(color: AppColors.neonGreen),
                            ),
                          ),
                        ),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: bookingDocs.length,
                          itemBuilder: (context, index) {
                            final bookingDoc = bookingDocs[index];
                            final userId =
                                bookingDoc.reference.parent.parent!.id;

                            return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .get(),
                              builder: (context, userSnap) {
                                final data =
                                    userSnap.data?.data()
                                        as Map<String, dynamic>?;
                                final name =
                                    data?['Name'] as String? ??
                                    AppStrings.unknown;
                                final phone =
                                    data?['Phone'] as String? ??
                                    AppStrings.unknown;
                                final email =
                                    data?['Email'] as String? ??
                                    AppStrings.unknown;

                                return Column(
                                  children: [
                                    Padding(
                                      padding: paddingOnlyLR,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              Text(
                                                name,
                                                style: AppTextStyles.vT,
                                              ),
                                            ],
                                          ),

                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.phone_iphone_outlined,
                                                size: 18,
                                                color: AppColors.lightGrey,
                                              ),
                                              gapW5,
                                              Text(
                                                phone,
                                                style: AppTextStyles.geistGrey,
                                              ),
                                            ],
                                          ),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap:
                                                      (email.isEmpty ||
                                                          email ==
                                                              AppStrings
                                                                  .unknown ||
                                                          !email.contains('@'))
                                                      ? null
                                                      : () async {
                                                          if (context.mounted) {
                                                            await openEmailToClients(
                                                              context,
                                                              emails: [email],
                                                              subject:
                                                                  '${widget.classData['title'] ?? ''} - ${widget.classData['date'] ?? ''}'
                                                                      .replaceAll(
                                                                        ' ',
                                                                        '',
                                                                      ),
                                                            );
                                                          }
                                                        },
                                                  borderRadius:
                                                      BorderRadius.circular(4),

                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.mail_outline,
                                                        size: 18,
                                                        color:
                                                            (email.isEmpty ||
                                                                email ==
                                                                    AppStrings
                                                                        .unknown ||
                                                                !email.contains(
                                                                  '@',
                                                                ))
                                                            ? AppColors
                                                                  .mediumGrey
                                                            : AppColors
                                                                  .neonGreen,
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Flexible(
                                                        child: Text(
                                                          email,
                                                          style: AppTextStyles
                                                              .geistGrey,

                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                                    builder: (context) =>
                                                        ConfirmationDialog(
                                                          type: ConfirmationType
                                                              .cancelBooking,
                                                          onConfirm: () async {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                            await _removeClient(
                                                              context,
                                                              bookingRef:
                                                                  bookingDocs[index]
                                                                      .reference,
                                                            );
                                                          },
                                                          onCancel: () =>
                                                              Navigator.pop(
                                                                context,
                                                              ),
                                                        ),
                                                  );
                                                },
                                                padding: paddingOnlyR,
                                                constraints: BoxConstraints(
                                                  minWidth: 36,
                                                  minHeight: 36,
                                                ),
                                                style: IconButton.styleFrom(
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 360,
                                            child: Divider(
                                              color: AppColors.turquise
                                                  .withValues(alpha: 0.4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppStrings.confirmCancel)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppStrings.bookingFailed} $e')),
        );
      }
    }
  }
}
