import 'package:flutter/material.dart';

import 'core/config/theme/app_theme.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

void main() {
  runApp(const MaakaSampleApp());
}

class MaakaSampleApp extends StatelessWidget {
  const MaakaSampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maaka Sample',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const SplashScreen(),
    );
  }
}

