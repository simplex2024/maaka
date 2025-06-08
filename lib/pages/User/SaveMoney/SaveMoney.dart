//todo:- 17.11.23 - new transaction list implementation
import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:maaakanmoney/pages/User/SaveMoney/PaymentDemo.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;
import 'package:tuple/tuple.dart';

import '../../../components/ListView/ListController.dart';
import '../../../components/ListView/ListPageView.dart';
import '../../../components/NotificationService.dart';
import '../../../components/constants.dart';
import '../../../components/custom_dialog_box.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../phoneController.dart';
import '../../budget_copy/BudgetCopyController.dart';
import '../../budget_copy/budget_copy_widget.dart';
import '../../chatScreen.dart';
import '../UserScreen_Notifer.dart';

class SaveMoney extends ConsumerStatefulWidget {
  SaveMoney({
    Key? key,
    @required this.getMobile,
    @required this.getDocId,
    @required this.getUserName,
    @required this.getGoalDocId,
    @required this.getTransData,
    @required this.getPaymentService,
    @required this.getPayableAmount,
  }) : super(key: key);
  String? getMobile;
  String? getDocId;
  String? getUserName;
  String? getGoalDocId;

  // List<TransactionData>? creditedData;
  // List<TransactionData>? debitedData;
  List<Transactionss>? getTransData;
  PaymentService? getPaymentService;
  String? getPayableAmount;

  @override
  SaveMoneyState createState() => SaveMoneyState();
}

class SaveMoneyState extends ConsumerState<SaveMoney>
    with TickerProviderStateMixin {
  bool? isGooglePaySelected = false;
  bool? isPhonePeSelected = false;
  String? getPayment = "Select";
  String? getUserName = "";
  String? getAdmin = "";
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  bool? isReportCurrentMonth = true;

  List<TransactionData>? creditedData = [];

  List<TransactionData>? debitedData = [];

  // Define a GlobalKey for the TransactionChart widget
  final GlobalKey<_TransactionChartState> _transactionChartKey =
      GlobalKey<_TransactionChartState>();

  @override
  void initState() {
    super.initState();
    getUserName = widget.getUserName ?? "";
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {});

//todo:- initial chart is shown for current month

    if (widget.getTransData != null) {
      createChart(isReportCurrentMonth);
    } else {
      if (creditedData!.isEmpty || creditedData == null) {
        creditedData?.add(
            TransactionData(date: DateTime(2024, 1, 1), amount: 0.1 ?? 0.0));
      }

      if (debitedData!.isEmpty || debitedData == null) {
        debitedData?.add(
            TransactionData(date: DateTime(2024, 1, 1), amount: 0.1 ?? 0.0));
      }
    }

    getAdmin = ref.read(UserDashListProvider.notifier).getAdminType == "1"
        ? "Meena"
        : "Babu";
    getNotificationAccessToken();
  }

  Future<void> getNotificationAccessToken() async {
    final String token =
        await getAccessToken(); // Assume this is your async method to fetch the token
    // setState(() {
    Constants.accessTokenFrNotificn = token; // Store the token in the state
    // });

    // Now the accessToken can be used throughout this class
  }

  Future<String> getAccessToken() async {
    final credentials = await loadServiceAccountCredentials();

    // Extract private key and client details from service account
    final accountCredentials = ServiceAccountCredentials.fromJson(credentials);

    final authClient = await clientViaServiceAccount(
      accountCredentials,
      ['https://www.googleapis.com/auth/firebase.messaging'], // FCM scope
    );

    // Get Access Token
    final token = await authClient.credentials.accessToken;

    print("Access Token: ${token.data}");

    return token.data;
  }

  Future<Map<String, dynamic>> loadServiceAccountCredentials() async {
    String jsonData = await rootBundle
        .loadString('images/maakanmoney-a6874-9f449586b9b5.json');
    return json.decode(jsonData);
  }

  //todo:- 2.3.24 creating chart for user based on user transaction snapshots from db

  //todo:- getting current month transactions

  void createChart(bool? isReportCurrentMonth) {
    List<Transactionss>? getFinalTransactions = [];
    creditedData = [];
    debitedData = [];

    if (isReportCurrentMonth ?? false) {
      getFinalTransactions = widget.getTransData!.where((transaction) {
        // Assuming transaction.date is in 'yyyy-mm-dd' format
        DateTime transactionDate = DateTime.parse(transaction.date ?? "");
        return transactionDate.year == DateTime.now().year &&
            transactionDate.month == DateTime.now().month;
      }).toList();
    } else {
      //todo:- getting last month transactions
      getFinalTransactions = widget.getTransData!.where((transaction) {
        // Assuming transaction.date is in 'yyyy-mm-dd' format
        DateTime transactionDate = DateTime.parse(transaction.date ?? "");

        // Get the first day of the current month
        DateTime firstDayOfCurrentMonth =
            DateTime(DateTime.now().year, DateTime.now().month, 1);

        // Get the first day of the previous month
        DateTime firstDayOfLastMonth = DateTime(
            firstDayOfCurrentMonth.year, firstDayOfCurrentMonth.month - 1, 1);

        // Get the last day of the previous month
        DateTime lastDayOfLastMonth =
            firstDayOfCurrentMonth.subtract(Duration(days: 1));

        // Check if the transaction date is between the first and last day of the previous month
        return transactionDate.isAfter(firstDayOfLastMonth) &&
            transactionDate.isBefore(firstDayOfCurrentMonth);
      }).toList();
    }

    for (int i = 0; i < getFinalTransactions.length; i++) {
      final document = getFinalTransactions?[i];

      final amount = document?.amount;
      final transType = document?.isDeposit;

      final date = document?.date;
      final mobile = document?.mobile;
      final docId = document?.docId;
      final interest = document?.interest;
      final timeStamp = document?.timmeStamp;

      // Replace this with your Timestamp object
      Timestamp timestamp = timeStamp ?? Timestamp(000, 000);
      // Convert Timestamp to DateTime
      DateTime dateTime = timestamp.toDate();

      // Format date and time
      String formattedDateTime = DateFormat('yyyy-MM-dd').format(dateTime);

      print("$transType /$amount / $formattedDateTime ");

      if (i < 30) {
        if (transType == true) {
          creditedData?.add(TransactionData(
              date: dateTime, amount: amount?.toDouble() ?? 0.0));
        } else {
          debitedData?.add(TransactionData(
              date: dateTime, amount: amount?.toDouble() ?? 0.0));
        }
      }
    }

    if (creditedData!.isEmpty || creditedData == null) {
      creditedData?.add(
          TransactionData(date: DateTime(2024, 1, 1), amount: 0.1 ?? 0.0));
    }

    if (debitedData!.isEmpty || debitedData == null) {
      debitedData?.add(
          TransactionData(date: DateTime(2024, 1, 1), amount: 0.1 ?? 0.0));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      ref.read(UserDashListProvider.notifier).data =
          ref.watch(connectivityProvider);

// creditedData = widget.creditedData;
// debitedData = widget.debitedData;

      return Scaffold(
        backgroundColor:  widget.getPaymentService == PaymentService.meatBasket ? Constants.secondary : FlutterFlowTheme.of(context).primary,
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
                title: Text(
                  widget.getPaymentService == PaymentService.meatBasket ? "Payment" : "Save Money",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color:  widget.getPaymentService == PaymentService.meatBasket ? Constants.secondary: Constants.secondary4,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold),
                ),
                backgroundColor: widget.getPaymentService == PaymentService.meatBasket ? Constants.secondary4 : Constants.secondary,
                automaticallyImplyLeading: true,
                toolbarHeight: 8.h,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon:  Icon(Icons.arrow_back_ios_rounded,
                      color:  widget.getPaymentService == PaymentService.meatBasket ? Constants.secondary : Colors.black),
                ),
                centerTitle: true,
                elevation: 0.0,
              )
            : null,
        body: SafeArea(
            child: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Center(
            child: Stack(alignment: Alignment.bottomRight, children: [

              widget.getPaymentService == PaymentService.meatBasket ?

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
color: Constants.secondary4,
                      child: Image.asset(
                        "images/meatbasketlogo.PNG",
                        errorBuilder: (context, exception, stackTrace) {
                          return Image.asset(
                            "images/final/Common/Error.png",
                          );
                        },
                      ),
                    ),

                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8,left: 8.0,right: 8.0,bottom: 8),
                    child: Row(
                      children: [
                        Expanded(

                          child: Text('Amount to be Paid',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Constants.secondary4),),
                        ),
                        Expanded(
                          child: Text( "₹${widget.getPayableAmount}",
                            style:
                            Theme.of(context)
                                .textTheme
                                .headlineLarge,textAlign: TextAlign.end,),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(top:
                      10.0),
                      child: SingleChildScrollView(
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(
                                  0), // Bottom-left corner is rounded
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                buildPaymentRow(
                                  getImage: "gpay",
                                  title: 'Google Pay',
                                  isSelected: isGooglePaySelected ?? false,
                                  onChanged: (value) async {
                                    isGooglePaySelected = true;

                                    //todo:- 2.12.23 adding notification to let admin know payment initiated
                                    String? token = await NotificationService
                                        .getDocumentIDsAndData();
                                    if (token != null) {
                                      Response? response = await NotificationService
                                          .postNotificationRequest(
                                          token,
                                          widget.getPaymentService == PaymentService.meatBasket ? "Hi Admin,\n$getUserName is Trying to Pay for Meat" : "Hi Admin,\n$getUserName is Trying to Save Money",
                                          "Under $getAdmin\nHurry up, let's Check with GPay App.");
                                      // Handle the response as needed
                                    } else {
                                      print("Problem in getting Token");
                                    }

                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context1) {
                                          return CustomDialogBox(
                                            title: "Need Payment Demo?",
                                            descriptions:
                                            "We created an animation to illustrate the payment process.",
                                            text: "Ok",
                                            isNo: true,
                                            isCancel: false,
                                            onNoTap: () async {
                                              final String defaultValue = ref
                                                  .read(
                                                  UserDashListProvider
                                                      .notifier)
                                                  .getAdminType ==
                                                  "1"
                                                  ? Constants.admin1Gpay
                                                  : Constants.admin2Gpay;
                                              Clipboard.setData(ClipboardData(
                                                  text: defaultValue));

                                              //todo:- 26.1.24 adding dummy entry when navigating to gpay

                                              // await addDummyTransaction(
                                              //     widget.getGoalDocId);

                                              var openAppResult =
                                              await LaunchApp.openApp(
                                                openStore: true,
                                                androidPackageName:
                                                'com.google.android.apps.nbu.paisa.user',
                                                // iosUrlScheme: 'pulsesecure://',
                                                // appStoreLink:
                                                //     'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
                                                iosUrlScheme: 'hjfg',
                                                appStoreLink:
                                                'https://apps.apple.com/in/app/google-pay-save-pay-manage/id1193357041',
                                              );
                                              Navigator.pop(context1);
                                            },
                                            onTap: () async {
                                              Navigator.pop(context1);
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  transitionDuration:
                                                  Duration(milliseconds: 400),
                                                  pageBuilder: (_, __, ___) =>
                                                      PaymentDemo(
                                                        isGpaySelected:
                                                        isGooglePaySelected,
                                                        getMobile: widget.getMobile,
                                                        getGoalDocId:
                                                        widget.getGoalDocId,
                                                          getPaymentService: widget.getPaymentService
                                                      ),
                                                  transitionsBuilder:
                                                      (_, animation, __, child) {
                                                    return SlideTransition(
                                                      position: Tween<Offset>(
                                                        begin: Offset(1, 0),
                                                        // You can adjust the start position
                                                        end: Offset
                                                            .zero, // You can adjust the end position
                                                      ).animate(animation),
                                                      child: child,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        });
                                  },
                                ),
                                SizedBox(height: 20),
                                Container(
                                    color:
                                    FlutterFlowTheme.of(context).secondary1,
                                    height: 1,
                                    width: 100.w),
                                SizedBox(height: 20),
                                buildPaymentRow(
                                  getImage: "phonePe",
                                  title: 'PhonePe',
                                  isSelected: isPhonePeSelected ?? false,
                                  onChanged: (value) async {
                                    isGooglePaySelected = false;

                                    //todo:- 2.12.23 adding notification to let admin know payment initiated
                                    String? token = await NotificationService
                                        .getDocumentIDsAndData();
                                    if (token != null) {
                                      Response? response = await NotificationService
                                          .postNotificationRequest(
                                          token,
                                          widget.getPaymentService == PaymentService.meatBasket ? "Hi Admin,\n$getUserName is Trying to Pay for Meat" :"Hi Admin,\n$getUserName is Trying to Save Money",
                                          "Under $getAdmin\nHurry up, let's Check with PhonePe App.");
                                      // Handle the response as needed
                                    } else {
                                      print("Problem in getting Token");
                                    }

                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context1) {
                                          return CustomDialogBox(
                                            title: "Need Payment Demo?",
                                            descriptions:
                                            "We created an animation to illustrate the payment process.",
                                            text: "Ok",
                                            isNo: true,
                                            isCancel: false,
                                            onNoTap: () async {
                                              final String defaultValue = ref
                                                  .read(
                                                  UserDashListProvider
                                                      .notifier)
                                                  .getAdminType ==
                                                  "1"
                                                  ? Constants.admin1Gpay
                                                  : Constants.admin2Gpay;
                                              Clipboard.setData(ClipboardData(
                                                  text: defaultValue));

                                              // await addDummyTransaction(
                                              //     widget.getGoalDocId);

                                              var openAppResult =
                                              await LaunchApp.openApp(
                                                openStore: true,
                                                androidPackageName:
                                                'com.phonepe.app',
                                                iosUrlScheme: 'sf',
                                                appStoreLink:
                                                'https://apps.apple.com/in/app/phonepe-secure-payments-app/id1170055821',
                                              );

                                              Navigator.pop(context1);
                                            },
                                            onTap: () async {
                                              Navigator.pop(context1);
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  transitionDuration:
                                                  Duration(milliseconds: 400),
                                                  pageBuilder: (_, __, ___) =>
                                                      PaymentDemo(
                                                        isGpaySelected:
                                                        isGooglePaySelected,
                                                        getMobile: widget.getMobile,
                                                        getGoalDocId:
                                                        widget.getGoalDocId,
                                                      ),
                                                  transitionsBuilder:
                                                      (_, animation, __, child) {
                                                    return SlideTransition(
                                                      position: Tween<Offset>(
                                                        begin: Offset(1, 0),
                                                        // You can adjust the start position
                                                        end: Offset
                                                            .zero, // You can adjust the end position
                                                      ).animate(animation),
                                                      child: child,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        });
                                  },
                                ),
                                SizedBox(height: 20),
                                Container(
                                    color:
                                    FlutterFlowTheme.of(context).secondary1,
                                    height: 1,
                                    width: 100.w),
                                SizedBox(height: 20),
                                buildPaymentRow(
                                  getImage: "Paytm",
                                  title: 'Paytm',
                                  isSelected: isPhonePeSelected ?? false,
                                  onChanged: (value) async {
                                    //todo:- 2.12.23 , coping mapped admin mobile no

                                    final String defaultValue = ref
                                        .read(
                                        UserDashListProvider.notifier)
                                        .getAdminType ==
                                        "1"
                                        ? Constants.admin1Gpay
                                        : Constants.admin2Gpay;

                                    Clipboard.setData(
                                        ClipboardData(text: defaultValue));

                                    //todo:- 2.12.23 adding notification to let admin know payment initiated
                                    String? token = await NotificationService
                                        .getDocumentIDsAndData();
                                    if (token != null) {
                                      Response? response = await NotificationService
                                          .postNotificationRequest(
                                          token,
                                          widget.getPaymentService == PaymentService.meatBasket ? "Hi Admin,\n$getUserName is Trying to Pay for Meat" :"Hi Admin,\n$getUserName is Trying to Save Money",
                                          "Under $getAdmin\nHurry up, let's Check with Paytm App.");
                                      // Handle the response as needed
                                    } else {
                                      print("Problem in getting Token");
                                    }

                                    // await addDummyTransaction(
                                    //     widget.getGoalDocId);

                                    var openAppResult = await LaunchApp.openApp(
                                      openStore: true,
                                      androidPackageName: 'net.one97.paytm',
                                      iosUrlScheme: 'paytm',
                                      appStoreLink:
                                      'https://apps.apple.com/in/app/paytm-kyc-wallet-recharge/id473941634',
                                    );
                                  },
                                ),
                                SizedBox(height: 20),






                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ) :

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                              0), // Bottom-left corner is rounded
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, right: 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  isReportCurrentMonth!
                                      ? "Current Month Report"
                                      : "Last Month Report",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: Constants.primary),
                                ),
                              ),
                            ),

                            // Add more Positioned widgets for additional images
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        child: TransactionChart(
                          key: _transactionChartKey,
                          creditedData: creditedData ?? [],
                          debitedData: debitedData ?? [],
                          rewards: [
                            TransactionData(
                                date: DateTime(2024, 1, 1), amount: 0.5),
                            TransactionData(
                                date: DateTime(2024, 1, 3), amount: 0.30),
                            TransactionData(
                                date: DateTime(2024, 1, 5), amount: 0.70),
                            TransactionData(
                                date: DateTime(2024, 1, 4), amount: 0.58),
                          ],
                          chartType: ChartType.StackedArea,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (widget.getTransData != null) {
                            isReportCurrentMonth = !isReportCurrentMonth!;
                            createChart(isReportCurrentMonth);
                          } else {
                            if (creditedData!.isEmpty || creditedData == null) {
                              creditedData?.add(TransactionData(
                                  date: DateTime(2024, 1, 1),
                                  amount: 0.1 ?? 0.0));
                            }

                            if (debitedData!.isEmpty || debitedData == null) {
                              debitedData?.add(TransactionData(
                                  date: DateTime(2024, 1, 1),
                                  amount: 0.1 ?? 0.0));
                            }

                            isReportCurrentMonth = !isReportCurrentMonth!;
                            createChart(isReportCurrentMonth);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            5.0, 5.0, 5.0, 5.0),
                        child: TextFormField(
                          enabled: false,
                          keyboardType: TextInputType.none,
                          controller:
                              ref.read(ListProvider.notifier).txtSavingsReport,
                          focusNode: ref
                              .read(ListProvider.notifier)
                              .focusSavingsReport,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                            labelText: isReportCurrentMonth!
                                ? "Switch to Last Month Report"
                                : "Switch to Current Month Report",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).primary,
                            suffixIcon: Icon(
                              Icons.change_circle,
                              color: Colors.white,
                            ),
                          ),
                          style: GlobalTextStyles.secondaryText2(),
                          // validator: _validateGoalPriority,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                                0), // Bottom-left corner is rounded
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              buildPaymentRow(
                                getImage: "gpay",
                                title: 'Google Pay',
                                isSelected: isGooglePaySelected ?? false,
                                onChanged: (value) async {
                                  isGooglePaySelected = true;

                                  //todo:- 2.12.23 adding notification to let admin know payment initiated
                                  String? token = await NotificationService
                                      .getDocumentIDsAndData();
                                  if (token != null) {
                                    Response? response = await NotificationService
                                        .postNotificationRequest(
                                            token,
                                            "Hi Admin,\n$getUserName is Trying to Save Money",
                                            "Under $getAdmin\nHurry up, let's Check with GPay App.");
                                    // Handle the response as needed
                                  } else {
                                    print("Problem in getting Token");
                                  }

                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context1) {
                                        return CustomDialogBox(
                                          title: "Need Payment Demo?",
                                          descriptions:
                                              "We created an animation to illustrate the payment process.",
                                          text: "Ok",
                                          isNo: true,
                                          isCancel: false,
                                          onNoTap: () async {
                                            final String defaultValue = ref
                                                        .read(
                                                            UserDashListProvider
                                                                .notifier)
                                                        .getAdminType ==
                                                    "1"
                                                ? Constants.admin1Gpay
                                                : Constants.admin2Gpay;
                                            Clipboard.setData(ClipboardData(
                                                text: defaultValue));

                                            //todo:- 26.1.24 adding dummy entry when navigating to gpay

                                            await addDummyTransaction(
                                                widget.getGoalDocId);

                                            var openAppResult =
                                                await LaunchApp.openApp(
                                              openStore: true,
                                              androidPackageName:
                                                  'com.google.android.apps.nbu.paisa.user',
                                              // iosUrlScheme: 'pulsesecure://',
                                              // appStoreLink:
                                              //     'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
                                              iosUrlScheme: 'hjfg',
                                              appStoreLink:
                                                  'https://apps.apple.com/in/app/google-pay-save-pay-manage/id1193357041',
                                            );
                                            Navigator.pop(context1);
                                          },
                                          onTap: () async {
                                            Navigator.pop(context1);
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                transitionDuration:
                                                    Duration(milliseconds: 400),
                                                pageBuilder: (_, __, ___) =>
                                                    PaymentDemo(
                                                  isGpaySelected:
                                                      isGooglePaySelected,
                                                  getMobile: widget.getMobile,
                                                  getGoalDocId:
                                                      widget.getGoalDocId,
                                                ),
                                                transitionsBuilder:
                                                    (_, animation, __, child) {
                                                  return SlideTransition(
                                                    position: Tween<Offset>(
                                                      begin: Offset(1, 0),
                                                      // You can adjust the start position
                                                      end: Offset
                                                          .zero, // You can adjust the end position
                                                    ).animate(animation),
                                                    child: child,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      });
                                },
                              ),
                              SizedBox(height: 20),
                              Container(
                                  color:
                                      FlutterFlowTheme.of(context).secondary1,
                                  height: 1,
                                  width: 100.w),
                              SizedBox(height: 20),
                              buildPaymentRow(
                                getImage: "phonePe",
                                title: 'PhonePe',
                                isSelected: isPhonePeSelected ?? false,
                                onChanged: (value) async {
                                  isGooglePaySelected = false;

                                  //todo:- 2.12.23 adding notification to let admin know payment initiated
                                  String? token = await NotificationService
                                      .getDocumentIDsAndData();
                                  if (token != null) {
                                    Response? response = await NotificationService
                                        .postNotificationRequest(
                                            token,
                                            "Hi Admin,\n$getUserName is Trying to Save Money",
                                            "Under $getAdmin\nHurry up, let's Check with PhonePe App.");
                                    // Handle the response as needed
                                  } else {
                                    print("Problem in getting Token");
                                  }

                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context1) {
                                        return CustomDialogBox(
                                          title: "Need Payment Demo?",
                                          descriptions:
                                              "We created an animation to illustrate the payment process.",
                                          text: "Ok",
                                          isNo: true,
                                          isCancel: false,
                                          onNoTap: () async {
                                            final String defaultValue = ref
                                                        .read(
                                                            UserDashListProvider
                                                                .notifier)
                                                        .getAdminType ==
                                                    "1"
                                                ? Constants.admin1Gpay
                                                : Constants.admin2Gpay;
                                            Clipboard.setData(ClipboardData(
                                                text: defaultValue));

                                            await addDummyTransaction(
                                                widget.getGoalDocId);

                                            var openAppResult =
                                                await LaunchApp.openApp(
                                              openStore: true,
                                              androidPackageName:
                                                  'com.phonepe.app',
                                              iosUrlScheme: 'sf',
                                              appStoreLink:
                                                  'https://apps.apple.com/in/app/phonepe-secure-payments-app/id1170055821',
                                            );

                                            Navigator.pop(context1);
                                          },
                                          onTap: () async {
                                            Navigator.pop(context1);
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                transitionDuration:
                                                    Duration(milliseconds: 400),
                                                pageBuilder: (_, __, ___) =>
                                                    PaymentDemo(
                                                  isGpaySelected:
                                                      isGooglePaySelected,
                                                  getMobile: widget.getMobile,
                                                  getGoalDocId:
                                                      widget.getGoalDocId,
                                                ),
                                                transitionsBuilder:
                                                    (_, animation, __, child) {
                                                  return SlideTransition(
                                                    position: Tween<Offset>(
                                                      begin: Offset(1, 0),
                                                      // You can adjust the start position
                                                      end: Offset
                                                          .zero, // You can adjust the end position
                                                    ).animate(animation),
                                                    child: child,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      });
                                },
                              ),
                              SizedBox(height: 20),
                              Container(
                                  color:
                                      FlutterFlowTheme.of(context).secondary1,
                                  height: 1,
                                  width: 100.w),
                              SizedBox(height: 20),
                              buildPaymentRow(
                                getImage: "Paytm",
                                title: 'Paytm',
                                isSelected: isPhonePeSelected ?? false,
                                onChanged: (value) async {
                                  //todo:- 2.12.23 , coping mapped admin mobile no

                                  final String defaultValue = ref
                                              .read(
                                                  UserDashListProvider.notifier)
                                              .getAdminType ==
                                          "1"
                                      ? Constants.admin1Gpay
                                      : Constants.admin2Gpay;

                                  Clipboard.setData(
                                      ClipboardData(text: defaultValue));

                                  //todo:- 2.12.23 adding notification to let admin know payment initiated
                                  String? token = await NotificationService
                                      .getDocumentIDsAndData();
                                  if (token != null) {
                                    Response? response = await NotificationService
                                        .postNotificationRequest(
                                            token,
                                            "Hi Admin,\n$getUserName is Trying to Save Money",
                                            "Under $getAdmin\nHurry up, let's Check with Paytm App.");
                                    // Handle the response as needed
                                  } else {
                                    print("Problem in getting Token");
                                  }

                                  await addDummyTransaction(
                                      widget.getGoalDocId);

                                  var openAppResult = await LaunchApp.openApp(
                                    openStore: true,
                                    androidPackageName: 'net.one97.paytm',
                                    iosUrlScheme: 'paytm',
                                    appStoreLink:
                                        'https://apps.apple.com/in/app/paytm-kyc-wallet-recharge/id473941634',
                                  );
                                },
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        )),
      );
    });
  }

//todo:- 19.11.23 - creating column row for payment mode design

  Widget buildPaymentRow({
    required String getImage,
    required String title,
    required bool isSelected,
    required Function(bool?) onChanged,
    // Function()? onTap;
  }) {
    return InkWell(
      onTap: () {
        onChanged(!isSelected);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              child: Image.asset(
                "images/final/Dashboard/SaveMoney/$getImage.png",
                errorBuilder: (context, exception, stackTrace) {
                  return Image.asset(
                    "images/final/Common/Error.png",
                  );
                },
              ),
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Constants.primary),
            ),
            Spacer(),
            RoundCheckbox(
              value: isSelected,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addDummyTransaction(String? goalId) async {
    int amount = int.parse("0");

    try {
      // Simulating some asynchronous operation
      // await Future.delayed(Duration(seconds: 2));

      Timestamp timestamp = Timestamp.fromDate(DateTime.now());

      try {
        //todo:- adding transaction inside user's table
        fireStore
            .collection('users')
            .doc(ref.read(UserDashListProvider.notifier).getDocId)
            .collection('transaction')
            .add({
          'mobile': widget.getMobile,
          'isDeposit': true,
          'isCashbckDeposit': true,
          'amount': amount,
          'interest': 0.0,
          'date': DateFormat('yyyy-MM-dd')
              .format(DateTime.now()), // Only date in 'yyyy-MM-dd' format
          // 'timestamp': DateTime.now(),
          'timestamp': timestamp,
          'goalId': goalId,
        }).then((_) async {
          //todo:- 28.1.24 - when user tries to goes to payment method, in user details, pending payment flag is updated
          await updatePaymentPendingRequest(
            ref.read(UserDashListProvider.notifier).getDocId,
          );

          Constants.showToast(
              "Your Payment is under Processing", ToastGravity.BOTTOM);
        }).catchError((error) {
          print('$error');
        });
      } catch (error) {
        print('Error retrieving user details: $error');
      }
    } catch (error) {
      print(error);
    } finally {
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  //todo:- 28.1.24 update new value about, pending payment in user details as ispending payment is true
  Future<void> updatePaymentPendingRequest(
    String? getDocId,
  ) async {
    String? documentId = getDocId;

    try {
      await fireStore.collection('users').doc(documentId).update({
        'isPendingPayment': true,
      }).then((value) {
        Constants.showToast("Pending Payment Request Updated Successfully",
            ToastGravity.CENTER);
      });
    } catch (error) {
      Constants.showToast(
          "Pending Payment Request Failed, Try again!", ToastGravity.CENTER);
    }
  }

  SliverPersistentHeader makeTitleHeader(String headerText, bool isViewAll) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 50.0,
        maxHeight: 70.0,
        child: Container(
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    headerText,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Visibility(
                    visible: isViewAll,
                    child: InkWell(
                      onTap: () {
                        print("View all tapped!");
                      },
                      child: Text(
                        "View All",
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).secondary2,
                              letterSpacing: 0.5,
                              fontSize: 16,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double? minHeight;
  final double? maxHeight;
  final Widget? child;

  @override
  double get minExtent => minHeight!;

  @override
  double get maxExtent => math.max(maxHeight!, minHeight!);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class RoundCheckbox extends StatelessWidget {
  final bool? value;
  final Function(bool) onChanged;

  const RoundCheckbox({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value!);
      },
      child: Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(
          color:
              value! ? FlutterFlowTheme.of(context).secondary1 : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
              width: 2.0,
              color: value!
                  ? FlutterFlowTheme.of(context).secondary
                  : Colors.grey),
        ),
        child: Center(
          child: value!
              ? Icon(
                  Icons.check,
                  size: 18.0,
                  color: value!
                      ? FlutterFlowTheme.of(context).secondary
                      : Colors.black,
                )
              : null,
        ),
      ),
    );
  }
}

//todo:- 23.2.24 showing user with graph
enum ChartType { Bar, StackedArea, Line, Pie }

class TransactionData {
  final DateTime date;
  final double amount;

  TransactionData({required this.date, required this.amount});
}

class TransactionChart extends StatefulWidget {
  final List<TransactionData>
      creditedData; // List of credited amounts over time
  final List<TransactionData> debitedData; // List of debited amounts over ti
  final List<TransactionData> rewards; // list of rewards
  final ChartType chartType;

  TransactionChart({
    required this.creditedData,
    required this.debitedData,
    required this.rewards,
    this.chartType = ChartType.Bar,
    Key? key,
  }) : super(key: key);

  static _TransactionChartState? of(BuildContext context) =>
      context.findAncestorStateOfType<_TransactionChartState>();

  @override
  _TransactionChartState createState() => _TransactionChartState();
}

class _TransactionChartState extends State<TransactionChart> {
  @override
  Widget build(BuildContext context) {
    if (widget.creditedData.isEmpty ||
        widget.debitedData.isEmpty ||
        widget.rewards.isEmpty) {
      return Container();
    }

    List<TransactionData> sortedCreditedData = List.of(widget.creditedData)
      ..sort((a, b) => a.date.compareTo(b.date));

    List<TransactionData> sortedDebitedData = List.of(widget.debitedData)
      ..sort((a, b) => a.date.compareTo(b.date));

    List<TransactionData> sortedRewardsData = List.of(widget.rewards)
      ..sort((a, b) => a.date.compareTo(b.date));

    List<double>? getFinalCreditedData = [];
    List<double>? getFinalDebitedData = [];
    List<double>? getFinalRewardsData = [];

    for (int i = 0; i < sortedCreditedData.length; i++) {
      getFinalCreditedData!.add(sortedCreditedData[i].amount);
    }

    for (int i = 0; i < sortedDebitedData.length; i++) {
      getFinalDebitedData!.add(sortedDebitedData[i].amount);
    }

    for (int i = 0; i < sortedRewardsData.length; i++) {
      getFinalRewardsData!.add(sortedRewardsData[i].amount);
    }

    return Container(
      // Adjust width as needed
      height: 300,
      width: 300,
      child: Center(
        child: getFinalCreditedData?.length == 1 &&
                getFinalDebitedData?.length == 1
            ? Text(
                "No Transaction Available",
                style: GlobalTextStyles.secondaryText1(
                    textColor: FlutterFlowTheme.of(context).primary,
                    txtWeight: FontWeight.w700),
              )
            : PieChart(
                _buildPieChartData(getFinalCreditedData, getFinalDebitedData,
                    getFinalRewardsData),
              ),
      ),
      color: Colors.transparent,
    );
  }
}

PieChartData _buildPieChartData(List<double>? sorterCreditedData,
    List<double>? sorterDebitedData, List<double>? sorterRewardsData) {
  if (sorterCreditedData?.length == 1) {
    return PieChartData(
      sections: [
        PieChartSectionData(
          value: sorterDebitedData?.reduce((value, element) => value + element),
          color: Colors.black,
          title: 'Debited',
          radius: 110,
        ),
      ],
      borderData: FlBorderData(show: false),
      sectionsSpace: 0,
      centerSpaceRadius: 40,
    );
  } else if (sorterDebitedData?.length == 1) {
    return PieChartData(
      sections: [
        PieChartSectionData(
          value:
              sorterCreditedData?.reduce((value, element) => value + element),
          color: Colors.blue,
          title: 'Credited',
          radius: 100,
        ),
      ],
      borderData: FlBorderData(show: false),
      sectionsSpace: 0,
      centerSpaceRadius: 40,
    );
  } else {
    return PieChartData(
      sections: [
        PieChartSectionData(
          value:
              sorterCreditedData?.reduce((value, element) => value + element),
          color: Colors.blue,
          title: 'Credited',
          radius: 100,
        ),
        PieChartSectionData(
          value: sorterDebitedData?.reduce((value, element) => value + element),
          color: Colors.black,
          title: 'Debited',
          radius: 110,
        ),
      ],
      borderData: FlBorderData(show: false),
      sectionsSpace: 0,
      centerSpaceRadius: 40,
    );
  }
}
