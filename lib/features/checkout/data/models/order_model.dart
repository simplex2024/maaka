import 'package:equatable/equatable.dart';
import '../../../product_list/data/models/product_model.dart';

enum OrderStatus {
  placed,
  helperAssigned,
  onTheWay,
  delivered,
  cancelled
}

class DeliverySchedule extends Equatable {
  final DateTime date;
  final String timeSlot;

  const DeliverySchedule({
    required this.date,
    required this.timeSlot,
  });

  @override
  List<Object?> get props => [date, timeSlot];

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
    };
  }

  factory DeliverySchedule.fromJson(Map<String, dynamic> json) {
    return DeliverySchedule(
      date: DateTime.parse(json['date']),
      timeSlot: json['timeSlot'],
    );
  }
}

class Order extends Equatable {
  final String id;
  final String shopId;
  final String shopName;
  final List<GroceryItem> items;
  final double totalAmount; // Mock total for now
  final OrderStatus status;
  final DeliverySchedule? schedule;
  final DateTime createdAt;
  final String? helperName;
  final String? helperPhone;

  const Order({
    required this.id,
    required this.shopId,
    required this.shopName,
    required this.items,
    this.totalAmount = 0.0,
    required this.status,
    this.schedule,
    required this.createdAt,
    this.helperName,
    this.helperPhone,
  });

  @override
  List<Object?> get props => [
        id,
        shopId,
        shopName,
        items,
        totalAmount,
        status,
        schedule,
        createdAt,
        helperName,
        helperPhone,
      ];

  Order copyWith({
    String? id,
    String? shopId,
    String? shopName,
    List<GroceryItem>? items,
    double? totalAmount,
    OrderStatus? status,
    DeliverySchedule? schedule,
    DateTime? createdAt,
    String? helperName,
    String? helperPhone,
  }) {
    return Order(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      schedule: schedule ?? this.schedule,
      createdAt: createdAt ?? this.createdAt,
      helperName: helperName ?? this.helperName,
      helperPhone: helperPhone ?? this.helperPhone,
    );
  }
}
