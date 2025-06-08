import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:maaakanmoney/components/custom_dialog_box.dart';
import 'package:maaakanmoney/pages/budget_copy/budget_copy_widget.dart';
import 'package:maaakanmoney/phoneController.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AddNewArea extends ConsumerStatefulWidget {
  AddNewArea({
    Key? key,
    @required this.getDocId,
    @required this.getArea,
    @required this.getAreaChickeWithSkinPrice,
    @required this.getAreaChickeWithOutSkinPrice,
    @required this.getAreaMuttonPrice,
    @required this.isUpdatingExistingDetails,
    @required this.getOurChickeWithSkinPrice,
    @required this.getOurChickeWithoutSkinPrice,
    @required this.getOurMuttonPrice,
    @required this.getUserIndex,
    @required this.getAreaChickenBonelessPrice,
    @required this.getAreaChickenChestPiecePrice,
    @required this.getAreaChickenLegPiecePrice,

    //our price
    @required this.getOurChickenBonelessPrice,
    @required this.getOurChickenChestPiecePrice,
    @required this.getOurChickenLegPiecePrice,

    // mutton
    //area
    @required this.getAreaMuttonBonelessPrice,
    @required this.getAreaMuttonLiverPrice,

    //our price
    @required this.getOurMuttonBonelessPrice,
    @required this.getOurMuttonLiverPrice,
  }) : super(key: key);

  String? getDocId;
  String? getArea;
  String? getAreaChickeWithSkinPrice;
  String? getAreaChickeWithOutSkinPrice;
  String? getAreaMuttonPrice;
  bool? isUpdatingExistingDetails;
  String? getOurChickeWithSkinPrice;
  String? getOurChickeWithoutSkinPrice;
  String? getOurMuttonPrice;
  int? getUserIndex;

  //todo:- 29.3.25
  // chicken
  //area
  String? getAreaChickenBonelessPrice;
  String? getAreaChickenChestPiecePrice;
  String? getAreaChickenLegPiecePrice;

  //our price
  String? getOurChickenBonelessPrice;
  String? getOurChickenChestPiecePrice;
  String? getOurChickenLegPiecePrice;

  // mutton
  //area
  String? getAreaMuttonBonelessPrice;
  String? getAreaMuttonLiverPrice;

  //our price
  String? getOurMuttonBonelessPrice;
  String? getOurMuttonLiverPrice;

  @override
  _AddNewAreaState createState() => _AddNewAreaState();
}

class _AddNewAreaState extends ConsumerState<AddNewArea> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _userName;
  String? _phoneNumber;

  final ValueNotifier<int> _selectedPriceCategory = ValueNotifier<int>(0);
  final Map<String, String> _categoryPriceMapping = {
    '0': 'Set Area Price',
    '1': 'Set Your Price',
  };

  TextEditingController? txtAreaName;
  TextEditingController? txtAreaPriceForChickenWithSkin;
  TextEditingController? txtOurPriceForChickenWithSkin;

  TextEditingController? txtAreaPriceForChickenWithoutSkin;
  TextEditingController? txtOurPriceForChickenWithoutSkin;

  TextEditingController? txtAreaPriceForMutton;
  TextEditingController? txtOurPriceForMutton;

  //todo:- 29.3.25
  // chicken
  //area
  TextEditingController? getAreaChickenBonelessPrice;
  TextEditingController? getAreaChickenChestPiecePrice;
  TextEditingController? getAreaChickenLegPiecePrice;

  //our price
  TextEditingController? getOurChickenBonelessPrice;
  TextEditingController? getOurChickenChestPiecePrice;
  TextEditingController? getOurChickenLegPiecePrice;

  // mutton
  //area
  TextEditingController? getAreaMuttonBonelessPrice;
  TextEditingController? getAreaMuttonLiverPrice;

  //our price
  TextEditingController? getOurMuttonBonelessPrice;
  TextEditingController? getOurMuttonLiverPrice;

  String? Function(BuildContext, String?)? cityController2Validator;
  List<Tuple2<String?, String?>?> adminType = [];
  ConnectivityResult? data;
  Tuple2<String?, String?>? getSelectedAdmin = Tuple2("", "");
  late StreamSubscription<List<ConnectivityResult>> subscription;

  /// Initialization and disposal methods.

  @override
  void initState() {
    txtAreaName ??= TextEditingController();
    txtAreaPriceForChickenWithSkin ??= TextEditingController();
    txtOurPriceForChickenWithSkin ??= TextEditingController();

    txtAreaPriceForChickenWithoutSkin ??= TextEditingController();
    txtOurPriceForChickenWithoutSkin ??= TextEditingController();

    txtAreaPriceForMutton ??= TextEditingController();
    txtOurPriceForMutton ??= TextEditingController();

    //todo:- 29.3.25
    // chicken
    //area
    getAreaChickenBonelessPrice ??= TextEditingController();
    getAreaChickenChestPiecePrice ??= TextEditingController();
    getAreaChickenLegPiecePrice ??= TextEditingController();

    //our price
    getOurChickenBonelessPrice ??= TextEditingController();
    getOurChickenChestPiecePrice ??= TextEditingController();
    getOurChickenLegPiecePrice ??= TextEditingController();

    // mutton
    //area
    getAreaMuttonBonelessPrice ??= TextEditingController();
    getAreaMuttonLiverPrice ??= TextEditingController();

    //our price
    getOurMuttonBonelessPrice ??= TextEditingController();
    getOurMuttonLiverPrice ??= TextEditingController();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // ref.read(ListProvider.notifier).txtGoalPriority?.text = "";

      txtAreaName.text = widget.getArea ?? "";
      txtAreaPriceForChickenWithSkin.text =
          widget.getAreaChickeWithSkinPrice ?? "";
      txtAreaPriceForChickenWithoutSkin.text =
          widget.getAreaChickeWithOutSkinPrice ?? "";
      txtAreaPriceForMutton.text = widget.getAreaMuttonPrice ?? "";

      txtOurPriceForChickenWithSkin.text =
          widget.getOurChickeWithSkinPrice ?? "";
      txtOurPriceForChickenWithoutSkin.text =
          widget.getOurChickeWithoutSkinPrice ?? "";
      txtOurPriceForMutton.text = widget.getOurMuttonPrice ?? "";

      //todo:- 29.3.25
      // chicken
      //area
      getAreaChickenBonelessPrice.text =
          widget.getAreaChickenBonelessPrice ?? "";
      getAreaChickenChestPiecePrice.text =
          widget.getAreaChickenChestPiecePrice ?? "";
      getAreaChickenLegPiecePrice.text =
          widget.getAreaChickenLegPiecePrice ?? "";

      //our price
      getOurChickenBonelessPrice.text = widget.getOurChickenBonelessPrice ?? "";
      getOurChickenChestPiecePrice.text =
          widget.getOurChickenChestPiecePrice ?? "";
      getOurChickenLegPiecePrice.text = widget.getOurChickenLegPiecePrice ?? "";

      // mutton
      //area
      getAreaMuttonBonelessPrice.text = widget.getAreaMuttonBonelessPrice ?? "";
      getAreaMuttonLiverPrice.text = widget.getAreaMuttonLiverPrice ?? "";

      //our price
      getOurMuttonBonelessPrice.text = widget.getOurMuttonBonelessPrice ?? "";
      getOurMuttonLiverPrice.text = widget.getOurMuttonLiverPrice ?? "";
    });
    adminType = [
      Tuple2("Meena", "1"),
      Tuple2("Babu", "2"),
    ];
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      print("aaaaaa$result");

      if (result != null || result.isNotEmpty) {
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                automaticallyImplyLeading: true,
                title: Text(
                  FFLocalizations.of(context).getText(
                      (widget.isUpdatingExistingDetails ?? false) == true
                          ? "Update"
                          : "Add Area"),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).primaryBtnText,
                        fontSize: 18.0,
                      ),
                ),
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
                elevation: 0,
              )
            : null,
        body: SafeArea(
          child: Consumer(builder: (context, ref, child) {
            data = ref.watch(connectivityProvider);

            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        color: Colors.white,
                        height: 10.h,
                        child: Center(
                          child: Container(
                            height: 5.h,
                            child: ValueListenableBuilder<int>(
                              valueListenable: _selectedPriceCategory,
                              builder: (context, selectedIndex, child) {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _categoryPriceMapping.length,
                                  itemBuilder: (context, index) {
                                    String category = _categoryPriceMapping
                                        .values
                                        .toList()[index];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedPriceCategory.value = index;
                                        });

                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: index == selectedIndex
                                              ? Constants.colorFoodCPrimary
                                              : Colors.grey[200],
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          // border: Border.all(
                                          //     color: Colors.grey),
                                          // Light gray background
                                          // Smooth corners
                                          // boxShadow: [
                                          //   BoxShadow(
                                          //     color: Colors.black.withOpacity(
                                          //         0.1), // Light shadow effect
                                          //     blurRadius: 10,
                                          //     spreadRadius: 2,
                                          //     offset: Offset(0,
                                          //         4), // Slight downward shadow
                                          //   ),
                                          // ],
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 40.w,
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              category,
                                              style: TextStyle(
                                                color: index == selectedIndex
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsetsDirectional.fromSTEB(
                            //       20.0, 10.0, 20.0, 16.0),
                            //   child: AbsorbPointer(
                            //     absorbing: true,
                            //     child: TextFormField(
                            //       controller: txtAreaName,
                            //       textCapitalization: TextCapitalization.words,
                            //       obscureText: false,
                            //       decoration: InputDecoration(
                            //         labelText: "Area",
                            //         labelStyle: FlutterFlowTheme.of(context)
                            //             .labelMedium
                            //             .override(
                            //               fontFamily: 'Outfit',
                            //               color: const Color(0xFF57636C),
                            //               fontSize: 14.0,
                            //               fontWeight: FontWeight.normal,
                            //             ),
                            //         hintStyle: FlutterFlowTheme.of(context)
                            //             .labelMedium
                            //             .override(
                            //               fontFamily: 'Outfit',
                            //               color: const Color(0xFF57636C),
                            //               fontSize: 14.0,
                            //               fontWeight: FontWeight.normal,
                            //             ),
                            //         enabledBorder: OutlineInputBorder(
                            //           borderSide: const BorderSide(
                            //             color: Color(0xFFE0E3E7),
                            //             width: 2.0,
                            //           ),
                            //           borderRadius: BorderRadius.circular(8.0),
                            //         ),
                            //         focusedBorder: OutlineInputBorder(
                            //           borderSide: const BorderSide(
                            //             color: Color(0xFF004D40),
                            //             width: 2.0,
                            //           ),
                            //           borderRadius: BorderRadius.circular(8.0),
                            //         ),
                            //         errorBorder: OutlineInputBorder(
                            //           borderSide: const BorderSide(
                            //             color: Color(0xFFFF5963),
                            //             width: 2.0,
                            //           ),
                            //           borderRadius: BorderRadius.circular(8.0),
                            //         ),
                            //         focusedErrorBorder: OutlineInputBorder(
                            //           borderSide: const BorderSide(
                            //             color: Color(0xFFFF5963),
                            //             width: 2.0,
                            //           ),
                            //           borderRadius: BorderRadius.circular(8.0),
                            //         ),
                            //         filled: true,
                            //         fillColor: Colors.white,
                            //         contentPadding:
                            //             const EdgeInsetsDirectional.fromSTEB(
                            //                 20.0, 24.0, 0.0, 24.0),
                            //       ),
                            //       style: FlutterFlowTheme.of(context)
                            //           .bodyMedium
                            //           .override(
                            //             fontFamily: 'Outfit',
                            //             color: const Color(0xFF14181B),
                            //             fontSize: 14.0,
                            //             fontWeight: FontWeight.normal,
                            //           ),
                            //       keyboardType: TextInputType.text,
                            //       // validator:
                            //       //     _model.cityController1Validator.asValidator(context),
                            //
                            //       validator: (value) {
                            //         if (value == null || value.isEmpty) {
                            //           return 'Please enter a area name';
                            //         }
                            //         return null;
                            //       },
                            //       onSaved: (value) => _userName = value,
                            //     ),
                            //   ),
                            // ),
                            //area price

                            Visibility(
                              visible: _selectedPriceCategory.value == 0 ? true : false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 20.0, 16.0),
                                    child: Text(
                                      "Area Price",
                                      style:
                                          FlutterFlowTheme.of(context).bodyLarge.override(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Outfit',
                                                color: FlutterFlowTheme.of(context).primary,
                                                letterSpacing: 0.5,
                                              ),
                                    ),
                                  ),
                    
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 20.0, 16.0),
                                    child: Text(
                                      "Chicken",
                                      style:
                                      FlutterFlowTheme.of(context).bodyLarge.override(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  //area price chicken container
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                            offset: Offset(2, 4),
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                20.0, 10.0, 20.0, 16.0),
                                            child: TextFormField(
                                              controller: txtAreaPriceForChickenWithSkin,
                                              textCapitalization: TextCapitalization.words,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelText:
                                                "Area price for chicken with skin",
                                                labelStyle: FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                  fontFamily: 'Outfit',
                                                  color: const Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                hintStyle: FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                  fontFamily: 'Outfit',
                                                  color: const Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFE0E3E7),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFF004D40),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFFF5963),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                focusedErrorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFFF5963),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 0.0, 24.0),
                                              ),
                                              style: FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                fontFamily: 'Outfit',
                                                color: const Color(0xFF14181B),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              keyboardType: TextInputType.number,
                                              // validator:
                                              //     _model.cityController1Validator.asValidator(context),
                    
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter area price for chicken with skin';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) => _userName = value,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                20.0, 10.0, 20.0, 16.0),
                                            child: TextFormField(
                                              controller: txtAreaPriceForChickenWithoutSkin,
                                              textCapitalization: TextCapitalization.words,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelText:
                                                "Area price for chicken without skin",
                                                labelStyle: FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                  fontFamily: 'Outfit',
                                                  color: const Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                hintStyle: FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                  fontFamily: 'Outfit',
                                                  color: const Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFE0E3E7),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFF004D40),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFFF5963),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                focusedErrorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFFF5963),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 0.0, 24.0),
                                              ),
                                              style: FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                fontFamily: 'Outfit',
                                                color: const Color(0xFF14181B),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              keyboardType: TextInputType.number,
                                              // validator:
                                              //     _model.cityController1Validator.asValidator(context),
                    
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter area price for chicken without skin';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) => _userName = value,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 20.0, 16.0),
                                    child: Text(
                                      "Chicken Boneless",
                                      style:
                                      FlutterFlowTheme.of(context).bodyLarge.override(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  //area price chicken boneless
                    
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                            offset: Offset(2, 4),
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                20.0, 10.0, 20.0, 16.0),
                                            child: TextFormField(
                                              controller: getAreaChickenBonelessPrice,
                                              textCapitalization: TextCapitalization.words,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelText:
                                                "Area price for chicken Boneless",
                                                labelStyle: FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                  fontFamily: 'Outfit',
                                                  color: const Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                hintStyle: FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                  fontFamily: 'Outfit',
                                                  color: const Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFE0E3E7),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFF004D40),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFFF5963),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                focusedErrorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFFF5963),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 0.0, 24.0),
                                              ),
                                              style: FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                fontFamily: 'Outfit',
                                                color: const Color(0xFF14181B),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              keyboardType: TextInputType.number,
                                              // validator:
                                              //     _model.cityController1Validator.asValidator(context),
                    
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter area price for chicken boneless';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) => _userName = value,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                    
                              //area price chicken chest piece
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 20.0, 16.0),
                                    child: Text(
                                      "Chicken Chest Piece",
                                      style:
                                      FlutterFlowTheme.of(context).bodyLarge.override(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                    
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                            offset: Offset(2, 4),
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                20.0, 10.0, 20.0, 16.0),
                                            child: TextFormField(
                                              controller: getAreaChickenChestPiecePrice,
                                              textCapitalization: TextCapitalization.words,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelText:
                                                "Area price for chicken Chest Piece",
                                                labelStyle: FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                  fontFamily: 'Outfit',
                                                  color: const Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                hintStyle: FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                  fontFamily: 'Outfit',
                                                  color: const Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFE0E3E7),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFF004D40),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFFF5963),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                focusedErrorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFFF5963),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 0.0, 24.0),
                                              ),
                                              style: FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                fontFamily: 'Outfit',
                                                color: const Color(0xFF14181B),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              keyboardType: TextInputType.number,
                                              // validator:
                                              //     _model.cityController1Validator.asValidator(context),
                    
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter area price for chicken chest piece';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) => _userName = value,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                    
                                  //area price chicken leg piece
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 20.0, 16.0),
                                    child: Text(
                                      "Chicken Leg Piece",
                                      style:
                                      FlutterFlowTheme.of(context).bodyLarge.override(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                    
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                            offset: Offset(2, 4),
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                20.0, 10.0, 20.0, 16.0),
                                            child: TextFormField(
                                              controller: getAreaChickenLegPiecePrice,
                                              textCapitalization: TextCapitalization.words,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelText:
                                                "Area price for chicken Leg Piece",
                                                labelStyle: FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                  fontFamily: 'Outfit',
                                                  color: const Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                hintStyle: FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                  fontFamily: 'Outfit',
                                                  color: const Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFE0E3E7),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFF004D40),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFFF5963),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                focusedErrorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFFF5963),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 0.0, 24.0),
                                              ),
                                              style: FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                fontFamily: 'Outfit',
                                                color: const Color(0xFF14181B),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              keyboardType: TextInputType.number,
                                              // validator:
                                              //     _model.cityController1Validator.asValidator(context),
                    
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter area price for chicken Leg piece';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) => _userName = value,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                    
                    
                    
                                  //mutton
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 20.0, 16.0),
                                    child: Text(
                                      "Mutton",
                                      style:
                                      FlutterFlowTheme.of(context).bodyLarge.override(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                            offset: Offset(2, 4),
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 10.0, 20.0, 16.0),
                                        child: TextFormField(
                                          controller: txtAreaPriceForMutton,
                                          textCapitalization: TextCapitalization.words,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: "Area price for Mutton",
                                            labelStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: const Color(0xFF57636C),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            hintStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: const Color(0xFF57636C),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFE0E3E7),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF004D40),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                20.0, 24.0, 0.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: 'Outfit',
                                            color: const Color(0xFF14181B),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          keyboardType: TextInputType.number,
                                          // validator:
                                          //     _model.cityController1Validator.asValidator(context),
                    
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter Area price for Mutton';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) => _userName = value,
                                        ),
                                      ),
                                    ),
                                  ),
                    
                                  //area price mutton liver
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 20.0, 16.0),
                                    child: Text(
                                      "Mutton Liver",
                                      style:
                                      FlutterFlowTheme.of(context).bodyLarge.override(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                            offset: Offset(2, 4),
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 10.0, 20.0, 16.0),
                                        child: TextFormField(
                                          controller: getAreaMuttonLiverPrice,
                                          textCapitalization: TextCapitalization.words,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: "Area price for Mutton Liver",
                                            labelStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: const Color(0xFF57636C),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            hintStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: const Color(0xFF57636C),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFE0E3E7),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF004D40),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                20.0, 24.0, 0.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: 'Outfit',
                                            color: const Color(0xFF14181B),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          keyboardType: TextInputType.number,
                                          // validator:
                                          //     _model.cityController1Validator.asValidator(context),
                    
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter Area price for Mutton Liver';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) => _userName = value,
                                        ),
                                      ),
                                    ),
                                  ),
                    
                                  //area price mutton Boneless
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 20.0, 16.0),
                                    child: Text(
                                      "Mutton Boneless",
                                      style:
                                      FlutterFlowTheme.of(context).bodyLarge.override(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                            offset: Offset(2, 4),
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 10.0, 20.0, 16.0),
                                        child: TextFormField(
                                          controller: getAreaMuttonBonelessPrice,
                                          textCapitalization: TextCapitalization.words,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: "Area price for Mutton Boneless",
                                            labelStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: const Color(0xFF57636C),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            hintStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: const Color(0xFF57636C),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFE0E3E7),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF004D40),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                20.0, 24.0, 0.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: 'Outfit',
                                            color: const Color(0xFF14181B),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          keyboardType: TextInputType.number,
                                          // validator:
                                          //     _model.cityController1Validator.asValidator(context),
                    
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter Area price for Mutton Boneless';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) => _userName = value,
                                        ),
                                      ),
                                    ),
                                  ),
                    
                                  SizedBox(width: 50, child: Divider()),
                                ],
                              ),
                            ),
                    
                    
                            // our price
                            Visibility(
                              visible: _selectedPriceCategory.value == 0 ? false : true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 20.0, 16.0),
                                    child: Text(
                                      "Our Price",
                                      style:
                                          FlutterFlowTheme.of(context).bodyLarge.override(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Outfit',
                                                color: FlutterFlowTheme.of(context).primary,
                                                letterSpacing: 0.5,
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 20.0, 16.0),
                                    child: Text(
                                      "Chicken",
                                      style:
                                      FlutterFlowTheme.of(context).bodyLarge.override(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                            offset: Offset(2, 4),
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                20.0, 10.0, 20.0, 16.0),
                                            child: TextFormField(
                                              controller: txtOurPriceForChickenWithSkin,
                                              textCapitalization: TextCapitalization.words,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelText:
                                                "Our Price for chicken with skin",
                                                labelStyle: FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                  fontFamily: 'Outfit',
                                                  color: const Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                hintStyle: FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                  fontFamily: 'Outfit',
                                                  color: const Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFE0E3E7),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFF004D40),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFFF5963),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                focusedErrorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFFF5963),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 0.0, 24.0),
                                              ),
                                              style: FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                fontFamily: 'Outfit',
                                                color: const Color(0xFF14181B),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              keyboardType: TextInputType.number,
                                              // validator:
                                              //     _model.cityController1Validator.asValidator(context),
                    
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter our price for chicken with skin';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) => _userName = value,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                20.0, 10.0, 20.0, 16.0),
                                            child: TextFormField(
                                              controller: txtOurPriceForChickenWithoutSkin,
                                              textCapitalization: TextCapitalization.words,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelText:
                                                "Our Price for chicken without skin",
                                                labelStyle: FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                  fontFamily: 'Outfit',
                                                  color: const Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                hintStyle: FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                  fontFamily: 'Outfit',
                                                  color: const Color(0xFF57636C),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFE0E3E7),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFF004D40),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFFF5963),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                focusedErrorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFFF5963),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 0.0, 24.0),
                                              ),
                                              style: FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                fontFamily: 'Outfit',
                                                color: const Color(0xFF14181B),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              keyboardType: TextInputType.number,
                                              // validator:
                                              //     _model.cityController1Validator.asValidator(context),
                    
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter our price for chicken without skin';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) => _userName = value,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                    
                                  //---
                    
                                  //our price chicken Boneless
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 20.0, 16.0),
                                    child: Text(
                                      "Chicken Boneless",
                                      style:
                                      FlutterFlowTheme.of(context).bodyLarge.override(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                            offset: Offset(2, 4),
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 10.0, 20.0, 16.0),
                                        child: TextFormField(
                                          controller: getOurChickenBonelessPrice,
                                          textCapitalization: TextCapitalization.words,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: "Our price for Chicken Boneless",
                                            labelStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: const Color(0xFF57636C),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            hintStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: const Color(0xFF57636C),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFE0E3E7),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF004D40),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                20.0, 24.0, 0.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: 'Outfit',
                                            color: const Color(0xFF14181B),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          keyboardType: TextInputType.number,
                                          // validator:
                                          //     _model.cityController1Validator.asValidator(context),
                    
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter Our price for Chicken Boneless';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) => _userName = value,
                                        ),
                                      ),
                                    ),
                                  ),
                    
                              //our price chicken Chest piece
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 20.0, 16.0),
                                    child: Text(
                                      "Chicken Chest Piece",
                                      style:
                                      FlutterFlowTheme.of(context).bodyLarge.override(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                            offset: Offset(2, 4),
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 10.0, 20.0, 16.0),
                                        child: TextFormField(
                                          controller: getOurChickenChestPiecePrice,
                                          textCapitalization: TextCapitalization.words,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: "Our price for Chicken Chest Piece",
                                            labelStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: const Color(0xFF57636C),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            hintStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: const Color(0xFF57636C),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFE0E3E7),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF004D40),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                20.0, 24.0, 0.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: 'Outfit',
                                            color: const Color(0xFF14181B),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          keyboardType: TextInputType.number,
                                          // validator:
                                          //     _model.cityController1Validator.asValidator(context),
                    
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter Our price for Chicken Chest Piece';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) => _userName = value,
                                        ),
                                      ),
                                    ),
                                  ),
                    
                              //our price chicken Leg piece
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 20.0, 16.0),
                                    child: Text(
                                      "Chicken Leg Piece",
                                      style:
                                      FlutterFlowTheme.of(context).bodyLarge.override(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                            offset: Offset(2, 4),
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 10.0, 20.0, 16.0),
                                        child: TextFormField(
                                          controller: getOurChickenLegPiecePrice,
                                          textCapitalization: TextCapitalization.words,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: "Our price for Chicken Leg Piece",
                                            labelStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: const Color(0xFF57636C),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            hintStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: const Color(0xFF57636C),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFE0E3E7),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF004D40),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                20.0, 24.0, 0.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: 'Outfit',
                                            color: const Color(0xFF14181B),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          keyboardType: TextInputType.number,
                                          // validator:
                                          //     _model.cityController1Validator.asValidator(context),
                    
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter Our price for Chicken Leg Piece';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) => _userName = value,
                                        ),
                                      ),
                                    ),
                                  ),
                    
                              //--
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 20.0, 16.0),
                                    child: Text(
                                      "Mutton",
                                      style:
                                      FlutterFlowTheme.of(context).bodyLarge.override(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                            offset: Offset(2, 4),
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 10.0, 20.0, 16.0),
                                        child: TextFormField(
                                          controller: txtOurPriceForMutton,
                                          textCapitalization: TextCapitalization.words,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: "Our price for Mutton",
                                            labelStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: const Color(0xFF57636C),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            hintStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: const Color(0xFF57636C),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFE0E3E7),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF004D40),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                20.0, 24.0, 0.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: 'Outfit',
                                            color: const Color(0xFF14181B),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          keyboardType: TextInputType.number,
                                          // validator:
                                          //     _model.cityController1Validator.asValidator(context),
                    
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter Our price for Mutton';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) => _userName = value,
                                        ),
                                      ),
                                    ),
                                  ),
                    
                                  //our price mutton Liver
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 20.0, 16.0),
                                    child: Text(
                                      "Mutton Liver",
                                      style:
                                      FlutterFlowTheme.of(context).bodyLarge.override(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                            offset: Offset(2, 4),
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 10.0, 20.0, 16.0),
                                        child: TextFormField(
                                          controller: getOurMuttonLiverPrice,
                                          textCapitalization: TextCapitalization.words,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: "Our price for Mutton Liver",
                                            labelStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: const Color(0xFF57636C),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            hintStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: const Color(0xFF57636C),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFE0E3E7),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF004D40),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                20.0, 24.0, 0.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: 'Outfit',
                                            color: const Color(0xFF14181B),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          keyboardType: TextInputType.number,
                                          // validator:
                                          //     _model.cityController1Validator.asValidator(context),
                    
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter Our price for Mutton Liver';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) => _userName = value,
                                        ),
                                      ),
                                    ),
                                  ),
                    
                                  //our price mutton Boneless
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 20.0, 16.0),
                                    child: Text(
                                      "Mutton Boneless",
                                      style:
                                      FlutterFlowTheme.of(context).bodyLarge.override(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                            offset: Offset(2, 4),
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 10.0, 20.0, 16.0),
                                        child: TextFormField(
                                          controller: getOurMuttonBonelessPrice,
                                          textCapitalization: TextCapitalization.words,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: "Our price for Mutton Boneless",
                                            labelStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: const Color(0xFF57636C),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            hintStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: const Color(0xFF57636C),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFE0E3E7),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF004D40),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                20.0, 24.0, 0.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: 'Outfit',
                                            color: const Color(0xFF14181B),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          keyboardType: TextInputType.number,
                                          // validator:
                                          //     _model.cityController1Validator.asValidator(context),
                    
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter Our price for Mutton Boneless';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) => _userName = value,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    
                    
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: const AlignmentDirectional(0.0, 0.05),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 24.0, 0.0, 0.0),
                        child: FFButtonWidget(
                          onPressed: _submitForm,
                          text: (widget.isUpdatingExistingDetails ?? false) ==
                              true
                              ? "Update Price"
                              : "Add Area",
                          options: FFButtonOptions(
                            width: 270.0,
                            height: 50.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                              fontFamily: 'Outfit',
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                            ),
                            elevation: 2.0,
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  //todo:-2.6.23 / creating new user to firestore
  void AddNewArea({
    @required String? getAreaName,
    @required String? getAreaPriceChickenWithSkin,
    @required String? getAreaPriceChickenWithoutSkin,
    @required String? getAreaPriceMutton,
    @required String? getOurPriceChickenWithSkin,
    @required String? getOurPriceChickenWithoutSkin,
    @required String? getOurPriceMutton,

    //chicken
    @required String? getAreaChickenBonelessPrice,
    @required String? getAreaChickenChestPiecePrice,
    @required String? getAreaChickenLegPiecePrice,

    //our price
    @required String? getOurChickenBonelessPrice,
    @required String? getOurChickenChestPiecePrice,
    @required String? getOurChickenLegPiecePrice,

    // mutton
    //area
    @required String? getAreaMuttonBonelessPrice,
    @required String? getAreaMuttonLiverPrice,

    //our price
    @required String? getOurMuttonBonelessPrice,
    @required String? getOurMuttonLiverPrice,
  }) {
    // String documentId = fireStore.collection('AreaMeatPrices').doc(getAreaName ?? "").id;
    //
    // fireStore.collection('AreaMeatPrices').doc(getAreaName ?? "").set({
    //   'areaPriceChicknWithSkin': getAreaPriceChickenWithSkin ?? "",
    //   'areaPriceChicknWithoutSkin': getAreaPriceChickenWithoutSkin ?? "",
    //   'areaPriceMutton': getAreaPriceMutton ?? "",
    //   'ourPriceChicknWithSkin': getOurPriceChickenWithSkin ?? "",
    //   'ourPriceChicknWithoutSkin': getOurPriceChickenWithoutSkin ?? "",
    //   'ourPriceMutton': getOurPriceMutton ?? "",
    // }).then((value) {
    //   setState(() {
    //     txtAreaName.text = "";
    //     txtAreaPriceForChickenWithSkin.text = "";
    //     txtAreaPriceForChickenWithoutSkin.text = "";
    //     txtAreaPriceForMutton.text = "";
    //
    //     txtOurPriceForChickenWithSkin.text = "";
    //     txtOurPriceForChickenWithoutSkin.text = "";
    //     txtOurPriceForMutton.text = "";
    //   });
    //   Constants.showToast("Area Added Successfully", ToastGravity.BOTTOM);
    // }).catchError((error) {
    //   print("Failed to save area prices: $error");
    // });

    String documentId =
        fireStore.collection('AreaMeatPrices').doc(getAreaName ?? "").id;

    fireStore.collection('AreaMeatPrices').doc(getAreaName ?? "").set({
      getAreaName ?? "": {
        'Chicken': {
          'AreaPrice': {
            'WithSkin': getAreaPriceChickenWithSkin ?? 0,
            'WithoutSkin': getAreaPriceChickenWithoutSkin ?? 0,
          },
          'OurPrice': {
            'WithSkin': getOurPriceChickenWithSkin ?? 0,
            'WithoutSkin': getOurPriceChickenWithoutSkin ?? 0,
          },
        },
        'Mutton': {
          'AreaPrice': getAreaPriceMutton ?? 0,
          'OurPrice': getOurPriceMutton ?? 0,
        },
        'ChickenBoneless': {
          'Area Price': getAreaChickenBonelessPrice,
          'Our Price': getOurChickenBonelessPrice,
        },
        'ChickenChestPiece': {
          'Area Price': getAreaChickenChestPiecePrice,
          'Our Price': getOurChickenChestPiecePrice,
        },
        'ChickenLegPiece': {
          'Area Price': getAreaChickenLegPiecePrice,
          'Our Price': getOurChickenLegPiecePrice,
        },
        'MuttonBoneless': {
          'Area Price': getAreaMuttonBonelessPrice,
          'Our Price': getOurMuttonBonelessPrice,
        },
        'MuttonLiver': {
          'Area Price': getAreaMuttonLiverPrice,
          'Our Price': getOurMuttonLiverPrice,
        },
      }
    }).then((value) {
      setState(() {
        txtAreaName.text = "";
        txtAreaPriceForChickenWithSkin.text = "";
        txtAreaPriceForChickenWithoutSkin.text = "";
        txtAreaPriceForMutton.text = "";

        txtOurPriceForChickenWithSkin.text = "";
        txtOurPriceForChickenWithoutSkin.text = "";
        txtOurPriceForMutton.text = "";
      });
      Constants.showToast("Area Added Successfully", ToastGravity.BOTTOM);
    }).catchError((error) {
      print("Failed to save area prices: $error");
    });
  }

  void UpdateAreaDetails({
    @required String? docId, // New parameter for document ID
    @required String? getAreaName,
    @required String? getAreaPriceChickenWithSkin,
    @required String? getAreaPriceChickenWithoutSkin,
    @required String? getAreaPriceMutton,
    @required String? getOurPriceChickenWithSkin,
    @required String? getOurPriceChickenWithoutSkin,
    @required String? getOurPriceMutton,

    //chicken
    @required String? getAreaChickenBonelessPrice,
    @required String? getAreaChickenChestPiecePrice,
    @required String? getAreaChickenLegPiecePrice,

    //our price
    @required String? getOurChickenBonelessPrice,
    @required String? getOurChickenChestPiecePrice,
    @required String? getOurChickenLegPiecePrice,

    // mutton
    //area
    @required String? getAreaMuttonBonelessPrice,
    @required String? getAreaMuttonLiverPrice,

    //our price
    @required String? getOurMuttonBonelessPrice,
    @required String? getOurMuttonLiverPrice,
  }) {
    if (docId == null || docId.isEmpty) {
      print("Error: Document ID cannot be null or empty.");
      return;
    }

    fireStore.collection('AreaMeatPrices').doc(docId).update({
      getAreaName ?? "": {
        'Chicken': {
          'AreaPrice': {
            'WithSkin': getAreaPriceChickenWithSkin ?? 0,
            'WithoutSkin': getAreaPriceChickenWithoutSkin ?? 0,
          },
          'OurPrice': {
            'WithSkin': getOurPriceChickenWithSkin ?? 0,
            'WithoutSkin': getOurPriceChickenWithoutSkin ?? 0,
          },
        },
        'Mutton': {
          'AreaPrice': getAreaPriceMutton ?? 0,
          'OurPrice': getOurPriceMutton ?? 0,
        },
        'ChickenBoneless': {
          'Area Price': getAreaChickenBonelessPrice,
          'Our Price': getOurChickenBonelessPrice,
        },
        'ChickenChestPiece': {
          'Area Price': getAreaChickenChestPiecePrice,
          'Our Price': getOurChickenChestPiecePrice,
        },
        'ChickenLegPiece': {
          'Area Price': getAreaChickenLegPiecePrice,
          'Our Price': getOurChickenLegPiecePrice,
        },
        'MuttonBoneless': {
          'Area Price': getAreaMuttonBonelessPrice,
          'Our Price': getOurMuttonBonelessPrice,
        },
        'MuttonLiver': {
          'Area Price': getAreaMuttonLiverPrice,
          'Our Price': getOurMuttonLiverPrice,
        },
      }
    }).then((value) {
      setState(() {
        txtAreaName.text = "";
        txtAreaPriceForChickenWithSkin.text = "";
        txtAreaPriceForChickenWithoutSkin.text = "";
        txtAreaPriceForMutton.text = "";

        txtOurPriceForChickenWithSkin.text = "";
        txtOurPriceForChickenWithoutSkin.text = "";
        txtOurPriceForMutton.text = "";
      });
      Constants.showToast(
          "Area Details Updated Successfully", ToastGravity.BOTTOM);
      Navigator.pop(context);
    }).catchError((error) {
      print("Failed to update area prices: $error");
    });
  }

  int? generateRandomCode() {
    final random = Random();
    int? code = random.nextInt(900000) +
        100000; // Generates a random number between 100000 and 999999
    return code;
  }

  Future<bool> isNewUser(String phoneNumber) async {
    QuerySnapshot querySnapshot = await fireStore
        .collection('users')
        .where('mobile', isEqualTo: phoneNumber)
        .get();

    return querySnapshot.docs.isEmpty;
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      if (data == ConnectivityResult.none) {
        Constants.showToast("No Internet Connection", ToastGravity.BOTTOM);
        return;
      }

      if (widget.isUpdatingExistingDetails == true) {
        UpdateAreaDetails(
          docId: widget.getDocId ?? "",
          getAreaName: txtAreaName.text,
          getAreaPriceChickenWithSkin: txtAreaPriceForChickenWithSkin.text,
          getAreaPriceChickenWithoutSkin:
              txtAreaPriceForChickenWithoutSkin.text,
          getAreaPriceMutton: txtAreaPriceForMutton.text,
          getOurPriceChickenWithSkin: txtOurPriceForChickenWithSkin.text,
          getOurPriceChickenWithoutSkin: txtOurPriceForChickenWithoutSkin.text,
          getOurPriceMutton: txtOurPriceForMutton.text,

          //chicken
          getAreaChickenBonelessPrice: getAreaChickenBonelessPrice.text,
          getAreaChickenChestPiecePrice: getAreaChickenChestPiecePrice.text,
          getAreaChickenLegPiecePrice: getAreaChickenLegPiecePrice.text,

          //our price
          getOurChickenBonelessPrice: getOurChickenBonelessPrice.text,
          getOurChickenChestPiecePrice: getOurChickenChestPiecePrice.text,
          getOurChickenLegPiecePrice: getOurChickenLegPiecePrice.text,
          // mutton
          //area
          getAreaMuttonBonelessPrice: getAreaMuttonBonelessPrice.text,
          getAreaMuttonLiverPrice: getAreaMuttonLiverPrice.text,

          //our price
          getOurMuttonBonelessPrice: getOurMuttonBonelessPrice.text,
          getOurMuttonLiverPrice: getOurMuttonLiverPrice.text,
        );
      } else {
        AddNewArea(
          getAreaName: txtAreaName.text,
          getAreaPriceChickenWithSkin: txtAreaPriceForChickenWithSkin.text,
          getAreaPriceChickenWithoutSkin:
              txtAreaPriceForChickenWithoutSkin.text,
          getAreaPriceMutton: txtAreaPriceForMutton.text,
          getOurPriceChickenWithSkin: txtOurPriceForChickenWithSkin.text,
          getOurPriceChickenWithoutSkin: txtOurPriceForChickenWithoutSkin.text,
          getOurPriceMutton: txtOurPriceForMutton.text,

          //chicken
          getAreaChickenBonelessPrice: getAreaChickenBonelessPrice.text,
          getAreaChickenChestPiecePrice: getAreaChickenChestPiecePrice.text,
          getAreaChickenLegPiecePrice: getAreaChickenLegPiecePrice.text,

          //our price
          getOurChickenBonelessPrice: getOurChickenBonelessPrice.text,
          getOurChickenChestPiecePrice: getOurChickenChestPiecePrice.text,
          getOurChickenLegPiecePrice: getOurChickenLegPiecePrice.text,
          // mutton
          //area
          getAreaMuttonBonelessPrice: getAreaMuttonBonelessPrice.text,
          getAreaMuttonLiverPrice: getAreaMuttonLiverPrice.text,

          //our price
          getOurMuttonBonelessPrice: getOurMuttonBonelessPrice.text,
          getOurMuttonLiverPrice: getOurMuttonLiverPrice.text,
        );
      }
    }
  }
}
