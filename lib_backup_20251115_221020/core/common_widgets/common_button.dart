import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:maaakanmoney/core/constants/app_colors.dart';
import 'package:maaakanmoney/core/constants/app_styles.dart';

class CommonButton extends StatefulWidget {
  final String? buttonText;
  final Function()? onPressed;

  const CommonButton({super.key, this.buttonText, this.onPressed});

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryButtonColor,
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
        ),
        onPressed: widget.onPressed!,
        child: Text(
          widget.buttonText!,
          style: AppStyles.buttonTextStyle,
        ));
  }
}
