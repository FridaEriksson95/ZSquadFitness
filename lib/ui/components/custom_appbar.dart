import 'package:flutter/material.dart';
import 'package:zsquadfitness/services/auth.dart';
import 'package:zsquadfitness/ui/constants/gaps.dart';
import 'package:zsquadfitness/ui/theme/app_colors.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLogout;

  const CustomAppbar({super.key, this.showLogout = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 153,
      titleSpacing: 0,
      centerTitle: true,
      title: Image.asset(
        'assets/images/LogoText.png',
        height: 350,
        width: 300,
        fit: BoxFit.contain,
      ),
      actions: showLogout
          ? [
              Padding(
                padding: paddingAll8,
                child: IconButton(
                  icon: Icon(Icons.logout, color: AppColors.lightGrey),
                  onPressed: () async {
                    await AuthService().signOut();
                  },
                ),
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(153);
}
