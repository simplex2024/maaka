// ignore_for_file: must_be_immutable, use_build_context_synchronously, invalid_return_type_for_catch_error, prefer_adjacent_string_concatenation

// import 'dart:html';

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:maaakanmoney/components/ListView/ListController.dart';
import 'package:maaakanmoney/components/ReusableWidget/BottomSheet.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:maaakanmoney/components/custom_dialog_box.dart';
import 'package:maaakanmoney/pages/budget_copy/BudgetCopyController.dart';
import 'package:maaakanmoney/pages/chatScreen.dart';
import 'package:maaakanmoney/pages/showUser/showUserController.dart';
import 'package:maaakanmoney/pages/update_money/update_money_widget.dart';
import 'package:maaakanmoney/phoneController.dart';
import 'package:maaakanmoney/verify.dart';
import 'package:tuple/tuple.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'change_area.dart';

class ShowUserWidget extends ConsumerStatefulWidget {
  ShowUserWidget(
      {Key? key,
      @required this.getMobile,
      @required this.getExistingTotal,
      @required this.getDocId,
      @required this.getUserName,
      @required this.getUserIndex,
      @required this.getSecurityCode,
      @required this.getAdminType,
      @required this.getHeroTag,
      @required this.getuserType})
      : super(key: key);

  String? getHeroTag;
  String? getUserName;
  String? getMobile;
  double? getExistingTotal;
  String? getDocId;
  int? getUserIndex;
  String? getSecurityCode;
  String? getAdminType;
  String? getuserType;

  @override
  _ShowUserWidgetState createState() => _ShowUserWidgetState();
}

class _ShowUserWidgetState extends ConsumerState<ShowUserWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  //todo:- 3.5.23
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  AnimationController? lottieController;
  ConnectivityResult? data;
  CollectionReference? _collectionReference;
  CollectionReference? _collectionUsers;
  bool? isPendingPayment = false;
  late StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void initState() {
    super.initState();

    _collectionReference =
        FirebaseFirestore.instance.collection('adminDetails');
    _collectionUsers = FirebaseFirestore.instance.collection('users');

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          ref.read(isUserRefreshIndicator.notifier).state = false;
        }));

    lottieController = AnimationController(vsync: this);

    lottieController!.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        lottieController!.repeat();
      }
    });

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(showUserListProvider.notifier).getUserListDetails(
          widget.getMobile, widget.getDocId, widget.getUserIndex);
    });
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      print("aaaaaa$result");

      if (result != null || result.isNotEmpty) {
        ref.read(connectivityProvider.notifier).state = result[0];
      }
    });
  }

  @override
  dispose() {
    subscription.cancel();
    lottieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          // toolbarHeight: 110,
          titleSpacing: 0,
          title: Consumer(builder: (context, ref, child) {
            Tuple4? getUserDetails = ref.watch(getUserNetTotal);

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.getUserName.toString().toUpperCase() +
                      " - " +
                      widget.getSecurityCode.toString(),
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      "Mapped Admin",
                      style: GlobalTextStyles.secondaryText2(
                          textColor: Constants.secondary),
                    ),
                    Text(
                      widget.getAdminType.toString() == "1"
                          ? " - Meena"
                          : widget.getAdminType.toString() == "2"
                              ? " - Babu"
                              : "",
                      style: GlobalTextStyles.secondaryText2(
                          textColor: Constants.secondary),
                    ),
                  ],
                ),
              ],
            );
          }),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
          ),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.add,
                        color: Constants.secondary3,
                        size: 24.0,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text("Add Money")
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.add,
                        color: Constants.secondary3,
                        size: 24.0,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text("Cashback")
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.message,
                        color: Constants.secondary3,
                        size: 24.0,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text("Contact")
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Constants.secondary3,
                        size: 24.0,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text("change Area")
                    ],
                  ),
                ),

                ///todo:- important - uncomment below code to change mapped admin
                PopupMenuItem<int>(
                  value: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.admin_panel_settings,
                        color: Constants.secondary3,
                        size: 24.0,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text("Change Admin")
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.merge_type,
                        color: Constants.secondary3,
                        size: 24.0,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text((widget.getuserType ?? "") == "0"
                          ? "Acc Type to Buisness"
                          : "Acc Type to Normal")
                    ],
                  ),
                ),
              ];
            }, onSelected: (value) async {
              if (value == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateMoneyWidget(
                      getMobile: widget.getMobile,
                      getDocId: widget.getDocId,
                      getExistingTotal: widget.getExistingTotal,
                      isSavOrCashback: true,
                      isUpdatingExistingEntry: false,
                      isTransTypeDeposite: null,
                      getUserIndex: widget.getUserIndex,
                    ),
                  ),
                ).then((value) {
                  //todo:- below code refresh firebase records automatically when come back to same screen

                  // ref
                  //     .read(showUserListProvider.notifier)
                  //     .getUserListDetails(widget.getMobile);
                });
              } else if (value == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateMoneyWidget(
                      getMobile: widget.getMobile,
                      getDocId: widget.getDocId,
                      getExistingTotal: widget.getExistingTotal,
                      isSavOrCashback: false,
                      isUpdatingExistingEntry: false,
                      isTransTypeDeposite: null,
                      getUserIndex: widget.getUserIndex,
                    ),
                  ),
                ).then((value) {
                  //todo:- below code refresh firebase records automatically when come back to same screen

                  // ref
                  //     .read(showUserListProvider.notifier)
                  //     .getUserListDetails(widget.getMobile);
                });
              } else if (value == 2) {
                //todo:30.6.23 - chat creation

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          userName: widget.getUserName,
                          adminId: Constants.adminId,
                          userId: widget.getMobile,
                          callNo: widget.getMobile,
                          getDocId: widget.getDocId),
                    )).then((value) {});
              } else if (value == 3) {
                updateMappedAdmin(
                    widget.getAdminType.toString() == "1" ? "2" : "1",
                    widget.getDocId);
              } else if (value == 4) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeArea(
                              getDocID: widget.getDocId ?? "",
                            )));
              } else if (value == 5) {


                OptionBottomSheet.show(
                  context: context,
                  title: "Change User type",
                  options: [
                    Tuple2("Normal User", "0"),
                    Tuple2("Meat Shop Owner", "1"),
                    Tuple2("Cloud Kitchen - Main Course", "2"),
                    Tuple2("Cloud Kitchen - Desserts", "3"),
                    Tuple2("Cloud Kitchen - Main Course & Desserts", "4"),
                    Tuple2("Delivery Boy", "5"),
                    Tuple2("Water Can / Groceries", "6"),
                    Tuple2("Product Seller", "7"),
                    Tuple2("Meat Executive", "8"),
                    Tuple2("Water Wash Service", "9"),
                    Tuple2("Bike Transport", "10"),
                    Tuple2("Car Cab Transport", "11"),
                    Tuple2("Load Van Transport", "12"),
                    Tuple2("Laundromat", "13"),
                  ],
                  onSelect: (selected) {
                    updateUserType(
                        // widget.getuserType.toString() == "0" ? "1" : "0",
                      selected ?? "0",
                        widget.getDocId);
                  },
                );
              }
            }),
          ],
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Consumer(builder: (context, ref, child) {
            data = ref.watch(connectivityProvider);
            bool? isRefresh = ref.watch(isUserRefreshIndicator);
            ShowUserListState getUserTransList =
                ref.watch(showUserListProvider);
            bool isLoading = false;
            isLoading = (getUserTransList.status == ResStatus.loading);
            return Stack(children: [
              RefreshIndicator(
                onRefresh: () async {
                  ref.read(isUserRefreshIndicator.notifier).state = true;
                  // ref
                  //     .read(showUserListProvider.notifier)
                  //     .getUserNetBal(widget.getUserIndex);

                  //todo:- 13.7.23 altering mistaken total in admin details and user details

                  Map<String, dynamic> newAdminData = {};

                  Map<String, dynamic> newUserData = {};

                  Tuple4? getUserDetails =
                      ref.read(getUserNetTotal.notifier).state;

                  try {
                    DocumentSnapshot snapshot = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.getDocId)
                        .get();

                    double? totalCredit = 0.0;
                    double? totalDebit = 0.0;
                    double? netTotal = 0.0;
                    double? totalIntCredit = 0.0;
                    double? totalIntDebit = 0.0;
                    double? netIntTotal = 0.0;

                    if (snapshot.exists) {
                      Map<String, dynamic> data =
                          snapshot.data() as Map<String, dynamic>;
                      totalCredit = data['totalCredit'] as double;
                      totalDebit = data['totalDebit'] as double;

                      totalIntCredit = data['totalIntCredit'] as double;
                      totalIntDebit = data['totalIntDebit'] as double;

//todo:-  if got user details, then get admin details

                      double? admnTtlCredit;
                      double? admnTtlDebit;
                      double? admnTtlIntCredit;
                      double? admnTtlIntDebit;

                      QuerySnapshot adminSnapshot = await FirebaseFirestore
                          .instance
                          .collection('adminDetails')
                          .get();

                      if (adminSnapshot != null &&
                          adminSnapshot.docs.isNotEmpty) {
                        await Future.forEach(adminSnapshot.docs, (doc) async {
                          Map<String, dynamic> data =
                              doc.data() as Map<String, dynamic>;

                          admnTtlCredit = data['totalCredit'] as double;
                          admnTtlDebit = data['totalDebit'] as double;
                          admnTtlIntCredit = data['totalIntCredit'] as double;
                          admnTtlIntDebit = data['totalIntDebit'] as double;
                        });

//todo:- if got user and admin details successfully then follow
                        if (getUserDetails.item1 == totalCredit) {
                          if (getUserDetails.item2 == totalDebit) {
                          } else {
                            newUserData = {
                              'totalDebit': getUserDetails.item2,
                            };

                            double? getadmnTotalDebit =
                                admnTtlDebit! - totalDebit!;
                            double? getFinalTotalDebit =
                                getadmnTotalDebit! + getUserDetails.item2!;

                            newAdminData = {
                              'totalCredit': getFinalTotalDebit,
                            };

                            await updateUserDetails(newUserData, snapshot);
                            await updateAdminDetails(newAdminData);
                          }
                        } else {
                          newUserData = {
                            'totalCredit': getUserDetails.item1,
                          };

                          double? getadmnTotalCredit =
                              admnTtlCredit! - totalCredit!;
                          double? getFinalTotalCredit =
                              getadmnTotalCredit! + getUserDetails.item1!;

                          newAdminData = {
                            'totalCredit': getFinalTotalCredit,
                          };

                          await updateUserDetails(newUserData, snapshot);
                          await updateAdminDetails(newAdminData);
                        }

                        if (getUserDetails.item4 == totalIntCredit) {
                        } else {
                          newUserData = {
                            'totalIntCredit': getUserDetails.item4,
                          };

                          double? getadmnTotalIntCredit =
                              admnTtlIntCredit! - totalIntCredit!;
                          double? getFinalTotalIntCredit =
                              getadmnTotalIntCredit! + getUserDetails.item4!;

                          newAdminData = {
                            'totalIntCredit': getFinalTotalIntCredit,
                          };

                          await updateUserDetails(newUserData, snapshot);
                          await updateAdminDetails(newAdminData);
                        }
                      }
                    } else {
                      // Handle the case when adminSnapshot is null or has no documents
                      print('adminSnapshot is null or has no documents.');
                    }
                  } catch (e) {
                    // Handle the network failure or unexpected error
                    print('An error occurred: $e');
                    // Display an error message to the user or perform appropriate error handling
                  }

                  // // //todo:-28.1.24 if any pending amount observed, then updated in users table
                  // await updatePaymentPendingRequest(widget.getDocId);

                  return ref
                      .read(showUserListProvider.notifier)
                      .getUserListDetails(widget.getMobile, widget.getDocId,
                          widget.getUserIndex);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Consumer(builder: (context, ref, child) {
                        Tuple4? getUserDetails = ref.watch(getUserNetTotal);

                        return Hero(
                          tag: widget.getHeroTag ?? "",
                          child: SingleChildScrollView(
                            child: Container(
                              color: Constants.secondary2,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Netbalance",
                                                style: GlobalTextStyles
                                                    .secondaryText1(
                                                  txtWeight: FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                getUserDetails?.item3
                                                        .toString() ??
                                                    "",
                                                style: GlobalTextStyles
                                                    .secondaryText1(
                                                        txtWeight:
                                                            FontWeight.bold),
                                                textAlign: TextAlign.left,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Credited",
                                                style: GlobalTextStyles
                                                    .secondaryText1(
                                                  txtWeight: FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Debited",
                                                style: GlobalTextStyles
                                                    .secondaryText1(
                                                        txtWeight:
                                                            FontWeight.normal),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Interest",
                                                style: GlobalTextStyles
                                                    .secondaryText1(
                                                        txtWeight:
                                                            FontWeight.normal),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                getUserDetails?.item1
                                                        .toString() ??
                                                    "",
                                                style: GlobalTextStyles
                                                    .secondaryText2(
                                                        txtWeight:
                                                            FontWeight.bold),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                getUserDetails?.item2
                                                        .toString() ??
                                                    "",
                                                style: GlobalTextStyles
                                                    .secondaryText2(
                                                        txtWeight:
                                                            FontWeight.bold),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                getUserDetails?.item4
                                                        .toStringAsFixed(2) ??
                                                    "",
                                                style: GlobalTextStyles
                                                    .secondaryText2(
                                                        txtWeight:
                                                            FontWeight.bold),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      Expanded(
                        flex: 8,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: ref
                              .read(showUserListProvider.notifier)
                              .groupTransactionsByDate(ref
                                      .read(adminDashListProvider.notifier)
                                      .userList2?[widget.getUserIndex ?? 0]
                                      .transactions ??
                                  [])
                              .length,
                          itemBuilder: (context, index) {
                            // // Now, use the groupedTransactions map to access transactions for each date

                            final groupedTransactions = ref
                                .read(showUserListProvider.notifier)
                                .groupTransactionsByDate(ref
                                        .read(adminDashListProvider.notifier)
                                        .userList2?[widget.getUserIndex ?? 0]
                                        .transactions ??
                                    []);
                            final dateKeys = groupedTransactions.keys.toList();
                            final date =
                                dateKeys[index]; // Get the date for this index

                            // Create a list of transaction widgets for the current date
                            final transactionsForDate =
                                groupedTransactions[date] ?? [];

                            final transactionWidgets =
                                transactionsForDate.map((transaction) {
                              //todo:- 4.10.23 Customize how you want to display each transaction item
                              final amount = transaction?.amount;
                              final transType = transaction?.isDeposit;
                              final datee = transaction?.date;
                              final mobile = transaction?.mobile;
                              final docId = transaction?.transDocId;
                              final interest = transaction?.interest;
                              final timeStamp = transaction?.timmeStamp;
                              final goalId = transaction?.goalId;

                              print("get doc id = $goalId");

                              // if(amount == 0 ){
                              //   isPendingPayment = true;
                              // }

                              // Replace this with your Timestamp object
                              Timestamp timestamp =
                                  timeStamp ?? Timestamp(000, 000);
                              // Convert Timestamp to DateTime
                              DateTime dateTime = timestamp.toDate();
                              // Format date and time
                              String formattedDateTime =
                                  DateFormat('dd-MM-yyyy h:mm a')
                                      .format(dateTime);

                              String getFinInt = interest == null
                                  ? 0.0.toString()
                                  : interest.toStringAsFixed(2);

                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: Slidable(
                                    key: const ValueKey(0),
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) {
                                            // String documentId =
                                            //     documents[index].id;

                                            if (widget.getMobile == mobile) {
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CustomDialogBox(
                                                      title: "Alert!",
                                                      descriptions:
                                                          "Are you sure, Do you want delete this record",
                                                      text: "Ok",
                                                      isCancel: true,
                                                      onTap: () async {
                                                        try {
                                                          Navigator.pop(
                                                              context); // Close the dialog
                                                          // Simulating some asynchronous operation
                                                          await Future.delayed(
                                                              const Duration(
                                                                  seconds: 0));
                                                          // User confirmed deletion, proceed with deleting the record

                                                          firestore
                                                              .collection(
                                                                  'users')
                                                              .doc(widget
                                                                  .getDocId)
                                                              .collection(
                                                                  'transaction')
                                                              .doc(docId)
                                                              .delete()
                                                              .then((_) async {
                                                            if (index >= 0 &&
                                                                index <
                                                                    ref
                                                                        .read(adminDashListProvider
                                                                            .notifier)
                                                                        .userList2![
                                                                            widget.getUserIndex ??
                                                                                0]
                                                                        .transactions
                                                                        .length) {
                                                              ref
                                                                  .read(adminDashListProvider
                                                                      .notifier)
                                                                  .userList2?[
                                                                      widget.getUserIndex ??
                                                                          0]
                                                                  .transactions
                                                                  .removeAt(
                                                                      index);
                                                              print(
                                                                  'Row deleted successfully!');
                                                            } else {
                                                              print(
                                                                  'Invalid row number. Deletion failed.');
                                                            }

                                                            DocumentSnapshot
                                                                snapshot =
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'users')
                                                                    .doc(widget
                                                                        .getDocId)
                                                                    .get();

                                                            double? totalCredit;
                                                            double? totalDebit;
                                                            double? netTotal;
                                                            double?
                                                                totalIntCredit;
                                                            double?
                                                                totalIntDebit;
                                                            double? netIntTotal;

                                                            if (snapshot
                                                                .exists) {
                                                              Map<String,
                                                                      dynamic>
                                                                  data =
                                                                  snapshot.data()
                                                                      as Map<
                                                                          String,
                                                                          dynamic>;
                                                              totalCredit =
                                                                  data['totalCredit']
                                                                      as double;
                                                              totalDebit = data[
                                                                      'totalDebit']
                                                                  as double;
                                                              netTotal = data[
                                                                      'netTotal']
                                                                  as double;
                                                              totalIntCredit =
                                                                  data['totalIntCredit']
                                                                      as double;
                                                              totalIntDebit =
                                                                  data['totalIntDebit']
                                                                      as double;
                                                              netIntTotal =
                                                                  data['netIntTotal']
                                                                      as double;
                                                            }

                                                            QuerySnapshot
                                                                adminSnapshot =
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'adminDetails')
                                                                    .get();

                                                            double?
                                                                admnTtlCredit;
                                                            double?
                                                                admnTtlDebit;
                                                            double?
                                                                admnTtlIntCredit;
                                                            double?
                                                                admnTtlIntDebit;

                                                            await Future.forEach(
                                                                adminSnapshot
                                                                    .docs,
                                                                (doc) async {
                                                              Map<String,
                                                                      dynamic>
                                                                  data =
                                                                  doc.data() as Map<
                                                                      String,
                                                                      dynamic>;

                                                              admnTtlCredit =
                                                                  data['totalCredit']
                                                                      as double;
                                                              admnTtlDebit =
                                                                  data['totalDebit']
                                                                      as double;
                                                              admnTtlIntCredit =
                                                                  data['totalIntCredit']
                                                                      as double;
                                                              admnTtlIntDebit =
                                                                  data['totalIntDebit']
                                                                      as double;
                                                            });

                                                            //todo:- updating new values to admin table, and user document
                                                            //todo:- admin set
                                                            double?
                                                                getFinalCredit =
                                                                0.0;
                                                            double?
                                                                getFinalIntCredit =
                                                                0.0;
                                                            double?
                                                                getFinalDebit =
                                                                0.0;
                                                            double?
                                                                getFinalIntDedit =
                                                                0.0;
                                                            //todo:- user set
                                                            double?
                                                                getFinalUsrCredit =
                                                                0.0;
                                                            double?
                                                                getFinalUsrIntCredit =
                                                                0.0;
                                                            double?
                                                                getFinalUsrDebit =
                                                                0.0;
                                                            double?
                                                                getFinalUsrIntDedit =
                                                                0.0;

                                                            double?
                                                                getFinalNetTotal =
                                                                0.0;
                                                            double?
                                                                getFinalNetIntTotal =
                                                                0.0;

                                                            Map<String, dynamic>
                                                                newAdminData =
                                                                {};

                                                            Map<String, dynamic>
                                                                newUserData =
                                                                {};

                                                            if (transType ==
                                                                true) {
                                                              //todo:- admin set
                                                              getFinalCredit =
                                                                  admnTtlCredit!
                                                                          .toDouble() -
                                                                      amount!
                                                                          .toDouble();
                                                              getFinalIntCredit =
                                                                  admnTtlIntCredit!
                                                                          .toDouble() -
                                                                      interest!
                                                                          .toDouble();

                                                              //todo:- user set
                                                              getFinalUsrCredit =
                                                                  totalCredit!
                                                                          .toDouble() -
                                                                      amount!
                                                                          .toDouble();
                                                              getFinalUsrIntCredit =
                                                                  totalIntCredit!
                                                                          .toDouble() -
                                                                      interest!
                                                                          .toDouble();

                                                              //todo:- check once

                                                              newAdminData = {
                                                                'totalCredit':
                                                                    getFinalCredit,
                                                                'totalIntCredit':
                                                                    getFinalIntCredit,
                                                              };

                                                              newUserData = {
                                                                'totalCredit':
                                                                    getFinalUsrCredit,
                                                                'totalIntCredit':
                                                                    getFinalUsrIntCredit,
                                                                // 'netTotal': getFinalNetTotal,
                                                                // 'netIntTotal': getFinalNetIntTotal,
                                                              };

                                                              await updateAdminDetails(
                                                                  newAdminData);
                                                              await updateUserDetails(
                                                                  newUserData,
                                                                  snapshot);
                                                            } else {
                                                              //todo: admin set
                                                              getFinalDebit =
                                                                  admnTtlDebit!
                                                                          .toDouble() -
                                                                      amount!
                                                                          .toDouble();
                                                              getFinalIntDedit =
                                                                  admnTtlIntDebit!
                                                                          .toDouble() -
                                                                      interest!
                                                                          .toDouble();

                                                              //todo:- user set
                                                              getFinalUsrDebit =
                                                                  totalDebit!
                                                                          .toDouble() -
                                                                      amount!
                                                                          .toDouble();
                                                              getFinalUsrIntDedit =
                                                                  totalIntDebit!
                                                                          .toDouble() -
                                                                      interest!
                                                                          .toDouble();

                                                              newAdminData = {
                                                                'totalDebit':
                                                                    getFinalDebit,
                                                                'totalIntDebit':
                                                                    getFinalIntDedit,
                                                              };

                                                              newUserData = {
                                                                'totalDebit':
                                                                    getFinalUsrDebit,
                                                                'totalIntDebit':
                                                                    getFinalUsrIntDedit,
                                                                // 'netTotal': getFinalNetTotal,
                                                                // 'netIntTotal': getFinalNetIntTotal,
                                                              };

                                                              await updateAdminDetails(
                                                                  newAdminData);
                                                              await updateUserDetails(
                                                                  newUserData,
                                                                  snapshot);
                                                            }
                                                          }).catchError(
                                                                  (error) {
                                                            print('$error');
                                                          });
                                                        } catch (error) {
                                                          print(error);
                                                        }
                                                      },
                                                    );
                                                  });
                                            }
                                          },
                                          backgroundColor:
                                              const Color(0xFFFE4A49),
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                        ),
                                        SlidableAction(
                                          onPressed: (context) {
                                            // String documentId =
                                            //     documents[index].id;

                                            if (widget.getMobile == mobile) {
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CustomDialogBox(
                                                      title: "Alert!",
                                                      descriptions:
                                                          "Are you sure, Do you want Edit this record",
                                                      text: "Ok",
                                                      isCancel: true,
                                                      onTap: () async {
                                                        Navigator.pop(context);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                UpdateMoneyWidget(
                                                              getMobile: widget
                                                                  .getMobile,
                                                              getDocId: widget
                                                                  .getDocId,
                                                              getExistingTotal:
                                                                  widget
                                                                      .getExistingTotal,
                                                              isSavOrCashback:
                                                                  true,
                                                              isUpdatingExistingEntry:
                                                                  true,
                                                              isTransTypeDeposite:
                                                                  transType,
                                                              transDocId: docId,
                                                              getUserIndex: widget
                                                                  .getUserIndex,
                                                            ),
                                                          ),
                                                        ).then((value) {
                                                          //todo:- below code refresh firebase records automatically when come back to same screen

                                                          // ref
                                                          //     .read(showUserListProvider.notifier)
                                                          //     .getUserListDetails(widget.getMobile);
                                                        });
                                                      },
                                                    );
                                                  });
                                            }
                                          },
                                          backgroundColor: Colors.blueAccent,
                                          foregroundColor: Colors.white,
                                          icon: Icons.edit,
                                          label: 'Edit',
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      color: amount == 0
                                          ? Colors.black
                                          : Colors.white,
                                      elevation: 4.0,
                                      shadowColor: Colors.white,
                                      child: ListTile(
                                        leading: Card(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          elevation: 5.0,
                                          color: transType == true
                                              ? FlutterFlowTheme.of(context)
                                                  .primary
                                              : Colors.red,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              transType == true
                                                  ? amount == 0
                                                      ? Icons.lock_clock
                                                      : Icons.arrow_forward
                                                  : amount == 0
                                                      ? Icons.lock_clock
                                                      : Icons.arrow_back,
                                              color: Colors.white,
                                              size: 24.0,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          transType == true
                                              ? amount == 0
                                                  ? "Approve Payment"
                                                  : "Deposit"
                                              : amount == 0
                                                  ? "Approve Withdraw"
                                                  : "Withdraw",
                                          style: TextStyle(
                                              color: amount == 0
                                                  ? FlutterFlowTheme.of(context)
                                                      .secondary
                                                  : FlutterFlowTheme.of(context)
                                                      .primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                              letterSpacing: 1),
                                        ),
                                        subtitle: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                formattedDateTime
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: amount == 0
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .secondary
                                                        : Colors.grey.shade600,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0,
                                                    letterSpacing: 0.5)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              goalId == "" || goalId == null
                                                  ? ""
                                                  : "- Goal",
                                              style: TextStyle(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .warning,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0,
                                                  letterSpacing: 1),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                        trailing: Container(
                                          width: 100,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              amount == 0
                                                  ? Text("")
                                                  : Text(
                                                      transType == true
                                                          ? "+" +
                                                              '$amount' +
                                                              ' ₹'
                                                          : "-" +
                                                              '$amount' +
                                                              ' ₹',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: transType == true
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .primary
                                                            : Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                              amount == 0
                                                  ? Text("")
                                                  : Visibility(
                                                      visible: transType == true
                                                          ? true
                                                          : false,
                                                      child: Text(
                                                        transType == true
                                                            ? "+" +
                                                                '$getFinInt' +
                                                                ' ₹'
                                                            : '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color:
                                                              transType == true
                                                                  ? Colors.grey
                                                                  : Colors.red,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          if (amount == 0) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateMoneyWidget(
                                                  getMobile: widget.getMobile,
                                                  getDocId: widget.getDocId,
                                                  getExistingTotal:
                                                      widget.getExistingTotal,
                                                  isSavOrCashback: true,
                                                  isUpdatingExistingEntry: true,
                                                  isTransTypeDeposite:
                                                      transType,
                                                  transDocId: docId,
                                                  getUserIndex:
                                                      widget.getUserIndex,
                                                ),
                                              ),
                                            ).then((value) {
                                              //todo:- below code refresh firebase records automatically when come back to same screen

                                              // ref
                                              //     .read(showUserListProvider.notifier)
                                              //     .getUserListDetails(widget.getMobile);
                                            });
                                          }
                                        },
                                      ),
                                    )),
                              );
                            }).toList();

                            String totalSum;
                            totalSum = transactionsForDate
                                .fold(
                                  0.0, // Initial value as a double
                                  (double sum, transaction) =>
                                      sum +
                                      ((transaction!.isDeposit)!
                                          ? (transaction.amount ?? 0)
                                          : -(transaction.amount ?? 0)),
                                )
                                .toStringAsFixed(2);

                            return Container(
                              color: Colors.grey.shade50,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0,
                                        right: 16.0,
                                        top: 15,
                                        bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          date,
                                          style:
                                              GlobalTextStyles.secondaryText1(
                                                  txtSize: 16,
                                                  textColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                  txtWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Saved:",
                                              style: GlobalTextStyles
                                                  .secondaryText1(
                                                      txtSize: 16,
                                                      textColor: Colors.grey,
                                                      txtWeight:
                                                          FontWeight.bold),
                                            ),
                                            Text(
                                              "$totalSum ₹",
                                              style: TextStyle(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Display transaction widgets for the date
                                  ...transactionWidgets,
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isLoading
                  ? isRefresh == true
                      ? Container()
                      : Container(
                          color: Colors.transparent,
                          child: Center(
                              child: CircularProgressIndicator(
                            color: isRefresh == true
                                ? Colors.transparent
                                : FlutterFlowTheme.of(context).primary,
                          )),
                        )
                  : Container()
            ]);
          }),
        ),
      ),
    );
  }

  Future<void> updateAdminDetails(Map<String, dynamic> newData) async {
    QuerySnapshot snapshot = await _collectionReference!.limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      String documentId = snapshot.docs.first.id;
      await _collectionReference!.doc(documentId).update(newData);
    }
  }

  Future<void> updateUserDetails(
      Map<String, dynamic> newData, DocumentSnapshot snapshot) async {
    // QuerySnapshot snapshot = await _collectionReference!.limit(1).get();
    // FirebaseFirestore.instance.collection('adminDetails');
    if (snapshot.id.isNotEmpty) {
      String documentId = snapshot.id;
      await _collectionUsers!
          .doc(documentId)
          .update(newData)
          .then((value) => null);
    }
  }

  //todo:- 28.1.24 update new value about, pending payment in user details as ispending payment is true
  Future<void> updatePaymentPendingRequest(
    String? getDocId,
  ) async {
    String? documentId = getDocId;

    try {
      await firestore.collection('users').doc(documentId).update({
        'isPendingPayment': isPendingPayment ?? false,
      }).then((value) {
        Constants.showToast("Pending Payment Request Updated Successfully",
            ToastGravity.CENTER);
      });
    } catch (error) {
      Constants.showToast(
          "Pending Payment Request Failed, Try again!", ToastGravity.CENTER);
    }
  }

  Future<void> updateMappedAdmin(
      String? getToMapAdmin, String? getDocId) async {
    String? documentId = getDocId;

    try {
      await firestore.collection('users').doc(documentId).update({
        'mappedAdmin': getToMapAdmin ?? "1",
      }).then((value) {
        Constants.showToast("Admin Changed Successfully", ToastGravity.CENTER);
      });
    } catch (error) {
      Constants.showToast(
          "Failed to Change Admin, Try again!", ToastGravity.CENTER);
    }
  }

  Future<void> updateUserType(String? getUserType, String? getDocId) async {
    String? documentId = getDocId;

    try {
      await firestore.collection('users').doc(documentId).update({
        'userType': getUserType ?? "0",
      }).then((value) {
        Constants.showToast(
            "User Type Changed Successfully", ToastGravity.CENTER);
      });
    } catch (error) {
      Constants.showToast(
          "Failed to Change User Type, Try again!", ToastGravity.CENTER);
    }
  }
}
