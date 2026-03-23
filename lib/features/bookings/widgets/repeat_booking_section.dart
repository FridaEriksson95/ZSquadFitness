import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/features/bookings/helpers/class_schedule_helper.dart';
import 'package:zsquadfitness/shared/ui/components/custom_dropdownfield.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

class RepeatBookingSection extends StatelessWidget {
  final bool sendConfirmation;
  final ValueChanged<bool> onSendConfirmationChanged;
  final bool repeatBooking;
  final ValueChanged<bool> onRepeatChanged;
  final List<int> availableRepeatWeekdays;
  final String repeatDay;
  final ValueChanged<String?> onRepeatDayChanged;
  final String repeatWeeks;
  final ValueChanged<String?> onRepeatWeeksChanged;

  const RepeatBookingSection({
    super.key,
    required this.sendConfirmation,
    required this.onSendConfirmationChanged,
    required this.repeatBooking,
    required this.onRepeatChanged,
    required this.availableRepeatWeekdays,
    required this.repeatDay,
    required this.onRepeatDayChanged,
    required this.repeatWeeks,
    required this.onRepeatWeeksChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingH20,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.bookingConfirmation,
                style: AppTextStyles.geist18T.copyWith(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
              gapW35,
              Switch(
                value: sendConfirmation,
                onChanged: onSendConfirmationChanged,
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
                style: AppTextStyles.geist18T.copyWith(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
              gapW70,
              Switch(
                value: repeatBooking,
                onChanged: onRepeatChanged,
                activeThumbColor: AppColors.neonGreen,
                inactiveThumbColor: AppColors.lightGrey,
                inactiveTrackColor: AppColors.lightBlack,
              ),
            ],
          ),
          if (repeatBooking && availableRepeatWeekdays.isNotEmpty) ...[
            gapH10,
            Row(
              children: [
                Expanded(
                  child: CustomDropdownfield<String>(
                    value: repeatDay,
                    fontSize: 18,
                    items: availableRepeatWeekdays
                        .map(
                          (weekdays) => DropdownMenuItem(
                            value: ClassScheduleHelper.weekdayLabel(weekdays),
                            child: Text(
                              ClassScheduleHelper.weekdayLabel(weekdays),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: onRepeatDayChanged,
                  ),
                ),
                gapW10,
                Expanded(
                  child: CustomDropdownfield<String>(
                    value: repeatWeeks,
                    fontSize: 14,
                    items:
                        [
                              AppStrings.weeksAhead2,
                              AppStrings.weeksAhead3,
                              AppStrings.weeksAhead5,
                            ]
                            .map(
                              (w) => DropdownMenuItem(value: w, child: Text(w)),
                            )
                            .toList(),
                    onChanged: onRepeatWeeksChanged,
                  ),
                ),
              ],
            ),
          ],
          if (repeatBooking && availableRepeatWeekdays.isEmpty) ...[
            gapH10,
            Text(
              AppStrings.noAvailableRepeatDays,
              style: AppTextStyles.vidaLoka14LG,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
