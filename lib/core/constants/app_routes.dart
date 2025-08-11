import 'package:flutter/material.dart';
import 'package:maaakanmoney/features/auth/presentation/screens/login_screen.dart';
import 'package:maaakanmoney/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:maaakanmoney/features/auth/presentation/screens/otp_screen.dart';
import 'package:maaakanmoney/features/dashboard/presentation/screens/order_by_voice_screen.dart';
import 'package:maaakanmoney/features/dashboard/presentation/screens/order_creation_screen.dart';
import 'package:maaakanmoney/features/splash_screen/presentation/screens/spalsh_screen.dart';
import 'package:maaakanmoney/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:maaakanmoney/pages/Auth/phone_auth_widget.dart';
import 'package:maaakanmoney/features/onBoarding_Screen/presentation/screens/onboardScreen.dart';

class AppRoutes {
  static const String splashScreen = '/splashScreen';
  static const String onboardingScreen = '/onboardingScreen';
  static const String loginScreen = '/loginScreen';
  static const String otpScreen = '/otpScreen';
  static const String dashboardScreen = '/dashboardScreen';
  static const String orderCreationScreen = '/orderCreationScreen';
  static const String orderByVoiceScreen = '/orderByVoiceScreen';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    /*  case onboardingScreen:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case otpScreen:
        return MaterialPageRoute(builder: (_) => OtpScreen());
      case dashboardScreen:
        return MaterialPageRoute(builder: (_) => DashboardScreen());*/
      case onboardingScreen:
        return MaterialPageRoute(builder: (_) => OnBoard());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => MyPhone());
      case otpScreen:
        return MaterialPageRoute(builder: (_) => OtpScreen());
      case dashboardScreen:
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case orderCreationScreen:
        return MaterialPageRoute(builder: (_) => OrderCreationScreen());
      case orderByVoiceScreen:
        return MaterialPageRoute(builder: (_) => OrderByVoiceScreen());
      default:
        return null;
    }
  }
}
