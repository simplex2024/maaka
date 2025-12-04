import 'package:equatable/equatable.dart';
import '../../../product_list/data/models/product_model.dart';
import '../../data/models/order_model.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CheckoutEvent {
  final List<GroceryItem> items;
  final String shopId;
  final String shopName;

  const LoadCart({
    required this.items,
    required this.shopId,
    required this.shopName,
  });

  @override
  List<Object> get props => [items, shopId, shopName];
}

class UpdateCartItem extends CheckoutEvent {
  final GroceryItem item;

  const UpdateCartItem(this.item);

  @override
  List<Object> get props => [item];
}

class RemoveCartItem extends CheckoutEvent {
  final String itemId;

  const RemoveCartItem(this.itemId);

  @override
  List<Object> get props => [itemId];
}

class SelectSchedule extends CheckoutEvent {
  final DeliverySchedule schedule;

  const SelectSchedule(this.schedule);

  @override
  List<Object> get props => [schedule];
}

class PlaceOrder extends CheckoutEvent {
  const PlaceOrder();
}
