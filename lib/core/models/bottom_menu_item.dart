import 'package:flutter/material.dart';

class BottomMenuItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const BottomMenuItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}

class BottomMenuTheme {
  final Color selectedBackgroundColor;
  final Color selectedTextColor;
  final Color selectedIconColor;
  final Color unselectedIconColor;
  final Color barBackgroundColor;

  const BottomMenuTheme({
    required this.selectedBackgroundColor,
    required this.selectedTextColor,
    required this.selectedIconColor,
    required this.unselectedIconColor,
    required this.barBackgroundColor,
  });

  // Default green theme
  static const BottomMenuTheme green = BottomMenuTheme(
    selectedBackgroundColor: Color(0xFF26AC73), // Vibrant Green
    selectedTextColor: Colors.white,
    selectedIconColor: Colors.white,
    unselectedIconColor: Color(0xFF9E9E9E), // Grey
    barBackgroundColor: Colors.white,
  );

  // Red theme for Meat module
  static const BottomMenuTheme red = BottomMenuTheme(
    selectedBackgroundColor: Color(0xFFC2185B), // Pinkish Red
    selectedTextColor: Colors.white,
    selectedIconColor: Colors.white,
    unselectedIconColor: Color(0xFF9E9E9E), // Grey
    barBackgroundColor: Colors.white,
  );

  // Purple theme
  static const BottomMenuTheme purple = BottomMenuTheme(
    selectedBackgroundColor: Color(0xFF9C27B0),
    selectedTextColor: Colors.white,
    selectedIconColor: Colors.white,
    unselectedIconColor: Color(0xFF9E9E9E),
    barBackgroundColor: Color(0xFFF5F5F5),
  );

  // Orange theme
  static const BottomMenuTheme orange = BottomMenuTheme(
    selectedBackgroundColor: Color(0xFFFF9800),
    selectedTextColor: Colors.white,
    selectedIconColor: Colors.white,
    unselectedIconColor: Color(0xFF9E9E9E),
    barBackgroundColor: Color(0xFFF5F5F5),
  );
}

