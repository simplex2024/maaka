import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class MaakaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MaakaAppBar({
    super.key,
    this.title,
    this.showBack = false,
    this.backText,
    this.actions,
  });

  final String? title;
  final bool showBack;
  final String? backText;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.primary,
      elevation: 0,
      leading: showBack
          ? backText != null
              ? TextButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: Text(
                    backText!,
                    style: const TextStyle(
                      color: AppColors.blackprimaryapp,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).maybePop(),
                )
          : null,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      centerTitle: false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

