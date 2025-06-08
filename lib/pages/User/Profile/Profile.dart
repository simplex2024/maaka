import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../components/custom_dialog_box.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../Auth/mpin.dart';
import '../../Auth/phone_auth_widget.dart';
import '../UserScreen_Notifer.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String? userName;
  final String? cashBack;
  final String? netBalance;
  final String? userNomName;
  final String? userNomMob;
  final String? getTotalCredit;
  final String? getTotalDebit;
  final String? getTotalIntCredit;
  final String? getTotalIntDebit;
  final String? userAddress;
  String? loginKey;
  bool? isNomineeEditable = false;
  bool? isAddressEditable = false;

  ProfileScreen(
      {required this.userName,
      required this.cashBack,
      required this.netBalance,
      required this.userNomName,
      required this.userNomMob,
      required this.getTotalCredit,
      required this.getTotalDebit,
      required this.getTotalIntCredit,
      required this.getTotalIntDebit,
      required this.userAddress});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool isNomineeEditEnabled = false;
  CollectionReference? _collectionUsers;
  TextEditingController? txtNominName;
  TextEditingController? txtNominMob;
  TextEditingController? txtAddress;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txtNominName ??= TextEditingController();
    txtNominMob ??= TextEditingController();
    txtAddress ??= TextEditingController();

    txtNominName?.text = widget.userNomName ?? "";
    txtNominMob?.text = widget.userNomMob ?? "";
    txtAddress?.text = widget.userAddress ?? "";

    _collectionUsers = FirebaseFirestore.instance.collection('users');
  }

  @override
  Widget build(BuildContext context) {
    String? getUserName = widget.userName;

    return Scaffold(
      appBar: responsiveVisibility(
        context: context,
        tabletLandscape: false,
        desktop: false,
      )
          ? AppBar(
              title: Text(
                widget.userName ?? "",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Constants.secondary3,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold),
              ),
              backgroundColor: Constants.secondary,
              automaticallyImplyLeading: true,
              toolbarHeight: 8.h,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_rounded,
                    color: Colors.black),
              ),
              centerTitle: true,
              elevation: 0.0,
            )
          : null,
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInfoCard(
                        Icons.account_balance_wallet,
                        "Current Savings",
                        '₹ ' + (widget.netBalance ?? "0.0"),
                        context,
                        false,
                        CardType.normal),
                    _buildInfoCard(
                        Icons.person,
                        "Total Savings",
                        "maakanmoney@gmail.com",
                        context,
                        true,
                        CardType.TransDetails),
                    _buildInfoCard(
                        Icons.currency_rupee,
                        "Current Rewards",
                        '₹ ' + (widget.cashBack ?? "0.0"),
                        context,
                        false,
                        CardType.normal),
                    _buildInfoCard(
                        Icons.currency_rupee,
                        "Total Rewards",
                        '₹ ' + (widget.cashBack ?? "0.0"),
                        context,
                        false,
                        CardType.TransIntDetails),
                    _buildInfoCard(
                        Icons.phone,
                        "Customer Support Number",
                        Constants.adminNo1 + " / " + Constants.adminNo2,
                        context,
                        false,
                        CardType.normal),
                    _buildInfoCard(
                        Icons.email,
                        "Customer Support Email",
                        "maakanmoney@gmail.com",
                        context,
                        false,
                        CardType.normal),
                    _buildInfoCard(
                        Icons.person,
                        "Nominee Details",
                        "maakanmoney@gmail.com",
                        context,
                        true,
                        CardType.nominee),
                    _buildInfoCard(
                        Icons.location_on,
                        "Current Address",
                        "",
                        context,
                        false,
                        CardType.address),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 90.w,
                    height: 6.h,
                    child: FFButtonWidget(
                      onPressed: () async {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogBox(
                                title: "Hi $getUserName",
                                descriptions:
                                    "Are you sure, Do you want to logout",
                                text: "Ok",
                                isCancel: true,
                                onTap: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  widget.loginKey =
                                      prefs.getString("LoginSuccessuser1");

                                  if (widget.loginKey == null ||
                                      widget.loginKey == "" ||
                                      widget.loginKey!.isEmpty) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyPhone()),
                                      (route) =>
                                          false, // Remove all routes from the stack
                                    );
                                  } else {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    String? mPin = prefs.getString("Mpin");
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MpinPageWidget(
                                              getMobileNo:
                                                  widget.loginKey ?? "",
                                              getMpin: mPin)),
                                      (route) =>
                                          false, // Remove all routes from the stack
                                    );
                                  }
                                },
                              );
                            });
                      },
                      text: "Logout",
                      options: FFButtonOptions(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 0.0, 0.0),
                        iconPadding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: GlobalTextStyles.secondaryText2(
                            txtWeight: FontWeight.bold,
                            txtSize: 16,
                            textColor: FlutterFlowTheme.of(context).secondary),
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
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData iconData, String? title, String? value,
      BuildContext getContext, bool? isNomineeCard, CardType getCardType) {
    switch (getCardType) {
      case CardType.nominee:
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title ?? "",
                      style: GlobalTextStyles.secondaryText1(
                          textColor: Colors.grey, txtWeight: FontWeight.w500),
                    ),
                    InkWell(
                      child: Icon(
                        Icons.edit,
                        size: 30,
                        color: FlutterFlowTheme.of(getContext).primary,
                      ),
                      onTap: () {
                        setState(() {
                          widget.isNomineeEditable = true;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      maxLines: null,
                      autofocus: true,
                      controller: txtNominName,
                      maxLength: 20,
                      textAlign: TextAlign.start,
                      enabled: widget.isNomineeEditable,
                      style: TextStyle(
                          color: FlutterFlowTheme.of(getContext).primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          letterSpacing: 1),
                      decoration: const InputDecoration(
                        labelText: 'Enter Name',
                      ),
                      onChanged: (value) {
                        // setState(() {
                        //   amount = int.parse(value);
                        // });
                      },
                      keyboardType: TextInputType.text,
                    ),
                    TextFormField(
                      maxLines: null,
                      autofocus: true,
                      controller: txtNominMob,
                      textAlign: TextAlign.start,
                      maxLength: 10,
                      enabled: widget.isNomineeEditable,
                      style: TextStyle(
                          color: FlutterFlowTheme.of(getContext).primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          letterSpacing: 1),
                      decoration: const InputDecoration(
                        labelText: 'Enter Mobile',
                      ),
                      onChanged: (value) {},
                      keyboardType: TextInputType.number,
                    ),
                    Visibility(
                      visible: widget.isNomineeEditable ?? false,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 90.w,
                            height: 6.h,
                            child: FFButtonWidget(
                              onPressed: () async {
                                if (txtNominName!.text.isEmpty ||
                                    txtNominMob!.text.isEmpty) {
                                  Constants.showToast(
                                      "Nominee Name and Mobile number should not be Empty",
                                      ToastGravity.CENTER);
                                  return;
                                }

                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialogBox(
                                        title: "Hi ",
                                        descriptions:
                                            "Are you sure, Do you want to Update Details",
                                        text: "Ok",
                                        isCancel: true,
                                        onTap: () async {
                                          updateUserNominee(
                                              txtNominName?.text,
                                              txtNominMob?.text,
                                              ref
                                                      .read(UserDashListProvider
                                                          .notifier)
                                                      .getDocId ??
                                                  "");
                                          Navigator.pop(context);
                                        },
                                      );
                                    });
                              },
                              text: "Update",
                              options: FFButtonOptions(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: GlobalTextStyles.secondaryText2(
                                    txtWeight: FontWeight.bold,
                                    txtSize: 16,
                                    textColor:
                                        FlutterFlowTheme.of(context).secondary),
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
                  ],
                ),
              ],
            ),
          ),
        );
      case CardType.normal:
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  iconData,
                  size: 40,
                  color: FlutterFlowTheme.of(getContext).primary,
                ),
                SizedBox(height: 8),
                Text(
                  title ?? "",
                  style: GlobalTextStyles.secondaryText1(
                      textColor: Colors.grey, txtWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text(
                  value ?? "",
                  style: GlobalTextStyles.secondaryText2(
                      textColor: FlutterFlowTheme.of(getContext).primary,
                      txtWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        );
      case CardType.TransDetails:
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "",
                  style: GlobalTextStyles.secondaryText1(
                      textColor: Colors.grey, txtWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text(
                  "Total Credit" + " ₹" + widget.getTotalCredit!,
                  style: GlobalTextStyles.secondaryText2(
                      textColor: FlutterFlowTheme.of(getContext).primary,
                      txtWeight: FontWeight.normal),
                ),
                SizedBox(height: 8),
                Text(
                  "Total Debit" + " ₹" + widget.getTotalDebit!,
                  style: GlobalTextStyles.secondaryText2(
                      textColor: FlutterFlowTheme.of(getContext).primary,
                      txtWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        );
      case CardType.TransIntDetails:
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "",
                  style: GlobalTextStyles.secondaryText1(
                      textColor: Colors.grey, txtWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text(
                  "Total Credit" + " ₹" + widget.getTotalIntCredit!,
                  style: GlobalTextStyles.secondaryText2(
                      textColor: FlutterFlowTheme.of(getContext).primary,
                      txtWeight: FontWeight.normal),
                ),
                SizedBox(height: 8),
                Text(
                  "Total Debit" + " ₹" + widget.getTotalIntDebit!,
                  style: GlobalTextStyles.secondaryText2(
                      textColor: FlutterFlowTheme.of(getContext).primary,
                      txtWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        );
      case CardType.address:
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title ?? "",
                        style: GlobalTextStyles.secondaryText1(
                            textColor: Colors.grey, txtWeight: FontWeight.w500),
                      ),
                      InkWell(
                        child: Icon(
                          Icons.edit,
                          size: 30,
                          color: FlutterFlowTheme.of(getContext).primary,
                        ),
                        onTap: () {
                          setState(() {
                            widget.isAddressEditable = true;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 10.0, 20.0, 16.0),
                        child:    TextFormField(
                          controller: txtAddress,
                          enabled: widget.isAddressEditable,
                          decoration: InputDecoration(
                              labelText: 'fill user address'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter address';
                            }
                            return null;
                          },
                          maxLines: 8,
                        ),
                      ),
                      Visibility(
                        visible: widget.isAddressEditable ?? false,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 90.w,
                              height: 6.h,
                              child: FFButtonWidget(
                                onPressed: () async {
                                  if (txtAddress!.text.isEmpty ) {
                                    Constants.showToast(
                                        "Address should not be Empty",
                                        ToastGravity.CENTER);
                                    return;
                                  }

                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialogBox(
                                          title: "Hi ",
                                          descriptions:
                                          "Are you sure, Do you want to Update Address",
                                          text: "Ok",
                                          isCancel: true,
                                          onTap: () async {
                                            updateAddress(
                                                txtAddress?.text,
                                                ref
                                                    .read(UserDashListProvider
                                                    .notifier)
                                                    .getDocId ??
                                                    "");
                                            Navigator.pop(context);
                                          },
                                        );
                                      });
                                },
                                text: "Update Address",
                                options: FFButtonOptions(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding:
                                  const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: GlobalTextStyles.secondaryText2(
                                      txtWeight: FontWeight.bold,
                                      txtSize: 16,
                                      textColor:
                                      FlutterFlowTheme.of(context).secondary),
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
                    ],
                  ),
                ],
              ),
            ),
          );
    }

  }

  //todo:- 11.2.24 update new value to user nominee details
  Future<void> updateUserNominee(
    String? nomName,
    String? nomMobile,
    String? getDocId,
  ) async {
    try {
      QuerySnapshot snapshot = await _collectionUsers!.limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        await _collectionUsers!.doc(getDocId).update({
          'nominName': nomName,
          'nominMobile': nomMobile,
        }).then((value) async {
          Constants.showToast("Nominee Details Updated", ToastGravity.CENTER);
        });
      } else {
        // Handle the case where no document is found
        print('No document found to update');
      }
    } catch (e) {
      // Handle the error when updating the admin token
      print('Error updating admin token: $e');
      // You might want to throw an exception or handle the error in some way
    }
  }

  Future<void> updateAddress(
      String? address,
      String? getDocId,
      ) async {
    try {
      QuerySnapshot snapshot = await _collectionUsers!.limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        await _collectionUsers!.doc(getDocId).update({
          'address': address,
        }).then((value) async {
          Constants.showToast("Address Updated", ToastGravity.CENTER);
        });
      } else {
        // Handle the case where no document is found
        print('No document found to update');
      }
    } catch (e) {
      // Handle the error when updating the admin token
      print('Error updating admin token: $e');
      // You might want to throw an exception or handle the error in some way
    }
  }
}

enum CardType { normal, nominee, TransDetails, TransIntDetails,address }
