import 'package:flutter/material.dart';

class ShopCardComponent extends StatelessWidget {
  final String name;
  final String distance;
  final String rating;
  final String owner;
  final String imageUrl;

  const ShopCardComponent({
    super.key,
    required this.name,
    required this.distance,
    required this.rating,
    required this.owner,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(imageUrl,
                  height: 100, width: double.infinity, fit: BoxFit.cover),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(distance, style: TextStyle(color: Colors.grey, fontSize: 12)),
            Row(
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 16),
                Text(rating, style: TextStyle(fontSize: 12)),
              ],
            ),
            Row(
              children: [
                CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 14)),
                SizedBox(width: 6),
                Text(owner, style: TextStyle(fontSize: 12)),
              ],
            ),
            SizedBox(height: 6),
          ],
        ),
      ),
    );
    /*  return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(imageUrl, height: 100, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(distance, style: TextStyle(color: Colors.grey, fontSize: 12)),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 16),
                    Text(rating, style: TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  children: [
                    CircleAvatar(radius: 12, backgroundColor: Colors.grey[300], child: Icon(Icons.person, size: 14)),
                    SizedBox(width: 6),
                    Text(owner, style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 6),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: Size(double.infinity, 32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text("View More", style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );*/
  }
}
