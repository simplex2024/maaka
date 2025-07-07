import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:maaakanmoney/core/constants/app_styles.dart';

class OnboardingWidget extends StatelessWidget {
  final String? img;
  final String? title;
  final String? description;

  const OnboardingWidget({super.key, this.img, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(img!),
        SizedBox(
          height: 37.h,
        ),
        Text(
          title!,
          textAlign: TextAlign.center,
          style: AppStyles.headerTitleTextStyle,
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          description!,
          textAlign: TextAlign.center,
          style: AppStyles.descriptionTextStyle,
        )
      ],
    );
  }
}
