import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:maaakanmoney/components/custom_dialog_box.dart';
import 'package:maaakanmoney/pages/budget_copy/BudgetCopyController.dart';
import 'package:maaakanmoney/pages/budget_copy/budget_copy_widget.dart';
import 'package:maaakanmoney/phoneController.dart';
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ChangeArea extends ConsumerStatefulWidget {
  String? getDocID;
   ChangeArea({Key? key,  @required this.getDocID,}) : super(key: key);

  @override
  ChangeAreaState createState() => ChangeAreaState();
}

class ChangeAreaState extends ConsumerState<ChangeArea> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  ConnectivityResult? data;

  List<MeatBasketAreaList>? areaList = [];
  List<Tuple2<String?, String?>?> getAreaLists = [];
  Tuple2<String?, String?>? getMappedAreaSelection = Tuple2("", "");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void initState() {
    ref.read(ListProvider.notifier).txtMappedArea.text = "";
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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

            if(getAreaList.status == ResStatus.success){
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
                            getMappedAreaSelection = ref.watch(adminTypeProvider);

                            return Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20.0, 10.0, 20.0, 16.0),
                              child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(left: 10),
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
                                                              .fromARGB(
                                                              125,
                                                              1,
                                                              2,
                                                              2),
                                                        ),
                                                        border:
                                                        InputBorder
                                                            .none),
                                                    style: const TextStyle(
                                                        letterSpacing: 1),

                                                    // keyboardType:
                                                    //     TextInputType
                                                    //         .text,
                                                    validator:
                                                        (value){
                                                      if (value == null || value.isEmpty) {
                                                        Constants.showToast("Please map user Area", ToastGravity.BOTTOM);
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
                                                  BorderRadius.circular(
                                                      10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ]),
                            );
                          }),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0.0, 0.05),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 24.0, 0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: _submitForm,
                              text: "Update Area",
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

                      ],
                    ),
                  ),
                ),
                isLoading
                    == true
                    ? Container(
                  color: Colors.transparent,
                  child: Center(
                      child: CircularProgressIndicator(
                        color: isLoading == true
                            ? Colors.transparent
                            : FlutterFlowTheme
                            .of(context)
                            .primary,
                      )),
                ) : Container()

                ,
              ]),
            );
          }),
        ),
      ),
    );
  }

  Future<bool?> updateData(String? getDocId, String? getArea) async {
    String? documentId = getDocId;

    try {
      await fireStore.collection('users').doc(documentId).update({
        'area': getArea,
      }).then((value) {
        Constants.showToast(
            "New Area is Updated", ToastGravity.CENTER);
        return true;
      });
      return null; // Return null or a success message if desired
    } catch (error) {
      Constants.showToast("Request Failed, Try again!", ToastGravity.CENTER);
      return false; // Return the error message as a string
    }
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      if (data == ConnectivityResult.none) {
        Constants.showToast("No Internet Connection", ToastGravity.BOTTOM);
        return;
      }


      updateData(widget.getDocID, getMappedAreaSelection?.item1 ?? "");
    }
  }


}
