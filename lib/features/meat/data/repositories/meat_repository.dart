import '../datasources/meat_service.dart';
import '../models/meat_model.dart';

class MeatRepository {
  final MeatService _service;

  MeatRepository(this._service);

  Future<List<MeatCategory>> getCategories() async {
    return await _service.getCategories();
  }

  Future<List<MeatProduct>> getProducts(String categoryId) async {
    return await _service.getProducts(categoryId);
  }
}
