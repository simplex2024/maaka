import 'package:flutter/material.dart';
import 'package:maaakanmoney/core/constants/app_colors.dart';
import 'package:maaakanmoney/core/constants/app_styles.dart';
import 'package:sizer/sizer.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryWhiteTextColor,
        elevation: 1,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.greyDarkColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(6), // Space around icon
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2), // Background color
                  shape: BoxShape.circle, // Makes it round
                ),
                child: Icon(
                  Icons.done,
                  color: AppColors.groceryColor,
                  size: 18,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  "Order Placed Successfully",
                  style: AppStyles.subTitleTextStyle,
                ),
              ),
            ],
          ),

          // ✅ Progress Tracker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _progressStep(Icons.shopping_bag, true),
                    _progressLine(true),
                    _progressStep(Icons.person, false,
                        image: 'https://i.pravatar.cc/50'),
                    _progressLine(false),
                    _progressStep(Icons.directions_walk, false),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text("Order Placed", style: TextStyle(fontSize: 12)),
                    SizedBox(width: 5),
                    Text("Helper Assigned", style: TextStyle(fontSize: 12)),
                    SizedBox(width: 5),
                    Text("On the Way", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          // const SizedBox(height: 30),

          // ✅ Helper Card

          Container(
            height: 10.h,

            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(0),
            color: AppColors.screenBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage:
                      NetworkImage('https://i.pravatar.cc/50'),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryWhiteTextColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Arun Kumar",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            const Text("On the Way to Shop",
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey)),
                          ],
                        ),
                        Container(
                          height: 5.h,
                          width: 25.w,
                          decoration: BoxDecoration(
                            color: AppColors.groceryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:  Center(
                            child: Text("Local Helper",
                                style:
                                AppStyles.labelTextStyle,textAlign: TextAlign.center,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ✅ Store Card
          Container(
            height: 15.h,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryWhiteTextColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.location_on, color: AppColors.groceryColor, size: 20),
                    SizedBox(width: 8),
                    Text("Karthi Grocerys",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    Spacer(),
                    Text("50 m away",
                        style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.shopping_bag, color: AppColors.groceryColor, size: 20),
                    SizedBox(width: 8),
                    Text("7 items", style: TextStyle(fontSize: 15)),
                    Spacer(),
                    Text("From 2 Shops",
                        style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "Estimate to Pickup in",
                      style: TextStyle(fontSize: 13, color: AppColors.primaryBlackTextColor),
                    ),
                    const Text(
                      "  6–10 minutes",
                      style: TextStyle(fontSize: 13, color: AppColors.groceryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // const Spacer(),

          // ✅ Cancel Order Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Cancel Order",
                    style: TextStyle(color: Colors.black)),
              ),
            ),
          ),

          // const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Progress Step with Gradient
  Widget _progressStep(IconData icon, bool active, {String? image}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: active
            ? const LinearGradient(
                colors: [AppColors.groceryColor, AppColors.greyDarkColor],
                // Green shades
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  AppColors.primaryWhiteTextColor,
                  AppColors.primaryWhiteTextColor
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
      ),
      child: Center(
        child: image != null
            ? ClipOval(
                child: Image.network(image,
                    width: 28, height: 28, fit: BoxFit.cover),
              )
            : Icon(icon, color: active ? Colors.white : Colors.black, size: 20),
      ),
    );
  }

// Progress Line with Gradient
  Widget _progressLine(bool active) {
    return Expanded(
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(
                  colors: [AppColors.greyDarkColor, AppColors.screenBackgroundColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : LinearGradient(
                  colors: [
                    AppColors.primaryWhiteTextColor,
                    AppColors.primaryWhiteTextColor
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Colors.green : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: selected ? Colors.white : Colors.grey),
          if (selected)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }
}
