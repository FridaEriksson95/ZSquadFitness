import 'package:flutter/material.dart';
import 'package:zsquadfitness/services/auth.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page", style: AppTextStyles.bodyMedium),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("Welcome to the Home Page!", style: AppTextStyles.h1),
      ),
    );
  }
}
