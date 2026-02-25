import 'package:flutter/material.dart';
import 'package:zsquadfitness/pages/register.dart';
import 'package:zsquadfitness/services/auth.dart';
import 'package:zsquadfitness/ui/components/primary_button.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';
import 'package:zsquadfitness/ui/extensions/context_extensions.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: context.screenWidth,
        height: context.screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 380),
          margin: marginHorizon,
          padding: paddingAll8,
          decoration: BoxDecoration(
            color: AppColors.lightBlack,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.neonGreen, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonGreen,
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: paddingH16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Z SQUAD FITNESS",
                            style: AppTextStyles.h2,
                            textAlign: TextAlign.center,
                          ),
                          gapH10,
                          PrimaryButton(
                            text: 'LOGGA IN',
                            onPressed: () {},
                            color: AppColors.turquise,
                          ),
                          gapH30,
                          GestureDetector(
                            onTap: () {
                              AuthService().signInWithGoogle(context);
                            },
                            child: Container(
                              height: 55,
                              margin: marginOnlyRL,
                              decoration: BoxDecoration(
                                color: AppColors.neonGreen,
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(3),
                                    blurRadius: 5,
                                    offset: const Offset(3, 4),
                                  ),
                                ],
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
                                  gapW12,
                                  Text(
                                    'Logga in med Google',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.buttonText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          gapH20,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Ny här?', style: AppTextStyles.bodySmall),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterAccountPage(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.only(left: 5),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Skapa konto!',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.neonGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          gapH30,
                          Padding(
                            padding: paddingOnlyTB,
                            child: Image.asset(
                              'assets/images/LogoBlack.PNG',
                              height: 250,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
