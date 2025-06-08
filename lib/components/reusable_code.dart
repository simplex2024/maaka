import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../pages/User/ShopNow/shop_now_model.dart';
import 'constants.dart';

class SingletonReusableCode {
  SingletonReusableCode._private();

  static final SingletonReusableCode _singleInstance =
  SingletonReusableCode._private();

  factory SingletonReusableCode() => _singleInstance;


  final Random random = Random();


  ///it generates random lighten color
  Color lighten(Color color, {double amount = 0.2}) {
    assert(amount >= 0 || amount <= 1.0);
    return Color.fromARGB(
      color.alpha,
      (color.red + ((255 - color.red) * amount)).round(),
      (color.green + ((255 - color.green) * amount)).round(),
      (color.blue + ((255 - color.blue) * amount)).round(),
    );
  }


  double generateRandomColorDouble() {
    double red = random.nextDouble();
    double green = random.nextDouble();
    double blue = random.nextDouble();

    // Ensure the color is not black
    if (red == 0.0 && green == 0.0 && blue == 0.0) {
      // Adjust one of the values to avoid black
      red = 0.1;  // You can adjust this value as needed
    }

    return (red + green + blue) / 3;  // Returns the average value for simplicity
  }


  ///common alert dialog
  void showAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onOkPressed,
    VoidCallback? onCancelPressed,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                if (onCancelPressed != null) {
                  onCancelPressed();
                }
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if (onOkPressed != null) {
                  onOkPressed();
                }
              },
            ),
          ],
        );
      },
    );
  }


  ///shared by multiple screens - 16.7.24
  final List<GridItem> shopNowItems = [
    GridItem(
      imagePath: 'images/final/Login/amazon.jpeg',
      title: 'Amazon',
      affiliateLink: Constants.getAmazonUrl ?? "", getColor: Colors.redAccent,),
    GridItem(
        imagePath: 'images/final/Login/flipkart.jpeg',
        title: 'Flipkart',
        affiliateLink: Constants.getFlipkartUrl ?? "", getColor: Colors.blueAccent),
    GridItem(
        imagePath: 'images/final/Login/myntra.png',
        title: 'Myntra',
        affiliateLink: Constants.getMyntraUrl ?? "", getColor: Colors.yellowAccent),
    GridItem(
        imagePath: 'images/final/Login/ajio.png',
        title: 'Ajio',
        affiliateLink: Constants.getAjioUrl ?? "", getColor: Colors.greenAccent),
    // GridItem(
    //     imagePath: 'images/final/Login/meesho.jpeg',
    //     title: 'Meesho',
    //     affiliateLink: Constants.getMeeshoUrl ?? ""),
  ];



}
