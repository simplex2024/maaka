import '../models/shop_models.dart';
import '../datasources/shop_service.dart';

class ShopRepository {
  ShopRepository(this._service);

  final ShopService _service;

  Future<List<ShopData>> getNearbyShops({
    required String location,
    String filterBy = 'distance',
  }) {
    return _service.getNearbyShops(
      location: location,
      filterBy: filterBy,
    );
  }

  Future<List<ShopData>> searchShops(String query) {
    return _service.searchShops(query);
  }
}

