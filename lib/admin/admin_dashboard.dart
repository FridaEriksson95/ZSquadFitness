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

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: SingleChildScrollView(
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
            Text(AppStrings.allClasses, style: AppTextStyles.h3),
            gapH10,
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('classes')
                  .orderBy('dateRaw')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text(
                    AppStrings.noClasses,
                    style: AppTextStyles.bodyMedium,
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    return BorderCard(
                      margin: marginOnlyB,
                      alpha: 0.5,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.neonGreen.withValues(
                            alpha: 0.3,
                          ),
                          child: Text(
                            data['time']?.substring(0, 2) ?? '',
                            style: AppTextStyles.bodyWhiteDialog,
                          ),
                        ),
                        title: Text(
                          '${data['date'] ?? AppStrings.cantFindDate} ${data['time'] ?? ''}',
                          style: AppTextStyles.hT,
                        ),
                        subtitle: Text(
                          '${data['locationName'] ?? ''} - ${data['spotsTotal'] ?? 0} ${AppStrings.spots}',
                          style: AppTextStyles.bodyMedium,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: AppColors.lightGrey,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UploadClass(
                                      classId: doc.id,
                                      initialData: data,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: AppColors.darkRed,
                              ),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text(AppStrings.deleteClass),
                                    content: const Text(
                                      AppStrings.confirmDelete,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text(AppStrings.cancel),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text(
                                          AppStrings.deleteBtn,
                                          style: TextStyle(
                                            color: AppColors.neonPink,
                                          ),
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
                                        content: Text(
                                          AppStrings.deleteConfirmation,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            gapBottom,
          ],
        ),
      ),
    );
  }
}
