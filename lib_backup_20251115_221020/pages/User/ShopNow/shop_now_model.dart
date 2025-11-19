import 'dart:ui';

class GridItem {
  final String imagePath;
  final String title;
  final String affiliateLink;
  final Color? getColor;

  GridItem(
      {required this.imagePath,
        required this.title,
        required this.affiliateLink,required this.getColor});
}