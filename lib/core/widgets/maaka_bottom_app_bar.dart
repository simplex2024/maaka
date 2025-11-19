import 'package:flutter/material.dart';
import '../models/bottom_menu_item.dart';

class MaakaBottomAppBar extends StatelessWidget {
  const MaakaBottomAppBar({
    super.key,
    required this.menuItems,
    required this.selectedIndex,
    this.theme = BottomMenuTheme.green,
    this.height = 70,
  });

  final List<BottomMenuItem> menuItems;
  final int selectedIndex;
  final BottomMenuTheme theme;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.barBackgroundColor,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          menuItems.length,
          (index) => _buildMenuItem(index),
        ),
      ),
    );
  }

  Widget _buildMenuItem(int index) {
    final item = menuItems[index];
    final isSelected = index == selectedIndex;

    if (isSelected) {
      // Selected item with background, icon, and text
      return Flexible(
        flex: 2,
        child: GestureDetector(
          onTap: item.onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: theme.selectedBackgroundColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.icon,
                  color: theme.selectedIconColor,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: theme.selectedTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Unselected item - icon only
      return Flexible(
        child: GestureDetector(
          onTap: item.onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              item.icon,
              color: theme.unselectedIconColor,
              size: 24,
            ),
          ),
        ),
      );
    }
  }
}

