import 'package:flutter/material.dart';
import 'package:maaakanmoney/core/common_widgets/common_button.dart';
import 'package:maaakanmoney/core/constants/app_colors.dart';
import 'package:maaakanmoney/core/constants/app_routes.dart';

class OnboardingContent {
  final String image;
  final String title;
  final String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<OnboardingContent> onboardingPages = [
  OnboardingContent(
    image: 'assets/images/onboarding_screen1_img.png',
    title: 'Order Easily, Anytime',
    description:
        'Place your order from nearby stores with just a few taps. Simple, safe, and convenient.',
  ),
  OnboardingContent(
    image: 'assets/images/onboarding_screen2_img.png',
    title: 'Earn Pocket Money by Helping Others',
    description:
        '"Accept delivery requests from nearby elders, deliver with kindness, and grow your savings every day."',
  ),
  OnboardingContent(
    image: 'assets/images/onboarding_screen3_img.png',
    title: 'Helped by Youth Around You',
    description:
        'Local students earn pocket money by helping with deliveries. You support their savings journey.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: onboardingPages.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (_, index) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Image.asset(onboardingPages[index].image, height: 300),
                    const SizedBox(height: 40),
                    Text(
                      onboardingPages[index].title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      onboardingPages[index].description,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingPages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentIndex == index ? 20 : 8,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? AppColors.primaryButtonColor
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                CommonButton(
                  buttonText: 'Next',
                  onPressed: () {
                    if (_currentIndex == onboardingPages.length - 1) {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.loginScreen);
                      // Navigate to Home/Login
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
