import 'package:flutter/material.dart';
import 'package:maaakanmoney/core/constants/app_colors.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:sizer/sizer.dart';

class PersistentBottomBarComponent extends StatefulWidget {
  final List<Widget> buildScreens;

  const PersistentBottomBarComponent({super.key, required this.buildScreens});

  @override
  State<PersistentBottomBarComponent> createState() =>
      _PersistentBottomBarComponentState();
}

class _PersistentBottomBarComponentState
    extends State<PersistentBottomBarComponent> {
  PersistentTabController controller = PersistentTabController();

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: Image.asset(
            "assets/images/shopping_bag.png",
            color: AppColors.primaryWhiteTextColor,
          ),
          inactiveIcon: Image.asset(
            "assets/images/shopping_bag.png",
            color: Colors.grey,
          ),
          title: ("Grocery"),
          textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          activeColorPrimary: AppColors.greenColor,
          inactiveColorPrimary: Colors.white,
          activeColorSecondary: AppColors.primaryWhiteTextColor),
      PersistentBottomNavBarItem(
          icon: Image.asset(
            "assets/images/meat_icon.png",
            color: AppColors.primaryWhiteTextColor,
          ),
          inactiveIcon: Image.asset(
            "assets/images/meat_icon.png",
            color: Colors.grey,
          ),
          title: ("Meat"),
          activeColorPrimary: AppColors.meatColor,
          inactiveColorPrimary: Colors.grey,
          activeColorSecondary: AppColors.primaryWhiteTextColor),
      PersistentBottomNavBarItem(
          icon: Image.asset(
            "assets/images/eshopping_icon.png",
            color: AppColors.primaryWhiteTextColor,
          ),
          inactiveIcon: Image.asset(
            "assets/images/eshopping_icon.png",
            color: Colors.grey,
          ),
          title: ("E-Shopping"),
          activeColorPrimary: AppColors.eShoppingColor,
          inactiveColorPrimary: Colors.grey,
          activeColorSecondary: AppColors.primaryWhiteTextColor),
      PersistentBottomNavBarItem(
          icon: Image.asset(
            "assets/images/piggy_bank.png",
            color: AppColors.primaryWhiteTextColor,
          ),
          inactiveIcon: Image.asset(
            "assets/images/piggy_bank.png",
            color: Colors.grey,
          ),
          title: ("Piggy Bank"),
          activeColorPrimary: AppColors.piggyBankColor,
          inactiveColorPrimary: Colors.grey,
          activeColorSecondary: AppColors.primaryWhiteTextColor),
      PersistentBottomNavBarItem(
          icon: Icon(
            Icons.info,
            color: AppColors.primaryWhiteTextColor,
          ),
          inactiveIcon: Icon(
            Icons.info,
            color: Colors.grey,
          ),
          title: ("About"),
          activeColorPrimary: AppColors.primaryButtonColor,
          inactiveColorPrimary: Colors.grey,
          activeColorSecondary: AppColors.primaryWhiteTextColor),
      // Add more items here
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: widget.buildScreens,
      items: _navBarsItems(),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      padding: const EdgeInsets.only(top: 8),
      backgroundColor: AppColors.primaryWhiteTextColor,
      isVisible: true,
      decoration: NavBarDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          colorBehindNavBar: AppColors.greyDotColor),
     /* animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),*/
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle: NavBarStyle.style7,
    );
  }
}
