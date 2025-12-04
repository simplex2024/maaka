import 'dart:async';
import '../models/order_model.dart';

class OrderService {
  // Mock in-memory storage
  final List<Order> _orders = [];

  Future<Order> placeOrder(Order order) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate success
    // In a real app, the backend would assign the ID and helper
    final newOrder = order.copyWith(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      status: OrderStatus.placed,
      createdAt: DateTime.now(),
    );

    _orders.add(newOrder);
    return newOrder;
  }

  Future<Order> trackOrder(String orderId) async {
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      final order = _orders.firstWhere((o) => o.id == orderId);
      
      // Simulate status updates based on time (mocking)
      final timeDiff = DateTime.now().difference(order.createdAt).inSeconds;
      
      if (timeDiff > 10 && order.status == OrderStatus.placed) {
        return order.copyWith(
          status: OrderStatus.helperAssigned,
          helperName: 'Arun Kumar',
          helperPhone: '+91 9876543210',
        );
      } else if (timeDiff > 20 && order.status == OrderStatus.helperAssigned) {
        return order.copyWith(status: OrderStatus.onTheWay);
      }
      
      return order;
    } catch (e) {
      throw Exception('Order not found');
    }
  }
}
