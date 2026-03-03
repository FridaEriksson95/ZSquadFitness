import 'package:flutter/material.dart';
import 'package:zsquadfitness/services/auth.dart';
import 'package:zsquadfitness/ui/components/custom_textfield.dart';
import 'package:zsquadfitness/ui/components/primary_button.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_assets.dart';
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
            image: AssetImage(AppAssets.background),
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
                                      onPressed: _resetPassword,
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
                                    AppAssets.googleLogo,
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
                              AppAssets.logoBlack,
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

  Future<void> _resetPassword() async {
    final TextEditingController resetEmailController = TextEditingController();
    bool isLoading = false;
    String? errorMessage;
    bool emailSent = false;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: borderRadiusBig),
              contentPadding: paddingAll24,
              backgroundColor: AppColors.background.withValues(alpha: 0.9),
              titlePadding: paddingOnlyLRT,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    emailSent ? 'Mejl skickat!' : 'Glömt lösenord?',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.neonGreen,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    icon: const Icon(Icons.close, color: AppColors.darkRed),
                    padding: paddingOnlyL,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              content: emailSent
                  ? Padding(
                      padding: paddingOnlyBs,
                      child: Text(
                        'Kontrollera din inkorg (och skräppost) för återställningslänk',
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ange din epost så skickas en återställningslänk till din inkorg.',
                          style: AppTextStyles.bodySmall,
                        ),
                        gapH15,
                        CustomTextfield(
                          labelText: 'Epost',
                          keyboardType: TextInputType.emailAddress,
                          controller: resetEmailController,
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: AppColors.lightGrey,
                          ),
                        ),
                        if (errorMessage != null) ...[
                          gapH10,
                          Text(
                            errorMessage!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.darkRed,
                            ),
                          ),
                        ],
                      ],
                    ),
              actionsPadding: paddingOnlyLRT,
              actions: [
                PrimaryButton(
                  text: emailSent
                      ? (isLoading ? 'Skickar igen..' : 'Skicka igen')
                      : (isLoading ? 'Skickar..' : 'Skicka länk'),
                  color: AppColors.turquise,
                  onPressed: isLoading
                      ? null
                      : () async {
                          final email = resetEmailController.text.trim();

                          if (email.isEmpty) {
                            setDialogState(() {
                              errorMessage = 'Ange en giltig epost';
                            });
                            return;
                          }

                          setDialogState(() {
                            isLoading = true;
                            errorMessage = null;
                          });

                          try {
                            await AuthService().sendPasswordResetEmail(email);
                            setDialogState(() {
                              emailSent = true;
                              isLoading = false;
                            });
                          } catch (e) {
                            setDialogState(() {
                              errorMessage = e.toString().replaceFirst(
                                'Exception: ',
                                '',
                              );
                              isLoading = false;
                            });
                          }
                        },
                ),

                gapH20,
              ],
            );
          },
        );
      },
    );
  }
}
