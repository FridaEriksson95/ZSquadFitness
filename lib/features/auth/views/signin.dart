import 'package:flutter/material.dart';
import 'package:zsquadfitness/features/auth/auth_actions.dart';
import 'package:zsquadfitness/features/auth/views/reset_password.dart';
import 'package:zsquadfitness/shared/ui/components/custom_textfield.dart';
import 'package:zsquadfitness/shared/ui/components/primary_button.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';
import 'package:zsquadfitness/shared/ui/extensions/context_extensions.dart';

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
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: context.screenWidth,
        height: context.screenHeight,
        decoration: bgLoginRegister,
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
                            decoration: boxBGLoginPage,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  gapH20,
                                  CustomTextfield(
                                    labelText: AppStrings.email,
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
                                    labelText: AppStrings.password,
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
                                        ? AppStrings.loginLoad
                                        : AppStrings.loginBtn,
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
                                      onPressed: () =>
                                          showResetPasswordDialog(context),
                                      style: TextButton.styleFrom(
                                        padding: paddingOnlyLxsmall,
                                      ),
                                      child: Text(
                                        AppStrings.forgotPW,
                                        style: AppTextStyles.vidaLoka14LG
                                            .copyWith(
                                              color: AppColors.neonGreen,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  AppColors.neonGreen,
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
                          dividerGreenish,
                          gapH15,
                          GestureDetector(
                            onTap: _googleSignin,
                            child: Container(
                              height: 60,
                              margin: marginOnlyRL,
                              decoration: googleSignInGradient,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  googleImage,
                                  gapW12,
                                  Text(
                                    _isLoading
                                        ? AppStrings.loginLoad
                                        : AppStrings.signInGoogle,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.geist20LB,
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
                              Text(
                                AppStrings.newUser,
                                style: AppTextStyles.vidaLoka14LG,
                              ),
                              TextButton(
                                onPressed: widget.onToggle,
                                style: TextButton.styleFrom(
                                  padding: paddingOnlyL5,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  AppStrings.createAccount,
                                  style: AppTextStyles.geist16LG.copyWith(
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
                            child: logoBlack300,
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
    setState(() => _isLoading = true);
    final success = await performEmailSignin(
      context,
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (mounted) setState(() => _isLoading = false);
    if (success) widget.onToggle();
  }

  Future<void> _googleSignin() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await performGoogleSignIn(context);
    if (mounted) setState(() => _isLoading = false);
  }
}
