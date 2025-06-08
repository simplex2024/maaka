import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:sizer/sizer.dart';

import '../../../components/NotificationService.dart';
import '../../../components/constants.dart';
import '../../../components/custom_dialog_box.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../phoneController.dart';
import '../../budget_copy/budget_copy_widget.dart';
import '../UserScreen_Notifer.dart';

class RequestMoney extends ConsumerStatefulWidget {
  RequestMoney(
      {Key? key,
      @required this.getMobile,
      @required this.getDocId,
      @required this.isSavingReq,
      @required this.getUserName,
      @required this.getReqAmnt,
      @required this.getGoalTargetAmnt,
      @required this.getGoalDocId,
      @required this.goalAmount})
      : super(key: key);
  String? getMobile;
  String? getDocId;
  bool? isSavingReq;
  String? getUserName;
  String? getReqAmnt;
  String? getGoalDocId;
  String? getGoalTargetAmnt;
  double? goalAmount;

  @override
  RequestMoneyState createState() => RequestMoneyState();
}

class RequestMoneyState extends ConsumerState<RequestMoney>
    with TickerProviderStateMixin {
  final txtReqAmount = TextEditingController();
  String? getUserName = "";
  String? getAdmin = "";
  double totalGoalSavedAmount = 0.0;

  @override
  void initState() {
    super.initState();
    txtReqAmount.text = widget.getReqAmnt ?? "";
    getUserName = widget.getUserName ?? "";
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(UserDashListProvider.notifier).getUserDetails(widget.getMobile,"",false);
    });

    totalGoalSavedAmount = widget.goalAmount ?? 0.0;

    print(totalGoalSavedAmount);


    getAdmin = ref
        .read(
        UserDashListProvider
            .notifier)
        .getAdminType ==
        "1" ? "Meena" : "Babu" ;
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


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer(builder: (context, ref, child) {
        ref.read(UserDashListProvider.notifier).data =
            ref.watch(connectivityProvider);

        return Scaffold(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          appBar: responsiveVisibility(
            context: context,
            tabletLandscape: false,
            desktop: false,
          )
              ? AppBar(
                  title: Text(
                    widget.isSavingReq!
                        ? "Request Savings"
                        : "Request Cashback",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: Constants.secondary2,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: FlutterFlowTheme.of(context).primary,
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
          body: SafeArea(
              child: Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: Consumer(builder: (context, ref, child) {
              bool? getPaidStatus = ref.watch(txtPaidStatus);
              bool? getCashbckPaidStatus = ref.watch(txtCashbckPaidStatus);

              //todo:- 17.3.24 , finding final withdrawal balance
              double? getUserSavedAmount =
                  ref.read(UserDashListProvider.notifier).getNetbalance ?? 0.0;
              double? getUserGoalAchieved = widget.goalAmount ?? 0.0;

              double? getFinalWithdrawalBal =
                  getUserSavedAmount - getUserGoalAchieved;

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, bottom: 0.5),
                                  child: Material(
                                    elevation: 8.0,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(50),
                                      bottomRight: Radius.circular(0),
                                    ),
                                    child: Container(
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(0),
                                          bottomRight: Radius.circular(0),
                                        ),
                                      ),
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Stack(children: [
                                          Positioned.fill(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, top: 5),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Stack(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    children: [
                                                      widget.isSavingReq!
                                                          ? Visibility(
                                                              visible: ref
                                                                          .read(
                                                                              UserDashListProvider.notifier)
                                                                          .getLastReqAmount! !=
                                                                      0
                                                                  ? true
                                                                  : false,
                                                              child: ref
                                                                          .read(
                                                                              UserDashListProvider.notifier)
                                                                          .getLastReqAmount! !=
                                                                      0
                                                                  ? Container(
                                                                      height:
                                                                          9.h,
                                                                      width:
                                                                          100.w,
                                                                      color: Colors
                                                                          .transparent,
                                                                      child:
                                                                          SingleChildScrollView(
                                                                            child: Column(
                                                                                                                                                    crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                                                                                                    children: [
                                                                            Text(
                                                                              "₹${ref.read(UserDashListProvider.notifier).getLastReqAmount!.toStringAsFixed(1)}",
                                                                              style:
                                                                              Theme.of(context)
                                                                                  .textTheme
                                                                                  .headlineLarge?.copyWith(color: Constants.secondary),
                                                                              textAlign:
                                                                                  TextAlign.start,
                                                                              overflow:
                                                                                  TextOverflow.ellipsis,
                                                                            ),
                                                                            Text(
                                                                              // ref.read(UserDashListProvider.notifier).getIsMoneyReq!
                                                                              ref.read(txtMoneyReqCanStatus.notifier).state == true
                                                                                  ? "Is your last Request and is Cancelled by you"
                                                                                  : getPaidStatus!
                                                                                      ? "Is your last Request and is UnPaid"
                                                                                      : "Is your last Request and is Paid",
                                                                              textAlign:
                                                                                  TextAlign.start,
                                                                              style:
                                                                                  GlobalTextStyles.secondaryText1(textColor: FlutterFlowTheme.of(context).secondary1),
                                                                              
                                                                            )
                                                                                                                                                    ],
                                                                                                                                                  ),
                                                                          ),
                                                                    )
                                                                  : Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              4,
                                                                          child:
                                                                              Text(
                                                                            "No Money Request is Raised!",
                                                                            style: TextStyle(
                                                                                color: FlutterFlowTheme.of(context).secondary,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 14.0,
                                                                                letterSpacing: 1),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                            )
                                                          : Visibility(
                                                              visible: ref
                                                                          .read(
                                                                              UserDashListProvider.notifier)
                                                                          .getLastCashbckReqAmount! !=
                                                                      0
                                                                  ? true
                                                                  : false,
                                                              child: ref
                                                                          .read(
                                                                              UserDashListProvider.notifier)
                                                                          .getLastCashbckReqAmount! !=
                                                                      0
                                                                  ? Container(
                                                                      height:
                                                                          7.h,
                                                                      width:
                                                                          90.w,
                                                                      color: Colors
                                                                          .transparent,
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "₹${ref.read(UserDashListProvider.notifier).getLastCashbckReqAmount!.toStringAsFixed(2)}",
                                                                            style: TextStyle(
                                                                                color: FlutterFlowTheme.of(context).secondary,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 22.0,
                                                                                letterSpacing: 1),
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                          Text(
                                                                            // ref.read(UserDashListProvider.notifier).getIsMoneyReq!
                                                                            ref.read(txtCashbckReqCanStatus.notifier).state == true
                                                                                ? "Is your last Request and is Cancelled by you"
                                                                                : getCashbckPaidStatus!
                                                                                    ? "Is your last Request and is UnPaid"
                                                                                    : "Is your last Request and is Paid",
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontFamily: 'Outfit',
                                                                                  color: FlutterFlowTheme.of(context).secondary2,
                                                                                  letterSpacing: 0.5,
                                                                                ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              4,
                                                                          child:
                                                                              Text(
                                                                            "No Money Request is Raised!",
                                                                            style: TextStyle(
                                                                                color: FlutterFlowTheme.of(context).secondary,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 14.0,
                                                                                letterSpacing: 1),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                            ),
                                                      widget.isSavingReq!
                                                          ? ref
                                                                      .read(UserDashListProvider
                                                                          .notifier)
                                                                      .getLastReqAmount! !=
                                                                  0
                                                              ? Container()
                                                              : Text(
                                                                  "No Money Request Yet!",
                                                                  style: GlobalTextStyles.secondaryText1(
                                                                      txtWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      textColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .secondary1),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                )
                                                          : ref
                                                                      .read(UserDashListProvider
                                                                          .notifier)
                                                                      .getLastCashbckReqAmount! !=
                                                                  0
                                                              ? Container()
                                                              : Text(
                                                                  "No Cashback Request Yet!",
                                                                  style: GlobalTextStyles.secondaryText1(
                                                                      txtWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      textColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .secondary1),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                    ]),
                                              ),
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10, bottom: 10),
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: SizedBox(
                                                  width: 40.w,
                                                  height: 4.h,
                                                  child: widget.isSavingReq!
                                                      ? Visibility(
                                                          visible: ref
                                                                      .read(UserDashListProvider
                                                                          .notifier)
                                                                      .getLastReqAmount! !=
                                                                  0
                                                              ? getPaidStatus!
                                                                  ? true
                                                                  : false
                                                              : false,
                                                          child: FFButtonWidget(
                                                            onPressed:
                                                                () async {
                                                              showDialog(
                                                                  barrierDismissible:
                                                                      false,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return CustomDialogBox(
                                                                      title:
                                                                          "Message!",
                                                                      descriptions:
                                                                          "Are you sure, Do you want to Cancel Money Request",
                                                                      text:
                                                                          "Ok",
                                                                      isNo:
                                                                          false,
                                                                      isCancel:
                                                                          true,
                                                                      onTap:
                                                                          () async {
                                                                        await ref.read(UserDashListProvider.notifier).canclRequest(
                                                                            ref.read(UserDashListProvider.notifier).getDocId,
                                                                            true,
                                                                            widget.getMobile);

//todo:- publishing notification when user requesting money
                                                                        String?
                                                                            token =
                                                                            await NotificationService.getDocumentIDsAndData();
                                                                        if (token !=
                                                                            null) {
                                                                          Response? response = await NotificationService.postNotificationRequest(
                                                                              token,
                                                                              widget.isSavingReq! ? "Hi Admin,\n$getUserName is Cancelled Money Request" : "Hi Admin,\n$getUserName is Cancelled Cashback Request",
                                                                              "Under $getAdmin\nHurry up, let's Check Maaka App.");
                                                                          // Handle the response as needed
                                                                        } else {
                                                                          print(
                                                                              "Problem in getting Token");
                                                                        }

                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    );
                                                                  });
                                                            },
                                                            text:
                                                                "Cancel Request",
                                                            options:
                                                                FFButtonOptions(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                              iconPadding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary1,
                                                              textStyle: GlobalTextStyles.secondaryText2(
                                                                  txtWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  txtSize: 16,
                                                                  textColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary),
                                                              elevation: 1.0,
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                          ),
                                                        )
                                                      : Visibility(
                                                          visible: ref
                                                                      .read(UserDashListProvider
                                                                          .notifier)
                                                                      .getLastCashbckReqAmount! !=
                                                                  0
                                                              ? getCashbckPaidStatus!
                                                                  ? true
                                                                  : false
                                                              : false,
                                                          child: FFButtonWidget(
                                                            onPressed:
                                                                () async {
                                                              showDialog(
                                                                  barrierDismissible:
                                                                      false,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return CustomDialogBox(
                                                                      title:
                                                                          "Message!",
                                                                      descriptions:
                                                                          "Are you sure, Do you want to Cancel Money Request",
                                                                      text:
                                                                          "Ok",
                                                                      isNo:
                                                                          false,
                                                                      isCancel:
                                                                          true,
                                                                      onTap:
                                                                          () async {
                                                                        await ref.read(UserDashListProvider.notifier).canclRequest(
                                                                            ref.read(UserDashListProvider.notifier).getDocId,
                                                                            false,
                                                                            widget.getMobile);

                                                                        //todo:- publishing notification when user requesting money
                                                                        String?
                                                                            token =
                                                                            await NotificationService.getDocumentIDsAndData();
                                                                        if (token !=
                                                                            null) {
                                                                          Response? response = await NotificationService.postNotificationRequest(
                                                                              token,
                                                                              widget.isSavingReq! ? "Hi Admin,\n$getUserName is Cancelled Money Request" : "Hi Admin,\n$getUserName is Cancelled Cashback Request",
                                                                              "Under $getAdmin\nHurry up, let's Check Maaka App.");
                                                                          // Handle the response as needed
                                                                        } else {
                                                                          print(
                                                                              "Problem in getting Token");
                                                                        }

                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    );
                                                                  });
                                                            },
                                                            text:
                                                                "Cancel Request",
                                                            options:
                                                                FFButtonOptions(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                              iconPadding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary1,
                                                              textStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Outfit',
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                              elevation: 1.0,
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.isSavingReq ?? false,
                      child: widget.getReqAmnt!.isEmpty
                          ? Expanded(
                              flex: 3,
                              child: Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(
                                              0), // Bottom-left corner is rounded
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Saved Amount: ',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: GlobalTextStyles
                                                              .secondaryText1(
                                                                  textColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary),
                                                        ),
                                                        Text(
                                                          ref
                                                              .read(
                                                                  UserDashListProvider
                                                                      .notifier)
                                                              .getNetbalance
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: GlobalTextStyles
                                                              .secondaryText1(
                                                                  textColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Saved Against Goals: ',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: GlobalTextStyles
                                                              .secondaryText1(
                                                                  textColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary),
                                                        ),
                                                        Consumer(builder:
                                                            (context, ref,
                                                                child) {
                                                          double getGoalBals =
                                                              ref.watch(
                                                                  getUserGoalBal);

                                                          return Text(
                                                              '₹' +
                                                                  widget
                                                                      .goalAmount
                                                                      .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: GlobalTextStyles
                                                                  .secondaryText1(
                                                                      textColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .secondary));
                                                        }),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Withdrawal Amount: ',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: GlobalTextStyles
                                                              .secondaryText1(
                                                                  textColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary),
                                                        ),
                                                        Text(
                                                          getFinalWithdrawalBal
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: GlobalTextStyles
                                                              .secondaryText1(
                                                                  textColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      widget.goalAmount != 0
                                                          ? "Note:- Try Withdraw Amount on Tapping Goals"
                                                          : "",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: GlobalTextStyles
                                                          .secondaryText1(
                                                              textColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                              txtSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // Add more Positioned widgets for additional images
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            )
                          : Expanded(
                              flex: 3,
                              child: Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(
                                              0), // Bottom-left corner is rounded
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Goal Target: ',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: GlobalTextStyles
                                                              .secondaryText1(
                                                                  textColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary),
                                                        ),
                                                        Text(
                                                          widget
                                                              .getGoalTargetAmnt
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: GlobalTextStyles
                                                              .secondaryText1(
                                                                  textColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Goal Achieved: ',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: GlobalTextStyles
                                                              .secondaryText1(
                                                                  textColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary),
                                                        ),
                                                        Consumer(builder:
                                                            (context, ref,
                                                                child) {
                                                          double getGoalBals =
                                                              ref.watch(
                                                                  getUserGoalBal);

                                                          return Text(
                                                              '₹' +
                                                                  widget
                                                                      .getReqAmnt
                                                                      .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: GlobalTextStyles
                                                                  .secondaryText1(
                                                                      textColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .secondary));
                                                        }),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Withdrawal Amount: ',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: GlobalTextStyles
                                                              .secondaryText1(
                                                                  textColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary),
                                                        ),
                                                        Text(
                                                          '₹' +
                                                              widget.getReqAmnt
                                                                  .toString(),
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: GlobalTextStyles
                                                              .secondaryText1(
                                                                  textColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // Add more Positioned widgets for additional images
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondary,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(
                                  0), // Bottom-left corner is rounded
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 0, bottom: 0),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                          // Add your desired height to the container
                                          height: 250,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  controller: txtReqAmount,
                                                  keyboardType: TextInputType
                                                      .numberWithOptions(
                                                          decimal: false),
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        'Withdrawal Amount',
                                                    border:
                                                        OutlineInputBorder(),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary1,
                                                      ),
                                                    ),
                                                  ),

                                                ),
                                              ),
                                            ],
                                          ))),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Expanded(
                      flex: 3,
                      child: Stack(alignment: Alignment.bottomLeft, children: [
                        Container(
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
                                  padding: const EdgeInsets.all(5),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: SizedBox(
                                      width: 100.w,
                                      height: 5.h,
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          // widget.getReqAmnt!.isEmpty

                                          if (widget.isSavingReq!) {
                                            double amount =
                                                txtReqAmount.text.isEmpty
                                                    ? 0
                                                    : double.parse(
                                                        txtReqAmount.text);
                                            if (amount != 0) {
                                              //todo:-  only if money request against goals, then it is consider checking for no pending money request available
                                              if (widget.getReqAmnt!.isEmpty) {
                                              } else {
                                                if (getPaidStatus == true) {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CustomDialogBox(
                                                          title: "Message!",
                                                          descriptions:
                                                              "Already Pending Request Available,",
                                                          text: "Ok",
                                                          isCancel: true,
                                                          onTap: () async {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        );
                                                      });
                                                  return;
                                                }
                                              }

                                              double? getReqAmont =
                                                  Constants.convertToDouble(
                                                      widget.getReqAmnt);

                                              if (widget.getReqAmnt!.isEmpty
                                                  ? amount >
                                                      getFinalWithdrawalBal
                                                  : amount > getReqAmont!) {
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return CustomDialogBox(
                                                        title: "Message!",
                                                        descriptions:
                                                            "Requested amount greater than Withdrawal balance",
                                                        text: "Ok",
                                                        isCancel: true,
                                                        onTap: () async {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      );
                                                    });

                                                return;
                                              } else {
                                                if (getPaidStatus ?? false) {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CustomDialogBox(
                                                          title: "Message!",
                                                          descriptions:
                                                              "Your last Request ₹${ref.read(UserDashListProvider.notifier).getLastReqAmount!.toStringAsFixed(2)} is Not Paid, Do you want add More Request",
                                                          text: "Ok",
                                                          isNo: true,
                                                          isCancel: true,
                                                          onTap: () async {
                                                            double amount = txtReqAmount
                                                                    .text
                                                                    .isEmpty
                                                                ? 0
                                                                : double.parse(
                                                                        txtReqAmount
                                                                            .text) +
                                                                    ref
                                                                        .read(UserDashListProvider
                                                                            .notifier)
                                                                        .getLastReqAmount!;

                                                            if (amount > getFinalWithdrawalBal){
                                                              Constants.showToast(
                                                                  "Requested amount greater than Withdrawal Balance",
                                                                  ToastGravity
                                                                      .CENTER);
                                                              return;
                                                            }

                                                            if (amount != 0) {
                                                              if (amount >
                                                                  ref
                                                                      .read(UserDashListProvider
                                                                          .notifier)
                                                                      .getNetbalance) {
                                                                Constants.showToast(
                                                                    "Requested amount greater than Netbalance",
                                                                    ToastGravity
                                                                        .CENTER);
                                                              } else {
                                                                amount = double.parse(
                                                                        txtReqAmount
                                                                            .text) +
                                                                    ref
                                                                        .read(UserDashListProvider
                                                                            .notifier)
                                                                        .getLastReqAmount!;

                                                                await ref
                                                                    .read(UserDashListProvider
                                                                        .notifier)
                                                                    .updateData(
                                                                        true,
                                                                        amount,
                                                                        ref
                                                                            .read(UserDashListProvider
                                                                                .notifier)
                                                                            .getDocId,
                                                                        widget
                                                                            .getMobile,
                                                                        txtReqAmount,
                                                                        widget
                                                                            .getGoalDocId);

//todo:- publishing notification when user requesting money
                                                                String? token =
                                                                    await NotificationService
                                                                        .getDocumentIDsAndData();
                                                                if (token !=
                                                                    null) {
                                                                  Response?
                                                                      response =
                                                                      await NotificationService.postNotificationRequest(
                                                                          token,
                                                                          widget.isSavingReq!
                                                                              ? "Hi Admin,\n$getUserName is Requesting Money $amount"
                                                                              : "Hi Admin,\n$getUserName is Requesting Cashback $amount",
                                                                          "Under $getAdmin\nHurry up, let's Check Maaka App.");
                                                                  // Handle the response as needed
                                                                } else {
                                                                  print(
                                                                      "Problem in getting Token");
                                                                }

                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            } else {
                                                              Constants.showToast(
                                                                  txtReqAmount
                                                                          .text
                                                                          .isEmpty
                                                                      ? "Please Enter Amount"
                                                                      : "Please Enter Valid Amount",
                                                                  ToastGravity
                                                                      .CENTER);
                                                            }
                                                          },
                                                          onNoTap: () async {
                                                            double amount = txtReqAmount
                                                                    .text
                                                                    .isEmpty
                                                                ? 0
                                                                : double.parse(
                                                                    txtReqAmount
                                                                        .text);
                                                            if (amount != 0) {
                                                              if (amount >
                                                                  ref
                                                                      .read(UserDashListProvider
                                                                          .notifier)
                                                                      .getNetbalance) {
                                                                Constants.showToast(
                                                                    "Requested amount greater than Netbalance",
                                                                    ToastGravity
                                                                        .CENTER);
                                                              } else {
                                                                amount = double.parse(
                                                                    txtReqAmount
                                                                        .text);

                                                                await ref
                                                                    .read(UserDashListProvider
                                                                        .notifier)
                                                                    .updateData(
                                                                        true,
                                                                        amount,
                                                                        ref
                                                                            .read(UserDashListProvider
                                                                                .notifier)
                                                                            .getDocId,
                                                                        widget
                                                                            .getMobile,
                                                                        txtReqAmount,
                                                                        widget
                                                                            .getGoalDocId);

//todo:- publishing notification when user requesting money
                                                                String? token =
                                                                    await NotificationService
                                                                        .getDocumentIDsAndData();
                                                                if (token !=
                                                                    null) {
                                                                  Response?
                                                                      response =
                                                                      await NotificationService.postNotificationRequest(
                                                                          token,
                                                                          widget.isSavingReq!
                                                                              ? "Hi Admin,\n$getUserName is Requesting Money $amount"
                                                                              : "Hi Admin,\n$getUserName is Requesting Cashback",
                                                                          "Under $getAdmin\nHurry up, let's Check Maaka App.");
                                                                  // Handle the response as needed
                                                                } else {
                                                                  print(
                                                                      "Problem in getting Token");
                                                                }

                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            } else {
                                                              Constants.showToast(
                                                                  txtReqAmount
                                                                          .text
                                                                          .isEmpty
                                                                      ? "Please Enter Amount"
                                                                      : "Please Enter Valid Amount",
                                                                  ToastGravity
                                                                      .CENTER);
                                                            }
                                                            // Navigator.pop(
                                                            //     context);
                                                          },
                                                        );
                                                      });
                                                } else {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CustomDialogBox(
                                                          title: "Message!",
                                                          descriptions:
                                                              "Are you sure, Do you want to Request Money",
                                                          text: "Ok",
                                                          isCancel: true,
                                                          onTap: () async {
                                                            double amount = txtReqAmount
                                                                    .text
                                                                    .isEmpty
                                                                ? 0
                                                                : double.parse(
                                                                    txtReqAmount
                                                                        .text);
                                                            if (amount != 0) {
                                                              if (amount >
                                                                  ref
                                                                      .read(UserDashListProvider
                                                                          .notifier)
                                                                      .getNetbalance) {
                                                                Constants.showToast(
                                                                    "Requested amount greater than Netbalance",
                                                                    ToastGravity
                                                                        .CENTER);
                                                              } else {
                                                                amount = double.parse(
                                                                    txtReqAmount
                                                                        .text);

                                                                await ref
                                                                    .read(UserDashListProvider
                                                                        .notifier)
                                                                    .updateData(
                                                                        true,
                                                                        amount,
                                                                        ref
                                                                            .read(UserDashListProvider
                                                                                .notifier)
                                                                            .getDocId,
                                                                        widget
                                                                            .getMobile,
                                                                        txtReqAmount,
                                                                        widget
                                                                            .getGoalDocId);
//todo:- 2.12.23 pushing notification when user requesting money
                                                                String? token =
                                                                    await NotificationService
                                                                        .getDocumentIDsAndData();
                                                                if (token !=
                                                                    null) {
                                                                  Response?
                                                                      response =
                                                                      await NotificationService.postNotificationRequest(
                                                                          token,
                                                                          widget.isSavingReq!
                                                                              ? "Hi Admin,\n$getUserName is Requesting Money $amount"
                                                                              : "Hi Admin,\n$getUserName is Requesting Cashback",
                                                                          "Under $getAdmin\nHurry up, let's Check Maaka App.");
                                                                  // Handle the response as needed
                                                                } else {
                                                                  print(
                                                                      "Problem in getting Token");
                                                                }
                                                              }
                                                            } else {
                                                              Constants.showToast(
                                                                  txtReqAmount
                                                                          .text
                                                                          .isEmpty
                                                                      ? "Please Enter Amount"
                                                                      : "Please Enter Valid Amount",
                                                                  ToastGravity
                                                                      .CENTER);
                                                            }
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        );
                                                      });
                                                }
                                              }
                                            } else {
                                              Constants.showToast(
                                                  txtReqAmount.text.isEmpty
                                                      ? "Please Enter Amount"
                                                      : "Please Enter Valid Amount",
                                                  ToastGravity.CENTER);
                                              return;
                                            }
                                          } else {
                                            double amount =
                                                txtReqAmount.text.isEmpty
                                                    ? 0
                                                    : double.parse(
                                                        txtReqAmount.text);
                                            if (amount != 0) {
                                              if (amount >
                                                  ref
                                                      .read(UserDashListProvider
                                                          .notifier)
                                                      .getNetIntbalance) {
                                                Constants.showToast(
                                                    "Requested amount greater than Cashback balance",
                                                    ToastGravity.CENTER);
                                                return;
                                              } else {
                                                if (getCashbckPaidStatus ??
                                                    false) {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CustomDialogBox(
                                                          title: "Message!",
                                                          descriptions:
                                                              "Your last Request ₹${ref.read(UserDashListProvider.notifier).getLastCashbckReqAmount!.toStringAsFixed(2)} is Not Paid, Do you want add More Request",
                                                          text: "Ok",
                                                          isNo: true,
                                                          isCancel: true,
                                                          onTap: () async {
                                                            double amount = txtReqAmount
                                                                    .text
                                                                    .isEmpty
                                                                ? 0
                                                                : double.parse(
                                                                        txtReqAmount
                                                                            .text) +
                                                                    ref
                                                                        .read(UserDashListProvider
                                                                            .notifier)
                                                                        .getLastCashbckReqAmount!;

                                                            double getAmount = amount;
                                                            String amntInString = getAmount.toStringAsFixed(2);
                                                            double getFinalUserEnteredAmount = double.parse(amntInString);


                                                            if(getFinalUserEnteredAmount > ref
                                                                .read(UserDashListProvider
                                                                .notifier)
                                                                .getNetIntbalance){
                                                              Constants.showToast(
                                                                  "Requested amount greater than Cashback balance",
                                                                  ToastGravity
                                                                      .CENTER);
                                                              Navigator.pop(context);
                                                              return;

                                                            }

                                                            if (amount != 0) {
                                                              if (amount >
                                                                  ref
                                                                      .read(UserDashListProvider
                                                                          .notifier)
                                                                      .getNetIntbalance) {
                                                                Constants.showToast(
                                                                    "Requested amount greater than Cashback balance",
                                                                    ToastGravity
                                                                        .CENTER);
                                                              } else {
                                                                amount = double.parse(
                                                                        txtReqAmount
                                                                            .text) +
                                                                    ref
                                                                        .read(UserDashListProvider
                                                                            .notifier)
                                                                        .getLastCashbckReqAmount!;

                                                                await ref
                                                                    .read(UserDashListProvider
                                                                        .notifier)
                                                                    .updateData(
                                                                        false,
                                                                        amount,
                                                                        ref
                                                                            .read(UserDashListProvider
                                                                                .notifier)
                                                                            .getDocId,
                                                                        widget
                                                                            .getMobile,
                                                                        txtReqAmount,
                                                                        widget
                                                                            .getGoalDocId);

//todo:-  2.12.23 publishing notification when user wants to request cashback
                                                                String? token =
                                                                    await NotificationService
                                                                        .getDocumentIDsAndData();
                                                                if (token !=
                                                                    null) {
                                                                  Response?
                                                                      response =
                                                                      await NotificationService.postNotificationRequest(
                                                                          token,
                                                                          widget.isSavingReq!
                                                                              ? "Hi Admin,\n$getUserName is Requesting Money"
                                                                              : "Hi Admin,\n$getUserName is Requesting Cashback $amount",
                                                                          "Under $getAdmin\nHurry up, let's Check Maaka App.");
                                                                  // Handle the response as needed
                                                                } else {
                                                                  print(
                                                                      "Problem in getting Token");
                                                                }

                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            } else {
                                                              Constants.showToast(
                                                                  txtReqAmount
                                                                          .text
                                                                          .isEmpty
                                                                      ? "Please Enter Amount"
                                                                      : "Please Enter Valid Amount",
                                                                  ToastGravity
                                                                      .CENTER);
                                                            }
                                                            // Navigator.pop(
                                                            //     context);
                                                          },
                                                          onNoTap: () async {
                                                            double amount = txtReqAmount
                                                                    .text
                                                                    .isEmpty
                                                                ? 0
                                                                : double.parse(
                                                                    txtReqAmount
                                                                        .text);
                                                            if (amount != 0) {
                                                              if (amount >
                                                                  ref
                                                                      .read(UserDashListProvider
                                                                          .notifier)
                                                                      .getNetIntbalance) {
                                                                Constants.showToast(
                                                                    "Requested amount greater than Cashback balance",
                                                                    ToastGravity
                                                                        .CENTER);
                                                              } else {
                                                                amount = double.parse(
                                                                    txtReqAmount
                                                                        .text);

                                                                await ref
                                                                    .read(UserDashListProvider
                                                                        .notifier)
                                                                    .updateData(
                                                                        false,
                                                                        amount,
                                                                        ref
                                                                            .read(UserDashListProvider
                                                                                .notifier)
                                                                            .getDocId,
                                                                        widget
                                                                            .getMobile,
                                                                        txtReqAmount,
                                                                        widget
                                                                            .getGoalDocId);

//todo:- publishing notification when user requesting money
                                                                String? token =
                                                                    await NotificationService
                                                                        .getDocumentIDsAndData();
                                                                if (token !=
                                                                    null) {
                                                                  Response?
                                                                      response =
                                                                      await NotificationService.postNotificationRequest(
                                                                          token,
                                                                          widget.isSavingReq!
                                                                              ? "Hi Admin,\n$getUserName is Requesting Money"
                                                                              : "Hi Admin,\n$getUserName is Requesting Cashback $amount",
                                                                          "Under $getAdmin\nHurry up, let's Check Maaka App.");
                                                                  // Handle the response as needed
                                                                } else {
                                                                  print(
                                                                      "Problem in getting Token");
                                                                }

                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            } else {
                                                              Constants.showToast(
                                                                  txtReqAmount
                                                                          .text
                                                                          .isEmpty
                                                                      ? "Please Enter Amount"
                                                                      : "Please Enter Valid Amount",
                                                                  ToastGravity
                                                                      .CENTER);
                                                            }
                                                            // Navigator.pop(
                                                            //     context);
                                                          },
                                                        );
                                                      });
                                                } else {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CustomDialogBox(
                                                          title: "Message!",
                                                          descriptions:
                                                              "Are you sure, Do you want to Request Cashback",
                                                          text: "Ok",
                                                          isCancel: true,
                                                          onTap: () async {
                                                            double amount = txtReqAmount
                                                                    .text
                                                                    .isEmpty
                                                                ? 0
                                                                : double.parse(
                                                                    txtReqAmount
                                                                        .text);
                                                            if (amount != 0) {
                                                              if (amount >
                                                                  ref
                                                                      .read(UserDashListProvider
                                                                          .notifier)
                                                                      .getNetIntbalance) {
                                                                Constants.showToast(
                                                                    "Requested amount greater than Netbalance",
                                                                    ToastGravity
                                                                        .CENTER);
                                                              } else {
                                                                amount = double.parse(
                                                                    txtReqAmount
                                                                        .text);

                                                                await ref
                                                                    .read(UserDashListProvider
                                                                        .notifier)
                                                                    .updateData(
                                                                        false,
                                                                        amount,
                                                                        ref
                                                                            .read(UserDashListProvider
                                                                                .notifier)
                                                                            .getDocId,
                                                                        widget
                                                                            .getMobile,
                                                                        txtReqAmount,
                                                                        widget
                                                                            .getGoalDocId);
//todo:- 2.12.23 publishing notification when user requesting cashback
                                                                String? token =
                                                                    await NotificationService
                                                                        .getDocumentIDsAndData();
                                                                if (token !=
                                                                    null) {
                                                                  Response?
                                                                      response =
                                                                      await NotificationService.postNotificationRequest(
                                                                          token,
                                                                          widget.isSavingReq!
                                                                              ? "Hi Admin,\n$getUserName is Requesting Money"
                                                                              : "Hi Admin,\n$getUserName is Requesting Cashback $amount",
                                                                          "Under $getAdmin\nHurry up, let's Check Maaka App.");
                                                                  // Handle the response as needed
                                                                } else {
                                                                  print(
                                                                      "Problem in getting Token");
                                                                }

                                                                // Navigator.pop(
                                                                //     context);
                                                              }
                                                            } else {
                                                              Constants.showToast(
                                                                  txtReqAmount
                                                                          .text
                                                                          .isEmpty
                                                                      ? "Please Enter Amount"
                                                                      : "Please Enter Valid Amount",
                                                                  ToastGravity
                                                                      .CENTER);
                                                            }
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        );
                                                      });
                                                }
                                              }
                                            } else {
                                              Constants.showToast(
                                                  txtReqAmount.text.isEmpty
                                                      ? "Please Enter Amount"
                                                      : "Please Enter Valid Amount",
                                                  ToastGravity.CENTER);
                                              return;
                                            }
                                          }
                                        },
                                        text: widget.isSavingReq!
                                            ? "Request Amount"
                                            : "Request Cashback",
                                        options: FFButtonOptions(
                                          width: 50.w,
                                          height: 5.h,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .secondary1,
                                          textStyle:
                                          Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              color: Constants.secondary,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold),
                                          elevation: 2.0,
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Add more Positioned widgets for additional images
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              );
            }),
          )),
        );
      }),
    );
  }
}
