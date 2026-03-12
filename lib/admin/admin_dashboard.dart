import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/admin/upload_class.dart';
import 'package:zsquadfitness/ui/components/border_card.dart';
import 'package:zsquadfitness/ui/components/custom_appbar.dart';
import 'package:zsquadfitness/ui/components/primary_button.dart';
import 'package:zsquadfitness/ui/constants/app_strings.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

const int _itemsPerPage = 3;

class _PagedClassList extends StatefulWidget {
  final List<QueryDocumentSnapshot> docs;

  const _PagedClassList({required this.docs});

  @override
  State<_PagedClassList> createState() => __PagedClassListState();
}

class __PagedClassListState extends State<_PagedClassList> {
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
    final grouped = <List<QueryDocumentSnapshot>>[];
    for (int i = 0; i < widget.docs.length; i += _itemsPerPage) {
      grouped.add(
        widget.docs.sublist(
          i,
          i + _itemsPerPage > widget.docs.length
              ? widget.docs.length
              : i + _itemsPerPage,
        ),
      );
    }
    final pageCount = grouped.length;

    return Column(
      children: [
        if (pageCount > 1)
          Padding(
            padding: paddingOnlyBs,
            child: Row(
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
                    padding: paddingAll15,
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
                  return _buildClassCard(context, pageDocs[i]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AdminDashboardState extends State<AdminDashboard> {
  static List<QueryDocumentSnapshot> _allSorted(QuerySnapshot snapshot) {
    final docs = List<QueryDocumentSnapshot>.from(snapshot.docs);
    docs.sort((a, b) {
      final aData = a.data() as Map<String, dynamic>?;
      final bData = b.data() as Map<String, dynamic>?;
      final aTs = aData?['dateRaw'] as Timestamp?;
      final bTs = bData?['dateRaw'] as Timestamp?;
      final aDate = aTs?.toDate() ?? DateTime(0);
      final bDate = bTs?.toDate() ?? DateTime(0);

      return aDate.compareTo(bDate);
    });
    return docs;
  }

  static List<QueryDocumentSnapshot> _pastOnly(QuerySnapshot snapshot) {
    final now = DateTime.now();
    return snapshot.docs.where((doc) {
      final ts = (doc.data() as Map<String, dynamic>)['dateRaw'] as Timestamp?;
      return ts != null && ts.toDate().isBefore(now);
    }).toList();
  }

  static List<QueryDocumentSnapshot> _upcomingOnly(QuerySnapshot snapshot) {
    final now = DateTime.now();
    return snapshot.docs.where((doc) {
      final ts = (doc.data() as Map<String, dynamic>)['dateRaw'] as Timestamp?;
      return ts != null && !ts.toDate().isBefore(now);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            gapH15,
            Text(AppStrings.adminTitle, style: AppTextStyles.h1),
            SizedBox(
              width: 300,
              child: Divider(color: AppColors.neonGreen.withValues(alpha: 0.4)),
            ),
            gapH15,
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: AppStrings.createNewClass,
                color: AppColors.neonGreen,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UploadClass(),
                    ),
                  );
                },
              ),
            ),
            gapH20,
            TabBar(
              labelColor: AppColors.neonGreen,
              unselectedLabelColor: AppColors.lightGrey,
              labelStyle: AppTextStyles.bodyGrey,
              tabs: [
                Tab(text: AppStrings.upcoming),
                Tab(text: AppStrings.passed),
                Tab(text: AppStrings.allClasses),
              ],
            ),
            gapH10,
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('classes')
                    .orderBy('dateRaw')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: paddingAll24,
                        child: Text(
                          AppStrings.noClasses,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    );
                  }

                  final qs = snapshot.data!;
                  return TabBarView(
                    children: [
                      _buildClassList(context, _upcomingOnly(qs)),
                      _buildClassList(context, _pastOnly(qs)),
                      _buildClassList(context, _allSorted(qs)),
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

Widget _buildClassList(BuildContext context, List<QueryDocumentSnapshot> docs) {
  if (docs.isEmpty) {
    return Center(
      child: Padding(
        padding: paddingAll24,
        child: Text(AppStrings.noClasses, style: AppTextStyles.bodyMedium),
      ),
    );
  }
  return _PagedClassList(docs: docs);
}

Widget _buildClassCard(BuildContext context, QueryDocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;

  return BorderCard(
    margin: marginOnlyB,
    padding: paddingAll12,
    alpha: 0.5,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: paddingAll8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data['date'] ?? AppStrings.cantFindDate,
                      style: AppTextStyles.vNG,
                    ),
                    Text(
                      data['time'] ?? '',
                      style: AppTextStyles.bodyWhiteMedium,
                    ),
                    Text(
                      data['locationName'] ?? '',
                      style: AppTextStyles.bodyWhiteSmall,
                    ),
                    Text(
                      '${data['spotsTotal'] ?? 0} ${AppStrings.spots}',
                      style: AppTextStyles.bodyWhiteSmall,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.lightGrey),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UploadClass(classId: doc.id, initialData: data),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AppColors.neonPink),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(AppStrings.deleteClass),
                        content: const Text(AppStrings.confirmDelete),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text(AppStrings.cancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              AppStrings.deleteBtn,
                              style: TextStyle(color: AppColors.neonPink),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await FirebaseFirestore.instance
                          .collection('classes')
                          .doc(doc.id)
                          .delete();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(AppStrings.deleteConfirmation),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),

        Positioned(
          right: 0,
          bottom: 0,
          child: IconButton(
            icon: const Icon(
              Icons.info_outline_rounded,
              color: AppColors.turquise,
            ),
            onPressed: () {},
          ),
        ),
      ],
    ),
  );
}
