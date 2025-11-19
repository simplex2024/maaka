import 'package:flutter/material.dart';
import 'package:maaakanmoney/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class MeatCardComponent extends StatelessWidget {
  final String? imageUrl;
  final String? meatName;

  const MeatCardComponent({super.key, this.imageUrl, this.meatName});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primaryWhiteTextColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(imageUrl!,width: 150,),
            Text(
              meatName!,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
            )
          ],
        ),
      ),
    );
  }
}
