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
  final Set<String> bookedClassIds;

  const HomeCard({
    super.key,
    required this.classes,
    required this.bookedClassIds,
  });

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

    // Group classes to a maximum of 2 cards per page
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
    final pageHeight = groupedClasses.any((p) => p.length > 1) ? 330.0 : 190.0;

    return BorderCard(
      margin: marginAll8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(child: goldLineLeft),
              gapW12,
              Text(
                AppStrings.upcomingClasses,
                style: AppTextStyles.vidaLoka32G,
                textAlign: TextAlign.center,
              ),
              gapW12,
              goldLineRight,
            ],
          ),
          gapH5,

          // Dot indicator and swipe to jump between pages
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
            height: pageHeight,
            child: PageView.builder(
              controller: _pageController,
              itemCount: pageCount,
              itemBuilder: (context, index) {
                final pageUploads = groupedClasses[index];

                return Column(
                  children: pageUploads.map((doc) {
                    final data = doc.data();

                    return Padding(
                      padding: paddingOnlyB5,
                      child: ClassCard(
                        classData: data,
                        classId: doc.id,
                        isBooked: widget.bookedClassIds.contains(doc.id),
                      ),
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
