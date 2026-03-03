import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';

class WeekCalendar extends StatefulWidget {
  const WeekCalendar({super.key});

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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1000);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentWeekStart = DateTime.now()
          .subtract(Duration(days: DateTime.now().weekday - 1))
          .add(Duration(days: (page - 1000) * 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingOnlyLR,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.dark.withValues(alpha: 1.5),
          borderRadius: borderRadiusBig,
          border: borderCard,
        ),
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
                    final weekStart = DateTime.now()
                        .subtract(Duration(days: DateTime.now().weekday - 1))
                        .add(Duration(days: (index - 1000) * 7));

                    final today = DateTime.now();
                    final days = List.generate(
                      7,
                      (i) => weekStart.add(Duration(days: i)),
                    );

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: days.map((day) {
                        final isToday =
                            day.day == today.day &&
                            day.month == today.month &&
                            day.year == today.year;

                        return GestureDetector(
                          onTap: () {
                            //TODO logik för välja dag och visa pass
                          },
                          child: Container(
                            width: 40,
                            height: 60,
                            decoration: BoxDecoration(
                              color: isToday
                                  ? AppColors.turquise.withValues(alpha: 0.20)
                                  : null,
                              boxShadow: [
                                shadowGlass1,
                                shadowGlass2,
                                shadowGlass3,
                              ],
                              borderRadius: borderRadiusSmall,
                              border: isToday ? borderCard : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _dayShort.format(day).toUpperCase(),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: isToday
                                        ? AppColors.white
                                        : AppColors.turquise,
                                    fontWeight: isToday
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    shadows: isToday
                                        ? [
                                            shadowGlass1,
                                            shadowGlass2,
                                            shadowGlass3,
                                          ]
                                        : [shadow],
                                  ),
                                ),
                                gapH5,
                                Text(
                                  _dayNum.format(day).toUpperCase(),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: isToday
                                        ? AppColors.turquise
                                        : AppColors.white,
                                    fontWeight: isToday
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
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
