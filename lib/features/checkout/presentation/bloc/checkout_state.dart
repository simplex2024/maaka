import 'package:equatable/equatable.dart';
import '../../../product_list/data/models/product_model.dart';
import '../../data/models/order_model.dart';

enum CheckoutStatus { initial, loading, success, failure }

class CheckoutState extends Equatable {
  final List<GroceryItem> items;
  final String shopId;
  final String shopName;
  final DeliverySchedule? schedule;
  final CheckoutStatus status;
  final Order? placedOrder;
  final String? errorMessage;

  const CheckoutState({
    this.items = const [],
    this.shopId = '',
    this.shopName = '',
    this.schedule,
    this.status = CheckoutStatus.initial,
    this.placedOrder,
    this.errorMessage,
  });

  double get totalAmount {
    // Mock calculation: assuming random prices for now since GroceryItem doesn't have price
    // In real app, GroceryItem should have price
    return items.length * 100.0; 
  }

  CheckoutState copyWith({
    List<GroceryItem>? items,
    String? shopId,
    String? shopName,
    DeliverySchedule? schedule,
    CheckoutStatus? status,
    Order? placedOrder,
    String? errorMessage,
  }) {
    return CheckoutState(
      items: items ?? this.items,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      schedule: schedule ?? this.schedule,
      status: status ?? this.status,
      placedOrder: placedOrder ?? this.placedOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        items,
        shopId,
        shopName,
        schedule,
        status,
        placedOrder,
        errorMessage,
      ];
}
