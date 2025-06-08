import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maaakanmoney/components/NotificationService.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:maaakanmoney/components/custom_dialog_box.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_theme.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_util.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_widgets.dart';
import 'package:maaakanmoney/pages/User/UserScreen_Notifer.dart';
import 'package:maaakanmoney/pages/budget_copy/budget_copy_widget.dart';

// class OrderSummaryScreen extends StatelessWidget {
//   final String title;
//   final String selectedArea;
//   final String selectedWeight;
//   final String? selectedChickenOption;
//   final double totalPrice;
//   final DateTime? selectedDate;
//   final String? selectedTime;
//
//   const OrderSummaryScreen(
//       {Key? key,
//         required this.title,
//         required this.selectedArea,
//         required this.selectedWeight,
//         required this.selectedChickenOption,
//         required this.totalPrice,
//         required this.selectedDate,
//         required this.selectedTime})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Order Summary')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Container(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Meat Type: $title', style: TextStyle(fontSize: 20)),
//                     Text('Area: $selectedArea', style: TextStyle(fontSize: 20)),
//                     Text('Weight: $selectedWeight', style: TextStyle(fontSize: 20)),
//                     if (title == 'Chicken') ...[
//                       Text('Chicken Option: $selectedChickenOption',
//                           style: TextStyle(fontSize: 20)),
//                     ],
//                     Text('delivery date: $selectedDate', style: TextStyle(fontSize: 20)),
//                     Text('delivery time: $selectedTime', style: TextStyle(fontSize: 20)),
//                     SizedBox(height: 20),
//                     Text('Total Price: ₹${totalPrice.toStringAsFixed(2)}',
//                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//               ),
//             ),
//
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//
//                     },
//                     child: Text('Order Now'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text('Change Details'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Future<void> addDummyOrder({ @required String? getMeatType,
//     @required String? getArea,
//     @required String? getWeight,
//     @required String? getChickenOption,
//     @required String? getDeliveryDate,
//     @required String? getDeliveryTime,@required String? getTotalPrice, }) async {
//
//     try {
//       // Simulating some asynchronous operation
//       // await Future.delayed(Duration(seconds: 2));
//
//       Timestamp timestamp = Timestamp.fromDate(DateTime.now());
//
//       try {
//         //todo:- adding transaction inside user's table
//         FirebaseFirestore.instance
//             .collection('users')
//             .doc(ref.read(UserDashListProvider.notifier).getDocId)
//             .collection('meatorder')
//             .add({
//           'meatType': "",
//           'area': "khanu nagar",
//           'weight': "1kg",
//           'chickenoption': "",
//           'totalPrice': "190",
//           'deliveryDate': DateFormat('yyyy-MM-dd')
//               .format(DateTime.now()),
//           'deliveryTime': "",// Only date in 'yyyy-MM-dd' format
//
//         }).then((_) async {
//
//           Constants.showToast(
//               "Your Order is Placed", ToastGravity.BOTTOM);
//         }).catchError((error) {
//           print('$error');
//         });
//       } catch (error) {
//         print('Error retrieving user details: $error');
//       }
//     } catch (error) {
//       print(error);
//     } finally {
//       // setState(() {
//       //   _isLoading = false;
//       // });
//     }
//   }
// }

class FoodSummaryScreen extends ConsumerStatefulWidget {
  final String title;
  final String selectedArea;
  final double totalPrice;
  final DateTime? selectedDate;
  final String? selectedTime;
  final String? selectedQuantity;

  FoodSummaryScreen(
      {Key? key,
        required this.title,
        required this.selectedArea,
        required this.totalPrice,
        required this.selectedDate,
        required this.selectedTime,required this.selectedQuantity,})
      : super(key: key);

  @override
  OrderSummaryScreenState createState() => OrderSummaryScreenState();
}

class OrderSummaryScreenState extends ConsumerState<FoodSummaryScreen> {
  String? getFinalSelectedDate;
  TextEditingController? remarksController;

  @override
  void initState() {
    getFinalSelectedDate =
        DateFormat('dd-MM-yyyy').format(widget.selectedDate ?? DateTime.now());
    remarksController ??= TextEditingController();
    remarksController?.text = "";
    // ref
    //     .read(UserDashListProvider.notifier)
    //     .getUserAddress
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.colorFoodCPrimary,
        title: Text(
          'Order Details',
          style: TextStyle(color: Constants.secondary),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded, color: Constants.secondary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 8,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Bill Summary ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: Offset(2, 4),
                              )
                            ],
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Item Total ',
                                        style: TextStyle(fontFamily:
                                        'Encode Sans Condensed',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "₹${widget.totalPrice.toStringAsFixed(2)}",
                                        style: TextStyle(fontFamily:
                                        'Encode Sans Condensed',fontSize: 17),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Delivery Fee ',
                                        style: TextStyle(fontFamily:
                                        'Encode Sans Condensed',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "₹10",
                                        style: TextStyle(fontFamily:
                                        'Encode Sans Condensed',
                                          fontSize: 17,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Handling Fee ',
                                        style: TextStyle(fontFamily:
                                        'Encode Sans Condensed',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "₹10",
                                        style: TextStyle(fontFamily:
                                        'Encode Sans Condensed',
                                          fontSize: 17,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Platform Fee ',
                                        style: TextStyle(fontFamily:
                                        'Encode Sans Condensed',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "₹10",
                                        style: TextStyle(fontFamily:
                                        'Encode Sans Condensed',
                                          fontSize: 17,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Divider(),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Total Price ',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "₹${widget.totalPrice.toStringAsFixed(2)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Delivery Summary',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: Offset(2, 4),
                              )
                            ],
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Food Type ',
                                        style: TextStyle(fontFamily:
                                        'Encode Sans Condensed',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        widget.title,
                                        style: TextStyle(fontFamily:
                                        'Encode Sans Condensed',fontSize: 17),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'delivery date ',
                                        style: TextStyle(fontFamily:
                                        'Encode Sans Condensed',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(getFinalSelectedDate ?? "",
                                          style: TextStyle(fontFamily:
                                          'Encode Sans Condensed',fontSize: 17),
                                          textAlign: TextAlign.end),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'delivery time ',
                                        style: TextStyle(fontFamily:
                                        'Encode Sans Condensed',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(widget.selectedTime ?? "",
                                          style: TextStyle(fontFamily:
                                          'Encode Sans Condensed',fontSize: 17),
                                          textAlign: TextAlign.end),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                          'Area ',
                                          style: TextStyle(fontFamily:
                                          'Encode Sans Condensed',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Expanded(
                                        child: Text(widget.selectedArea,
                                            style: TextStyle(fontFamily:
                                            'Encode Sans Condensed',fontSize: 17),
                                            textAlign: TextAlign.end)),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, .0),
                                  child: TextFormField(
                                    controller: remarksController,
                                    decoration: InputDecoration(
                                      labelText: "Any Information, We Should consider?",
                                      // Short label for better UI clarity
                                      hintText:
                                      "Let us know about your meat preferences, contact info, or address updates!",
                                      helperText:
                                      "You can share your contact info, address updates, or preferences.",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Rounded corners
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter address';
                                      }
                                      return null;
                                    },
                                    maxLines: 5,
                                    readOnly: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Container(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: const AlignmentDirectional(0.0, 0.05),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                text: "Change Order",
                                options: FFButtonOptions(
                                  width: 270.0,
                                  height: 50.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding:
                                  const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Constants.colorFoodCPrimary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                    fontFamily: 'Outfit',
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  elevation: 2.0,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          child: Align(
                            alignment: const AlignmentDirectional(0.0, 0.05),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialogBox(
                                          title: "Message!",
                                          descriptions:
                                          "Are you sure, Want to Place Order",
                                          text: "Ok",
                                          isCancel: true,
                                          onTap: () {
                                            addFoodOrder(
                                                getFoodType: widget.title,
                                                getArea: widget.selectedArea,
                                                getDeliveryDate:
                                                getFinalSelectedDate ?? "",
                                                getDeliveryTime:
                                                widget.selectedTime,
                                                getTotalPrice: widget.totalPrice
                                                    .toString() ??
                                                    "",
                                                getUserAddress: ref
                                                    .read(
                                                    UserDashListProvider
                                                        .notifier)
                                                    .getUserAddress ??
                                                    "",
                                                getUserRemarks:
                                                remarksController.text ??
                                                    "",
                                            getFoodQuantity: widget.selectedQuantity ?? "");
                                          },
                                        );
                                      });
                                },
                                text: "Confirm Order",
                                options: FFButtonOptions(
                                  width: 270.0,
                                  height: 50.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding:
                                  const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Constants.colorFoodCPrimary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                    fontFamily: 'Outfit',
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  elevation: 2.0,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addFoodOrder(
      {@required String? getFoodType,
        @required String? getArea,
        @required String? getDeliveryDate,
        @required String? getDeliveryTime,
        @required String? getTotalPrice,
        @required String? getUserAddress,
        @required String? getUserRemarks,@required String? getFoodQuantity}) async {
    try {
      Navigator.pop(context);

      Timestamp timestamp = Timestamp.fromDate(DateTime.now());

      try {
//todo:- adding transaction inside user's table
        FirebaseFirestore.instance
            .collection('users')
            .doc(ref.read(UserDashListProvider.notifier).getDocId)
            .collection('foodorder')
            .add({
          'name': Constants.getUserName,
          'mobile': Constants.getUserMobile,
          'foodType': getFoodType,
          'foodQuantity': getFoodQuantity,
          'area': getArea,
          'totalPrice': getTotalPrice,
          'deliveryDate': getDeliveryDate,
          'deliveryTime': getDeliveryTime, // Only date in 'yyyy-MM-dd' format
          'orderStatus': "Pending",
          'paymentStatus': "Not Paid",
          'deliveryAddress': getUserAddress ?? "",
          'remarks': getUserRemarks ?? "",
          'reffererMobile': Constants.getRefferer ?? "",
        }).then((_) async {
          Constants.showToast("Your Order is Placed", ToastGravity.BOTTOM);
          //todo:- 2.12.23 adding notification to let admin know payment initiated

          String? getName = Constants.getUserName ?? "N/A";
          String? getFoodName = getFoodType ?? "N/A";
          String? token = await NotificationService.getDocumentIDsAndData();
          if (token != null) {
            Response? response =
            await NotificationService.postNotificationRequest(
                token,
                "Hi Admin,\n$getName Trying to Order $getFoodName",
                "Asking $getFoodQuantity - $getFoodName\nFor Price- $getTotalPrice\nHurry up, let's Deliver Food.");
            // Handle the response as needed
          } else {
            print("Problem in getting Token");
            Navigator.pop(context);
          }
          Navigator.pop(context);
        }).catchError((error) {
          print('$error');
          Navigator.pop(context);
        });
      } catch (error) {
        print('Error retrieving user details: $error');
        Navigator.pop(context);
      }
    } catch (error) {
      print(error);
      Navigator.pop(context);
    } finally {
// setState(() {
//   _isLoading = false;
// });
    }
  }
}
