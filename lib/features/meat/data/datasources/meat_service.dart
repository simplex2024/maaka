import '../models/meat_model.dart';

class MeatService {
  Future<List<MeatCategory>> getCategories() async {
    // Mock data
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const MeatCategory(id: 'chicken', name: 'Chicken', isSelected: true),
      const MeatCategory(id: 'mutton', name: 'Mutton'),
    ];
  }

  Future<List<MeatProduct>> getProducts(String categoryId) async {
    // Mock data
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (categoryId == 'chicken') {
      return [
        const MeatProduct(
          id: 'c1',
          name: 'Ordinary Chicken',
          image: 'assets/images/chicken_ordinary.png',
          categoryId: 'chicken',
        ),
        const MeatProduct(
          id: 'c2',
          name: 'Chicken Boneless',
          image: 'assets/images/chicken_boneless.png',
          categoryId: 'chicken',
        ),
        const MeatProduct(
          id: 'c3',
          name: 'Chicken Leg Piece',
          image: 'assets/images/chicken_leg.png',
          categoryId: 'chicken',
        ),
        const MeatProduct(
          id: 'c4',
          name: 'Chicken Liver Piece',
          image: 'assets/images/chicken_liver.png',
          categoryId: 'chicken',
        ),
      ];
    } else if (categoryId == 'mutton') {
      return [
        const MeatProduct(
          id: 'm1',
          name: 'Ordinary Mutton',
          image: 'assets/images/mutton_ordinary.png',
          categoryId: 'mutton',
        ),
        const MeatProduct(
          id: 'm2',
          name: 'Mutton Liver',
          image: 'assets/images/mutton_liver.png',
          categoryId: 'mutton',
        ),
        const MeatProduct(
          id: 'm3',
          name: 'Mutton Brine',
          image: 'assets/images/mutton_brine.png',
          categoryId: 'mutton',
        ),
        const MeatProduct(
          id: 'm4',
          name: 'Mutton Lungs',
          image: 'assets/images/mutton_lungs.png',
          categoryId: 'mutton',
        ),
      ];
    }
    return [];
  }
}
