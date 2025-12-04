import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({ProductRepository? productRepository})
      : _productRepository = productRepository ?? ProductRepository(),
        super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddGroceryItem>(_onAddGroceryItem);
    on<RemoveGroceryItem>(_onRemoveGroceryItem);
    on<UpdateGroceryItem>(_onUpdateGroceryItem);
    on<ProcessVoiceInput>(_onProcessVoiceInput);
    on<ClearGroceryList>(_onClearGroceryList);
    on<SaveGroceryList>(_onSaveGroceryList);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    try {
      final products = await _productRepository.getProductsByShop(event.shopId);
      emit(ProductLoaded(
        products: products,
        groceryItems: const [],
        shopId: event.shopId,
        shopName: event.shopName,
      ));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void _onAddGroceryItem(
    AddGroceryItem event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final newItem = GroceryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        quantity: event.quantity,
        unit: event.unit,
      );

      final updatedItems = List<GroceryItem>.from(currentState.groceryItems)
        ..add(newItem);

      emit(currentState.copyWith(groceryItems: updatedItems));
    }
  }

  void _onRemoveGroceryItem(
    RemoveGroceryItem event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final updatedItems = currentState.groceryItems
          .where((item) => item.id != event.itemId)
          .toList();

      emit(currentState.copyWith(groceryItems: updatedItems));
    }
  }

  void _onUpdateGroceryItem(
    UpdateGroceryItem event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final updatedItems = currentState.groceryItems.map((item) {
        return item.id == event.item.id ? event.item : item;
      }).toList();

      emit(currentState.copyWith(groceryItems: updatedItems));
    }
  }

  void _onProcessVoiceInput(
    ProcessVoiceInput event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      try {
        final parsedItems = _productRepository.parseVoiceInput(event.voiceText);
        final updatedItems = List<GroceryItem>.from(currentState.groceryItems)
          ..addAll(parsedItems);

        emit(currentState.copyWith(groceryItems: updatedItems));
      } catch (e) {
        emit(ProductError('Failed to process voice input: $e'));
      }
    }
  }

  void _onClearGroceryList(
    ClearGroceryList event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      emit(currentState.copyWith(groceryItems: []));
    }
  }

  Future<void> _onSaveGroceryList(
    SaveGroceryList event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      
      if (currentState.groceryItems.isEmpty) {
        emit(const ProductError('Please add at least one item to your list'));
        // Restore previous state
        emit(currentState);
        return;
      }

      try {
        final groceryList = GroceryList(
          id: '',
          shopId: currentState.shopId,
          shopName: currentState.shopName,
          items: currentState.groceryItems,
          createdAt: DateTime.now(),
          status: 'draft',
        );

        final savedList = await _productRepository.saveGroceryList(groceryList);
        emit(GroceryListSaved(savedList));
      } catch (e) {
        emit(ProductError('Failed to save grocery list: $e'));
        // Restore previous state
        emit(currentState);
      }
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      try {
        if (event.query.isEmpty) {
          // Reload all products
          final products = await _productRepository.getProductsByShop(currentState.shopId);
          emit(currentState.copyWith(products: products));
        } else {
          final products = await _productRepository.searchProducts(
            currentState.shopId,
            event.query,
          );
          emit(currentState.copyWith(products: products));
        }
      } catch (e) {
        emit(ProductError('Failed to search products: $e'));
        // Restore previous state
        emit(currentState);
      }
    }
  }
}
