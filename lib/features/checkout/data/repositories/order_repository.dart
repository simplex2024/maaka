import '../datasources/order_service.dart';
import '../models/order_model.dart';

class OrderRepository {
  final OrderService _service;

  OrderRepository(this._service);

  Future<Order> placeOrder(Order order) async {
    try {
      return await _service.placeOrder(order);
    } catch (e) {
      throw Exception('Failed to place order: $e');
    }
  }

  Future<Order> trackOrder(String orderId) async {
    try {
      return await _service.trackOrder(orderId);
    } catch (e) {
      throw Exception('Failed to track order: $e');
    }
  }
}
