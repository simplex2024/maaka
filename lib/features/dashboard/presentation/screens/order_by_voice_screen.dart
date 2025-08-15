import 'package:flutter/material.dart';
import 'package:maaakanmoney/core/constants/app_colors.dart';
import 'package:maaakanmoney/core/constants/app_styles.dart';
import 'package:maaakanmoney/features/dashboard/presentation/screens/order_preview_screen.dart';
import 'package:sizer/sizer.dart';

class OrderByVoiceScreen extends StatefulWidget {
  const OrderByVoiceScreen({super.key});

  @override
  State<OrderByVoiceScreen> createState() => _OrderByVoiceScreenState();
}

class _OrderByVoiceScreenState extends State<OrderByVoiceScreen> {
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _quantityControllers = [];
  int visibleRows = 1;

  bool get _hasAnyRowFilled {
    return _nameControllers.asMap().entries.any((entry) {
      int i = entry.key;
      return _nameControllers[i].text.trim().isNotEmpty &&
          _quantityControllers[i].text.trim().isNotEmpty;
    });
  }

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
      if (bothFilled && index + 1 > visibleRows - 1) {
        visibleRows++;
        _addNewRow();
      }
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
        color: AppColors.screenBackgroundColor,
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
    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ fix keyboard push issue
      backgroundColor:  AppColors.screenBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
// Table headers
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

                      // Input rows
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: visibleRows,
                        // padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          bool filled = _nameControllers[index]
                              .text
                              .trim()
                              .isNotEmpty &&
                              _quantityControllers[index]
                                  .text
                                  .trim()
                                  .isNotEmpty;
                  
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
                  
                      const SizedBox(height: 20),
                  
                  
                    ],
                  ),
                ),
              ),
            ),
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _hasAnyRowFilled
                          ? () {
                        setState(() {
                          _nameControllers.clear();
                          _quantityControllers.clear();
                          visibleRows = 1;
                          _addNewRow();
                        });
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _hasAnyRowFilled
                            ? AppColors.groceryColor
                            : AppColors.screenBackgroundColor,
                        foregroundColor: Colors.white,
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
                      onPressed: _hasAnyRowFilled
                          ? () {
                        debugPrint("Continue pressed");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PreviewOrderScreen(
                              items: List.generate(_nameControllers.length, (i) => {
                                'name': _nameControllers[i].text.trim(),
                                'quantity': _quantityControllers[i].text.trim(),
                              }).where((item) => item['name']!.isNotEmpty && item['quantity']!.isNotEmpty).toList(),
                            ),
                          ),
                        );
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _hasAnyRowFilled
                            ? AppColors.groceryColor
                            : AppColors.screenBackgroundColor,
                        foregroundColor: Colors.white,
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
      appBar: AppBar(
        backgroundColor:  AppColors.primaryWhiteTextColor,
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
              "Create Your Grocery List",
              style: AppStyles.subTitleTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
