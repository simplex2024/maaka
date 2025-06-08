import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
import '../../../components/custom_dialog_box.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../phoneController.dart';
import '../../budget_copy/budget_copy_widget.dart';
import '../UserScreen_Notifer.dart';
import '../Userscreen_widget.dart';
import 'GoalHistoryNotifier1.dart';

class AddGoalWidget extends ConsumerStatefulWidget {
  AddGoalWidget({
    Key? key,
    required this.getDocId,
    required this.getMobile,
  }) : super(key: key);

  final String? getDocId;
  final String? getMobile;

  @override
  AddGoalWidgetState createState() => AddGoalWidgetState();
}

class AddGoalWidgetState extends ConsumerState<AddGoalWidget> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? getGoalTitle;
  int? getTargetValue;
  int? getPriorityValue;
  IconData? selectedIcon;
  String? selectedIconName;

  TextEditingController? txtGoalTitle;
  TextEditingController? txtphneName;
  TextEditingController? txtTargetValue;
  String? Function(BuildContext, String?)? cityController2Validator;

  // List<Tuple2<String?, String?>?> goalPriorityType = [];
  ConnectivityResult? data;
  Tuple2<String?, String?>? getGoalPriority = Tuple2("", "");
  bool _isLoading = false;

  /// Initialization and disposal methods.

  @override
  void initState() {
    txtGoalTitle ??= TextEditingController();
    txtTargetValue ??= TextEditingController();
    txtphneName ??= TextEditingController();
    selectedIcon = Icons.tour;
    selectedIconName = "tour";
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(ListProvider.notifier).txtGoalPriority?.text = "";
    });
    getNotificationAccessToken();
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
  void dispose() {
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
                backgroundColor: Constants.secondary,
                automaticallyImplyLeading: true,
                title: Text(
                  "Add Goals",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Constants.secondary3,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold)
                ),
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
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 25.0, 0.0, 16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary,
                                shape: BoxShape.circle,
                              ),
                              child: this.selectedIcon != null
                                  ? Icon(this.selectedIcon,
                                      size: 36.0, color: Colors.blue)
                                  : Center(
                                      child: Text(
                                      "Choose Icon",
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Constants.secondary),
                                      textAlign: TextAlign.center,
                                    )),
                            ),
                            onTap: () {
                              _showIconSelectionBottomSheet();
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 10.0),
                      child: Text(
                        "New Goal",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Constants.primary),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 10.0, 20.0, 16.0),
                      child: TextFormField(
                        controller: txtGoalTitle,
                        textCapitalization: TextCapitalization.words,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: "Goal Title",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                        style: GlobalTextStyles.secondaryText2(),
                        // validator:
                        //     _model.cityController1Validator.asValidator(context),
                        maxLength: 20,
                        validator: _validateGoalTitle,
                        // onSaved: (value) => getGoalTitle = value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 10.0, 20.0, 16.0),
                      child: TextFormField(
                        controller: txtTargetValue,
                        textCapitalization: TextCapitalization.words,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: "Target Value",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                        maxLength: 6,
                        style: GlobalTextStyles.secondaryText2(),
                        keyboardType: TextInputType.number,
                        // validator:
                        //     _model.cityController2Validator.asValidator(context),
                        validator: _validateTargetValue,
                        // onSaved: (value) => getTargetValue = value,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        bool? priority1 = false;
                        bool? priority2 = false;
                        bool? priority3 = false;

                        Tuple2<List<Goal>, String> getGoalDetails =
                            await updateGoalProvider();

                        List<Tuple2<String?, String?>?> goalPriorityType = [];
                        List<Tuple2<String?, String?>?> toCompareGoalPriority =
                            [
                          Tuple2("First Priority", "1"),
                          Tuple2("Second Priority", "2"),
                          Tuple2("Third Priority", "3"),
                        ];

                        for (Goal goal in getGoalDetails.item1) {
                          int? priority = goal.priorityPercentage;

                          if (priority == null) {
                            print(
                                '${goal.name}: Priority percentage is not present.');
                          } else {
                            switch (priority) {
                              case 1:
                                priority1 = true;
                                break;
                              case 2:
                                priority2 = true;
                                break;
                              case 3:
                                priority3 = true;
                                break;
                              default:
                                print(
                                    '${goal.name}: Invalid priority percentage value: $priority');
                            }
                          }
                        }

                        if (priority1 == true) {
                          goalPriorityType.add(Tuple2("First Priority", "1"));
                        }

                        if (priority2 == true) {
                          goalPriorityType.add(Tuple2("Second Priority", "2"));
                        }

                        if (priority3 == true) {
                          goalPriorityType.add(Tuple2("Third Priority", "3"));
                        }

                        List<Tuple2<String?, String?>?> difference =
                            toCompareGoalPriority
                                .where(
                                    (item) => !goalPriorityType.contains(item))
                                .toList();

                        ref.read(ListProvider.notifier).getData = difference;
                        ref.read(ListProvider.notifier).getSelectionType =
                            SelectionType.goalPriorityType;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListViewBuilder(
                                      getListHeading: "Set Goal Priority",
                                      getIndex: null,
                                    )));
                      },
                      child: Consumer(builder: (context, ref, child) {
                        getGoalPriority = ref.watch(adminTypeProvider);

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
                                labelText: "Goal Priority",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                                suffixIcon: Icon(
                                  Icons.navigate_next,
                                  color: Color.fromARGB(125, 1, 2, 2),
                                ),
                              ),
                              style: GlobalTextStyles.secondaryText2(),
                              validator: _validateGoalPriority,
                            ),
                          ),
                        );
                      }),
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
                                    text: "Set Goal",
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
                                      textStyle:
                                      Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                        "Dream Big | Set Goal | Take Action",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Constants.primary,fontWeight: FontWeight.bold),
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

  //todo:- 4.1.24 ,showing bottom sheet
  Future<void> _showIconSelectionBottomSheet() async {
    // IconData? selectedIcon

    List<Object> getIconData = await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.0), // Adjust the radius as needed
          topRight: Radius.circular(50.0), // Adjust the radius as needed
        ),
      ),
      builder: (BuildContext context) {
        return IconSelectionBottomSheet();
      },
    );

    // Now, you need to handle the received data appropriately.
    if (getIconData != null && getIconData.length == 2) {
      selectedIcon = getIconData[0] as IconData;
      selectedIconName = getIconData[1] as String;
    }

    if (selectedIcon != null) {
      // Update the selected icon in the main page
      setState(() {
        this.selectedIcon = selectedIcon;
      });
    }
  }

  Future<Tuple2<List<Goal>, String>> updateGoalProvider() async {
    var goalDetails = await ref
        .read(UserDashListProvider.notifier)
        .updateGoalDetails(
            ref.read(UserDashListProvider.notifier).goalDocuments,
            ref.read(UserDashListProvider.notifier).iconOptions);

    return goalDetails;
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
        print(txtGoalTitle.text);
        print(txtTargetValue.text);
        print(getGoalPriority?.item2);

        if (selectedIconName == null) {
          Constants.showToast("Select Goal Icon", ToastGravity.CENTER);
          return;
        }

        getGoalTitle = txtGoalTitle.text;
        getTargetValue = int.parse(txtTargetValue!.text);
        getPriorityValue = int.parse(getGoalPriority!.item2 ?? "");

        _addGoals(txtGoalTitle.text, getTargetValue, getPriorityValue, false,
            selectedIconName);
      }
    }
  }

  void _addGoals(String? goalTitle, int? goalTarget, int? goalPriority,
      bool? goalToDelete, String? goalIcon) {
    setState(() {
      _isLoading = true;
    });

    fireStore.collection('users').doc(widget.getDocId).collection('goals').add({
      'goalTitle': goalTitle,
      'goalTarget': goalTarget,
      'goalPriority': goalPriority,
      'goalToDelete': goalToDelete,
      'goalIcon': goalIcon,
    }).then((_) async {
      setState(() {
        txtGoalTitle.text = "";
        txtTargetValue.text = "";
        _isLoading = false;
        ref.read(ListProvider.notifier).txtGoalPriority.text = "";
      });

      Constants.showToast("Goal Added Successfully", ToastGravity.BOTTOM);

      //todo:- 2.12.23 adding notification on adding goals
      String? token = await NotificationService.getDocumentIDsAndData();
      if (token != null) {
        Response? response = await NotificationService.postNotificationRequest(
            token,
            "Hi Admin,\n${ref.read(UserDashListProvider.notifier).getUser}  Added New Goal",
            "Goal Title - $goalTitle,\nGoal Target - $goalTarget,\nHurry up, let's Check with Admin App.");
        // Handle the response as needed
      } else {
        print("Problem in getting Token");
      }

      // Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BudgetWidget1(
            getMobile: widget.getMobile,
            getDocId: widget.getDocId,
          ),
        ),
      );
    }).catchError((error) {
      print('$error');
      setState(() {
        txtGoalTitle.text = "";
        txtTargetValue.text = "";
        _isLoading = false;
        ref.read(ListProvider.notifier).txtGoalPriority.text = "";
      });
      Constants.showToast("Problem in adding Goal", ToastGravity.BOTTOM);
    });
  }

  String? _validateGoalTitle(String? value) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return 'Please enter a goal title';
    }
    return null;
  }

  String? _validateTargetValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a target value';
    }
    return null;
  }

  String? _validateGoalPriority(String? value) {
    if (value == null || value.isEmpty) {
      Constants.showToast(
          "Please set priority for your Goal", ToastGravity.CENTER);
      return 'Please set priority for your Goal';
    }

    return null;
  }
}

class IconSelectionBottomSheet extends StatefulWidget {
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

  @override
  _IconSelectionBottomSheetState createState() =>
      _IconSelectionBottomSheetState();
}

class _IconSelectionBottomSheetState extends State<IconSelectionBottomSheet> {
  late List<Tuple3<IconData, String, String>> filteredIcons;

  @override
  void initState() {
    filteredIcons = widget.iconOptions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (query) {
              // Filter icons based on user input
              setState(() {
                filteredIcons = widget.iconOptions
                    .where((icon) => icon.item2
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .toList();

                if (filteredIcons.isEmpty) {
                  filteredIcons = widget.iconOptions;
                }
              });
            },
            decoration: InputDecoration(
              labelText: 'Search Icons',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: filteredIcons.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  // Return the selected icon to the main page
                  // Navigator.of(context).pop(filteredIcons[index].item1,filteredIcons[index].item1);

                  Navigator.of(context).pop(
                      [filteredIcons[index].item1, filteredIcons[index].item3]);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CircleAvatar(
                    backgroundColor: generateRandomDarkColor(),
                    // Set your desired background color
                    radius: 10.0,
                    // Adjust the radius as needed
                    child: Icon(
                      filteredIcons[index].item1,
                      size: 20.0,
                      color: Colors.white, // Set your desired icon color
                    ),
                  ),
                ),
                // Icon(filteredIcons[index].item1, size: 36.0,color: generateRandomDarkColor(),),
              );
            },
          ),
        ),
      ],
    );
  }

  Color generateRandomDarkColor() {
    Random random = Random();

    // Generate random values for RGB components in the range 0-127
    int red = random.nextInt(128);
    int green = random.nextInt(128);
    int blue = random.nextInt(128);

    // Combine the values to create a dark color
    Color darkColor = Color.fromARGB(255, red, green, blue);

    return darkColor;
  }
}
