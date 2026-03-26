import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/theme/app_assets.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/core/utils/email_launcher.dart';

/// Main Appbar with text Logo
class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final double toolbarHeight;
  final double logoHeight;
  final double logoWidth;

  const CustomAppbar({
    super.key,
    this.toolbarHeight = 153,
    this.logoHeight = 350,
    this.logoWidth = 300,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: toolbarHeight,
      titleSpacing: 0,
      centerTitle: true,
      title: Image.asset(
        AppAssets.logoText,
        height: logoHeight,
        width: logoWidth,
        fit: BoxFit.contain,
      ),

      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: paddingAll8,
              child: IconButton(
                icon: Icon(
                  Icons.email_rounded,
                  color: AppColors.neonGreen.withValues(alpha: 0.8),
                ),
                onPressed: () => openEmail(context),
                tooltip: AppStrings.contactUs,
                iconSize: 32,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(153);
}
