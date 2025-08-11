import 'package:flutter/material.dart';
import 'package:maaakanmoney/core/constants/app_colors.dart';
import 'package:maaakanmoney/core/constants/app_routes.dart';
import 'package:maaakanmoney/features/dashboard/presentation/widgets/shop_card_component.dart';
import 'package:sizer/sizer.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  final List<Map<String, String>> shops = [
    {
      'name': 'Karthi Grocercys',
      'distance': '50 m',
      'rating': '4/5',
      'owner': 'Rajesh Kumar',
      'image': 'assets/images/shop_img.png'
    },
    {
      'name': 'Naveen Department',
      'distance': '100 m',
      'rating': '4/5',
      'owner': 'Ram Kumar',
      'image': 'assets/images/shop_img.png'
    },
    {
      'name': 'Nithiya Maligai',
      'distance': '150 m',
      'rating': '4/5',
      'owner': 'Anitha',
      'image': 'assets/images/shop_img.png'
    },
    {
      'name': 'Praveen Shop',
      'distance': '200 m',
      'rating': '4/5',
      'owner': 'Praveen',
      'image': 'assets/images/shop_img.png'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      text: TextSpan(
                          text: 'Maaka',
                          style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                          children: [
                        TextSpan(
                          text: " grocery",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(38, 173, 113, 1)),
                        )
                      ])),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(212, 212, 212, 1),
                          ),
                          child: Image.asset(
                            "assets/images/notification_icon.png",
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.greenColor,
                        ),
                        child: Image.asset(
                          "assets/images/cart_icon.png",
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.greenColor,
                        ),
                        child: Image.asset(
                          "assets/images/call_icon.png",
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.greenColor,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Nesapakkam, Chennai",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp),
                  )
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.greenColor,
                  borderRadius: BorderRadius.circular(23),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      suffixIcon: Icon(Icons.mic, color: Colors.white),
                      hintText: "Search Shop",
                      hintStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(255, 255, 255, 0.6)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15)),
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Grocery's shops near by you",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  FilterChip(
                    label: Text(
                      "Distance",
                      style: TextStyle(color: AppColors.primaryWhiteTextColor),
                    ),
                    onSelected: (_) {},
                    selected: true,
                    selectedColor: AppColors.greenColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // more curve
                    ),
                  ),
                  SizedBox(width: 10),
                  FilterChip(
                    label: Text("Rating"),
                    onSelected: (_) {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // more curve
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Shops Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: shops.length,
                  itemBuilder: (context, index) {
                    final shop = shops[index];
                    return ShopCardComponent(
                      name: shop['name']!,
                      distance: shop['distance']!,
                      rating: shop['rating']!,
                      owner: shop['owner']!,
                      imageUrl: shop['image']!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
