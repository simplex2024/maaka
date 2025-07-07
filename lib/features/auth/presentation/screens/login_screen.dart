import 'package:flutter/material.dart';
import 'package:maaakanmoney/core/common_widgets/common_button.dart';
import 'package:maaakanmoney/core/constants/app_colors.dart';
import 'package:maaakanmoney/core/constants/app_constants.dart';
import 'package:maaakanmoney/core/constants/icon_images.dart';
import 'package:maaakanmoney/features/auth/presentation/widgets/login_google_widget.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                const SizedBox(height: 20),
                // Welcome text
                Text(
                  Constant.welcomeBackToMaaka,
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 14),
                Text(
                  Constant.localHelpAtYourDoorStep,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.subTitleGreyColor),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Text(
                      Constant.phoneNumber,
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlackTextColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 7.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    hintText: Constant.enterYourMobileNumber,
                    focusColor: AppColors.primaryButtonColor,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.primaryButtonColor)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.primaryButtonColor)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: AppColors.primaryButtonColor)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: CommonButton(
                      onPressed: () {},
                      buttonText: Constant.sendOTP,
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
                const SizedBox(height: 24),
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
