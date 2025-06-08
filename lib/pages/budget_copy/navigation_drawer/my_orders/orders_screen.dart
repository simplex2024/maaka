import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:maaakanmoney/components/search_box.dart';
import 'package:maaakanmoney/pages/budget_copy/BudgetCopyController.dart';
import 'package:sizer/sizer.dart';
import 'orders_details_screen.dart';
// Assuming your MeatOrder model is in this file

class OrdersScreen extends ConsumerStatefulWidget {

  final String? getUserType;
  final String? getAdminMobileNo;

  OrdersScreen({Key? key, required this.getUserType, required this.getAdminMobileNo}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  List<MeatOrder> allOrders = [];
  List<FoodOrder> allFoodOrders = [];
  bool isLoading = false;
  int? getOrderCount = 0;
  final txtSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    // getMeatOrders(); // Fetch orders when screen is loaded

    if((widget.getUserType ?? "0") == "0"){
      getMeatOrders();
    }else if((widget.getUserType ?? "0") == "1"){
      getMeatOrders();
    }else if((widget.getUserType ?? "0") == "2"){
      getFoodOrders();
    }else if((widget.getUserType ?? "0") == "6"){
      getFoodOrders();
    }else if((widget.getUserType ?? "0") == "20"){
      getFoodOrders();
    }else{
      getMeatOrders();
    }


  }

  // Method to refresh the orders list
  Future<void> _onRefresh() async {
    print("Refreshing orders list...");
    await getMeatOrders(); // Fetch updated orders
    print("Orders list refreshed successfully.");
    ref.read(getTotalOrderCount.notifier).state = (allOrders.length ?? 0);
  }

  Future<void> _onRefreshFoodOrder() async {
    print("Refreshing orders list...");
    await getFoodOrders(); // Fetch updated orders
    print("Orders list refreshed successfully.");
    ref.read(getTotalOrderCount.notifier).state = (allFoodOrders.length ?? 0);
  }

  // Fetch all meat orders from Firestore
  Future<void> getMeatOrders() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      final firestore = FirebaseFirestore.instance;

      // Perform a collection group query to fetch all meat orders
      QuerySnapshot querySnapshot =
          await firestore.collectionGroup('meatorder').get();

      // Map each Firestore document to a MeatOrder object
      List<MeatOrder> orders = querySnapshot.docs.map((doc) {
        // Extract the user collection ID (parent document ID)
        String? userId = doc.reference.parent.parent?.id;

        // Create the MeatOrder object and include the userId
        return MeatOrder.fromFirestore(doc, userId ?? "");
      }).toList();

      setState(() {
        allOrders = orders; // Update the state with fetched orders
        isLoading = false; // Hide loading indicator
        txtSearch.text = "";
      });
    } catch (e) {
      print("Error fetching meat orders: $e");
      setState(() {
        isLoading = false; // Hide loading indicator if error occurs
      });
    }
  }
  Future<void> getFoodOrders() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      final firestore = FirebaseFirestore.instance;

      // Perform a collection group query to fetch all meat orders
      QuerySnapshot querySnapshot =
      await firestore.collectionGroup('foodorder').get();

      // Map each Firestore document to a MeatOrder object
      List<FoodOrder> orders = querySnapshot.docs.map((doc) {
        // Extract the user collection ID (parent document ID)
        String? userId = doc.reference.parent.parent?.id;

        // Create the MeatOrder object and include the userId
        return FoodOrder.fromFirestore(doc, userId ?? "");
      }).toList();

      setState(() {
        allFoodOrders = orders; // Update the state with fetched orders
        isLoading = false; // Hide loading indicator
        txtSearch.text = "";
      });
    } catch (e) {
      print("Error fetching meat orders: $e");
      setState(() {
        isLoading = false; // Hide loading indicator if error occurs
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return _OrderScreen(context, widget.getUserType ?? "0");
  }

  Widget _OrderScreen(BuildContext context, String getUserType) {
    switch (getUserType) {
      case "0": //supper admin view for meat order list
        return Scaffold(
          appBar: AppBar(
            title: Text("Meat Orders"),
          ),
          body: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: isLoading
                      ? Center(
                      child:
                      CircularProgressIndicator()) // Show loading indicator
                      : allOrders.isEmpty
                      ? Center(
                    child: Text(
                      'No orders found. Pull to refresh.',
                      textAlign: TextAlign.center,
                    ),
                  )
                      : Column(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          color: Colors.white,
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: SearchBox(onChanged: (value) {
                                  txtSearch.text = value;
                                }),
                              ),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Constants.secondary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          50.0), // Set the border radius here
                                    ), // Set the background color here
                                  ),
                                  onPressed: () {
                                    // getMeatOrders();

                                    setState(() {
                                      // txtSearch.text = "";
                                    });
                                  },
                                  child: Center(
                                    child: Icon(
                                      Icons.search,
                                      // You can replace 'home' with any other icon
                                      size:
                                      30.0, // Set the size of the icon
                                      color: Constants
                                          .secondary4, // Set the color of the icon
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Total Orders ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Consumer(
                                    builder: (context, ref, child) {
                                      getOrderCount =
                                          ref.watch(getTotalOrderCount);

                                      return Text(
                                        "${getOrderCount ?? 0}",
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge
                                            ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            overflow:
                                            TextOverflow.ellipsis),
                                        textAlign: TextAlign.end,
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: ListView.builder(
                          itemCount: allOrders.length,
                          itemBuilder: (context, index) {
                            // ref.read(getTotalOrderCount.notifier).state =  (allOrders.length ?? 0) ;
                            final order = allOrders[index];

                            return (order.name ?? "")
                                .toLowerCase().contains(txtSearch.text.toLowerCase())
                                ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.white,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderDetailsScreen(
                                                order: order,isAdminView: true,),
                                      ),
                                    );
                                  },
                                  child: Container(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceEvenly,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      (order.orderStatus ==
                                                          "Delivered" &&
                                                          order.paymentStatus ==
                                                              "Not Paid")
                                                          ? "Payment Pending 😩"
                                                          : (order.orderStatus == "Delivered" &&
                                                          order.paymentStatus ==
                                                              "Paid")
                                                          ? "Completed 😎"
                                                          : "Not Delivered 😰",
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                      style: TextStyle(
                                                          color: (order.orderStatus ==
                                                              "Delivered" &&
                                                              order.paymentStatus ==
                                                                  "Not Paid")
                                                              ? Colors
                                                              .red
                                                              : (order.orderStatus == "Delivered" &&
                                                              order.paymentStatus ==
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
                                                Text("${index + 1}",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: TextStyle(
                                                        color: (order.orderStatus ==
                                                            "Delivered" &&
                                                            order.paymentStatus ==
                                                                "Not Paid")
                                                            ? Colors.red
                                                            : (order.orderStatus ==
                                                            "Delivered" &&
                                                            order.paymentStatus ==
                                                                "Paid")
                                                            ? Constants
                                                            .secondary3
                                                            : Constants
                                                            .secondary3,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: 16.0,
                                                        letterSpacing:
                                                        0.5)),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text("Name:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.name ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text("Mobile:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.mobile ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text("Meat:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.meatType ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text("Weight:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.weight ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            (order.meatType ?? "")
                                                .contains("Chick")
                                                ? Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Option:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.chickenoption ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow.ellipsis),
                                                    textAlign:
                                                    TextAlign
                                                        .end,
                                                  ),
                                                ),
                                              ],
                                            )
                                                : Container(),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Payable Amount:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "₹${order.totalPrice}" ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Delivery Status:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.orderStatus ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Payment Status:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.paymentStatus ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Customer Remarks:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 100.w,
                                              // Scrollable area height
                                              padding:
                                              EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                BorderRadius
                                                    .circular(8.0),
                                              ),
                                              child:
                                              SingleChildScrollView(
                                                child: Text(
                                                  order.remarks ?? "",
                                                  style: TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),

                                // ListTile(
                                //   title: Text(order.name ?? "No Name"),
                                //   subtitle: Text("${order.mobile ?? 'N/A'}"),
                                //   trailing: Column(
                                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Text("Meat: ${order.meatType ?? 'N/A'}",textAlign: TextAlign.end,),
                                //     (order.meatType?? "").contains("Chick")  ?  Text("Type: ${order.chickenoption ?? 'N/A'}",textAlign: TextAlign.end,) : Text("") ,
                                //
                                //     ],
                                //   ),
                                //   onTap: () {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) => OrderDetailsScreen(order: order),
                                //       ),
                                //     );
                                //   },
                                // ),
                              ),
                            )
                                : Container();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

      case "1": // meat shop owner
        return Scaffold(
          appBar: AppBar(
            title: Text("Meat Orders"),
          ),
          body: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: isLoading
                      ? Center(
                      child:
                      CircularProgressIndicator()) // Show loading indicator
                      : allOrders.isEmpty
                      ? Center(
                    child: Text(
                      'No orders found. Pull to refresh.',
                      textAlign: TextAlign.center,
                    ),
                  )
                      : Column(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          color: Colors.white,
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: SearchBox(onChanged: (value) {
                                  txtSearch.text = value;
                                }),
                              ),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Constants.secondary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          50.0), // Set the border radius here
                                    ), // Set the background color here
                                  ),
                                  onPressed: () {
                                    // getMeatOrders();

                                    setState(() {
                                      // txtSearch.text = "";
                                    });
                                  },
                                  child: Center(
                                    child: Icon(
                                      Icons.search,
                                      // You can replace 'home' with any other icon
                                      size:
                                      30.0, // Set the size of the icon
                                      color: Constants
                                          .secondary4, // Set the color of the icon
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 9,
                        child: ListView.builder(
                          itemCount: allOrders.length,
                          itemBuilder: (context, index) {
                            // ref.read(getTotalOrderCount.notifier).state =  (allOrders.length ?? 0) ;
                            final order = allOrders[index];
                            print("user mob ${order.reffererMobile}}/ reffere mob ${widget
                                .getAdminMobileNo}");

                            return (order.name ?? "")
                                .toLowerCase().contains(txtSearch.text.toLowerCase())
                                ? (order.reffererMobile ?? "") == widget.getAdminMobileNo ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.white,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderDetailsScreen(
                                                order: order,isAdminView: false,),
                                      ),
                                    );
                                  },
                                  child: Container(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceEvenly,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      (order.orderStatus ==
                                                          "Delivered" &&
                                                          order.paymentStatus ==
                                                              "Not Paid")
                                                          ? "Payment Pending 😩"
                                                          : (order.orderStatus == "Delivered" &&
                                                          order.paymentStatus ==
                                                              "Paid")
                                                          ? "Completed 😎"
                                                          : "Not Delivered 😰",
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                      style: TextStyle(
                                                          color: (order.orderStatus ==
                                                              "Delivered" &&
                                                              order.paymentStatus ==
                                                                  "Not Paid")
                                                              ? Colors
                                                              .red
                                                              : (order.orderStatus == "Delivered" &&
                                                              order.paymentStatus ==
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

                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text("Name:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.name ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text("Mobile:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.mobile ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text("Meat:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.meatType ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text("Weight:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.weight ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            (order.meatType ?? "")
                                                .contains("Chick")
                                                ? Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Option:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.chickenoption ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow.ellipsis),
                                                    textAlign:
                                                    TextAlign
                                                        .end,
                                                  ),
                                                ),
                                              ],
                                            )
                                                : Container(),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Payable Amount:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "₹${order.totalPrice}" ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Delivery Status:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.orderStatus ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Payment Status:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.paymentStatus ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Customer Remarks:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 100.w,
                                              // Scrollable area height
                                              padding:
                                              EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                BorderRadius
                                                    .circular(8.0),
                                              ),
                                              child:
                                              SingleChildScrollView(
                                                child: Text(
                                                  order.remarks ?? "",
                                                  style: TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),

                                // ListTile(
                                //   title: Text(order.name ?? "No Name"),
                                //   subtitle: Text("${order.mobile ?? 'N/A'}"),
                                //   trailing: Column(
                                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Text("Meat: ${order.meatType ?? 'N/A'}",textAlign: TextAlign.end,),
                                //     (order.meatType?? "").contains("Chick")  ?  Text("Type: ${order.chickenoption ?? 'N/A'}",textAlign: TextAlign.end,) : Text("") ,
                                //
                                //     ],
                                //   ),
                                //   onTap: () {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) => OrderDetailsScreen(order: order),
                                //       ),
                                //     );
                                //   },
                                // ),
                              ),
                            )
                               : Container() : Container();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

      case "2": //  cloud kitchen owner
        return Scaffold(
          appBar: AppBar(
            title: Text("Food Orders"),
          ),
          body: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefreshFoodOrder,
                  child: isLoading
                      ? Center(
                      child:
                      CircularProgressIndicator()) // Show loading indicator
                      : allFoodOrders.isEmpty
                      ? Center(
                    child: Text(
                      'No orders found. Pull to refresh.',
                      textAlign: TextAlign.center,
                    ),
                  )
                      : Column(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          color: Colors.white,
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: SearchBox(onChanged: (value) {
                                  txtSearch.text = value;
                                }),
                              ),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Constants.secondary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          50.0), // Set the border radius here
                                    ), // Set the background color here
                                  ),
                                  onPressed: () {
                                    // getMeatOrders();

                                    setState(() {
                                      // txtSearch.text = "";
                                    });
                                  },
                                  child: Center(
                                    child: Icon(
                                      Icons.search,
                                      // You can replace 'home' with any other icon
                                      size:
                                      30.0, // Set the size of the icon
                                      color: Constants
                                          .secondary4, // Set the color of the icon
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 9,
                        child: ListView.builder(
                          itemCount: allFoodOrders.length,
                          itemBuilder: (context, index) {
                            // ref.read(getTotalOrderCount.notifier).state =  (allOrders.length ?? 0) ;
                            final order = allFoodOrders[index];
                            print("user mob ${order.reffererMobile}}/ reffere mob ${widget
                                .getAdminMobileNo}");

                            return (order.name ?? "")
                                .toLowerCase().contains(txtSearch.text.toLowerCase())
                                ?
                            (order.reffererMobile ?? "") == widget.getAdminMobileNo ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.white,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FoodOrderDetailsScreen(
                                                order: order,isAdminView: false,),
                                      ),
                                    );
                                  },
                                  child: Container(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceEvenly,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      (order.orderStatus ==
                                                          "Delivered" &&
                                                          order.paymentStatus ==
                                                              "Not Paid")
                                                          ? "Payment Pending 😩"
                                                          : (order.orderStatus == "Delivered" &&
                                                          order.paymentStatus ==
                                                              "Paid")
                                                          ? "Completed 😎"
                                                          : "Not Delivered 😰",
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                      style: TextStyle(
                                                          color: (order.orderStatus ==
                                                              "Delivered" &&
                                                              order.paymentStatus ==
                                                                  "Not Paid")
                                                              ? Colors
                                                              .red
                                                              : (order.orderStatus == "Delivered" &&
                                                              order.paymentStatus ==
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

                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text("Name:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.name ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text("Mobile:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.mobile ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.foodName ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text("Weight:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.reffererMobile ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Payable Amount:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "₹${order.totalPrice}" ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Delivery Status:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.orderStatus ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Payment Status:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.paymentStatus ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Customer Remarks:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 100.w,
                                              // Scrollable area height
                                              padding:
                                              EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                BorderRadius
                                                    .circular(8.0),
                                              ),
                                              child:
                                              SingleChildScrollView(
                                                child: Text(
                                                  order.remarks ?? "",
                                                  style: TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),

                                // ListTile(
                                //   title: Text(order.name ?? "No Name"),
                                //   subtitle: Text("${order.mobile ?? 'N/A'}"),
                                //   trailing: Column(
                                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Text("Meat: ${order.meatType ?? 'N/A'}",textAlign: TextAlign.end,),
                                //     (order.meatType?? "").contains("Chick")  ?  Text("Type: ${order.chickenoption ?? 'N/A'}",textAlign: TextAlign.end,) : Text("") ,
                                //
                                //     ],
                                //   ),
                                //   onTap: () {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) => OrderDetailsScreen(order: order),
                                //       ),
                                //     );
                                //   },
                                // ),
                              ),
                            )
                                : Container() : Container();


                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      case "6": //  cloud kitchen owner
        return Scaffold(
          appBar: AppBar(
            title: Text("Food Orders"),
          ),
          body: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefreshFoodOrder,
                  child: isLoading
                      ? Center(
                      child:
                      CircularProgressIndicator()) // Show loading indicator
                      : allFoodOrders.isEmpty
                      ? Center(
                    child: Text(
                      'No orders found. Pull to refresh.',
                      textAlign: TextAlign.center,
                    ),
                  )
                      : Column(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          color: Colors.white,
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: SearchBox(onChanged: (value) {
                                  txtSearch.text = value;
                                }),
                              ),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Constants.secondary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          50.0), // Set the border radius here
                                    ), // Set the background color here
                                  ),
                                  onPressed: () {
                                    // getMeatOrders();

                                    setState(() {
                                      // txtSearch.text = "";
                                    });
                                  },
                                  child: Center(
                                    child: Icon(
                                      Icons.search,
                                      // You can replace 'home' with any other icon
                                      size:
                                      30.0, // Set the size of the icon
                                      color: Constants
                                          .secondary4, // Set the color of the icon
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 9,
                        child: ListView.builder(
                          itemCount: allFoodOrders.length,
                          itemBuilder: (context, index) {
                            // ref.read(getTotalOrderCount.notifier).state =  (allOrders.length ?? 0) ;
                            final order = allFoodOrders[index];
                            print("user mob ${order.reffererMobile}}/ reffere mob ${widget
                                .getAdminMobileNo}");

                            return (order.name ?? "")
                                .toLowerCase().contains(txtSearch.text.toLowerCase())
                                ?
                            (order.reffererMobile ?? "") == widget.getAdminMobileNo ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.white,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FoodOrderDetailsScreen(
                                                order: order,isAdminView: false,),
                                      ),
                                    );
                                  },
                                  child: Container(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceEvenly,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      (order.orderStatus ==
                                                          "Delivered" &&
                                                          order.paymentStatus ==
                                                              "Not Paid")
                                                          ? "Payment Pending 😩"
                                                          : (order.orderStatus == "Delivered" &&
                                                          order.paymentStatus ==
                                                              "Paid")
                                                          ? "Completed 😎"
                                                          : "Not Delivered 😰",
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                      style: TextStyle(
                                                          color: (order.orderStatus ==
                                                              "Delivered" &&
                                                              order.paymentStatus ==
                                                                  "Not Paid")
                                                              ? Colors
                                                              .red
                                                              : (order.orderStatus == "Delivered" &&
                                                              order.paymentStatus ==
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

                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text("Name:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.name ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text("Mobile:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.mobile ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.foodName ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text("Weight:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.reffererMobile ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Payable Amount:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "₹${order.totalPrice}" ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Delivery Status:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.orderStatus ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Payment Status:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.paymentStatus ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Customer Remarks:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 100.w,
                                              // Scrollable area height
                                              padding:
                                              EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                BorderRadius
                                                    .circular(8.0),
                                              ),
                                              child:
                                              SingleChildScrollView(
                                                child: Text(
                                                  order.remarks ?? "",
                                                  style: TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),

                                // ListTile(
                                //   title: Text(order.name ?? "No Name"),
                                //   subtitle: Text("${order.mobile ?? 'N/A'}"),
                                //   trailing: Column(
                                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Text("Meat: ${order.meatType ?? 'N/A'}",textAlign: TextAlign.end,),
                                //     (order.meatType?? "").contains("Chick")  ?  Text("Type: ${order.chickenoption ?? 'N/A'}",textAlign: TextAlign.end,) : Text("") ,
                                //
                                //     ],
                                //   ),
                                //   onTap: () {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) => OrderDetailsScreen(order: order),
                                //       ),
                                //     );
                                //   },
                                // ),
                              ),
                            )
                                : Container() : Container();


                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      case "20": //  super admin view for cloud kitchen food order
        return Scaffold(
          appBar: AppBar(
            title: Text("Food Orders"),
          ),
          body: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefreshFoodOrder,
                  child: isLoading
                      ? Center(
                      child:
                      CircularProgressIndicator()) // Show loading indicator
                      : allFoodOrders.isEmpty
                      ? Center(
                    child: Text(
                      'No orders found. Pull to refresh.',
                      textAlign: TextAlign.center,
                    ),
                  )
                      : Column(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          color: Colors.white,
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: SearchBox(onChanged: (value) {
                                  txtSearch.text = value;
                                }),
                              ),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Constants.secondary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          50.0), // Set the border radius here
                                    ), // Set the background color here
                                  ),
                                  onPressed: () {
                                    // getMeatOrders();

                                    setState(() {
                                      // txtSearch.text = "";
                                    });
                                  },
                                  child: Center(
                                    child: Icon(
                                      Icons.search,
                                      // You can replace 'home' with any other icon
                                      size:
                                      30.0, // Set the size of the icon
                                      color: Constants
                                          .secondary4, // Set the color of the icon
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 9,
                        child: ListView.builder(
                          itemCount: allFoodOrders.length,
                          itemBuilder: (context, index) {
                            // ref.read(getTotalOrderCount.notifier).state =  (allOrders.length ?? 0) ;
                            final order = allFoodOrders[index];
                            print("user mob ${order.reffererMobile}}/ reffere mob ${widget
                                .getAdminMobileNo}");

                            return (order.name ?? "")
                                .toLowerCase().contains(txtSearch.text.toLowerCase())
                                ?
                             Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.white,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FoodOrderDetailsScreen(
                                                order: order,isAdminView: true,),
                                      ),
                                    );
                                  },
                                  child: Container(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceEvenly,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      (order.orderStatus ==
                                                          "Delivered" &&
                                                          order.paymentStatus ==
                                                              "Not Paid")
                                                          ? "Payment Pending 😩"
                                                          : (order.orderStatus == "Delivered" &&
                                                          order.paymentStatus ==
                                                              "Paid")
                                                          ? "Completed 😎"
                                                          : "Not Delivered 😰",
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                      style: TextStyle(
                                                          color: (order.orderStatus ==
                                                              "Delivered" &&
                                                              order.paymentStatus ==
                                                                  "Not Paid")
                                                              ? Colors
                                                              .red
                                                              : (order.orderStatus == "Delivered" &&
                                                              order.paymentStatus ==
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

                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text("Name:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.name ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text("Mobile:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.mobile ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.foodName ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text("Weight:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.reffererMobile ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Payable Amount:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "₹${order.totalPrice}" ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Delivery Status:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.orderStatus ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Payment Status:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    order.paymentStatus ??
                                                        "No Name",
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    textAlign:
                                                    TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "Customer Remarks:",
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
                                                          fontSize:
                                                          12.0,
                                                          letterSpacing:
                                                          0.5)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 100.w,
                                              // Scrollable area height
                                              padding:
                                              EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                BorderRadius
                                                    .circular(8.0),
                                              ),
                                              child:
                                              SingleChildScrollView(
                                                child: Text(
                                                  order.remarks ?? "",
                                                  style: TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),

                                // ListTile(
                                //   title: Text(order.name ?? "No Name"),
                                //   subtitle: Text("${order.mobile ?? 'N/A'}"),
                                //   trailing: Column(
                                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Text("Meat: ${order.meatType ?? 'N/A'}",textAlign: TextAlign.end,),
                                //     (order.meatType?? "").contains("Chick")  ?  Text("Type: ${order.chickenoption ?? 'N/A'}",textAlign: TextAlign.end,) : Text("") ,
                                //
                                //     ],
                                //   ),
                                //   onTap: () {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) => OrderDetailsScreen(order: order),
                                //       ),
                                //     );
                                //   },
                                // ),
                              ),
                            )
                                : Container() ;


                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return Scaffold(
          appBar: AppBar(
            title: Text("My Orders"),
          ),
          body: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: isLoading
                      ? Center(
                      child:
                      CircularProgressIndicator()) // Show loading indicator
                      : allOrders.isEmpty
                      ? Center(
                    child: Text(
                      'No orders found. Pull to refresh.',
                      textAlign: TextAlign.center,
                    ),
                  )
                      : Center(
                    child: Text(
                      'No orders found. Pull to refresh.',
                      textAlign: TextAlign.center,
                    ),
                  )
                ),
              ),
            ],
          ),
        );
    }
  }
}
