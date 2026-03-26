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

/// Callback used by each booking card to trigger cancel flow in parent view
typedef BookingCancelCallback =
    Future<void> Function(
      BuildContext context, {
      required DocumentReference<Map<String, dynamic>> bookingRef,
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
  final now = DateTime.now();

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

    // Group bookings info fixed-sized pages for dot flow and swipe
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
                  duration: duration300,
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
                    now: now,
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

/// Renders a single booking card from booking data
Widget _buildBookingCard(
  BuildContext context, {
  required QueryDocumentSnapshot<Map<String, dynamic>> bookingDoc,
  required BookingCancelCallback onCancel,
  required DateTime now,
}) {
  final bookingData = bookingDoc.data();

  final classId = bookingData['classId'] as String?;

  if (classId == null || classId.isEmpty) {
    return const ListTile(title: Text(AppStrings.errorBooking));
  }

  final ts = bookingData['dateRaw'] as Timestamp?;
  final isPast = ts != null && ts.toDate().isBefore(now);

  final title = bookingData['title'] as String? ?? AppStrings.zumba;
  final date = bookingData['date'] as String? ?? AppStrings.noDate;
  final time = bookingData['time'] as String? ?? AppStrings.noTime;
  final locationName =
      bookingData['locationName'] as String? ?? AppStrings.noPlace;

  return Padding(
    padding: paddingOnlyTB,
    child: BorderCard(
      padding: paddingAll8,
      margin: marginZero,
      alpha: 0.07,
      color: AppColors.backgroundGradient1.withValues(alpha: 0.8),
      boxShadow: [shadowGlass1B, shadowGlass2B, shadowGlass3W],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          logoBlack82,
          gapW12,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.vidaLoka24G),

                Text(date, style: AppTextStyles.vidaLoka16W),

                Text(time, style: AppTextStyles.vidaLoka16W),
                gapH5,
                Text(locationName, style: AppTextStyles.vidaLoka11NG),
                gapH5,
              ],
            ),
          ),
          gapW12,

          // Past classes are read-only, marked as 'utförd', upcoming classes can be cancelled
          SizedBox(
            width: 110,
            child: Padding(
              padding: paddingOnlyT30,
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
}
