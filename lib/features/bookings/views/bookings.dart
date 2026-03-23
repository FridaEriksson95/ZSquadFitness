import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/services/booking_service.dart';
import 'package:zsquadfitness/features/bookings/helpers/user_bookings_helper.dart';
import 'package:zsquadfitness/features/bookings/widgets/paged_booking_list.dart';
import 'package:zsquadfitness/shared/ui/components/custom_appbar.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/components/snackbar_utils.dart';
import 'package:zsquadfitness/shared/ui/components/stream_builder_view.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final _bookingService = BookingService();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _cancelBooking(
    BuildContext context, {
    required DocumentReference bookingRef,
    required String classId,
  }) async {
    await _bookingService.cancelBooking(
      bookingRef: bookingRef,
      classId: classId,
    );

    if (!context.mounted) return;
    Navigator.pop(context);
    showAppSnackBar(context, message: AppStrings.confirmCancel);
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
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            gapH15,
            Text(AppStrings.yourBookings, style: AppTextStyles.cinzel24LG),
            divider300,
            gapH15,
            TabBar(
              labelColor: AppColors.neonGreen,
              unselectedLabelColor: AppColors.lightGrey,
              labelStyle: AppTextStyles.vidaLoka16LG,
              indicatorColor: AppColors.turquise,
              indicatorWeight: 3,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: AppStrings.allBookedTitle),
                Tab(text: AppStrings.accomplishedTitle),
              ],
            ),
            gapH10,
            Expanded(
              child: SimpleStreamView<UserBookingsView>(
                stream: UserBookingsHelper.streamBookings(user?.uid),
                empty: Center(
                  child: Text(
                    AppStrings.noBookings,
                    style: AppTextStyles.vidaLoka24T,
                    textAlign: TextAlign.center,
                  ),
                ),
                isEmpty: (view) => view.isEmpty,
                builder: (view) {
                  return TabBarView(
                    children: [
                      PagedBookingList(
                        docs: view.upcoming,
                        onCancel: _cancelBooking,
                      ),
                      PagedBookingList(
                        docs: view.past,
                        onCancel: _cancelBooking,
                      ),
                    ],
                  );
                },
              ),
            ),
            gapH20,
          ],
        ),
      ),
    );
  }
}
