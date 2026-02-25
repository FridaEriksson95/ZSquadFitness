import 'package:flutter/material.dart';
import 'package:zsquadfitness/services/auth.dart';
import 'package:zsquadfitness/ui/components/custom_appbar.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(showLogout: true),
      body: const Center(child: Text("Profile Page!", style: AppTextStyles.h1)),
    );
    ;
  }
}
