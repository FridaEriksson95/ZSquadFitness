import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/shared/ui/components/border_card.dart';
import 'package:zsquadfitness/shared/ui/components/bottom_nav.dart';
import 'package:zsquadfitness/shared/ui/components/confirmation_dialog.dart';
import 'package:zsquadfitness/shared/ui/components/primary_button.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps.dart';
import 'package:zsquadfitness/shared/ui/theme/app_assets.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

class BookingDialog extends StatefulWidget {
  final String classId;
  final Map<String, dynamic> classData;

  const BookingDialog({
    super.key,
    required this.classId,
    required this.classData,
  });

  @override
  State<BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
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

  final Map<int, String> weekdayNames = {
    DateTime.monday: 'Måndagar',
    DateTime.tuesday: 'Tisdagar',
    DateTime.wednesday: 'Onsdagar',
    DateTime.thursday: 'Torsdagar',
    DateTime.friday: 'Fredagar',
    DateTime.saturday: 'Lördagar',
    DateTime.sunday: 'Söndagar',
  };

  List<String> _availableReapeatDayLabels = [];

  int _repeatWeeksToInt(String value) {
    if (value == AppStrings.weeksAhead2) return 2;
    if (value == AppStrings.weeksAhead3) return 3;
    if (value == AppStrings.weeksAhead5) return 5;
    return 0;
  }

  int _repeatDayToWeekday(String label) {
    return weekdayNames.entries.firstWhere((entry) => entry.value == label).key;
  }

  Future<void> _loadAvailableRepeatDays() async {
    final now = DateTime.now();
    final end = now.add(const Duration(days: 90));
    final query = await FirebaseFirestore.instance
        .collection('classes')
        .where('dateRaw', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .where('dateRaw', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .get();

    final Set<int> days = {};
    for (final doc in query.docs) {
      final ts = doc['dateRaw'] as Timestamp?;
      if (ts == null) continue;
      final d = ts.toDate();
      days.add(d.weekday);
    }

    setState(() {
      final sortedDays = days.toList()..sort();
      final labels = sortedDays.map((w) => weekdayNames[w]!).toList();

      _availableReapeatDayLabels = labels;

      if (_availableReapeatDayLabels.isNotEmpty &&
          !_availableReapeatDayLabels.contains(_repeatDay)) {
        _repeatDay = _availableReapeatDayLabels.first;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAvailableRepeatDays();
  }

  Future<void> _bookRepeatingClasses(User user) async {
    final int weeks = _repeatWeeksToInt(_repeatWeeks);
    if (weeks <= 0) return;

    final Timestamp? currentTs = widget.classData['dateRaw'] as Timestamp?;
    if (currentTs == null) return;
    final DateTime currentDate = currentTs.toDate();

    final int targetWeekday = _repeatBooking
        ? _repeatDayToWeekday(_repeatDay)
        : currentDate.weekday;

    final DateTime endDate = currentDate.add(Duration(days: 7 * weeks));

    final query = await FirebaseFirestore.instance
        .collection('classes')
        .where('dateRaw', isGreaterThan: Timestamp.fromDate(currentDate))
        .where('dateRaw', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('dateRaw')
        .get();

    for (final doc in query.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final ts = data['dateRaw'] as Timestamp?;
      if (ts == null) continue;
      final date = ts.toDate();

      if (date.weekday != targetWeekday) continue;

      final classId = doc.id;

      final existing = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('bookings')
          .where('classId', isEqualTo: classId)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) continue;

      final classRef = FirebaseFirestore.instance
          .collection('classes')
          .doc(classId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snap = await transaction.get(classRef);
        if (!snap.exists) return;
        final booked = snap.data()?['spotsBooked'] ?? 0;
        final total = snap.data()?['spotsTotal'] ?? 0;

        transaction.update(classRef, {'spotsBooked': booked + 1});

        final bookingRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('bookings')
            .doc();

        transaction.set(bookingRef, {
          'classId': classId,
          'date': data['date'],
          'time': data['time'],
          'dateRaw': widget.classData['dateRaw'],
          'bookedAt': FieldValue.serverTimestamp(),
        });
      });
    }
  }

  Future<void> _bookClass() async {
    setState(() => _isBooking = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.loginRequired)));
      setState(() => _isBooking = false);
      return;
    }

    final classRef = FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.classId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final classSnapshot = await transaction.get(classRef);

        if (!classSnapshot.exists) {
          throw AppStrings.classRemoved;
        }
        final currentBooked = classSnapshot.data()?['spotsBooked'] ?? 0;
        final total = classSnapshot.data()?['spotsTotal'] ?? 0;

        if (currentBooked >= total) {
          throw AppStrings.classFull;
        }

        transaction.update(classRef, {'spotsBooked': currentBooked + 1});

        final bookingRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('bookings')
            .doc();

        transaction.set(bookingRef, {
          'classId': widget.classId,
          'date': widget.classData['date'],
          'time': widget.classData['time'],
          'dateRaw': widget.classData['dateRaw'],
          'bookedAt': FieldValue.serverTimestamp(),
        });

        await _bookRepeatingClasses(user);
      });

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
          type: ConfirmationType.bookingSuccess,
          onConfirm: () {
            Navigator.pop(context);
            BottomNav.globalKey.currentState?.switchToBookings();
          },
          onCancel: () => Navigator.pop(context),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${AppStrings.bookingFailed} $e')));
    } finally {
      setState(() => _isBooking = false);
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
                      icon: Icon(Icons.close, color: AppColors.darkRed),
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

            Padding(
              padding: paddingH20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 90,
                        child: Center(
                          child: Image.asset(
                            AppAssets.logoBlack,
                            width: 60,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              gapH10,
                              Text(
                                widget.classData['title'] ?? AppStrings.zumba,
                                style: AppTextStyles.hT,
                              ),
                              gapH5,
                              Text(
                                widget.classData['date'] ?? AppStrings.noDate,
                              ),
                              Text(
                                widget.classData['time'] ?? AppStrings.noTime,
                              ),
                            ],
                          ),
                        ),
                      ),
                      gapW12,

                      BorderCard(
                        padding: paddingAll8,
                        margin: EdgeInsets.zero,
                        color: AppColors.turquise.withValues(alpha: 0.2),
                        border: buttonGlassBorder,
                        boxShadow: [shadow, shadowGlass2, shadowGlass3],
                        child: Column(
                          children: [
                            Text(bookedText, style: AppTextStyles.bodySmall),
                            Text(
                              '$spotsLeft ${AppStrings.available}',
                              style: AppTextStyles.hT.copyWith(
                                color: AppColors.neonGreen.withValues(
                                  alpha: 0.7,
                                ),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  gapH20,
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: paddingOnlyTSmall,
                              child: Icon(
                                Icons.pin_drop_rounded,
                                color: AppColors.gold,
                                size: 20,
                              ),
                            ),
                            gapW5,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.classData['locationName'] ??
                                      AppStrings.noLocation,
                                  style: AppTextStyles.hT.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                gapH5,
                                Text(
                                  widget.classData['locationAddress'] ??
                                      AppStrings.noAddress,
                                  style: TextStyle(fontWeight: FontWeight.w200),
                                ),
                              ],
                            ),
                          ],
                        ),

                        gapH10,

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.phonelink_ring_rounded,
                              color: AppColors.gold,
                              size: 20,
                            ),
                            gapW5,
                            Text(
                              '${widget.classData['priceSingle'] ?? AppStrings.priceSingle} ${AppStrings.perClass}  |  ${widget.classData['price10Card'] ?? AppStrings.tenCard} ${AppStrings.perTenCard} ',
                              style: AppTextStyles.hT.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        gapH10,

                        SizedBox(
                          width: 300,
                          child: Divider(
                            color: AppColors.neonGreen.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  gapH5,

                  if (!_repeatBooking) ...[
                    Text(
                      widget.classData['description'] ?? AppStrings.noDesc,
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    gapH15,
                  ],
                ],
              ),
            ),

            Padding(
              padding: paddingH20,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.bookingConfirmation,
                        style: AppTextStyles.hT.copyWith(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      gapW35,
                      Switch(
                        value: _sendConfirmation,
                        onChanged: (choice) =>
                            setState(() => _sendConfirmation = choice),
                        activeThumbColor: AppColors.neonGreen,
                        inactiveThumbColor: AppColors.lightGrey,
                        inactiveTrackColor: AppColors.lightBlack,
                      ),
                    ],
                  ),
                  gapH5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.repeatBooking,
                        style: AppTextStyles.hT.copyWith(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      gapW70,
                      Switch(
                        value: _repeatBooking,
                        onChanged: (choice) =>
                            setState(() => _repeatBooking = choice),
                        activeThumbColor: AppColors.neonGreen,
                        inactiveThumbColor: AppColors.lightGrey,
                        inactiveTrackColor: AppColors.lightBlack,
                      ),
                    ],
                  ),
                  if (_repeatBooking) ...[
                    gapH10,
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _repeatDay,
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.lightBlack.withValues(
                                alpha: 0.6,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: borderRadiusSmall,
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: paddingVH,
                            ),
                            items: _availableReapeatDayLabels
                                .map(
                                  (label) => DropdownMenuItem(
                                    value: label,
                                    child: Text(label),
                                  ),
                                )
                                .toList(),
                            onChanged: (choice) =>
                                setState(() => _repeatDay = choice!),
                          ),
                        ),
                        gapW10,
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _repeatWeeks,
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.lightBlack.withValues(
                                alpha: 0.6,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: borderRadiusSmall,
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: paddingVH,
                            ),
                            items:
                                [
                                      AppStrings.weeksAhead2,
                                      AppStrings.weeksAhead3,
                                      AppStrings.weeksAhead5,
                                    ]
                                    .map(
                                      (w) => DropdownMenuItem(
                                        value: w,
                                        child: Text(w),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (choice) =>
                                setState(() => _repeatWeeks = choice!),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
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
