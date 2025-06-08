// ignore_for_file: prefer_interpolation_to_compose_strings, invalid_return_type_for_catch_error, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:lottie/lottie.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_widgets.dart';
import 'package:maaakanmoney/pages/User/navigation_drawer/AdminsGrocery/admins_grocery.dart';
import 'package:maaakanmoney/pages/User/navigation_drawer/foodAdminsFoods/food_admins_foods.dart';
import 'package:maaakanmoney/pages/budget_copy/navigation_drawer/meat_basket_areas/area_list.dart';
import 'package:maaakanmoney/pages/chatScreen.dart';
import 'package:maaakanmoney/pages/showMoneyRequest/ShowMoneyRequest.dart';
import 'package:maaakanmoney/phoneController.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/NotificationService.dart';
import '../../components/custom_dialog_box.dart';
import '../../components/search_box.dart';
import '../Auth/phone_auth_widget.dart';
import '../User/Goals/GoalsHistory1.dart';
import '../User/UserScreen_Notifer.dart';
import '../showUser/showUser.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/adduser/adduser_widget.dart';
import 'package:flutter/material.dart';
import 'BudgetCopyController.dart';
export 'budget_copy_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:http/http.dart' as http;

import 'Goals/UserGoalHistory.dart';
import 'GoalsUser/GoalUsers.dart';
import 'ecommerce/ecommerce.dart';
import 'navigation_drawer/Update_affiliate_link.dart';
import 'navigation_drawer/create_notification.dart';
import 'navigation_drawer/my_orders/orders_screen.dart';
import 'navigation_drawer/post_product_screen.dart';

class BudgetCopyWidget extends ConsumerStatefulWidget {
  final String? getUserType;
  final String? getAdminMobileNo;

  BudgetCopyWidget(
      {Key? key, required this.getUserType, required this.getAdminMobileNo})
      : super(key: key);

  @override
  _BudgetCopyWidgetState createState() => _BudgetCopyWidgetState();
}

class _BudgetCopyWidgetState extends ConsumerState<BudgetCopyWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<User2>? newDataList = [];
  AnimationController? lottieController;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  int _selectedIndex = 0;
  int _currentIndex = 0;
  bool showbutton = true;
  bool _isNavigationBarVisible = false;
  List<MeatOrder> allOrders = [];

  CollectionReference? _collectionReference;
  CollectionReference? _collectionUsers;
  CollectionReference? _collectionRefToken;

  final txtReqAmount = TextEditingController();

  String? lastProcessedMessageId;

  @override
  void initState() {
    super.initState();
    // _startTimer();
    // todo:-29.9.23

    _collectionReference =
        FirebaseFirestore.instance.collection('adminDetails');
    _collectionRefToken = FirebaseFirestore.instance.collection('AdminToken');
    _collectionUsers = FirebaseFirestore.instance.collection('users');
    ref
        .read(adminDashListProvider.notifier)
        .txtSearch
        .addListener(onChangedText);

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(isRefreshIndicator.notifier).state = false;
      ref.read(isPendingReq.notifier).state = 0;
      ref.read(isPendingCashbckReq.notifier).state = 0;
      ref.read(isPendingMessages.notifier).state = 0;
      ref.read(adminDashListProvider.notifier).getDashboardDetails();
    });

    //todo:- 30.11.23, if login with - 0805080588, means , that device token is admin app token, user app through notification to that token,means that device receives notifcation from users
    if (Constants.isAdmin2) {
      print(Constants.adminDeviceToken);
      // getDocumentIDsAndData();
      updateAdminToken(Constants.adminDeviceToken);
      // getDocumentIDsAndData();
    }

    //todo:- Firestore Database changes
    // updateDefaultValues();
    // addNewFieldToDocuments();
    // renameFieldInDocuments();
    // deleteFieldInDocuments();
    // addNewFieldToTransactions();
    // addNewCollectionWithDocument();
    //getDocumentIDsAndData()
    //updateAdminToken();
    // updateAllMeatPrices();
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

  Future<bool> _onWillPop() async {
    if ((widget.getUserType ?? "0") == "0") {
      return (await showDialog(
            context: context,
            builder: (alertcontext) => AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to Exit'),
              actions: <Widget>[
                TextButton(
                  // onPressed: () =>
                  //     Navigator.of(context).pop(false), //<-- SEE HERE
                  onPressed: () {
                    Navigator.pop(alertcontext);
                  },
                  child: new Text('No'),
                ),
                TextButton(
                  // onPressed: () =>
                  //     Navigator.of(context).pop(true), // <-- SEE HERE
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: new Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    } else {
      Navigator.of(context).pop();
      return true;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    lottieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //todo:- 16.6.23
    final currentTime = DateTime.now().toLocal();
    final currentHour = currentTime.hour;
    // int randomIndex = math.Random().nextInt(imagePaths.length);
    // String randomImagePath = imagePaths[randomIndex];

    String greetingText = '';

    if (currentHour >= 6 && currentHour < 12) {
      greetingText = 'Good Morning';
    } else if (currentHour >= 12 && currentHour < 18) {
      greetingText = 'Good Afternoon';
    } else if (currentHour >= 18 || currentHour == 0 || currentHour < 6) {
      greetingText = 'Good Evening';
    } else if (currentHour == 14) {
      greetingText = 'Good Afternoon'; // Custom message for 14 hours
    }

    return WillPopScope(
        onWillPop: () => _onWillPop(),
        child: _AdminScreen(context, widget.getUserType ?? "0"));
  }

  Widget _AdminScreen(BuildContext context, String getAdminType) {
    switch (getAdminType) {
      case "0": //supper admin
        return Scaffold(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          key: scaffoldKey,
          appBar: responsiveVisibility(
            context: context,
            tabletLandscape: false,
            desktop: false,
          )
              ? AppBar(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 100,
                  title: _selectedIndex == 0
                      ? AnimatedContainer(
                          // color: Colors.white60,
                          duration: const Duration(milliseconds: 500),
                          height: _isNavigationBarVisible ? 50.0 : 60.0,
                          child: !_isNavigationBarVisible
                              ? SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text.rich(
                                        TextSpan(
                                          text: 'Maaka ',
                                          children: [
                                            TextSpan(
                                              text: "Users",
                                              style: TextStyle(
                                                  fontSize: 22.0,
                                                  fontFamily: 'Outfit',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                  letterSpacing: 1),
                                            ),
                                          ],
                                        ),
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                          fontSize: 22.0,
                                          letterSpacing: 1.0,
                                          fontFamily: 'Outfit',
                                        ),
                                      ),
                                      Consumer(builder: (context, ref, child) {
                                        List<User2>? userCount =
                                            ref.watch(getListItemProvider);

                                        return Text(
                                          userCount?.length.toString() ?? "",
                                          style: FlutterFlowTheme.of(context)
                                              .titleSmall
                                              .override(
                                                fontFamily: 'Outfit',
                                                color: Colors.white,
                                                fontSize: 30.0,
                                                fontWeight: FontWeight.w900,
                                              ),
                                        );
                                      }),
                                    ],
                                  ),
                                )
                              : SearchBox(onChanged: (value) {
                                  ref
                                      .read(adminDashListProvider.notifier)
                                      .txtSearch
                                      .text = value;
                                }))
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text.rich(
                                TextSpan(
                                  text: 'Maaka ',
                                  children: [
                                    TextSpan(
                                      text: "Users",
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontFamily: 'Outfit',
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          letterSpacing: 1),
                                    ),
                                  ],
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontSize: 22.0,
                                  letterSpacing: 1.0,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                              Text(
                                ref
                                    .read(getListItemProvider.notifier)
                                    .state!
                                    .length
                                    .toString(),
                                style: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Outfit',
                                      color: Colors.white,
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ],
                          ),
                        ),
                  actions: [
                    // Row(
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsetsDirectional.fromSTEB(
                    //           0.0, 0.0, 20.0, 0.0),
                    //       child: InkWell(
                    //         splashColor: Colors.transparent,
                    //         focusColor: Colors.transparent,
                    //         hoverColor: Colors.transparent,
                    //         highlightColor: Colors.transparent,
                    //         onTap: () async {
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder: (context) => ProductListScreen(
                    //                 userName: ref
                    //                         .read(UserDashListProvider.notifier)
                    //                         .getUser ??
                    //                     "",
                    //               ),
                    //             ),
                    //           ).then((value) {
                    //             //todo:- below code refresh firebase records automatically when come back to same screen
                    //             // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                    //           });
                    //         },
                    //         child: Icon(
                    //           Icons.camera_alt,
                    //           color: FlutterFlowTheme.of(context).primaryBtnText,
                    //           size: 24.0,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsetsDirectional.fromSTEB(
                    //           0.0, 0.0, 20.0, 0.0),
                    //       child: InkWell(
                    //         splashColor: Colors.transparent,
                    //         focusColor: Colors.transparent,
                    //         hoverColor: Colors.transparent,
                    //         highlightColor: Colors.transparent,
                    //         onTap: () async {
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder: (context) => const UserGoals(),
                    //             ),
                    //           ).then((value) {
                    //             //todo:- below code refresh firebase records automatically when come back to same screen
                    //             // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                    //           });
                    //         },
                    //         child: Icon(
                    //           Icons.flag,
                    //           color: FlutterFlowTheme.of(context).primaryBtnText,
                    //           size: 24.0,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 20.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              txtReqAmount.text = "";
                              _showBottomSheet(
                                context,
                              );
                            },
                            child: Icon(
                              Icons.notification_add,
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                              size: 24.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Consumer(builder: (context, ref, child) {
                      int? isPendingRequest = ref.watch(isPendingReq);
                      int? isPendingCashbckRequest =
                          ref.watch(isPendingCashbckReq);
                      int? isPendingMessage = ref.watch(isPendingMessages);

                      return Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 20.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialogBox(
                                    title: "Alert!",
                                    descriptions:
                                        "Are you sure, Do you want to logout",
                                    text: "Ok",
                                    isCancel: true,
                                    onTap: () {
                                      // openAnotherApp("com.phonepe.app");
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyPhone()),
                                        (route) =>
                                            false, // Remove all routes from the stack
                                      );
                                    },
                                  );
                                });
                          },
                          child: Icon(
                            Icons.logout,
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                            size: 24.0,
                          ),
                        ),
                      );
                    }),
                  ],
                  centerTitle: false,
                  elevation: 0.0,
                )
              : null,
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Constants.primary,
                  ),
                  child: Center(
                    child: Text(
                      'Team Maaka',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Maaka Service',
                    style: GlobalTextStyles.secondaryText1(
                        txtWeight: FontWeight.bold,
                        textColor: Constants.primary),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.supervised_user_circle_rounded,
                    color: Constants.primary,
                  ),
                  title: Text('Users With Goals'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserGoals(),
                      ),
                    ).then((value) {
                      //todo:- below code refresh firebase records automatically when come back to same screen
                      // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                    });
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.notification_add,
                    color: Constants.primary,
                  ),
                  title: Text('Create Notification'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateNewNotificationScreen(
                            isIndividualNotificationToken: null),
                      ),
                    ).then((value) {
                      //todo:- below code refresh firebase records automatically when come back to same screen
                      // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                    });
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.link,
                    color: Constants.primary,
                  ),
                  title: Text('Update Affiliate Links'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateAffiliateLink(),
                      ),
                    ).then((value) {
                      //todo:- below code refresh firebase records automatically when come back to same screen
                      // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                    });
                  },
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Meat Business',
                    style: GlobalTextStyles.secondaryText1(
                        txtWeight: FontWeight.bold,
                        textColor: Constants.primary),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.dining_sharp,
                    color: Constants.primary,
                  ),
                  title: Text('Meat Basket Areas'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AreaList(
                          getUserType: '0',
                          getAdminMobileNo: '',
                        ),
                      ),
                    ).then((value) {
                      //todo:- below code refresh firebase records automatically when come back to same screen
                      // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                    });
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.thumb_up,
                    color: Constants.primary,
                  ),
                  title: Text('My Meat Orders'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrdersScreen(
                          getUserType: '0',
                          getAdminMobileNo: '',
                        ),
                      ),
                    ).then((value) {
                      //todo:- below code refresh firebase records automatically when come back to same screen
                      // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                    });
                  },
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Cloud Kitchen Business',
                    style: GlobalTextStyles.secondaryText1(
                        txtWeight: FontWeight.bold,
                        textColor: Constants.primary),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.food_bank,
                    color: Constants.primary,
                  ),
                  title: Text('Sell Food'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateNewFood(
                            getMobNo: "+919941445471",
                            getDocId: "",
                            getTitle: "",
                            getDescription: "",
                            getAmount: "",
                            getIsUpdatingFoodPrice: false),
                      ),
                    ).then((value) {
                      //todo:- below code refresh firebase records automatically when come back to same screen
                      // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                    });
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.fastfood_outlined,
                    color: Constants.primary,
                  ),
                  title: Text('My Foods Orders'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrdersScreen(
                          getUserType: '20',
                          getAdminMobileNo: '',
                        ),
                      ),
                    ).then((value) {
                      //todo:- below code refresh firebase records automatically when come back to same screen
                      // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                    });
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.fastfood_outlined,
                    color: Constants.primary,
                  ),
                  title: Text('Our Foods'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                            AdminsFoodListScreen(
                              getAdminMobile: Constants.adminNo2 ??
                                  "",
                            ),
                      ),
                    ).then((value) {
                      //todo:- below code refresh firebase records automatically when come back to same screen
                      // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                    });
                  },
                ),
                Divider(),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Grocery Business',
                    style: GlobalTextStyles.secondaryText1(
                        txtWeight: FontWeight.bold,
                        textColor: Constants.primary),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.food_bank,
                    color: Constants.primary,
                  ),
                  title: Text('Sell Grocery'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateNewGrocery(
                            getMobNo: "+919941445471",
                            getDocId: "",
                            getTitle: "",
                            getDescription: "",
                            getAmount: "",
                            getIsUpdatingGroceryPrice: false),
                      ),
                    ).then((value) {
                      //todo:- below code refresh firebase records automatically when come back to same screen
                      // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                    });
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.fastfood_outlined,
                    color: Constants.primary,
                  ),
                  title: Text('My Grocery Orders'),
                  onTap: () {
                    // Navigator.pop(context);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => OrdersScreen(
                    //       getUserType: '20',
                    //       getAdminMobileNo: '',
                    //     ),
                    //   ),
                    // ).then((value) {
                    //   //todo:- below code refresh firebase records automatically when come back to same screen
                    //   // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                    // });
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.fastfood_outlined,
                    color: Constants.primary,
                  ),
                  title: Text('Our Groceries'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                AdminsGroceryListScreen(
                              getAdminMobile: Constants.adminNo2 ??
                                  "",
                            ),
                      ),
                    ).then((value) {
                      //todo:- below code refresh firebase records automatically when come back to same screen
                      // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                    });
                  },
                ),


                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Product / Selling Business',
                    style: GlobalTextStyles.secondaryText1(
                        txtWeight: FontWeight.bold,
                        textColor: Constants.primary),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.sell,
                    color: Constants.primary,
                  ),
                  title: Text('Sell Product'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateNewProduct(),
                      ),
                    ).then((value) {
                      //todo:- below code refresh firebase records automatically when come back to same screen
                      // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                    });
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Constants.primary,
                  ),
                  title: Text('Our Products'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductListScreen(
                          userName:
                              ref.read(UserDashListProvider.notifier).getUser ??
                                  "",
                        ),
                      ),
                    ).then((value) {
                      //todo:- below code refresh firebase records automatically when come back to same screen
                      // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                    });
                  },
                ),

              ],
            ),
          ),
          body: SafeArea(
            child: NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
              if (notification.direction == ScrollDirection.forward) {
                _toggleNavigationBarVisibility(false);
              } else if (notification.direction == ScrollDirection.reverse) {
                _toggleNavigationBarVisibility(true);
              }
              return true;
            }, child: Consumer(builder: (context, ref, child) {
              ref.read(adminDashListProvider.notifier).data =
                  ref.watch(connectivityProvider);
              // AdminDashState getAdminDashList = ref.watch(adminDashListProvider);
              AdminDashState2 getAdminDashList =
                  ref.watch(adminDashListProvider);
              ref.watch(getListItemProvider);
              bool? isRefresh = ref.watch(isRefreshIndicator);
              bool isLoading = false;

              ref.read(adminDashListProvider.notifier).admnTtlCredit = ref
                  .read(adminDashListProvider.notifier)
                  .userList2!
                  .map((val) => val.totalCredit ?? 0.0)
                  .fold(
                      0,
                      (previousValue, element) =>
                          (previousValue ?? 0.0) + element ?? 0.0);
              ref.read(adminDashListProvider.notifier).admnTtlDebit = ref
                  .read(adminDashListProvider.notifier)
                  .userList2!
                  .map((val) => val.totalDebit ?? 0.0)
                  .fold(
                      0,
                      (previousValue, element) =>
                          (previousValue ?? 0.0) + element ?? 0.0);

              ref.read(adminDashListProvider.notifier).admnTtlIntCredit = ref
                  .read(adminDashListProvider.notifier)
                  .userList2!
                  .map((val) => val.totalIntCredit ?? 0.0)
                  .fold(
                      0,
                      (previousValue, element) =>
                          (previousValue ?? 0.0) + element ?? 0.0);

              ref.read(adminDashListProvider.notifier).admnTtlIntDebit = ref
                  .read(adminDashListProvider.notifier)
                  .userList2!
                  .map((val) => val.totalIntDebit ?? 0.0)
                  .fold(
                      0,
                      (previousValue, element) =>
                          (previousValue ?? 0.0) + element ?? 0.0);

              ref.read(adminDashListProvider.notifier).totalNet =
                  (ref.read(adminDashListProvider.notifier).admnTtlCredit ??
                          0.0) -
                      (ref.read(adminDashListProvider.notifier).admnTtlDebit ??
                          0.0);
//todo:- 1.9.23 changes
              ref.read(adminDashListProvider.notifier).totalNetInt = (ref
                          .read(adminDashListProvider.notifier)
                          .admnTtlIntCredit ??
                      0.0) -
                  (ref.read(adminDashListProvider.notifier).admnTtlIntDebit ??
                      0.0);

              // isRefreshIndicator = false;

              isLoading = (getAdminDashList.status == ResStatus.loading);
              return Container(
                color: Colors.white,
                height: 100.h,
                child: Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            expandedHeight: 22.h,
                            flexibleSpace: FlexibleSpaceBar(
                              background: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollController,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100.w,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8.0, 0.0, 8.0, 6.0),
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Card(
                                            elevation: 18,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          8.0, 8.0, 8.0, 8.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(12.0,
                                                                10.0, 0.0, 0.0),
                                                        child: Text(
                                                          FFLocalizations.of(
                                                                  context)
                                                              .getText(
                                                            'lfgx5yff' /* Net Balance */,
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'Outfit',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                letterSpacing:
                                                                    0.5,
                                                              ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    10.0,
                                                                    12.0,
                                                                    0.0),
                                                            child: Text(
                                                              ' ₹' +
                                                                  ref
                                                                      .read(adminDashListProvider
                                                                          .notifier)
                                                                      .totalNet!
                                                                      .toString(),
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                fontSize: 25.0,
                                                                letterSpacing:
                                                                    1.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(20.0, 15.0,
                                                          20.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        FFLocalizations.of(
                                                                context)
                                                            .getText(
                                                          'x2e1wpw3' /* Credited */,
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Outfit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.5,
                                                                ),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              '0qxzch1c' /* Debited */,
                                                            ),
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .headlineSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Outfit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.5,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          18, 10, 18, 0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      FFButtonWidget(
                                                        onPressed: () {
                                                          print(
                                                              'Button pressed ...');
                                                        },
                                                        text: '₹ ' +
                                                            ref
                                                                .read(adminDashListProvider
                                                                    .notifier)
                                                                .admnTtlCredit
                                                                .toString(),
                                                        options:
                                                            FFButtonOptions(
                                                          width: 100,
                                                          height: 40,
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 0, 0, 0),
                                                          iconPadding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 0, 0, 0),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          textStyle: TextStyle(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    .95),
                                                            letterSpacing: 0.5,
                                                            fontSize: 15,
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                      FFButtonWidget(
                                                        onPressed: () {},
                                                        text: '₹ ' +
                                                            ref
                                                                .read(adminDashListProvider
                                                                    .notifier)
                                                                .admnTtlDebit
                                                                .toString(),
                                                        options:
                                                            FFButtonOptions(
                                                          width: 100,
                                                          height: 40,
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 0, 0, 0),
                                                          iconPadding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 0, 0, 0),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          textStyle: TextStyle(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    .95),
                                                            letterSpacing: 0.5,
                                                            fontSize: 15,
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 100.w,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8.0, 0.0, 8.0, 6.0),
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Card(
                                            elevation: 18,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          8.0, 8.0, 8.0, 8.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(12.0,
                                                                10.0, 0.0, 0.0),
                                                        child: Text(
                                                          "Cashback",
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'Outfit',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                letterSpacing:
                                                                    0.5,
                                                              ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    10.0,
                                                                    12.0,
                                                                    0.0),
                                                            child: Text(
                                                              ' ₹' +
                                                                  ref
                                                                      .read(adminDashListProvider
                                                                          .notifier)
                                                                      .totalNetInt!
                                                                      .toStringAsFixed(
                                                                          2),
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                fontSize: 25.0,
                                                                letterSpacing:
                                                                    1.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(20.0, 15.0,
                                                          20.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Cashback Credited",
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Outfit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.5,
                                                                ),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            "Cashback Debited",
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .headlineSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Outfit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.5,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          18, 10, 18, 0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      FFButtonWidget(
                                                        onPressed: () {
                                                          print(
                                                              'Button pressed ...');
                                                        },
                                                        text: '₹ ' +
                                                            ref
                                                                .read(adminDashListProvider
                                                                    .notifier)
                                                                .admnTtlIntCredit!
                                                                .toStringAsFixed(
                                                                    2),
                                                        options:
                                                            FFButtonOptions(
                                                          width: 100,
                                                          height: 40,
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 0, 0, 0),
                                                          iconPadding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 0, 0, 0),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          textStyle: TextStyle(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    .95),
                                                            letterSpacing: 0.5,
                                                            fontSize: 15,
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                      FFButtonWidget(
                                                        onPressed: () {},
                                                        text: '₹ ' +
                                                            ref
                                                                .read(adminDashListProvider
                                                                    .notifier)
                                                                .admnTtlIntDebit!
                                                                .toStringAsFixed(
                                                                    2),
                                                        options:
                                                            FFButtonOptions(
                                                          width: 100,
                                                          height: 40,
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 0, 0, 0),
                                                          iconPadding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 0, 0, 0),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          textStyle: TextStyle(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    .95),
                                                            letterSpacing: 0.5,
                                                            fontSize: 15,
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
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
                          _selectedIndex == 0
                              ? SliverLayoutBuilder(
                                  builder: (BuildContext context,
                                      SliverConstraints constraints) {
                                    WidgetsBinding.instance!
                                        .addPostFrameCallback((_) {
                                      ref
                                              .read(adminDashListProvider.notifier)
                                              .admnTtlCredit =
                                          ref
                                              .read(adminDashListProvider
                                                  .notifier)
                                              .userList2!
                                              .map((val) =>
                                                  val.totalCredit ?? 0.0)
                                              .fold(
                                                  0,
                                                  (previousValue, element) =>
                                                      (previousValue ?? 0.0) +
                                                          element ??
                                                      0.0);
                                      ref
                                              .read(adminDashListProvider.notifier)
                                              .admnTtlDebit =
                                          ref
                                              .read(adminDashListProvider
                                                  .notifier)
                                              .userList2!
                                              .map((val) =>
                                                  val.totalDebit ?? 0.0)
                                              .fold(
                                                  0,
                                                  (previousValue, element) =>
                                                      (previousValue ?? 0.0) +
                                                          element ??
                                                      0.0);

                                      ref
                                              .read(adminDashListProvider.notifier)
                                              .admnTtlIntCredit =
                                          ref
                                              .read(adminDashListProvider
                                                  .notifier)
                                              .userList2!
                                              .map((val) =>
                                                  val.totalIntCredit ?? 0.0)
                                              .fold(
                                                  0,
                                                  (previousValue, element) =>
                                                      (previousValue ?? 0.0) +
                                                          element ??
                                                      0.0);

                                      ref
                                              .read(adminDashListProvider.notifier)
                                              .admnTtlIntDebit =
                                          ref
                                              .read(adminDashListProvider
                                                  .notifier)
                                              .userList2!
                                              .map((val) =>
                                                  val.totalIntDebit ?? 0.0)
                                              .fold(
                                                  0,
                                                  (previousValue, element) =>
                                                      (previousValue ?? 0.0) +
                                                          element ??
                                                      0.0);

                                      ref
                                          .read(adminDashListProvider.notifier)
                                          .totalNet = (ref
                                                  .read(adminDashListProvider
                                                      .notifier)
                                                  .admnTtlCredit ??
                                              0.0) -
                                          (ref
                                                  .read(adminDashListProvider
                                                      .notifier)
                                                  .admnTtlDebit ??
                                              0.0);
// todo:1.9.23 changes
                                      ref
                                          .read(adminDashListProvider.notifier)
                                          .totalNetInt = (ref
                                                  .read(adminDashListProvider
                                                      .notifier)
                                                  .admnTtlIntCredit ??
                                              0.0) -
                                          (ref
                                                  .read(adminDashListProvider
                                                      .notifier)
                                                  .admnTtlIntDebit ??
                                              0.0);
                                    });

                                    return SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                          final document = ref
                                              .read(
                                                  getListItemProvider.notifier)
                                              .state![index];

                                          final userType = document.userType;
                                          final name = document.name;
                                          final mobile = document.mobile;
                                          final securityCode =
                                              document.getSecurityCode;
                                          final total = document.getNetBal();
                                          final interest =
                                              document.getNetIntBal();
                                          final getAdminType =
                                              document.getAdminType;
                                          final isGoalsAdded =
                                              document.isUserSetupGoals;
                                          final isPendingPaymentFound =
                                              document.isPendingPayment;
                                          final userReffererNo =
                                              document.userReffererNo;
                                          final getUserType =
                                              document.userTypeDes;
                                          final getUserTypeId =
                                              document.userType;

                                          String? getDocId = document.docId;
                                          bool? isMoneyRequest =
                                              document.isMoneyRequest;
                                          double? requestAmnt =
                                              document.requestAmount;
                                          double? requestCashbckAmnt =
                                              document.requestCashbckAmount;

                                          bool? isNotificationByAdmin =
                                              document.isNotificationByAdmin;

                                          String? notificationToken =
                                              document.notificationToken;

                                          String getFinInt = interest == null
                                              ? 0.0.toString()
                                              : interest.toStringAsFixed(2);

                                          String? getPincode =
                                              document.getUserPincode;

                                          String? getReffererName =
                                              document.getUserReffererName;

                                          return Hero(
                                            tag: 'imageHero$index',
                                            child: Container(
                                              color: Colors.white
                                                  .withOpacity(0.95),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  elevation: 4.0,
                                                  child: Slidable(
                                                    key: const ValueKey(0),
                                                    endActionPane: ActionPane(
                                                      motion:
                                                          const ScrollMotion(),
                                                      children: [
                                                        SlidableAction(
                                                          onPressed: (context) {
                                                            String? documentId =
                                                                getDocId;

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
                                                                        "Alert!",
                                                                    descriptions:
                                                                        "Are you sure, Do you want to delete this User",
                                                                    text: "Ok",
                                                                    isCancel:
                                                                        true,
                                                                    onTap:
                                                                        () async {
                                                                      // User confirmed deletion, proceed with deleting the record

                                                                      if (ref.read(adminDashListProvider.notifier).data ==
                                                                          ConnectivityResult
                                                                              .none) {
                                                                        Constants.showToast(
                                                                            "No Internet Connection",
                                                                            ToastGravity.BOTTOM);
                                                                        return;
                                                                      }

                                                                      DocumentSnapshot snapshot = await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'users')
                                                                          .doc(
                                                                              documentId)
                                                                          .get();

                                                                      double?
                                                                          totalCredit;
                                                                      double?
                                                                          totalDebit;
                                                                      double?
                                                                          netTotal;
                                                                      double?
                                                                          totalIntCredit;
                                                                      double?
                                                                          totalIntDebit;
                                                                      double?
                                                                          netIntTotal;

                                                                      if (snapshot
                                                                          .exists) {
                                                                        Map<String,
                                                                                dynamic>
                                                                            data =
                                                                            snapshot.data()
                                                                                as Map<String, dynamic>;
                                                                        totalCredit =
                                                                            data['totalCredit']
                                                                                as double;
                                                                        totalDebit =
                                                                            data['totalDebit']
                                                                                as double;
                                                                        // netTotal = data[
                                                                        //         'netTotal']
                                                                        //     as double;
                                                                        totalIntCredit =
                                                                            data['totalIntCredit']
                                                                                as double;
                                                                        totalIntDebit =
                                                                            data['totalIntDebit']
                                                                                as double;
                                                                        // netIntTotal =
                                                                        //     data['netIntTotal']
                                                                        //         as double;
                                                                      }

                                                                      ref
                                                                          .read(adminDashListProvider
                                                                              .notifier)
                                                                          .firestore
                                                                          .collection(
                                                                              'users')
                                                                          .doc(
                                                                              documentId)
                                                                          .delete()
                                                                          .then(
                                                                              (value) async {
                                                                        QuerySnapshot adminSnapshot = await FirebaseFirestore
                                                                            .instance
                                                                            .collection('adminDetails')
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
                                                                            adminSnapshot.docs,
                                                                            (doc) async {
                                                                          Map<String, dynamic>
                                                                              data =
                                                                              doc.data() as Map<String, dynamic>;

                                                                          admnTtlCredit =
                                                                              data['totalCredit'] as double;
                                                                          admnTtlDebit =
                                                                              data['totalDebit'] as double;
                                                                          admnTtlIntCredit =
                                                                              data['totalIntCredit'] as double;
                                                                          admnTtlIntDebit =
                                                                              data['totalIntDebit'] as double;
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

                                                                        Map<String,
                                                                                dynamic>
                                                                            newAdminData =
                                                                            {};

                                                                        getFinalCredit =
                                                                            admnTtlCredit!.toDouble() -
                                                                                totalCredit!.toDouble();
                                                                        getFinalIntCredit =
                                                                            admnTtlIntCredit!.toDouble() -
                                                                                totalIntCredit!.toDouble();

                                                                        getFinalDebit =
                                                                            admnTtlDebit!.toDouble() -
                                                                                totalDebit!.toDouble();
                                                                        getFinalIntDedit =
                                                                            admnTtlIntDebit!.toDouble() -
                                                                                totalIntDebit!.toDouble();

                                                                        newAdminData =
                                                                            {
                                                                          'totalCredit':
                                                                              getFinalCredit.toDouble(),
                                                                          'totalIntCredit':
                                                                              getFinalIntCredit.toDouble(),
                                                                          'totalDebit':
                                                                              getFinalDebit.toDouble(),
                                                                          'totalIntDebit':
                                                                              getFinalIntDedit.toDouble(),
                                                                        };

                                                                        await updateAdminDetails(
                                                                            newAdminData);

                                                                        // if(widget.getUserType != "0"){
                                                                        //todo:- deletion based on user type, if buisness user deleted, his details in another collection should also deleted
                                                                        //todo: -commenting below code , because

                                                                        await deletionBasedOnUserType(
                                                                            mobile ??
                                                                                "",
                                                                            widget.getUserType ??
                                                                                "0");
                                                                        // }

                                                                        Navigator.pop(
                                                                            context); // Close the dialog
                                                                        // Perform any additional actions or show a success message
                                                                      }).catchError((error) =>
                                                                              print('Failed to delete data: $error'));
                                                                    },
                                                                  );
                                                                });
                                                          },
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFFFE4A49),
                                                          foregroundColor:
                                                              Colors.white,
                                                          icon: Icons.delete,
                                                          label: 'Delete',
                                                        ),
                                                        SlidableAction(
                                                          onPressed: (context) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => ChatScreen(
                                                                      userName: name
                                                                          .toString(),
                                                                      adminId:
                                                                          Constants
                                                                              .adminId,
                                                                      userId:
                                                                          mobile,
                                                                      callNo:
                                                                          mobile,
                                                                      getDocId:
                                                                          getDocId),
                                                                )).then((value) {});
                                                          },
                                                          backgroundColor:
                                                              Colors.lightGreen,
                                                          foregroundColor:
                                                              Colors.white,
                                                          icon: Icons.message,
                                                          label: 'Message',
                                                        ),
                                                        SlidableAction(
                                                          onPressed: (context) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          UserGoalHistory(
                                                                    getDocId:
                                                                        getDocId,
                                                                    getMobile:
                                                                        mobile,
                                                                    getNetBal:
                                                                        total,
                                                                    getUserName:
                                                                        name.toString(),
                                                                    getUserToken:
                                                                        notificationToken ??
                                                                            "",
                                                                  ),
                                                                )).then((value) {});
                                                          },
                                                          backgroundColor:
                                                              Colors.yellow,
                                                          foregroundColor:
                                                              Colors.black,
                                                          icon: Icons.flag,
                                                          label: 'Goals',
                                                        ),
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      child: ListTile(
                                                        leading: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              Card(
                                                                clipBehavior: Clip
                                                                    .antiAliasWithSaveLayer,
                                                                color: isPendingPaymentFound ??
                                                                        false
                                                                    ? Colors.red
                                                                    : FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                elevation: 6.0,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              40.0),
                                                                ),
                                                                child:
                                                                    const Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          8.0,
                                                                          8.0,
                                                                          8.0),
                                                                  child: Icon(
                                                                    Icons
                                                                        .person,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 24.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ]),
                                                        title: Text(
                                                          "$name "
                                                              .toUpperCase(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xFF004D40),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16.0,
                                                              letterSpacing:
                                                                  0.5),
                                                        ),
                                                        subtitle: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text('M-$mobile',
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
                                                            Text(
                                                                'RN-$getReffererName',
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
                                                            Text(
                                                                'RM-$userReffererNo',
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
                                                            Text(
                                                                "UT-$getUserType",
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
                                                            Text(
                                                                "PC -${(getPincode ?? "").isEmpty ? "N/A" : getPincode ?? "N/A"}",
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
                                                            Text(
                                                                "Payments -${(isPendingPaymentFound ?? false) ? "Pending" : "No Pending"}",
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

                                                          ],
                                                        ),
                                                        trailing: Container(
                                                          width: 100,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                  '$total' +
                                                                      ' ₹',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                              Text(
                                                                  '$getFinInt' +
                                                                      ' ₹',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .blueGrey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ],
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ShowUserWidget(
                                                                  getMobile:
                                                                      mobile,
                                                                  getExistingTotal:
                                                                      0.0,
                                                                  getDocId:
                                                                      getDocId,
                                                                  getUserName:
                                                                      name,
                                                                  getUserIndex:
                                                                      index,
                                                                  getSecurityCode:
                                                                      securityCode
                                                                          .toString(),
                                                                  getAdminType:
                                                                      getAdminType,
                                                                  getHeroTag:
                                                                      "imageHero$index",
                                                                  getuserType:
                                                                      userType ??
                                                                          "0",
                                                                ),
                                                              )).then((value) {});
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        // childCount: ref
                                        //         .read(adminDashListProvider
                                        //             .notifier)
                                        //         .userList2!
                                        //         .length ??
                                        //     0,
                                        childCount: ref
                                                .read(getListItemProvider
                                                    .notifier)
                                                .state!
                                                .length ??
                                            0,
                                      ),
                                    );
                                  },
                                )
                              : _selectedIndex == 1
                                  ? SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                          final document = ref
                                              .read(adminDashListProvider
                                                  .notifier)
                                              .moneyRequestUsers2?[index];

                                          final name = document?.name;
                                          final mobile = document?.mobile;
                                          final total = document?.getNetBal();
                                          final interest =
                                              document?.getNetIntBal();
                                          String? getDocId = document?.docId;
                                          bool? isMoneyRequest =
                                              document?.isMoneyRequest;
                                          double? requestAmnt =
                                              document?.requestAmount;
                                          double? requestCashbckAmnt =
                                              document?.requestCashbckAmount;

                                          return Container(
                                            color:
                                                Colors.white.withOpacity(0.95),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                elevation: 4.0,
                                                child: Slidable(
                                                  key: const ValueKey(0),
                                                  endActionPane: ActionPane(
                                                    motion:
                                                        const ScrollMotion(),
                                                    children: [
                                                      Visibility(
                                                        visible: isMoneyRequest!
                                                            ? true
                                                            : false,
                                                        child: SlidableAction(
                                                          onPressed: (context) {
                                                            String? documentId =
                                                                getDocId;

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
                                                                        "Alert!",
                                                                    descriptions:
                                                                        "Are you sure, Have you sent money",
                                                                    text: "Ok",
                                                                    isCancel:
                                                                        true,
                                                                    onTap: () {
                                                                      if (ref.read(adminDashListProvider.notifier).data ==
                                                                          ConnectivityResult
                                                                              .none) {
                                                                        Constants.showToast(
                                                                            "No Internet Connection",
                                                                            ToastGravity.BOTTOM);
                                                                        return;
                                                                      }
                                                                      ref.read(adminDashListProvider.notifier).updateData(
                                                                          getDocId,
                                                                          true);
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  );
                                                                });
                                                          },
                                                          backgroundColor:
                                                              Colors.green,
                                                          foregroundColor:
                                                              Colors.white,
                                                          icon: Icons
                                                              .currency_rupee,
                                                          label: isMoneyRequest!
                                                              ? 'paid'
                                                              : "UnPaid",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    child: ListTile(
                                                      leading: Card(
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        color: isMoneyRequest!
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .primary
                                                            : FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                        elevation: 6.0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      40.0),
                                                        ),
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      8.0,
                                                                      8.0,
                                                                      8.0,
                                                                      8.0),
                                                          child: Icon(
                                                            Icons.person,
                                                            color: Colors.white,
                                                            size: 24.0,
                                                          ),
                                                        ),
                                                      ),
                                                      title: Text(
                                                        name
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF004D40),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.0,
                                                            letterSpacing: 0.5),
                                                      ),
                                                      subtitle: Text(
                                                          '$total' + ' ₹',
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xFF004D40),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14.0,
                                                              letterSpacing:
                                                                  0.5)),
                                                      trailing: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                              isMoneyRequest!
                                                                  ? 'Requested'
                                                                  : "",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .lightGreen,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14.0,
                                                                  letterSpacing:
                                                                      0.5)),
                                                          Text(
                                                              isMoneyRequest!
                                                                  ? '$requestAmnt' +
                                                                      ' ₹'
                                                                  : "",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14.0,
                                                                  letterSpacing:
                                                                      0.5)),
                                                        ],
                                                      ),
                                                      onTap: () {},
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        childCount: ref
                                                .read(adminDashListProvider
                                                    .notifier)
                                                .moneyRequestUsers2
                                                ?.length ??
                                            0,
                                      ),
                                    )
                                  : _selectedIndex == 2
                                      ? SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index) {
                                              final document = ref
                                                  .read(adminDashListProvider
                                                      .notifier)
                                                  .notifications?[index];

                                              final name = document?.name;
                                              final mobile = document?.mobile;
                                              final total =
                                                  document?.getNetBal();
                                              final interest =
                                                  document?.getNetIntBal();
                                              String? getDocId =
                                                  document?.docId;
                                              bool? isNotificationByAdmin =
                                                  document
                                                      ?.isNotificationByAdmin;
                                              double? requestAmnt =
                                                  document?.requestAmount;
                                              double? requestCashbckAmount =
                                                  document
                                                      ?.requestCashbckAmount;
                                              String getFinInt = interest ==
                                                      null
                                                  ? 0.0.toString()
                                                  : interest.toStringAsFixed(2);

                                              return Container(
                                                color: Colors.white
                                                    .withOpacity(0.95),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    elevation: 4.0,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      child: ListTile(
                                                        leading: Card(
                                                          clipBehavior: Clip
                                                              .antiAliasWithSaveLayer,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          elevation: 6.0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40.0),
                                                          ),
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        8.0,
                                                                        8.0,
                                                                        8.0,
                                                                        8.0),
                                                            child: Icon(
                                                              Icons.person,
                                                              color:
                                                                  Colors.white,
                                                              size: 24.0,
                                                            ),
                                                          ),
                                                        ),
                                                        title: Text(
                                                          name
                                                              .toString()
                                                              .toUpperCase(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xFF004D40),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16.0,
                                                              letterSpacing:
                                                                  0.5),
                                                        ),
                                                        subtitle: Text(
                                                            '$mobile',
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
                                                        trailing: Container(
                                                          width: 100,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                  '$total' +
                                                                      ' ₹',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                              Text(
                                                                  '$getFinInt' +
                                                                      ' ₹',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ],
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => ChatScreen(
                                                                    userName: name
                                                                        .toString(),
                                                                    adminId:
                                                                        Constants
                                                                            .adminId,
                                                                    userId:
                                                                        mobile,
                                                                    callNo:
                                                                        mobile,
                                                                    getDocId:
                                                                        getDocId),
                                                              )).then((value) {});
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            childCount: ref
                                                    .read(adminDashListProvider
                                                        .notifier)
                                                    .notifications
                                                    ?.length ??
                                                0,
                                          ),
                                        )
                                      : _selectedIndex == 3
                                          ? SliverList(
                                              delegate:
                                                  SliverChildBuilderDelegate(
                                                (BuildContext context,
                                                    int index) {
                                                  final document = ref
                                                      .read(
                                                          adminDashListProvider
                                                              .notifier)
                                                      .enquiryList?[index];

                                                  final mobile =
                                                      document?.mobile;
                                                  final enquiryReason =
                                                      document?.enquiryReason;
                                                  final name = document?.name;
                                                  final refNumber =
                                                      document?.refNumber;

                                                  return Container(
                                                    color: Colors.white
                                                        .withOpacity(0.95),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        elevation: 4.0,
                                                        child: Slidable(
                                                          key:
                                                              const ValueKey(0),
                                                          endActionPane:
                                                              ActionPane(
                                                            motion:
                                                                const ScrollMotion(),
                                                            children: [
                                                              SlidableAction(
                                                                onPressed:
                                                                    (context) async {
                                                                  String?
                                                                      contactNo =
                                                                      mobile;
                                                                  final Uri
                                                                      launchUri =
                                                                      Uri(
                                                                    scheme:
                                                                        'tel',
                                                                    path:
                                                                        contactNo,
                                                                  );
                                                                  await launchUrl(
                                                                      launchUri);
                                                                },
                                                                backgroundColor:
                                                                    const Color(
                                                                        0xFFFE4A49),
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                icon: Icons
                                                                    .delete,
                                                                label: 'Call',
                                                              ),
                                                            ],
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            child: ListTile(
                                                              leading: Card(
                                                                clipBehavior: Clip
                                                                    .antiAliasWithSaveLayer,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                elevation: 6.0,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              40.0),
                                                                ),
                                                                child:
                                                                    const Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          8.0,
                                                                          8.0,
                                                                          8.0),
                                                                  child: Icon(
                                                                    Icons
                                                                        .person,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 24.0,
                                                                  ),
                                                                ),
                                                              ),
                                                              title: Text(
                                                                name
                                                                    .toString()
                                                                    .toUpperCase(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xFF004D40),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16.0,
                                                                    letterSpacing:
                                                                        0.5),
                                                              ),
                                                              subtitle: Text(
                                                                  '$mobile',
                                                                  overflow: TextOverflow
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
                                                              onTap: () {},
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                childCount: ref
                                                        .read(
                                                            adminDashListProvider
                                                                .notifier)
                                                        .enquiryList
                                                        ?.length ??
                                                    0,
                                              ),
                                            )
                                          : SliverList(
                                              delegate:
                                                  SliverChildBuilderDelegate(
                                                (BuildContext context,
                                                    int index) {
                                                  final document = ref
                                                      .read(
                                                          adminDashListProvider
                                                              .notifier)
                                                      .cashBckRequestUsers2?[index];

                                                  final name = document?.name;
                                                  final mobile =
                                                      document?.mobile;
                                                  final total =
                                                      document?.getNetBal();
                                                  final interest =
                                                      document?.getNetIntBal();
                                                  String modifyInt =
                                                      interest?.toStringAsFixed(
                                                              2) ??
                                                          '';
                                                  String finalInterest =
                                                      modifyInt + ' ₹';
                                                  String? getDocId =
                                                      document?.docId;
                                                  bool? isCashbckRequest =
                                                      document
                                                          ?.isCashBackRequest;
                                                  double? requestAmnt =
                                                      document?.requestAmount;
                                                  String? requestCashbckAmnt =
                                                      document
                                                          ?.requestCashbckAmount
                                                          ?.toStringAsFixed(2);
                                                  return Container(
                                                    color: Colors.white
                                                        .withOpacity(0.95),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        elevation: 4.0,
                                                        child: Slidable(
                                                          key:
                                                              const ValueKey(0),
                                                          endActionPane:
                                                              ActionPane(
                                                            motion:
                                                                const ScrollMotion(),
                                                            children: [
                                                              Visibility(
                                                                visible:
                                                                    isCashbckRequest!
                                                                        ? true
                                                                        : false,
                                                                child:
                                                                    SlidableAction(
                                                                  onPressed:
                                                                      (context) {
                                                                    String?
                                                                        documentId =
                                                                        getDocId;

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
                                                                                "Alert!",
                                                                            descriptions:
                                                                                "Are you sure, Have you sent money",
                                                                            text:
                                                                                "Ok",
                                                                            isCancel:
                                                                                true,
                                                                            onTap:
                                                                                () {
                                                                              if (ref.read(adminDashListProvider.notifier).data == ConnectivityResult.none) {
                                                                                Constants.showToast("No Internet Connection", ToastGravity.BOTTOM);
                                                                                return;
                                                                              }
                                                                              ref.read(adminDashListProvider.notifier).updateData(getDocId, false);
                                                                              Navigator.pop(context);
                                                                            },
                                                                          );
                                                                        });
                                                                  },
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                  foregroundColor:
                                                                      Colors
                                                                          .white,
                                                                  icon: Icons
                                                                      .currency_rupee,
                                                                  label: isCashbckRequest!
                                                                      ? 'paid'
                                                                      : "UnPaid",
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            child: ListTile(
                                                              leading: Card(
                                                                clipBehavior: Clip
                                                                    .antiAliasWithSaveLayer,
                                                                color: isCashbckRequest!
                                                                    ? FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary
                                                                    : FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                elevation: 6.0,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              40.0),
                                                                ),
                                                                child:
                                                                    const Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          8.0,
                                                                          8.0,
                                                                          8.0),
                                                                  child: Icon(
                                                                    Icons
                                                                        .person,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 24.0,
                                                                  ),
                                                                ),
                                                              ),
                                                              title: Text(
                                                                name
                                                                    .toString()
                                                                    .toUpperCase(),
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xFF004D40),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14.0,
                                                                    letterSpacing:
                                                                        0.5),
                                                              ),
                                                              subtitle: Text(
                                                                  finalInterest,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                              trailing: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                      isCashbckRequest!
                                                                          ? 'Requested'
                                                                          : "",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .lightGreen,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              14.0,
                                                                          letterSpacing:
                                                                              0.5)),
                                                                  Text(
                                                                      isCashbckRequest!
                                                                          ? '$requestCashbckAmnt' +
                                                                              ' ₹'
                                                                          : "",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              14.0,
                                                                          letterSpacing:
                                                                              0.5)),
                                                                ],
                                                              ),
                                                              onTap: () {},
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                childCount: ref
                                                        .read(
                                                            adminDashListProvider
                                                                .notifier)
                                                        .cashBckRequestUsers2
                                                        ?.length ??
                                                    0,
                                              ),
                                            ),
                        ],
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
                  ],
                ),
              );
            })),
          ),
          floatingActionButton: Visibility(
            visible: _isNavigationBarVisible ? true : false,
            child: FloatingActionButton(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdduserWidget(),
                  ),
                ).then((value) {
                  //todo:- below code refresh firebase records automatically when come back to same screen
                  // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                });
              },
              child: Icon(
                Icons.person_add_alt,
                color: FlutterFlowTheme.of(context).primaryBtnText,
                size: 24.0,
              ),
            ),
          ),
          bottomNavigationBar: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: _isNavigationBarVisible ? 70.0 : 0.0,
            child: Center(
              child: Consumer(builder: (context, ref, child) {
                int? isPendingRequest = ref.watch(isPendingReq);
                int? isPendingCshbckReq = ref.watch(isPendingCashbckReq);
                int? isPendingMessage = ref.watch(isPendingMessages);

                return SingleChildScrollView(
                  child: BottomNavigationBar(
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Image.asset(
                          'images/final/Admin/Dashboard/users.png',
                          fit: BoxFit.contain,
                          height: 25,
                          width: 25,
                        ),
                        label: "Users",
                        backgroundColor: FlutterFlowTheme.of(context).primary,
                      ),
                      BottomNavigationBarItem(
                        icon: Stack(alignment: Alignment.center, children: [
                          Image.asset(
                            'images/final/Admin/Dashboard/moneyReq.png',
                            fit: BoxFit.contain,
                            height: 25,
                            width: 25,
                          ),
                          Visibility(
                            visible: isPendingRequest == 0 ? false : true,
                            child: Positioned(
                              right: -5,
                              top: -5,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  "1",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ]),
                        label: "Money Request",
                        backgroundColor: FlutterFlowTheme.of(context)
                            .primary
                            .withOpacity(0.95),
                      ),
                      BottomNavigationBarItem(
                        icon: Stack(alignment: Alignment.center, children: [
                          Image.asset(
                            'images/final/Admin/Dashboard/message.png',
                            fit: BoxFit.contain,
                            height: 25,
                            width: 25,
                          ),
                          Visibility(
                            visible: isPendingMessage == 0 ? false : true,
                            child: Positioned(
                              right: -5,
                              top: -5,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  "1",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ]),
                        label: "Messages",
                        backgroundColor: FlutterFlowTheme.of(context)
                            .primary
                            .withOpacity(0.95),
                      ),
                      BottomNavigationBarItem(
                        icon: Stack(alignment: Alignment.center, children: [
                          Image.asset(
                            'images/final/Admin/Dashboard/enquiry.png',
                            fit: BoxFit.contain,
                            height: 25,
                            width: 25,
                          ),
                        ]),
                        label: "Enquiry",
                        backgroundColor: FlutterFlowTheme.of(context)
                            .primary
                            .withOpacity(0.95),
                      ),
                      BottomNavigationBarItem(
                        icon: Stack(alignment: Alignment.center, children: [
                          Image.asset(
                            'images/final/Admin/Dashboard/cashback.png',
                            fit: BoxFit.contain,
                            height: 25,
                            width: 25,
                          ),
                          Visibility(
                            visible: isPendingCshbckReq == 0 ? false : true,
                            child: Positioned(
                              right: -5,
                              top: -5,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  "1",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ]),
                        label: "Cashback",
                        backgroundColor: FlutterFlowTheme.of(context)
                            .primary
                            .withOpacity(0.95),
                      )
                    ],
                    type: BottomNavigationBarType.shifting,
                    currentIndex: _selectedIndex,
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.greenAccent,
                    iconSize: 40,
                    onTap: _onBottomItemTapped,
                    elevation: 5,
                  ),
                );
              }),
            ),
          ),
        );

      case "1": // meat shop owner
        return Scaffold(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              widget.getAdminMobileNo ?? "",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Constants.primary,
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(
              color: Constants
                  .secondary, // Change the color of the drawer icon here
            ),
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            child: NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
              if (notification.direction == ScrollDirection.forward) {
                _toggleNavigationBarVisibility(false);
              } else if (notification.direction == ScrollDirection.reverse) {
                _toggleNavigationBarVisibility(true);
              }
              return true;
            }, child: Consumer(builder: (context, ref, child) {
              ref.read(adminDashListProvider.notifier).data =
                  ref.watch(connectivityProvider);
              // AdminDashState getAdminDashList = ref.watch(adminDashListProvider);
              AdminDashState2 getAdminDashList =
                  ref.watch(adminDashListProvider);
              ref.watch(getListItemProvider);
              bool? isRefresh = ref.watch(isRefreshIndicator);
              bool isLoading = false;

              ref.read(adminDashListProvider.notifier).admnTtlCredit = ref
                  .read(adminDashListProvider.notifier)
                  .userList2!
                  .map((val) => val.totalCredit ?? 0.0)
                  .fold(
                      0,
                      (previousValue, element) =>
                          (previousValue ?? 0.0) + element ?? 0.0);
              ref.read(adminDashListProvider.notifier).admnTtlDebit = ref
                  .read(adminDashListProvider.notifier)
                  .userList2!
                  .map((val) => val.totalDebit ?? 0.0)
                  .fold(
                      0,
                      (previousValue, element) =>
                          (previousValue ?? 0.0) + element ?? 0.0);

              ref.read(adminDashListProvider.notifier).admnTtlIntCredit = ref
                  .read(adminDashListProvider.notifier)
                  .userList2!
                  .map((val) => val.totalIntCredit ?? 0.0)
                  .fold(
                      0,
                      (previousValue, element) =>
                          (previousValue ?? 0.0) + element ?? 0.0);

              ref.read(adminDashListProvider.notifier).admnTtlIntDebit = ref
                  .read(adminDashListProvider.notifier)
                  .userList2!
                  .map((val) => val.totalIntDebit ?? 0.0)
                  .fold(
                      0,
                      (previousValue, element) =>
                          (previousValue ?? 0.0) + element ?? 0.0);

              ref.read(adminDashListProvider.notifier).totalNet =
                  (ref.read(adminDashListProvider.notifier).admnTtlCredit ??
                          0.0) -
                      (ref.read(adminDashListProvider.notifier).admnTtlDebit ??
                          0.0);
//todo:- 1.9.23 changes
              ref.read(adminDashListProvider.notifier).totalNetInt = (ref
                          .read(adminDashListProvider.notifier)
                          .admnTtlIntCredit ??
                      0.0) -
                  (ref.read(adminDashListProvider.notifier).admnTtlIntDebit ??
                      0.0);

              // isRefreshIndicator = false;

              isLoading = (getAdminDashList.status == ResStatus.loading);
              return Container(
                color: Colors.white,
                height: 100.h,
                child: Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: CustomScrollView(
                        slivers: [
                          SliverLayoutBuilder(
                            builder: (BuildContext context,
                                SliverConstraints constraints) {
                              WidgetsBinding.instance!
                                  .addPostFrameCallback((_) {
                                ref
                                        .read(adminDashListProvider.notifier)
                                        .admnTtlCredit =
                                    ref
                                        .read(adminDashListProvider.notifier)
                                        .userList2!
                                        .map((val) => val.totalCredit ?? 0.0)
                                        .fold(
                                            0,
                                            (previousValue, element) =>
                                                (previousValue ?? 0.0) +
                                                    element ??
                                                0.0);
                                ref
                                        .read(adminDashListProvider.notifier)
                                        .admnTtlDebit =
                                    ref
                                        .read(adminDashListProvider.notifier)
                                        .userList2!
                                        .map((val) => val.totalDebit ?? 0.0)
                                        .fold(
                                            0,
                                            (previousValue, element) =>
                                                (previousValue ?? 0.0) +
                                                    element ??
                                                0.0);

                                ref
                                        .read(adminDashListProvider.notifier)
                                        .admnTtlIntCredit =
                                    ref
                                        .read(adminDashListProvider.notifier)
                                        .userList2!
                                        .map((val) => val.totalIntCredit ?? 0.0)
                                        .fold(
                                            0,
                                            (previousValue, element) =>
                                                (previousValue ?? 0.0) +
                                                    element ??
                                                0.0);

                                ref
                                        .read(adminDashListProvider.notifier)
                                        .admnTtlIntDebit =
                                    ref
                                        .read(adminDashListProvider.notifier)
                                        .userList2!
                                        .map((val) => val.totalIntDebit ?? 0.0)
                                        .fold(
                                            0,
                                            (previousValue, element) =>
                                                (previousValue ?? 0.0) +
                                                    element ??
                                                0.0);

                                ref
                                    .read(adminDashListProvider.notifier)
                                    .totalNet = (ref
                                            .read(
                                                adminDashListProvider.notifier)
                                            .admnTtlCredit ??
                                        0.0) -
                                    (ref
                                            .read(
                                                adminDashListProvider.notifier)
                                            .admnTtlDebit ??
                                        0.0);
// todo:1.9.23 changes
                                ref
                                    .read(adminDashListProvider.notifier)
                                    .totalNetInt = (ref
                                            .read(
                                                adminDashListProvider.notifier)
                                            .admnTtlIntCredit ??
                                        0.0) -
                                    (ref
                                            .read(
                                                adminDashListProvider.notifier)
                                            .admnTtlIntDebit ??
                                        0.0);
                              });

                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    final document = ref
                                        .read(getListItemProvider.notifier)
                                        .state![index];

                                    final userType = document.userType;
                                    final reffererNo = document.userReffererNo;
                                    final name = document.name;
                                    final mobile = document.mobile;

                                    print(
                                        "user mob $reffererNo/ reffere mob ${widget.getAdminMobileNo}");

                                    final securityCode =
                                        document.getSecurityCode;
                                    final total = document.getNetBal();
                                    final interest = document.getNetIntBal();
                                    final getAdminType = document.getAdminType;
                                    final isGoalsAdded =
                                        document.isUserSetupGoals;
                                    final isPendingPaymentFound =
                                        document.isPendingPayment;

                                    String? getDocId = document.docId;
                                    bool? isMoneyRequest =
                                        document.isMoneyRequest;
                                    double? requestAmnt =
                                        document.requestAmount;
                                    double? requestCashbckAmnt =
                                        document.requestCashbckAmount;

                                    bool? isNotificationByAdmin =
                                        document.isNotificationByAdmin;

                                    String? notificationToken =
                                        document.notificationToken;

                                    String getFinInt = interest == null
                                        ? 0.0.toString()
                                        : interest.toStringAsFixed(2);

                                    return (reffererNo ?? "") ==
                                            widget.getAdminMobileNo
                                        ? Container(
                                            color:
                                                Colors.white.withOpacity(0.95),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child:
                                                  (reffererNo ?? "") ==
                                                          widget
                                                              .getAdminMobileNo
                                                      ? Card(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          elevation: 4.0,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            child: ListTile(
                                                              leading: Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  children: [
                                                                    Card(
                                                                      clipBehavior:
                                                                          Clip.antiAliasWithSaveLayer,
                                                                      color: isPendingPaymentFound ??
                                                                              false
                                                                          ? Colors
                                                                              .red
                                                                          : FlutterFlowTheme.of(context)
                                                                              .primary,
                                                                      elevation:
                                                                          6.0,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(40.0),
                                                                      ),
                                                                      child:
                                                                          const Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            8.0,
                                                                            8.0,
                                                                            8.0,
                                                                            8.0),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .person,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              24.0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                              title: Text(
                                                                name
                                                                    .toString()
                                                                    .toUpperCase(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xFF004D40),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16.0,
                                                                    letterSpacing:
                                                                        0.5),
                                                              ),
                                                              subtitle: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text('$mobile',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade600,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.5)),
                                                                ],
                                                              ),
                                                              onTap: () {},
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),
                                            ),
                                          )
                                        : Container();
                                  },
                                  // childCount: ref
                                  //         .read(adminDashListProvider
                                  //             .notifier)
                                  //         .userList2!
                                  //         .length ??
                                  //     0,
                                  childCount: ref
                                          .read(getListItemProvider.notifier)
                                          .state!
                                          .length ??
                                      0,
                                ),
                              );
                            },
                          )
                        ],
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
                  ],
                ),
              );
            })),
          ),
        );

      default:
        return Scaffold(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              widget.getAdminMobileNo ?? "",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Constants.primary,
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(
              color: Constants
                  .secondary, // Change the color of the drawer icon here
            ),
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            child: NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
              if (notification.direction == ScrollDirection.forward) {
                _toggleNavigationBarVisibility(false);
              } else if (notification.direction == ScrollDirection.reverse) {
                _toggleNavigationBarVisibility(true);
              }
              return true;
            }, child: Consumer(builder: (context, ref, child) {
              ref.read(adminDashListProvider.notifier).data =
                  ref.watch(connectivityProvider);
              // AdminDashState getAdminDashList = ref.watch(adminDashListProvider);
              AdminDashState2 getAdminDashList =
                  ref.watch(adminDashListProvider);
              ref.watch(getListItemProvider);
              bool? isRefresh = ref.watch(isRefreshIndicator);
              bool isLoading = false;

              ref.read(adminDashListProvider.notifier).admnTtlCredit = ref
                  .read(adminDashListProvider.notifier)
                  .userList2!
                  .map((val) => val.totalCredit ?? 0.0)
                  .fold(
                      0,
                      (previousValue, element) =>
                          (previousValue ?? 0.0) + element ?? 0.0);
              ref.read(adminDashListProvider.notifier).admnTtlDebit = ref
                  .read(adminDashListProvider.notifier)
                  .userList2!
                  .map((val) => val.totalDebit ?? 0.0)
                  .fold(
                      0,
                      (previousValue, element) =>
                          (previousValue ?? 0.0) + element ?? 0.0);

              ref.read(adminDashListProvider.notifier).admnTtlIntCredit = ref
                  .read(adminDashListProvider.notifier)
                  .userList2!
                  .map((val) => val.totalIntCredit ?? 0.0)
                  .fold(
                      0,
                      (previousValue, element) =>
                          (previousValue ?? 0.0) + element ?? 0.0);

              ref.read(adminDashListProvider.notifier).admnTtlIntDebit = ref
                  .read(adminDashListProvider.notifier)
                  .userList2!
                  .map((val) => val.totalIntDebit ?? 0.0)
                  .fold(
                      0,
                      (previousValue, element) =>
                          (previousValue ?? 0.0) + element ?? 0.0);

              ref.read(adminDashListProvider.notifier).totalNet =
                  (ref.read(adminDashListProvider.notifier).admnTtlCredit ??
                          0.0) -
                      (ref.read(adminDashListProvider.notifier).admnTtlDebit ??
                          0.0);
//todo:- 1.9.23 changes
              ref.read(adminDashListProvider.notifier).totalNetInt = (ref
                          .read(adminDashListProvider.notifier)
                          .admnTtlIntCredit ??
                      0.0) -
                  (ref.read(adminDashListProvider.notifier).admnTtlIntDebit ??
                      0.0);

              // isRefreshIndicator = false;

              isLoading = (getAdminDashList.status == ResStatus.loading);
              return Container(
                color: Colors.white,
                height: 100.h,
                child: Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: CustomScrollView(
                        slivers: [
                          SliverLayoutBuilder(
                            builder: (BuildContext context,
                                SliverConstraints constraints) {
                              WidgetsBinding.instance!
                                  .addPostFrameCallback((_) {
                                ref
                                        .read(adminDashListProvider.notifier)
                                        .admnTtlCredit =
                                    ref
                                        .read(adminDashListProvider.notifier)
                                        .userList2!
                                        .map((val) => val.totalCredit ?? 0.0)
                                        .fold(
                                            0,
                                            (previousValue, element) =>
                                                (previousValue ?? 0.0) +
                                                    element ??
                                                0.0);
                                ref
                                        .read(adminDashListProvider.notifier)
                                        .admnTtlDebit =
                                    ref
                                        .read(adminDashListProvider.notifier)
                                        .userList2!
                                        .map((val) => val.totalDebit ?? 0.0)
                                        .fold(
                                            0,
                                            (previousValue, element) =>
                                                (previousValue ?? 0.0) +
                                                    element ??
                                                0.0);

                                ref
                                        .read(adminDashListProvider.notifier)
                                        .admnTtlIntCredit =
                                    ref
                                        .read(adminDashListProvider.notifier)
                                        .userList2!
                                        .map((val) => val.totalIntCredit ?? 0.0)
                                        .fold(
                                            0,
                                            (previousValue, element) =>
                                                (previousValue ?? 0.0) +
                                                    element ??
                                                0.0);

                                ref
                                        .read(adminDashListProvider.notifier)
                                        .admnTtlIntDebit =
                                    ref
                                        .read(adminDashListProvider.notifier)
                                        .userList2!
                                        .map((val) => val.totalIntDebit ?? 0.0)
                                        .fold(
                                            0,
                                            (previousValue, element) =>
                                                (previousValue ?? 0.0) +
                                                    element ??
                                                0.0);

                                ref
                                    .read(adminDashListProvider.notifier)
                                    .totalNet = (ref
                                            .read(
                                                adminDashListProvider.notifier)
                                            .admnTtlCredit ??
                                        0.0) -
                                    (ref
                                            .read(
                                                adminDashListProvider.notifier)
                                            .admnTtlDebit ??
                                        0.0);
// todo:1.9.23 changes
                                ref
                                    .read(adminDashListProvider.notifier)
                                    .totalNetInt = (ref
                                            .read(
                                                adminDashListProvider.notifier)
                                            .admnTtlIntCredit ??
                                        0.0) -
                                    (ref
                                            .read(
                                                adminDashListProvider.notifier)
                                            .admnTtlIntDebit ??
                                        0.0);
                              });

                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    final document = ref
                                        .read(getListItemProvider.notifier)
                                        .state![index];

                                    final userType = document.userType;
                                    final reffererNo = document.userReffererNo;
                                    final name = document.name;
                                    final mobile = document.mobile;

                                    print(
                                        "user mob $reffererNo/ reffere mob ${widget.getAdminMobileNo}");

                                    final securityCode =
                                        document.getSecurityCode;
                                    final total = document.getNetBal();
                                    final interest = document.getNetIntBal();
                                    final getAdminType = document.getAdminType;
                                    final isGoalsAdded =
                                        document.isUserSetupGoals;
                                    final isPendingPaymentFound =
                                        document.isPendingPayment;

                                    String? getDocId = document.docId;
                                    bool? isMoneyRequest =
                                        document.isMoneyRequest;
                                    double? requestAmnt =
                                        document.requestAmount;
                                    double? requestCashbckAmnt =
                                        document.requestCashbckAmount;

                                    bool? isNotificationByAdmin =
                                        document.isNotificationByAdmin;

                                    String? notificationToken =
                                        document.notificationToken;

                                    String getFinInt = interest == null
                                        ? 0.0.toString()
                                        : interest.toStringAsFixed(2);

                                    return (reffererNo ?? "") ==
                                            widget.getAdminMobileNo
                                        ? Container(
                                            color:
                                                Colors.white.withOpacity(0.95),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child:
                                                  (reffererNo ?? "") ==
                                                          widget
                                                              .getAdminMobileNo
                                                      ? Card(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          elevation: 4.0,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            child: ListTile(
                                                              leading: Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  children: [
                                                                    Card(
                                                                      clipBehavior:
                                                                          Clip.antiAliasWithSaveLayer,
                                                                      color: isPendingPaymentFound ??
                                                                              false
                                                                          ? Colors
                                                                              .red
                                                                          : FlutterFlowTheme.of(context)
                                                                              .primary,
                                                                      elevation:
                                                                          6.0,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(40.0),
                                                                      ),
                                                                      child:
                                                                          const Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            8.0,
                                                                            8.0,
                                                                            8.0,
                                                                            8.0),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .person,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              24.0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                              title: Text(
                                                                name
                                                                    .toString()
                                                                    .toUpperCase(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xFF004D40),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16.0,
                                                                    letterSpacing:
                                                                        0.5),
                                                              ),
                                                              subtitle: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text('$mobile',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade600,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.5)),
                                                                ],
                                                              ),
                                                              onTap: () {},
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),
                                            ),
                                          )
                                        : Container();
                                  },
                                  // childCount: ref
                                  //         .read(adminDashListProvider
                                  //             .notifier)
                                  //         .userList2!
                                  //         .length ??
                                  //     0,
                                  childCount: ref
                                          .read(getListItemProvider.notifier)
                                          .state!
                                          .length ??
                                      0,
                                ),
                              );
                            },
                          )
                        ],
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
                  ],
                ),
              );
            })),
          ),
        );
    }
  }

  void _showBottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildBottomSheetContent(
          context,
        );
      },
    ).whenComplete(() {
      // Reset focus when the bottom sheet is closed
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  Widget _buildBottomSheetContent(
    BuildContext context,
  ) {
    return SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          // Add your desired height to the container
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Amount to Request from Customers!",
                style: TextStyle(
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    letterSpacing: 1),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: txtReqAmount,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter amount',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      double amount = txtReqAmount.text.isEmpty
                          ? 0
                          : double.parse(txtReqAmount.text);
                      if (amount != 0) {
                        //todo:- 19.6.24, post common notification with image
                        // Response? res = await NotificationService
                        //     .postCustomNotificationWithImage(
                        //         "cyNUeg_XRWiNcTlxTrHd1B:APA91bEvDxlMXQawgNO0Kv801u4ZgPWwoO_Zb-G44pCyEKBYoZcbfPBepBPRsp8Oj5W2xwyp61L-CDzDfhwdHWORuSU5xAhRhWJTVY_Amtq-au71Yl_QmL8uFwCsP6Wsq6SZ1qQJ8_n1",
                        //         "Earn While You Shop – Shopping into Earnings💵₹💰",
                        //         "Maaka Adds Commision for your Purchase - Just Try It",
                        //         "https://drive.google.com/file/d/1rU-Okb9Xwokt1BbSoC-VJ-9qm5mVdaW3/view?usp=drivesdk");

                        //todo:- Some of Drive links for image / common notification
                        /// 1. retailors apps banner = cyNUeg_XRWiNcTlxTrHd1B:APA91bEvDxlMXQawgNO0Kv801u4ZgPWwoO_Zb-G44pCyEKBYoZcbfPBepBPRsp8Oj5W2xwyp61L-CDzDfhwdHWORuSU5xAhRhWJTVY_Amtq-au71Yl_QmL8uFwCsP6Wsq6SZ1qQJ8_n1

                        ///important:- uncomment below line / it is regular money request notification
                        Response? res =
                            await NotificationService.postNotificationWithImage(
                                "Send Rs.$amount Now,\nLet Us Save Your Money! 💰",
                                "Maaka: Your Money Saving Partner🖖🏻👥✨\nSaving is Earning.😎😍🥳",
                                null);

                        if (res?.statusCode == 200) {
                          txtReqAmount.text = "";
                          Constants.showToast("Amount Requested Successfully!",
                              ToastGravity.CENTER);
                        } else {
                          txtReqAmount.text = "";
                          Constants.showToast("Problem in Requesting Amount!",
                              ToastGravity.CENTER);
                        }

                        Navigator.pop(context);
                      } else {
                        Constants.showToast(
                            txtReqAmount.text.isEmpty
                                ? "Please Enter Amount"
                                : "Please Enter Valid Amount",
                            ToastGravity.CENTER);
                        return;
                      }
                    },
                    child: Text('Request'),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  // postNotificationRequest(String? amount) async {
  //   Response? res;
  //   var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
  //
  //   try {
  //     var response = await http.Client().post(url,
  //         body: jsonEncode({
  //           "to": "/topics/all",
  //           "priority": "high",
  //           "notification": {
  //             "title": "Send Rs.$amount Now,\nLet Us Save Your Money! 💰",
  //             "body":
  //                 "Maaka: Your Money Saving Partner🖖🏻👥✨\nSaving is Earning.😎😍🥳",
  //           },
  //           "data": {
  //             "custom_key":
  //                 "custom_value" // Optional: You can include custom data here
  //           }
  //         }),
  //         headers: {
  //           "Accept": "application/json",
  //           "Content-type": "application/json",
  //           "Authorization":
  //               "key=AAAAb-_MBP8:APA91bFubSJ4pOcNkYMD9uFXekSyOQel1Mzojc1Q7noOPRiR-WNu_C_FgoZ-lQ6Maa1A52NqAoLM7tdQTZ7nEeXs_WUhhqjUg5B0P2lCp2rf95PxdR0PaOSVZUz8UeWJArogfm3gFKRp",
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
  //   print("res <- ${res.resBody.toString()}");
  //   return res;
  // }

  //todo:- add this code snippet for adding new field to firestore collection
  Future<void> addNewFieldToDocuments() async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('AreaFoodPrices');

    final QuerySnapshot snapshot = await collectionRef.get();

    final List<DocumentSnapshot> documents = snapshot.docs;

    // Loop through each document and add a new field
    for (final DocumentSnapshot document in documents) {
      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      // Check if the new field doesn't exist already
      if (!data.containsKey('foodAdminNo')) {
        // Add the new field to the data
        data['foodAdminNo'] = "";

        // Update the document with the new field
        await document.reference.update(data);
      }
      // Add the new field to the data
      // data['nominName'] = "";
      // data['nominMobile'] = "";
      //
      // // Update the document with the new field
      // await document.reference.update(data);
    }
  }

  Future<void> addNewFieldToTransactions() async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('users');

    final QuerySnapshot snapshot = await collectionRef.get();

    final List<DocumentSnapshot> documents = snapshot.docs;

    for (final DocumentSnapshot document in documents) {
      final String userId = document.id;

      // Create a reference to the 'transactions' subcollection
      final CollectionReference transactionRef =
          collectionRef.doc(userId).collection('meatorder');

      // Query for all documents within the 'transactions' subcollection
      final QuerySnapshot transactionSnapshot = await transactionRef.get();

      final List<DocumentSnapshot> transactionDocuments =
          transactionSnapshot.docs;

      // Loop through each transaction document and add a new field
      for (final DocumentSnapshot transactionDocument in transactionDocuments) {
        final Map<String, dynamic> data =
            transactionDocument.data() as Map<String, dynamic>;

        // Add the new field to the data
        data['paymentStatus'] = "";
        data['deliveryAddress'] = "";
        data['remarks'] = "";

        // Update the transaction document with the new field
        await transactionDocument.reference.update(data);
      }
    }
  }

  //todo:- 28.8.23 to rename existing field
  Future<void> renameFieldInDocuments() async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('users');

    final QuerySnapshot snapshot = await collectionRef.get();

    final List<DocumentSnapshot> documents = snapshot.docs;

    // Loop through each document and rename the existing field
    for (final DocumentSnapshot document in documents) {
      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      // Check if the old field name exists and the new field name doesn't
      if (data.containsKey('isVerified') &&
          !data.containsKey('isPendingPayment')) {
        // Create a copy of the data without the old field
        final Map<String, dynamic> updatedData = Map.from(data);
        updatedData['isPendingPayment'] = updatedData['isVerified'];
        updatedData.remove('isVerified');

        // Update the document with the renamed field
        await document.reference.update(updatedData);
      }
    }
  }

  //todo:- 28.1.24 update new value to existing field
  Future<void> updateDefaultValues() async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('users');

    final QuerySnapshot snapshot = await collectionRef.get();

    final List<DocumentSnapshot> documents = snapshot.docs;

    // Loop through each document and update values to false
    for (final DocumentSnapshot document in documents) {
      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      // Update the value for 'isVerified' to false
      data['reffererNumber'] = "+919941445471";

      // Update the document with the new values
      await document.reference.update(data);
    }
  }

//todo:- 28.8.23 to delete existing field
  Future<void> deleteFieldInDocuments() async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('users');

    final QuerySnapshot snapshot = await collectionRef.get();

    final List<DocumentSnapshot> documents = snapshot.docs;

    // Loop through each document and delete the specific field
    for (final DocumentSnapshot document in documents) {
      // Get the document reference
      final DocumentReference docRef = collectionRef.doc(document.id);

      // Update the document by removing the field
      await docRef.update({'mappedAdmin': FieldValue.delete()});
    }
  }

  Future<void> updateAllMeatPrices() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference areaMeatPricesRef =
        firestore.collection('AreaMeatPrices');

    try {
      // Fetch all documents in the AreaMeatPrices collection
      QuerySnapshot snapshot = await areaMeatPricesRef.get();

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        String docId = doc.id; // Get each document ID

        // Reference to the document directly inside AreaMeatPrices
        DocumentReference meatPricesRef = areaMeatPricesRef.doc(docId);

        // Data to add under the field name same as the document ID
        Map<String, dynamic> newMeatPrices = {
          docId: {
            // Field name is the same as document ID
            'ChickenBoneless': {
              'AreaPrice': "100",
              'OurPrice': "100",
            },
            'ChickenLegPiece': {
              'AreaPrice': "100",
              'OurPrice': "100",
            },
            'ChickenChestPiece': {
              'AreaPrice': "100",
              'OurPrice': "100",
            },
            'MuttonLiver': {
              'AreaPrice': "100",
              'OurPrice': "100",
            },
            'MuttonBoneless': {
              'AreaPrice': "100",
              'OurPrice': "100",
            },
          }
        };

        // Update Firestore without overwriting existing data
        await meatPricesRef.set(newMeatPrices, SetOptions(merge: true));
      }

      print("All documents updated successfully!");
    } catch (e) {
      print("Error updating documents: $e");
    }
  }

  //todo:- 30.11.23 to add new collection with document and fields
  Future<void> addNewCollectionWithDocument() async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('MaakaAdminAccess');

    final Map<String, dynamic> newData = {
      'meatBasketAdmin': '1234598765',
      'maakaAdminPrimary': '0805080588',
      'maakaAdminSecondary': '0805080508',
      // Replace 'your_token_value' with the actual token value
    };

    // Add a new document with the specified data
    await collectionRef.add(newData);
  }

//todo:- 30.11.23 get current token value in collection
  Future<void> getDocumentIDsAndData() async {
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
    }
  }

  //todo:- 30.11.23 update new value to admin token
  Future<void> updateAdminToken(String getNewToken) async {
    try {
      QuerySnapshot snapshot = await _collectionRefToken!.limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        String documentId = snapshot.docs.first.id;
        await _collectionRefToken!.doc(documentId).update({
          'token': getNewToken,
        });
      } else {
        // Handle the case where no document is found
        print('No document found to update');
      }
    } catch (e) {
      // Handle the error when updating the admin token
      print('Error updating admin token: $e');
      // You might want to throw an exception or handle the error in some way
    }
  }

  Future<void> _handleRefresh() async {
    // isRefreshIndicator = true;
    //on refresh , fetch meat orders again

    ref.read(isRefreshIndicator.notifier).state = true;
    return ref.read(adminDashListProvider.notifier).getDashboardDetails();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % 3;

        _scrollToIndex(_currentIndex);
      });
    });
  }

  void _toggleNavigationBarVisibility(bool isVisible) {
    setState(() {
      _isNavigationBarVisible = isVisible;
    });
  }

  void _scrollToIndex(int index) {
    if (index >= 0 && index < 3) {
      _scrollController.animateTo(
        index * 100.w,
        duration: Duration(milliseconds: 1200),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onBottomItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  SliverPersistentHeader makeHeader(String headerText, bool isShowFilter) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
          minHeight: 50.0,
          maxHeight: 60.0,
          child: Container(
              alignment: Alignment.centerLeft,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      headerText,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ))),
    );
  }

  Future<void> updateAdminDetails(Map<String, dynamic> newData) async {
    QuerySnapshot snapshot = await _collectionReference!.limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      String documentId = snapshot.docs.first.id;
      await _collectionReference!.doc(documentId).update(newData);
    }
  }

  //todo:- important base on user buisness type , nescessary parameters must get deleted

  Future<void> deletionBasedOnUserType(String docId, getUserType) async {
    // if(getUserType == "1"){

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Perform a collection group query to get all documents in the subcollection
      QuerySnapshot querySnapshot =
          await firestore.collectionGroup('AreaMeatPrices').get();

      // Iterate over documents and find the matching document ID
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        if (doc.id == docId) {
          // Manually check if the document ID matches
          await doc.reference.delete();
          print('Document with ID $docId deleted successfully.');
          return; // Stop once deleted
        }
      }

      print('No document found with ID $docId.');
    } catch (e) {
      print('Error deleting document: $e');
    }

    // }
  }

  void onChangedText() {
    ref.read(getListItemProvider.notifier).state =
        ref.read(adminDashListProvider.notifier).state.success1;

    // newDataList = ref
    //     .read(getListItemProvider.notifier)
    //     .state!
    //     .where((i) => i.name!.toLowerCase().contains(ref
    //         .read(adminDashListProvider.notifier)
    //         .txtSearch
    //         .text
    //         .toLowerCase())
    // )
    //     .toList();

    newDataList = ref.read(getListItemProvider.notifier).state!.where((i) {
      final query =
          ref.read(adminDashListProvider.notifier).txtSearch.text.toLowerCase();



      return (i.name?.toLowerCase().contains(query) ?? false) || (i.getPaymentStatus()?.toLowerCase().contains(query) ?? false) || (i.getUserReffererName?.toLowerCase().contains(query) ?? false) ||
          ((i.mobile?.toLowerCase().contains(query) ?? false) ||
              (i.userReffererNo?.toLowerCase().contains(query) ?? false)) ||
          (i.userTypeDes?.toLowerCase().contains(query) ??
              false ||
                  (i.userReffererNo?.toLowerCase().contains(query) ?? false)) ||
          (i.getUserPincode?.toLowerCase().contains(query) ?? false);
    }).toList();

    ref.read(getListItemProvider.notifier).state = newDataList;
  }
}

class ImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50); // Start at the bottom-left corner
    path.quadraticBezierTo(
      // Add a quadratic bezier curve
      size.width / 2, size.height, // Control point and end point
      size.width, size.height - 50, // Control point and end point
    );
    path.lineTo(size.width, 0); // Draw a straight line to the top-right corner
    path.close(); // Close the path to form a closed shape
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
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

class Response {
  int? statusCode;
  var resBody;

  Response(this.statusCode, this.resBody);
}
