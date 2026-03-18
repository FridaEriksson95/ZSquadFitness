import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/services/booking_service.dart';
import 'package:zsquadfitness/core/services/class_schedule_helper.dart';
import 'package:zsquadfitness/features/bookings/widgets/booking_dialog_summary.dart';
import 'package:zsquadfitness/features/bookings/widgets/repeat_booking_section.dart';
import 'package:zsquadfitness/shared/ui/components/border_card.dart';
import 'package:zsquadfitness/shared/ui/components/bottom_nav.dart';
import 'package:zsquadfitness/shared/ui/components/confirmation_dialog.dart';
import 'package:zsquadfitness/shared/ui/components/primary_button.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps.dart';
import 'package:zsquadfitness/shared/ui/components/snackbar_utils.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

class BookingDialog extends StatefulWidget {
  final String classId;
  final Map<String, dynamic> classData;
  final BuildContext parentContext;

  const BookingDialog({
    super.key,
    required this.classId,
    required this.classData,
    required this.parentContext,
  });

  @override
  State<BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  final _bookingService = BookingService();
  bool _sendConfirmation = false;
  bool _repeatBooking = false;
  String _repeatDay = AppStrings.wednesdays;
  String _repeatWeeks = AppStrings.weeksAhead2;
  bool _isBooking = false;

  int get spotsLeft =>
      (widget.classData['spotsTotal'] ?? 0) -
      (widget.classData['spotsBooked'] ?? 0);
  String get bookedText =>
      '${widget.classData['spotsBooked'] ?? 0}/${widget.classData['spotsTotal'] ?? 25}';

  List<int> _availableRepeatWeekdays = [];

  int _repeatWeeksToInt(String value) {
    if (value == AppStrings.weeksAhead2) return 2;
    if (value == AppStrings.weeksAhead3) return 3;
    if (value == AppStrings.weeksAhead5) return 5;
    return 0;
  }

  Future<void> _loadAvailableRepeatDays() async {
    final weekdays = await ClassScheduleHelper.getAvailableWeekdays();

    if (!mounted) return;

    setState(() {
      _availableRepeatWeekdays = weekdays;

      if (_availableRepeatWeekdays.isNotEmpty) {
        final firstLabel = ClassScheduleHelper.weekdayLabel(
          _availableRepeatWeekdays.first,
        );
        if (!_availableRepeatWeekdays
            .map(ClassScheduleHelper.weekdayLabel)
            .contains(_repeatDay)) {
          _repeatDay = firstLabel;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAvailableRepeatDays();
  }

  User? _requireUserOrShowError() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showAppSnackBar(context, message: AppStrings.loginRequired);
      return null;
    }
    return user;
  }

  void _showSuccessDialog() {
    showDialog(
      context: widget.parentContext,
      builder: (context) => ConfirmationDialog(
        type: ConfirmationType.bookingSuccess,
        onConfirm: () {
          Navigator.pop(context);
          BottomNav.globalKey.currentState?.switchToBookings();
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  Future<void> _bookClass() async {
    setState(() => _isBooking = true);

    final user = _requireUserOrShowError();
    if (user == null) {
      setState(() => _isBooking = false);
      return;
    }

    try {
      await _bookingService.bookSingleClass(
        user: user,
        classId: widget.classId,
        classData: widget.classData,
        sendConfirmation: _sendConfirmation,
      );
      if (_repeatBooking && _availableRepeatWeekdays.isNotEmpty) {
        final weeks = _repeatWeeksToInt(_repeatWeeks);
        final targetWeekday = ClassScheduleHelper.weekdayFromLabel(_repeatDay);

        await _bookingService.bookRepeating(
          repeatBooking: _repeatBooking,
          weeks: weeks,
          targetWeekday: targetWeekday,
          classData: widget.classData,
          sendConfirmation: _sendConfirmation,
        );
      }

      if (!context.mounted) return;
      Navigator.pop(context);
      _showSuccessDialog();
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        showAppSnackBar(
          widget.parentContext,
          message: '${AppStrings.bookingFailed} $e',
        );
      }
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: borderRadiusBig),
      backgroundColor: Colors.transparent,
      insetPadding: paddingVH,
      child: BorderCard(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        alpha: 0.62,
        boxShadow: [shadowGlass1, shadowGlass2, shadowGlass3],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: paddingOnlyLRT,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    AppStrings.bookClass,
                    style: AppTextStyles.h1,
                    textAlign: TextAlign.center,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.close, color: AppColors.neonPink),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 300,
              child: Divider(color: AppColors.neonGreen.withValues(alpha: 0.4)),
            ),

            BookingDialogSummary(
              classData: widget.classData,
              bookedText: bookedText,
              spotsLeft: spotsLeft,
              repeatBooking: _repeatBooking,
            ),

            RepeatBookingSection(
              sendConfirmation: _sendConfirmation,
              onSendConfirmationChanged: (choice) =>
                  setState(() => _sendConfirmation = choice),
              repeatBooking: _repeatBooking,
              onRepeatChanged: (choice) =>
                  setState(() => _repeatBooking = choice),
              availableRepeatWeekdays: _availableRepeatWeekdays,
              repeatDay: _repeatDay,
              onRepeatDayChanged: (choice) =>
                  setState(() => _repeatDay = choice!),
              repeatWeeks: _repeatWeeks,
              onRepeatWeeksChanged: (choice) =>
                  setState(() => _repeatWeeks = choice!),
            ),
            gapH20,
            Padding(
              padding: paddingVH,
              child: SizedBox(
                width: 180,
                child: PrimaryButton(
                  text: _isBooking ? AppStrings.bookingLoad : AppStrings.book,
                  color: AppColors.neonGreen,
                  onPressed: _isBooking ? null : _bookClass,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
