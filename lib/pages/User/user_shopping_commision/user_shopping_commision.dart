import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

import '../../../components/ListView/ListController.dart';
import '../../../components/ListView/ListPageView.dart';
import '../../../components/NotificationService.dart';
import '../../../components/constants.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../phoneController.dart';
import '../../Auth/phone_auth_widget.dart';
import '../../budget_copy/budget_copy_widget.dart';
import '../Goals/AddGoals.dart';
import '../Goals/GoalHistoryNotifier1.dart';
import '../UserScreen_Notifer.dart';
import '../Userscreen_widget.dart';

class UserShoppingCommision extends ConsumerStatefulWidget {
  UserShoppingCommision({
    Key? key,
    required this.getDocId,
    required this.getMobile,
  }) : super(key: key);

  final String? getDocId;
  final String? getMobile;

  @override
  UserShoppingCommisionState createState() => UserShoppingCommisionState();
}

class UserShoppingCommisionState extends ConsumerState<UserShoppingCommision> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? getGoalTitle;
  int? getProdAmount;
  String? getShoppingPlatformVal;
  String? getShoppingPlatformName;
  IconData? selectedIcon;
  String? selectedIconName;

  TextEditingController? txtProdName;
  TextEditingController? txtOrderId;
  TextEditingController? txtProdAmount;
  TextEditingController? _dateController;

  DateTime selectedDate = DateTime.now();

  String? Function(BuildContext, String?)? cityController2Validator;

  // List<Tuple2<String?, String?>?> goalPriorityType = [];
  ConnectivityResult? data;
  Tuple2<String?, String?>? getShoppingPlatformSelection = Tuple2("", "");
  bool _isLoading = false;
  late StreamSubscription<List<ConnectivityResult>> subscription;
  /// Initialization and disposal methods.

  @override
  void initState() {
    txtProdName ??= TextEditingController();
    txtProdAmount ??= TextEditingController();
    txtOrderId ??= TextEditingController();
    _dateController ??= TextEditingController();

    selectedIcon = Icons.tour;
    selectedIconName = "tour";
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(ListProvider.notifier).txtGoalPriority?.text = "";
      // _dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
    });
    getNotificationAccessToken();
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      print("aaaaaa$result");

      if(result != null || result.isNotEmpty){
        ref.read(connectivityProvider.notifier).state = result[0];
      }
    });
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<void> getNotificationAccessToken() async {
    final String token =
    await getAccessToken(); // Assume this is your async method to fetch the token
    // setState(() {
    Constants.accessTokenFrNotificn = token; // Store the token in the state
    // });

    // Now the accessToken can be used throughout this class
  }

  Future<String> getAccessToken() async {
    final credentials = await loadServiceAccountCredentials();

    // Extract private key and client details from service account
    final accountCredentials = ServiceAccountCredentials.fromJson(credentials);

    final authClient = await clientViaServiceAccount(
      accountCredentials,
      ['https://www.googleapis.com/auth/firebase.messaging'], // FCM scope
    );

    // Get Access Token
    final token = await authClient.credentials.accessToken;

    print("Access Token: ${token.data}");

    return token.data;
  }

  Future<Map<String, dynamic>> loadServiceAccountCredentials() async {
    String jsonData = await rootBundle
        .loadString('images/maakanmoney-a6874-9f449586b9b5.json');
    return json.decode(jsonData);
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
                backgroundColor: Constants.secondary,
                automaticallyImplyLeading: true,
                title: Text("Add Shopping Details",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Constants.secondary3,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold)),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.black,
                  ),
                ),
                centerTitle: true,
                elevation: 0,
              )
            : null,
        body: SafeArea(
          child: Consumer(builder: (context, ref, child) {
            data = ref.watch(connectivityProvider);

            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Container(

                      height: 10.h,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceEvenly,
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [

                            Text(
                                "You earn commission as real money.",
                                textAlign:
                                TextAlign.start,
                                style: Theme.of(
                                    context)
                                    .textTheme
                                    .bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                            Text(
                            "By Ordering through our app",
                              textAlign:
                              TextAlign.start,
                              style:
                              Theme.of(context)
                                  .textTheme
                                  .bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 16.0),
                      child: TextFormField(
                        controller: txtProdName,
                        textCapitalization: TextCapitalization.words,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: "Ordered Product Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                        style: GlobalTextStyles.secondaryText2(),
                        maxLength: 20,
                        validator: _validateOrderedProdName,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 10.0, 20.0, 16.0),
                      child: TextFormField(
                        controller: txtProdAmount,
                        textCapitalization: TextCapitalization.words,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: "Ordered Product Amount",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                        maxLength: 6,
                        style: GlobalTextStyles.secondaryText2(),
                        keyboardType: TextInputType.number,
                        validator: _validateOrderedProdAmount,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 10.0, 20.0, 16.0),
                      child: TextFormField(
                        controller: txtOrderId,
                        textCapitalization: TextCapitalization.words,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: "Order ID",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                        style: GlobalTextStyles.secondaryText2(),
                        maxLength: 20,
                        validator: _validateOrderId,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        List<Tuple2<String?, String?>?> getSelectionList = [
                          Tuple2("Amazon", "1"),
                          Tuple2("Flipkart", "2"),
                          Tuple2("Myntra", "3"),
                          Tuple2("Ajio", "3"),
                        ];

                        ref.read(ListProvider.notifier).getData =
                            getSelectionList;
                        ref.read(ListProvider.notifier).getSelectionType =
                            SelectionType.shoppingPlatformType;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListViewBuilder(
                                      getListHeading: "Select Shopped Platform",
                                      getIndex: null,
                                    )));
                      },
                      child: Consumer(builder: (context, ref, child) {
                        getShoppingPlatformSelection = ref.watch(adminTypeProvider);

                        return Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20.0, 10.0, 20.0, 16.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: TextFormField(
                              enabled: false,
                              keyboardType: TextInputType.none,
                              controller: ref
                                  .read(ListProvider.notifier)
                                  .txtGoalPriority,
                              focusNode: ref
                                  .read(ListProvider.notifier)
                                  .focusGoalPriority,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                labelText: "Shopped Platform",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                                suffixIcon: Icon(
                                  Icons.navigate_next,
                                  color: Color.fromARGB(125, 1, 2, 2),
                                ),
                              ),
                              style: GlobalTextStyles.secondaryText2(),
                              validator: _validateShoppingPlatform,
                            ),
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 10.0, 20.0, 16.0),
                      child: Container(
                        color: Colors.transparent,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: _dateController,

                          onTap: _selectDate,
                          readOnly: true,
                          textInputAction: TextInputAction.none,
                          obscureText: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Select Date",
                            // ...
                          ),
                          validator: _validateShoppingDate,
                          // ...
                        ),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0.0, 0.05),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 24.0, 0.0, 0.0),
                        child: _isLoading
                            ? const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(),
                              )
                            : SizedBox(
                                width: 50.w,
                                height: 5.h,
                                child: IgnorePointer(
                                  ignoring: isOtpSent == true ? true : false,
                                  child: FFButtonWidget(
                                    onPressed: _isLoading
                                        ? null
                                        : () {
                                            _submitForm();
                                          },
                                    text: "Request Commision",
                                    options: FFButtonOptions(
                                      width: 270.0,
                                      height: 20.0,
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      iconPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: Constants.secondary,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold),
                                      elevation: 2.0,
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          10.0, 30.0, 10.0, 10.0),
                      child: Text(
                        "Turn Shopping into Earnings!",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Constants.primary,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      if (data == ConnectivityResult.none) {
        setState(() {
          _isLoading = false;
        });

        Constants.showToast("No Internet Connection", ToastGravity.BOTTOM);
        return;
      } else {
        print(txtProdName.text);
        print(txtProdAmount.text);
        print(getShoppingPlatformSelection?.item2);

        if (selectedIconName == null) {
          Constants.showToast("Select Goal Icon", ToastGravity.CENTER);
          return;
        }

        getGoalTitle = txtProdName.text;
        getProdAmount = int.parse(txtProdAmount!.text);
        getShoppingPlatformVal = getShoppingPlatformSelection!.item2;
        getShoppingPlatformName =  getShoppingPlatformSelection!.item1;
        Timestamp timestamp = Timestamp.fromDate(selectedDate);

        _addCommisionReq(txtProdName.text, getProdAmount, txtOrderId.text,getShoppingPlatformVal,timestamp,getShoppingPlatformName);



      }
    }
  }

  void _addCommisionReq(String? getProdName, int? getProdAmount, String? getOrderId,
      String? getShoppingPlatform, Timestamp? getTimeStamp, String? getShoppingPlatformName) {
    setState(() {
      _isLoading = true;
    });

    fireStore.collection('users').doc(widget.getDocId).collection('shoppings').add({
      'productName': getProdName,
      'productAmnt': getProdAmount,
      'orderId': getOrderId,
      'shoppingPlatform': getShoppingPlatform,
      'timeStamp': getTimeStamp,
      'earnKaroId': "",
      'commisionAmount': "",
      'commisionStatus': ""
    }).then((_) async {
      setState(() {
        txtProdName.text = "";
        txtProdAmount.text = "";
        txtOrderId.text = "";
        _isLoading = false;
        ref.read(ListProvider.notifier).txtGoalPriority.text = "";
      });

      Constants.showToast("Commision Requested Successfully", ToastGravity.BOTTOM);

      //todo:- 2.12.23 adding notification on adding goals
      String? token = await NotificationService.getDocumentIDsAndData();
      if (token != null) {
        Response? response = await NotificationService.postNotificationRequest(
            token,
            "Hi Admin,\n${ref.read(UserDashListProvider.notifier).getUser}  Added Commision Request",
            "Purchased - $getProdName,\nAmount - $getProdAmount,\nPurchased Using - $getShoppingPlatformName .");
        // Handle the response as needed
      } else {
        print("Problem in getting Token");
      }

      Navigator.pop(context,true);


    }).catchError((error) {
      print('$error');
      setState(() {
        txtProdName.text = "";
        txtProdAmount.text = "";
        txtOrderId.text = "";
        _isLoading = false;
        ref.read(ListProvider.notifier).txtGoalPriority.text = "";
      });
      Constants.showToast("Problem in adding Goal", ToastGravity.BOTTOM);
    });
  }

  String? _validateOrderedProdName(String? value) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return 'Please enter Ordered Product Name';
    }
    return null;
  }

  String? _validateOrderId(String? value) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return 'Please enter Order Id';
    }
    return null;
  }

  String? _validateOrderedProdAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Ordered Product Amount';
    }
    return null;
  }

  String? _validateShoppingPlatform(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Select Shopped Platform';
    }

    return null;
  }

  String? _validateShoppingDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Select Shopped Date';
    }

    return null;
  }
}
