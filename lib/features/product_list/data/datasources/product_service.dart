import 'dart:async';
import '../models/product_model.dart';

class ProductService {
  /// Fetch products available at a specific shop
  /// TODO: Replace with actual API call
  Future<List<Product>> getProductsByShop(String shopId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock data - in production, this would come from API
    // Example API call:
    // final response = await http.get('$baseUrl/shops/$shopId/products');
    // return (response.data as List).map((json) => Product.fromJson(json)).toList();

    final List<Map<String, dynamic>> mockProducts = [
      {
        'id': '1',
        'name': 'Rice',
        'category': 'Grains',
        'price': 50.0,
        'unit': 'kg',
        'image': 'assets/images/rice.png',
        'isAvailable': true,
      },
      {
        'id': '2',
        'name': 'Sunflower Oil',
        'category': 'Oils',
        'price': 150.0,
        'unit': 'ltr',
        'image': 'assets/images/oil.png',
        'isAvailable': true,
      },
      {
        'id': '3',
        'name': 'Aavin Milk',
        'category': 'Dairy',
        'price': 25.0,
        'unit': 'ltr',
        'image': 'assets/images/milk.png',
        'isAvailable': true,
      },
      {
        'id': '4',
        'name': 'Aachi Masala',
        'category': 'Spices',
        'price': 30.0,
        'unit': 'g',
        'image': 'assets/images/masala.png',
        'isAvailable': true,
      },
      {
        'id': '5',
        'name': 'Aashirvaad Atta',
        'category': 'Flour',
        'price': 200.0,
        'unit': 'kg',
        'image': 'assets/images/atta.png',
        'isAvailable': true,
      },
    ];

    return mockProducts.map((json) => Product.fromJson(json)).toList();
  }

  /// Create or save a grocery list
  /// TODO: Replace with actual API call
  Future<GroceryList> createGroceryList(GroceryList groceryList) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock response - in production, this would be an API call
    // Example API call:
    // final response = await http.post('$baseUrl/grocery-lists', data: groceryList.toJson());
    // return GroceryList.fromJson(response.data);

    // Return the same list with a generated ID if it doesn't have one
    if (groceryList.id.isEmpty) {
      return groceryList.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        status: 'submitted',
      );
    }

    return groceryList;
  }

  /// Parse voice input into grocery items
  /// This is a simple parser - can be enhanced with NLP
  List<GroceryItem> parseVoiceInput(String voiceText) {
    final List<GroceryItem> items = [];
    
    // Simple parsing logic
    // Expected format: "Rice 5 kg, Oil 1 liter, Milk 2 liters"
    final parts = voiceText.split(',');
    
    for (var i = 0; i < parts.length; i++) {
      final part = parts[i].trim();
      if (part.isEmpty) continue;

      // Try to extract name, quantity, and unit
      final words = part.split(' ');
      if (words.length >= 2) {
        // Try to find quantity (number)
        String? quantity;
        String? unit;
        String name = '';
        
        for (var j = 0; j < words.length; j++) {
          final word = words[j];
          // Check if it's a number
          if (double.tryParse(word) != null && quantity == null) {
            quantity = word;
            // Next word might be unit
            if (j + 1 < words.length) {
              unit = words[j + 1];
              // Build name from remaining words
              name = words.sublist(0, j).join(' ');
              break;
            }
          }
        }

        // If we couldn't parse properly, use first word as name
        if (name.isEmpty) {
          name = words[0];
          quantity = words.length > 1 ? words[1] : '1';
          unit = words.length > 2 ? words[2] : null;
        }

        items.add(GroceryItem(
          id: DateTime.now().millisecondsSinceEpoch.toString() + i.toString(),
          name: name,
          quantity: quantity ?? '1',
          unit: unit,
        ));
      }
    }

    return items;
  }

  /// Search products by name or category
  /// TODO: Replace with actual API call
  Future<List<Product>> searchProducts(String shopId, String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final allProducts = await getProductsByShop(shopId);
    return allProducts.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.category.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
