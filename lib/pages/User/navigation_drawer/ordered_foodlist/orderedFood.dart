import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_theme.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_util.dart';
import 'package:maaakanmoney/pages/User/SaveMoney/SaveMoney.dart';
import 'package:maaakanmoney/pages/User/UserScreen_Notifer.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderedFoodList extends ConsumerStatefulWidget {
  @override
  OrderedFoodListState createState() => OrderedFoodListState();
}

class OrderedFoodListState extends ConsumerState<OrderedFoodList> {
  final _formKey = GlobalKey<FormState>();


  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<FoodDetailsList>? orderedFood = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: responsiveVisibility(
        context: context,
        tabletLandscape: false,
        desktop: false,
      )
          ?  AppBar(
        title: Text(
          "My Orders",
          style: GlobalTextStyles.secondaryText1(
              textColor: Constants.secondary,
              txtWeight: FontWeight.w700),
        ),
        // backgroundColor: Constants.secondary4,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:  [ Constants.secondary4,Constants.colorFoodCPrimary,

              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        automaticallyImplyLeading: true,
        toolbarHeight: 8.h,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0.0,
      )
          : null,
      body: Consumer(builder: (context, ref, child) {
        return SafeArea(
          child: Container(
            color: Constants.secondary,
            height: 100.h,
            child: Stack(
              children: [
                Container(
                    height: 100.h,
                    child: Stack(
                      children: [
                        CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: firestore
                                    .collection('users')
                                    .doc(ref
                                    .read(UserDashListProvider.notifier)
                                    .getDocId)
                                    .collection('foodorder')
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: SizedBox(
                                        child: CircularProgressIndicator(),
                                        height: 20,
                                        width: 20,
                                      ),
                                    );
                                  }

                                  orderedFood = snapshot.data!.docs
                                      .map((doc) {


                                    final data =
                                    doc.data() as Map<String, dynamic>;
                                    final foodType = data['foodType'];
                                    final area = data['area'];
                                    final totalPrice = data['totalPrice'];
                                    final deliveryDate =
                                    data['deliveryDate'];
                                    final deliveryTime =
                                    data['deliveryTime'];
                                    final orderStatus = data['orderStatus'];
                                    final paymentStatus =
                                    data['paymentStatus'];
                                    final foodQuantity = data['foodQuantity'];

                                    return FoodDetailsList(
                                        foodName: foodType,
                                        area: area,
                                        totalPrice: totalPrice,
                                        deliveryDate: deliveryDate,
                                        deliveryTime: deliveryTime,
                                        paymentStatus: paymentStatus,
                                        orderStatus: orderStatus, foodQuantity: foodQuantity);
                                  })
                                      .whereType<FoodDetailsList>()
                                      .toList();

                                  //----------------------------------

                                  print("goals stream build called");
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: orderedFood?.length,
                                    itemBuilder: (context, index) {
                                      final document = orderedFood?[index];
                                      String? meatType = document?.foodName;

                                      String? foodQuantity = document?.foodQuantity;

                                      String? orderStatus =
                                          document?.orderStatus;
                                      String? paymentStatus =
                                          document?.paymentStatus;
                                      String? totalPrice = document?.totalPrice;

                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          child: Container(


                                              child:
                                              Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceEvenly,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,

                                                  children: [
                                                    Row(
                                                      // mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                              (orderStatus ==
                                                                  "Delivered" &&
                                                                  paymentStatus ==
                                                                      "Not Paid")
                                                                  ? "Payment Pending"
                                                                  : (orderStatus == "Delivered" &&
                                                                  paymentStatus ==
                                                                      "Paid")
                                                                  ? "Completed"
                                                                  : "Not Delivered",
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              style: TextStyle(
                                                                  color: (orderStatus ==
                                                                      "Delivered" &&
                                                                      paymentStatus ==
                                                                          "Not Paid")
                                                                      ? Colors
                                                                      .red
                                                                      : (orderStatus == "Delivered" &&
                                                                      paymentStatus ==
                                                                          "Paid")
                                                                      ? Constants
                                                                      .secondary3
                                                                      : Constants
                                                                      .secondary3,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize:
                                                                  16.0,
                                                                  letterSpacing:
                                                                  0.5)),
                                                        ),



                                                        Expanded(
                                                          child: Text( "${index + 1}",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge
                                                                ?.copyWith(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),textAlign: TextAlign.end,),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text("Food:",
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 12.0,
                                                                  letterSpacing:
                                                                  0.5)),
                                                        ),
                                                        Expanded(
                                                          child: Text(meatType ?? "No Name",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),textAlign: TextAlign.end,),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text("Quantity:",
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 12.0,
                                                                  letterSpacing:
                                                                  0.5)),
                                                        ),
                                                        Expanded(
                                                          child: Text(foodQuantity ?? "No Name",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),textAlign: TextAlign.end,),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text("Delivery status:",
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 12.0,
                                                                  letterSpacing:
                                                                  0.5)),
                                                        ),
                                                        Expanded(
                                                          child: Text(orderStatus ?? "No Name",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),textAlign: TextAlign.end,),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text("Payment status:",
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 12.0,
                                                                  letterSpacing:
                                                                  0.5)),
                                                        ),
                                                        Expanded(
                                                          child: Text(paymentStatus ?? "No Name",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),textAlign: TextAlign.end,),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text("Payable Amount:",
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 12.0,
                                                                  letterSpacing:
                                                                  0.5)),
                                                        ),
                                                        Expanded(
                                                          child: Text(totalPrice ?? "No Name",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),textAlign: TextAlign.end,),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    paymentStatus == "Paid"  ? Container() :  Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Constants.colorFoodCPrimary,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(10.0), // Set the border radius here
                                                            ), // Set the background color here
                                                          ),
                                                          onPressed: () {

                                                            Navigator.push(
                                                              context,
                                                              PageRouteBuilder(
                                                                transitionDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                    400),
                                                                pageBuilder:
                                                                    (_, __, ___) =>
                                                                    SaveMoney(
                                                                      getMobile:
                                                                      "",
                                                                      getUserName: ref
                                                                          .read(
                                                                          UserDashListProvider
                                                                              .notifier)
                                                                          .getUser,
                                                                      getGoalDocId: "",
                                                                      getTransData:
                                                                      [],
                                                                      getPaymentService:  PaymentService.meatBasket,
                                                                      getPayableAmount: totalPrice ?? "",
                                                                    ),
                                                                transitionsBuilder: (_,
                                                                    animation,
                                                                    __,
                                                                    child) {
                                                                  return SlideTransition(
                                                                    position:
                                                                    Tween<Offset>(
                                                                      begin:
                                                                      Offset(0, 1),
                                                                      // You can adjust the start position
                                                                      end: Offset
                                                                          .zero, // You can adjust the end position
                                                                    ).animate(
                                                                        animation),
                                                                    child: child,
                                                                  );
                                                                },
                                                              ),
                                                            );

                                                          },
                                                          child: Text("Pay   ${totalPrice}",
                                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                  color: Constants.secondary,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  fontWeight: FontWeight.bold,fontSize: 15
                                                              )

                                                            // TextStyle(
                                                            //     fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Constants.colorFoodCPrimary,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(10.0), // Set the border radius here
                                                            ), // Set the background color here
                                                          ),
                                                          onPressed: () async {

                                                            final Uri launchUri = Uri(
                                                              scheme: 'tel',
                                                              path: Constants.adminNo1,
                                                            );
                                                            await launchUrl(launchUri);

                                                          },
                                                          child: Icon(
                                                            Icons.call,
                                                            color: FlutterFlowTheme.of(context).primaryBtnText,
                                                            size: 24.0,
                                                          ),
                                                        ),
                                                      ],
                                                    )


                                                  ],
                                                ),
                                              )





                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class FoodDetailsList {
  String? foodName;
  String? area;
  String? totalPrice;
  String? deliveryDate;
  String? deliveryTime;
  String? foodQuantity;

  String? paymentStatus;
  String? orderStatus;

  FoodDetailsList(
      {required this.foodName,
        required this.area,
        required this.totalPrice,
        required this.deliveryDate,
        required this.deliveryTime,
        required this.foodQuantity,
        required this.paymentStatus,
        required this.orderStatus});
}
