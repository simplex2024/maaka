import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:maaakanmoney/pages/budget_copy/BudgetCopyController.dart';
import 'package:maaakanmoney/pages/budget_copy/navigation_drawer/meat_basket_areas/add_new_area.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

import '../../../../components/ListView/ListController.dart';
import '../../../../components/ListView/ListPageView.dart';
import '../../../../components/NotificationService.dart';
import '../../../../components/constants.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_util.dart';
import '../../budget_copy_widget.dart';
import 'add_new_areaController.dart';

class AreaList extends ConsumerStatefulWidget {
  final String? getUserType;
  final String? getAdminMobileNo;

  AreaList(
      {Key? key, required this.getUserType, required this.getAdminMobileNo})
      : super(key: key);

  @override
  AreaListState createState() => AreaListState();
}

class AreaListState extends ConsumerState<AreaList> {
  final _formKey = GlobalKey<FormState>();

  CollectionReference? _collectionRefToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _collectionRefToken =
        FirebaseFirestore.instance.collection('AreaMeatPrices');

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(isRefreshIndicator.notifier).state = false;
      ref.read(areaListProvider.notifier).getMeatBasketAreaDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _AreaListScreen(
      context,
      widget.getUserType ?? "0",
      true,
      true,
    );
  }

  Future<void> _handleRefresh() async {
    // isRefreshIndicator = true;
    ref.read(isRefreshIndicator.notifier).state = true;
    return ref.read(areaListProvider.notifier).getMeatBasketAreaDetails();
  }

  Widget _AreaListScreen(BuildContext context, String getUserType,
      bool? isRefresh, bool? isLoading) {
    if (getUserType == "0") {
      //todo:- super admin

      return Scaffold(
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
                title: Text(
                  "Update Area",
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
                  icon: const Icon(Icons.arrow_back_ios_rounded,
                      color: Colors.white),
                ),
                centerTitle: true,
                elevation: 0.0,
              )
            : null,
        body: Consumer(builder: (context, ref, child) {
          AreaState getAreaList = ref.watch(areaListProvider);
          bool? isRefresh = ref.watch(isRefreshIndicator);
          bool isLoading = false;
          isLoading = (getAreaList.status == ResStatus.loading);
          return Container(
            color: Colors.white,
            height: 100.h,
            child: Stack(
              children: [
                Container(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 8,
                        child: RefreshIndicator(
                          onRefresh: _handleRefresh,
                          child: CustomScrollView(
                            slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    final document = ref
                                        .read(areaListProvider.notifier)
                                        .areaList?[index];

                                    final areaName = document?.areaName;
                                    final areaPriceChicknWithSkin =
                                        document?.areaPriceChicknWithSkin;
                                    final areaPriceChicknWithoutSkin =
                                        document?.areaPriceChicknWithoutSkin;
                                    final areaPriceMutton =
                                        document?.areaPriceMutton;
                                    final ourPriceChicknWithSkin =
                                        document?.ourPriceChicknWithSkin;
                                    final ourPriceChicknWithoutSkin =
                                        document?.ourPriceChicknWithoutSkin;
                                    final ourPriceMutton =
                                        document?.ourPriceMutton;

                                    //--
                                    final areaPriceChickenLegPiece =
                                        document?.areaPriceChickenLegPiece;
                                    final areaPriceChickenChestPiece =
                                        document?.areaPriceChickenChestPiece;
                                    final areaPriceChickenBoneless =
                                        document?.areaPriceChickenBoneless;

                                    //--

                                    final areaPriceMuttonBoneless =
                                        document?.areaPriceMuttonBoneless;
                                    final areaPriceMuttonLiver =
                                        document?.areaPriceMuttonLiver;

                                    //--

//--
                                    final ourPriceChickenLegPiece =
                                        document?.ourPriceChickenLegPiece;
                                    final ourPriceChickenChestPiece =
                                        document?.ourPriceChickenChestPiece;
                                    final ourPriceChickenBoneless =
                                        document?.ourPriceChickenBoneless;

                                    //--

                                    final ourPriceMuttonBoneless =
                                        document?.ourPriceMuttonBoneless;
                                    final ourPriceMuttonLiver =
                                        document?.ourPriceMuttonLiver;

                                    //--

                                    final docId = document?.docId;

                                    return Container(
                                      color: Colors.white.withOpacity(0.95),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          elevation: 4.0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: ListTile(
                                              leading: Card(
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                elevation: 6.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40.0),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          8.0, 8.0, 8.0, 8.0),
                                                  child: Icon(
                                                    Icons.location_on,
                                                    color: Colors.white,
                                                    size: 24.0,
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                areaName
                                                    .toString()
                                                    .toUpperCase(),
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Color(0xFF004D40),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.5),
                                              ),
                                              subtitle: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  //todo:- uncomment incase of not updating properlly
                                                  //-----
                                                  // Text(
                                                  //   "Area Price",
                                                  //   style: FlutterFlowTheme.of(
                                                  //           context)
                                                  //       .bodyLarge
                                                  //       .override(
                                                  //         fontWeight:
                                                  //             FontWeight.w500,
                                                  //         fontFamily: 'Outfit',
                                                  //         color: FlutterFlowTheme
                                                  //                 .of(context)
                                                  //             .primary,
                                                  //         letterSpacing: 0.5,
                                                  //       ),
                                                  // ),
                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment
                                                  //           .spaceBetween,
                                                  //   children: [
                                                  //     Expanded(
                                                  //       flex: 8,
                                                  //       child: Text(
                                                  //           'chickn with skin price',
                                                  //           overflow:
                                                  //               TextOverflow
                                                  //                   .ellipsis,
                                                  //           style: const TextStyle(
                                                  //               color: Color(
                                                  //                   0xFF004D40),
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .normal,
                                                  //               fontSize: 13.0,
                                                  //               letterSpacing:
                                                  //                   0.5)),
                                                  //     ),
                                                  //     Expanded(
                                                  //       flex: 3,
                                                  //       child: Text(
                                                  //           '₹' +
                                                  //               '$areaPriceChicknWithSkin',
                                                  //           overflow:
                                                  //               TextOverflow
                                                  //                   .ellipsis,
                                                  //           style: const TextStyle(
                                                  //               color: Color(
                                                  //                   0xFF004D40),
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .bold,
                                                  //               fontSize: 13.0,
                                                  //               letterSpacing:
                                                  //                   0.5)),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment
                                                  //           .spaceBetween,
                                                  //   children: [
                                                  //     Expanded(
                                                  //       flex: 8,
                                                  //       child: Text(
                                                  //           'chickn without skin price',
                                                  //           overflow:
                                                  //               TextOverflow
                                                  //                   .ellipsis,
                                                  //           style: const TextStyle(
                                                  //               color: Color(
                                                  //                   0xFF004D40),
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .normal,
                                                  //               fontSize: 13.0,
                                                  //               letterSpacing:
                                                  //                   0.5)),
                                                  //     ),
                                                  //     Expanded(
                                                  //       flex: 3,
                                                  //       child: Text(
                                                  //           '₹' +
                                                  //               '$areaPriceChicknWithoutSkin',
                                                  //           overflow:
                                                  //               TextOverflow
                                                  //                   .ellipsis,
                                                  //           style: const TextStyle(
                                                  //               color: Color(
                                                  //                   0xFF004D40),
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .bold,
                                                  //               fontSize: 13.0,
                                                  //               letterSpacing:
                                                  //                   0.5)),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment
                                                  //           .spaceBetween,
                                                  //   children: [
                                                  //     Expanded(
                                                  //       flex: 8,
                                                  //       child: Text(
                                                  //           'mutton price',
                                                  //           overflow:
                                                  //               TextOverflow
                                                  //                   .ellipsis,
                                                  //           style: const TextStyle(
                                                  //               color: Color(
                                                  //                   0xFF004D40),
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .normal,
                                                  //               fontSize: 13.0,
                                                  //               letterSpacing:
                                                  //                   0.5)),
                                                  //     ),
                                                  //     Expanded(
                                                  //       flex: 3,
                                                  //       child: Text(
                                                  //           '₹' +
                                                  //               '$areaPriceMutton',
                                                  //           overflow:
                                                  //               TextOverflow
                                                  //                   .ellipsis,
                                                  //           style: const TextStyle(
                                                  //               color: Color(
                                                  //                   0xFF004D40),
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .bold,
                                                  //               fontSize: 13.0,
                                                  //               letterSpacing:
                                                  //                   0.5)),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  // Divider(),
                                                  // Text(
                                                  //   "Meat Basket Price",
                                                  //   style: FlutterFlowTheme.of(
                                                  //           context)
                                                  //       .bodyLarge
                                                  //       .override(
                                                  //         fontWeight:
                                                  //             FontWeight.w500,
                                                  //         fontFamily: 'Outfit',
                                                  //         color: FlutterFlowTheme
                                                  //                 .of(context)
                                                  //             .primary,
                                                  //         letterSpacing: 0.5,
                                                  //       ),
                                                  // ),
                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment
                                                  //           .spaceBetween,
                                                  //   children: [
                                                  //     Expanded(
                                                  //       flex: 8,
                                                  //       child: Text(
                                                  //           'chickn with skin price',
                                                  //           overflow:
                                                  //               TextOverflow
                                                  //                   .ellipsis,
                                                  //           style: const TextStyle(
                                                  //               color: Color(
                                                  //                   0xFF004D40),
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .normal,
                                                  //               fontSize: 13.0,
                                                  //               letterSpacing:
                                                  //                   0.5)),
                                                  //     ),
                                                  //     Expanded(
                                                  //       flex: 3,
                                                  //       child: Text(
                                                  //           '₹' +
                                                  //               '$ourPriceChicknWithSkin',
                                                  //           overflow:
                                                  //               TextOverflow
                                                  //                   .ellipsis,
                                                  //           style: const TextStyle(
                                                  //               color: Color(
                                                  //                   0xFF004D40),
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .bold,
                                                  //               fontSize: 13.0,
                                                  //               letterSpacing:
                                                  //                   0.5)),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment
                                                  //           .spaceBetween,
                                                  //   children: [
                                                  //     Expanded(
                                                  //       flex: 8,
                                                  //       child: Text(
                                                  //           'chickn without skin price',
                                                  //           overflow:
                                                  //               TextOverflow
                                                  //                   .ellipsis,
                                                  //           style: const TextStyle(
                                                  //               color: Color(
                                                  //                   0xFF004D40),
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .normal,
                                                  //               fontSize: 13.0,
                                                  //               letterSpacing:
                                                  //                   0.5)),
                                                  //     ),
                                                  //     Expanded(
                                                  //       flex: 3,
                                                  //       child: Text(
                                                  //           '₹' +
                                                  //               '$ourPriceChicknWithoutSkin',
                                                  //           overflow:
                                                  //               TextOverflow
                                                  //                   .ellipsis,
                                                  //           style: const TextStyle(
                                                  //               color: Color(
                                                  //                   0xFF004D40),
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .bold,
                                                  //               fontSize: 13.0,
                                                  //               letterSpacing:
                                                  //                   0.5)),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment
                                                  //           .spaceBetween,
                                                  //   children: [
                                                  //     Expanded(
                                                  //       flex: 8,
                                                  //       child: Text(
                                                  //           'mutton price',
                                                  //           overflow:
                                                  //               TextOverflow
                                                  //                   .ellipsis,
                                                  //           style: const TextStyle(
                                                  //               color: Color(
                                                  //                   0xFF004D40),
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .normal,
                                                  //               fontSize: 13.0,
                                                  //               letterSpacing:
                                                  //                   0.5)),
                                                  //     ),
                                                  //     Expanded(
                                                  //       flex: 3,
                                                  //       child: Text(
                                                  //           '₹' +
                                                  //               '$ourPriceMutton',
                                                  //           overflow:
                                                  //               TextOverflow
                                                  //                   .ellipsis,
                                                  //           style: const TextStyle(
                                                  //               color: Color(
                                                  //                   0xFF004D40),
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .bold,
                                                  //               fontSize: 13.0,
                                                  //               letterSpacing:
                                                  //                   0.5)),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  //--

                                                  Text(
                                                    "Area Price",
                                                    style: FlutterFlowTheme
                                                        .of(context)
                                                        .bodyLarge
                                                        .override(
                                                      fontWeight:
                                                      FontWeight
                                                          .w500,
                                                      fontFamily:
                                                      'Outfit',
                                                      color: FlutterFlowTheme.of(
                                                          context)
                                                          .primary,
                                                      letterSpacing:
                                                      0.5,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Text(
                                                            'chickn with skin price',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                            '₹' +
                                                                '$areaPriceChicknWithSkin',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Text(
                                                            'chickn without skin price',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                            '₹' +
                                                                '$areaPriceChicknWithoutSkin',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 50,
                                                      child: Divider()),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Text(
                                                            'Chicken Boneless',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                            '₹' +
                                                                '$areaPriceChickenBoneless',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Text(
                                                            'Chicken Leg Piece',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                            '₹' +
                                                                '$areaPriceChickenLegPiece',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Text(
                                                            'Chicken Chest Piece',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                            '₹' +
                                                                '$areaPriceChickenChestPiece',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 50,
                                                      child: Divider()),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Text(
                                                            'mutton price',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                            '₹' +
                                                                '$areaPriceMutton',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Text(
                                                            'Mutton Liver',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                            '₹' +
                                                                '$areaPriceMuttonLiver',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Text(
                                                            'Mutton Boneless',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                            '₹' +
                                                                '$areaPriceMuttonBoneless',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 50,
                                                      child: Divider()),
                                                  Divider(),
                                                  Text(
                                                    "Our Price",
                                                    style: FlutterFlowTheme
                                                        .of(context)
                                                        .bodyLarge
                                                        .override(
                                                      fontWeight:
                                                      FontWeight
                                                          .w500,
                                                      fontFamily:
                                                      'Outfit',
                                                      color: FlutterFlowTheme.of(
                                                          context)
                                                          .primary,
                                                      letterSpacing:
                                                      0.5,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Text(
                                                            'chickn with skin price',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                            '₹' +
                                                                '$ourPriceChicknWithSkin',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Text(
                                                            'chickn without skin price',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                            '₹' +
                                                                '$ourPriceChicknWithoutSkin',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 50,
                                                      child: Divider()),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Text(
                                                            'Chicken Boneless',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                            '₹' +
                                                                '$ourPriceChickenBoneless',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Text(
                                                            'Chicken Leg Piece',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                            '₹' +
                                                                '$ourPriceChickenLegPiece',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Text(
                                                            'Chicken Chest Piece',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                            '₹' +
                                                                '$ourPriceChickenChestPiece',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 50,
                                                      child: Divider()),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Text(
                                                            'Mutton Price',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                            '₹' +
                                                                '$ourPriceMutton',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Text(
                                                            'Mutton Liver',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                            '₹' +
                                                                '$ourPriceMuttonLiver',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Text(
                                                            'Mutton Boneless ',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                            '₹' +
                                                                '$ourPriceMuttonBoneless',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF004D40),
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                13.0,
                                                                letterSpacing:
                                                                0.5)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 50,
                                                      child: Divider()),
                                                ],
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddNewArea(
                                                      getDocId: docId ?? "",
                                                      getArea: areaName,
                                                      getAreaChickeWithSkinPrice:
                                                          areaPriceChicknWithSkin ??
                                                              "",
                                                      getAreaChickeWithOutSkinPrice:
                                                          areaPriceChicknWithoutSkin ??
                                                              "",
                                                      getAreaMuttonPrice:
                                                          areaPriceMutton ?? "",
                                                      getOurChickeWithSkinPrice:
                                                          ourPriceChicknWithSkin,
                                                      isUpdatingExistingDetails:
                                                          true,
                                                      getOurChickeWithoutSkinPrice:
                                                          ourPriceChicknWithoutSkin,
                                                      getOurMuttonPrice:
                                                          ourPriceMutton,
                                                      getUserIndex: index ?? 0,
                                                      getAreaChickenBonelessPrice:
                                                          areaPriceChickenBoneless,
                                                      getAreaChickenChestPiecePrice:
                                                          areaPriceChickenChestPiece,
                                                      getAreaChickenLegPiecePrice:
                                                          areaPriceChickenLegPiece,
                                                      getOurChickenBonelessPrice:
                                                          ourPriceChickenBoneless,
                                                      getOurChickenChestPiecePrice:
                                                          ourPriceChickenChestPiece,
                                                      getOurChickenLegPiecePrice:
                                                          ourPriceChickenLegPiece,
                                                      getAreaMuttonBonelessPrice:
                                                          areaPriceMuttonBoneless,
                                                      getAreaMuttonLiverPrice:
                                                          areaPriceMuttonLiver,
                                                      getOurMuttonBonelessPrice:
                                                          ourPriceMuttonBoneless,
                                                      getOurMuttonLiverPrice:
                                                          ourPriceMuttonLiver,
                                                    ),
                                                  ),
                                                ).then((value) {
                                                  //todo:- below code refresh firebase records automatically when come back to same screen
                                                  // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  childCount: ref
                                          .read(areaListProvider.notifier)
                                          .areaList
                                          ?.length ??
                                      0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Expanded(
                                    child: Container(
                                  width: 100.w,
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //     builder: (context) =>
                                                  //      AddNewArea(),
                                                  //   ),
                                                  // ).then((value) {
                                                  //   //todo:- below code refresh firebase records automatically when come back to same screen
                                                  //   // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                                                  // });
                                                },
                                                child: Text(
                                                  'Add New Area',
                                                  style: TextStyle(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondary,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0), // Set the border radius here
                                                  ), // Set the background color here
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ),
                      )
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
                    : Container(),
              ],
            ),
          );
        }),
      );
    } else if (getUserType == "1") {
      //todo:- meat shop owner ui
      return Scaffold(
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
                title: Text(
                  "Update Area",
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
                  icon: const Icon(Icons.arrow_back_ios_rounded,
                      color: Colors.white),
                ),
                centerTitle: true,
                elevation: 0.0,
              )
            : null,
        body: Consumer(builder: (context, ref, child) {
          AreaState getAreaList = ref.watch(areaListProvider);
          bool? isRefresh = ref.watch(isRefreshIndicator);
          bool isLoading = false;
          isLoading = (getAreaList.status == ResStatus.loading);
          return Container(
            color: Colors.white,
            height: 100.h,
            child: Stack(
              children: [
                Container(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 8,
                        child: RefreshIndicator(
                          onRefresh: _handleRefresh,
                          child: CustomScrollView(
                            slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    final document = ref
                                        .read(areaListProvider.notifier)
                                        .areaList?[index];

                                    final areaName = document?.areaName;
                                    final areaPriceChicknWithSkin =
                                        document?.areaPriceChicknWithSkin;
                                    final areaPriceChicknWithoutSkin =
                                        document?.areaPriceChicknWithoutSkin;

//--
                                    final areaPriceChickenLegPiece =
                                        document?.areaPriceChickenLegPiece;
                                    final areaPriceChickenChestPiece =
                                        document?.areaPriceChickenChestPiece;
                                    final areaPriceChickenBoneless =
                                        document?.areaPriceChickenBoneless;

                                    //--

                                    final areaPriceMutton =
                                        document?.areaPriceMutton;

                                    final areaPriceMuttonBoneless =
                                        document?.areaPriceMuttonBoneless;
                                    final areaPriceMuttonLiver =
                                        document?.areaPriceMuttonLiver;

                                    //--

                                    final ourPriceChicknWithSkin =
                                        document?.ourPriceChicknWithSkin;
                                    final ourPriceChicknWithoutSkin =
                                        document?.ourPriceChicknWithoutSkin;
//--
                                    final ourPriceChickenLegPiece =
                                        document?.ourPriceChickenLegPiece;
                                    final ourPriceChickenChestPiece =
                                        document?.ourPriceChickenChestPiece;
                                    final ourPriceChickenBoneless =
                                        document?.ourPriceChickenBoneless;

                                    //--
                                    final ourPriceMutton =
                                        document?.ourPriceMutton;

                                    final ourPriceMuttonBoneless =
                                        document?.ourPriceMuttonBoneless;
                                    final ourPriceMuttonLiver =
                                        document?.ourPriceMuttonLiver;

                                    //--

                                    final docId = document?.docId;

                                    return (areaName ?? "") ==
                                            widget.getAdminMobileNo
                                        ? Container(
                                            color:
                                                Colors.white.withOpacity(0.95),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                elevation: 4.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  child: ListTile(
                                                    leading: Card(
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      elevation: 6.0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40.0),
                                                      ),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    8.0,
                                                                    8.0,
                                                                    8.0,
                                                                    8.0),
                                                        child: Icon(
                                                          Icons.location_on,
                                                          color: Colors.white,
                                                          size: 24.0,
                                                        ),
                                                      ),
                                                    ),
                                                    title: Text(
                                                      areaName
                                                          .toString()
                                                          .toUpperCase(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFF004D40),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.5),
                                                    ),
                                                    subtitle: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Area Price",
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'Outfit',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                letterSpacing:
                                                                    0.5,
                                                              ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 8,
                                                              child: Text(
                                                                  'chickn with skin price',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                  '₹' +
                                                                      '$areaPriceChicknWithSkin',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 8,
                                                              child: Text(
                                                                  'chickn without skin price',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                  '₹' +
                                                                      '$areaPriceChicknWithoutSkin',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            width: 50,
                                                            child: Divider()),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 8,
                                                              child: Text(
                                                                  'Chicken Boneless',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                  '₹' +
                                                                      '$areaPriceChickenBoneless',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 8,
                                                              child: Text(
                                                                  'Chicken Leg Piece',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                  '₹' +
                                                                      '$areaPriceChickenLegPiece',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 8,
                                                              child: Text(
                                                                  'Chicken Chest Piece',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                  '₹' +
                                                                      '$areaPriceChickenChestPiece',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            width: 50,
                                                            child: Divider()),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 8,
                                                              child: Text(
                                                                  'mutton price',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                  '₹' +
                                                                      '$areaPriceMutton',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 8,
                                                              child: Text(
                                                                  'Mutton Liver',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                  '₹' +
                                                                      '$areaPriceMuttonLiver',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 8,
                                                              child: Text(
                                                                  'Mutton Boneless',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                  '₹' +
                                                                      '$areaPriceMuttonBoneless',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            width: 50,
                                                            child: Divider()),
                                                        Divider(),
                                                        Text(
                                                          "Our Price",
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'Outfit',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                letterSpacing:
                                                                    0.5,
                                                              ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 8,
                                                              child: Text(
                                                                  'chickn with skin price',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                  '₹' +
                                                                      '$ourPriceChicknWithSkin',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 8,
                                                              child: Text(
                                                                  'chickn without skin price',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                  '₹' +
                                                                      '$ourPriceChicknWithoutSkin',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            width: 50,
                                                            child: Divider()),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 8,
                                                              child: Text(
                                                                  'Chicken Boneless',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                  '₹' +
                                                                      '$ourPriceChickenBoneless',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 8,
                                                              child: Text(
                                                                  'Chicken Leg Piece',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                  '₹' +
                                                                      '$ourPriceChickenLegPiece',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 8,
                                                              child: Text(
                                                                  'Chicken Chest Piece',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                  '₹' +
                                                                      '$ourPriceChickenChestPiece',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            width: 50,
                                                            child: Divider()),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 8,
                                                              child: Text(
                                                                  'Mutton Price',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                  '₹' +
                                                                      '$ourPriceMutton',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 8,
                                                              child: Text(
                                                                  'Mutton Liver',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                  '₹' +
                                                                      '$ourPriceMuttonLiver',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 8,
                                                              child: Text(
                                                                  'Mutton Boneless ',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                  '₹' +
                                                                      '$ourPriceMuttonBoneless',
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF004D40),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.5)),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            width: 50,
                                                            child: Divider()),
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddNewArea(
                                                            getDocId:
                                                                docId ?? "",
                                                            getArea: areaName,
                                                            getAreaChickeWithSkinPrice:
                                                                areaPriceChicknWithSkin ??
                                                                    "",
                                                            getAreaChickeWithOutSkinPrice:
                                                                areaPriceChicknWithoutSkin ??
                                                                    "",
                                                            getAreaMuttonPrice:
                                                                areaPriceMutton ??
                                                                    "",
                                                            getOurChickeWithSkinPrice:
                                                                ourPriceChicknWithSkin,
                                                            isUpdatingExistingDetails:
                                                                true,
                                                            getOurChickeWithoutSkinPrice:
                                                                ourPriceChicknWithoutSkin,
                                                            getOurMuttonPrice:
                                                                ourPriceMutton,
                                                            getUserIndex:
                                                                index ?? 0,
                                                            getAreaChickenBonelessPrice:
                                                                areaPriceChickenBoneless,
                                                            getAreaChickenChestPiecePrice:
                                                                areaPriceChickenChestPiece,
                                                            getAreaChickenLegPiecePrice:
                                                                areaPriceChickenLegPiece,
                                                            getOurChickenBonelessPrice:
                                                                ourPriceChickenBoneless,
                                                            getOurChickenChestPiecePrice:
                                                                ourPriceChickenChestPiece,
                                                            getOurChickenLegPiecePrice:
                                                                ourPriceChickenLegPiece,
                                                            getAreaMuttonBonelessPrice:
                                                                areaPriceMuttonBoneless,
                                                            getAreaMuttonLiverPrice:
                                                                areaPriceMuttonLiver,
                                                            getOurMuttonBonelessPrice:
                                                                ourPriceMuttonBoneless,
                                                            getOurMuttonLiverPrice:
                                                                ourPriceMuttonLiver,
                                                          ),
                                                        ),
                                                      ).then((value) {
                                                        //todo:- below code refresh firebase records automatically when come back to same screen
                                                        // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox.shrink();
                                  },
                                  childCount: ref
                                          .read(areaListProvider.notifier)
                                          .areaList
                                          ?.length ??
                                      0,
                                ),
                              )
                            ],
                          ),
                        ),
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
                    : Container(),
              ],
            ),
          );
        }),
      );
    } else {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondary,
        appBar: AppBar(
          backgroundColor: Constants.secondary,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: Constants
                .secondary3, // Change the color of the drawer icon here
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          //todo:- important in below line entire user ui changed to split into sub admin ui and normal user ui
          child: Container(
            color: Constants.secondary,
            height: 100.h,
            child: Center(
              child: Text("Loading..."),
            ),
          ),
        ),
      );
    }
  }
}
