import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

enum SelectionType {
  adminType,
  goalPriorityType,
  postProductCategoryType,
  postFoodCategoryType,
  shoppingPlatformType,
  areaPrize,
  areaList,
  orderStatus,
  paymentStatus,
}

final ListProvider =
    StateNotifierProvider<ListNotifier, dynamic>((ref) => ListNotifier(ref));

class ListNotifier extends StateNotifier<dynamic> {
  Ref ref;

  List<Tuple2<String?, String?>?>? getData;
  SelectionType? getSelectionType;
  TextEditingController? txtGoalPriority = TextEditingController();
  TextEditingController? txtMappedArea = TextEditingController();
  TextEditingController? txtSavingsReport = TextEditingController();
  TextEditingController? txtPaymentStatus = TextEditingController();
  TextEditingController? txtOrderStatus = TextEditingController();
  FocusNode focusGoalPriority = FocusNode();
  FocusNode focusSavingsReport = FocusNode();
  FocusNode focusMappedArea = FocusNode();

  FocusNode focusPaymentStatus = FocusNode();
  FocusNode focusOrderStatus = FocusNode();

  ListNotifier(this.ref) : super("");
}

var adminTypeProvider =
    StateProvider<Tuple2<String?, String?>>((ref) => Tuple2("", ""));
var productCategoryTypeProvider =
    StateProvider<Tuple2<String?, String?>>((ref) => Tuple2("", ""));
// var goalTypeProvider =
// StateProvider<Tuple2<String, String>>((ref) => Tuple2("", ""));
