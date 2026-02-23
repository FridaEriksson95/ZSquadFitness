import 'package:flutter/material.dart';
import 'package:zsquadfitness/services/auth.dart';
import 'package:zsquadfitness/ui/components/primary_button.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up Page", style: AppTextStyles.h1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to the Sign Up Page!",
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                AuthService().signInWithGoogle(context);
              },
              child: Container(
                height: 55,
                margin: EdgeInsets.only(left: 10, right: 10),
                padding: EdgeInsets.only(top: 0, bottom: 0),
                decoration: BoxDecoration(
                  color: AppColors.neonGreen,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/google.png',
                      height: 30,
                      width: 30,
                      fit: BoxFit.fitHeight,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Logga in med Google',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.buttonText,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            PrimaryButton(
              text: 'LOGGA IN',
              onPressed: () {},
              color: AppColors.turquise,
            ),
          ],
        ),
      ),
    );
  }
}
