import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/services/booking_service.dart';
import 'package:zsquadfitness/features/bookings/helpers/class_schedule_helper.dart';
import 'package:zsquadfitness/features/bookings/widgets/booking_dialog_summary.dart';
import 'package:zsquadfitness/features/bookings/widgets/repeat_booking_section.dart';
import 'package:zsquadfitness/shared/ui/components/border_card.dart';
import 'package:zsquadfitness/shared/ui/components/bottom_nav.dart';
import 'package:zsquadfitness/shared/ui/components/confirmation_dialog.dart';
import 'package:zsquadfitness/shared/ui/components/primary_button.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
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

// Dialog local booking options and loading state
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

  /// Loads weekdays with available classes and keeps selected repeat day valid
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

  /// Returns current user or shows login error snackbar if signed out
  User? _requireUserOrShowError() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showAppSnackBar(context, message: AppStrings.loginRequired);
      return null;
    }
    return user;
  }

  /// Shows success confirmation and routes user to bookings tab
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

  /// Bookes current class and optionally books repeating classes for chosen weekday
  Future<void> _bookClass() async {
    if(!mounted) return; 
    setState(() => _isBooking = true);

    final user = _requireUserOrShowError();
    if (user == null) {
      if (mounted) setState(() => _isBooking = false);
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

      if (!mounted) return;
      Navigator.pop(context);
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return; 
        Navigator.pop(context);

        if(!widget.parentContext.mounted) return;
        showAppSnackBar(
          widget.parentContext,
          message: '${AppStrings.bookingFailed} $e',
        );
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: borderRadius24),
      backgroundColor: Colors.transparent,
      insetPadding: paddingVH,
      child: BorderCard(
        padding: paddingZero,
        margin: marginZero,
        alpha: 0.62,
        boxShadow: [shadowGlass1B, shadowGlass2B, shadowGlass3W],
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
                    style: AppTextStyles.cinzel24LG,
                    textAlign: TextAlign.center,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: paddingH10,
                      child: IconButton(
                        icon: Icon(Icons.close, color: AppColors.neonPink),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            divider300,

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
