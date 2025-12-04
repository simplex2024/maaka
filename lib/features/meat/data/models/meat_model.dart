class MeatCategory {
  final String id;
  final String name;
  final bool isSelected;

  const MeatCategory({
    required this.id,
    required this.name,
    this.isSelected = false,
  });
}

class MeatProduct {
  final String id;
  final String name;
  final String image;
  final String categoryId;

  const MeatProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.categoryId,
  });
}
