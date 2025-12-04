class ShopData {
  final String name;
  final String distance;
  final String rating;
  final String owner;
  final String image;

  ShopData({
    required this.name,
    required this.distance,
    required this.rating,
    required this.owner,
    required this.image,
  });

  factory ShopData.fromJson(Map<String, dynamic> json) {
    return ShopData(
      name: json['name'] as String,
      distance: json['distance'] as String,
      rating: json['rating'] as String,
      owner: json['owner'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'distance': distance,
      'rating': rating,
      'owner': owner,
      'image': image,
    };
  }
}

