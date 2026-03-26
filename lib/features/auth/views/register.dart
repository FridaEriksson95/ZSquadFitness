import 'package:flutter/material.dart';
import 'package:zsquadfitness/features/auth/auth_actions.dart';
import 'package:zsquadfitness/shared/ui/components/custom_textfield.dart';
import 'package:zsquadfitness/shared/ui/components/primary_button.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/components/snackbar_utils.dart';
import 'package:zsquadfitness/shared/ui/extensions/context_extensions.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';
import 'package:zsquadfitness/core/utils/phone_validator.dart';

class RegisterAccountPage extends StatefulWidget {
  final VoidCallback onToggle;
  const RegisterAccountPage({super.key, required this.onToggle});

  @override
  State<RegisterAccountPage> createState() => _RegisterAccountPageState();
}

class _RegisterAccountPageState extends State<RegisterAccountPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Registration build with form validation and optional Google sign in
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
                            decoration: boxBGTransparent,
                            child: Form(
                              key: _formKey,
                              child: Column(
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppStrings.submitEmail;
                                      }
                                      if (!RegExp(
                                        r'^[^@]+@[^@]+\.[^@]+',
                                      ).hasMatch(value)) {
                                        return AppStrings.errorEmail;
                                      }
                                      return null;
                                    },
                                  ),
                                  gapH20,
                                  CustomTextfield(
                                    labelText: AppStrings.name,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    controller: _nameController,
                                    prefixIcon: const Icon(
                                      Icons.person_outline_rounded,
                                      color: AppColors.lightGrey,
                                    ),
                                    validator: (value) => value?.isEmpty ?? true
                                        ? AppStrings.submitName
                                        : null,
                                  ),
                                  gapH20,
                                  CustomTextfield(
                                    labelText: AppStrings.phone,
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.next,
                                    controller: _phoneController,
                                    prefixIcon: const Icon(
                                      Icons.phone_android_rounded,
                                      color: AppColors.lightGrey,
                                    ),
                                    restrictToDigits: true,
                                  ),
                                  gapH20,
                                  CustomTextfield(
                                    labelText: AppStrings.password,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.next,
                                    controller: _passwordController,
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: AppColors.lightGrey,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppColors.lightGrey,
                                      ),
                                      onPressed: () => setState(
                                        () => _obscurePassword =
                                            !_obscurePassword,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.length < 8) {
                                        return AppStrings.minimunPW;
                                      }
                                      return null;
                                    },
                                  ),
                                  gapH20,
                                  CustomTextfield(
                                    labelText: AppStrings.repeatPassword,
                                    obscureText: _obscureConfirmPassword,
                                    textInputAction: TextInputAction.done,
                                    controller: _confirmPasswordController,
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: AppColors.lightGrey,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppColors.lightGrey,
                                      ),
                                      onPressed: () => setState(
                                        () => _obscureConfirmPassword =
                                            !_obscureConfirmPassword,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value != _passwordController.text) {
                                        return AppStrings.noMatchPW;
                                      }
                                      return null;
                                    },
                                  ),
                                  gapH20,
                                  PrimaryButton(
                                    text: _isLoading
                                        ? AppStrings.registerLoad
                                        : AppStrings.register,
                                    onPressed: _isLoading
                                        ? null
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() => _isLoading = true);
                                              _register();
                                            }
                                          },
                                    color: AppColors.turquise,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          gapH15,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppStrings.accountCheck,
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
                                  AppStrings.signIn,
                                  style: AppTextStyles.geist16LG.copyWith(
                                    color: AppColors.neonGreen,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.neonGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          dividerGreenish,

                          Text(
                            AppStrings.or,
                            style: AppTextStyles.vidaLoka14LG.copyWith(
                              color: AppColors.lightGrey,
                            ),
                          ),
                          gapH10,
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
                                    AppStrings.signInGoogle,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.geist20LB,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          gapH20,
                          Padding(padding: paddingZero, child: logoBlack120),
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

  /// Validates phonenr, then register with email and password
  Future<void> _register() async {
    final phoneError = validatePhone(_phoneController.text.trim());
    if (phoneError != null) {
      if (mounted) {
        showAppSnackBar(context, message: phoneError);
      }
      setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = true);
    final success = await performRegister(
      context,
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) widget.onToggle();
    }
  }

  /// Starts Google sign in flow and is loading process
  Future<void> _googleSignin() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await performGoogleSignIn(context);
    if (mounted) setState(() => _isLoading = false);
  }
}
