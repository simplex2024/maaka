import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maaakanmoney/pages/budget_copy/BudgetCopyController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

import '../../../components/constants.dart';
import '../UserScreen_Notifer.dart';

final UserGoalListProvider =
    StateNotifierProvider<GoalListNotifier, UserGoalListState>(
        (ref) => GoalListNotifier(ref));

class GoalListNotifier extends StateNotifier<UserGoalListState> {
  Ref ref;

  List<Goal>? goalList = [];
  double getUnallocated = 0.0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ConnectivityResult? data;

  final List<Tuple3<IconData, String, String>> iconOptions = [
    Tuple3(Icons.sort_by_alpha, "warnunexpectedcarelesssdfsfsafs",
        "sort_by_alpha"),
    Tuple3(Icons.snowshoeing, "sandlesslippershoe", "snowshoeing"),
    Tuple3(Icons.camera, "cameravidbuygiftnew", "camera"),
    Tuple3(Icons.gamepad, "gamegiftbuy", "gamepad"),
    Tuple3(Icons.groups, "petpuppyparrotdog", "groups"),
    Tuple3(
        Icons.pets, "friendpeopleuncledadmomsisbrolovesondaugteraunty", "pets"),
    Tuple3(Icons.group, "friendpeopleuncledadmomsisbrolovesondaugteraunty",
        "group"),
    Tuple3(Icons.person, "friendpeopleuncledadmomsisbrolovesondaugteraunty",
        "person"),
    Tuple3(Icons.install_mobile, "mobilerechargebuynewsellmomdadsis",
        "install_mobile"),
    Tuple3(Icons.system_update, "warnunexpectedcarelesssdfasfasf",
        "system_update"),
    Tuple3(Icons.festival, "celebrationtourexploretravel", "festival"),
    Tuple3(Icons.tour, "celebrationtourexploretravel", "tour"),
    Tuple3(Icons.home, "househome", "home"),
    Tuple3(Icons.settings, "mechanic", "settings"),
    Tuple3(Icons.favorite, "favoritelovewifemomdadsisbroperson", "favorite"),
    Tuple3(Icons.star, "favoritelovewifemomdadsisbroperson", "star"),
    Tuple3(Icons.family_restroom_rounded, "favoritelovewifemomdadsisbroperson",
        "family_restroom_rounded"),
    Tuple3(Icons.autorenew, "loanpayment", "autorenew"),
    Tuple3(Icons.key, "carbikecycle", "key"),
    Tuple3(Icons.add_box, "medicalhospitalemergency", "add_box"),
    Tuple3(Icons.shopping_cart_checkout, "shoppingnewbuy",
        "shopping_cart_checkout"),
    Tuple3(Icons.school, "schoolcollegepgfeesphdhigherstudiesbook", "school"),
    Tuple3(Icons.cast_for_education, "schoolcollegepgfeesphdhigherstudiesbook",
        "cast_for_education"),
    Tuple3(Icons.reduce_capacity, "schoolcollegepgfeesphdhigherstudiesbook",
        "reduce_capacity"),
    Tuple3(Icons.menu_book, "schoolcollegepgfeesphdhigherstudiesbook",
        "menu_book"),
    Tuple3(Icons.group, "workbuisnessnew", "group"),
    Tuple3(Icons.work, "workbuisnessnew", "work"),
    Tuple3(Icons.group_add, "workbuisnessnew", "group_add"),
    Tuple3(Icons.engineering, "workbuisnessnew", "engineering"),
    Tuple3(Icons.diversity_3, "workbuisnessnew", "diversity_3"),
    Tuple3(Icons.travel_explore, "buisnesstravelexploretripinvest",
        "travel_explore"),
    Tuple3(Icons.business_center, "workbuisnessnewinvest", "business_center"),
    Tuple3(
        Icons.attach_money,
        "moneysavingsborrowemergencfinanceinvestgrowbanksellbuyrupeeemergen",
        "attach_money"),
    Tuple3(
        Icons.credit_card,
        "moneysavingsfinanceinvestgrowbanksellbuyrupeeemergency",
        "credit_card"),
    Tuple3(
        Icons.account_balance,
        "moneysavingsfinanceinvestgrowbanksellbuyrupeeemergency",
        "account_balance"),
    Tuple3(
        Icons.paid,
        "moneysavingsemergencyfinanceinvestgrowbanksellbuyrupeeemergency",
        "paid"),
    Tuple3(Icons.savings,
        "moneysavingsemergencyfinanceinvestgrowbanksellbuyrupee", "savings"),
    Tuple3(
        Icons.account_balance_wallet,
        "moneysavingsfinanceinvestgrowbanksellbuyrupee",
        "account_balance_wallet"),
    Tuple3(Icons.currency_rupee,
        "moneysavingsfinanceinvestgrowbanksellbuyrupee", "currency_rupee"),
    Tuple3(Icons.payment, "paymentfinancesavingloanjweleducationfeebuynew",
        "payment"),
    Tuple3(Icons.health_and_safety, "healthsafetyinsurancemedicalemergency",
        "health_and_safety"),
    Tuple3(Icons.monitor_heart, "healthsafetyinsurancemedicalemergency",
        "monitor_heart"),
    Tuple3(
        Icons.emergency, "healthsafetyinsurancemedicalemergency", "emergency"),
    Tuple3(Icons.medical_information, "healthsafetyinsurancemedicalemergency",
        "medical_information"),
    Tuple3(Icons.personal_injury, "healthsafetyinsurancemedicalemergency",
        "personal_injury"),
    Tuple3(
        Icons.fitness_center, "fitnessgymtrainingworkoutfee", "fitness_center"),
    Tuple3(
        Icons.monitor_weight, "fitnessgymtrainingworkoutfee", "monitor_weight"),
    Tuple3(Icons.chair, "sofachairbedhouse", "chair"),
    Tuple3(Icons.living, "sofachairbedhouse", "living"),
    Tuple3(Icons.bed, "sofachairbedhouse", "bed"),
    Tuple3(Icons.bedtime, "sofachairbedhouse", "bedtime"),
    Tuple3(Icons.redeem, "birthdayweddinganniversarysurprisegiftbuy", "redeem"),
    Tuple3(Icons.card_giftcard, "birthdayweddinganniversarysurprisegiftbuy",
        "card_giftcard"),
    Tuple3(Icons.directions_bike, "bikecyclebuyhelmescooternewbuytour",
        "directions_bike"),
    Tuple3(
        Icons.two_wheeler, "bikecyclebuyhelmescooternewbuytour", "two_wheeler"),
    Tuple3(Icons.sports_motorsports, "bikecyclebuyhelmescooternewbuytour",
        "sports_motorsports"),
    Tuple3(
        Icons.motorcycle, "bikecyclebuyhelmescooternewbuytour", "motorcycle"),
    Tuple3(Icons.electric_moped, "bikecyclebuyhelmescooternewbuytour",
        "electric_moped"),
    Tuple3(Icons.electric_scooter, "bikecyclebuyhelmescooternewbuytour",
        "electric_scooter"),
    Tuple3(Icons.electric_bike, "bikecyclebuyhelmescooternewbuytour",
        "electric_bike"),
    Tuple3(Icons.bike_scooter, "bikecyclebuyhelmescooternewbuytour",
        "bike_scooter"),
    Tuple3(Icons.directions_car, "carbuytraveltour", "directions_car"),
    Tuple3(Icons.airport_shuttle, "carbuytraveltour", "airport_shuttle"),
    Tuple3(Icons.local_gas_station, "petroltravelbikecar", "local_gas_station"),
    Tuple3(Icons.precision_manufacturing, "servicerepairbikecarmechanic",
        "precision_manufacturing"),
    Tuple3(Icons.settings, "servicerepairbikecarmechanic", "settings"),
    Tuple3(Icons.menu_book, "bookgiftbuyread", "menu_book"),
    Tuple3(Icons.restaurant, "foodfamilyoutingdinnerlunch", "restaurant"),
    Tuple3(Icons.apartment, "homeloanhousebuyinvestment", "apartment"),
    Tuple3(Icons.real_estate_agent, "buyhouseloan", "real_estate_agent"),
    Tuple3(Icons.call, "mobilerechargebuyphonemobilegiftbirthday", "call"),
    Tuple3(Icons.phone_iphone, "mobilerechargebuyphonemobilegiftbirthday",
        "phone_iphone"),
    Tuple3(Icons.smartphone, "mobilerechargebuyphonemobilegiftbirthday",
        "smartphone"),
    Tuple3(Icons.phone_android, "mobilerechargebuyphonemobilegiftbirthday",
        "phone_android"),
    Tuple3(
        Icons.tv,
        "mobilerechargebuyphonemobilegiftbirthdaytvremotecomputermonitor",
        "tv"),
    Tuple3(
        Icons.monitor,
        "mobilerechargebuyphonemobilegiftbirthdaytvremotecomputermonitor",
        "monitor"),
    Tuple3(
        Icons.settings_remote,
        "mobilerechargebuyphonemobilegiftbirthdaytvremotecomputermonitor",
        "settings_remote"),
    Tuple3(Icons.watch, "watchgiftbirthdaypresent", "watch"),
    Tuple3(Icons.wind_power, "acfanwindcooler", "wind_power"),
    Tuple3(Icons.print, "buyprinterscanner", "print"),
    Tuple3(Icons.scanner, "buyprinterscanner", "scanner"),
    Tuple3(Icons.blender, "mixyblender", "blender"),
    Tuple3(Icons.celebration, "celebrationgiftmomdadbrosissondaughter",
        "celebration"),
    Tuple3(Icons.cake, "celebrationgiftmomdadbrosissondaughter", "cake"),
    Tuple3(Icons.warning, "warnunexpectedcareless", "warning"),
  ];

  GoalListNotifier(this.ref)
      : super(UserGoalListState(
            status: ResStatus.init, success: [], failure: ""));

  Future<void> getUserGoalDetails(
      String? getDocId, double? getUserNetBal) async {
    if (data == ConnectivityResult.none) {
      Constants.showToast("No Internet Connection", ToastGravity.BOTTOM);
      return;
    }
    state = getLoadingState();
    goalList = await getUserGoals(getDocId, getUserNetBal);
    state = getSuccessState(goalList);
  }

  Future<List<Goal>> getUserGoals(
      String? getDocId, double? getUserNetBal) async {
    getUnallocated = 0.0;

    double remainingBalance =
        ref.read(UserDashListProvider.notifier).getNetbalance;

    final QuerySnapshot goalSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(getDocId)
        .collection('goals')
        .get();

    final List<Goal> goalList = goalSnapshot.docs
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
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
                iconOptions.firstWhere(
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

          double goalAllocation = 0.0;
          double currentBalance = 0.0;
          String? currentStatus = "";
          Color? getColor = Colors.red;

          // Adjust allocation based on priority level
          if (goalPriority == 1) {
            goalAllocation = remainingBalance * 0.5; // Priority 1 - 50%
          } else if (goalPriority == 2) {
            goalAllocation = remainingBalance * 0.3; // Priority 2 - 30%
            print(goalAllocation);
          } else if (goalPriority == 3) {
            goalAllocation = remainingBalance * 0.2; // Priority 3 - 20%
          }

          getColor = generateRandomDarkColor();
          currentBalance = goalAllocation;
          remainingBalance -= goalAllocation;

          ref.read(remainingBalProvider.notifier).state = remainingBalance;

//todo;- chaging status of goal
          if (currentBalance! >= goalTarget!) {
            currentStatus = "Completed";
          } else {
            currentStatus = "In Progress";
          }

          // Update the remaining balance
          // This is a simple example; you may want to handle rounding or other edge cases
          if (remainingBalance < 0) {
            remainingBalance = 0;
          }

          getUnallocated += currentBalance;

          return Goal(goalTitle, goalPriority, goalTarget, currentBalance,
              currentStatus, goalToDelete, doc.id, getColor, goalIcon);
        })
        .whereType<Goal>()
        .toList();

    return goalList;
  }

  UserGoalListState getLoadingState() {
    return UserGoalListState(
        status: ResStatus.loading, success: null, failure: "");
  }

  UserGoalListState getSuccessState(goalList) {
    return UserGoalListState(
        status: ResStatus.success, success: goalList, failure: "");
  }

  UserGoalListState getFailureState(err) {
    return UserGoalListState(
        status: ResStatus.failure, success: [], failure: err);
  }
}

class UserGoalListState {
  ResStatus? status;
  List<Goal>? success;
  String? failure;

  UserGoalListState({this.status, this.success, this.failure});
}

class Goal {
  String? name;
  int? priorityPercentage;
  int? targetAmount;
  double? currentBalance;
  String? currentGoalStatus;
  bool? goalToDelete;
  String? goalDocId;
  Color? getColor;
  IconData? goalIcon;

  Goal(
      this.name,
      this.priorityPercentage,
      this.targetAmount,
      this.currentBalance,
      this.currentGoalStatus,
      this.goalToDelete,
      this.goalDocId,
      this.getColor,
      this.goalIcon) {
    currentBalance ??= 0.0;
  }
}

//
Color generateRandomDarkColor() {
  Random random = Random();

  // Generate random values for RGB components in the range 0-127
  int red = random.nextInt(128);
  int green = random.nextInt(128);
  int blue = random.nextInt(128);

  // Combine the values to create a dark color
  Color darkColor = Color.fromARGB(255, red, green, blue);

  return darkColor;
}

var remainingBalProvider = StateProvider<double>((ref) => 0.0);
