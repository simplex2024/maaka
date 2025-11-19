import 'package:flutter/material.dart';
import 'package:maaakanmoney/pages/User/navigation_drawer/order_meat/create_order.dart';

class SelectionScreen extends StatelessWidget {
  final List<Map<String, String>> items = [
    {'title': 'Chicken', 'image': 'images/chickn1.png'},
    {'title': 'Mutton', 'image': 'images/muttn1.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Option'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {

                print("object");
                //todo:- if should enable then here should pass , whether this users, refferer is meat shop owner or not
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => DetailScreen(
                //       title: items[index]['title']!,
                //
                //     ),
                //   ),
                // );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      items[index]['image']!,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10),
                    Text(
                      items[index]['title']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}