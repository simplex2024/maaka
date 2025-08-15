import 'package:flutter/material.dart';
import 'package:maaakanmoney/core/constants/app_colors.dart';
import 'package:maaakanmoney/core/constants/app_routes.dart';
import 'package:maaakanmoney/core/constants/app_styles.dart';

class PreviewOrderScreen extends StatefulWidget {
  final List<Map<String, String>> items;

  const PreviewOrderScreen({super.key, required this.items});

  @override
  State<PreviewOrderScreen> createState() => _PreviewOrderScreenState();
}

class _PreviewOrderScreenState extends State<PreviewOrderScreen> {
  late List<Map<String, String>> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items); // Copy so we can modify
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  bool get _hasItems => _items.isNotEmpty;

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
            const SizedBox(width: 10),
            Text(
              "Preview Grocery List",
              style: AppStyles.subTitleTextStyle,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(


          child: Column(
            children: [


// Table header
              Padding(
                padding:
                const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Name",
                      style: AppStyles.mediumTitleTextStyle,
                    ),
                    Text(
                      "Quantity",
                      style: AppStyles.mediumTitleTextStyle,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhiteTextColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [


                        // Items list
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _items.length,

                          itemBuilder: (context, index) {
                            final item = _items[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 12),
                                      height: 45,
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        color: AppColors.screenBackgroundColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(item['name'] ?? ''),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 12),
                                      height: 45,
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        color: AppColors.screenBackgroundColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(item['quantity'] ?? ''),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _removeItem(index),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),


              // Bottom buttons
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _hasItems
                            ? () {
                          setState(() {
                            _items.clear();
                          });
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _hasItems
                              ? AppColors.groceryColor
                              : AppColors.screenBackgroundColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Add to Cart"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _hasItems
                            ? () {
                          debugPrint("Place order pressed");
                          Navigator.pushNamed(context, AppRoutes.orderStatusScreen);
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _hasItems
                              ? AppColors.groceryColor
                              : AppColors.screenBackgroundColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Place Order"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
