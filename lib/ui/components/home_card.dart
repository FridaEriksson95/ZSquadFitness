import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/ui/components/booking_dialog.dart';
import 'package:zsquadfitness/ui/components/border_card.dart';
import 'package:zsquadfitness/ui/components/class_card.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';

class HomeCard extends StatefulWidget {
  final List<QueryDocumentSnapshot> classes;
  const HomeCard({super.key, required this.classes});

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
    if (widget.classes.isEmpty) {
      return const SizedBox.shrink();
    }

    final groupedClasses = <List<QueryDocumentSnapshot>>[];
    for (int i = 0; i < widget.classes.length; i += 2) {
      groupedClasses.add(
        widget.classes.sublist(
          i,
          i + 2 > widget.classes.length ? widget.classes.length : i + 2,
        ),
      );
    }

    return BorderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'KOMMANDE PASS',
            style: AppTextStyles.h3,
            textAlign: TextAlign.center,
          ),

          gapH10,

          SizedBox(
            height: 330,
            child: PageView.builder(
              controller: _pageController,
              itemCount: groupedClasses.length,
              itemBuilder: (context, index) {
                final pageUploads =
                    groupedClasses[index % groupedClasses.length];

                return Column(
                  children: pageUploads.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    return Padding(
                      padding: paddingOnlyBs,
                      child: ClassCard(
                        date: data['date'] ?? 'Datum saknas',
                        time: data['time'] ?? 'Tid saknas',
                        spotsLeft:
                            (data['spotsTotal'] ?? 0) -
                            (data['spotsBooked'] ?? 0),
                        isBooked: false,
                        onBookTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const BookingDialog(),
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
