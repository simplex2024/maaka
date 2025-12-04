import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

/// Load products for a specific shop
class LoadProducts extends ProductEvent {
  final String shopId;
  final String shopName;

  const LoadProducts({
    required this.shopId,
    required this.shopName,
  });

  @override
  List<Object?> get props => [shopId, shopName];
}

/// Add a grocery item to the list
class AddGroceryItem extends ProductEvent {
  final String name;
  final String quantity;
  final String? unit;

  const AddGroceryItem({
    required this.name,
    required this.quantity,
    this.unit,
  });

  @override
  List<Object?> get props => [name, quantity, unit];
}

/// Remove a grocery item from the list
class RemoveGroceryItem extends ProductEvent {
  final String itemId;

  const RemoveGroceryItem(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

/// Update a grocery item
class UpdateGroceryItem extends ProductEvent {
  final GroceryItem item;

  const UpdateGroceryItem(this.item);

  @override
  List<Object?> get props => [item];
}

/// Process voice input
class ProcessVoiceInput extends ProductEvent {
  final String voiceText;

  const ProcessVoiceInput(this.voiceText);

  @override
  List<Object?> get props => [voiceText];
}

/// Clear all grocery items
class ClearGroceryList extends ProductEvent {
  const ClearGroceryList();
}

/// Save the grocery list and navigate to cart
class SaveGroceryList extends ProductEvent {
  const SaveGroceryList();
}

/// Search products
class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}
