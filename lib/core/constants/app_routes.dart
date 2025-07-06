import 'package:flutter/material.dart';
import 'package:maaakanmoney/features/auth/presentation/screens/login_screen.dart';
import 'package:maaakanmoney/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:maaakanmoney/features/auth/presentation/screens/spalsh_screen.dart';
import 'package:maaakanmoney/pages/Auth/phone_auth_widget.dart';

class AppRoutes {
  static const String splashScreen = '/splashScreen';
  static const String onboardingScreen = '/onboardingScreen';
  static const String loginScreen = '/loginScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case onboardingScreen:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => MyPhone());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
