import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/pages/register.dart';
import 'package:zsquadfitness/services/auth.dart';
import 'package:zsquadfitness/ui/components/bottom_nav.dart';
import 'package:zsquadfitness/ui/components/custom_textfield.dart';
import 'package:zsquadfitness/ui/components/primary_button.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';
import 'package:zsquadfitness/ui/theme/app_textstyles.dart';
import 'package:zsquadfitness/ui/extensions/context_extensions.dart';

class SignInPage extends StatefulWidget {
  final VoidCallback onToggle;
  const SignInPage({super.key, required this.onToggle});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

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
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: paddingV40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 380),
                            margin: marginHorizon,
                            padding: paddingAll15,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: borderRadiusBig,
                              border: Border.all(
                                color: AppColors.greenish,
                                width: 1.5,
                              ),
                              boxShadow: [shadow],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  gapH20,
                                  CustomTextfield(
                                    labelText: 'Epost',
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    controller: _emailController,
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      color: AppColors.lightGrey,
                                    ),
                                  ),
                                  gapH20,
                                  CustomTextfield(
                                    labelText: 'Lösenord',
                                    obscureText: true,
                                    textInputAction: TextInputAction.done,
                                    controller: _passwordController,
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: AppColors.lightGrey,
                                    ),
                                  ),

                                  gapH20,

                                  PrimaryButton(
                                    text: _isLoading
                                        ? 'Loggar in...'
                                        : 'LOGGA IN',
                                    onPressed: _isLoading
                                        ? null
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() => _isLoading = true);
                                              _signin();
                                            }
                                          },
                                    color: AppColors.turquise,
                                  ),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                      onPressed: () {
                                        //TODO glömt lösenord funktion
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.only(left: 10),
                                      ),
                                      child: Text(
                                        'Glömt Lösenord?',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.neonGreen,
                                          decoration: TextDecoration.underline,
                                          decorationColor: AppColors.neonGreen,
                                          decorationThickness: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      gapH15,
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 250,
                            child: Divider(color: AppColors.greenish),
                          ),
                          gapH15,
                          GestureDetector(
                            onTap: () {
                              AuthService().signInWithGoogle(context);
                            },
                            child: Container(
                              height: 60,
                              margin: marginOnlyRL,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [0.0, 0.45, 1.0],
                                  colors: [
                                    AppColors.neonGreen,
                                    AppColors.neonGreen.withValues(alpha: 8.0),
                                    AppColors.neonGreen.withValues(alpha: 0.5),
                                  ],
                                ),
                                borderRadius: borderRadiusBig,
                                border: buttonGlassBorder,
                                boxShadow: [
                                  shadowGlass1,
                                  shadowGlass2,
                                  shadowGlass3,
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
                                onPressed: widget.onToggle,
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
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.neonGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          gapH20,
                          Padding(
                            padding: EdgeInsets.zero,
                            child: Image.asset(
                              'assets/images/LogoBlack.PNG',
                              height: 300,
                              width: 300,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signin() async {
    try {
      await AuthService().signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Inloggning misslyckades: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
