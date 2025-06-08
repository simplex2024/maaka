import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maaakanmoney/components/NotificationService.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:maaakanmoney/components/custom_dialog_box.dart';
import 'package:maaakanmoney/pages/budget_copy/BudgetCopyController.dart';
import 'package:maaakanmoney/pages/budget_copy/budget_copy_widget.dart';
import 'package:maaakanmoney/phoneController.dart';
import 'package:maaakanmoney/verify.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

import '../../components/ListView/ListController.dart';
import '../../components/ListView/ListPageView.dart';
import '../budget_copy/navigation_drawer/meat_basket_areas/add_new_areaController.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'adduser_model.dart';
export 'adduser_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AdduserWidget extends ConsumerStatefulWidget {
  const AdduserWidget({Key? key}) : super(key: key);

  @override
  _AdduserWidgetState createState() => _AdduserWidgetState();
}

class _AdduserWidgetState extends ConsumerState<AdduserWidget> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _userName;
  String? _phoneNumber;

  TextEditingController? txtUserName;
  TextEditingController? txtphneName;
  String? Function(BuildContext, String?)? cityController1Validator;

  // State field(s) for city widget.
  TextEditingController? txtMobileNo;
  TextEditingController? addressController;

  String? Function(BuildContext, String?)? cityController2Validator;
  List<Tuple2<String?, String?>?> adminType = [];
  ConnectivityResult? data;
  Tuple2<String?, String?>? getSelectedAdmin = Tuple2("", "");

  List<MeatBasketAreaList>? areaList = [];
  List<Tuple2<String?, String?>?> getAreaLists = [];
  Tuple2<String?, String?>? getMappedAreaSelection = Tuple2("", "");
  late StreamSubscription<List<ConnectivityResult>> subscription;

  /// Initialization and disposal methods.

  @override
  void initState() {
    txtUserName ??= TextEditingController();
    txtMobileNo ??= TextEditingController();
    txtphneName ??= TextEditingController();
    addressController ??= TextEditingController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(ListProvider.notifier).txtGoalPriority?.text = "";
      ref.read(areaListProvider.notifier).getMeatBasketAreaDetails();
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
                    '3usdhnov' /* Add user */,
                  ),
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
            AreaState getAreaList = ref.watch(areaListProvider);
            bool isLoading = false;
            isLoading = (getAreaList.status == ResStatus.loading);

            if (getAreaList.status == ResStatus.success) {
              getAreaLists = [];
              areaList = getAreaList.success;
              if (areaList != null && (areaList ?? []).isNotEmpty) {
                for (var area in areaList!) {
                  getAreaLists.add(Tuple2(area?.areaName, area?.docId));
                }
              }
            }

            return SingleChildScrollView(
              child: Stack(children: [
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 25.0, 0.0, 16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: const BoxDecoration(
                                  color: Colors.blueGrey,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 10.0),
                          child: Text(
                            "New User",
                            style: FlutterFlowTheme.of(context)
                                .labelLarge
                                .override(
                                  fontFamily: 'Outfit',
                                  color: const Color(0xFF049A50),
                                  fontSize: 16.0,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20.0, 10.0, 20.0, 16.0),
                          child: TextFormField(
                            controller: txtUserName,
                            textCapitalization: TextCapitalization.words,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: FFLocalizations.of(context).getText(
                                '0nbq1nrp' /* NAME */,
                              ),
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
                            // validator:
                            //     _model.cityController1Validator.asValidator(context),

                            validator: _validateUserName,
                            onSaved: (value) => _userName = value,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20.0, 10.0, 20.0, 16.0),
                          child: TextFormField(
                            controller: txtMobileNo,
                            textCapitalization: TextCapitalization.words,
                            obscureText: false,
                            decoration: InputDecoration(
                              counterText: "",
                              labelText: FFLocalizations.of(context).getText(
                                'jfu76k1i' /* MOBILE NUMBER */,
                              ),
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
                            maxLength: 10,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color: const Color(0xFF14181B),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                ),
                            keyboardType: TextInputType.phone,
                            // validator:
                            //     _model.cityController2Validator.asValidator(context),
                            validator: _validatePhoneNumber,
                            onSaved: (value) => _phoneNumber = value,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ref.read(ListProvider.notifier).getData = adminType;
                            ref.read(ListProvider.notifier).getSelectionType =
                                SelectionType.adminType;

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListViewBuilder(
                                          getListHeading: "Map User to Admin",
                                          getIndex: null,
                                        )));
                          },
                          child: Consumer(builder: (context, ref, child) {
                            getSelectedAdmin = ref.watch(adminTypeProvider);

                            return Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20.0, 10.0, 20.0, 16.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Mapped Admin",
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 1),
                                        maxLines: 2,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                height: 50,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: TextFormField(
                                                    enabled: false,
                                                    keyboardType:
                                                        TextInputType.none,
                                                    controller: ref
                                                        .read(ListProvider
                                                            .notifier)
                                                        .txtGoalPriority,
                                                    focusNode: ref
                                                        .read(ListProvider
                                                            .notifier)
                                                        .focusGoalPriority,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .words,
                                                    decoration:
                                                        const InputDecoration(
                                                            // labelText: data.success![1][index].item2!,
                                                            suffixIcon: Icon(
                                                              Icons
                                                                  .navigate_next,
                                                              color: Color
                                                                  .fromARGB(125,
                                                                      1, 2, 2),
                                                            ),
                                                            border: InputBorder
                                                                .none),
                                                    style: const TextStyle(
                                                        letterSpacing: 1),

                                                    // keyboardType:
                                                    //     TextInputType
                                                    //         .text,
                                                    validator:
                                                        _validateMappedAdmin,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ]),
                            );
                          }),
                        ),
                        GestureDetector(
                          onTap: () {
                            ref.read(ListProvider.notifier).getData =
                                getAreaLists;
                            ref.read(ListProvider.notifier).getSelectionType =
                                SelectionType.areaList;

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListViewBuilder(
                                          getListHeading: "Area Lists",
                                          getIndex: null,
                                        )));
                          },
                          child: Consumer(builder: (context, ref, child) {
                            getMappedAreaSelection =
                                ref.watch(adminTypeProvider);

                            return Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20.0, 10.0, 20.0, 16.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Mapped Area",
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 1),
                                        maxLines: 2,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                height: 50,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: TextFormField(
                                                    enabled: false,
                                                    keyboardType:
                                                        TextInputType.none,
                                                    controller: ref
                                                        .read(ListProvider
                                                            .notifier)
                                                        .txtMappedArea,
                                                    focusNode: ref
                                                        .read(ListProvider
                                                            .notifier)
                                                        .focusMappedArea,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .words,
                                                    decoration:
                                                        const InputDecoration(
                                                            // labelText: data.success![1][index].item2!,
                                                            suffixIcon: Icon(
                                                              Icons
                                                                  .navigate_next,
                                                              color: Color
                                                                  .fromARGB(125,
                                                                      1, 2, 2),
                                                            ),
                                                            border: InputBorder
                                                                .none),
                                                    style: const TextStyle(
                                                        letterSpacing: 1),

                                                    // keyboardType:
                                                    //     TextInputType
                                                    //         .text,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        Constants.showToast(
                                                            "Please map user to Admin",
                                                            ToastGravity
                                                                .BOTTOM);
                                                        return 'Please map user Area';
                                                      }

                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ]),
                            );
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20.0, 10.0, 20.0, 16.0),
                          child: TextFormField(
                            controller: addressController,
                            decoration:
                                InputDecoration(labelText: 'fill user address'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Your Full Address';
                              }
                              return null;
                            },
                            maxLines: 8,
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0.0, 0.05),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 24.0, 0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: _submitForm,
                              text: FFLocalizations.of(context).getText(
                                'jdq9v5wm' /* Add User */,
                              ),
                              options: FFButtonOptions(
                                width: 270.0,
                                height: 50.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
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
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10.0, 30.0, 10.0, 10.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'l3nh6fz4' /* User will receive an SMS with ... */,
                            ),
                            style: FlutterFlowTheme.of(context)
                                .labelLarge
                                .override(
                                  fontFamily: 'Outfit',
                                  color: const Color(0xFF049A50),
                                  fontSize: 13.0,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                isLoading == true
                    ? Container(
                        color: Colors.transparent,
                        child: Center(
                            child: CircularProgressIndicator(
                          color: isLoading == true
                              ? Colors.transparent
                              : FlutterFlowTheme.of(context).primary,
                        )),
                      )
                    : Container(),
              ]),
            );
          }),
        ),
      ),
    );
  }

  //todo:-2.6.23 / creating new user to firestore
  void AddUser(String? getName, String? getMobile, String? getAdminId,
      String? getAddress, String? getArea) {
    if (getAdminId == "" || getAdminId == null) {
      Constants.showToast("Please map user to Admin", ToastGravity.BOTTOM);
      return;
    }

    String documentId = fireStore.collection('users').doc().id;
    int? randomCode = generateRandomCode();

    fireStore.collection('users').doc(documentId).set({
      'name': getName,
      'mobile': getMobile,
      'total': 0.0,
      'isVerified': false,
      'isPendingPayment': false,
      'isMoneyRequest': false,
      'notificationByAdmin': true,
      'requestAmnt': 0.0,
      'totalCredit': 0.0,
      'totalDebit': 0.0,
      'nominName': "", //not
      'nominMobile': "", //not
      'totalIntCredit': 0.0,
      'totalIntDebit': 0.0,
      'address': getAddress,
      'securityCode': randomCode ?? 000000,
      'isCashbackRequest': false,
      'requestCashbckAmnt': 0.0,
      'mappedAdmin': getAdminId,
      'isCanMoneyReq': false,
      'isCanCashbackReq': false,
      'area': getArea ?? "",
      'pincode': "",
      'reffererNumber': "",
      'userType': "0",
    }).then((value) {
      setState(() {
        txtUserName.text = "";
        txtMobileNo.text = "";
        ref.read(ListProvider.notifier).txtGoalPriority.text = "";
        ref.read(ListProvider.notifier).txtMappedArea.text = "";
        addressController.text = "";
      });

      Constants.showToast("User Added Successfully", ToastGravity.BOTTOM);

      // Navigator.pop(context);
    }).catchError((error) => print('Failed to create data: $error'));
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

      bool isNewCust = await isNewUser("+91" + txtMobileNo.text);

      if (isNewCust) {
        AddUser(
            txtUserName.text,
            "+91" + txtMobileNo.text,
            getSelectedAdmin?.item2 ?? "",
            addressController.text,
            getMappedAreaSelection?.item1 ?? "");
      } else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: "Alert!",
                descriptions: "User Already Added",
                text: "Ok",
                isCancel: false,
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>  BudgetCopyWidget(getUserType: "0", getAdminMobileNo: '',),
                  //   ),
                  // );
                },
              );
            });
      }
    }
  }

  String? _validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a user name';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }

    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validateMappedAdmin(String? value) {
    if (value == null || value.isEmpty) {
      Constants.showToast("Please map user to Admin", ToastGravity.BOTTOM);
      return 'Please map user to Admin';
    }

    return null;
  }
}

//todo:- 12.1.25 - make below class as final and remove above code, if goes well by using logic to add user by themselves not using security code.

class AdduserWidget1 extends ConsumerStatefulWidget {
  AdduserWidget1({
    Key? key,
    @required this.getMobile,
  }) : super(
          key: key,
        );

  String? getMobile;

  @override
  _AdduserWidget1State createState() => _AdduserWidget1State();
}

class _AdduserWidget1State extends ConsumerState<AdduserWidget1> {
  //todo:- important
  // String googleApiKey = 'AIzaSyCoJHsRYXwiXkSz5M1d5NdfHXogEKUEUug';//
  String googleApiKey = 'AIzaSyAzC-VnCrSlSSbRiTGO72ORpeqZBssL-MY';

  bool isLoading = true;

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _userName;
  String? _phoneNumber;

  TextEditingController? txtUserName;
  TextEditingController? txtphneName;
  TextEditingController? txtPincode;
  TextEditingController? txtArea;
  TextEditingController? txtReffererNo;
  String? Function(BuildContext, String?)? cityController1Validator;

  // State field(s) for city widget.
  TextEditingController? txtMobileNo;
  TextEditingController? addressController;

  String? Function(BuildContext, String?)? cityController2Validator;
  List<Tuple2<String?, String?>?> adminType = [];
  ConnectivityResult? data;
  Tuple2<String?, String?>? getSelectedAdmin = Tuple2("Babu", "2");

  List<MeatBasketAreaList>? areaList = [];
  List<Tuple2<String?, String?>?> getAreaLists = [];
  Tuple2<String?, String?>? getMappedAreaSelection = Tuple2("", "");
  late StreamSubscription<List<ConnectivityResult>> subscription;

  TextEditingController? txtMappedAdmin = TextEditingController();

  /// Initialization and disposal methods.

  @override
  void initState() {
    txtUserName ??= TextEditingController();
    txtMobileNo ??= TextEditingController();
    txtphneName ??= TextEditingController();
    addressController ??= TextEditingController();

    txtArea ??= TextEditingController();
    txtPincode ??= TextEditingController();
    txtReffererNo ??= TextEditingController();
    txtReffererNo.text = "9941445471";

    txtMappedAdmin ??= TextEditingController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(ListProvider.notifier).txtGoalPriority?.text = "";
      ref.read(areaListProvider.notifier).getMeatBasketAreaDetails();
    });
    adminType = [
      Tuple2("Meena", "1"),
      Tuple2("Babu", "2"),
    ];
    txtMappedAdmin?.text = adminType![1]?.item1 ?? "";

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      print("aaaaaa$result");

      if (result != null || result.isNotEmpty) {
        ref.read(connectivityProvider.notifier).state = result[0];
      }
    });
    fetchCurrentLocation();
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
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                automaticallyImplyLeading: true,
                title: Text(
                  "Sign In",
                  style: GlobalTextStyles.secondaryText1(
                      txtWeight: FontWeight.bold,
                      textColor: Constants.secondary),
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
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Consumer(builder: (context, ref, child) {
                  data = ref.watch(connectivityProvider);
                  AreaState getAreaList = ref.watch(areaListProvider);
                  bool isLoading = false;
                  isLoading = (getAreaList.status == ResStatus.loading);

                  if (getAreaList.status == ResStatus.success) {
                    getAreaLists = [];
                    areaList = getAreaList.success;
                    if (areaList != null && (areaList ?? []).isNotEmpty) {
                      for (var area in areaList!) {
                        getAreaLists.add(Tuple2(area?.areaName, area?.docId));
                      }
                    }
                  }

                  return GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Stack(children: [
                      Form(
                        key: _formKey,
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                flex: 8,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Personal Details',
                                                style: GlobalTextStyles
                                                    .secondaryText1(
                                                  txtWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  controller: txtUserName,
                                                  textCapitalization:
                                                      TextCapitalization.words,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    labelText: "Name",
                                                    labelStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: const Color(
                                                              0xFF57636C),
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                    hintStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: const Color(
                                                              0xFF57636C),
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFFE0E3E7),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFF004D40),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFFFF5963),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFFFF5963),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    contentPadding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(20.0,
                                                            24.0, 0.0, 24.0),
                                                  ),
                                                  style: GlobalTextStyles
                                                      .secondaryText2(
                                                    txtWeight: FontWeight.bold,
                                                  ),
                                                  // validator:
                                                  //     _model.cityController1Validator.asValidator(context),

                                                  validator: _validateUserName,
                                                  onSaved: (value) =>
                                                      _userName = value,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  controller: txtMobileNo,
                                                  textCapitalization:
                                                      TextCapitalization.words,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    counterText: "",
                                                    labelText:
                                                        "Confirm Mobile Number",
                                                    labelStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: const Color(
                                                              0xFF57636C),
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                    hintStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: const Color(
                                                              0xFF57636C),
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFFE0E3E7),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFF004D40),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFFFF5963),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFFFF5963),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    contentPadding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(20.0,
                                                            24.0, 0.0, 24.0),
                                                  ),
                                                  maxLength: 10,
                                                  style: GlobalTextStyles
                                                      .secondaryText2(
                                                    txtWeight: FontWeight.bold,
                                                  ),
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  // validator:
                                                  //     _model.cityController2Validator.asValidator(context),
                                                  validator:
                                                      _validatePhoneNumber,
                                                  onSaved: (value) =>
                                                      _phoneNumber = value,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Home Address',
                                                style: GlobalTextStyles
                                                    .secondaryText1(
                                                  txtWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  controller: txtPincode,
                                                  textCapitalization:
                                                      TextCapitalization.words,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    labelText: "Pincode",
                                                    labelStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: const Color(
                                                              0xFF57636C),
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                    hintStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: const Color(
                                                              0xFF57636C),
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFFE0E3E7),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFF004D40),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFFFF5963),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFFFF5963),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    contentPadding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(20.0,
                                                            24.0, 0.0, 24.0),
                                                  ),
                                                  style: GlobalTextStyles
                                                      .secondaryText2(
                                                    txtWeight: FontWeight.bold,
                                                  ),
                                                  // validator:
                                                  //     _model.cityController1Validator.asValidator(context),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  validator: _validatePincode,
                                                  onSaved: (value) =>
                                                      _userName = value,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  controller: txtArea,
                                                  textCapitalization:
                                                      TextCapitalization.words,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    counterText: "",
                                                    labelText: "Area",
                                                    labelStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: const Color(
                                                              0xFF57636C),
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                    hintStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: const Color(
                                                              0xFF57636C),
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFFE0E3E7),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFF004D40),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFFFF5963),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFFFF5963),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    contentPadding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(20.0,
                                                            24.0, 0.0, 24.0),
                                                  ),
                                                  style: GlobalTextStyles
                                                      .secondaryText2(
                                                    txtWeight: FontWeight.bold,
                                                  ),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  // validator:
                                                  //     _model.cityController2Validator.asValidator(context),
                                                  validator: _validateUserArea,
                                                  onSaved: (value) =>
                                                      _phoneNumber = value,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  controller: addressController,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        'Enter your Full Address',
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Rounded corners
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0xFFE0E3E7),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFF004D40),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFFFF5963),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFFFF5963),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                  style: GlobalTextStyles
                                                      .secondaryText2(
                                                    txtWeight: FontWeight.bold,
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please Enter your Full Address';
                                                    }
                                                    return null;
                                                  },
                                                  maxLines: 8,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Refferer Details',
                                                style: GlobalTextStyles
                                                    .secondaryText1(
                                                  txtWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  controller: txtReffererNo,
                                                  textCapitalization:
                                                      TextCapitalization.words,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        "Refferer Mobile Number",
                                                    labelStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: const Color(
                                                              0xFF57636C),
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                    hintStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: const Color(
                                                              0xFF57636C),
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFFE0E3E7),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFF004D40),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFFFF5963),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFFFF5963),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    contentPadding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(20.0,
                                                            24.0, 0.0, 24.0),
                                                  ),
                                                  style: GlobalTextStyles
                                                      .secondaryText2(
                                                    txtWeight: FontWeight.bold,
                                                  ),
                                                  // validator:
                                                  //     _model.cityController1Validator.asValidator(context),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  validator:
                                                      _validateReffererNumber,
                                                  onSaved: (value) =>
                                                      _userName = value,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            // Background color
                                            borderRadius: BorderRadius.circular(
                                                15), // Circular corners
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0.0, 0.05),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 24.0,
                                                            0.0, 0.0),
                                                    child: FFButtonWidget(
                                                      onPressed: _submitForm,
                                                      text: "Sign In",
                                                      options: FFButtonOptions(
                                                        width: 270.0,
                                                        height: 50.0,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(0.0,
                                                                0.0, 0.0, 0.0),
                                                        iconPadding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(0.0,
                                                                0.0, 0.0, 0.0),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Outfit',
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                        elevation: 2.0,
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      isLoading == true
                          ? Container(
                              color: Colors.transparent,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: isLoading == true
                                    ? Colors.transparent
                                    : FlutterFlowTheme.of(context).primary,
                              )),
                            )
                          : Container(),
                    ]),
                  );

                  //   SingleChildScrollView(
                  //   child: Stack(children: [
                  //     Container(
                  //       child: Form(
                  //         key: _formKey,
                  //         child: Column(
                  //           mainAxisSize: MainAxisSize.max,
                  //           children: [
                  //             Padding(
                  //               padding: const EdgeInsetsDirectional.fromSTEB(
                  //                   0.0, 25.0, 0.0, 16.0),
                  //               child: Row(
                  //                 mainAxisSize: MainAxisSize.max,
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Container(
                  //                     width: 100.0,
                  //                     height: 100.0,
                  //                     decoration: const BoxDecoration(
                  //                       color: Colors.blueGrey,
                  //                       shape: BoxShape.circle,
                  //                     ),
                  //                     child: const Icon(
                  //                       Icons.person,
                  //                       color: Colors.white,
                  //                       size: 50.0,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsetsDirectional.fromSTEB(
                  //                   0.0, 0.0, 0.0, 10.0),
                  //               child: Text(
                  //                 "New User",
                  //                 style: FlutterFlowTheme.of(context)
                  //                     .labelLarge
                  //                     .override(
                  //                   fontFamily: 'Outfit',
                  //                   color: const Color(0xFF049A50),
                  //                   fontSize: 16.0,
                  //                 ),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsetsDirectional.fromSTEB(
                  //                   20.0, 10.0, 20.0, 16.0),
                  //               child: TextFormField(
                  //                 controller: txtUserName,
                  //                 textCapitalization: TextCapitalization.words,
                  //                 obscureText: false,
                  //                 decoration: InputDecoration(
                  //                   labelText: FFLocalizations.of(context).getText(
                  //                     '0nbq1nrp' /* NAME */,
                  //                   ),
                  //                   labelStyle: FlutterFlowTheme.of(context)
                  //                       .labelMedium
                  //                       .override(
                  //                     fontFamily: 'Outfit',
                  //                     color: const Color(0xFF57636C),
                  //                     fontSize: 14.0,
                  //                     fontWeight: FontWeight.normal,
                  //                   ),
                  //                   hintStyle: FlutterFlowTheme.of(context)
                  //                       .labelMedium
                  //                       .override(
                  //                     fontFamily: 'Outfit',
                  //                     color: const Color(0xFF57636C),
                  //                     fontSize: 14.0,
                  //                     fontWeight: FontWeight.normal,
                  //                   ),
                  //                   enabledBorder: OutlineInputBorder(
                  //                     borderSide: const BorderSide(
                  //                       color: Color(0xFFE0E3E7),
                  //                       width: 2.0,
                  //                     ),
                  //                     borderRadius: BorderRadius.circular(8.0),
                  //                   ),
                  //                   focusedBorder: OutlineInputBorder(
                  //                     borderSide: const BorderSide(
                  //                       color: Color(0xFF004D40),
                  //                       width: 2.0,
                  //                     ),
                  //                     borderRadius: BorderRadius.circular(8.0),
                  //                   ),
                  //                   errorBorder: OutlineInputBorder(
                  //                     borderSide: const BorderSide(
                  //                       color: Color(0xFFFF5963),
                  //                       width: 2.0,
                  //                     ),
                  //                     borderRadius: BorderRadius.circular(8.0),
                  //                   ),
                  //                   focusedErrorBorder: OutlineInputBorder(
                  //                     borderSide: const BorderSide(
                  //                       color: Color(0xFFFF5963),
                  //                       width: 2.0,
                  //                     ),
                  //                     borderRadius: BorderRadius.circular(8.0),
                  //                   ),
                  //                   filled: true,
                  //                   fillColor: Colors.white,
                  //                   contentPadding:
                  //                   const EdgeInsetsDirectional.fromSTEB(
                  //                       20.0, 24.0, 0.0, 24.0),
                  //                 ),
                  //                 style: FlutterFlowTheme.of(context)
                  //                     .bodyMedium
                  //                     .override(
                  //                   fontFamily: 'Outfit',
                  //                   color: const Color(0xFF14181B),
                  //                   fontSize: 14.0,
                  //                   fontWeight: FontWeight.normal,
                  //                 ),
                  //                 // validator:
                  //                 //     _model.cityController1Validator.asValidator(context),
                  //
                  //                 validator: _validateUserName,
                  //                 onSaved: (value) => _userName = value,
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsetsDirectional.fromSTEB(
                  //                   20.0, 10.0, 20.0, 16.0),
                  //               child: TextFormField(
                  //                 controller: txtMobileNo,
                  //                 textCapitalization: TextCapitalization.words,
                  //                 obscureText: false,
                  //                 decoration: InputDecoration(
                  //                   counterText: "",
                  //                   labelText: FFLocalizations.of(context).getText(
                  //                     'jfu76k1i' /* MOBILE NUMBER */,
                  //                   ),
                  //                   labelStyle: FlutterFlowTheme.of(context)
                  //                       .labelMedium
                  //                       .override(
                  //                     fontFamily: 'Outfit',
                  //                     color: const Color(0xFF57636C),
                  //                     fontSize: 14.0,
                  //                     fontWeight: FontWeight.normal,
                  //                   ),
                  //                   hintStyle: FlutterFlowTheme.of(context)
                  //                       .labelMedium
                  //                       .override(
                  //                     fontFamily: 'Outfit',
                  //                     color: const Color(0xFF57636C),
                  //                     fontSize: 14.0,
                  //                     fontWeight: FontWeight.normal,
                  //                   ),
                  //                   enabledBorder: OutlineInputBorder(
                  //                     borderSide: const BorderSide(
                  //                       color: Color(0xFFE0E3E7),
                  //                       width: 2.0,
                  //                     ),
                  //                     borderRadius: BorderRadius.circular(8.0),
                  //                   ),
                  //                   focusedBorder: OutlineInputBorder(
                  //                     borderSide: const BorderSide(
                  //                       color: Color(0xFF004D40),
                  //                       width: 2.0,
                  //                     ),
                  //                     borderRadius: BorderRadius.circular(8.0),
                  //                   ),
                  //                   errorBorder: OutlineInputBorder(
                  //                     borderSide: const BorderSide(
                  //                       color: Color(0xFFFF5963),
                  //                       width: 2.0,
                  //                     ),
                  //                     borderRadius: BorderRadius.circular(8.0),
                  //                   ),
                  //                   focusedErrorBorder: OutlineInputBorder(
                  //                     borderSide: const BorderSide(
                  //                       color: Color(0xFFFF5963),
                  //                       width: 2.0,
                  //                     ),
                  //                     borderRadius: BorderRadius.circular(8.0),
                  //                   ),
                  //                   filled: true,
                  //                   fillColor: Colors.white,
                  //                   contentPadding:
                  //                   const EdgeInsetsDirectional.fromSTEB(
                  //                       20.0, 24.0, 0.0, 24.0),
                  //                 ),
                  //                 maxLength: 10,
                  //                 style: FlutterFlowTheme.of(context)
                  //                     .bodyMedium
                  //                     .override(
                  //                   fontFamily: 'Outfit',
                  //                   color: const Color(0xFF14181B),
                  //                   fontSize: 14.0,
                  //                   fontWeight: FontWeight.normal,
                  //                 ),
                  //                 keyboardType: TextInputType.phone,
                  //                 // validator:
                  //                 //     _model.cityController2Validator.asValidator(context),
                  //                 validator: _validatePhoneNumber,
                  //                 onSaved: (value) => _phoneNumber = value,
                  //               ),
                  //             ),
                  //             GestureDetector(
                  //               onTap: () {
                  //                 ref.read(ListProvider.notifier).getData = adminType;
                  //                 ref.read(ListProvider.notifier).getSelectionType =
                  //                     SelectionType.adminType;
                  //
                  //                 Navigator.push(
                  //                     context,
                  //                     MaterialPageRoute(
                  //                         builder: (context) => ListViewBuilder(
                  //                           getListHeading: "Map User to Admin",
                  //                           getIndex: null,
                  //                         )));
                  //               },
                  //               child: Consumer(builder: (context, ref, child) {
                  //                 getSelectedAdmin = ref.watch(adminTypeProvider);
                  //
                  //                 return Padding(
                  //                   padding: const EdgeInsetsDirectional.fromSTEB(
                  //                       20.0, 10.0, 20.0, 16.0),
                  //                   child: Column(
                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                  //                       children: [
                  //                         Padding(
                  //                           padding: const EdgeInsets.only(left: 10),
                  //                           child: Text(
                  //                             "Mapped Admin",
                  //                             style: const TextStyle(
                  //                                 color: Colors.grey,
                  //                                 fontWeight: FontWeight.w400,
                  //                                 letterSpacing: 1),
                  //                             maxLines: 2,
                  //                             softWrap: false,
                  //                             overflow: TextOverflow.fade,
                  //                             textAlign: TextAlign.justify,
                  //                           ),
                  //                         ),
                  //                         Row(
                  //                             mainAxisAlignment:
                  //                             MainAxisAlignment.spaceEvenly,
                  //                             children: [
                  //                               Expanded(
                  //                                 child: Padding(
                  //                                   padding:
                  //                                   const EdgeInsets.all(5.0),
                  //                                   child: Container(
                  //                                     height: 50,
                  //                                     child: Padding(
                  //                                       padding:
                  //                                       const EdgeInsets.only(
                  //                                           left: 10.0),
                  //                                       child: TextFormField(
                  //                                         enabled: false,
                  //                                         keyboardType:
                  //                                         TextInputType.none,
                  //                                         controller: ref
                  //                                             .read(ListProvider
                  //                                             .notifier)
                  //                                             .txtGoalPriority,
                  //                                         focusNode: ref
                  //                                             .read(ListProvider
                  //                                             .notifier)
                  //                                             .focusGoalPriority,
                  //                                         textCapitalization:
                  //                                         TextCapitalization
                  //                                             .words,
                  //                                         decoration:
                  //                                         const InputDecoration(
                  //                                           // labelText: data.success![1][index].item2!,
                  //                                             suffixIcon: Icon(
                  //                                               Icons
                  //                                                   .navigate_next,
                  //                                               color: Color
                  //                                                   .fromARGB(125,
                  //                                                   1, 2, 2),
                  //                                             ),
                  //                                             border: InputBorder
                  //                                                 .none),
                  //                                         style: const TextStyle(
                  //                                             letterSpacing: 1),
                  //
                  //                                         // keyboardType:
                  //                                         //     TextInputType
                  //                                         //         .text,
                  //                                         validator:
                  //                                         _validateMappedAdmin,
                  //                                       ),
                  //                                     ),
                  //                                     decoration: BoxDecoration(
                  //                                       border: Border.all(
                  //                                           color: Colors.grey),
                  //                                       borderRadius:
                  //                                       BorderRadius.circular(10),
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                             ]),
                  //                       ]),
                  //                 );
                  //               }),
                  //             ),
                  //             GestureDetector(
                  //               onTap: () {
                  //                 ref.read(ListProvider.notifier).getData =
                  //                     getAreaLists;
                  //                 ref.read(ListProvider.notifier).getSelectionType =
                  //                     SelectionType.areaList;
                  //
                  //                 Navigator.push(
                  //                     context,
                  //                     MaterialPageRoute(
                  //                         builder: (context) => ListViewBuilder(
                  //                           getListHeading: "Area Lists",
                  //                           getIndex: null,
                  //                         )));
                  //               },
                  //               child: Consumer(builder: (context, ref, child) {
                  //                 getMappedAreaSelection =
                  //                     ref.watch(adminTypeProvider);
                  //
                  //                 return Padding(
                  //                   padding: const EdgeInsetsDirectional.fromSTEB(
                  //                       20.0, 10.0, 20.0, 16.0),
                  //                   child: Column(
                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                  //                       children: [
                  //                         Padding(
                  //                           padding: const EdgeInsets.only(left: 10),
                  //                           child: Text(
                  //                             "Mapped Area",
                  //                             style: const TextStyle(
                  //                                 color: Colors.grey,
                  //                                 fontWeight: FontWeight.w400,
                  //                                 letterSpacing: 1),
                  //                             maxLines: 2,
                  //                             softWrap: false,
                  //                             overflow: TextOverflow.fade,
                  //                             textAlign: TextAlign.justify,
                  //                           ),
                  //                         ),
                  //                         Row(
                  //                             mainAxisAlignment:
                  //                             MainAxisAlignment.spaceEvenly,
                  //                             children: [
                  //                               Expanded(
                  //                                 child: Padding(
                  //                                   padding:
                  //                                   const EdgeInsets.all(5.0),
                  //                                   child: Container(
                  //                                     height: 50,
                  //                                     child: Padding(
                  //                                       padding:
                  //                                       const EdgeInsets.only(
                  //                                           left: 10.0),
                  //                                       child: TextFormField(
                  //                                         enabled: false,
                  //                                         keyboardType:
                  //                                         TextInputType.none,
                  //                                         controller: ref
                  //                                             .read(ListProvider
                  //                                             .notifier)
                  //                                             .txtMappedArea,
                  //                                         focusNode: ref
                  //                                             .read(ListProvider
                  //                                             .notifier)
                  //                                             .focusMappedArea,
                  //                                         textCapitalization:
                  //                                         TextCapitalization
                  //                                             .words,
                  //                                         decoration:
                  //                                         const InputDecoration(
                  //                                           // labelText: data.success![1][index].item2!,
                  //                                             suffixIcon: Icon(
                  //                                               Icons
                  //                                                   .navigate_next,
                  //                                               color: Color
                  //                                                   .fromARGB(125,
                  //                                                   1, 2, 2),
                  //                                             ),
                  //                                             border: InputBorder
                  //                                                 .none),
                  //                                         style: const TextStyle(
                  //                                             letterSpacing: 1),
                  //
                  //                                         // keyboardType:
                  //                                         //     TextInputType
                  //                                         //         .text,
                  //                                         validator: (value) {
                  //                                           if (value == null ||
                  //                                               value.isEmpty) {
                  //                                             Constants.showToast(
                  //                                                 "Please map user to Admin",
                  //                                                 ToastGravity
                  //                                                     .BOTTOM);
                  //                                             return 'Please map user Area';
                  //                                           }
                  //
                  //                                           return null;
                  //                                         },
                  //                                       ),
                  //                                     ),
                  //                                     decoration: BoxDecoration(
                  //                                       border: Border.all(
                  //                                           color: Colors.grey),
                  //                                       borderRadius:
                  //                                       BorderRadius.circular(10),
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                             ]),
                  //                       ]),
                  //                 );
                  //               }),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsetsDirectional.fromSTEB(
                  //                   20.0, 10.0, 20.0, 16.0),
                  //               child: TextFormField(
                  //                 controller: addressController,
                  //                 decoration:
                  //                 InputDecoration(labelText: 'fill user address'),
                  //                 validator: (value) {
                  //                   if (value == null || value.isEmpty) {
                  //                     return 'Please enter address';
                  //                   }
                  //                   return null;
                  //                 },
                  //                 maxLines: 8,
                  //               ),
                  //             ),
                  //             Align(
                  //               alignment: const AlignmentDirectional(0.0, 0.05),
                  //               child: Padding(
                  //                 padding: const EdgeInsetsDirectional.fromSTEB(
                  //                     0.0, 24.0, 0.0, 0.0),
                  //                 child: FFButtonWidget(
                  //                   onPressed: _submitForm,
                  //                   text: FFLocalizations.of(context).getText(
                  //                     'jdq9v5wm' /* Add User */,
                  //                   ),
                  //                   options: FFButtonOptions(
                  //                     width: 270.0,
                  //                     height: 50.0,
                  //                     padding: const EdgeInsetsDirectional.fromSTEB(
                  //                         0.0, 0.0, 0.0, 0.0),
                  //                     iconPadding:
                  //                     const EdgeInsetsDirectional.fromSTEB(
                  //                         0.0, 0.0, 0.0, 0.0),
                  //                     color: FlutterFlowTheme.of(context).primary,
                  //                     textStyle: FlutterFlowTheme.of(context)
                  //                         .titleMedium
                  //                         .override(
                  //                       fontFamily: 'Outfit',
                  //                       color: Colors.white,
                  //                       fontSize: 18.0,
                  //                       fontWeight: FontWeight.normal,
                  //                     ),
                  //                     elevation: 2.0,
                  //                     borderSide: const BorderSide(
                  //                       color: Colors.transparent,
                  //                       width: 1.0,
                  //                     ),
                  //                     borderRadius: BorderRadius.circular(12.0),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsetsDirectional.fromSTEB(
                  //                   10.0, 30.0, 10.0, 10.0),
                  //               child: Text(
                  //                 FFLocalizations.of(context).getText(
                  //                   'l3nh6fz4' /* User will receive an SMS with ... */,
                  //                 ),
                  //                 style: FlutterFlowTheme.of(context)
                  //                     .labelLarge
                  //                     .override(
                  //                   fontFamily: 'Outfit',
                  //                   color: const Color(0xFF049A50),
                  //                   fontSize: 13.0,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     isLoading == true
                  //         ? Container(
                  //       color: Colors.transparent,
                  //       child: Center(
                  //           child: CircularProgressIndicator(
                  //             color: isLoading == true
                  //                 ? Colors.transparent
                  //                 : FlutterFlowTheme.of(context).primary,
                  //           )),
                  //     )
                  //         : Container(),
                  //   ]),
                  // );
                }),
        ),
      ),
    );
  }

  //todo:-2.6.23 / creating new user to firestore
  void AddUser(
      String? getName,
      String? getMobile,
      String? getAdminId,
      String? getAddress,
      String? getArea,
      String? getPincode,
      String? getReffererNo,
      String? getUserType) {
    if (getAdminId == "" || getAdminId == null) {
      Constants.showToast("Please map user to Admin", ToastGravity.BOTTOM);
      return;
    }

    String documentId = fireStore.collection('users').doc().id;
    int? randomCode = generateRandomCode();

    fireStore.collection('users').doc(documentId).set({
      'name': getName,
      'mobile': getMobile,
      'total': 0.0,
      'isVerified': false,
      'isPendingPayment': false,
      'isMoneyRequest': false,
      'notificationByAdmin': true,
      'requestAmnt': 0.0,
      'totalCredit': 0.0,
      'totalDebit': 0.0,
      'nominName': "", //not
      'nominMobile': "", //not
      'totalIntCredit': 0.0,
      'totalIntDebit': 0.0,
      'address': getAddress,
      'securityCode': randomCode ?? 000000,
      'isCashbackRequest': false,
      'requestCashbckAmnt': 0.0,
      'mappedAdmin': getAdminId,
      'isCanMoneyReq': false,
      'isCanCashbackReq': false,
      'area': getArea ?? "",
      'pincode': getPincode ?? "",
      'reffererNumber': getReffererNo ?? "+919941445471",
      'userType': getUserType ?? "0",
    }).then((value) {
      setState(() async {
        String? token = await NotificationService.getDocumentIDsAndData();
        if (token != null) {
          Response? response = await NotificationService.postNotificationRequest(
              token,
              "Hi Admin, New User Added 😎",
              "User Name - ${txtUserName.text}\nUser Mobile - ${txtMobileNo.text}\nKnow Your New User Better!.");
          // Handle the response as needed
        } else {
          print("Problem in getting Token");
        }

        txtUserName.text = "";
        txtMobileNo.text = "";
        ref.read(ListProvider.notifier).txtGoalPriority.text = "";
        ref.read(ListProvider.notifier).txtMappedArea.text = "";
        addressController.text = "";

        //todo:- 12.1.2025, now user themselve add to admin dashboard list count
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => MpinSetUp(
              getMobile: "+91" + (widget.getMobile ?? ""),
            ),
            transitionsBuilder: (_, animation, __, child) {
              return ScaleTransition(
                scale: Tween<double>(
                  begin: 0.0, // You can adjust the start scale
                  end: 1.0, // You can adjust the end scale
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
      });

      // Constants.showToast("Welcome", ToastGravity.CENTER);

      // Navigator.pop(context);
    }).catchError((error) => print('Failed to create data: $error'));
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

//todo:- if fetched pincode edited then validate pincode again

      bool? isValidPincode = await validatePincode(txtPincode.text ?? "");

      if (!(isValidPincode ?? false)) {
        Constants.showToast("Invalid Pincode", ToastGravity.BOTTOM);
        return;
      }

      //todo:-  after validating pincode , add validated pincode to areameat prices table
      bool? isAreaMeatPriceAdded = await AddNewAreaMeatPrice(
        getPincode: txtPincode.text ?? "",
        getAreaName: txtArea.text ?? "",
        getAreaPriceChickenWithSkin: "220",
        getAreaPriceChickenWithoutSkin: "250",
        getAreaPriceMutton: "900",
        getOurPriceChickenWithSkin: "210",
        getOurPriceChickenWithoutSkin: "240",
        getOurPriceMutton: "890",

        //chicken
        getAreaChickenBonelessPrice: "200",
        getAreaChickenChestPiecePrice: "200",
        getAreaChickenLegPiecePrice: "200",

        //our price
        getOurChickenBonelessPrice: "200",
        getOurChickenChestPiecePrice: "200",
        getOurChickenLegPiecePrice: "200",

        // mutton
        //area
        getAreaMuttonBonelessPrice: "200",
        getAreaMuttonLiverPrice: "200",

        //our price
        getOurMuttonBonelessPrice: "200",
        getOurMuttonLiverPrice: "200",
      );

      if (!(isAreaMeatPriceAdded ?? false)) {
        Constants.showToast("Something Went Wrong", ToastGravity.BOTTOM);
        return;
      }

      bool isNewCust = await isNewUser("+91" + txtMobileNo.text);

      if (isNewCust) {
        print(getSelectedAdmin?.item2 ?? "");

        print(getMappedAreaSelection?.item1 ?? "");

        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: "Message!",
                descriptions: "Are you sure with Sign in Details?",
                text: "Ok",
                isCancel: true,
                onTap: () {
                  AddUser(
                      txtUserName.text,
                      "+91" + txtMobileNo.text,
                      getSelectedAdmin?.item2 ?? "",
                      addressController.text,
                      txtArea.text ?? "",
                      txtPincode.text,
                      "+91" + txtReffererNo.text,
                      "0");
                  Navigator.pop(context);
                },
              );
            });

        return;
      } else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: "Alert!",
                descriptions: "User Already Added",
                text: "Ok",
                isCancel: false,
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>  BudgetCopyWidget(getUserType: "0", getAdminMobileNo: '',),
                  //   ),
                  // );
                },
              );
            });
      }
    }
  }

  String? _validateUserName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please Enter Your Name';
    }
    return null;
  }

  String? _validateUserArea(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Your Area';
    }
    return null;
  }

  String? _validatePincode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Confirm Pincode';
    }

    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Please enter a valid 6-digit Pincoder';
    }

    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Confirm Your Mobile Number';
    }

    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }

    if (widget.getMobile != value) {
      // Constants.showToast("Phone Number Mismatched!", ToastGravity.CENTER);

      return 'Mobile Number is Mismatched!';
    }
    return null;
  }

  String? _validateReffererNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Refferer Mobile Number';
    }

    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }

    return null;
  }

  String? _validateMappedAdmin(String? value) {
    if (value == null || value.isEmpty) {
      Constants.showToast("Please map user to Admin", ToastGravity.BOTTOM);
      return 'Please map user to Admin';
    }

    return null;
  }

  // Get current location of the user
  Future<void> fetchCurrentLocation() async {
    bool granted = await requestLocationPermission();
    if (!granted) {
      setState(() {
        isLoading = false;
      });
      print("Permission denied. Cannot access location.");
      return;
    } else {
      // Get current position (latitude and longitude)
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Use the coordinates to get the pincode and area
      await fetchAddressFromCoordinates(position.latitude, position.longitude);
    }

    // // Request permission for location access
    // LocationPermission permission = await Geolocator.requestPermission();
    //
    // if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
    //   // Get current position (latitude and longitude)
    //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //
    //   // Use the coordinates to get the pincode and area
    //   await fetchAddressFromCoordinates(position.latitude, position.longitude);
    // } else {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   print('Location permission denied');
    // }
  }

  Future<bool> requestLocationPermission() async {
    LocationPermission permission;

    // Keep requesting permission until the user grants it
    while (true) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        print("Location permission granted!");
        return true; // Permission granted
      } else {
        // Show an alert to force the user to enable it
        bool shouldOpenSettings = await showDialog(
          context: context, // Ensure this runs inside a StatefulWidget
          builder: (context) => AlertDialog(
            title: Text("Location Permission Required"),
            content: Text(
                "This app requires location access to continue. Please enable it in settings."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                  Navigator.pop(context, false);
                }, // User cancels
                child: Text("Exit"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                // User agrees to open settings
                child: Text("Open Settings"),
              ),
            ],
          ),
        );

        if (shouldOpenSettings == true) {
          await Geolocator
              .openAppSettings(); // Open settings for manual permission change
        } else {
          return false; // User exits or denies permission
        }
      }
    }
  }

  // // Fetch address details based on coordinates
  Future<void> fetchAddressFromCoordinates(
      double latitude, double longitude) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleApiKey');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      print("json String ${data}");

      if (data['status'] == 'OK') {
        // Check if we have any result with formatted_address
        var results = data['results'];

        if (results.isNotEmpty) {
          String? fullAddress = results[0][
              'formatted_address']; // Get the full address from the first result

          List<String> addressComponents = [];

          print("sd ${results[0]}");

          for (var component in results[0]['address_components']) {
            if (component['types'].contains('postal_code')) {
              txtPincode.text = component['long_name']; // Get the pincode
            }
            if (component['types'].contains('locality')) {
              // city = component['long_name'];  // Get the locality (area) name
            }
            if (component['types'].contains('sublocality')) {
              txtArea.text =
                  component['long_name']; // Get the locality (area) name
            }
          }

          // Set the full address
          addressController.text = fullAddress ?? 'Full address not available';

          // Set the state to show the results
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          print('No results found in geocoding response');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error: ${data['status']}');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to fetch data from API: ${response.statusCode}');
    }
  }

  // Future<void> fetchAddressFromPincode(String pincode) async {
  //
  //   bool? isValidPincode = await validatePincode(pincode);
  //   if(isValidPincode ?? false){
  //     var url = Uri.parse(
  //         'https://maps.googleapis.com/maps/api/geocode/json?address=$pincode&key=$googleApiKey');
  //
  //
  //     var response = await http.get(url);
  //
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //
  //       print("JSON Response: $data");
  //
  //       if (data['status'] == 'OK') {
  //         var results = data['results'];
  //
  //         if (results.isNotEmpty) {
  //           String? fullAddress = results[0]['formatted_address'];  // Get the full address from the first result
  //
  //           List<String> addressComponents = [];
  //
  //           print("sd ${results[0]}");
  //
  //           for (var component in results[0]['address_components']) {
  //             if (component['types'].contains('postal_code')) {
  //               pincodee = component['long_name'];  // Get the pincode
  //             }
  //             if (component['types'].contains('locality')) {
  //               city = component['long_name'];  // Get the locality (area) name
  //             }
  //             if (component['types'].contains('sublocality')) {
  //               area = component['long_name'];  // Get the locality (area) name
  //             }
  //           }
  //
  //           // Set the full address
  //           address = fullAddress ?? 'Full address not available';
  //
  //           // Set the state to show the results
  //           setState(() {
  //             isLoading = false;
  //           });
  //         } else {
  //           setState(() {
  //             isLoading = false;
  //           });
  //           print('No results found for the given pincode');
  //         }
  //       } else {
  //         setState(() {
  //           isLoading = false;
  //         });
  //         print('Error: ${data['status']}');
  //       }
  //     } else {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       print('Failed to fetch data from API: ${response.statusCode}');
  //     }
  //   }else{
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print("invalid pincode");
  //   }
  //
  // }

  Future<bool?> validatePincode(String pincode) async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$pincode&key=$googleApiKey');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        setState(() {
          isLoading = false;
        });
        return true;
      } else {
        Constants.showToast("Invalid Pincode", ToastGravity.CENTER);
        setState(() {
          isLoading = false;
        });
        return false;
      }
    } else {
      Constants.showToast("Invalid Pincode", ToastGravity.CENTER);
      setState(() {
        isLoading = false;
      });
      return false;
    }
    return false;
  }

  Future<bool?> AddNewAreaMeatPrice({
    @required String? getPincode,
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
  }) async {
    setState(() {
      isLoading = true;
    });

    String documentId = getPincode ?? "";
    DocumentReference docRef =
        fireStore.collection('AreaMeatPrices').doc(documentId);

    try {
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        print("Document exists: $documentId");
        setState(() {
          isLoading = false;
        });
        return true;
      } else {
        print("Document does not exist: $documentId");

        await docRef.set({
          getPincode ?? "": {
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
        });

        setState(() {
          isLoading = false;
        });

        Constants.showToast("Area Details Added", ToastGravity.BOTTOM);
        return true;
      }
    } catch (error) {
      print("Error checking or saving document: $error");

      setState(() {
        isLoading = false;
      });

      return false;
    }
  }
}
