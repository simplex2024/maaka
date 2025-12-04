import '../datasources/product_service.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ProductService _productService;

  ProductRepository({ProductService? productService})
      : _productService = productService ?? ProductService();

  /// Get all products for a specific shop
  Future<List<Product>> getProductsByShop(String shopId) async {
    try {
      return await _productService.getProductsByShop(shopId);
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  /// Create or save a grocery list
  Future<GroceryList> saveGroceryList(GroceryList groceryList) async {
    try {
      return await _productService.createGroceryList(groceryList);
    } catch (e) {
      throw Exception('Failed to save grocery list: $e');
    }
  }

  /// Parse voice input into grocery items
  List<GroceryItem> parseVoiceInput(String voiceText) {
    try {
      return _productService.parseVoiceInput(voiceText);
    } catch (e) {
      throw Exception('Failed to parse voice input: $e');
    }
  }

  /// Search products
  Future<List<Product>> searchProducts(String shopId, String query) async {
    try {
      return await _productService.searchProducts(shopId, query);
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }
}
