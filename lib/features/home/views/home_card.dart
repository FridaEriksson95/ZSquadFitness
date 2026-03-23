import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/shared/ui/components/border_card.dart';
import 'package:zsquadfitness/features/home/views/class_card.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

class HomeCard extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> classes;
  const HomeCard({super.key, required this.classes});

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.classes.isEmpty) {
      return const SizedBox.shrink();
    }

    final groupedClasses =
        <List<QueryDocumentSnapshot<Map<String, dynamic>>>>[];
    for (int i = 0; i < widget.classes.length; i += 2) {
      groupedClasses.add(
        widget.classes.sublist(
          i,
          i + 2 > widget.classes.length ? widget.classes.length : i + 2,
        ),
      );
    }

    final pageCount = groupedClasses.length;

    return BorderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppStrings.upcomingClasses,
            style: AppTextStyles.vidaLoka32T,
            textAlign: TextAlign.center,
          ),
          gapH5,
          if (pageCount > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pageCount, (index) {
                return GestureDetector(
                  onTap: () => _pageController.animateToPage(
                    index,
                    duration: duration300,
                    curve: Curves.easeInOut,
                  ),
                  child: Container(
                    margin: marginAll5,
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? AppColors.neonGreen
                          : AppColors.lightGrey,
                    ),
                  ),
                );
              }),
            ),

          gapH10,

          SizedBox(
            height: 310,
            child: PageView.builder(
              controller: _pageController,
              itemCount: pageCount,
              itemBuilder: (context, index) {
                final pageUploads = groupedClasses[index];

                return Column(
                  children: pageUploads.map((doc) {
                    final data = doc.data();

                    return Padding(
                      padding: paddingOnlyBxs,
                      child: ClassCard(classData: data, classId: doc.id),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          gapH5,
        ],
      ),
    );
  }
}
