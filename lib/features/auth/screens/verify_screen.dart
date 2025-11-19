import 'package:flutter/material.dart';

import '../../../data/models/auth_models.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/auth_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/widgets/maaka_app_bar.dart';
import '../../dashboard/screens/grocery_dashboard_screen.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({
    super.key,
    required this.phoneNumber,
    required this.expectedOtp,
  });

  final String phoneNumber;
  final String expectedOtp;

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _repository = AuthRepository(AuthService());
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  bool _isLoading = false;
  String? _error;

  String get _enteredOtp =>
      _controllers.map((c) => c.text.trim()).join();

  Future<void> _verify() async {
    // Check if OTP is entered (4 digits)
    if (_enteredOtp.length != 4) {
      setState(() {
        _error = 'Please enter 4-digit OTP';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Accept any OTP - just check if 4 digits are entered
    await Future.delayed(const Duration(milliseconds: 500)); // Small delay for UX
    
    if (!mounted) return;
    
    // Navigate to dashboard - accept any OTP
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const GroceryDashboardScreenProvider(),
      ),
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MaakaAppBar(
        showBack: true,
        backText: 'Back',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Logo & title section
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Image.asset(
                      IconImages.appLogo,
                      width: 64,
                      height: 64,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Maaka',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackprimaryapp,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Verify Your Number',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackprimaryapp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "We've sent an OTP to +91 ${widget.phoneNumber}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.blacksecondaryapp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  4,
                  (index) => _OtpBox(
                    controller: _controllers[index],
                    onChanged: (val) {
                      if (val.isNotEmpty && index < 3) {
                        FocusScope.of(context).nextFocus();
                      } else if (val.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                      setState(() {});
                    },
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              // Resend OTP
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          // Autofill mock OTP for quick testing
                          final digits = widget.expectedOtp.split('');
                          for (int i = 0; i < 4 && i < digits.length; i++) {
                            _controllers[i].text = digits[i];
                          }
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Auto-filled mock OTP ${widget.expectedOtp}'),
                            ),
                          );
                        },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Didn't receive OTP? ",
                          style: TextStyle(
                            color: AppColors.blacksecondaryapp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: "RESEND",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Verify button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _isLoading || _enteredOtp.length != 4 ? null : _verify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Verify & Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 14),
              // Signup text
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {},
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            color: AppColors.blackprimaryapp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: "Signup",
                          style: TextStyle(
                            color: AppColors.blackprimaryapp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Google and Email buttons
              const _GoogleButton(),
              const SizedBox(height: 12),
              const _EmailButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.4,
            ),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google Sign-In coming soon')),
          );
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: const BorderSide(color: Color(0xFFE0E0E0)),
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 12),
            Image.asset(
              IconImages.googleIconImage,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 60),
            const Text(
              'Continue With Google',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailButton extends StatelessWidget {
  const _EmailButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Continue with Email coming soon')),
          );
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: const BorderSide(color: Color(0xFFE0E0E0)),
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 12),
            Image.asset(
              IconImages.emailIconImage,
              width: 22,
              height: 22,
            ),
            const SizedBox(width: 60),
            const Text(
              'Continue With Email',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

