import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../pages/budget_copy/budget_copy_widget.dart';
import 'constants.dart';

class NotificationService {

///15.9.24



  static Future<Response?> postNotificationRequest(
      String token, String getTitleMessage, String getBodyMessage) async {
    Response? res;
    String? getBearerToken = Constants.accessTokenFrNotificn;


    const fcmUrl =
        'https://fcm.googleapis.com/v1/projects/maakanmoney-a6874/messages:send';

    try {
      // Create FCM message payload
      final message = {
        "message": {
          "token": token,  // Replace with 'token' if you're targeting specific devices
          "notification": {
            "title": getTitleMessage,
            "body": getBodyMessage,
          },

        }


      };

      // Make POST request to send the message
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          'Authorization': 'Bearer $getBearerToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(message),
      );

      var body = response.body;
      print("JSON Response -- $body");

      if (response.statusCode == 200) {
        body = await response.body;

      }
      res = Response(response.statusCode, body);
    } on SocketException catch (e) {
      print(e);
      res = Response(
          001, 'No Internet Connection\nPlease check your network status');
    }
    return res;
  }

  static Future<Response?> postCommonNotificationRequest(String getTitleMessage, String getBodyMessage) async {
    Response? res;
    String? getBearerToken = Constants.accessTokenFrNotificn;


    const fcmUrl =
        'https://fcm.googleapis.com/v1/projects/maakanmoney-a6874/messages:send';

    try {
      // Create FCM message payload
      final message = {


        "message": {
          "topic": "all",  // Replace with 'token' if you're targeting specific devices
          "notification": {
            "title": getTitleMessage,
            "body": getBodyMessage,
          },

        }
      };

      // Make POST request to send the message
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          'Authorization': 'Bearer $getBearerToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(message),
      );

      var body = response.body;
      print("JSON Response -- $body");

      if (response.statusCode == 200) {
        body = await response.body;

      }
      res = Response(response.statusCode, body);
    } on SocketException catch (e) {
      print(e);
      res = Response(
          001, 'No Internet Connection\nPlease check your network status');
    }
    return res;
  }
  static Future<Response?> postNotificationWithImage(
      String getTitleMessage, String getBodyMessage, String? getProductImage) async {

    String fileId = _extractFileId("https://drive.google.com/file/d/1wANZHruoYJ5uO-q8bdt-jIz4MSu2seh8/view?usp=sharing");
    String? directImageUrl = 'https://drive.google.com/uc?export=view&id=$fileId';

    Response? res;
    String? getBearerToken = Constants.accessTokenFrNotificn;

    const fcmUrl = 'https://fcm.googleapis.com/v1/projects/maakanmoney-a6874/messages:send';

    try {
      // Create FCM message payload
      final message = {
        "message": {
          "topic": "all",  // Replace with 'token' if you're targeting specific devices
          "notification": {
            "title": getTitleMessage,
            "body": getBodyMessage,
          },
          "android": {
            "notification": {
              "image": getProductImage ?? directImageUrl,  // Image URL for Android
            }
          },
          "apns": {
            "payload": {
              "aps": {
                "mutable-content": 1
              }
            },
            "fcm_options": {
              "image": getProductImage ?? directImageUrl,  // Image URL for iOS
            }
          },
          "webpush": {
            "headers": {
              "image": getProductImage ?? directImageUrl,  // Image URL for web push
            }
          }
        }
      };

      // Make POST request to send the message
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          'Authorization': 'Bearer $getBearerToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(message),
      );

      var body = response.body;
      print("Status Code: ${response.statusCode}");
      print("Response Body: $body");

      if (response.statusCode == 200) {
        body = await response.body;
      }
      res = Response(response.statusCode, body);
    } on SocketException catch (e) {
      print(e);
      res = Response(001, 'No Internet Connection\nPlease check your network status');
    }

    return res;
  }
  static Future<Response?> postCustomNotificationWithImage(String? getToken, String getTitleMessage, String getBodyMessage, String? getImgDriveLink,) async {

    String fileId = _extractFileId(getImgDriveLink ?? "");


    // Convert to a direct link
    String? directImageUrl = 'https://drive.google.com/uc?export=view&id=$fileId';


    Response? res;
    String? getBearerToken = Constants.accessTokenFrNotificn;


    const fcmUrl =
        'https://fcm.googleapis.com/v1/projects/maakanmoney-a6874/messages:send';

    try {
      // Create FCM message payload
      final message = {

        "message": {
          "token": getToken,  // Replace with 'token' if you're targeting specific devices
          "notification": {
            "title": getTitleMessage,
            "body": getBodyMessage,
          },
          "android": {
            "notification": {
              "image": directImageUrl ?? directImageUrl,  // Image URL for Android
            }
          },
          "apns": {
            "payload": {
              "aps": {
                "mutable-content": 1
              }
            },
            "fcm_options": {
              "image": directImageUrl ?? directImageUrl,  // Image URL for iOS
            }
          },
          "webpush": {
            "headers": {
              "image": directImageUrl ?? directImageUrl,  // Image URL for web push
            }
          }
        }





      };

      // Make POST request to send the message
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          'Authorization': 'Bearer $getBearerToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(message),
      );

      var body = response.body;
      print("JSON Response -- $body");

      if (response.statusCode == 200) {
        body = await response.body;

      }
      res = Response(response.statusCode, body);
    } on SocketException catch (e) {
      print(e);
      res = Response(
          001, 'No Internet Connection\nPlease check your network status');
    }
    return res;
  }





  // static Future<Response?> postNotificationRequest(
  //     String token, String getTitleMessage, String getBodyMessage) async {
  //   Response? res;
  //   var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
  //
  //   try {
  //     var response = await http.Client().post(url,
  //         body: jsonEncode({
  //           "to": token,
  //           "priority": "high",
  //           "notification": {
  //             "title": getTitleMessage,
  //             "body": getBodyMessage,
  //           },
  //           "data": {
  //             "custom_key":
  //             "custom_value" // Optional: You can include custom data here
  //           }
  //         }),
  //         headers: {
  //           "Accept": "application/json",
  //           "Content-type": "application/json",
  //           "Authorization":
  //           "key=AAAAb-_MBP8:APA91bFubSJ4pOcNkYMD9uFXekSyOQel1Mzojc1Q7noOPRiR-WNu_C_FgoZ-lQ6Maa1A52NqAoLM7tdQTZ7nEeXs_WUhhqjUg5B0P2lCp2rf95PxdR0PaOSVZUz8UeWJArogfm3gFKRp",
  //         });
  //
  //     var body = response.body;
  //     print("JSON Response -- $body");
  //     if (response.statusCode == 200) {
  //       body = await response.body;
  //     }
  //     res = Response(response.statusCode, body);
  //   } on SocketException catch (e) {
  //     print(e);
  //     res = Response(
  //         001, 'No Internet Connection\nPlease check your network status');
  //   }
  //
  //   print("res <- ${res?.resBody.toString()}");
  //   return res;
  // }
  //
  // static Future<Response?> postCommonNotificationRequest(String getTitleMessage, String getBodyMessage) async {
  //   Response? res;
  //   var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
  //
  //   try {
  //     var response = await http.Client().post(url,
  //         body: jsonEncode({
  //           "to": "/topics/all",
  //           "priority": "high",
  //           "notification": {
  //             "title": getTitleMessage,
  //             "body": getBodyMessage,
  //           },
  //           "data": {
  //             "custom_key":
  //             "custom_value" // Optional: You can include custom data here
  //           }
  //         }),
  //         headers: {
  //           "Accept": "application/json",
  //           "Content-type": "application/json",
  //           "Authorization":
  //           "key=AAAAb-_MBP8:APA91bFubSJ4pOcNkYMD9uFXekSyOQel1Mzojc1Q7noOPRiR-WNu_C_FgoZ-lQ6Maa1A52NqAoLM7tdQTZ7nEeXs_WUhhqjUg5B0P2lCp2rf95PxdR0PaOSVZUz8UeWJArogfm3gFKRp",
  //         });
  //
  //     var body = response.body;
  //     print("JSON Response -- $body");
  //     if (response.statusCode == 200) {
  //       body = await response.body;
  //     }
  //     res = Response(response.statusCode, body);
  //   } on SocketException catch (e) {
  //     print(e);
  //     res = Response(
  //         001, 'No Internet Connection\nPlease check your network status');
  //   }
  //
  //   print("res <- ${res?.resBody.toString()}");
  //   return res;
  // }
  //
  //
  // static Future<Response?> postNotificationWithImage( String getTitleMessage, String getBodyMessage, String? getProductImage) async {
  //
  //   String fileId = _extractFileId("https://drive.google.com/file/d/1wANZHruoYJ5uO-q8bdt-jIz4MSu2seh8/view?usp=sharing");
  //
  //
  //   // Convert to a direct link
  //   String? directImageUrl = 'https://drive.google.com/uc?export=view&id=$fileId';
  //
  //   Response? res;
  //   var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
  //
  //   try {
  //     var response = await http.Client().post(url,
  //         body: jsonEncode({
  //           "to": "/topics/all",
  //           "priority": "high",
  //           "notification": {
  //             "title": getTitleMessage,
  //             "body": getBodyMessage,
  //             "image": getProductImage ?? directImageUrl,
  //           },
  //           // "data": {
  //           //   "custom_key":
  //           //   "custom_value" // Optional: You can include custom data here
  //           // }
  //         }),
  //         headers: {
  //           "Accept": "application/json",
  //           "Content-type": "application/json",
  //           "Authorization":
  //           "key=AAAAb-_MBP8:APA91bFubSJ4pOcNkYMD9uFXekSyOQel1Mzojc1Q7noOPRiR-WNu_C_FgoZ-lQ6Maa1A52NqAoLM7tdQTZ7nEeXs_WUhhqjUg5B0P2lCp2rf95PxdR0PaOSVZUz8UeWJArogfm3gFKRp",
  //         });
  //
  //     var body = response.body;
  //     print("JSON Response -- $body");
  //     if (response.statusCode == 200) {
  //       body = await response.body;
  //     }
  //     res = Response(response.statusCode, body);
  //   } on SocketException catch (e) {
  //     print(e);
  //     res = Response(
  //         001, 'No Internet Connection\nPlease check your network status');
  //   }
  //
  //   print("res <- ${res?.resBody.toString()}");
  //   return res;
  // }
  //
  //
  // static Future<Response?> postCustomNotificationWithImage(String? getToken, String getTitleMessage, String getBodyMessage, String? getImgDriveLink,) async {
  //
  //   String fileId = _extractFileId(getImgDriveLink ?? "");
  //
  //
  //   // Convert to a direct link
  //   String? directImageUrl = 'https://drive.google.com/uc?export=view&id=$fileId';
  //
  //   Response? res;
  //   var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
  //
  //   try {
  //     var response = await http.Client().post(url,
  //         body: jsonEncode({
  //           "to": getToken ?? "/topics/all",
  //           // "to": getToken,
  //           "priority": "high",
  //           "notification": {
  //             "title": getTitleMessage,
  //             "body": getBodyMessage,
  //             "image": directImageUrl,
  //           },
  //           "data": {
  //             "custom_key":
  //             "custom_value" // Optional: You can include custom data here
  //           }
  //         }),
  //         headers: {
  //           "Accept": "application/json",
  //           "Content-type": "application/json",
  //           "Authorization":
  //           "key=AAAAb-_MBP8:APA91bFubSJ4pOcNkYMD9uFXekSyOQel1Mzojc1Q7noOPRiR-WNu_C_FgoZ-lQ6Maa1A52NqAoLM7tdQTZ7nEeXs_WUhhqjUg5B0P2lCp2rf95PxdR0PaOSVZUz8UeWJArogfm3gFKRp",
  //         });
  //
  //     var body = response.body;
  //     print("JSON Response -- $body");
  //     if (response.statusCode == 200) {
  //       body = await response.body;
  //     }
  //     res = Response(response.statusCode, body);
  //   } on SocketException catch (e) {
  //     print(e);
  //     res = Response(
  //         001, 'No Internet Connection\nPlease check your network status');
  //   }
  //
  //   print("res <- ${res?.resBody.toString()}");
  //   return res;
  // }



  static Future<String?> getDocumentIDsAndData() async {
    final CollectionReference collectionRef =
    FirebaseFirestore.instance.collection('AdminToken');

    // Get the documents in the collection
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Iterate through the documents in the snapshot
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      // Access the document ID
      String documentID = documentSnapshot.id;

      // Access the document data as a Map
      Map<String, dynamic> documentData =
      documentSnapshot.data() as Map<String, dynamic>;

      // Access the value of the field (assuming there's only one field)
      dynamic fieldValue = documentData['token'];

      // Print the document ID and field value
      print('Document ID: $documentID, Token Value: $fieldValue');
      return fieldValue ?? "";
    }
  }


  //todo:- to convert drive link to direct link
  static String _extractFileId(String url) {
    // Extract the file ID from the Google Drive link
    final RegExp regExp = RegExp(r'/d/(.*?)/');
    final match = regExp.firstMatch(url);
    if (match != null && match.groupCount > 0) {
      return match.group(1) ?? '';
    }
    return '';
  }
}
