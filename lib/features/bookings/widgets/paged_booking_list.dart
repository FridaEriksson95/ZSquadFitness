import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/components/border_card.dart';
import 'package:zsquadfitness/shared/ui/components/confirmation_dialog.dart';
import 'package:zsquadfitness/shared/ui/components/primary_button.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

const int _bookingItemsPerPage = 3;
typedef BookingCancelCallback =
    Future<void> Function(
      BuildContext context, {
      required DocumentReference bookingRef,
      required String classId,
    });

class PagedBookingList extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  final BookingCancelCallback onCancel;

  const PagedBookingList({
    super.key,
    required this.docs,
    required this.onCancel,
  });

  @override
  State<PagedBookingList> createState() => __PagedBookingListState();
}

class __PagedBookingListState extends State<PagedBookingList> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.docs.isEmpty) {
      return Center(
        child: Text(
          AppStrings.noBookings,
          style: AppTextStyles.geist16LG,
          textAlign: TextAlign.center,
        ),
      );
    }

    final grouped = <List<QueryDocumentSnapshot<Map<String, dynamic>>>>[];
    for (int i = 0; i < widget.docs.length; i += _bookingItemsPerPage) {
      grouped.add(
        widget.docs.sublist(
          i,
          i + _bookingItemsPerPage > widget.docs.length
              ? widget.docs.length
              : i + _bookingItemsPerPage,
        ),
      );
    }

    final pageCount = grouped.length;

    return Column(
      children: [
        if (pageCount > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pageCount, (index) {
              return GestureDetector(
                onTap: () => _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                child: Container(
                  margin: marginAll8,
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? AppColors.neonGreen
                        : AppColors.lightGrey,
                  ),
                ),
              );
            }),
          ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: pageCount,
            itemBuilder: (context, index) {
              final pageDocs = grouped[index];
              return ListView.builder(
                padding: paddingOnlyLRT.copyWith(bottom: 100),
                itemCount: pageDocs.length,
                itemBuilder: (context, i) {
                  final bookingDoc = pageDocs[i];
                  return _buildBookingCard(
                    context,
                    bookingDoc: bookingDoc,
                    onCancel: widget.onCancel,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

Widget _buildBookingCard(
  BuildContext context, {
  required QueryDocumentSnapshot<Map<String, dynamic>> bookingDoc,
  required BookingCancelCallback onCancel,
}) {
  final bookingData = bookingDoc.data();

  final classId = bookingData['classId'] as String?;

  if (classId == null) {
    return const ListTile(title: Text(AppStrings.errorBooking));
  }

  return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    future: FirebaseFirestore.instance.collection('classes').doc(classId).get(),
    builder: (context, classSnapshot) {
      if (classSnapshot.connectionState == ConnectionState.waiting) {
        return const ListTile(title: CircularProgressIndicator());
      }

      if (!classSnapshot.hasData || !classSnapshot.data!.exists) {
        return const ListTile(title: Text(AppStrings.removedBooking));
      }

      final classData = classSnapshot.data!.data() as Map<String, dynamic>;
      final ts = classData['dateRaw'] as Timestamp?;
      final isPast = ts != null && ts.toDate().isBefore(DateTime.now());

      return Padding(
        padding: paddingOnlyTB,
        child: BorderCard(
          padding: paddingAll8,
          margin: marginZero,
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
                      classData['title'] ?? AppStrings.zumba,
                      style: AppTextStyles.vidaLoka18T,
                    ),
                    gapH5,
                    Text(
                      classData['date'] ?? AppStrings.noDate,
                      style: AppTextStyles.vidaLoka14W,
                    ),
                    gapH5,
                    Text(
                      classData['time'] ?? AppStrings.noTime,
                      style: AppTextStyles.vidaLoka14W,
                    ),
                    gapH5,
                    Text(
                      classData['locationName'] ?? AppStrings.noPlace,
                      style: AppTextStyles.vidaLoka11G,
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
                      text: isPast
                          ? AppStrings.accomplished
                          : AppStrings.cancelBooking,
                      color: isPast ? AppColors.lightGrey : AppColors.neonPink,
                      onPressed: isPast
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) => ConfirmationDialog(
                                  type: ConfirmationType.cancelBooking,
                                  onConfirm: () => onCancel(
                                    context,
                                    bookingRef: bookingDoc.reference,
                                    classId: classId,
                                  ),
                                  onCancel: () => Navigator.pop(context),
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
}
