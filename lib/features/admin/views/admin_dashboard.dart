import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/utils/query_docs_helper.dart';
import 'package:zsquadfitness/features/admin/views/class_info.dart';
import 'package:zsquadfitness/features/admin/views/upload_class.dart';
import 'package:zsquadfitness/shared/ui/components/border_card.dart';
import 'package:zsquadfitness/shared/ui/components/custom_appbar.dart';
import 'package:zsquadfitness/shared/ui/components/primary_button.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/components/snackbar_utils.dart';
import 'package:zsquadfitness/shared/ui/components/stream_builder_view.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

const int _itemsPerPage = 3;

class _PagedClassList extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;

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
    final grouped = <List<QueryDocumentSnapshot<Map<String, dynamic>>>>[];
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
                    duration: duration300,
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
        Padding(
          padding: paddingOnlyBs,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              '${AppStrings.total}: ${widget.docs.length}',
              style: AppTextStyles.vidaLoka14LG,
            ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        toolbarHeight: 150,
        logoHeight: 250,
        logoWidth: 220,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Text(AppStrings.adminTitle, style: AppTextStyles.cinzel24LG),
            divider300,
            gapH15,

            PrimaryButton(
              text: AppStrings.createNewClass,
              color: AppColors.neonGreen,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UploadClass()),
                );
              },
            ),

            gapH10,
            TabBar(
              labelColor: AppColors.neonGreen,
              unselectedLabelColor: AppColors.lightGrey,
              labelStyle: AppTextStyles.vidaLoka16LG,
              indicatorColor: AppColors.turquise,
              indicatorWeight: 3,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: AppStrings.upcoming),
                Tab(text: AppStrings.passed),
                Tab(text: AppStrings.allClasses),
              ],
            ),
            gapH5,
            Expanded(
              child: SimpleStreamView<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('classes')
                    .orderBy('dateRaw')
                    .snapshots(),
                loading: cpi,
                empty: Center(
                  child: Padding(
                    padding: paddingAll24,
                    child: Text(
                      AppStrings.noClasses,
                      style: AppTextStyles.geist16LG,
                    ),
                  ),
                ),
                isEmpty: (qs) => qs.docs.isEmpty,
                builder: (qs) {
                  final docs = qs.docs;

                  return TabBarView(
                    children: [
                      _buildClassList(
                        context,
                        QueryDocsHelper.upcomingOnly(docs),
                      ),
                      _buildClassList(context, QueryDocsHelper.pastOnly(docs)),
                      _buildClassList(context, QueryDocsHelper.allSorted(docs)),
                    ],
                  );
                },
              ),
            ),
            gapH10,
          ],
        ),
      ),
    );
  }
}

Widget _buildClassList(
  BuildContext context,
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
) {
  if (docs.isEmpty) {
    return Center(
      child: Padding(
        padding: paddingAll24,
        child: Text(AppStrings.noClasses, style: AppTextStyles.geist16LG),
      ),
    );
  }
  return _PagedClassList(docs: docs);
}

Widget _buildClassCard(
  BuildContext context,
  QueryDocumentSnapshot<Map<String, dynamic>> doc,
) {
  final data = doc.data();

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
                      style: AppTextStyles.vidaLoka22T,
                    ),
                    Text(data['time'] ?? '', style: AppTextStyles.vidaLoka16W),
                    Text(
                      data['locationName'] ?? '',
                      style: AppTextStyles.geist14W,
                    ),
                    Text(
                      '${data['spotsTotal'] ?? 0} ${AppStrings.spots}',
                      style: AppTextStyles.geist14W,
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
                        showAppSnackBar(
                          context,
                          message: AppStrings.deleteConfirmation,
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ClassInfoPage(classId: doc.id, classData: data),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
