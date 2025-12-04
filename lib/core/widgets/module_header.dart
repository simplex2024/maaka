import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ModuleHeader extends StatelessWidget implements PreferredSizeWidget {
  final String moduleName;
  final Color themeColor;
  final String location;
  final List<Widget>? actions;

  const ModuleHeader({
    super.key,
    required this.moduleName,
    required this.themeColor,
    this.location = 'Nesapakkam, Chennai',
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Maaka',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blackprimaryapp,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    moduleName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: themeColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: themeColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.blacksecondaryapp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (actions != null)
            Row(
              children: actions!,
            ),
        ],
      ),
    );
  }
}

class ModuleActionIcon extends StatelessWidget {
  final IconData icon;
  final Color? backgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const ModuleActionIcon({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.iconColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xFFEEEEEE),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 22,
          color: iconColor,
        ),
      ),
    );
  }
}
