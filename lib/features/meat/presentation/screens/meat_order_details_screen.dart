import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/meat_model.dart';
import '../../../checkout/presentation/widgets/schedule_bottom_sheet.dart';
import '../../../checkout/presentation/screens/order_success_screen.dart';
import '../../../checkout/data/models/order_model.dart';

class MeatOrderDetailsScreen extends StatefulWidget {
  final MeatProduct product;

  const MeatOrderDetailsScreen({super.key, required this.product});

  @override
  State<MeatOrderDetailsScreen> createState() => _MeatOrderDetailsScreenState();
}

class _MeatOrderDetailsScreenState extends State<MeatOrderDetailsScreen> {
  String _selectedQuantity = '1 Kg';
  String _skinPreference = 'With Skin';
  
  final List<String> _quantities = ['500 g', '1 Kg', '1.5 Kg', '2 Kg', '3 Kg'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFC2185B),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Meat Order Details',
          style: TextStyle(
            color: AppColors.blackprimaryapp,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Center(
                    child: SizedBox(
                      height: 200,
                      child: Image.asset(
                        widget.product.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Quantity Selection
                  const Text(
                    'Select Quantity',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF757575),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedQuantity,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: _quantities.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() => _selectedQuantity = newValue!);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Skin Preference
                  const Text(
                    'Skin Preference',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF757575),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildRadioOption('With Skin'),
                      const SizedBox(width: 24),
                      _buildRadioOption('Without Skin'),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Schedule Button
                  const Text(
                    'Select Details',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF757575),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRadioOption('Order Now', isSelected: true), // Always selected for now
                  
                  const SizedBox(height: 16),
                  
                  OutlinedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const ScheduleBottomSheet(
                          themeColor: Color(0xFFC2185B),
                        ),
                      );
                    },
                    icon: const Icon(Icons.schedule, size: 20),
                    label: const Text('Make Schedule'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF757575),
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Place Order Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Success Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderSuccessScreen(
                        order: Order(
                          id: 'ORDER_${DateTime.now().millisecondsSinceEpoch}',
                          shopId: 'meat_shop_1', // Mock shop ID
                          shopName: 'Maaka Meat Shop',
                          items: [], // Placeholder
                          totalAmount: 0,
                          status: OrderStatus.placed,
                          createdAt: DateTime.now(),
                        ),
                        themeColor: const Color(0xFFC2185B),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC2185B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Place the Order',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String value, {bool? isSelected}) {
    final selected = isSelected ?? (_skinPreference == value);
    
    return GestureDetector(
      onTap: () {
        if (isSelected == null) {
          setState(() => _skinPreference = value);
        }
      },
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? const Color(0xFFC2185B) : const Color(0xFFE0E0E0),
                width: 2,
              ),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFFC2185B),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.blackprimaryapp,
            ),
          ),
        ],
      ),
    );
  }
}
