import 'package:flutter/material.dart';
import 'package:maaakanmoney/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class ShopCardComponent extends StatelessWidget {
  final String name;
  final String distance;
  final String rating;
  final String owner;
  final String imageUrl;

  const ShopCardComponent({
    super.key,
    required this.name,
    required this.distance,
    required this.rating,
    required this.owner,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: Image.asset(imageUrl,
                  height: 100, width: double.infinity, fit: BoxFit.cover),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(name,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.sp)),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(distance,
                    style:
                        TextStyle(color: AppColors.greenColor, fontSize: 12)),
                Row(
                  children: [
                    Text(rating, style: TextStyle(fontSize: 12)),
                    SizedBox(width: 2,),
                    Icon(Icons.star, color: Colors.yellow, size: 16),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 14)),
                SizedBox(width: 6),
                Text(owner, style: TextStyle(fontSize: 12)),
              ],
            ),
            SizedBox(height: 7),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greyDotColor,
                    foregroundColor: AppColors.primaryBlackTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                  onPressed: () {},
                  child: Text("View More")),
            ),
          ],
        ),
      ),
    );
  }
}
