import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/maaka_app_bar.dart';
import '../../../product_list/presentation/widgets/grocery_item_card.dart';
import '../bloc/checkout_bloc.dart';
import '../bloc/checkout_event.dart';
import '../bloc/checkout_state.dart';
import 'order_success_screen.dart';
import '../widgets/schedule_bottom_sheet.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MaakaAppBar(
        showBack: true,
        backText: 'Preview',
      ),
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state.status == CheckoutStatus.success && state.placedOrder != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => OrderSuccessScreen(order: state.placedOrder!),
              ),
            );
          } else if (state.status == CheckoutStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Error placing order')),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return GroceryItemCard(
                      item: item,
                      onUpdate: (updatedItem) {
                        context.read<CheckoutBloc>().add(UpdateCartItem(updatedItem));
                      },
                      onDelete: () {
                        context.read<CheckoutBloc>().add(RemoveCartItem(item.id));
                      },
                    );
                  },
                ),
              ),
              _buildBottomSection(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, CheckoutState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.schedule != null)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scheduled Delivery',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.blacksecondaryapp,
                        ),
                      ),
                      Text(
                        '${_formatDate(state.schedule!.date)} at ${state.schedule!.timeSlot}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackprimaryapp,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _showScheduleSheet(context),
                    child: const Text('Change'),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showScheduleSheet(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFFE0E0E0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Schedule Delivery',
                    style: TextStyle(color: AppColors.blackprimaryapp),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: state.status == CheckoutStatus.loading
                      ? null
                      : () {
                          if (state.schedule == null) {
                            _showScheduleSheet(context);
                          } else {
                            context.read<CheckoutBloc>().add(const PlaceOrder());
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF26AC73),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: state.status == CheckoutStatus.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Place the Order',
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

  void _showScheduleSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<CheckoutBloc>(),
        child: const ScheduleBottomSheet(),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Simple formatter, can use intl package if available
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    return '${date.day}/${date.month}';
  }
}
