import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ProductInitial extends ProductState {
  const ProductInitial();
}

/// Loading products
class ProductLoading extends ProductState {
  const ProductLoading();
}

/// Products loaded successfully
class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<GroceryItem> groceryItems;
  final String shopId;
  final String shopName;

  const ProductLoaded({
    required this.products,
    required this.groceryItems,
    required this.shopId,
    required this.shopName,
  });

  ProductLoaded copyWith({
    List<Product>? products,
    List<GroceryItem>? groceryItems,
    String? shopId,
    String? shopName,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      groceryItems: groceryItems ?? this.groceryItems,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
    );
  }

  @override
  List<Object?> get props => [products, groceryItems, shopId, shopName];
}

/// Error state
class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Grocery list saved successfully
class GroceryListSaved extends ProductState {
  final GroceryList groceryList;

  const GroceryListSaved(this.groceryList);

  @override
  List<Object?> get props => [groceryList];
}

/// Voice input processed
class VoiceInputProcessed extends ProductState {
  final List<GroceryItem> parsedItems;

  const VoiceInputProcessed(this.parsedItems);

  @override
  List<Object?> get props => [parsedItems];
}
