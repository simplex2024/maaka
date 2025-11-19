// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:tuple/tuple.dart';

enum ResStatus { init, loading, success, failure }

final adminDashListProvider =
    StateNotifierProvider<DashListNotifier, AdminDashState2>(
        (ref) => DashListNotifier(ref));

class DashListNotifier extends StateNotifier<AdminDashState2> {
  Ref ref;

  double getNetbalance = 0;
  double getTotalCredit = 0;
  double getTotalDebit = 0;

  double getNetIntbalance = 0;
  double getTotalIntCredit = 0;
  double getTotalIntDebit = 0;

  List<User>? userList = [];
  List<User2>? userList2 = [];
  List<ProductList>? productList = [];
  List<FoodList>? foodList = [];


  //todo:- Grocery Model
  List<GroceryList>? groceryList = [];

  List<Transaction>? transList = [];
  List<EnquiryList>? enquiryList = [];
  List<Transaction2>? transList2 = [];
  List<User>? moneyRequestUsers = [];
  List<User2>? moneyRequestUsers2 = [];
  List<User2>? cashBckRequestUsers2 = [];
  List<User2>? notifications = [];

  bool isPendingRequest = false;

  double? admnTtlCredit = 0.0;
  double? admnTtlDebit = 0.0;
  double? totalNet = 0.0;
  double? admnTtlIntCredit = 0.0;
  double? admnTtlIntDebit = 0.0;
  double? totalNetInt = 0.0;

  final txtSearch = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ConnectivityResult? data;

  DashListNotifier(this.ref)
      : super(AdminDashState2(
            status: ResStatus.init, success1: [], success2: [], failure: ""));

  Future<void> getDashboardDetails() async {
    //getHeaderDetails();
    // getNetbalance = 0;
    getTotalCredit = 0.0;
    getTotalDebit = 0.0;
    //
    // getNetIntbalance = 0;
    getTotalIntCredit = 0.0;
    getTotalIntDebit = 0.0;

    ref.read(isPendingReq.notifier).state = 0;
    ref.read(isPendingCashbckReq.notifier).state = 0;
    ref.read(isPendingMessages.notifier).state = 0;
    if (ref.read(adminDashListProvider.notifier).data ==
        ConnectivityResult.none) {
      Constants.showToast("No Internet Connection", ToastGravity.BOTTOM);
      return;
    }

    ref.read(getListItemProvider.notifier).state = [];
    state = getLoadingState();
    userList2 = await fetchUsersList2();
    enquiryList = await fetchEnquiryList();

    productList = await fetchProductList();
    foodList = await fetchFoodList(Constants.adminNo2 ?? "+919941445471");
    groceryList = await fetchGroceryList(Constants.adminNo2 ?? "+919941445471");

    // usersWitGoals = await fetchUserGoals();
    ref.read(getListItemProvider.notifier).state = userList2;
    state = getSuccessState(userList2, transList);
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

      // bool? isGoalsFound = await isGoalFound(doc.id);



      //todo:- get refferer name - 1213

      // 🔹 Get referrer name using the map
      final referrerName = mobileToNameMap[data['reffererNumber']] ?? 'N/A';

      print("Referrer name: $referrerName");

      //todo

      QuerySnapshot goalsSnapshot = await ref
          .read(adminDashListProvider.notifier)
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
        transactions: transList2 ?? [],
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
                                                        : "Normal",
        getUserPincode: data['pincode'] ?? "",
        getUserReffererName: referrerName ?? "N/A"
      );
      if (goalsSnapshot.size != 0) {
        users2.add(user);
      }
    });

    return users2;
  }

  Future<List<User2>> fetchUsersList2() async {
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
    moneyRequestUsers2 = [];
    cashBckRequestUsers2 = [];
    notifications = [];

    await Future.forEach(userSnapshot.docs, (doc) async {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;


      //todo:- get refferer name - 1213

      // 🔹 Get referrer name using the map
      final referrerName = mobileToNameMap[data['reffererNumber']] ?? 'N/A';

      print("Referrer name: $referrerName");

      //todo


      //todo:- below code, will check for empty message for user
      // bool? isMessages = await isCollectionEmpty(doc.id);

      //todo:- 1.9.23 - if field updated with wrong data type, below code is to resolve error
      // var name = data['name'];
      // if (name == "Babu") {
      //   //todo:- 1.9.23  adding specific field value to collection
      //   DocumentSnapshot snapshot = await FirebaseFirestore.instance
      //       .collection('users')
      //       .doc(doc.id)
      //       .get();
      //
      //   Map<String, dynamic> newUserData = {};
      //   newUserData = {
      //     // 'totalDebit': getFinalUsrDebit?.toDouble(),
      //     'totalIntDebit': 0.10,
      //     // 'netTotal': getFinalNetTotal,
      //     // 'netIntTotal': getFinalNetIntTotal,
      //   };
      //
      //   await updateUserDetails(newUserData, snapshot);
      //
      //   return;
      // }

      bool? isMoneyRequest = data['isMoneyRequest'];
      bool? isNotificationByAdmin = data['notificationByAdmin'];
      bool? isCashbckRequest = data['isCashbackRequest'];

      if (isMoneyRequest!) {
        ref.read(isPendingReq.notifier).state =
            (ref.read(isPendingReq.notifier).state! + 1)!;
        String? getUserType = data['userType'] ?? "";
        User2 user = User2(
          name: getUserType != "0"
              ? "${data['name']} Client"
              : "${data['name']} ",
          total: data['total'],
          interest: data['totalIntCredit'],
          mobile: data['mobile'],
          docId: doc.id,
          isMoneyRequest: data['isMoneyRequest'],
          requestAmount: data['requestAmnt'],
          isNotificationByAdmin: data['notificationByAdmin'],
          transactions: transList2 ?? [],
          totalCredit: data['totalCredit'],
          totalDebit: data['totalDebit'],
          totalIntCredit: data['totalIntCredit'],
          totalIntDebit: data['totalIntDebit'],
          getSecurityCode: data['securityCode'],
          isCashBackRequest: data['isCashbackRequest'],
          requestCashbckAmount: data['requestCashbckAmnt'],
          getAdminType: data['mappedAdmin'],
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
                                                          : "Normal",
          getUserPincode: data['pincode'] ?? "",getUserReffererName: referrerName ?? ""
        );
        moneyRequestUsers2?.add(user);
      }

      if (isCashbckRequest!) {
        ref.read(isPendingCashbckReq.notifier).state =
            (ref.read(isPendingCashbckReq.notifier).state! + 1)!;
        String? getUserType = data['userType'] ?? "";
        User2 user = User2(
          name: getUserType != "0"
              ? "${data['name']} Client"
              : "${data['name']} ",
          total: data['total'],
          interest: data['totalIntCredit'],
          mobile: data['mobile'],
          docId: doc.id,
          isMoneyRequest: data['isMoneyRequest'],
          requestAmount: data['requestAmnt'],
          isNotificationByAdmin: data['notificationByAdmin'],
          transactions: transList2 ?? [],
          totalCredit: data['totalCredit'],
          totalDebit: data['totalDebit'],
          totalIntCredit: data['totalIntCredit'],
          totalIntDebit: data['totalIntDebit'],
          getSecurityCode: data['securityCode'],
          isCashBackRequest: data['isCashbackRequest'],
          requestCashbckAmount: data['requestCashbckAmnt'],
          getAdminType: data['mappedAdmin'],
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
                                                          : "Normal",
          getUserPincode: data['pincode'] ?? "",getUserReffererName: referrerName ?? ""
        );
        cashBckRequestUsers2?.add(user);
      }

      // if (isMessages == true) {
      //   isNotificationByAdmin = true;
      // }

      if (isNotificationByAdmin! == false) {
        ref.read(isPendingMessages.notifier).state =
            (ref.read(isPendingMessages.notifier).state! + 1)!;
        // ref.read(isPendingReq.notifier).state =
        //     (ref.read(isPendingReq.notifier).state! + 1)!;
        String? getUserType = data['userType'] ?? "";
        User2 user = User2(
          name: getUserType != "0"
              ? "${data['name']} Client"
              : "${data['name']} ",
          total: data['total'],
          interest: data['totalIntCredit'],
          mobile: data['mobile'],
          docId: doc.id,
          isMoneyRequest: data['isMoneyRequest'],
          requestAmount: data['requestAmnt'],
          isNotificationByAdmin: data['notificationByAdmin'],
          transactions: transList2 ?? [],
          totalCredit: data['totalCredit'],
          totalDebit: data['totalDebit'],
          totalIntCredit: data['totalIntCredit'],
          totalIntDebit: data['totalIntDebit'],
          getSecurityCode: data['securityCode'],
          isCashBackRequest: data['isCashbackRequest'],
          requestCashbckAmount: data['requestCashbckAmnt'],
          getAdminType: data['mappedAdmin'],
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
                                                          : "Normal",
          getUserPincode: data['pincode'] ?? "",getUserReffererName: referrerName ?? ""
        );
        notifications?.add(user);
      }

      // bool? isGoalsFound = await isGoalFound(doc.id);
      bool? isGoalsFound = false;
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
        transactions: transList2 ?? [],
        totalCredit: data['totalCredit'],
        totalDebit: data['totalDebit'],
        totalIntCredit: data['totalIntCredit'],
        totalIntDebit: data['totalIntDebit'],
        getSecurityCode: data['securityCode'],
        isCashBackRequest: data['isCashbackRequest'],
        requestCashbckAmount: data['requestCashbckAmnt'],
        getAdminType: data['mappedAdmin'],
        isUserSetupGoals: isGoalsFound,
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
                                                        : "Normal",
        getUserPincode: data['pincode'] ?? "",getUserReffererName: referrerName ?? ""
      );
      users2.add(user);
    });

    return users2;
  }

  Future<List<ProductList>> fetchProductList() async {
    QuerySnapshot userSnapshot = await firestore.collection('banners').get();

    List<ProductList> getProducts = [];

    await Future.forEach(userSnapshot.docs, (doc) async {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      List<dynamic> imageUrls =
          (doc.data() as Map<String, dynamic>?)?.containsKey('fileUrls') ??
                  false
              ? doc['fileUrls']
              : [];

      String getTitle =
          (doc.data() as Map<String, dynamic>?)?.containsKey('title') ?? false
              ? doc['title']
              : "";

      String getDescription =
          (doc.data() as Map<String, dynamic>?)?.containsKey('description') ??
                  false
              ? doc['description']
              : "";

      String getAmount =
          (doc.data() as Map<String, dynamic>?)?.containsKey('amount') ?? false
              ? doc['amount']
              : "";
      String getBargainAmount = (doc.data() as Map<String, dynamic>?)
                  ?.containsKey('minBargainAmount') ??
              false
          ? doc['minBargainAmount']
          : "";

      String getProdDetails = (doc.data() as Map<String, dynamic>?)
                  ?.containsKey('productDetails') ??
              false
          ? doc['productDetails']
          : "";

      String getProdSpec =
          (doc.data() as Map<String, dynamic>?)?.containsKey('productSpec') ??
                  false
              ? doc['productSpec']
              : "";

      String getAffiliate =
          (doc.data() as Map<String, dynamic>?)?.containsKey('affiliateLink') ??
                  false
              ? doc['affiliateLink']
              : "";

      String getProductCategory = (doc.data() as Map<String, dynamic>?)
                  ?.containsKey('productCategory') ??
              false
          ? doc['productCategory']
          : "";

      ProductList getProductList = ProductList(
        affiliateLink: getAffiliate,
        amount: getAmount,
        description: getDescription,
        fileUrls: imageUrls,
        minBargainAmount: getBargainAmount,
        productCategory: getProductCategory,
        productDetails: getProdDetails,
        productSpec: getProdSpec,
        title: getTitle,
        docID: doc.id,
      );
      getProducts.add(getProductList);
    });

    return getProducts;
  }

  Future<List<FoodList>> fetchFoodList(String? getMobile) async {
    QuerySnapshot userSnapshot =
        await firestore.collection('AreaFoodPrices').doc(getMobile).collection('Foods').get();

    List<FoodList> getProducts = [];

    await Future.forEach(userSnapshot.docs, (doc) async {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      List<dynamic> imageUrls =
          (doc.data() as Map<String, dynamic>?)?.containsKey('fileUrls') ??
                  false
              ? doc['fileUrls']
              : [];

      String getTitle =
          (doc.data() as Map<String, dynamic>?)?.containsKey('title') ?? false
              ? doc['title']
              : "";

      String getDescription =
          (doc.data() as Map<String, dynamic>?)?.containsKey('description') ??
                  false
              ? doc['description']
              : "";

      String getAmount =
          (doc.data() as Map<String, dynamic>?)?.containsKey('amount') ?? false
              ? doc['amount']
              : "";
      String getBargainAmount = (doc.data() as Map<String, dynamic>?)
                  ?.containsKey('minBargainAmount') ??
              false
          ? doc['minBargainAmount']
          : "";

      String getProdDetails = (doc.data() as Map<String, dynamic>?)
                  ?.containsKey('productDetails') ??
              false
          ? doc['productDetails']
          : "";

      String getProdSpec =
          (doc.data() as Map<String, dynamic>?)?.containsKey('productSpec') ??
                  false
              ? doc['productSpec']
              : "";

      String getAffiliate =
          (doc.data() as Map<String, dynamic>?)?.containsKey('affiliateLink') ??
                  false
              ? doc['affiliateLink']
              : "";

      String getProductCategory = (doc.data() as Map<String, dynamic>?)
                  ?.containsKey('productCategory') ??
              false
          ? doc['productCategory']
          : "";

      String getFoodAdminNo =
          (doc.data() as Map<String, dynamic>?)?.containsKey('foodAdminNo') ??
                  false
              ? doc['foodAdminNo']
              : "";

      FoodList getProductList = FoodList(
          amount: getAmount,
          description: getDescription,
          fileUrls: imageUrls,
          minBargainAmount: getBargainAmount,
          productCategory: getProductCategory,
          productDetails: getProdDetails,
          productSpec: getProdSpec,
          title: getTitle,
          docID: doc.id,
          getFoodAdminNo: getFoodAdminNo);
      getProducts.add(getProductList);
    });

    return getProducts;
  }


  //todo:- Grocery Model
  Future<List<GroceryList>> fetchGroceryList(String? getMobile) async {
    QuerySnapshot userSnapshot =
    await firestore.collection('AreaGroceryPrices').doc(getMobile).collection('Grocery').get();

    List<GroceryList> getProducts = [];

    await Future.forEach(userSnapshot.docs, (doc) async {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      List<dynamic> imageUrls =
      (doc.data() as Map<String, dynamic>?)?.containsKey('fileUrls') ??
          false
          ? doc['fileUrls']
          : [];

      String getTitle =
      (doc.data() as Map<String, dynamic>?)?.containsKey('title') ?? false
          ? doc['title']
          : "";

      String getDescription =
      (doc.data() as Map<String, dynamic>?)?.containsKey('description') ??
          false
          ? doc['description']
          : "";

      String getAmount =
      (doc.data() as Map<String, dynamic>?)?.containsKey('amount') ?? false
          ? doc['amount']
          : "";
      String getBargainAmount = (doc.data() as Map<String, dynamic>?)
          ?.containsKey('minBargainAmount') ??
          false
          ? doc['minBargainAmount']
          : "";

      String getProdDetails = (doc.data() as Map<String, dynamic>?)
          ?.containsKey('productDetails') ??
          false
          ? doc['productDetails']
          : "";

      String getProdSpec =
      (doc.data() as Map<String, dynamic>?)?.containsKey('productSpec') ??
          false
          ? doc['productSpec']
          : "";

      String getAffiliate =
      (doc.data() as Map<String, dynamic>?)?.containsKey('affiliateLink') ??
          false
          ? doc['affiliateLink']
          : "";

      String getProductCategory = (doc.data() as Map<String, dynamic>?)
          ?.containsKey('productCategory') ??
          false
          ? doc['productCategory']
          : "";

      String getGroceryAdminNo =
      (doc.data() as Map<String, dynamic>?)?.containsKey('groceryAdminNo') ??
          false
          ? doc['groceryAdminNo']
          : "";

      GroceryList getProductList = GroceryList(
          amount: getAmount,
          description: getDescription,
          fileUrls: imageUrls,
          minBargainAmount: getBargainAmount,
          productCategory: getProductCategory,
          productDetails: getProdDetails,
          productSpec: getProdSpec,
          title: getTitle,
          docID: doc.id,
          getGroceryAdminNo: getGroceryAdminNo);
      getProducts.add(getProductList);
    });

    return getProducts;
  }

//todo:- 1.9.23 dont delete
  // Future<void> updateUserDetails(
  //     Map<String, dynamic> newData, DocumentSnapshot snapshot) async {
  //   // QuerySnapshot snapshot = await _collectionReference!.limit(1).get();
  //   // FirebaseFirestore.instance.collection('adminDetails');
  //   CollectionReference? _collectionUsers;
  //   _collectionUsers = FirebaseFirestore.instance.collection('users');
  //   if (snapshot.id.isNotEmpty) {
  //     String documentId = snapshot.id;
  //     await _collectionUsers!
  //         .doc(documentId)
  //         .update(newData)
  //         .then((value) => null);
  //   }
  // }

  Future<bool> isGoalFound(
    String? getDocIds,
  ) async {
    QuerySnapshot transactionSnapshot = await ref
        .read(adminDashListProvider.notifier)
        .firestore
        .collection('users')
        .doc(getDocIds)
        .collection('goals')
        .get();

    if (transactionSnapshot.size == 0) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<EnquiryList>> fetchEnquiryList() async {
    QuerySnapshot userSnapshot = await firestore.collection('Enquiry').get();

    List<EnquiryList> enquiryList = [];

    await Future.forEach(userSnapshot.docs, (doc) async {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      //todo:- below code, will check for empty message for user
      // bool? isMessages = await isCollectionEmpty(doc.id);
      String? enquiryNo = data['mobile'];

      EnquiryList enquiry = EnquiryList(
        mobile: data['mobile'] ?? "",
        enquiryReason: data['enquiryReason'] ?? "",
        name: data['name'] ?? "",
        refNumber: data['refNumber'] ?? "",
      );
      enquiryList?.add(enquiry);

      // if (isMessages == true) {
      //   isNotificationByAdmin = true;
      // }
    });

    return enquiryList;
  }

  Future<bool?> isPendingMoneyReq() async {
    ref.read(adminDashListProvider.notifier).userList?.map((doc) {
      bool? isPendingAmount = doc?.isMoneyRequest;

      if (isPendingAmount!) {
        isPendingRequest = true;
        return;
      }
    });
  }

  Future<bool> isCollectionEmpty(String getDocId) async {
    QuerySnapshot messagesSnapshot = await firestore
        .collection('users')
        .doc(getDocId)
        .collection('messages')
        .limit(1)
        .get();

    return messagesSnapshot.docs.isEmpty;
  }

  Future<bool?> updateData(String? getDocId, bool? isSavingAmntReqPaid) async {
    String? documentId = getDocId;

    if (isSavingAmntReqPaid!) {
      try {
        await firestore.collection('users').doc(documentId).update({
          'isMoneyRequest': false,
        }).then((value) {
          Constants.showToast(
              "Money Request Status Updated", ToastGravity.CENTER);
          getDashboardDetails();
          return true;
        });
        return null; // Return null or a success message if desired
      } catch (error) {
        Constants.showToast("Request Failed, Try again!", ToastGravity.CENTER);
        return false; // Return the error message as a string
      }
    } else {
      try {
        await firestore.collection('users').doc(documentId).update({
          'isCashbackRequest': false,
        }).then((value) {
          Constants.showToast(
              "Money Request Status Updated", ToastGravity.CENTER);
          getDashboardDetails();
          return true;
        });
        return null; // Return null or a success message if desired
      } catch (error) {
        Constants.showToast("Request Failed, Try again!", ToastGravity.CENTER);
        return false; // Return the error message as a string
      }
    }
  }

  AdminDashState2 getLoadingState() {
    return AdminDashState2(
        status: ResStatus.loading, success1: null, success2: null, failure: "");
  }

  AdminDashState2 getSuccessState(userList, transList) {
    return AdminDashState2(
        status: ResStatus.success,
        success1: userList,
        success2: transList,
        failure: "");
  }

  AdminDashState2 getFailureState(err) {
    return AdminDashState2(
        status: ResStatus.failure, success1: [], success2: [], failure: err);
  }
}

var isPendingReq = StateProvider<int?>((ref) => 0);
var isPendingCashbckReq = StateProvider<int?>((ref) => 0);
var isPendingMessages = StateProvider<int?>((ref) => 0);
var isRefreshIndicator = StateProvider<bool?>((ref) => false);
var isUserRefreshIndicator = StateProvider<bool?>((ref) => false);
var getCredit =
    StateProvider<Tuple6>((ref) => Tuple6(0.0, 0.0, 0.0, 0.0, 0.0, 0.0));

var aaa = StateProvider<double?>((ref) => 0.0);

class AdminDashState {
  ResStatus? status;
  List<User>? success1;
  List<Transaction>? success2;
  String? failure;

  AdminDashState({this.status, this.success1, this.success2, this.failure});
}

class AdminDashState2 {
  ResStatus? status;
  List<User2>? success1;
  List<Transaction>? success2;
  String? failure;

  AdminDashState2({this.status, this.success1, this.success2, this.failure});
}

class User {
  String? name;
  String? mobile;
  String? total;
  double? interest;
  String? docId;
  bool? isNotificationByAdmin;
  bool? isMoneyRequest;
  double? requestAmount;

  // List<Transaction> transactions;

  User({
    required this.name,
    required this.mobile,
    required this.total,
    required this.interest,
    required this.docId,
    required this.isMoneyRequest,
    required this.requestAmount,
    required this.isNotificationByAdmin,
    // required this.transactions
  });
}

class User2 {
  String? name;
  String? mobile;
  double? total;
  double? interest;
  String? docId;
  bool? isNotificationByAdmin;
  bool? isMoneyRequest;
  bool? isCashBackRequest;
  double? requestAmount;
  double? requestCashbckAmount;
  List<Transaction2> transactions;
  double? totalCredit;
  double? totalDebit;
  double? totalIntCredit;
  double? totalIntDebit;
  int? getSecurityCode;
  String? getAdminType;
  bool? isUserSetupGoals;
  bool? isPendingPayment;
  String? notificationToken;
  String? userType;
  String? userReffererNo;
  String? userTypeDes;

  String? getUserPincode;
  String? getUserReffererName;

  String? getPaymentStatus() {
    bool? isPending = isPendingPayment;


    return (isPending ?? false) ? "pending" : "success";
  }


  double? getNetBal() {
    var getTotalCredit = totalCredit;
    var getTotalDebit = totalDebit;

    double getFinalBal = getTotalCredit! - getTotalDebit!;
    // print(getFinalBal);

    return getFinalBal;
  }

  double? getNetIntBal() {
    var getTotalCredit = totalIntCredit;
    var getTotalDebit = totalIntDebit;

    double getFinalBal = getTotalCredit! - getTotalDebit!;
    // print(getFinalBal);

    return getFinalBal;
  }

  User2(
      {required this.name,
      required this.mobile,
      required this.total,
      required this.interest,
      required this.docId,
      required this.isMoneyRequest,
      required this.isCashBackRequest,
      required this.requestAmount,
      required this.requestCashbckAmount,
      required this.isNotificationByAdmin,
      required this.transactions,
      required this.totalCredit,
      required this.totalDebit,
      required this.totalIntCredit,
      required this.totalIntDebit,
      required this.getSecurityCode,
      required this.getAdminType,
      this.isUserSetupGoals,
      required this.isPendingPayment,
      required this.notificationToken,
      required this.userType,
      required this.userReffererNo,
      required this.userTypeDes,
      required this.getUserPincode, required this.getUserReffererName});
}

class MeatOrder {
  String? name;
  String? mobile;
  String? meatType;
  String? area;
  String? weight;
  String? chickenoption;
  String? totalPrice;
  String? deliveryDate;
  String? deliveryTime;
  String? orderStatus;
  String? docID;

  String? userId;
  String? paymentStatus;
  String? deliveryAddress;
  String? remarks;
  String? reffererMobile;
  String? getUserReffererName;

  MeatOrder({
    required this.name,
    required this.mobile,
    required this.meatType,
    required this.area,
    required this.weight,
    required this.chickenoption,
    required this.totalPrice,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.orderStatus,
    required this.docID,
    required this.userId,
    required this.paymentStatus,
    required this.deliveryAddress,
    required this.remarks,
    required this.reffererMobile,
  });

  // Factory method to create a MeatOrder object from Firestore data
  factory MeatOrder.fromFirestore(DocumentSnapshot doc, String userId) {
    final data = doc.data() as Map<String, dynamic>;
    return MeatOrder(
      name: data['name'] ?? '',
      mobile: data['mobile'] ?? '',
      meatType: data['meatType'] ?? '',
      area: data['area'] ?? '',
      weight: data['weight'] ?? '',
      chickenoption: data['chickenoption'] ?? '',
      totalPrice: data['totalPrice'] ?? '',
      deliveryDate: data['deliveryDate'] ?? '',
      deliveryTime: data['deliveryTime'] ?? '',
      orderStatus: data['orderStatus'] ?? '',
      paymentStatus: data['paymentStatus'] ?? '',
      deliveryAddress: data['deliveryAddress'] ?? '',
      remarks: data['remarks'] ?? '',
      reffererMobile: data['reffererMobile'] ?? '',
      docID: doc.id,
      // Using the Firestore document ID
      userId: userId,
    );
  }
}

class FoodOrder {
  String? name;
  String? mobile;
  String? foodName;

  String? area;

  String? totalPrice;
  String? deliveryDate;
  String? deliveryTime;
  String? orderStatus;
  String? docID;

  String? userId;
  String? paymentStatus;
  String? deliveryAddress;
  String? remarks;
  String? reffererMobile;

  String? foodQuantity;

  FoodOrder(
      {required this.name,
      required this.mobile,
      required this.foodName,
      required this.area,
      required this.totalPrice,
      required this.deliveryDate,
      required this.deliveryTime,
      required this.orderStatus,
      required this.docID,
      required this.userId,
      required this.paymentStatus,
      required this.deliveryAddress,
      required this.remarks,
      required this.reffererMobile,
      required this.foodQuantity});

  // Factory method to create a MeatOrder object from Firestore data
  factory FoodOrder.fromFirestore(DocumentSnapshot doc, String userId) {
    final data = doc.data() as Map<String, dynamic>;
    return FoodOrder(
      name: data['name'] ?? '',
      mobile: data['mobile'] ?? '',
      area: data['area'] ?? '',
      totalPrice: data['totalPrice'] ?? '',
      deliveryDate: data['deliveryDate'] ?? '',
      deliveryTime: data['deliveryTime'] ?? '',
      orderStatus: data['orderStatus'] ?? '',
      paymentStatus: data['paymentStatus'] ?? '',
      deliveryAddress: data['deliveryAddress'] ?? '',
      remarks: data['remarks'] ?? '',
      reffererMobile: data['reffererMobile'] ?? '',
      docID: doc.id,
      // Using the Firestore document ID
      userId: userId,
      foodQuantity: data['foodQuantity'] ?? '',
      foodName: data['foodType'] ?? '',
    );
  }
}

///todo:- product model - 6.7.24 - important this product model is common for both user and admin, should not delete
class ProductList {
  String? affiliateLink;
  String? amount;
  String? description;
  List<dynamic> fileUrls;
  String? minBargainAmount;
  String? productCategory;
  String? productDetails;
  String? productSpec;
  String? title;
  String? docID;

  ProductList({
    required this.affiliateLink,
    required this.amount,
    required this.description,
    required this.fileUrls,
    required this.minBargainAmount,
    required this.productCategory,
    required this.productDetails,
    required this.productSpec,
    required this.title,
    required this.docID,
  });
}

///todo:- food model - 6.7.24 - important this product model is common for both user and admin, should not delete
class FoodList {
  String? amount;
  String? description;
  List<dynamic> fileUrls;
  String? minBargainAmount;
  String? productCategory;
  String? productDetails;
  String? productSpec;
  String? title;
  String? docID;
  String? getFoodAdminNo;

  FoodList(
      {required this.amount,
      required this.description,
      required this.fileUrls,
      required this.minBargainAmount,
      required this.productCategory,
      required this.productDetails,
      required this.productSpec,
      required this.title,
      required this.docID,
      required this.getFoodAdminNo});
}


//todo:- Grocery Model
class GroceryList {
  String? amount;
  String? description;
  List<dynamic> fileUrls;
  String? minBargainAmount;
  String? productCategory;
  String? productDetails;
  String? productSpec;
  String? title;
  String? docID;
  String? getGroceryAdminNo;

  GroceryList(
      {required this.amount,
        required this.description,
        required this.fileUrls,
        required this.minBargainAmount,
        required this.productCategory,
        required this.productDetails,
        required this.productSpec,
        required this.title,
        required this.docID,
        required this.getGroceryAdminNo});
}



class EnquiryList {
  String? mobile;
  String? enquiryReason;
  String? name;
  String? refNumber;

  EnquiryList({
    required this.mobile,
    required this.enquiryReason,
    required this.name,
    required this.refNumber,
  });
}

class Transaction {
  int? amount;
  double? interest;
  String? date;
  bool? isDeposit;
  String? mobile;

  Transaction({
    required this.amount,
    required this.date,
    required this.isDeposit,
    required this.mobile,
    required this.interest,
  });
}

class Transaction2 {
  int? amount;
  double? interest;
  String? date;
  bool? isDeposit;
  String? mobile;
  String? transDocId;
  Timestamp? timmeStamp;

  //todo:- newUpdate 7.5.24
  String? goalId;

  Transaction2(
      {required this.amount,
      required this.date,
      required this.isDeposit,
      required this.mobile,
      required this.interest,
      required this.transDocId,
      required this.timmeStamp,
      required this.goalId});
}

class AdminDetails {
  double? totalCredit;
  double? totalDebit;
  double? totalIntCredit;
  double? totalIntDebit;

  double? getNetBal() {
    var getTotalCredit = totalCredit;
    var getTotalDebit = totalDebit;

    double getFinalBal = getTotalCredit! - getTotalDebit!;
    print(getFinalBal);

    return getFinalBal;
  }

  double? getNetIntBal() {
    var getTotalCredit = totalIntCredit;
    var getTotalDebit = totalIntDebit;

    double getFinalBal = getTotalCredit! - getTotalDebit!;
    print(getFinalBal);

    return getFinalBal;
  }

  AdminDetails(
      {required this.totalCredit,
      required this.totalDebit,
      required this.totalIntCredit,
      required this.totalIntDebit});
}

var getListItemProvider = StateProvider<List<User2>?>((ref) => []);
var getTotalOrderCount = StateProvider<int?>((ref) => 0);
