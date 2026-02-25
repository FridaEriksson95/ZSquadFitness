import 'package:flutter/material.dart';
import 'package:zsquadfitness/ui/components/custom_appbar.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(showLogout: false),
      body: const Center(
        child: Text("Bookings Page!", style: AppTextStyles.h1),
      ),
    );
  }
}
