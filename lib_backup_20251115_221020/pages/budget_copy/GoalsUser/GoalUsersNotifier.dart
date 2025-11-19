// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:tuple/tuple.dart';

import '../BudgetCopyController.dart';

final userGoalListProvider =
    StateNotifierProvider<UserGoalListNotifier, UsrGoalsState>(
        (ref) => UserGoalListNotifier(ref));

class UserGoalListNotifier extends StateNotifier<UsrGoalsState> {
  Ref ref;

  final txtSearch = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ConnectivityResult? data;
  List<User2>? usersWitGoals = [];

  UserGoalListNotifier(this.ref)
      : super(UsrGoalsState(status: ResStatus.init, success: [], failure: ""));

  Future<void> getUserGoalDetails() async {
    state = getLoadingState();
    usersWitGoals = await fetchUserGoals();
    state = getSuccessState(usersWitGoals);
  }

  Future<List<User2>> fetchUserGoals() async {
    QuerySnapshot userSnapshot =
        await firestore.collection('users').orderBy('name').get();

    // todo:- try getting reffere name with refferen mobile no - 1213
    // todo:- Create a lookup map for mobileNo -> name
    final Map<String, String> mobileToNameMap = {
      for (var doc in userSnapshot.docs)
        (doc['mobile'] ?? ''): (doc['name'] ?? '')
    };

    //todo--

    List<User2> users2 = [];

    await Future.forEach(userSnapshot.docs, (doc) async {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      //todo:- get refferer name - 1213

      // 🔹 Get referrer name using the map
      final referrerName = mobileToNameMap[data['reffererNumber']] ?? 'N/A';

      print("Referrer name: $referrerName");

      //todo


      // bool? isGoalsFound = await isGoalFound(doc.id);

      QuerySnapshot goalsSnapshot = await ref
          .read(userGoalListProvider.notifier)
          .firestore
          .collection('users')
          .doc(doc.id)
          .collection('goals')
          .get();

      String? getUserType = data['userType'] ?? "";

      User2 user = User2(
        name:
            getUserType != "0" ? "${data['name']} Client" : "${data['name']} ",
        total: data['total'],
        interest: data['totalIntCredit'],
        mobile: data['mobile'],
        docId: doc.id,
        isMoneyRequest: data['isMoneyRequest'],
        requestAmount: data['requestAmnt'],
        isNotificationByAdmin: data['notificationByAdmin'],
        transactions: [],
        totalCredit: data['totalCredit'],
        totalDebit: data['totalDebit'],
        totalIntCredit: data['totalIntCredit'],
        totalIntDebit: data['totalIntDebit'],
        getSecurityCode: data['securityCode'],
        isCashBackRequest: data['isCashbackRequest'],
        requestCashbckAmount: data['requestCashbckAmnt'],
        getAdminType: data['mappedAdmin'],
        isUserSetupGoals: false,
        isPendingPayment: data['isPendingPayment'],
        notificationToken: data['notificationToken'],
        userType: data['userType'],
        userReffererNo: data['reffererNumber'],
        userTypeDes: getUserType == "1"
            ? "Meat Shop Owner"
            : getUserType == "2"
                ? "Cloud Kitchen - Main Course"
                : getUserType == "3"
                    ? "Cloud Kitchen - Desserts"
                    : getUserType == "4"
                        ? "Cloud Kitchen - Main Course & Desserts"
                        : getUserType == "5"
                            ? "Delivery Boy"
                            : getUserType == "6"
                                ? "Water Can Owner"
                                : getUserType == "7"
                                    ? "Product Seller"
                                    : getUserType == "8"
                                        ? "Meat Executive"
                                        : getUserType == "9"
                                            ? "Water Wash Service"
                                            : getUserType == "10"
                                                ? "Bike Transport"
                                                : getUserType == "11"
                                                    ? "Car Cab Transport"
                                                    : getUserType == "12"
                                                        ? "Load Van Transport"
                                                        : "Normal", getUserPincode: data['pincode'] ?? "",getUserReffererName: referrerName ?? ""
      );

      if (goalsSnapshot.size != 0) {
        users2.add(user);
      }
    });

    return users2;
  }

  UsrGoalsState getLoadingState() {
    return UsrGoalsState(status: ResStatus.loading, success: null, failure: "");
  }

  UsrGoalsState getSuccessState(userList) {
    return UsrGoalsState(
        status: ResStatus.success, success: userList, failure: "");
  }

  UsrGoalsState getFailureState(err) {
    return UsrGoalsState(status: ResStatus.failure, success: [], failure: err);
  }
}

class UsrGoalsState {
  ResStatus? status;
  List<User2>? success;
  String? failure;

  UsrGoalsState({this.status, this.success, this.failure});
}
