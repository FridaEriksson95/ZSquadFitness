import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zsquadfitness/ui/components/booking_dialog.dart';
import 'package:zsquadfitness/ui/components/border_card.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';

class WeekCalendar extends StatefulWidget {
  final List<QueryDocumentSnapshot> classes;

  const WeekCalendar({super.key, required this.classes});

  @override
  State<WeekCalendar> createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  late PageController _pageController;
  DateTime _currentWeekStart = DateTime.now().subtract(
    Duration(days: DateTime.now().weekday - 1),
  );

  final DateFormat _dayShort = DateFormat('E', 'sv_SE');
  final DateFormat _dayNum = DateFormat('d');
  final DateFormat _monthShort = DateFormat('MMM', 'sv_SE');

  Set<DateTime> _daysWithClasses = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1000);
    _loadDaysWithClasses();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadDaysWithClasses() async {
    try {
      final start = _currentWeekStart.subtract(const Duration(days: 90));
      final end = _currentWeekStart.add(const Duration(days: 90));

      final query = await FirebaseFirestore.instance
          .collection('classes')
          .where('dateRaw', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('dateRaw', isLessThanOrEqualTo: Timestamp.fromDate(end))
          .get();

      final Set<DateTime> days = {};
      for (final doc in query.docs) {
        final timestamp = doc['dateRaw'] as Timestamp?;
        if (timestamp != null) {
          final date = timestamp.toDate();
          final normalized = DateTime(date.year, date.month, date.day);
          days.add(normalized);
        }
      }
      setState(() {
        _daysWithClasses = days;
      });
    } catch (e) {}
  }

  void _onPageChanged(int page) {
    setState(() {
      final today = DateTime.now();
      final todayMonday = today.subtract(Duration(days: today.weekday - 1));
      _currentWeekStart = todayMonday.add(Duration(days: (page - 1000) * 7));
    });

    _loadDaysWithClasses();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingOnlyLR,
      child: BorderCard(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        alpha: 1.5,
        boxShadow: [shadowGlass3],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: AppColors.lightGrey,
                size: 28,
              ),
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),

            Expanded(
              child: SizedBox(
                height: 60,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) {
                    final today = DateTime.now();
                    final todayMonday = today.subtract(
                      Duration(days: today.weekday - 1),
                    );
                    final weekStart = todayMonday.add(
                      Duration(days: (index - 1000) * 7),
                    );

                    final days = List.generate(
                      7,
                      (i) => weekStart.add(Duration(days: i)),
                    );

                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.dark.withValues(alpha: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: days.map((day) {
                          final normalizedDay = DateTime(
                            day.year,
                            day.month,
                            day.day,
                          );
                          final hasClass = _daysWithClasses.contains(
                            normalizedDay,
                          );
                          final isToday =
                              day.day == today.day &&
                              day.month == today.month &&
                              day.year == today.year;

                          final fontWeight = hasClass || isToday
                              ? FontWeight.bold
                              : FontWeight.normal;

                          return GestureDetector(
                            onTap: () {
                              if (!hasClass) return;

                              final classForDay = widget.classes.where((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                final classDateRaw =
                                    data['dateRaw'] as Timestamp?;
                                if (classDateRaw == null) return false;
                                final classDate = classDateRaw.toDate();
                                return classDate.year == day.year &&
                                    classDate.month == day.month &&
                                    classDate.day == day.day;
                              }).toList();

                              if (classForDay.isEmpty) return;

                              if (classForDay.length == 1) {
                                final classData =
                                    classForDay.first.data()
                                        as Map<String, dynamic>;
                                showDialog(
                                  context: context,
                                  builder: (context) => BookingDialog(
                                    classId: classForDay.first.id,
                                    classData: classData,
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: 40,
                              height: 60,
                              decoration: BoxDecoration(
                                color: isToday
                                    ? AppColors.turquise.withValues(alpha: 0.20)
                                    : null,
                                boxShadow: isToday
                                    ? [shadowGlass1, shadowGlass2, shadowGlass3]
                                    : null,
                                borderRadius: borderRadiusSmall,
                                border: isToday ? borderCard : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _dayShort.format(day).toUpperCase(),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: hasClass
                                          ? AppColors.neonGreen
                                          : (isToday
                                                ? AppColors.white
                                                : AppColors.turquise),
                                      fontWeight: fontWeight,
                                      shadows: isToday
                                          ? [
                                              shadowGlass1,
                                              shadowGlass2,
                                              shadowGlass3,
                                            ]
                                          : [shadow],
                                    ),
                                  ),

                                  Text(
                                    _dayNum.format(day).toUpperCase(),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: hasClass
                                          ? AppColors.neonGreen
                                          : AppColors.white,
                                      fontWeight: fontWeight,
                                    ),
                                  ),
                                  Text(
                                    _monthShort.format(day).toUpperCase(),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: hasClass
                                          ? AppColors.neonGreen
                                          : AppColors.white,
                                      fontSize: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.lightGrey,
                size: 28,
              ),
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
