import 'package:equatable/equatable.dart';

/// Represents a product available at a grocery shop
class Product extends Equatable {
  final String id;
  final String name;
  final String category;
  final double price;
  final String unit; // kg, ltr, pcs, etc.
  final String? image;
  final bool isAvailable;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.unit,
    this.image,
    this.isAvailable = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      image: json['image'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'unit': unit,
      'image': image,
      'isAvailable': isAvailable,
    };
  }

  @override
  List<Object?> get props => [id, name, category, price, unit, image, isAvailable];
}

/// Represents an item in the user's grocery list
class GroceryItem extends Equatable {
  final String id;
  final String name;
  final String quantity;
  final String? unit;

  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    this.unit,
  });

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as String,
      unit: json['unit'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
    };
  }

  GroceryItem copyWith({
    String? id,
    String? name,
    String? quantity,
    String? unit,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }

  @override
  List<Object?> get props => [id, name, quantity, unit];
}

/// Represents a complete grocery list for a shop
class GroceryList extends Equatable {
  final String id;
  final String shopId;
  final String shopName;
  final List<GroceryItem> items;
  final DateTime createdAt;
  final String status; // draft, submitted, completed

  const GroceryList({
    required this.id,
    required this.shopId,
    required this.shopName,
    required this.items,
    required this.createdAt,
    this.status = 'draft',
  });

  factory GroceryList.fromJson(Map<String, dynamic> json) {
    return GroceryList(
      id: json['id'] as String,
      shopId: json['shopId'] as String,
      shopName: json['shopName'] as String,
      items: (json['items'] as List)
          .map((item) => GroceryItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String? ?? 'draft',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopId': shopId,
      'shopName': shopName,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  GroceryList copyWith({
    String? id,
    String? shopId,
    String? shopName,
    List<GroceryItem>? items,
    DateTime? createdAt,
    String? status,
  }) {
    return GroceryList(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, shopId, shopName, items, createdAt, status];
}
