import 'package:flutter/material.dart';
import 'package:maaakanmoney/core/constants/app_colors.dart';
import 'package:maaakanmoney/core/constants/app_styles.dart';
import 'package:sizer/sizer.dart';

class LoginGoogleWidget extends StatelessWidget {
  final String? labelText;
  final String? image;

  const LoginGoogleWidget({super.key, this.labelText, this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton.icon(
        icon: Image.asset(image!, height: 20),
        label: Text(labelText!, style: AppStyles.labelTextStyle),
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
