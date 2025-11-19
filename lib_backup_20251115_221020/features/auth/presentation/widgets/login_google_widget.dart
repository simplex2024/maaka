import 'package:flutter/material.dart';
import 'package:maaakanmoney/core/constants/app_colors.dart';
import 'package:maaakanmoney/core/constants/app_styles.dart';
import 'package:sizer/sizer.dart';

class LoginGoogleWidget extends StatelessWidget {
  final String? labelText;
  final String? image;
  final GestureTapCallback? onPressed;

  const LoginGoogleWidget(
      {super.key, this.labelText, this.image, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(image!),
            Text(
              labelText!,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryBlackTextColor),
            ),
            SizedBox()
          ],
        ),
      ),
    );
  }
}
