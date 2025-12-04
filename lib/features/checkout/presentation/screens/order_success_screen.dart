import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/order_model.dart';

class OrderSuccessScreen extends StatelessWidget {
  final Order order;
  final Color themeColor;

  const OrderSuccessScreen({
    super.key,
    required this.order,
    this.themeColor = const Color(0xFF26AC73), // Default green
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackprimaryapp),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: const Text(
          'Products view',
          style: TextStyle(
            color: AppColors.blackprimaryapp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Icon(
              Icons.check_circle,
              color: themeColor,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Order Placed Successfully',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.blackprimaryapp,
              ),
            ),
            const SizedBox(height: 40),
            
            // Tracking Stepper
            _buildTracker(),
            
            const SizedBox(height: 40),
            
            // Helper Card
            if (order.status != OrderStatus.placed)
              _buildHelperCard(),
              
            const SizedBox(height: 32),
            
            // Shop Info
            _buildShopInfo(),
            
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Cancel order logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE0E0E0),
                  foregroundColor: AppColors.blackprimaryapp,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Cancel Order',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTracker() {
    return Row(
      children: [
        _buildStep(
          label: 'Order Placed',
          isActive: true,
          isCompleted: order.status != OrderStatus.placed,
          icon: Icons.shopping_bag,
        ),
        _buildLine(order.status != OrderStatus.placed),
        _buildStep(
          label: 'Helper Assigned',
          isActive: order.status == OrderStatus.helperAssigned || 
                   order.status == OrderStatus.onTheWay,
          isCompleted: order.status == OrderStatus.onTheWay,
          icon: Icons.person,
        ),
        _buildLine(order.status == OrderStatus.onTheWay),
        _buildStep(
          label: 'On the Way',
          isActive: order.status == OrderStatus.onTheWay,
          isCompleted: false,
          icon: Icons.directions_bike,
        ),
      ],
    );
  }

  Widget _buildStep({
    required String label,
    required bool isActive,
    required bool isCompleted,
    required IconData icon,
  }) {
    final color = isActive || isCompleted ? themeColor : Colors.grey[300]!;
    
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? themeColor : Colors.grey[300],
        margin: const EdgeInsets.only(bottom: 20), // Align with circle center
      ),
    );
  }

  Widget _buildHelperCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/helper_img.png'), // Placeholder
            backgroundColor: Color(0xFFF5F5F5),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.helperName ?? 'Helper',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackprimaryapp,
                  ),
                ),
                const Text(
                  'On the Way to Shop',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.blacksecondaryapp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Local Helper',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: themeColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  order.shopName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackprimaryapp,
                  ),
                ),
              ),
              const Text(
                '50 m away',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.blacksecondaryapp,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          Row(
            children: [
              Icon(Icons.shopping_bag, color: themeColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${order.items.length} items',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackprimaryapp,
                  ),
                ),
              ),
              const Text(
                'From 1 Shop',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.blacksecondaryapp,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Estimate to Pickup in 6-10 minutes',
            style: TextStyle(
              fontSize: 12,
              color: themeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
