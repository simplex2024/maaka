import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maaakanmoney/core/constants/app_routes.dart';
import 'package:maaakanmoney/pages/Auth/mpin.dart';
import 'package:maaakanmoney/pages/Auth/phone_auth_widget.dart';
import 'package:maaakanmoney/phoneController.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fillAnimation;
  String? loginKey;
  String? mPin;
  String? shoppingKey;
  late StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fillAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();

    Timer(const Duration(seconds: 4), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      loginKey = prefs.getString("LoginSuccessuser1");
      mPin = prefs.getString("Mpin");
      shoppingKey = prefs.getString("ShoppingUser");
      var isviewed = prefs.getInt('onBoard');

      if ((isviewed == 0) || (isviewed == null)) {
        Navigator.pushReplacementNamed(context, AppRoutes.onboardingScreen);
      } else {
        if (loginKey == null || loginKey == "" || loginKey!.isEmpty) {
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => const MyPhone()));
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (_, __, ___) => MyPhone(
                getIsShoppingUserName: shoppingKey,
              ),
              transitionsBuilder: (_, animation, __, child) {
                return ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.0, // You can adjust the start scale
                    end: 1.0, // You can adjust the end scale
                  ).animate(animation),
                  child: child,
                );
              },
            ),
          );
        } else {
          String? myString = loginKey;
          String lastFourDigits =
              (myString ?? "").substring((myString ?? "").length - 4);

          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (_, __, ___) => MpinPageWidget(
                getMobileNo: loginKey ?? "",
                getMpin: mPin,
              ),
              transitionsBuilder: (_, animation, __, child) {
                return ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.0, // You can adjust the start scale
                    end: 1.0, // You can adjust the end scale
                  ).animate(animation),
                  child: child,
                );
              },
            ),
          );
        }
      }
    });
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      print("aaaaaa$result");

      if (result != null || result.isNotEmpty) {
        ref.read(connectivityProvider.notifier).state = result[0];
      }
    });
  }

  @override
  dispose() {
    subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("assets/images/app_logo.png")),
    );
  }
}
