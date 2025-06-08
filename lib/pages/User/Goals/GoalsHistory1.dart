//todo:- 17.11.23 - new transaction list implementation
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:maaakanmoney/pages/User/Goals/AddGoals.dart';
import 'package:maaakanmoney/pages/User/Goals/GoalHistoryNotifier1.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';
import 'dart:math' as math;
import '../../../components/NotificationService.dart';
import '../../../components/constants.dart';
import '../../../components/reusable_code.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../phoneController.dart';
import '../../budget_copy/BudgetCopyController.dart';
import '../../budget_copy/budget_copy_widget.dart';
import '../Request Money/RequestMoney.dart';
import '../SaveMoney/SaveMoney.dart';
import '../UserScreen_Notifer.dart';

import 'dart:ui' as ui;

import '../Userscreen_widget.dart';

class GoalsHistory1 extends ConsumerStatefulWidget {
  GoalsHistory1({
    Key? key,
    required this.getDocId,
    required this.getMobile,
    required this.dataList,
  }) : super(key: key);

  final String? getDocId;
  final String? getMobile;
  final List<Transactionss>? dataList;

  // Tuple2<List<Goal>, String> getGoalDetail;

  @override
  GoalsHistory1State createState() => GoalsHistory1State();
}

class GoalsHistory1State extends ConsumerState<GoalsHistory1>
    with TickerProviderStateMixin {
  List<ColorPopper> poppers = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  double getUnAllocatedBal = 0.0;
  List<Goal> goals = [];
  TextEditingController netBalanceController = TextEditingController();
  TextEditingController goalNameController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController targetAmountController = TextEditingController();
  ConnectivityResult? data;
  List<DocumentSnapshot>? goalDocuments = [];

//todo:- 3.5.23
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final SingletonReusableCode _singleton = SingletonReusableCode();
  late StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void initState() {
    super.initState();

    // netBalance = ref.read(remainingBalProvider.notifier).state;

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {});
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




  @override
  Widget build(BuildContext context) {
    _addPoppers(50);
    return Consumer(builder: (context, ref, child) {
      data = ref.watch(connectivityProvider);
      bool? isRefresh = ref.watch(isUserRefreshIndicator);
      // UserGoalListState getUserGoalList = ref.watch(UserGoalListProvider);

      bool isLoading = false;
      // isLoading = (getUserGoalList.status == ResStatus.loading);

      goalDocuments = ref.read(UserDashListProvider.notifier).goalDocuments;

      return Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
                title: Text(
                  "My Goals",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Constants.secondary3,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold

                  ),
                ),
                backgroundColor: Constants.secondary,
                automaticallyImplyLeading: true,
                toolbarHeight: 8.h,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.black,
                  ),
                ),
                centerTitle: true,
                elevation: 0.0,
              )
            : null,
        body: SafeArea(
          child: Stack(children: [
            Container(
              color: Colors.white,
              height: 100.h,
              child: Stack(
                children: [

                  goalDocuments == null ?  InkWell(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/final/Dashboard/Goal.png',
                            width: 150,
                            height: 150,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Tap to Add Goals!",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Add Goals and Start Saving your Money!",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration:
                          Duration(milliseconds: 500),
                          pageBuilder: (_, __, ___) =>
                              AddGoalWidget(
                                getDocId: widget.getDocId,
                                getMobile: widget.getMobile,
                              ),
                          transitionsBuilder:
                              (_, animation, __, child) {
                            return ScaleTransition(
                              scale: Tween<double>(
                                begin: 0.0,
                                // You can adjust the start scale
                                end:
                                1.0, // You can adjust the end scale
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      ).then((value) {});
                    },
                  ) :

                  Column(
                    children: [
                      Expanded(
                        child: goalDocuments?.length == 0
                            ? InkWell(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'images/final/Dashboard/Goal.png',
                                        width: 150,
                                        height: 150,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        "Tap to Add Goals!",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        "Add Goals and Start Saving your Money!",
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: 500),
                                      pageBuilder: (_, __, ___) =>
                                          AddGoalWidget(
                                        getDocId: widget.getDocId,
                                        getMobile: widget.getMobile,
                                      ),
                                      transitionsBuilder:
                                          (_, animation, __, child) {
                                        return ScaleTransition(
                                          scale: Tween<double>(
                                            begin: 0.0,
                                            // You can adjust the start scale
                                            end:
                                                1.0, // You can adjust the end scale
                                          ).animate(animation),
                                          child: child,
                                        );
                                      },
                                    ),
                                  ).then((value) {});
                                },
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: goalDocuments?.length,
                                      itemBuilder: (context, index) {
                                        if (index > 2) {
                                          return SizedBox
                                              .shrink(); // Return an empty widget for transactions beyond the last three
                                        }

                                        var goalData = goalDocuments?[index]
                                            .data() as Map<String, dynamic>;
                                        var goalId =
                                            goalDocuments?[index].id as String;

                                        // double totalSavedAmount = 0.0;

                                        //todo:- 7.2.24 try calculating balance against goals

                                        return StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(ref
                                                    .read(UserDashListProvider
                                                        .notifier)
                                                    .getDocId)
                                                .collection('transaction')
                                                .where('goalId',
                                                    isEqualTo: goalId)
                                                .snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              double totalSavedAmount = 0.0;

                                              if (!snapshot.hasData) {
                                                return CircularProgressIndicator(); // Loading indicator
                                              }

                                              List<DocumentSnapshot>
                                                  transactions =
                                                  snapshot.data!.docs;

                                              // Calculate total saved amount for this goal
                                              for (DocumentSnapshot transaction
                                                  in transactions) {
                                                int? getAmount =
                                                    transaction['amount'];
                                                bool? isDeposit =
                                                    transaction['isDeposit'];

                                                if (isDeposit ?? false) {
                                                  totalSavedAmount +=
                                                      getAmount ?? 0;
                                                } else {
                                                  totalSavedAmount -=
                                                      getAmount ?? 0;
                                                }
                                              }

                                              if (totalSavedAmount < 0) {
                                                totalSavedAmount = 0;
                                              }

                                              return buildRowWidget(
                                                  goalData,
                                                  context,
                                                  widget.getMobile,
                                                  goalId ?? "",
                                                  totalSavedAmount);

                                              // return ListTile(
                                              // title: Text("goal['name']"),
                                              // subtitle: Text('Total Saved: $totalSavedAmount'),
                                              // );
                                            });
                                      },
                                    ),
                                    flex: 6,
                                  ),
                                ],
                              ),
                        flex: 8,
                      ),
                      Expanded(
                        flex: 1,
                        child: Stack(alignment: Alignment.center, children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Visibility(
                                        visible: goalDocuments?.length == 0
                                            ? false
                                            : true,
                                        child: SizedBox(
                                          width: 50.w,
                                          height: 5.h,
                                          child: IgnorePointer(
                                            ignoring: isOtpSent == true
                                                ? true
                                                : false,
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                bool? priority1 = false;
                                                bool? priority2 = false;
                                                bool? priority3 = false;

                                                if (goalDocuments!.length >=
                                                    3) {
                                                  Constants.showToast(
                                                      "Maximum Goal Reached, Delete Existing to add New Goal",
                                                      ToastGravity.CENTER);
                                                  return;
                                                }

                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    transitionDuration:
                                                        Duration(
                                                            milliseconds: 500),
                                                    pageBuilder: (_, __, ___) =>
                                                        AddGoalWidget(
                                                      getDocId: widget.getDocId,
                                                      getMobile:
                                                          widget.getMobile,
                                                    ),
                                                    transitionsBuilder: (_,
                                                        animation, __, child) {
                                                      return ScaleTransition(
                                                        scale: Tween<double>(
                                                          begin: 0.0,
                                                          // You can adjust the start scale
                                                          end:
                                                              1.0, // You can adjust the end scale
                                                        ).animate(animation),
                                                        child: child,
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              text: "Add Goals",
                                              options: FFButtonOptions(
                                                width: 270.0,
                                                height: 20.0,
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 0.0, 0.0),
                                                iconPadding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 0.0, 0.0),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        color:
                                                            Constants.secondary,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontWeight:
                                                            FontWeight.bold),
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
            ),
            for (var popper in poppers) popper,
          ]),
        ),
      );
    });
  }

  Widget buildRowWidget(Map<String, dynamic> goalData, BuildContext context,
      String? getMobile, String? getGoalDocId, double? getTotalGoalAmount) {
    //todo:- 10.1.24 setting up data with icon in grid view

    // double remainingBalance =
    //     ref.read(UserDashListProvider.notifier).getNetbalance;

    final data = goalData;
    final goalTitle = data['goalTitle'];
    final goalTarget = data['goalTarget'];
    final goalPriority = data['goalPriority'];
    final goalToDelete = data['goalToDelete'];
    // final goalIconName = data['goalIcon'];

    // Check if 'goalIcon' key is present in the data map
    IconData? goalIcon;
    if (data.containsKey('goalIcon')) {
      // Use null-aware operator to safely access 'goalIcon'
      String? getData = data['goalIcon'];

//todo:- 10.1.24 ,finding matching icon from array
      Tuple3<IconData, String, String> defaultIcon =
          Tuple3(Icons.error, "default", "default");
      Tuple3<IconData, String, String>? matchingIcon =
          ref.read(UserDashListProvider.notifier).iconOptions.firstWhere(
                (tuple) => tuple.item3 == getData,
                orElse: () => defaultIcon,
              );

      if (matchingIcon != null) {
        goalIcon = matchingIcon.item1;
      } else {
        // Handle the case when no matching icon is found
        goalIcon = Icons
            .error; // You can set a default icon or handle it in any other way
      }
    } else {
      // Handle the case when 'goalIcon' key is not present
      // You can set a default icon or handle it in any other way
      goalIcon = Icons.flag;
    }

    double goalAllocation = getTotalGoalAmount ?? 0.0;
    double currentBalance = 0.0;
    String? currentStatus = "";
    Color? getColor = Colors.red;

    getColor = generateRandomDarkColor();
    currentBalance = goalAllocation;
    // remainingBalance -= goalAllocation;
    // print("current remaining bal is $remainingBalance");

    // ref.read(remainingBalProvider.notifier).state = remainingBalance;

//todo;- chaging status of goal
    if (currentBalance! >= goalTarget!) {
      currentStatus = "Completed";
    } else {
      currentStatus = "In Progress";
    }

    return Container(
      height: 15.h,
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 7.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Constants.secondary1.withOpacity(0.5),
                Constants.secondary,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors
                                .white60, // Set initial background color to blue
                          ),
                          child: CustomPaint(
                            painter: PieChartPainter(
                                currentSavedAmount: double.tryParse(
                                        currentBalance.toString()) ??
                                    0.0,
                                targetAmount:
                                    double.tryParse(goalTarget.toString()) ??
                                        1.0,
                                getColor: Colors.black),
                            child: Center(
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors
                                      .white, // Set initial background color to blue
                                ),
                                child: Center(
                                    child: Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child:

                                          // SvgPicture.asset(() {
                                          //   return "images/sample.svg";
                                          // }(), color: generateRandomLightColor()),
                                          new Icon(
                                        goalIcon,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          ((double.tryParse(currentBalance.toString()) ?? 0.0) /
                                      (double.tryParse(goalTarget.toString()) ??
                                          1.0) *
                                      100) <
                                  100
                              ? "${((double.tryParse(currentBalance.toString()) ?? 0.0) / (double.tryParse(goalTarget.toString()) ?? 1.0) * 100).toStringAsFixed(2)}%"
                              : "100%",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: Constants.secondary3,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                goalTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ),
                        Text('Target: $goalTarget',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(overflow: TextOverflow.ellipsis)),
                        Text(
                          'Achieved: $getTotalGoalAmount',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(overflow: TextOverflow.ellipsis),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors
                                .transparent, // You can set your desired color here
                          ),
                          child: Icon(
                            Icons.delete,
                            color: Colors
                                .black, // You can set your desired color here
                          ),
                        ),
                        onTap: () {
                          _singleton.showAlertDialog(
                            context: context,
                            title: "Are you sure?",
                            message: "Do you want to Delete this Goal?",
                            onCancelPressed: () {},
                            onOkPressed: () async {
                              deleteGoal(getGoalDocId ?? "");
                            },
                          );
                        },
                      ),
                      CustomButton(
                        getReqAmount: goalTarget!.round().toString(),
                        getTargetAmount: goalAllocation.round().toString(),
                        getMobile: widget.getMobile,
                        getUser:
                            ref.read(UserDashListProvider.notifier).getUser,
                        getDocId:
                            ref.read(UserDashListProvider.notifier).getDocId,
                        isSaveMoney: ((double.tryParse(
                                            currentBalance.toString()) ??
                                        0.0) /
                                    (double.tryParse(goalTarget.toString()) ??
                                        1.0) *
                                    100) <
                                100
                            ? true
                            : false,
                        getGoalDocId: getGoalDocId,
                        dataList: widget.dataList ?? [],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Tuple2<List<Goal>, String>> updateGoalProvider() async {
    var goalDetails = await ref
        .read(UserDashListProvider.notifier)
        .updateGoalDetails(
            ref.read(UserDashListProvider.notifier).goalDocuments,
            ref.read(UserDashListProvider.notifier).iconOptions);

    return goalDetails;
  }

  //todo:- 24.12.23 add goal

  void deleteGoal(String docID) {
    if (data == ConnectivityResult.none) {
      Constants.showToast("No Internet Connection", ToastGravity.CENTER);
      return;
    }

    firestore
        .collection('users')
        .doc(widget.getDocId)
        .collection('goals')
        .doc(docID)
        .delete()
        .then((_) async {
      Constants.showToast("Goal Deleted Successfully", ToastGravity.CENTER);

      //todo:- 2.12.23 adding notification to let admin know payment initiated
      String? token = await NotificationService.getDocumentIDsAndData();
      if (token != null) {
        Response? response = await NotificationService.postNotificationRequest(
            token,
            "Hi Admin,\n${ref.read(UserDashListProvider.notifier).getUser}  Deleted Goal",
            "Hurry up, let's Check with Admin App.");
      }

      setState(() {
        int indexToDelete =
            goalDocuments!.indexWhere((item) => item.id == docID);

        if (indexToDelete != -1) {
          goalDocuments!.removeAt(indexToDelete);
          setState(() {});
        }
      });
    });
  }

  void _addPoppers(int count) {
    setState(() {
      for (var i = 0; i < count; i++) {
        double verticalOffset = i * 50.0; // Adjust the space between papers

        poppers.add(ColorPopper(
          verticalOffset: verticalOffset,
        ));
      }
    });
  }
}

//todo"- 21.12.23 showing pie chart based on target amount and achieved balance

class PieChartPainter extends CustomPainter {
  final double currentSavedAmount;
  final double targetAmount;
  final Color getColor;

  PieChartPainter(
      {required this.currentSavedAmount,
      required this.targetAmount,
      required this.getColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Set default color to blue and draw a single circle
    paint.color = Colors.white54;
    canvas.drawCircle(center, radius, paint);

    // Change color to red if user input is provided
    if (currentSavedAmount > 0) {
      paint.color = getColor;

      // Calculate sweep angle based on the current saved and target amounts
      final double sweepAngle = 2 * pi * (currentSavedAmount / targetAmount);

      // Draw the arc
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        sweepAngle,
        true,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

//todo:- 28.12.23 creating color pops

class ColorPopper extends StatefulWidget {
  final double verticalOffset;

  ColorPopper({required this.verticalOffset});

  @override
  _ColorPopperState createState() => _ColorPopperState();
}

class _ColorPopperState extends State<ColorPopper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _width;
  late double _height;
  late Offset _position;
  late bool _isHorizontal;
  late double _rotation;
  late Color _paperColor;
  late Path _paperPath;

  @override
  void initState() {
    super.initState();

    _width = 60;
    _height = 60;
    _isHorizontal = Random().nextBool();
    _rotation = Random().nextDouble() * 360;
    _position = Offset(
      Random().nextDouble() * 300,
      -(_isHorizontal ? _height : _width),
    );
    _paperColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    _paperPath = _generateRandomPath();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {
          _rotation = 360 * _animation.value;
          _position = Offset(
            _position.dx + (_isHorizontal ? 2 : 0), // Adjust wind effect speed
            _position.dy + 4, // Vertical movement
          );
        });
      });

    _controller.forward();
  }

  Path _generateRandomPath() {
    final path = Path();
    final Random random = Random();

    final double startX = random.nextDouble() * _width;
    final double startY = random.nextDouble() * _height;
    path.moveTo(startX, startY);

    final double endX = startX + random.nextDouble() * (_width - startX);
    final double endY = startY + random.nextDouble() * (_height - startY);

    path.lineTo(endX, startY);
    path.lineTo(endX, endY);
    path.lineTo(startX, endY);

    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: -50 +
          _position.dy +
          _animation.value * MediaQuery.of(context).size.height +
          widget.verticalOffset,
      child: Transform.rotate(
        angle: _rotation * pi / 180,
        child: Opacity(
          opacity: 1 - _animation.value,
          child: CustomPaint(
            painter: _PaperPainter(_paperPath, _paperColor),
            size: Size(_width, _height),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _PaperPainter extends CustomPainter {
  final Path path;
  final Color color;

  _PaperPainter(this.path, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
