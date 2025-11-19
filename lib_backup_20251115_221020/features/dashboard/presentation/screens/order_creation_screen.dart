import 'package:flutter/material.dart';
import 'package:maaakanmoney/core/constants/app_colors.dart';
import 'package:maaakanmoney/core/constants/app_routes.dart';
import 'package:maaakanmoney/core/constants/app_styles.dart';
import 'package:maaakanmoney/core/constants/icon_images.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  runApp(OrderCreationScreen());
}

class OrderCreationScreen extends StatefulWidget {
  const OrderCreationScreen({super.key});

  @override
  State<OrderCreationScreen> createState() => _OrderCreationScreenState();
}

class _OrderCreationScreenState extends State<OrderCreationScreen> {
  final TextEditingController _groceryController = TextEditingController();

  @override
  void dispose() {
    _groceryController.dispose();
    super.dispose();
  }

  void _onCameraPressed() {
    // TODO: Add camera functionality
    debugPrint("Camera button pressed");
  }

  void _onSendPressed() {
    debugPrint("Grocery List: ${_groceryController.text}");
    _groceryController.clear();
  }

  void _onMicPressed() {
    // TODO: Add voice input
    debugPrint("Mic button pressed");
    Navigator.pushNamed(context, AppRoutes.orderByVoiceScreen);
  }

  void _onBottomNavTap(int index) {
    debugPrint("Bottom Nav tapped: $index");
  }

  Widget _roundIconButton(String imagePath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: AppColors.groceryColor,
          shape: BoxShape.circle,
        ),
        child: Image.asset(imagePath ?? ""),//Icon(icon, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: AppColors.screenBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 16),
                // Store Card
                Container(
                  height: 15.h,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.blue, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Container(
                      height: 15.h,
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(8),
                                //   child: Image.network(
                                //     'https://picsum.photos/80', // Replace with actual
                                //     width: 60,
                                //     height: 60,
                                //     fit: BoxFit.cover,
                                //   ),
                                // ),
                                // ClipRRect(
                                //   borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                //   child: Image.asset(imageUrl,
                                //       height: 100, width: double.infinity, fit: BoxFit.cover),
                                // ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(IconImages.shopImage,
                                      height: 50, width: 50, fit: BoxFit.cover),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "Karthi Grocerys",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            "(50 m)",
                                            style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        "Owned by : Rajesh Kumar",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 4),

                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                        'https://i.pravatar.cc/50',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 4),

                                  ],
                                )
                              ],
                            ),
                          ),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    const SizedBox(height: 4),
                                    const Text(
                                      "Open till 9 PM",
                                      style:
                                      TextStyle(fontSize: 12, color: AppColors.primaryBlackTextColor),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [

                                  const SizedBox(height: 4),
                                  Row(
                                    children: const [
                                      Text("4/5"),
                                      Icon(Icons.star, color: Colors.amber, size: 16),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Create Your List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Create Your List",
                    style: AppStyles.subTitleTextStyle,
                  ),
                ),
                Container(
                  height: 25.h,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _groceryController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: "Type the Grocery's list",
                          border: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          _roundIconButton(IconImages.cameraImage, _onCameraPressed),
                          const SizedBox(width: 10),
                          _roundIconButton(IconImages.sendImage, _onSendPressed),



                        ],
                      ),
                    ],
                  ),
                ),

                // Create List by Voice
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Create Your List by voice",
                    style: AppStyles.subTitleTextStyle,
                  ),
                ),

                Container(
                  height: 25.h,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                        ),

                        _roundIconButton(IconImages.micImage, _onMicPressed),
                        const SizedBox(height: 8),
                        const Text("Tap to Speak"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
            const SizedBox(width: 10),
            Text(
              "Type Your Grocery List",
              style: AppStyles.subTitleTextStyle,
            ),
          ],
        ),
      ),
      );
  }

}
