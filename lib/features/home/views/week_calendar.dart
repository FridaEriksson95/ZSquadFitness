import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zsquadfitness/features/bookings/views/booking_dialog.dart';
import 'package:zsquadfitness/features/home/helpers/week_calendar_helper.dart';
import 'package:zsquadfitness/shared/ui/components/border_card.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

/// Weekly calendar strip for quick day-based class booking
class WeekCalendar extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> classes;

  const WeekCalendar({super.key, required this.classes});

  @override
  State<WeekCalendar> createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  late PageController _pageController;

  final DateFormat _dayShort = DateFormat('E', 'sv_SE');
  final DateFormat _dayNum = DateFormat('d');
  final DateFormat _monthShort = DateFormat('MMM', 'sv_SE');

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

  /// Opens a bottom sheet when multiple classes exists for the selected day
  Future<void> _openClassPicker(
    BuildContext context, {
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> dayClasses,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.dark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: dayClasses.length,
            separatorBuilder: (_, _) => Divider(
              color: AppColors.lightGrey.withValues(alpha: 0.15),
              height: 1,
            ),
            itemBuilder: (context, index) {
              final doc = dayClasses[index];
              final data = doc.data();

              final title = data['title'] as String? ?? '';
              final time = data['time'] as String? ?? '';
              final location = data['locationName'] as String? ?? '';

              return ListTile(
                title: Text(
                  title,
                  style: AppTextStyles.vidaLoka18G.copyWith(
                    color: AppColors.turquise,
                  ),
                ),
                subtitle: Text(
                  '$time • $location',
                  style: AppTextStyles.vidaLoka14LG,
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.lightGrey,
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  showDialog(
                    context: context,
                    builder: (dialogContext) => BookingDialog(
                      classId: doc.id,
                      classData: data,
                      parentContext: context,
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  /// Highlights days that contains classes
  @override
  Widget build(BuildContext context) {
    final daysWithClasses = WeekCalendarHelper.daysWithClasses(widget.classes);
    final today = DateTime.now();
    final todayMonday = WeekCalendarHelper.mondayOf(today);

    return Padding(
      padding: paddingOnlyLR,
      child: BorderCard(
        padding: paddingZero,
        margin: marginZero,
        alpha: 1.5,
        boxShadow: [shadowGlass3W],
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
                  duration: duration300,
                  curve: Curves.easeInOut,
                );
              },
            ),

            Expanded(
              child: SizedBox(
                height: 60,
                child: PageView.builder(
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    final weekStart = todayMonday.add(
                      Duration(days: (index - 1000) * 7),
                    );

                    final days = List.generate(
                      7,
                      (i) => weekStart.add(Duration(days: i)),
                    );

                    return Container(
                      decoration: boxDecorDark,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: days.map((day) {
                          final normalizedDay = WeekCalendarHelper.normalize(
                            day,
                          );
                          final hasClass = daysWithClasses.contains(
                            normalizedDay,
                          );
                          final isToday = WeekCalendarHelper.isSameDay(
                            day,
                            today,
                          );

                          final fontWeight = hasClass || isToday
                              ? FontWeight.bold
                              : FontWeight.normal;

                          // Open dialog directly when only one class exists on that day
                          return GestureDetector(
                            onTap: () async {
                              if (!hasClass) return;

                              final dayClasses =
                                  WeekCalendarHelper.classesForDay(
                                    widget.classes,
                                    day,
                                  );

                              if (dayClasses.isEmpty) return;
                              if (dayClasses.length == 1) {
                                final data = dayClasses.first.data();

                                showDialog(
                                  context: context,
                                  builder: (dialogContext) => BookingDialog(
                                    parentContext: context,
                                    classId: dayClasses.first.id,
                                    classData: data,
                                  ),
                                );
                                return;
                              }

                              await _openClassPicker(
                                context,
                                dayClasses: dayClasses,
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 60,
                              decoration: BoxDecoration(
                                color: isToday
                                    ? AppColors.turquise.withValues(alpha: 0.20)
                                    : null,
                                boxShadow: isToday
                                    ? [
                                        shadowGlass1B,
                                        shadowGlass2B,
                                        shadowGlass3W,
                                      ]
                                    : null,
                                borderRadius: borderRadius12,
                                border: isToday ? borderCardNG : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _dayShort.format(day).toUpperCase(),
                                    style: AppTextStyles.vidaLoka14LG.copyWith(
                                      color: hasClass
                                          ? AppColors.gold.withValues(
                                              alpha: 0.65,
                                            )
                                          : AppColors.turquise,
                                      fontWeight: fontWeight,
                                      shadows: isToday
                                          ? [
                                              shadowGlass1B,
                                              shadowGlass2B,
                                              shadowGlass3W,
                                            ]
                                          : [shadowLB],
                                    ),
                                  ),

                                  Text(
                                    _dayNum.format(day).toUpperCase(),
                                    style: AppTextStyles.vidaLoka14LG.copyWith(
                                      color: hasClass
                                          ? AppColors.gold.withValues(
                                              alpha: 0.65,
                                            )
                                          : AppColors.white,
                                      fontWeight: fontWeight,
                                    ),
                                  ),
                                  Text(
                                    _monthShort.format(day).toUpperCase(),
                                    style: AppTextStyles.vidaLoka14LG.copyWith(
                                      color: hasClass
                                          ? AppColors.gold.withValues(
                                              alpha: 0.65,
                                            )
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
