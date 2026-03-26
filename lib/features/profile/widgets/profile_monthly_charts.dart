import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/features/profile/helpers/profile_stats_helper.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

/// Monthly bar chart used for admin profile statistics
class ProfileMonthlyCharts extends StatelessWidget {
  final List<int> counts;
  final List<DateTime> buckets;

  const ProfileMonthlyCharts({
    super.key,
    required this.counts,
    required this.buckets,
  });

  @override
  Widget build(BuildContext context) {
    final maxCount = counts.isEmpty
        ? 1
        : counts.reduce((a, b) => a > b ? a : b);
    final maxY = maxCount < 2 ? 2 : maxCount;
    const chartHeight = 140.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(counts.length, (i) {
        final h = (counts[i] / maxY) * chartHeight;

        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedContainer(
                duration: duration350,
                height: h.clamp(4.0, chartHeight),
                margin: marginHorizon6,
                decoration: boxStatisticChartsT,
              ),
              gapH10,
              Text(
                ProfileStatsHelper.monthLabelSv(buckets[i]),
                style: AppTextStyles.geist14W,
              ),
            ],
          ),
        );
      }),
    );
  }
}
