import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/shared/ui/components/border_card.dart';
import 'package:zsquadfitness/shared/ui/components/confirmation_dialog.dart';
import 'package:zsquadfitness/shared/ui/components/custom_appbar.dart';
import 'package:zsquadfitness/shared/ui/components/primary_button.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps.dart';
import 'package:zsquadfitness/shared/ui/theme/app_assets.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _cancelBooking(
    BuildContext context, {
    required DocumentReference bookingRef,
    required String classId,
  }) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final classRef = FirebaseFirestore.instance
          .collection('classes')
          .doc(classId);

      final classSnap = await transaction.get(classRef);

      final booked = classSnap.data()?['spotsBooked'] ?? 0;
      if (booked > 0) {
        transaction.update(classRef, {'spotsBooked': booked - 1});
      }

      transaction.delete(bookingRef);
    });

    if (!context.mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(AppStrings.confirmCancel)));
  }

  List<QueryDocumentSnapshot> _pastOnly(QuerySnapshot snapshot) {
    final now = DateTime.now();
    return snapshot.docs.where((doc) {
      final ts = (doc.data() as Map<String, dynamic>)['dateRaw'] as Timestamp?;
      return ts != null && ts.toDate().isBefore(now);
    }).toList();
  }

  List<QueryDocumentSnapshot> _upcomingOnly(QuerySnapshot snapshot) {
    final now = DateTime.now();
    return snapshot.docs.where((doc) {
      final ts = (doc.data() as Map<String, dynamic>)['dateRaw'] as Timestamp?;
      return ts != null && !ts.toDate().isBefore(now);
    }).toList();
  }

  List<QueryDocumentSnapshot> _sortedByDate(List<QueryDocumentSnapshot> docs) {
    final list = List<QueryDocumentSnapshot>.from(docs);
    list.sort((a, b) {
      final aData = a.data() as Map<String, dynamic>?;
      final bData = b.data() as Map<String, dynamic>?;
      final aTs = aData?['dateRaw'] as Timestamp?;
      final bTs = bData?['dateRaw'] as Timestamp?;
      final aDate = aTs?.toDate() ?? DateTime(0);
      final bDate = bTs?.toDate() ?? DateTime(0);

      return aDate.compareTo(bDate);
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: const CustomAppbar(),
        body: const Center(child: Text(AppStrings.loginRequired)),
      );
    }

    return Scaffold(
      appBar: const CustomAppbar(),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            gapH15,
            Text(AppStrings.yourBookings, style: AppTextStyles.h1),
            SizedBox(
              width: 300,
              child: Divider(color: AppColors.neonGreen.withValues(alpha: 0.4)),
            ),
            gapH15,
            TabBar(
              labelColor: AppColors.neonGreen,
              unselectedLabelColor: AppColors.lightGrey,
              labelStyle: AppTextStyles.bodyGrey,
              indicatorColor: AppColors.turquise,
              indicatorWeight: 3,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: AppStrings.allBookedTitle),
                Tab(text: AppStrings.accomplishedTitle),
              ],
            ),
            gapH10,
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .collection('bookings')
                    .orderBy('dateRaw')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        AppStrings.noBookings,
                        style: AppTextStyles.h2,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final qs = snapshot.data!;
                  final upcoming = _sortedByDate(_upcomingOnly(qs));
                  final past = _sortedByDate(_pastOnly(qs));

                  return TabBarView(
                    children: [
                      _PagedBookingList(
                        docs: upcoming,
                        onCancel: _cancelBooking,
                      ),
                      _PagedBookingList(docs: past, onCancel: _cancelBooking),
                    ],
                  );
                },
              ),
            ),
            gapH20,
          ],
        ),
      ),
    );
  }
}

const int _bookingItemsPerPage = 3;

class _PagedBookingList extends StatefulWidget {
  final List<QueryDocumentSnapshot> docs;
  final Future<void> Function(
    BuildContext context, {
    required DocumentReference bookingRef,
    required String classId,
  })
  onCancel;

  const _PagedBookingList({
    super.key,
    required this.docs,
    required this.onCancel,
  });

  @override
  State<_PagedBookingList> createState() => __PagedBookingListState();
}

class __PagedBookingListState extends State<_PagedBookingList> {
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
    if (widget.docs.isEmpty) {
      return Center(
        child: Text(
          AppStrings.noBookings,
          style: AppTextStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
      );
    }

    final grouped = <List<QueryDocumentSnapshot>>[];
    for (int i = 0; i < widget.docs.length; i += _bookingItemsPerPage) {
      grouped.add(
        widget.docs.sublist(
          i,
          i + _bookingItemsPerPage > widget.docs.length
              ? widget.docs.length
              : i + _bookingItemsPerPage,
        ),
      );
    }

    final pageCount = grouped.length;

    return Column(
      children: [
        if (pageCount > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pageCount, (index) {
              return GestureDetector(
                onTap: () => _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                child: Container(
                  margin: marginAll8,
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
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: pageCount,
            itemBuilder: (context, index) {
              final pageDocs = grouped[index];
              return ListView.builder(
                padding: paddingOnlyLRT.copyWith(bottom: 100),
                itemCount: pageDocs.length,
                itemBuilder: (context, i) {
                  final bookingDoc = pageDocs[i];
                  return _buildBookingCard(
                    context,
                    bookingDoc: bookingDoc,
                    onCancel: widget.onCancel,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

Widget _buildBookingCard(
  BuildContext context, {
  required QueryDocumentSnapshot bookingDoc,
  required Future<void> Function(
    BuildContext context, {
    required DocumentReference bookingRef,
    required String classId,
  })
  onCancel,
}) {
  final bookingData = bookingDoc.data() as Map<String, dynamic>;

  final classId = bookingData['classId'] as String?;

  if (classId == null) {
    return const ListTile(title: Text(AppStrings.errorBooking));
  }

  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance.collection('classes').doc(classId).get(),
    builder: (context, classSnapshot) {
      if (classSnapshot.connectionState == ConnectionState.waiting) {
        return const ListTile(title: CircularProgressIndicator());
      }

      if (!classSnapshot.hasData || !classSnapshot.data!.exists) {
        return const ListTile(title: Text(AppStrings.removedBooking));
      }

      final classData = classSnapshot.data!.data() as Map<String, dynamic>;
      final ts = classData['dateRaw'] as Timestamp?;
      final isPast = ts != null && ts.toDate().isBefore(DateTime.now());

      return Padding(
        padding: paddingOnlyTB,
        child: BorderCard(
          padding: paddingAll8,
          margin: EdgeInsets.zero,
          alpha: 0.07,
          boxShadow: [textFieldShadow],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 82,
                height: 75,
                child: Center(
                  child: Image.asset(AppAssets.logoBlack, fit: BoxFit.contain),
                ),
              ),
              gapW12,

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classData['title'] ?? AppStrings.zumba,
                      style: AppTextStyles.vT,
                    ),
                    gapH5,
                    Text(
                      classData['date'] ?? AppStrings.noDate,
                      style: AppTextStyles.bodyWhiteBold,
                    ),
                    gapH5,
                    Text(
                      classData['time'] ?? AppStrings.noTime,
                      style: AppTextStyles.bodyWhiteBold,
                    ),
                    gapH5,
                    Text(
                      classData['locationName'] ?? AppStrings.noPlace,
                      style: AppTextStyles.bodyNeongreen,
                    ),
                    gapH5,
                  ],
                ),
              ),
              gapW12,

              SizedBox(
                width: 110,
                child: Padding(
                  padding: paddingOnlyT,
                  child: IntrinsicWidth(
                    child: PrimaryButton(
                      text: isPast
                          ? AppStrings.accomplished
                          : AppStrings.cancelBooking,
                      color: isPast ? AppColors.lightGrey : AppColors.neonPink,
                      onPressed: isPast
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) => ConfirmationDialog(
                                  type: ConfirmationType.cancelBooking,
                                  onConfirm: () => onCancel(
                                    context,
                                    bookingRef: bookingDoc.reference,
                                    classId: classId,
                                  ),
                                  onCancel: () => Navigator.pop(context),
                                ),
                              );
                            },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
