import 'package:flutter/material.dart';
import 'package:maaakanmoney/core/constants/app_colors.dart';
import 'package:maaakanmoney/core/constants/app_routes.dart';
import 'package:maaakanmoney/core/constants/app_styles.dart';
import 'package:sizer/sizer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> shops = [
    {
      "shopName": "Karthi Grocerys",
      "items": 5,
      "scheduled": false,
      "scheduleTime": null
    },
    {
      "shopName": "Naveen Department",
      "items": 2,
      "scheduled": false,
      "scheduleTime": null
    },
    {
      "shopName": "Karthi Grocerys",
      "items": 8,
      "scheduled": true,
      "scheduleTime": "Tomorrow 06:00 PM"
    },
    {
      "shopName": "Karthi Grocerys",
      "items": 8,
      "scheduled": true,
      "scheduleTime": "Tomorrow 06:00 PM"
    },
    {
      "shopName": "Karthi Grocerys",
      "items": 8,
      "scheduled": true,
      "scheduleTime": "Tomorrow 06:00 PM"
    },
  ];

  Future<void> _pickScheduleTime(int index) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        String formattedTime =
            "${pickedTime.hourOfPeriod.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')} ${pickedTime.period == DayPeriod.am ? 'AM' : 'PM'}";

        shops[index]["scheduled"] = true;
        shops[index]["scheduleTime"] = "Today $formattedTime";
      });
    }
  }

  void _removeShop(int index) {
    setState(() {
      shops.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
              "My Cart",
              style: AppStyles.subTitleTextStyle,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 70.h,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < shops.length; i++) ...[
                      Row(
                        children: [
                          Text(
                            "Shop ${i + 1}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Expanded(
                            child: DashedLine(
                              color: Colors.green,
                              height: 1,
                              dashWidth: 5,
                              dashSpace: 3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shops[i]["shopName"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        "${shops[i]["items"]} items Added",
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "View",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              // Outer padding between square & circle
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green, width: 2),
                                // Square border
                                shape: BoxShape.rectangle,
                                // Outer shape is square/rect
                                borderRadius: BorderRadius.circular(
                                    8), // Slightly rounded square corners
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                // Padding inside circle
                                decoration: BoxDecoration(
                                  color: AppColors.greenColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.green,
                                      width: 2), // Circle border
                                ),
                                child: const SizedBox(
                                  height: 5,
                                  width: 5,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (!shops[i]["scheduled"])
                        Row(
                          children: [
                            // Expanded(
                            //   child: OutlinedButton.icon(
                            //     onPressed: () => _pickScheduleTime(i),
                            //     icon: const Icon(Icons.access_time),
                            //     label: const Text("Schedule Delivery"),
                            //     style: OutlinedButton.styleFrom(
                            //       shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(30)),
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              child: InkWell(
                                onTap: () => _pickScheduleTime(i),
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white, // White background
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "Schedule Deliver",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(Icons.access_time, color: Colors.red),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Expanded(
                            //   child: OutlinedButton.icon(
                            //     onPressed: () => _removeShop(i),
                            //     icon: const Icon(Icons.delete_outline),
                            //     label: const Text("Remove"),
                            //     style: OutlinedButton.styleFrom(
                            //       shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(30)),
                            //     ),
                            //   ),
                            // ),
                
                            Expanded(
                              child: InkWell(
                                onTap: () => _removeShop(i),
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white, // White background
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "Remove",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(Icons.delete_outline,
                                          color: Colors.red),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                "Scheduled on",
                                style: TextStyle(color: Colors.grey),
                              ),
                              const Spacer(),
                              Text(
                                shops[i]["scheduleTime"] ?? "",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: AppColors.greenColor),
                                onPressed: () => _pickScheduleTime(i),
                                tooltip: "Edit Schedule Time",
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
            if (shops.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.orderStatusScreen);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenColor,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Place the Order",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class DashedLine extends StatelessWidget {
  final Color color;
  final double height;
  final double dashWidth;
  final double dashSpace;

  const DashedLine({
    super.key,
    this.color = Colors.green,
    this.height = 1,
    this.dashWidth = 5,
    this.dashSpace = 3,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount =
            (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
