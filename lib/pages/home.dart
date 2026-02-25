import 'package:flutter/material.dart';
import 'package:zsquadfitness/ui/components/custom_appbar.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(showLogout: false),
      body: const Center(child: Text("Home Page!", style: AppTextStyles.h1)),
    );
  }
}
