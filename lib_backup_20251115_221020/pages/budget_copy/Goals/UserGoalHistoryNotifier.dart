import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../components/constants.dart';
import '../BudgetCopyController.dart';


class UserGoal {
  String? name;
  int? priorityPercentage;
  int? targetAmount;
  double? currentBalance;
  String? currentGoalStatus;
  bool? goalToDelete;
  String? goalDocId;
  String? goalIcon;
  Color? getColor;

  UserGoal(this.name, this.priorityPercentage, this.targetAmount,
      this.currentBalance, this.currentGoalStatus,this.goalToDelete,this.goalDocId,this.goalIcon,this.getColor) {
    currentBalance ??= 0.0;
  }
}


final UserGoalHistProvider =
StateNotifierProvider<GoalHistListNotifier, UserGoalHistState>(
        (ref) => GoalHistListNotifier(ref));

class GoalHistListNotifier extends StateNotifier<UserGoalHistState> {
  Ref ref;

  List<UserGoal>? goalList = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ConnectivityResult? data;

  GoalHistListNotifier(this.ref)
      : super(UserGoalHistState(
      status: ResStatus.init, success: [], failure: ""));

  Future<void> getUserGoalDetails(String? getDocId,double? getUserNetBal) async {
    if (data == ConnectivityResult.none) {
      Constants.showToast("No Internet Connection", ToastGravity.BOTTOM);
      return;
    }
    state = getLoadingState();
    goalList = await getUserGoalHist(getDocId,getUserNetBal);
    state = getSuccessState(goalList);
  }

  Future<List<UserGoal>> getUserGoalHist(String? getDocId, double? getUserNetBal) async {
    double remainingBalance = getUserNetBal ?? 0.0;

    final QuerySnapshot goalSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(getDocId)
        .collection('goals')
        .get();

    final List<UserGoal> goalList = [];

    for (final doc in goalSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final goalTitle = data['goalTitle'];
      final goalTarget = data['goalTarget'];
      final goalPriority = data['goalPriority'];
      final goalToDelete = data['goalToDelete'];
      final goalIcon = data['goalIcon'];
      final goalId = doc.id;

      // Calculate the total saved amount for this goal
      double totalSavedAmount = 0.0;
      final QuerySnapshot transactionSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(getDocId)
          .collection('transaction')
          .where('goalId', isEqualTo: goalId)
          .get();

      for (final transaction in transactionSnapshot.docs) {
        final transactionData = transaction.data() as Map<String, dynamic>;
        final int? getAmount = transactionData['amount'];
        final bool? isDeposit = transactionData['isDeposit'];

        if (isDeposit ?? false) {
          totalSavedAmount += getAmount ?? 0;
        } else {
          totalSavedAmount -= getAmount ?? 0;
        }
      }

      if (totalSavedAmount < 0) {
        totalSavedAmount = 0;
      }

      // Adjust allocation based on priority level
      double goalAllocation = 0.0;
      if (goalPriority == 1) {
        goalAllocation = getUserNetBal! * 0.5; // Priority 1 - 50%
      } else if (goalPriority == 2) {
        goalAllocation = getUserNetBal! * 0.3; // Priority 2 - 30%
      } else if (goalPriority == 3) {
        goalAllocation = getUserNetBal! * 0.2; // Priority 3 - 20%
      }

      Color? getColor = generateRandomDarkColor1();
      double currentBalance = goalAllocation;
      remainingBalance -= goalAllocation;

      String? currentStatus;
      if (totalSavedAmount >= goalTarget) {
        currentStatus = "Completed";
      } else {
        currentStatus = "In Progress";
      }

      if (remainingBalance < 0) {
        remainingBalance = 0;
      }

      final userGoal = UserGoal(
        goalTitle,
        goalPriority,
        goalTarget,
        totalSavedAmount,
        currentStatus,
        goalToDelete,
        goalId,
        goalIcon,
        getColor,
      );

      goalList.add(userGoal);
    }

    return goalList;
  }

  UserGoalHistState getLoadingState() {
    return UserGoalHistState(
        status: ResStatus.loading, success: null, failure: "");
  }

  UserGoalHistState getSuccessState(goalList) {
    return UserGoalHistState(
        status: ResStatus.success, success: goalList, failure: "");
  }

  UserGoalHistState getFailureState(err) {
    return UserGoalHistState(
        status: ResStatus.failure, success: [], failure: err);
  }
}

class UserGoalHistState {
  ResStatus? status;
  List<UserGoal>? success;
  String? failure;

  UserGoalHistState({this.status, this.success, this.failure});
}




Color generateRandomDarkColor1() {
  Random random = Random();

  // Generate random values for RGB components in the range 0-127
  int red = random.nextInt(128);
  int green = random.nextInt(128);
  int blue = random.nextInt(128);

  // Combine the values to create a dark color
  Color darkColor = Color.fromARGB(255, red, green, blue);

  return darkColor;
}