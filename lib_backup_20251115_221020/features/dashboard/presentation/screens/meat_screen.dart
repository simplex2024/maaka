import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maaakanmoney/core/constants/app_colors.dart';
import 'package:maaakanmoney/core/constants/app_routes.dart';
import 'package:maaakanmoney/features/dashboard/presentation/widgets/meat_card_component.dart';
import 'package:maaakanmoney/features/dashboard/presentation/widgets/shop_card_component.dart';
import 'package:sizer/sizer.dart';

class MeatScreen extends ConsumerStatefulWidget {
  const MeatScreen({super.key});

  @override
  ConsumerState<MeatScreen> createState() => _MeatScreenState();
}

class _MeatScreenState extends ConsumerState<MeatScreen> {
  bool isSelected = true;
  final List<Map<String, String>> chickenMeats = [
    {
      'meatName': 'Ordinary Chicken',
      'image': 'assets/images/ordinary_chicken.png'
    },
    {'meatName': 'Chicken Boanless', 'image': 'assets/images/chicken_boneless.png'},
    {
      'meatName': 'Chicken leg piece',
      'image': 'assets/images/chicken_leg_piece.png'
    },
  ];
  final List<Map<String, String>> muttonMeats = [
    {
      'meatName': 'Ordinary Mutton',
      'image': 'assets/images/ordinary_mutton.png'
    },
    {'meatName': 'Mutton Liver', 'image': 'assets/images/mutton_liver.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
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
                          text: " Meat",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.meatColor),
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
                            color: AppColors.meatColor,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                "assets/images/cart_icon.png",
                              ),
                              Positioned(
                                top: 2,
                                right: 7,
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryWhiteTextColor),
                                  child: Text(
                                    "4",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.meatColor,
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
                    color: AppColors.primaryBlackTextColor,
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
                  color: AppColors.meatColor,
                  borderRadius: BorderRadius.circular(23),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 25,
                            width: 1,
                            color: Colors.white, // divider
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.mic, color: Colors.white),
                          const SizedBox(width: 8),
                        ],
                      ),
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
                "Meats List's",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? AppColors.meatColor
                            : AppColors.screenBackgroundColor,
                        foregroundColor: isSelected
                            ? AppColors.primaryWhiteTextColor
                            : AppColors.meatColor,
                        side: BorderSide(
                          color: AppColors.meatColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Rounded corners
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isSelected = true;
                        });
                      },
                      child: Text("Chicken")),
                  SizedBox(width: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !isSelected
                            ? AppColors.meatColor
                            : AppColors.screenBackgroundColor,
                        foregroundColor: !isSelected
                            ? AppColors.primaryWhiteTextColor
                            : AppColors.meatColor,
                        side: BorderSide(
                          color: AppColors.meatColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Rounded corners
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isSelected = false;
                        });
                      },
                      child: Text("Mutton")),
                ],
              ),
              SizedBox(height: 20),
              isSelected
                  ? Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 3,
                          crossAxisSpacing: 3,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: chickenMeats.length,
                        itemBuilder: (context, index) {
                          final chickenMeat = chickenMeats[index];
                          return MeatCardComponent(
                            meatName: chickenMeat['meatName']!,
                            imageUrl: chickenMeat['image']!,
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 3,
                          crossAxisSpacing: 3,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: muttonMeats.length,
                        itemBuilder: (context, index) {
                          final muttonMeat = muttonMeats[index];
                          return MeatCardComponent(
                            meatName: muttonMeat['meatName']!,
                            imageUrl: muttonMeat['image']!,
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
