import 'package:flutter/material.dart';
import 'package:maaakanmoney/core/common_widgets/persistent_bottom_navbar_component.dart';
import 'package:maaakanmoney/core/constants/app_colors.dart';
import 'package:maaakanmoney/features/dashboard/presentation/screens/grocery_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return PersistentBottomBarComponent(
      buildScreens: [
        GroceryScreen(),
        Scaffold(
            backgroundColor: AppColors.greyColor,
            body: Center(
              child: Text("Meat Screen"),
            )),
        Scaffold(
            backgroundColor: AppColors.greyColor,
            body: Center(
              child: Text("E-Shopping Screen"),
            )),
        Scaffold(
            backgroundColor: AppColors.greyColor,
            body: Center(
              child: Text("Piggy Bank Screen"),
            )),
        Scaffold(
            backgroundColor: AppColors.greyColor,
            body: Center(
              child: Text("About Screen"),
            )),
      ],
    );
  }
}
