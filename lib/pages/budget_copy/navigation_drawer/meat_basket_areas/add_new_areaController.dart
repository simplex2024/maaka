// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:maaakanmoney/pages/budget_copy/BudgetCopyController.dart';
import 'package:tuple/tuple.dart';

final areaListProvider = StateNotifierProvider<AreaListNotifier, AreaState>(
    (ref) => AreaListNotifier(ref));

class AreaListNotifier extends StateNotifier<AreaState> {
  Ref ref;

  List<MeatBasketAreaList>? areaList = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ConnectivityResult? data;

  AreaListNotifier(this.ref)
      : super(AreaState(status: ResStatus.init, success: [], failure: ""));

  Future<void> getMeatBasketAreaDetails() async {
    if (ref.read(areaListProvider.notifier).data == ConnectivityResult.none) {
      Constants.showToast("No Internet Connection", ToastGravity.BOTTOM);
      return;
    }

    // ref.read(getListItemProvider.notifier).state = [];
    state = getLoadingState();
    areaList = await fetchAreaList();

    state = getSuccessState(areaList);
  }

  Future<List<MeatBasketAreaList>> fetchAreaList() async {
    QuerySnapshot userSnapshot =
        await firestore.collection('AreaMeatPrices').get();

    List<MeatBasketAreaList> getProducts = [];

    await Future.forEach(userSnapshot.docs, (doc) async {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      String getareaName = doc.id;

      // Extracting chicken prices
      Map<String, dynamic>? chickenData = data[getareaName]?['Chicken'];
      String areaPriceChickenWithSkin =
          chickenData?['AreaPrice']?['WithSkin']?.toString() ?? "0";
      String areaPriceChickenWithoutSkin =
          chickenData?['AreaPrice']?['WithoutSkin']?.toString() ?? "0";
      String ourPriceChickenWithSkin =
          chickenData?['OurPrice']?['WithSkin']?.toString() ?? "0";
      String ourPriceChickenWithoutSkin =
          chickenData?['OurPrice']?['WithoutSkin']?.toString() ?? "0";

      // Extracting mutton prices
      Map<String, dynamic>? muttonData = data[getareaName]?['Mutton'];
      String areaPriceMutton = muttonData?['AreaPrice']?.toString() ?? "0";
      String ourPriceMutton = muttonData?['OurPrice']?.toString() ?? "0";

      //todo:- 29.3.25 - new implementation for meat types
      //todo:- chicken
      Map<String, dynamic>? ChickenBonelessData =
          data[getareaName]?['ChickenBoneless'];
      String areaPriceChickenBonelessData =
          ChickenBonelessData?['Area Price']?.toString() ?? "0";
      String ourPriceChickenBonelessData =
          ChickenBonelessData?['Our Price']?.toString() ?? "0";

      Map<String, dynamic>? ChickenChestPieceData =
          data[getareaName]?['ChickenChestPiece'];
      String areaPriceChickenChestPieceData =
          ChickenChestPieceData?['Area Price']?.toString() ?? "0";
      String ourPriceChickenChestPieceData =
          ChickenChestPieceData?['Our Price']?.toString() ?? "0";

      Map<String, dynamic>? ChickenLegPieceData =
          data[getareaName]?['ChickenLegPiece'];
      String areaPriceChickenLegPieceData =
          ChickenLegPieceData?['Area Price']?.toString() ?? "0";
      String ourPriceChickenLegPieceData =
          ChickenLegPieceData?['Our Price']?.toString() ?? "0";

      //todo:- mutton
      Map<String, dynamic>? MuttonBonelessData =
          data[getareaName]?['MuttonBoneless'];
      String areaPriceMuttonBonelessData =
          MuttonBonelessData?['Area Price']?.toString() ?? "0";
      String ourPriceMuttonBonelessData =
          MuttonBonelessData?['Our Price']?.toString() ?? "0";

      Map<String, dynamic>? MuttonLiverData = data[getareaName]?['MuttonLiver'];
      String areaPriceMuttonLiverData =
          MuttonLiverData?['Area Price']?.toString() ?? "0";
      String ourPriceMuttonLiverData =
          MuttonLiverData?['Our Price']?.toString() ?? "0";

      // String getareaPriceChicknWithSkin = (doc.data() as Map<String, dynamic>?)
      //     ?.containsKey('areaPriceChicknWithSkin') ??
      //     false
      //     ? doc['areaPriceChicknWithSkin']
      //     : "";
      // String getareaPriceChicknWithoutSkin = (doc.data() as Map<String, dynamic>?)
      //     ?.containsKey('areaPriceChicknWithoutSkin') ??
      //     false
      //     ? doc['areaPriceChicknWithoutSkin']
      //     : "";
      //
      // String getareaPriceMutton = (doc.data() as Map<String, dynamic>?)
      //     ?.containsKey('areaPriceMutton') ??
      //     false
      //     ? doc['areaPriceMutton']
      //     : "";
      //
      // //--
      //
      // String getourPriceChicknWithSkin = (doc.data() as Map<String, dynamic>?)
      //     ?.containsKey('ourPriceChicknWithSkin') ??
      //     false
      //     ? doc['ourPriceChicknWithSkin']
      //     : "";
      // String getourPriceChicknWithoutSkin = (doc.data() as Map<String, dynamic>?)
      //     ?.containsKey('ourPriceChicknWithoutSkin') ??
      //     false
      //     ? doc['ourPriceChicknWithoutSkin']
      //     : "";
      //
      // String getourPriceMutton = (doc.data() as Map<String, dynamic>?)
      //     ?.containsKey('ourPriceMutton') ??
      //     false
      //     ? doc['ourPriceMutton']
      //     : "";

      MeatBasketAreaList getAreaList = MeatBasketAreaList(
        areaName: getareaName,
        areaPriceChicknWithSkin: areaPriceChickenWithSkin,
        areaPriceChicknWithoutSkin: areaPriceChickenWithoutSkin,
        areaPriceMutton: areaPriceMutton,
        ourPriceChicknWithSkin: ourPriceChickenWithSkin,
        ourPriceChicknWithoutSkin: ourPriceChickenWithoutSkin,
        ourPriceMutton: ourPriceMutton,
        docId: doc.id,
        areaPriceChickenBoneless: areaPriceChickenBonelessData,
        areaPriceChickenChestPiece: areaPriceChickenChestPieceData,
        areaPriceChickenLegPiece: areaPriceChickenLegPieceData,
        areaPriceMuttonBoneless: areaPriceMuttonBonelessData,
        areaPriceMuttonLiver: areaPriceMuttonLiverData,
        ourPriceChickenBoneless: ourPriceChickenBonelessData,
        ourPriceChickenChestPiece: ourPriceChickenChestPieceData,
        ourPriceChickenLegPiece: ourPriceChickenLegPieceData,
        ourPriceMuttonBoneless: ourPriceMuttonBonelessData,
        ourPriceMuttonLiver: ourPriceMuttonLiverData,
      );
      getProducts.add(getAreaList);
    });

    return getProducts;
  }

  // Future<bool?> updateData(String? getDocId, bool? isSavingAmntReqPaid) async {
  //   String? documentId = getDocId;
  //
  //   if (isSavingAmntReqPaid!) {
  //     try {
  //       await firestore.collection('users').doc(documentId).update({
  //         'isMoneyRequest': false,
  //       }).then((value) {
  //         Constants.showToast(
  //             "Money Request Status Updated", ToastGravity.CENTER);
  //         getDashboardDetails();
  //         return true;
  //       });
  //       return null; // Return null or a success message if desired
  //     } catch (error) {
  //       Constants.showToast("Request Failed, Try again!", ToastGravity.CENTER);
  //       return false; // Return the error message as a string
  //     }
  //   } else {
  //     try {
  //       await firestore.collection('users').doc(documentId).update({
  //         'isCashbackRequest': false,
  //       }).then((value) {
  //         Constants.showToast(
  //             "Money Request Status Updated", ToastGravity.CENTER);
  //         getDashboardDetails();
  //         return true;
  //       });
  //       return null; // Return null or a success message if desired
  //     } catch (error) {
  //       Constants.showToast("Request Failed, Try again!", ToastGravity.CENTER);
  //       return false; // Return the error message as a string
  //     }
  //   }
  // }

  AreaState getLoadingState() {
    return AreaState(status: ResStatus.loading, success: null, failure: "");
  }

  AreaState getSuccessState(userList) {
    return AreaState(status: ResStatus.success, success: userList, failure: "");
  }

  AreaState getFailureState(err) {
    return AreaState(status: ResStatus.failure, success: [], failure: err);
  }
}

//todo:- list to handle meat basket areas
class MeatBasketAreaList {
  String? areaName;
  String? areaPriceChicknWithSkin;
  String? areaPriceChicknWithoutSkin;
  String? areaPriceMutton;

  // Chicken
  // Mutton
  // ChickenBoneless
  // ChickenChestPiece
  // ChickenLegPiece
  // MuttonBoneless
  // MuttonLiver

  //todo:- 29.3.25 changes
  //--
  String? areaPriceChickenBoneless;
  String? areaPriceChickenChestPiece;
  String? areaPriceChickenLegPiece;

  String? areaPriceMuttonBoneless;
  String? areaPriceMuttonLiver;

//--

  String? ourPriceChicknWithSkin;
  String? ourPriceChicknWithoutSkin;
  String? ourPriceMutton;

  String? docId;

  //todo:- 29.3.25 changes
  //--
  String? ourPriceChickenBoneless;
  String? ourPriceChickenChestPiece;
  String? ourPriceChickenLegPiece;

  String? ourPriceMuttonBoneless;
  String? ourPriceMuttonLiver;

  MeatBasketAreaList(
      {required this.areaName,
      required this.areaPriceChicknWithSkin,
      required this.areaPriceChicknWithoutSkin,
      required this.areaPriceMutton,
      required this.ourPriceChicknWithSkin,
      required this.ourPriceChicknWithoutSkin,
      required this.ourPriceMutton,
      required this.docId,
      required this.areaPriceChickenBoneless,
      required this.areaPriceChickenChestPiece,
      required this.areaPriceChickenLegPiece,
      required this.areaPriceMuttonBoneless,
      required this.areaPriceMuttonLiver,
      required this.ourPriceChickenBoneless,
      required this.ourPriceChickenChestPiece,
      required this.ourPriceChickenLegPiece,
      required this.ourPriceMuttonBoneless,
      required this.ourPriceMuttonLiver});
}

class AreaState {
  ResStatus? status;
  List<MeatBasketAreaList>? success;
  String? failure;

  AreaState({this.status, this.success, this.failure});
}
