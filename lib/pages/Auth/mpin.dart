import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:lottie/lottie.dart';
import 'package:maaakanmoney/pages/Auth/phone_auth_widget.dart';
import 'package:maaakanmoney/pages/User/Userscreen_widget.dart';
import 'package:maaakanmoney/verify.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/NotificationService.dart';
import '../../components/constants.dart';
import '../../components/custom_dialog_box.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../phoneController.dart';

class MpinPageWidget extends ConsumerStatefulWidget {
  MpinPageWidget({
    Key? key,
    required this.getMobileNo,
    required this.getMpin,
  }) : super(key: key);
  final String getMobileNo; // Data received from SplashScreen
  final String? getMpin;

  @override
  MpinPageState createState() => MpinPageState();
}

class MpinPageState extends ConsumerState<MpinPageWidget> {
  var verifycode = "";
  ConnectivityResult? data;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool? isUserStillAvailable = true;
  List<int> passcode = [];
  final ValueNotifier<bool> _isTappingAffiliateApp = ValueNotifier<bool>(false);
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription<List<ConnectivityResult>> subscription;
  String? getUserDocId = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _HomePageLinks1(context);
    getNotificationAccessToken();
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      print("aaaaaa$result");

      if(result != null || result.isNotEmpty){
        ref.read(connectivityProvider.notifier).state = result[0];
      }
    });
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
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


  Future<void> _HomePageLinks1(BuildContext context) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('HomePageLink').get();
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Access the fields and use them as needed
        Constants.getAmazonUrl = data['amazonHomePageUrl'] ?? "";
        Constants.getFlipkartUrl = data['flipkartHomePageUrl'] ?? "";
        Constants.getMyntraUrl = data['myntraHomePageUrl'] ?? "";
        Constants.getAjioUrl = data['ajioHomePageUrl'] ?? "";
        // Constants.getMeeshoUrl = data['meeshoHomePageUrl'] ?? "";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
      print('Error retrieving data: $e');
    }
  }

  Widget build(BuildContext context) {
    return UpgradeAlert(
      shouldPopScope: () => false, // Disables back button
      showIgnore: false, // Hide the "Ignore" button
      showLater: false,  // Hide the "Later" button
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          data = ref.watch(connectivityProvider);
          ref.watch(isOtpSent);
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              extendBodyBehindAppBar: true,
              body: SafeArea(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: IgnorePointer(
                    ignoring: _isTappingAffiliateApp.value,
                    child: Stack(
                      children: [
                        //todo:- 15.11.23 new ui for mpin screen
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                FlutterFlowTheme.of(context).primary,
                                FlutterFlowTheme.of(context).primary2
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            height: 100.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Stack(children: [
                                    SizedBox(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.transparent),
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Positioned.fill(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 50.0, right: 0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          letterSpacing: 1,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      Text(Constants.appVersion,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                  color: Constants
                                                                      .secondary,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              // Add more Positioned widgets for additional images
                                            ),
                                            Positioned.fill(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Stack(children: [
                                                  SizedBox(
                                                    height: 100.h,
                                                    width: 70.w,
                                                    child: Image.asset(
                                                      'images/final/SecurityCode/MPin.png',
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, right: 0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Stack(children: [
                                                    Text(
                                                      "MPin",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineLarge
                                                          ?.copyWith(
                                                              color: Constants
                                                                  .secondary),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(100.w /
                                                2), // Bottom-left corner is rounded
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Container(
                                          color: Colors.transparent,
                                          height: 40.h,
                                          width: 80.w,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children:
                                                List.generate(4, (rowIndex) {
                                              if (rowIndex == 3) {
                                                // Last row with 0
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: List.generate(3,
                                                      (colIndex) {
                                                    int index =
                                                        rowIndex * 3 + colIndex;
                                                    if (index == 9) {
                                                      return GestureDetector(
                                                        onTap: () async {},
                                                        child: Container(
                                                          height: 50,
                                                          width: 50,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.0),
                                                          ),
                                                        ),
                                                      );
                                                    } else if (index == 11) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          if (passcode
                                                              .isNotEmpty) {
                                                            setState(() {
                                                              passcode
                                                                  .removeLast();
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 50,
                                                          width: 50,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[100],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.0),
                                                          ),
                                                          child: Icon(
                                                            Icons.clear,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    return GestureDetector(
                                                      onTap: () {
                                                        print(
                                                            'Digit tapped: ${index == 10 ? 0 : index + 1}');

                                                        if (passcode.length <
                                                            4) {
                                                          ref
                                                                      .read(isOtpSent
                                                                          .notifier)
                                                                      .state ==
                                                                  true
                                                              ? () {}()
                                                              : setState(() {
                                                                  passcode.add(
                                                                      index ==
                                                                              10
                                                                          ? 0
                                                                          : index +
                                                                              1);
                                                                  if (passcode
                                                                          .length ==
                                                                      4) {
                                                                    print(
                                                                        'Passcode: $passcode');

                                                                    String
                                                                        finalSecCode =
                                                                        passcode
                                                                            .join('');

                                                                    verifyOtp(
                                                                        context,
                                                                        finalSecCode ??
                                                                            "");
                                                                  }
                                                                });
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 50,
                                                        width: 50,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[100],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100.0),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.2),
                                                              spreadRadius: 8,
                                                              blurRadius: 5,
                                                              offset: Offset(0,
                                                                  3), // changes the position of the shadow
                                                            ),
                                                          ],
                                                        ),
                                                        child: Text(
                                                          index == 10
                                                              ? '0'
                                                              : '${index + 1}',
                                                          // 0 for the last cell
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                );
                                              } else {
                                                // Regular rows
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: List.generate(3,
                                                      (colIndex) {
                                                    int index =
                                                        rowIndex * 3 + colIndex;
                                                    return GestureDetector(
                                                      onTap: () {
                                                        print(
                                                            'Digit tapped: ${index == 10 ? 0 : index + 1}');
                                                        if (passcode.length <
                                                            4) {
                                                          ref
                                                                      .read(isOtpSent
                                                                          .notifier)
                                                                      .state ==
                                                                  true
                                                              ? () {}()
                                                              : setState(() {
                                                                  passcode.add(
                                                                      index ==
                                                                              10
                                                                          ? 0
                                                                          : index +
                                                                              1);
                                                                  if (passcode
                                                                          .length ==
                                                                      4) {
                                                                    print(
                                                                        'Passcode: $passcode');
                                                                    String
                                                                        finalSecCode =
                                                                        passcode
                                                                            .join('');

                                                                    verifyOtp(
                                                                        context,
                                                                        finalSecCode ??
                                                                            "");
                                                                  }
                                                                });
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 50,
                                                        width: 50,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[100],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100.0),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.2),
                                                              spreadRadius: 8,
                                                              blurRadius: 5,
                                                              offset: Offset(3,
                                                                  4), // changes the position of the shadow
                                                            ),
                                                          ],
                                                        ),
                                                        child: Text(
                                                          '${index + 1}',
                                                          // Index starts from 0, so add 1
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                );
                                              }
                                            }),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 30.0, right: 0),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children:
                                                  List.generate(4, (index) {
                                                return Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: index <
                                                            passcode.length
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .primary
                                                        : Colors.transparent,
                                                    border: Border.all(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary2),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                        ),

                                        // Add more Positioned widgets for additional images
                                      ),
                                      (isUserStillAvailable ?? false) ?  Positioned.fill(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: InkWell(
                                              child: Text("forgot Mpin?",
                                                  selectionColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                          color: Constants
                                                              .primary)),
                                              onTap: () {
                                                // Navigator.pushReplacement(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             MyPhone()));

                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    transitionDuration: Duration(milliseconds: 500),
                                                    pageBuilder: (_, __, ___) => MpinSetUp(
                                                      getMobile:  (widget.getMobileNo ?? ""),
                                                    ),
                                                    transitionsBuilder: (_, animation, __, child) {
                                                      return ScaleTransition(
                                                        scale: Tween<double>(
                                                          begin: 0.0, // You can adjust the start scale
                                                          end: 1.0, // You can adjust the end scale
                                                        ).animate(animation),
                                                        child: child,
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),

                                        // Add more Positioned widgets for additional images
                                      ) : Container(),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 100.h,
                                    color: Constants.secondary,
                                    child: SingleChildScrollView(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "☑️Chance to turn your shopping into money!",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                            color: Constants
                                                                .primary,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      child: buildLinkItem(
                                                          context,
                                                          "Amazon",
                                                          'images/final/Login/amazon.jpeg',
                                                          Constants
                                                                  .getAmazonUrl ??
                                                              ""),
                                                      onTap: () {
                                                        _openAffiliateApp(
                                                            Constants
                                                                .getAmazonUrl,
                                                            AffiliateAppType
                                                                .amazon);
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      child: buildLinkItem(
                                                          context,
                                                          "Flipkart",
                                                          'images/final/Login/flipkart.jpeg',
                                                          Constants
                                                                  .getFlipkartUrl ??
                                                              ""),
                                                      onTap: () {
                                                        _openAffiliateApp(
                                                            Constants
                                                                .getFlipkartUrl,
                                                            AffiliateAppType
                                                                .flipkart);
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      child: buildLinkItem(
                                                          context,
                                                          "Myntra",
                                                          'images/final/Login/myntra.png',
                                                          Constants
                                                                  .getMyntraUrl ??
                                                              ""),
                                                      onTap: () {
                                                        _openAffiliateApp(
                                                            Constants
                                                                .getMyntraUrl,
                                                            AffiliateAppType
                                                                .myntra);
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      child: buildLinkItem(
                                                          context,
                                                          "Ajio",
                                                          'images/final/Login/ajio.png',
                                                          Constants
                                                                  .getAjioUrl ??
                                                              ""),
                                                      onTap: () {
                                                        _openAffiliateApp(
                                                            Constants
                                                                .getAjioUrl,
                                                            AffiliateAppType
                                                                .ajio);
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  // Expanded(
                                                  //     child: InkWell(
                                                  //   child: buildLinkItem(
                                                  //       context,
                                                  //       "Meesho",
                                                  //       'images/final/Login/meesho.jpeg',
                                                  //       Constants.getMeeshoUrl ?? ""),
                                                  //   onTap: () {
                                                  //     _openAffiliateApp(Constants.getMeeshoUrl,
                                                  //         AffiliateAppType.meesho);
                                                  //   },
                                                  // )),
                                                  // SizedBox(
                                                  //   width: 10,
                                                  // ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        ref.read(isOtpSent.notifier).state == true
                            ? const IgnorePointer(
                                ignoring: true,
                                child: AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  content: SizedBox(
                                      height: 80,
                                      width: 50,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                color: Color(0xFF004D40),
                                              )),
                                            ],
                                          ),
                                          Text(
                                            "Loading",
                                            style: TextStyle(
                                                color: Color(0xFF004D40),
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      )),
                                ),
                              )
                            : Container(),
                        ValueListenableBuilder<bool>(
                          valueListenable: _isTappingAffiliateApp,
                          builder: (context, isCreating, child) {
                            if (isCreating) {
                              return Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      upgrader: Upgrader(
        // canDismissDialog: false, // This forces the update by disallowing dialog dismissal
        // shouldPopScope: () => false, // Disables back button
        // showIgnore: false, // Hide the "Ignore" button
        // showLater: false,  // Hide the "Later" button
      ),
    );
  }

  Future<bool?> isUserVerified(String? phoneNumber) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('mobile', isEqualTo: phoneNumber)
        .get();

    if (querySnapshot.docs.isEmpty) {
      // Phone number does not exist in the Firestore table
      return false;
    }

    // var user = querySnapshot.docs.first.data() as Map<String, dynamic>?;
    // int getUser = user?['securityCode'];
    // getUserDocId = querySnapshot.docs.first.id;
    return true;
  }

  Future<void> verifyOtp(BuildContext context, String? getFinalSecCode) async {
    FocusScope.of(context).unfocus();

     isUserStillAvailable = await isUserVerified(widget.getMobileNo);
    if(isUserStillAvailable != true){
      setState(() {
        passcode.clear();
      });

      SharedPreferences prefs =
      await SharedPreferences
          .getInstance();
      prefs.setString(
          "LoginSuccessuser1",
          "");

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Message!",
              descriptions: "You're not Valid User!",
              text: "Ok",
              isCancel: false,
              onTap: () {
                // Pop the dialog first
                Navigator.of(context).pop();


                String? shoppingKey = prefs.getString("ShoppingUser");

                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (_, __, ___) => MyPhone(getIsShoppingUserName: shoppingKey,),
                    transitionsBuilder: (_, animation, __, child) {
                      return ScaleTransition(
                        scale: Tween<double>(
                          begin: 0.0, // You can adjust the start scale
                          end: 1.0, // You can adjust the end scale
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ),
                );
              },
            );
          });

      return;
    }



    if (data == ConnectivityResult.none) {
      Constants.showToast("No Internet Connection", ToastGravity.BOTTOM);
      return;
    }
    if (getFinalSecCode!.isNotEmpty) {
      if (getFinalSecCode!.length < 4) {
        Constants.showToast("Please enter a Valid Mpin", ToastGravity.BOTTOM);
      } else {
        if (widget.getMpin == getFinalSecCode) {

          // await updateUserNotificationToken(
          //   getUserDocId ?? "",
          // );


          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BudgetWidget1(
                getMobile: widget.getMobileNo,
              ),
            ),
          );
        } else {
          if (passcode.isNotEmpty) {
            setState(() {
              passcode.clear();
            });
          }

          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: "Message!",
                  descriptions: "You Entered Invalid Pin,Please contact Admin",
                  text: "Ok",
                  isCancel: false,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                );
              });
        }
      }
    } else {
      Constants.showToast("Please enter a OTP", ToastGravity.BOTTOM);
    }
  }

  ///implementation to update user token key in firestore / for sending notification to individual user
  Future<void> updateUserNotificationToken(
      String? getDocId,
      ) async {
    String? documentId = getDocId;

    try {
      await firestore.collection('users').doc(documentId).update({
        'notificationToken': Constants.userDeviceToken ?? "",
      }).then((value) {
        Constants.showToast(
            "Notification Token Updated Successfully", ToastGravity.CENTER);
      });
    } catch (error) {
      Constants.showToast(
          "Notification Token Update Failed, Try again!", ToastGravity.CENTER);
    }
  }

  Widget buildLinkItem(
      BuildContext context, String name, String imagePath, String? url) {
    return Column(
      children: [
        Container(
          height: 30,
          width: 30,
          // decoration: BoxDecoration(
          //   color: Colors.black,
          //   borderRadius: BorderRadius.circular(10),
          // ),
          child: Image.asset(
            imagePath,
            opacity: const AlwaysStoppedAnimation(.9),
            fit: BoxFit.cover,
          ),
        ),
        Text(
          name,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Constants.primary,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  void _openAffiliateApp(
      String? getAffiliateLink, AffiliateAppType getAppType) async {
    _isTappingAffiliateApp.value = true;
    String? getApp;

    switch (getAppType) {
      case AffiliateAppType.amazon:
        getApp = "Amazon";
        break;
      case AffiliateAppType.flipkart:
        getApp = "Flipkart";
        break;
      case AffiliateAppType.myntra:
        getApp = "Myntra";
        break;
      case AffiliateAppType.ajio:
        getApp = "Ajio";
        break;
      case AffiliateAppType.meesho:
        getApp = "Meesho";
        break;
      default:
        getApp = "xxx";
    }

    String? token = await NotificationService.getDocumentIDsAndData();

    if (await canLaunch(getAffiliateLink ?? "")) {
      await NotificationService.postNotificationRequest(
          token ?? "",
          "Hi Admin,\nSome User Started shopping 😍😍😍",
          "Trying to open $getApp Affiliate App\nOpening in MPin Screen!");
      _isTappingAffiliateApp.value = false;
      await launch(getAffiliateLink ?? "");
    } else {
      Constants.showToast("Try Again After SomeTimes", ToastGravity.CENTER);
      _isTappingAffiliateApp.value = false;
      await NotificationService.postNotificationRequest(
          token ?? "",
          "Hi Admin,\nSome User facing Issue 😖🙁🤯",
          "Trying to open $getApp Affiliate App\nProblem in opening $getApp Affiliate App!");
      throw 'Could not launch $getAffiliateLink';
    }
  }




}
