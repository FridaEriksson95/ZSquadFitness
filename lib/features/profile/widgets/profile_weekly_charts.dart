import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

class ProfileWeeklyCharts extends StatelessWidget {
  final List<int> counts;

  const ProfileWeeklyCharts({super.key, required this.counts});

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
        final value = counts[i];
        final h = (value / maxY) * chartHeight;

        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedContainer(
                duration: duration350,
                height: h.clamp(4.0, chartHeight),
                margin: marginHorizon6,
                decoration: boxStatisticCharts,
              ),
              gapH5,
              Text('v${i + 1}', style: AppTextStyles.geist14W),
            ],
          ),
        );
      }),
    );
  }
}
