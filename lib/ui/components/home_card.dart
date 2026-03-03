import 'package:flutter/material.dart';
import 'package:zsquadfitness/ui/components/booking_dialog.dart';
import 'package:zsquadfitness/ui/components/class_card.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';

class HomeCard extends StatefulWidget {
  const HomeCard({super.key});

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  late PageController _pageController;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: marginAll5,
      padding: paddingAll15,
      decoration: BoxDecoration(
        color: AppColors.dark.withValues(alpha: 0.50),
        borderRadius: borderRadiusBig,
        border: borderCard,
        boxShadow: [shadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'VECKANS PASS',
            style: AppTextStyles.h3,
            textAlign: TextAlign.center,
          ),

          gapH10,

          SizedBox(
            height: 330,
            child: PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ClassCard(
                      date: 'Onsdag 18 februari',
                      time: '17.40 - 18. 40',
                      spotsLeft: 20,
                      isBooked: false,
                      onBookTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const BookingDialog(),
                        );
                      },
                    ),

                    ClassCard(
                      date: 'Söndag 22 februari',
                      time: '17.30 - 18. 30',
                      spotsLeft: 20,
                      isBooked: true,
                      onBookTap: () {},
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
