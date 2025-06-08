// ignore_for_file: dead_code

import 'dart:ffi';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tuple/tuple.dart';

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 45;

  static bool isAdmin = false;
  static bool isAdmin2 = false;
  static String adminDeviceToken = "";
  static String userDeviceToken = "";
  static String adminId = "0805080508";
  static String adminNo1 = "+919360840071";
  static String adminNo2 = "+919941445471";
  static String appVersion = "1.2.55";
  static String admin1Gpay = "9360840071";
  static String admin2Gpay = "9941445471";
  static String accessTokenFrNotificn = "";
  static String getUserName = "";
  static String getUserMobile = "";
  static String getUserArea = "";
  static String getUserPincode = "";
  static String getRefferer = "";





  static String? getAmazonUrl;
  static String? getFlipkartUrl;
  static String? getMyntraUrl;
  static String? getAjioUrl;
  static String? getMeatBasketAdminAccess;
  static String? getMaakaAdminPrimary;
  static String? getMaakaAdminSecondary;
  // static String? getMeeshoUrl;

  //todo:- Global App Theme Color
  static  Color primary = const Color(0xFF001B48);
  static Color secondary = const Color(0xFFFFFFFF);
  static Color primary1 = const Color(0xFF002E7B);
  static Color primary2 = const Color(0xFF95A1AC);
  static Color secondary1 = const Color(0xFF018ABE);
  static Color secondary2 = const Color(0xFF97CADB);
  static Color secondary3 = Colors.black87;
  static Color secondary4 = Colors.black;


  static Color deposite = const Color(0xFF2CA900);
  static Color withdrawal = const Color(0xFFBF1A0F);


  //todo:- color code for food customers

  static  Color colorFoodCPrimary = const Color(0xFFB22222);
  static  Color colorFoodCSecondaryWhite = const Color(0xFFffffff);
  static  Color colorFoodCSecondaryGrey1 = const Color(0xFFF5F5F5);
  static  Color colorFoodCSecondaryGrey2 = const Color(0xFFe6e6e6);
  static  Color colorFoodCSecondaryGrey3 = const Color(0xFFcccccc);


//todo:- color code for meat customers
  static  Color colorMeatCPrimary = const Color(0xFFB22222);
  static  Color colorMeatCSecondary = const Color(0xFFeb9393);
  static  Color colorMeatCSecondaryWhite = const Color(0xFFffffff);
  static  Color colorMeatCSecondaryGrey1 = const Color(0xFFF5F5F5);
  static  Color colorMeatCSecondaryGrey2 = const Color(0xFFe6e6e6);
  static  Color colorMeatCSecondaryGrey3 = const Color(0xFFcccccc);


  static bool? displayToast(ConnectivityResult result) {
    String message;
    switch (result) {
      case ConnectivityResult.wifi:
        message = 'Connected to WiFi';
        break;
        return true;
      case ConnectivityResult.mobile:
        message = 'Connected to mobile network';
        break;
        return true;
      case ConnectivityResult.none:
        message = 'No network connection';
        break;
        return false;
      default:
        message = 'Unknown network status';
        return false;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
    return null;
  }

  static void showToast(String toastMessage, ToastGravity? getToastGravity) {
    Fluttertoast.showToast(
      msg: toastMessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: getToastGravity,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

  static double? convertToDouble(String? s) {
    try {
      if (s == null) {
        throw FormatException('Input is null');
      }
      return double.parse(s);
    } catch (e) {
      print('Error: ${e.toString()}');
      return 0.0;
    }
  }

  static List<Tuple3<IconData, String, String>> iconOptions = [
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



  //todo:- 28.6.24 improving coding style in constants
  /// use code below with member , saying assigned during run time
  static const Color kTextColor =  Colors.black;
  static const Color kTextLightColor =  Color(0xFFACACAC);

  static double kDefaultPadding = 20.0;
}

//todo:- 24.11.23 - using global font styles for app
class GlobalTextStyles {
  static TextStyle primaryText1({
    double txtSize = 32.0,
    FontWeight txtWeight = FontWeight.bold,
    Color textColor = Colors.black,
    TextOverflow txtOverflow = TextOverflow.visible,
  }) {
    return TextStyle(
      fontSize: txtSize,
      letterSpacing: 2,
      fontWeight: txtWeight,
      color: textColor,
      fontFamily: 'Outfit',
      overflow: txtOverflow,
    );
  }

  static TextStyle primaryText2({
    double txtSize = 26.0,
    FontWeight txtWeight = FontWeight.bold,
    Color textColor = Colors.black,
    TextOverflow txtOverflow = TextOverflow.visible,
  }) {
    return TextStyle(
      fontSize: txtSize,
      letterSpacing: 2,
      fontWeight: txtWeight,
      color: textColor,
      fontFamily: 'Outfit',
      overflow: txtOverflow,
    );
  }

  static TextStyle secondaryText1({
    double txtSize = 18.0,
    FontWeight txtWeight = FontWeight.normal,
    Color? textColor = Colors.black,
    TextOverflow txtOverflow = TextOverflow.visible,
  }) {
    return TextStyle(
      fontSize: txtSize,
      letterSpacing: 1,
      fontWeight: txtWeight,
      color: textColor,
      fontFamily: 'Outfit',
      overflow: txtOverflow,
    );
  }

  static TextStyle secondaryText2({
    double txtSize = 15.0,
    FontWeight txtWeight = FontWeight.normal,
    Color textColor = Colors.black,
    TextOverflow txtOverflow = TextOverflow.visible,
  }) {
    return TextStyle(
      fontSize: txtSize,
      letterSpacing: 1,
      fontWeight: txtWeight,
      color: textColor,
      // fontFamily: 'Outfit',
      fontFamily: 'Encode Sans Condensed',
      overflow: txtOverflow,
    );
  }
}

enum NetworkConnection {
  wifi,
  mobile,
  none,
}

enum AffiliateAppType { amazon, flipkart, myntra, ajio, meesho }

var getNetworkConnection =
    StateProvider<NetworkConnection>((ref) => NetworkConnection.mobile);

enum PaymentService { maakaMoney, shopify, meatBasket }

enum UserType { normalUser, meatShopOwner,cloudKitchen, meatExecutive }