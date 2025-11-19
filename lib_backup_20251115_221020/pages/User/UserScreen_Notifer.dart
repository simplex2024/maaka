import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maaakanmoney/pages/budget_copy/BudgetCopyController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

import '../../components/constants.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../update_money/update_money_widget.dart';
import 'Goals/GoalHistoryNotifier1.dart';

//todo points to note
//getting food owners list while getting user details on refresh and init search -123

final UserDashListProvider =
    StateNotifierProvider<DashListNotifier, UserDashListState>(
        (ref) => DashListNotifier(ref));

class DashListNotifier extends StateNotifier<UserDashListState> {
  Ref ref;

  double getUnallocated = 0.0;
  List<Transactionss>? transList = [];
  List<Cashbacks>? cashBackList = [];
  List<ProductList>? productList = [];

  List<FoodOwners>? foodOwnerList = [];


  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ConnectivityResult? data;
  List<DocumentSnapshot>? goalDocuments;

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

  //todo:- varialble for user screen
  double getNetbalance = 0;
  double getTotalCredit = 0;
  double getTotalDebit = 0;

  double getNetIntbalance = 0;
  double getTotalIntCredit = 0;
  double getTotalIntDebit = 0;

  String? getUser = "";
  String? getUserArea = "";
  String? getUserPincode = "";
  String? getReffererMobileNo = "";
  String? getUserType = "";
  String? getUserNominee = "";
  String? getUserNomineeMob = "";
  double? getLastReqAmount;
  double? getLastCashbckReqAmount;
  bool? getIsMoneyReq;
  bool? getIsCashbckReq;
  bool? getIsCanMoneyReq;
  bool? getIsCanCashbckReq;
  String? getDocId;
  bool isNotificationByAdmin = false;
  String? getAdminType = "";
  String? getUserInitial = "";
  String? getUserAddress = "";
  String? getReffererType = "";
  String? getReffererName = "";
  List<FoodList>? categoryProducts = [];

  List<GroceryList>? categoryGroceryProducts = [];

  DateTime? startDate;
  DateTime? endDate;

  // Tuple2<List<Goal>, String>? goalList;

  // List<Goal>? goalList;

  //todo:- 26.1.24 - getting user transactions using stream builder concept
  // late StreamController<List<Transaction>> _transactionsStreamController;
  late StreamController<List<Transactionss>> _transactionsStreamController =
      StreamController<List<Transactionss>>.broadcast();

  Stream<List<Transactionss>> get transactionsStream =>
      _transactionsStreamController.stream;

  DashListNotifier(this.ref)
      : super(UserDashListState(
            status: ResStatus.init, success: [], failure: ""));

  void dispose() {
    _transactionsStreamController.close();
  }

  Future<void> getUserDetails(String? getMobile, String? getReffererMob, bool? isReffererIsCloud ) async {
    if (data == ConnectivityResult.none) {
      Constants.showToast("No Internet Connection", ToastGravity.BOTTOM);
      return;
    }
    state = getLoadingState();
    //todo:- 26.1.24 , change regarding using streambuilder for user transactions
    // transList = await getUserTransactions(getMobile);
    // getUserTransactionsStream2(getMobile);
    cashBackList = await getUserCashbckTransactions(getMobile);

    //todo:-search code 123 getting food owner list
    // foodOwnerList = await fetchFoodCloudOwners();




    //todo:-  important product model is shared commonly by admin and user carefully change below code
    ref
        .read(adminDashListProvider.notifier)
        .productList = await fetchProductList();
    //todo:-  important food model is shared commonly by admin and user carefully change below code
    // ref
    //     .read(adminDashListProvider.notifier)
    //     .foodList = await fetchFoodList();

    // categoryProducts = await fetchFoodList((isReffererIsCloud ?? false) ? getReffererMob : getMobile ?? "");

    //store name and mob
    Constants.getUserName =
        ref.read(UserDashListProvider.notifier).getUser ?? "";
    Constants.getUserMobile = getMobile ?? "";
    Constants.getUserArea =        ref.read(UserDashListProvider.notifier).getUserArea ?? "";
    Constants.getUserPincode =        ref.read(UserDashListProvider.notifier).getUserPincode ?? "";
    Constants.getRefferer = ref.read(UserDashListProvider.notifier).getReffererMobileNo ?? "";

    getReffererType =
    await getReffererUserType(Constants.getRefferer ?? "9941445471");


    //todo:- based on user type and refferer type, pick up food details

    if(getUserType == "0"){
      categoryProducts = await fetchFoodList((getReffererType == "2") ?  Constants.getRefferer ?? "":    Constants.adminNo2 ?? "");
      categoryGroceryProducts = await fetchGroceryList((getReffererType == "6") ?  Constants.getRefferer ?? "":    Constants.adminNo2 ?? "");


    }else if(getUserType == "1"){
      categoryProducts = await fetchFoodList(   Constants.adminNo2 ?? "");
      categoryGroceryProducts = await fetchGroceryList(   Constants.adminNo2 ?? "");

    }else if(getUserType == "2"){
      categoryProducts = await fetchFoodList( Constants.getUserMobile ?? "");
      categoryGroceryProducts = await fetchGroceryList( Constants.adminNo2 ?? "");

    }else if(getUserType == "6"){
      categoryProducts = await fetchFoodList( Constants.adminNo2 ?? "");
      categoryGroceryProducts = await fetchGroceryList( Constants.getUserMobile ?? "");

    }else{
      categoryProducts = await fetchFoodList((getReffererType == "2") ?  Constants.getRefferer ?? "":    Constants.adminNo2 ?? "");
      categoryGroceryProducts = await fetchGroceryList((getReffererType == "2") ?  Constants.getRefferer ?? "":    Constants.adminNo2 ?? "");
    }

    // categoryProducts = await fetchFoodList((getReffererType == "2") ?  Constants.getRefferer ?? "":    Constants.adminNo2 ?? "");


    state = getSuccessState(transList);
  }


  //todo:- to get refferer user type
  Future<String?> getReffererUserType(String reffererMobile) async {
    final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

    final QuerySnapshot snapshot =
    await usersCollection.where('mobile', isEqualTo: reffererMobile).get();

    if (snapshot.docs.isNotEmpty) {
      final Map<String, dynamic> data =
      snapshot.docs.first.data() as Map<String, dynamic>;
      // getReffererName = data["name"];
      return data["userType"]; // Returns the specific field's value
    }
    return null;
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

      String getProductCategory =
      (doc.data() as Map<String, dynamic>?)?.containsKey('productCategory') ??
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
        title: getTitle, docID: doc.id,
      );
      getProducts.add(getProductList);
    });

    return getProducts;
  }

  Future<List<FoodList>> fetchFoodList(String? getMobile) async {
    // QuerySnapshot userSnapshot = await firestore.collection('AreaFoodPrices').doc(getMobile).collection('Foods').get();





    //todo:- start
    //to check for admin mobile no, if no records found , then search for default admins mobile
    String defaultMobile = Constants.adminNo2; // your fallback mobile number here

    Future<QuerySnapshot> fetchSnapshot(String mobile) {
      return firestore.collection('AreaFoodPrices').doc(getMobile).collection('Foods').get();
    }

    QuerySnapshot userSnapshot = await fetchSnapshot(getMobile ?? defaultMobile);

    // If no documents found, try with default mobile
    if (userSnapshot.docs.isEmpty && getMobile != defaultMobile) {
      userSnapshot = await fetchSnapshot(defaultMobile);
    }

    //todo:- end




    List<FoodList> getFoods = [];

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

      String getProductCategory =
      (doc.data() as Map<String, dynamic>?)?.containsKey('productCategory') ??
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
        title: getTitle, docID: doc.id,
        getFoodAdminNo: getFoodAdminNo
      );
      getFoods.add(getProductList);
    });

    return getFoods;
  }
  Future<List<GroceryList>> fetchGroceryList(String? getMobile) async {
    // QuerySnapshot userSnapshot = await firestore.collection('AreaGroceryPrices').doc(getMobile).collection('Grocery').get();

    //todo:- start
    //to check for admin mobile no, if no records found , then search for default admins mobile
     String defaultMobile = Constants.adminNo2; // your fallback mobile number here

    Future<QuerySnapshot> fetchSnapshot(String mobile) {
      return firestore.collection('AreaGroceryPrices').doc(mobile).collection('Grocery').get();
    }

    QuerySnapshot userSnapshot = await fetchSnapshot(getMobile ?? defaultMobile);

    // If no documents found, try with default mobile
    if (userSnapshot.docs.isEmpty && getMobile != defaultMobile) {
      userSnapshot = await fetchSnapshot(defaultMobile);
    }

    //todo:- end


    List<GroceryList> getFoods = [];

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

      String getProductCategory =
      (doc.data() as Map<String, dynamic>?)?.containsKey('productCategory') ??
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
          title: getTitle, docID: doc.id,
          getGroceryAdminNo: getGroceryAdminNo
      );
      getFoods.add(getProductList);
    });

    return getFoods;
  }


  Future<List<FoodOwners>> fetchFoodCloudOwners() async {
    QuerySnapshot userSnapshot = await firestore.collection('AreaFoodPrices').get();

    List<FoodOwners> getFoodOwners = [];

    await Future.forEach(userSnapshot.docs, (doc) async {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;



      String getFoodAdminCloudShopName =
      (doc.data() as Map<String, dynamic>?)?.containsKey('foodAdminCloudShopName') ?? false
          ? doc['foodAdminCloudShopName']
          : "";

      String getFoodAdminNo =
      (doc.data() as Map<String, dynamic>?)?.containsKey('foodAdminNo') ??
          false
          ? doc['foodAdminNo']
          : "";



      FoodOwners getFoodOwnersList = FoodOwners(
          foodAdminCloudShopName: getFoodAdminCloudShopName ?? "", foodAdminNo: getFoodAdminNo ?? "", foodAdminCloudShopTitle: '', foodAdminCloudShopDescription: '', getOwnerFoods: [],docId: doc.id,
      );
      getFoodOwners.add(getFoodOwnersList);
    });

    return getFoodOwners;
  }




//todo:- 26.1.24 adding stream builder for transactions
  Future<void> getUserTransactionsStream2(String? getMobile) async {
    getUser = await isUserVerified(getMobile);
    getUserInitial = getUser?[0];

    final CollectionReference transactionCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(getDocId)
        .collection('transaction');

    transactionCollection
        .where('timestamp', isGreaterThanOrEqualTo: startDate)
        .where('timestamp',
            isLessThanOrEqualTo: endDate == null
                ? endDate
                : DateTime(endDate!.year, endDate!.month, endDate!.day))
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((querySnapshot) {
      double totalCredit = 0;
      List<double> creditList = [];

      double totalDebit = 0;
      List<double> debitList = [];

//todo:- for interest
      double totalIntCredit = 0;
      List<double> creditIntList = [];

      double totalIntDebit = 0;
      List<double> debitIntList = [];

      final List<Transactionss> transactionList = querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final amount = data['amount'];
            final isDeposit = data['isDeposit'];
            final mobile = data['mobile'];
            final date = data['date'];
            final interest = data['interest'];
            final timeStamp = data['timestamp'];
            final goalId = data['goalId'];

            if (getMobile == (mobile)) {
              return Transactionss(
                  amount: amount,
                  date: date,
                  isDeposit: isDeposit,
                  mobile: mobile,
                  docId: doc.id,
                  goalDocId: goalId ?? "",
                  interest: interest,
                  timmeStamp: timeStamp);
            } else {
              return null;
            }
          })
          .whereType<Transactionss>()
          .toList();

      //todo:- calculating total debit and total credit
      creditList = querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final amount = data['amount'] as int;
            final isDeposit = data['isDeposit'] as bool;
            final mobile = data['mobile'] as String;

            if (getMobile == (mobile)) {
              if (isDeposit) {
                return amount.toDouble();
              } else {
                return null;
              }
            } else {
              return null;
            }
          })
          .whereType<double>()
          .toList();

      for (var transaction in creditList) {
        totalCredit += transaction;
      }

      debitList = querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final amount = data['amount'] as int;
            final isDeposit = data['isDeposit'] as bool;
            final mobile = data['mobile'] as String;

            if (getMobile == (mobile)) {
              if (isDeposit == false) {
                return amount.toDouble();
              } else {
                return null;
              }
            } else {
              return null;
            }
          })
          .whereType<double>()
          .toList();

      for (var transaction in debitList) {
        totalDebit += transaction;
      }

      getTotalCredit = totalCredit;

      getTotalDebit = totalDebit;

      double finalCredit = getTotalCredit;
      double finalDebit = getTotalDebit;
      getNetbalance = finalCredit - finalDebit;
      //todo:- 26.1.24 , adding notifier to net balance
      ref.read(getUserNetBal.notifier).state = finalCredit - finalDebit;
      ref.read(getUserCreditBal.notifier).state = finalCredit;
      ref.read(getUserDebitBal.notifier).state = finalDebit;

      //todo:- calculating Interest of total debit and total credit
      creditIntList = transactionList
          .map((doc) {
            // final data = doc. as Map<String, dynamic>;
            final intAmount = doc.interest as double;
            final isDeposit = doc.isDeposit as bool;
            final mobile = doc.mobile as String;

            if (getMobile == (mobile)) {
              if (isDeposit) {
                return intAmount.toDouble();
              } else {
                return null;
              }
            } else {
              return null;
            }
          })
          .whereType<double>()
          .toList();

      for (var transaction in creditIntList) {
        totalIntCredit += transaction;
      }

      getTotalIntCredit = totalIntCredit;

      double finalIntCredit = getTotalIntCredit;

      getNetIntbalance = finalIntCredit;

      //todo:- 26.1.24 adding obtained transaction list o stream
      _transactionsStreamController.add(transactionList);
      transList = transactionList ?? [];
    });
  }

  Future<List<Transactionss>> getUserTransactions(String? getMobile) async {
    double totalCredit = 0;
    List<double> creditList = [];

    double totalDebit = 0;
    List<double> debitList = [];

//todo:- for interest
    double totalIntCredit = 0;
    List<double> creditIntList = [];

    double totalIntDebit = 0;
    List<double> debitIntList = [];

    getUser = await isUserVerified(getMobile);
    getUserInitial = getUser?[0];

    final QuerySnapshot transactionSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(getDocId)
        .collection('transaction')
        .where('timestamp', isGreaterThanOrEqualTo: startDate)
        .where('timestamp',
            isLessThanOrEqualTo: endDate == null
                ? endDate
                : DateTime(endDate!.year, endDate!.month, endDate!.day))
        .orderBy('timestamp', descending: true)
        .get();

    final List<Transactionss> transactionList = transactionSnapshot.docs
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final amount = data['amount'];
          final isDeposit = data['isDeposit'];
          final mobile = data['mobile'];
          final date = data['date'];
          final interest = data['interest'];
          final timeStamp = data['timestamp'];
          final goalId = data['goalId'];

          if (getMobile == (mobile)) {
            return Transactionss(
                amount: amount,
                date: date,
                isDeposit: isDeposit,
                mobile: mobile,
                docId: doc.id,
                goalDocId: goalId ?? "",
                interest: interest,
                timmeStamp: timeStamp);
          } else {
            return null;
          }
        })
        .whereType<Transactionss>()
        .toList();

    //todo:- calculating total debit and total credit
    creditList = transactionSnapshot.docs
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final amount = data['amount'] as int;
          final isDeposit = data['isDeposit'] as bool;
          final mobile = data['mobile'] as String;

          if (getMobile == (mobile)) {
            if (isDeposit) {
              return amount.toDouble();
            } else {
              return null;
            }
          } else {
            return null;
          }
        })
        .whereType<double>()
        .toList();

    for (var transaction in creditList) {
      totalCredit += transaction;
    }

    debitList = transactionSnapshot.docs
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final amount = data['amount'] as int;
          final isDeposit = data['isDeposit'] as bool;
          final mobile = data['mobile'] as String;

          if (getMobile == (mobile)) {
            if (isDeposit == false) {
              return amount.toDouble();
            } else {
              return null;
            }
          } else {
            return null;
          }
        })
        .whereType<double>()
        .toList();

    for (var transaction in debitList) {
      totalDebit += transaction;
    }

    getTotalCredit = totalCredit;

    getTotalDebit = totalDebit;

    double finalCredit = getTotalCredit;
    double finalDebit = getTotalDebit;
    getNetbalance = finalCredit - finalDebit;

    //todo:- calculating Interest of total debit and total credit
    creditIntList = transactionList
        .map((doc) {
          // final data = doc. as Map<String, dynamic>;
          final intAmount = doc.interest as double;
          final isDeposit = doc.isDeposit as bool;
          final mobile = doc.mobile as String;

          if (getMobile == (mobile)) {
            if (isDeposit) {
              return intAmount.toDouble();
            } else {
              return null;
            }
          } else {
            return null;
          }
        })
        .whereType<double>()
        .toList();

    for (var transaction in creditIntList) {
      totalIntCredit += transaction;
    }

    getTotalIntCredit = totalIntCredit;

    double finalIntCredit = getTotalIntCredit;

    getNetIntbalance = finalIntCredit;

    return transactionList;
  }

  Future<List<Cashbacks>> getUserCashbckTransactions(String? getMobile) async {
    double totalIntDebit = 0;
    List<double> debitIntList = [];

    getUser = await isUserVerified(getMobile);

    final QuerySnapshot cashbackSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(getDocId)
        .collection('cashbacks')
        .where('timestamp', isGreaterThanOrEqualTo: startDate)
        .where('timestamp',
            isLessThanOrEqualTo: endDate == null
                ? endDate
                : DateTime(endDate!.year, endDate!.month, endDate!.day))
        .orderBy('timestamp', descending: true)
        .get();

    final List<Cashbacks> transactionList = cashbackSnapshot.docs
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final amount = data['amount'];
          final isCashbckDep = data['isCashbckDeposit'];
          final mobile = data['mobile'];
          final date = data['date'];

          if (getMobile == (mobile)) {
            return Cashbacks(
              amount: amount,
              date: date,
              isCashbackDeposit: isCashbckDep,
              mobile: mobile,
              docId: doc.id,
            );
          } else {
            return null;
          }
        })
        .whereType<Cashbacks>()
        .toList();

    //todo:- calculating Interest of total debit
    debitIntList = transactionList
        .map((doc) {
          // final data = doc. as Map<String, dynamic>;
          final intAmount = doc.amount as double;
          final isCashbckDeposit = doc.isCashbackDeposit as bool;
          final mobile = doc.mobile as String;

          if (getMobile == (mobile)) {
            if (isCashbckDeposit == false) {
              return intAmount.toDouble();
            } else {
              return null;
            }
          } else {
            return null;
          }
        })
        .whereType<double>()
        .toList();

    for (var transaction in debitIntList) {
      totalIntDebit += transaction;
    }

    getTotalIntDebit = totalIntDebit;

    double finalIntDebit = getTotalIntDebit;
    double finalIntCredit = getTotalIntCredit;

    getNetIntbalance = finalIntCredit - finalIntDebit;

    return transactionList;
  }

  Future<Tuple2<List<Goal>, String>> updateGoalDetails(
      List<DocumentSnapshot>? getGoalData,
      List<Tuple3<IconData, String, String>> iconOptions) async {
    try {
      getUnallocated = 0.0;

      double remainingBalance =
          ref.read(UserDashListProvider.notifier).getNetbalance;

      final List<Goal> goalList = getGoalData!
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
              goalAllocation =
                  ref.read(UserDashListProvider.notifier).getNetbalance *
                      0.5; // Priority 1 - 50% changed remainingBalance *
            } else if (goalPriority == 2) {
              goalAllocation =
                  ref.read(UserDashListProvider.notifier).getNetbalance *
                      0.3; // Priority 2 - 30%
              print(goalAllocation);
            } else if (goalPriority == 3) {
              goalAllocation =
                  ref.read(UserDashListProvider.notifier).getNetbalance *
                      0.2; // Priority 3 - 20%
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

      return Tuple2(goalList, "Success");
    } catch (error) {
// Handle errors here
      return Tuple2([], "Failed to fetch data: $error");
    }
  }

  //todo:- 4.10.23 Helper function to group transactions by date
  Map<String, List<Transactionss>> groupTransactionsByDate(
      List<Transactionss> transactions) {
    final groupedTransactions = <String, List<Transactionss>>{};
    for (final transaction in transactions) {
      final date =
          transaction.date.toString(); // Assuming date is stored as a string
      if (groupedTransactions[date] == null) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]?.add(transaction);
    }
    return groupedTransactions;
  }

  //todo:- 4.10.23 Helper function to group transactions by date for cashback
  Map<String, List<Cashbacks>> groupTransactionsByDate1(
      List<Cashbacks> transactions) {
    final groupedTransactions = <String, List<Cashbacks>>{};
    for (final transaction in transactions) {
      final date =
          transaction.date.toString(); // Assuming date is stored as a string
      if (groupedTransactions[date] == null) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]?.add(transaction);
    }
    return groupedTransactions;
  }

  Future<String?> isUserVerified(String? phoneNumber) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('mobile', isEqualTo: phoneNumber)
        .get();

    if (querySnapshot.docs.isEmpty) {
      // Phone number does not exist in the Firestore table
      return "";
    }

    var user = querySnapshot.docs.first.data() as Map<String, dynamic>?;
    getUserArea = user?['area'] ?? "";
    getUserPincode = user?['pincode'] ?? "";
    getUser = user?['name'] ?? "";
    getUserNominee = user?['nominName'] ?? "";
    getUserNomineeMob = user?['nominMobile'] ?? "";
    getLastReqAmount = user?['requestAmnt'] ?? "";
    getLastCashbckReqAmount = user?['requestCashbckAmnt'] ?? "";
    getIsMoneyReq = user?['isMoneyRequest'] ?? "";
    getIsCashbckReq = user?['isCashbackRequest'] ?? "";
    getUserAddress = user?['address'] ?? "";
    getIsCanMoneyReq = user?['isCanMoneyReq'] ?? "";
    getIsCanCashbckReq = user?['isCanCashbackReq'] ?? "";

    getDocId = querySnapshot.docs.first.id;
    isNotificationByAdmin = user?['notificationByAdmin'] ?? "";
    getAdminType = user?['mappedAdmin'] ?? "";
    getUserType = user?['userType'] ?? "";
    getReffererMobileNo = user?['reffererNumber'] ?? "";
    ref.read(txtPaidStatus.notifier).state = getIsMoneyReq;
    ref.read(txtCashbckPaidStatus.notifier).state = getIsCashbckReq;

    ref.read(txtMoneyReqCanStatus.notifier).state = getIsCanMoneyReq;
    ref.read(txtCashbckReqCanStatus.notifier).state = getIsCanCashbckReq;

    return getUser;
  }

  Future<bool?> updateData(
      bool? isMoneyReq,
      double? getReqAmount,
      String? getDocId,
      String? getMobile,
      TextEditingController? getText,
      String? getGoalDocId) async {
    String? documentId = getDocId;

    if (data == ConnectivityResult.none) {
      Constants.showToast("No Internet Connection", ToastGravity.BOTTOM);
      return false;
    }

    if (isMoneyReq!) {
      try {
        await firestore.collection('users').doc(documentId).update({
          'isMoneyRequest': true,
          'requestAmnt': getReqAmount,
          'isCanMoneyReq': false,
        }).then((value) async {
          getText?.text = "";
          Constants.showToast(
              "Money Requested Successfully", ToastGravity.CENTER);
          getUserDetails(getMobile,"",false);

          //todo:- 4.2.24 - adding dummy withdrawal request
          await addDummyWithdrawalTransaction(
              getReqAmount, getMobile, getGoalDocId);

          return true;
        });
        return null; // Return null or a success message if desired
      } catch (error) {
        getText?.text = "";
        Constants.showToast("Request Failed, Try again!", ToastGravity.CENTER);
        return false; // Return the error message as a string
      }
    } else {
      try {
        await firestore.collection('users').doc(documentId).update({
          'isCashbackRequest': true,
          'requestCashbckAmnt': getReqAmount,
          'isCanCashbackReq': false,
        }).then((value) {
          getText?.text = "";
          Constants.showToast(
              "Money Requested Successfully", ToastGravity.CENTER);
          getUserDetails(getMobile,"",false);
          return true;
        });
        return null; // Return null or a success message if desired
      } catch (error) {
        getText?.text = "";
        Constants.showToast("Request Failed, Try again!", ToastGravity.CENTER);
        return false; // Return the error message as a string
      }
    }
  }

  //todo:- 4.2.24 - adding dummy withdrawal request

  Future<void> addDummyWithdrawalTransaction(
      double? getAmount, String? getMob, String? getGoalDocId) async {
    try {
      // Simulating some asynchronous operation
      // await Future.delayed(Duration(seconds: 2));

      Timestamp timestamp = Timestamp.fromDate(DateTime.now());

      try {
        //todo:- adding transaction inside user's table
        firestore
            .collection('users')
            .doc(ref.read(UserDashListProvider.notifier).getDocId)
            .collection('transaction')
            .add({
          'mobile': getMob,
          'isDeposit': false,
          'isCashbckDeposit': true,
          'amount': 0,
          'interest': 0.0,
          'date': DateFormat('yyyy-MM-dd')
              .format(DateTime.now()), // Only date in 'yyyy-MM-dd' format
          // 'timestamp': DateTime.now(),
          'timestamp': timestamp,
          'goalId': getGoalDocId,
        }).then((_) async {
          //todo:- 28.1.24 - when user tries to goes to payment method, in user details, pending payment flag is updated
          await updatePaymentPendingRequest(
            ref.read(UserDashListProvider.notifier).getDocId,
          );

          Constants.showToast(
              "Withdrawal Request is under Processing", ToastGravity.BOTTOM);
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

  Future<void> updatePaymentPendingRequest(
    String? getDocId,
  ) async {
    String? documentId = getDocId;

    try {
      await firestore.collection('users').doc(documentId).update({
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

  Future<bool?> canclRequest(
      String? getDocId, bool? isSavingAmntReqPaid, String? getMobile) async {
    String? documentId = getDocId;

    if (isSavingAmntReqPaid!) {
      try {
        await firestore.collection('users').doc(documentId).update({
          'isMoneyRequest': false,
          'isCanMoneyReq': true,
        }).then((value) {
          Constants.showToast(
              "Money Request Cancelled Successfully", ToastGravity.CENTER);
          getUserDetails(getMobile,"",false);
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
          'isCanCashbackReq': true,
        }).then((value) {
          Constants.showToast(
              "Cashback Request Cancelled Successfully", ToastGravity.CENTER);
          getUserDetails(getMobile,"",false);
          return true;
        });
        return null; // Return null or a success message if desired
      } catch (error) {
        Constants.showToast("Request Failed, Try again!", ToastGravity.CENTER);
        return false; // Return the error message as a string
      }
    }
  }

  UserDashListState getLoadingState() {
    return UserDashListState(
        status: ResStatus.loading, success: null, failure: "");
  }

  UserDashListState getSuccessState(transList) {
    return UserDashListState(
        status: ResStatus.success, success: transList, failure: "");
  }

  UserDashListState getFailureState(err) {
    return UserDashListState(
        status: ResStatus.failure, success: [], failure: err);
  }
}

class UserDashListState {
  ResStatus? status;
  List<Transactionss>? success;
  String? failure;

  UserDashListState({this.status, this.success, this.failure});
}

class Transactionss {
  int? amount;
  double? interest;
  String? date;
  bool? isDeposit;
  String? mobile;
  final String docId;
  final String goalDocId;
  Timestamp? timmeStamp;

  Transactionss(
      {required this.amount,
      required this.date,
      required this.isDeposit,
      required this.mobile,
      required this.docId,
      required this.goalDocId,
      required this.interest,
      required this.timmeStamp});
}

//todo:- 31.8.23
class Cashbacks {
  double? amount;
  String? date;
  bool? isCashbackDeposit;
  String? mobile;
  final String docId;

  Cashbacks({
    required this.amount,
    required this.date,
    required this.isCashbackDeposit,
    required this.mobile,
    required this.docId,
  });
}

//todo:- maintain cloud kitchen owner

class FoodOwners {
  String? foodAdminCloudShopName;
  String? foodAdminNo;
  String? foodAdminCloudShopTitle;
  String? foodAdminCloudShopDescription;

  List<OwnerFoods> getOwnerFoods;
  final String docId;



  FoodOwners(
      {required this.foodAdminCloudShopName,
        required this.foodAdminNo,
        required this.foodAdminCloudShopTitle,
        required this.foodAdminCloudShopDescription,
        required this.getOwnerFoods,required this.docId,});

}

class OwnerFoods {
  String? amount;
  String? description;


  List<dynamic> fileUrls;
  String? foodAdminNo;
  String? minBargainAmount;
  String? productCategory;
  String? productDetails;
  String? productSpec;
  String? title;



  OwnerFoods(
      {required this.amount,
        required this.description,
        required this.fileUrls,

        required this.foodAdminNo,
        required this.minBargainAmount,
        required this.productCategory,
        required this.productDetails,
        required this.productSpec,
        required this.title,});

}







var txtPaidStatus = StateProvider<bool?>((ref) => false);
var txtCashbckPaidStatus = StateProvider<bool?>((ref) => false);

var txtMoneyReqCanStatus = StateProvider<bool?>((ref) => false);
var txtCashbckReqCanStatus = StateProvider<bool?>((ref) => false);

var getUserNetBal = StateProvider<double?>((ref) => 0.0);
var getUserCreditBal = StateProvider<double?>((ref) => 0.0);
var getUserDebitBal = StateProvider<double?>((ref) => 0.0);
var getUserCashbakNetBal = StateProvider<double?>((ref) => 0.0);
var getUserCashbakCreditBal = StateProvider<double?>((ref) => 0.0);
var getUserCashbakDebitBal = StateProvider<double?>((ref) => 0.0);
var getUserGoalBal = StateProvider<double>((ref) => 0.0);
