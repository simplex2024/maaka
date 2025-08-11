import 'package:flutter/material.dart';
import 'package:maaakanmoney/core/constants/app_colors.dart';
import 'package:maaakanmoney/core/constants/app_styles.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  runApp(const OrderByVoiceScreen());
}

class OrderByVoiceScreen extends StatefulWidget {
  const OrderByVoiceScreen({super.key});

  @override
  State<OrderByVoiceScreen> createState() => _OrderByVoiceScreenState();
}

class _OrderByVoiceScreenState extends State<OrderByVoiceScreen> {
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _quantityControllers = [];
  int visibleRows = 1;

  @override
  void initState() {
    super.initState();
    _addNewRow();
  }

  void _addNewRow() {
    _nameControllers.add(TextEditingController());
    _quantityControllers.add(TextEditingController());
  }

  void _checkRowChange(int index) {
    bool bothFilled = _nameControllers[index].text.trim().isNotEmpty &&
        _quantityControllers[index].text.trim().isNotEmpty;

    bool bothEmpty = _nameControllers[index].text.trim().isEmpty &&
        _quantityControllers[index].text.trim().isEmpty;

    setState(() {
      // Add new row if both are filled
      if (bothFilled && index + 1 > visibleRows - 1) {
        visibleRows++;
        _addNewRow();
      }

      // Remove row if both are empty (and it's not the first row)
      if (bothEmpty && index != 0 && index < visibleRows) {
        _nameControllers.removeAt(index);
        _quantityControllers.removeAt(index);
        visibleRows--;
      }
    });
  }

  void _editRow(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing row ${index + 1}')),
    );
  }

  Widget _inputBox({
    required String hint,
    required TextEditingController controller,
    required VoidCallback onChanged,
  }) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.greyColor,
        // border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
        onChanged: (_) => onChanged(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        body: SafeArea(
          child:

          Column(
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:

                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration:  BoxDecoration(
                        color: AppColors.greyDarkColor,
                        shape: BoxShape.circle,
                      ),
                      child:   IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),//Icon(icon, color: Colors.white),
                    ),
                    SizedBox(width: 10,),
                     Text(
                      "Type Your Grocery List",
                      style:
                      AppStyles.subTitleTextStyle,//TextStyle(fontSize: 18, fontWeight: FontWeight.w500),

                    ),
                  ],
                ),


              ),


              Container(
                height: 70.h,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryWhiteTextColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  color: AppColors.primaryWhiteTextColor,
                  height: 100.h,
                  child: Column(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: AppColors.primaryWhiteTextColor,

                        child: Column(
                          children: [


                            // Table headers
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                children:  [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Name",
                                      style: AppStyles.mediumTitleTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Quantity",
                                      style: AppStyles.mediumTitleTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Input rows
                            Container(
                              color: AppColors.primaryWhiteTextColor,
                              height: 20.h,
                              child: ListView.builder(
                                itemCount: visibleRows,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemBuilder: (context, index) {
                                  bool filled = _nameControllers[index].text.trim().isNotEmpty &&
                                      _quantityControllers[index].text.trim().isNotEmpty;

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: _inputBox(
                                            hint: index == 0 ? "Type here.." : "",
                                            controller: _nameControllers[index],
                                            onChanged: () => _checkRowChange(index),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          flex: 1,
                                          child: _inputBox(
                                            hint: "",
                                            controller: _quantityControllers[index],
                                            onChanged: () => _checkRowChange(index),
                                          ),
                                        ),
                                        if (filled) ...[
                                          const SizedBox(width: 8),
                                          IconButton(
                                            icon: const Icon(Icons.edit, size: 20),
                                            onPressed: () => _editRow(index),
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),


                          ],
                        ),
                      ),
                      Container(
                        color: AppColors.primaryWhiteTextColor,

                        child: Column(
                          children: [



                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        debugPrint("Add to Cart pressed");


                                        setState(() {
                                          _nameControllers.clear();
                                          _quantityControllers.clear();
                                          visibleRows = 1;
                                          _addNewRow();
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.grey,
                                        side: BorderSide(
                                            color: Colors.grey.shade300, width: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text("Clear"),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        debugPrint("Continue pressed");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade300,
                                        foregroundColor: Colors.grey,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text("Continue"),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          // Buttons


            ],
          ),


        ),
      );
  }
}
