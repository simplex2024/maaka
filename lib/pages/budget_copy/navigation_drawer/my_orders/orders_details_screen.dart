import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maaakanmoney/components/ListView/ListController.dart';
import 'package:maaakanmoney/components/ListView/ListPageView.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:maaakanmoney/components/custom_dialog_box.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_theme.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_widgets.dart';
import 'package:maaakanmoney/pages/budget_copy/BudgetCopyController.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final MeatOrder order;
  final bool? isAdminView;

  OrderDetailsScreen({required this.order,required this.isAdminView});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  CollectionReference? _collectionUsers;
  bool isDeleting = false;
  TextEditingController? addressController;
  TextEditingController? custRemarksController;

  List<Tuple2<String?, String?>?> paymentStatus = [];
  List<Tuple2<String?, String?>?> orderStatus = [];

  Tuple2<String?, String?>? getSelectedOrderStatus = Tuple2("", "");
  Tuple2<String?, String?>? getSelectedPaymentStatus = Tuple2("", "");

  Future<void> deleteOrder(String userId,String docID) async {
    setState(() {
      isDeleting = true;
    });

    try {
      // Replace `users` and `meatorder` with your Firestore collection paths.
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId) // Replace with appropriate user ID if needed
          .collection('meatorder')
          .doc(docID)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order deleted successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete order: $e")),
      );
    } finally {
      setState(() {
        isDeleting = false;
      });
    }
  }


  Future<void> updateOrderDetails(
      String? getUserId,
      String? getOrderStatus,
      String? getPaymentStatus,
      String? getDocId,
      ) async {
    try {
      QuerySnapshot snapshot = await _collectionUsers!.limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        await _collectionUsers!.doc(getUserId).collection('meatorder').doc(getDocId).update({
          'orderStatus': getOrderStatus ?? "",
          'paymentStatus': getPaymentStatus ?? "",
        }).then((value) async {
          Constants.showToast("Order Details Updated", ToastGravity.CENTER);
          Navigator.pop(context);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Document id is empty")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to Update Details: $e")),
      );
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _collectionUsers = FirebaseFirestore.instance.collection('users');

    addressController ??= TextEditingController();
    custRemarksController ??= TextEditingController();

    addressController?.text = widget.order.deliveryAddress ?? "";
    custRemarksController?.text = widget.order.remarks ?? "";

    paymentStatus = [
      Tuple2("Paid", "1"),
      Tuple2("Not Paid", "2"),
    ];

    orderStatus = [
      Tuple2("Pending", "1"),
      Tuple2("Order Confirmed", "1"),
      Tuple2("Order Taken", "2"),
      Tuple2("In Preparation", "3"),
      Tuple2("Out for Delivery", "4"),
      Tuple2("Delivered", "5"),
    ];

    ref.read(ListProvider.notifier).txtPaymentStatus?.text = widget.order.paymentStatus ?? "";
    ref.read(ListProvider.notifier).txtOrderStatus?.text = widget.order.orderStatus ?? "";

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
        actions: [
          (widget.isAdminView ?? false) ?  IconButton(
            icon: Icon(Icons.delete),
            onPressed: isDeleting
                ? null
                : () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Delete Order"),
                  content: Text(
                    "Are you sure you want to delete this order?",
                  ),
                  actions: [
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text("Delete"),
                      onPressed: () {
                        Navigator.pop(context);
                        deleteOrder(widget.order.userId ?? "",widget.order.docID ?? "");
                      },
                    ),
                  ],
                ),
              );
            },
          ) : Container()
        ],
      ),
      body: isDeleting
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 8,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                
                    Row(
                      children: [
                        Expanded(
                          child: Text('Total Amount:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text( "₹${widget.order.totalPrice ?? ""}",
                            style:
                            Theme.of(context)
                                .textTheme
                                .headlineLarge,textAlign: TextAlign.end,),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        ref.read(ListProvider.notifier).getData =
                            orderStatus;
                        ref.read(ListProvider.notifier).getSelectionType =
                            SelectionType.orderStatus;
                
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListViewBuilder(
                                  getListHeading: "Order Status",
                                  getIndex: null,
                                )));
                      },
                      child: Consumer(builder: (context, ref, child) {
                        getSelectedOrderStatus = ref.watch(adminTypeProvider);
                
                        return Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Order Status",
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1),
                                  maxLines: 2,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(top: 10.0),
                                        child: Container(
                                          height: 50,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 10.0),
                                            child: TextFormField(
                                              enabled: false,
                                              keyboardType:
                                              TextInputType.none,
                                              controller: ref
                                                  .read(ListProvider
                                                  .notifier)
                                                  .txtOrderStatus,
                                              focusNode: ref
                                                  .read(ListProvider
                                                  .notifier)
                                                  .focusOrderStatus,
                                              textCapitalization:
                                              TextCapitalization
                                                  .words,
                                              decoration:
                                              const InputDecoration(
                                                // labelText: data.success![1][index].item2!,
                                                  suffixIcon: Icon(
                                                    Icons
                                                        .navigate_next,
                                                    color: Color
                                                        .fromARGB(
                                                        125,
                                                        1,
                                                        2,
                                                        2),
                                                  ),
                                                  border:
                                                  InputBorder
                                                      .none),
                                              style: const TextStyle(
                                                  letterSpacing: 1),
                
                
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey),
                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ]);
                      }),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        ref.read(ListProvider.notifier).getData =
                            paymentStatus;
                        ref.read(ListProvider.notifier).getSelectionType =
                            SelectionType.paymentStatus;
                
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListViewBuilder(
                                  getListHeading: "Payment Status",
                                  getIndex: null,
                                )));
                      },
                      child: Consumer(builder: (context, ref, child) {
                        getSelectedPaymentStatus = ref.watch(adminTypeProvider);
                
                        return Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Payment Status",
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1),
                                  maxLines: 2,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(top: 10.0),
                                        child: Container(
                                          height: 50,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 10.0),
                                            child: TextFormField(
                                              enabled: false,
                                              keyboardType:
                                              TextInputType.none,
                                              controller: ref
                                                  .read(ListProvider
                                                  .notifier)
                                                  .txtPaymentStatus,
                                              focusNode: ref
                                                  .read(ListProvider
                                                  .notifier)
                                                  .focusPaymentStatus,
                                              textCapitalization:
                                              TextCapitalization
                                                  .words,
                                              decoration:
                                              const InputDecoration(
                                                // labelText: data.success![1][index].item2!,
                                                  suffixIcon: Icon(
                                                    Icons
                                                        .navigate_next,
                                                    color: Color
                                                        .fromARGB(
                                                        125,
                                                        1,
                                                        2,
                                                        2),
                                                  ),
                                                  border:
                                                  InputBorder
                                                      .none),
                                              style: const TextStyle(
                                                  letterSpacing: 1),
                
                
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey),
                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ]);
                      }),
                    ),
                    SizedBox(height: 20),
                    Row(
                
                      children: [
                        Expanded(
                          child: Text('Name:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text(widget.order.name ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end,),
                        ),
                      ],
                    ),
                    Row(
                
                      children: [
                        Expanded(
                          child: Text('Mobile:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text(widget.order.mobile ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(
                
                      children: [
                        Expanded(
                          child: Text('Meat Type:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text(widget.order.meatType ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                        ),
                      ],
                    ),

                    Row(
                
                      children: [
                        Expanded(
                          child: Text('Area:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text(widget.order.area ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(
                
                      children: [
                        Expanded(
                          child: Text('Weight:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text(widget.order.weight ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(
                
                      children: [
                        Expanded(
                          child: Text('Price:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text("₹${widget.order.totalPrice}" ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(
                
                      children: [
                        Expanded(
                          child: Text('Delivery Date:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text(widget.order.deliveryDate ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(
                
                      children: [
                        Expanded(
                          child: Text('Delivery Time:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text(widget.order.deliveryTime ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(
                
                      children: [
                        Expanded(
                          child: Text('Order Status:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text(widget.order.orderStatus ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(

                      children: [
                        Expanded(
                          child: Text('Payment Status:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text(widget.order.paymentStatus ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, .0),
                      child: TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                            labelText: 'Delivery Address'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                        maxLines: 5,
                        readOnly: true,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, .0),
                      child: TextFormField(
                        controller: custRemarksController,
                        decoration: InputDecoration(
                            labelText: 'Customer Remarks'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                        maxLines: 10,
                        readOnly: true,
                      ),
                    ),
                    SizedBox(height: 20),
                   (widget.isAdminView ?? false)?  Container(
                      height: 25.h,
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
                      child: Row(

                        children: [
                          Expanded(
                            child: Text('Refferer No:- ',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                          ),
                          Expanded(
                            child: Text(widget.order.reffererMobile ?? "",
                                style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                          ),
                        ],
                      ),
                    ) : Container(),
                    SizedBox(height: 20),
                

                  ],
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Align(
                alignment: const AlignmentDirectional(0.0, 0.05),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      0.0, 24.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () {



                      showDialog(
                          barrierDismissible:
                          false,
                          context: context,
                          builder:
                              (BuildContext
                          context) {
                            return CustomDialogBox(
                              title:
                              "Message!",
                              descriptions:
                              "Are you sure, Want to Update Details",
                              text: "Ok",
                              isCancel:
                              true,
                              onTap: () {

                                if((ref.read(ListProvider.notifier).txtOrderStatus?.text ?? "").isEmpty ){
                                  Constants.showToast("Select Order Status", ToastGravity.CENTER);
                                  Navigator.pop(context);
                                  return;
                                }

                                if((ref.read(ListProvider.notifier).txtPaymentStatus?.text ?? "").isEmpty ){
                                  Constants.showToast("Select Payment Status", ToastGravity.CENTER);
                                  Navigator.pop(context);
                                  return;
                                }


                                updateOrderDetails(widget.order.userId ?? "",ref.read(ListProvider.notifier).txtOrderStatus?.text,ref.read(ListProvider.notifier).txtPaymentStatus?.text,widget.order.docID);

                              },
                            );
                          });


                    },
                    text: "Update Details !",
                    options: FFButtonOptions(
                      width: 270.0,
                      height: 50.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context)
                          .titleMedium
                          .override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 15.0,
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
    );
  }

}


//todo:- food order details

class FoodOrderDetailsScreen extends ConsumerStatefulWidget {
  final FoodOrder order;
  final bool? isAdminView;

  FoodOrderDetailsScreen({required this.order,required this.isAdminView});

  @override
  _FoodOrderDetailsScreenState createState() => _FoodOrderDetailsScreenState();
}

class _FoodOrderDetailsScreenState extends ConsumerState<FoodOrderDetailsScreen> {
  CollectionReference? _collectionUsers;
  bool isDeleting = false;
  TextEditingController? addressController;
  TextEditingController? custRemarksController;

  List<Tuple2<String?, String?>?> paymentStatus = [];
  List<Tuple2<String?, String?>?> orderStatus = [];

  Tuple2<String?, String?>? getSelectedOrderStatus = Tuple2("", "");
  Tuple2<String?, String?>? getSelectedPaymentStatus = Tuple2("", "");

  Future<void> deleteOrder(String userId,String docID) async {
    setState(() {
      isDeleting = true;
    });

    try {
      // Replace `users` and `meatorder` with your Firestore collection paths.
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId) // Replace with appropriate user ID if needed
          .collection('foodorder')
          .doc(docID)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order deleted successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete order: $e")),
      );
    } finally {
      setState(() {
        isDeleting = false;
      });
    }
  }


  Future<void> updateOrderDetails(
      String? getUserId,
      String? getOrderStatus,
      String? getPaymentStatus,
      String? getDocId,
      ) async {
    try {
      QuerySnapshot snapshot = await _collectionUsers!.limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        await _collectionUsers!.doc(getUserId).collection('foodorder').doc(getDocId).update({
          'orderStatus': getOrderStatus ?? "",
          'paymentStatus': getPaymentStatus ?? "",
        }).then((value) async {
          Constants.showToast("Order Details Updated", ToastGravity.CENTER);
          Navigator.pop(context);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Document id is empty")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to Update Details: $e")),
      );
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _collectionUsers = FirebaseFirestore.instance.collection('users');

    addressController ??= TextEditingController();
    custRemarksController ??= TextEditingController();

    addressController?.text = widget.order.deliveryAddress ?? "";
    custRemarksController?.text = widget.order.remarks ?? "";

    paymentStatus = [
      Tuple2("Paid", "1"),
      Tuple2("Not Paid", "2"),
    ];

    orderStatus = [
      Tuple2("Pending", "1"),
      Tuple2("Order Confirmed", "1"),
      Tuple2("Order Taken", "2"),
      Tuple2("In Preparation", "3"),
      Tuple2("Out for Delivery", "4"),
      Tuple2("Delivered", "5"),
    ];

    ref.read(ListProvider.notifier).txtPaymentStatus?.text = widget.order.paymentStatus ?? "";
    ref.read(ListProvider.notifier).txtOrderStatus?.text = widget.order.orderStatus ?? "";

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
        actions: [
          (widget.isAdminView ?? false) ?  IconButton(
            icon: Icon(Icons.delete),
            onPressed: isDeleting
                ? null
                : () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Delete Order"),
                  content: Text(
                    "Are you sure you want to delete this order?",
                  ),
                  actions: [
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text("Delete"),
                      onPressed: () {
                        Navigator.pop(context);
                        deleteOrder(widget.order.userId ?? "",widget.order.docID ?? "");
                      },
                    ),
                  ],
                ),
              );
            },
          ) : Container()
        ],
      ),
      body: isDeleting
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 8,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: Text('Total Amount:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text( "₹${widget.order.totalPrice ?? ""}",
                            style:
                            Theme.of(context)
                                .textTheme
                                .headlineLarge,textAlign: TextAlign.end,),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        ref.read(ListProvider.notifier).getData =
                            orderStatus;
                        ref.read(ListProvider.notifier).getSelectionType =
                            SelectionType.orderStatus;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListViewBuilder(
                                  getListHeading: "Order Status",
                                  getIndex: null,
                                )));
                      },
                      child: Consumer(builder: (context, ref, child) {
                        getSelectedOrderStatus = ref.watch(adminTypeProvider);

                        return Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Order Status",
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1),
                                  maxLines: 2,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(top: 10.0),
                                        child: Container(
                                          height: 50,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 10.0),
                                            child: TextFormField(
                                              enabled: false,
                                              keyboardType:
                                              TextInputType.none,
                                              controller: ref
                                                  .read(ListProvider
                                                  .notifier)
                                                  .txtOrderStatus,
                                              focusNode: ref
                                                  .read(ListProvider
                                                  .notifier)
                                                  .focusOrderStatus,
                                              textCapitalization:
                                              TextCapitalization
                                                  .words,
                                              decoration:
                                              const InputDecoration(
                                                // labelText: data.success![1][index].item2!,
                                                  suffixIcon: Icon(
                                                    Icons
                                                        .navigate_next,
                                                    color: Color
                                                        .fromARGB(
                                                        125,
                                                        1,
                                                        2,
                                                        2),
                                                  ),
                                                  border:
                                                  InputBorder
                                                      .none),
                                              style: const TextStyle(
                                                  letterSpacing: 1),


                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey),
                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ]);
                      }),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        ref.read(ListProvider.notifier).getData =
                            paymentStatus;
                        ref.read(ListProvider.notifier).getSelectionType =
                            SelectionType.paymentStatus;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListViewBuilder(
                                  getListHeading: "Payment Status",
                                  getIndex: null,
                                )));
                      },
                      child: Consumer(builder: (context, ref, child) {
                        getSelectedPaymentStatus = ref.watch(adminTypeProvider);

                        return Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Payment Status",
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1),
                                  maxLines: 2,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(top: 10.0),
                                        child: Container(
                                          height: 50,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 10.0),
                                            child: TextFormField(
                                              enabled: false,
                                              keyboardType:
                                              TextInputType.none,
                                              controller: ref
                                                  .read(ListProvider
                                                  .notifier)
                                                  .txtPaymentStatus,
                                              focusNode: ref
                                                  .read(ListProvider
                                                  .notifier)
                                                  .focusPaymentStatus,
                                              textCapitalization:
                                              TextCapitalization
                                                  .words,
                                              decoration:
                                              const InputDecoration(
                                                // labelText: data.success![1][index].item2!,
                                                  suffixIcon: Icon(
                                                    Icons
                                                        .navigate_next,
                                                    color: Color
                                                        .fromARGB(
                                                        125,
                                                        1,
                                                        2,
                                                        2),
                                                  ),
                                                  border:
                                                  InputBorder
                                                      .none),
                                              style: const TextStyle(
                                                  letterSpacing: 1),


                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey),
                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ]);
                      }),
                    ),
                    SizedBox(height: 20),
                    Row(

                      children: [
                        Expanded(
                          child: Text('Name:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text(widget.order.name ?? "",
                            style: TextStyle(fontSize: 20),textAlign: TextAlign.end,),
                        ),
                      ],
                    ),
                    Row(

                      children: [
                        Expanded(
                          child: Text('Mobile:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text(widget.order.mobile ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(

                      children: [
                        Expanded(
                          child: Text('Food Type:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text(widget.order.foodName ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                        ),
                      ],
                    ),

                    Row(

                      children: [
                        Expanded(
                          child: Text('Area:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text(widget.order.area ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(

                      children: [
                        Expanded(
                          child: Text('Quantity:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text(widget.order.foodQuantity ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(

                      children: [
                        Expanded(
                          child: Text('Price:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text("₹${widget.order.totalPrice}" ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(

                      children: [
                        Expanded(
                          child: Text('Delivery Date:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text(widget.order.deliveryDate ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(

                      children: [
                        Expanded(
                          child: Text('Delivery Time:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text(widget.order.deliveryTime ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(

                      children: [
                        Expanded(
                          child: Text('Order Status:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text(widget.order.orderStatus ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(

                      children: [
                        Expanded(
                          child: Text('Payment Status:- ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: Text(widget.order.paymentStatus ?? "",
                              style: TextStyle(fontSize: 20),textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, .0),
                      child: TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                            labelText: 'Delivery Address'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                        maxLines: 5,
                        readOnly: true,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, .0),
                      child: TextFormField(
                        controller: custRemarksController,
                        decoration: InputDecoration(
                            labelText: 'Customer Remarks'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                        maxLines: 10,
                        readOnly: true,
                      ),
                    ),
                    SizedBox(height: 20),


                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: const AlignmentDirectional(0.0, 0.05),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      0.0, 24.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () {



                      showDialog(
                          barrierDismissible:
                          false,
                          context: context,
                          builder:
                              (BuildContext
                          context) {
                            return CustomDialogBox(
                              title:
                              "Message!",
                              descriptions:
                              "Are you sure, Want to Update Details",
                              text: "Ok",
                              isCancel:
                              true,
                              onTap: () {

                                if((ref.read(ListProvider.notifier).txtOrderStatus?.text ?? "").isEmpty ){
                                  Constants.showToast("Select Order Status", ToastGravity.CENTER);
                                  Navigator.pop(context);
                                  return;
                                }

                                if((ref.read(ListProvider.notifier).txtPaymentStatus?.text ?? "").isEmpty ){
                                  Constants.showToast("Select Payment Status", ToastGravity.CENTER);
                                  Navigator.pop(context);
                                  return;
                                }


                                updateOrderDetails(widget.order.userId ?? "",ref.read(ListProvider.notifier).txtOrderStatus?.text,ref.read(ListProvider.notifier).txtPaymentStatus?.text,widget.order.docID);

                              },
                            );
                          });


                    },
                    text: "Update Details !",
                    options: FFButtonOptions(
                      width: 270.0,
                      height: 50.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context)
                          .titleMedium
                          .override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 15.0,
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
    );
  }

}
