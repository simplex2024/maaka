//todo:- 17.11.23 - new transaction list implementation
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maaakanmoney/pages/User/Goals/AddGoals.dart';
import 'package:maaakanmoney/pages/User/Goals/GoalHistoryNotifier1.dart';
import 'package:maaakanmoney/pages/budget_copy/Goals/UserGoalHistoryNotifier.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;
import '../../../components/NotificationService.dart';
import '../../../components/constants.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../phoneController.dart';
import '../../budget_copy/BudgetCopyController.dart';
import 'package:tuple/tuple.dart';
import 'dart:ui' as ui;

import '../budget_copy_widget.dart';
import '../navigation_drawer/create_notification.dart';

class UserGoalHistory extends ConsumerStatefulWidget {
  const UserGoalHistory(
      {Key? key,
      required this.getDocId,
      required this.getMobile,
      required this.getNetBal,
      required this.getUserName,
      required this.getUserToken})
      : super(key: key);

  final String? getDocId;
  final String? getMobile;
  final double? getNetBal;
  final String? getUserName;
  final String? getUserToken;

  @override
  UserGoalHistoryState createState() => UserGoalHistoryState();
}

class UserGoalHistoryState extends ConsumerState<UserGoalHistory>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  double netBalance = 10100.0;
  List<UserGoal> goals = [];
  TextEditingController netBalanceController = TextEditingController();
  TextEditingController goalNameController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController targetAmountController = TextEditingController();
  late StreamSubscription<List<ConnectivityResult>> subscription;
  ConnectivityResult? data;

//todo:- 3.5.23
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    // netBalance = ref.read(remainingBalProvider.notifier).state;

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(UserGoalHistProvider.notifier)
          .getUserGoalDetails(widget.getDocId, widget.getNetBal ?? 0.0);
    });
    getNotificationAccessToken();
  }

  Future<void> getNotificationAccessToken() async {
    final String token =
        await getAccessToken(); // Assume this is your async method to fetch the token
    // setState(() {
    Constants.accessTokenFrNotificn = token; // Store the token in the state
    // });

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

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      data = ref.watch(connectivityProvider);
      bool? isRefresh = ref.watch(isUserRefreshIndicator);
      UserGoalHistState getUserTransList = ref.watch(UserGoalHistProvider);

      bool isLoading = false;
      isLoading = (getUserTransList.status == ResStatus.loading);

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
                  "${widget.getUserName} Goals",
                  style: GlobalTextStyles.secondaryText1(
                      textColor: FlutterFlowTheme.of(context).secondary2,
                      txtWeight: FontWeight.w700),
                ),
                backgroundColor: FlutterFlowTheme.of(context).primary,
                automaticallyImplyLeading: true,
                toolbarHeight: 8.h,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                elevation: 0.0,
                actions: [
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
                            int randomNumber = generateRandomNumber();
                            String? getUser = widget.getUserName;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateNewNotificationScreen(
                                        isIndividualNotificationToken:
                                            widget.getUserToken ?? ""),
                              ),
                            ).then((value) {
                              //todo:- below code refresh firebase records automatically when come back to same screen
                              // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                            });
                          },
                          child: Icon(
                            Icons.notification_add,
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : null,
        body: SafeArea(
          child: Container(
            color: Colors.white,
            height: 100.h,
            child: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: Column(
                    children: [
                      Expanded(
                        child: ref
                                    .read(UserGoalHistProvider.notifier)
                                    .goalList!
                                    .length ==
                                0
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      child: Image.asset(
                                        'images/final/Dashboard/Goal.png',
                                        width: 150,
                                        height: 150,
                                      ),
                                      onTap: () {
                                        String? getUser = widget.getUserName;
                                        postIndividualNotification(
                                            widget.getUserToken,
                                            widget.getUserName,
                                            "Hey $getUser, You haven't created a goal yet! 🙁🫤",
                                            "Set and track your Goals! 🎯\nTeam Maaka will help you to achieve it! 🖖🏻👥✨");
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "No Goals Yet!",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Tap Cheers Customer Abou Smart financial moves and Savings Plans.",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Consumer(
                                        builder: (context, ref, child) {
                                      double? getRemainingBal =
                                          ref.watch(remainingBalProvider);

                                      return Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            'Running Balance  ${widget.getNetBal}',
                                            style:
                                                GlobalTextStyles.primaryText2(
                                                    txtSize: 20,
                                                    textColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                    txtWeight: FontWeight.w700),
                                          ),
                                        ),
                                      );
                                    }),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: 3, // Priority levels: 1, 2, 3
                                      itemBuilder: (context, priorityIndex) {
                                        List<UserGoal> filteredGoals = ref
                                            .read(UserGoalHistProvider.notifier)
                                            .goalList!
                                            .where((goal) =>
                                                goal.priorityPercentage ==
                                                (priorityIndex + 1))
                                            .toList();
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (filteredGoals.isNotEmpty)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      priorityIndex + 1 == 1
                                                          ? "First Priority"
                                                          : priorityIndex + 1 ==
                                                                  2
                                                              ? "Second Priority"
                                                              : "Third Priority",
                                                      style: GlobalTextStyles
                                                          .secondaryText1(
                                                              textColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                              txtWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ...filteredGoals.map((goal) =>
                                                buildRowWidget(
                                                    goal,
                                                    context,
                                                    widget.getMobile,
                                                    goal.goalDocId ?? "",
                                                    goal.currentBalance)),
                                          ],
                                        );
                                      },
                                    ),
                                    flex: 6,
                                  ),
                                ],
                              ),
                        flex: 8,
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
          ),
        ),
      );
    });
  }

  Widget buildRowWidget(UserGoal goalData, BuildContext context,
      String? getMobile, String? getGoalDocId, double? getTotalGoalAmount) {
    //todo:- 10.1.24 setting up data with icon in grid view

    // double remainingBalance =
    //     ref.read(UserDashListProvider.notifier).getNetbalance;

    final data = goalData;
    final goalTitle = data.name;
    final goalTarget = data.targetAmount;
    final goalIcn = data.goalIcon;

    // Check if 'goalIcon' key is present in the data map
    IconData? goalIcon;
    if (goalIcn != null) {
      // Use null-aware operator to safely access 'goalIcon'
      String? getData = goalIcn;

//todo:- 10.1.24 ,finding matching icon from array
      Tuple3<IconData, String, String> defaultIcon =
          Tuple3(Icons.error, "default", "default");
      Tuple3<IconData, String, String>? matchingIcon =
          Constants.iconOptions.firstWhere(
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

//todo;- chaging status of goal
    if (currentBalance! >= goalTarget!) {
      currentStatus = "Completed";
    } else {
      currentStatus = "In Progress";
    }

    //todo:- creating goals list to goal history
    // ref.read(UserDashListProvider.notifier).goalList = Tuple2([Goal(goalTitle, goalPriority, goalTarget, currentBalance,
    //     currentStatus, goalToDelete, getGoalDocId, getColor, goalIcon)], "Success");

    // ref.read(UserDashListProvider.notifier).goalList?.add(Goal(goalTitle, goalPriority, goalTarget, currentBalance,
    //     currentStatus, goalToDelete, getGoalDocId, getColor, goalIcon));

    return InkWell(
      child: Container(
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
                  FlutterFlowTheme.of(context).primary,
                  FlutterFlowTheme.of(context).primary2,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
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
                          style: TextStyle(
                              color: FlutterFlowTheme.of(context).secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
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
                                  goalTitle ?? "",
                                  style: GlobalTextStyles.primaryText2(
                                      textColor: FlutterFlowTheme.of(context)
                                          .secondary,
                                      txtSize: 18),
                                ),
                              ),
                            ],
                          ),
                          Text('Target: $goalTarget',
                              style: GlobalTextStyles.secondaryText1(
                                  textColor:
                                      FlutterFlowTheme.of(context).secondary,
                                  txtSize: 14)),
                          Text(
                            'Achieved: $getTotalGoalAmount',
                            style: GlobalTextStyles.secondaryText1(
                                textColor:
                                    FlutterFlowTheme.of(context).secondary,
                                txtSize: 14),
                            overflow: TextOverflow.ellipsis,
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
      ),
      onTap: () async {
        int randomNumber = generateRandomNumber();
        String? getUser = widget.getUserName;
        String? achievedPercentage = ((double.tryParse(
                            currentBalance.toString()) ??
                        0.0) /
                    (double.tryParse(goalTarget.toString()) ?? 1.0) *
                    100) <
                100
            ? "${((double.tryParse(currentBalance.toString()) ?? 0.0) / (double.tryParse(goalTarget.toString()) ?? 1.0) * 100).toStringAsFixed(2)}%"
            : "100%";

        String getBody = "";
        String getTitle = "";

        if (achievedPercentage == "100%") {
          getTitle = "$getUser, Your Goal - $goalTitle - Completed 😍🥳😎";
          getBody =
              "Target: Rs. $goalTarget\nAchieved: Rs. $getTotalGoalAmount\n$achievedPercentage Completed \n$getUser, You Achieved your Goal Successfully! 😎😍🥳\nAdd new Goals with Maaka App! 🖖🏻👥✨";
        } else {
          getTitle = "$getUser, Your Goal - $goalTitle - Not Completed ☹️";
          getBody =
              "Target: Rs. $goalTarget\nAchieved: Rs. $getTotalGoalAmount\n$achievedPercentage Completed \n$getUser, Achieve Your Goal in Single Tap!\nSend Rs.$randomNumber Now,Let Us Save Your Money! 🖖🏻👥✨";
        }

        // ///11.9.24 try new post notification
        // String accessToken = await getAccessToken();

        // await sendFcmMessage(accessToken, widget.getUserToken,
        //     widget.getUserName, getTitle, getBody);

        postIndividualNotification(
            widget.getUserToken, widget.getUserName, getTitle, getBody);
      },
    );
  }

  //todo:- 24.12.23 add goal

  Future<void> _handleRefresh() async {
    // ref.read(isUserRefreshIndicator.notifier).state = true;
    return ref
        .read(UserGoalHistProvider.notifier)
        .getUserGoalDetails(widget.getDocId, widget.getNetBal ?? 0.0);
  }

  postIndividualNotification( String? getToken,
      String? getUserName, String? getTitle, String? getBody) async {

    Response? res;
    String? getBearerToken = Constants.accessTokenFrNotificn;


    const fcmUrl =
        'https://fcm.googleapis.com/v1/projects/maakanmoney-a6874/messages:send';

    try {
      // Create FCM message payload
      final message = {
        "message": {
          "notification": {"title": getTitle, "body": getBody},
          "token": getToken // The device FCM token
        }
      };

      // Make POST request to send the message
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          'Authorization': 'Bearer $getBearerToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(message),
      );

      var body = response.body;
      print("JSON Response -- $body");

      if (response.statusCode == 200) {
        body = await response.body;
        Constants.showToast(
            "Notification posted successfully", ToastGravity.BOTTOM);
      } else {
        Constants.showToast("Failed to post notification", ToastGravity.BOTTOM);
      }
      res = Response(response.statusCode, body);
    } on SocketException catch (e) {
      print(e);
      res = Response(
          001, 'No Internet Connection\nPlease check your network status');
    }
    return res;
  }

  ///11.9.24 new implementation for notification service
  // ---
  Future<Map<String, dynamic>> loadServiceAccountCredentials() async {
    String jsonData = await rootBundle
        .loadString('images/maakanmoney-a6874-9f449586b9b5.json');
    return json.decode(jsonData);
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



  //----

  //todo:- to convert drive link to direct link
  static String _extractFileId(String url) {
    // Extract the file ID from the Google Drive link
    final RegExp regExp = RegExp(r'/d/(.*?)/');
    final match = regExp.firstMatch(url);
    if (match != null && match.groupCount > 0) {
      return match.group(1) ?? '';
    }
    return '';
  }
}

int generateRandomNumber() {
  Random random = new Random();
  return random.nextInt(40) +
      45; // Generates a random number between 0 and 90, then adds 10
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

class ConsolidatedBarChartPainter extends CustomPainter {
  final List<Goal> goals;
  final double barSpacing;

  ConsolidatedBarChartPainter({required this.goals, this.barSpacing = 8.0});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    final double totalBarWidth = size.width - (goals.length - 1) * barSpacing;
    final double barWidth = totalBarWidth / goals.length;
    final double maxBarHeight = size.height * 0.8;

    // Calculate total target amount
    double maxTargetAmount = 0.0;

    goals.forEach((goal) {
      maxTargetAmount = max(maxTargetAmount, goal.currentBalance ?? 0.0);
    });

    // Draw bars for each goal
    for (int i = 0; i < goals.length; i++) {
      final Goal goal = goals[i];

      double barHeight =
          (goal.currentBalance ?? 0.0) / maxTargetAmount * maxBarHeight;

      paint.color = goal.getColor!;
      canvas.drawRect(
        Rect.fromPoints(
          Offset(i * (barWidth + barSpacing), size.height - barHeight),
          Offset((i + 1) * barWidth + i * barSpacing, size.height),
        ),
        paint,
      );

      // Draw labels below each bar
      TextPainter textPainter = TextPainter(
        textDirection: ui.TextDirection.ltr,
        text: TextSpan(
          text: "${goal.name}",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          i * (barWidth + barSpacing) + (barWidth - textPainter.width) / 2,
          size.height,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
