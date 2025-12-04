import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/order_model.dart';
import '../bloc/checkout_bloc.dart';
import '../bloc/checkout_event.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final Color themeColor;

  const ScheduleBottomSheet({
    super.key,
    this.themeColor = const Color(0xFF26AC73), // Default green
  });

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  DateTime _selectedDate = DateTime.now();
  String _selectedTimeSlot = '10 - 11 AM';

  final List<String> _timeSlots = [
    '8 - 9 AM', '9 - 10 AM', '10 - 11 AM', '11 - 12 PM',
    '1 - 2 PM', '2 - 3 PM', '3 - 4 PM', '4 - 5 PM',
    '5 - 6 PM', '6 - 7 PM'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Schedule Date and Time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.blackprimaryapp,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select the Schedule Date and Time for your order can be delivered',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.blacksecondaryapp,
            ),
          ),
          const SizedBox(height: 24),
          
          // Date Selection
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index));
                final isSelected = date.day == _selectedDate.day && 
                                 date.month == _selectedDate.month;
                
                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = date),
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                      color: isSelected ? widget.themeColor : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? widget.themeColor : const Color(0xFFE0E0E0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getMonth(date.month),
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white : AppColors.blacksecondaryapp,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : AppColors.blackprimaryapp,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Time Selection
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _timeSlots.map((slot) {
              final isSelected = slot == _selectedTimeSlot;
              return GestureDetector(
                onTap: () => setState(() => _selectedTimeSlot = slot),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? widget.themeColor.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF26AC73) : const Color(0xFFE0E0E0),
                    ),
                  ),
                  child: Text(
                    slot,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? widget.themeColor : AppColors.blackprimaryapp,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 32),
          
          // Buttons
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.blackprimaryapp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CheckoutBloc>().add(
                      SelectSchedule(
                        DeliverySchedule(
                          date: _selectedDate,
                          timeSlot: _selectedTimeSlot,
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.themeColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
