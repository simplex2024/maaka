import 'package:flutter/material.dart';
import '../../auth/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final _slides = const [
    _OnboardingSlide(
      image: 'assets/images/onboarding_screen1_img.png',
      title: 'Order Easily, Anytime',
      description:
          'Place your order from nearby stores with just a few taps. Simple, safe, and convenient.',
    ),
    _OnboardingSlide(
      image: 'assets/images/onboarding_screen2_img.png',
      title: 'Earn Pocket Money by Helping Others',
      description:
          '"Accept delivery requests from nearby elders, deliver with kindness, and grow your savings every day."',
    ),
    _OnboardingSlide(
      image: 'assets/images/onboarding_screen3_img.png',
      title: 'Helped by Youth Around You',
      description:
          'Local students earn pocket money by helping with deliveries. You support their savings journey',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_currentPage == _slides.length - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final isSmall = mq.height < 700;

    // Responsive values
    final double topGap = mq.height * 0.08;
    final double imageHeight = (mq.height * 0.35).clamp(200, 360);
    final double titleSize = isSmall ? 22 : 24;
    final double descSize = isSmall ? 14 : 16;

    final double footerHeight = mq.height * 0.11;
    final double buttonWidth = mq.width * 0.38;
    final double buttonHeight = mq.height * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            // PAGEVIEW
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (_, index) {
                  final slide = _slides[index];
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: mq.width * 0.06,
                        vertical: mq.height * 0.02,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: topGap),

                          // IMAGE (RESPONSIVE)
                          SizedBox(
                            height: imageHeight,
                            child: Image.asset(slide.image, fit: BoxFit.contain),
                          ),

                          SizedBox(height: mq.height * 0.05),

                          // TITLE
                          Text(
                            slide.title,
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0B1F3A),
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: mq.height * 0.03),

                          // DESCRIPTION
                          SizedBox(
                            width: mq.width * 0.80,
                            child: Text(
                              slide.description,
                              style: TextStyle(
                                fontSize: descSize,
                                color: Colors.black,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(height: mq.height * 0.03),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // FOOTER
            SafeArea(
              top: false,
              child: Container(
                height: footerHeight.clamp(70, 110),
                padding: EdgeInsets.symmetric(
                  horizontal: mq.width * 0.06,
                  vertical: mq.height * 0.015,
                ),
                child: Row(
                  children: [
                    // DOT INDICATORS
                    Row(
                      children: List.generate(
                        _slides.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: EdgeInsets.symmetric(horizontal: mq.width * 0.01),
                          height: 8,
                          width: _currentPage == index ? 28 : 10,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? const Color(0xFF0B1F3A)
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // NEXT / GET STARTED BUTTON
                    SizedBox(
                      width: buttonWidth.clamp(120, 200),
                      height: buttonHeight.clamp(44, 56),
                      child: ElevatedButton(
                        onPressed: _handleNext,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: const Color(0xFF0B1F3A),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          _currentPage == _slides.length - 1 ? "Get Started" : "Next",
                          style: TextStyle(
                            fontSize: isSmall ? 15 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;
}
