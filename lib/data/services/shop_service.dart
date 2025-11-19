import 'dart:async';
import '../models/shop_models.dart';

class ShopService {
  Future<List<ShopData>> getNearbyShops({
    required String location,
    String filterBy = 'distance', // 'distance' or 'rating'
  }) async {
    // TODO: Replace mock delay with a real API call.
    // Example:
    // final response = await http.get('$baseUrl/shops?location=$location&filter=$filterBy');
    // return (response.data as List).map((json) => ShopData.fromJson(json)).toList();
    
    await Future.delayed(const Duration(seconds: 1));

    // Mock data - in production, this would come from API
    final List<Map<String, dynamic>> mockShops = [
      {
        'name': 'Karthi Grocerys',
        'distance': '50 m',
        'rating': '4/5',
        'owner': 'Rajesh Kumar',
        'image': 'assets/images/shop_img.png',
      },
      {
        'name': 'Naveen Department',
        'distance': '100 m',
        'rating': '4/5',
        'owner': 'Ram Kumar',
        'image': 'assets/images/shop_img.png',
      },
      {
        'name': 'Nithiya maligal',
        'distance': '150 m',
        'rating': '4/5',
        'owner': 'Anitha',
        'image': 'assets/images/shop_img.png',
      },
      {
        'name': 'Praveen shop',
        'distance': '200 m',
        'rating': '4/5',
        'owner': 'Praveen',
        'image': 'assets/images/shop_img.png',
      },
    ];

    List<ShopData> shops = mockShops.map((json) => ShopData.fromJson(json)).toList();

    // Mock filtering logic
    if (filterBy == 'rating') {
      // In production, this would be done on the backend
      shops = shops.reversed.toList(); // Simple mock: reverse order
    }

    return shops;
  }

  Future<List<ShopData>> searchShops(String query) async {
    // TODO: Replace with actual search API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    final allShops = await getNearbyShops(location: '');
    return allShops.where((shop) {
      return shop.name.toLowerCase().contains(query.toLowerCase()) ||
          shop.owner.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

