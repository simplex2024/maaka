import 'package:flutter/material.dart';
import 'package:maaakanmoney/core/common_widgets/common_button.dart';
import 'package:maaakanmoney/core/constants/app_colors.dart';
import 'package:maaakanmoney/core/constants/app_constants.dart';
import 'package:maaakanmoney/core/constants/app_styles.dart';
import 'package:maaakanmoney/core/constants/icon_images.dart';
import 'package:maaakanmoney/features/auth/presentation/widgets/login_google_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: TextStyle(
        fontSize: 20,
        color: AppColors.subTitleGreyColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        Constant.back,
                        style: AppStyles.labelTextStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    IconImages.appLogo,
                  ),
                ),
                SizedBox(height: 10.0),
                // App name
                const Text(
                  Constant.maaka,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                // Welcome text
                Text(
                  Constant.verifyYourNumber,
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 14),
                Text(
                  Constant.weHaveSentAnOtp,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.greySixColor),
                ),
                const SizedBox(height: 40),
                Pinput(
                    length: 4,
                    controller: otpController,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryButtonColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: AppColors.primaryBlackTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )),

                const SizedBox(height: 20),
                Text(
                  Constant.dontHaveReceiveOtp,
                  style: AppStyles.labelTextStyle,
                ),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: CommonButton(
                      onPressed: () {},
                      buttonText: Constant.verifyAndContinue,
                    )),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(Constant.donTHaveAnAccount),
                    Text(
                      Constant.singUp,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                LoginGoogleWidget(
                  labelText: Constant.continueWithGoogle,
                  image: IconImages.googleIconImage,
                ),
                const SizedBox(height: 12),

                LoginGoogleWidget(
                  labelText: Constant.continueWithEmail,
                  image: IconImages.emailIconImage,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
