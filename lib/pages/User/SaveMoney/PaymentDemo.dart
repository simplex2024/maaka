import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;
import '../../../components/constants.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../phoneController.dart';
import '../UserScreen_Notifer.dart';

class PaymentDemo extends ConsumerStatefulWidget {
  PaymentDemo({
    Key? key,
    @required this.isGpaySelected,
    @required this.getMobile,
    @required this.getGoalDocId,
    @required this.getPaymentService,
  }) : super(key: key);
  bool? isGpaySelected;
  String? getMobile;
  String? getGoalDocId;
  PaymentService? getPaymentService;
  @override
  PaymentDemoState createState() => PaymentDemoState();
}

class PaymentDemoState extends ConsumerState<PaymentDemo>
    with TickerProviderStateMixin {
  AnimationController? controller;
  AssetImage? gifAsset;

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    String? getGif = widget.isGpaySelected! ? "GpayDemo" : "PhonepeDemo";

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {});

    gifAsset = AssetImage('images/final/Dashboard/$getGif.gif');

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    controller?.repeat();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      ref.read(UserDashListProvider.notifier).data =
          ref.watch(connectivityProvider);

      return Scaffold(
        backgroundColor:  widget.getPaymentService == PaymentService.meatBasket ? Constants.secondary4 : FlutterFlowTheme.of(context).primary,
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
                title: Text(
                  "",
                ),
                backgroundColor: widget.getPaymentService == PaymentService.meatBasket ? Constants.secondary4 : FlutterFlowTheme.of(context).primary,
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
        body: SafeArea(
            child: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(
                                  0), // Bottom-left corner is rounded
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "You're watching, Payment Demo",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Outfit',
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            letterSpacing: 0.5,
                                            fontSize: 18,
                                          ),
                                    ),
                                  ),
                                ),

                                // Add more Positioned widgets for additional images
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondary,
                      borderRadius: BorderRadius.only(
                        bottomLeft:
                            Radius.circular(0), // Bottom-left corner is rounded
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        color: Colors.transparent,
                        height: 100.h,
                        width: 90.w,
                        child: Image(
                          image: gifAsset!,
                          fit: BoxFit.fitHeight,
                          errorBuilder: (context, exception, stackTrace) {
                            return Image.asset(
                              "images/final/Common/Error.png",
                            );
                          },
                          gaplessPlayback:
                              true, // This ensures smooth transition when changing assets
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            // Listen for the end of the GIF and reset the controller to loop
                            if (controller!.isCompleted) {
                              controller!.reset();
                              controller!.forward();
                            }
                            return child;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Stack(alignment: Alignment.bottomLeft, children: [
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                              0), // Bottom-left corner is rounded
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 90.w,
                                  height: 6.h,
                                  child: IgnorePointer(
                                    ignoring: isOtpSent == true ? true : false,
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        if (widget.isGpaySelected ?? false) {
                                          final String defaultValue = ref
                                                      .read(UserDashListProvider
                                                          .notifier)
                                                      .getAdminType ==
                                                  "1"
                                              ? Constants.admin1Gpay
                                              : Constants.admin2Gpay;
                                          Clipboard.setData(ClipboardData(
                                              text: defaultValue));

                                          if  (widget.getPaymentService != PaymentService.meatBasket ){
                                            await addDummyTransaction(widget.getGoalDocId);
                                          }

                                          // await addDummyTransaction(widget.getGoalDocId);

                                          var openAppResult =
                                              await LaunchApp.openApp(
                                            openStore: true,
                                            androidPackageName:
                                                'com.google.android.apps.nbu.paisa.user',
                                            // iosUrlScheme: 'pulsesecure://',
                                            // appStoreLink:
                                            //     'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
                                            iosUrlScheme: 'hjfg',
                                            appStoreLink:
                                                'https://apps.apple.com/in/app/google-pay-save-pay-manage/id1193357041',
                                          );
                                        } else {
                                          final String defaultValue = ref
                                                      .read(UserDashListProvider
                                                          .notifier)
                                                      .getAdminType ==
                                                  "1"
                                              ? Constants.admin1Gpay
                                              : Constants.admin2Gpay;
                                          Clipboard.setData(ClipboardData(
                                              text: defaultValue));

                                          //todo:- 26.1.24 adding dummy entry when navigating to gpay

                                          if  (widget.getPaymentService != PaymentService.meatBasket ){
                                            await addDummyTransaction(widget.getGoalDocId);
                                          }
                                          // await addDummyTransaction(widget.getGoalDocId);

                                          var openAppResult =
                                              await LaunchApp.openApp(
                                            openStore: true,
                                            androidPackageName:
                                                'com.phonepe.app',
                                            iosUrlScheme: 'sf',
                                            appStoreLink:
                                                'https://apps.apple.com/in/app/phonepe-secure-payments-app/id1170055821',
                                          );
                                        }
                                      },
                                      text: "Pay Now",
                                      options: FFButtonOptions(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        iconPadding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        color:  widget.getPaymentService == PaymentService.meatBasket ? Constants.secondary4 : FlutterFlowTheme.of(context)
                                            .primary,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              fontFamily: 'Outfit',
                                              color: Colors.white,
                                              fontSize: 18,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                        elevation: 2.0,
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Add more Positioned widgets for additional images
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        )),
      );
    });
  }

  Future<void> addDummyTransaction(String? getGoalDocID) async {

    int amount = int.parse("0");

    try {
      // Simulating some asynchronous operation
      // await Future.delayed(Duration(seconds: 2));

      Timestamp timestamp = Timestamp.fromDate(DateTime.now());

      try {
        //todo:- adding transaction inside user's table
        fireStore
            .collection('users')
            .doc(ref.read(UserDashListProvider.notifier).getDocId)
            .collection('transaction')
            .add({
          'mobile': widget.getMobile,
          'isDeposit': true,
          'isCashbckDeposit': true,
          'amount': amount,
          'interest': 0.0,
          'date': DateFormat('yyyy-MM-dd')
              .format(DateTime.now()), // Only date in 'yyyy-MM-dd' format
          // 'timestamp': DateTime.now(),
          'timestamp': timestamp,
          'goalId': getGoalDocID,
        }).then((_) async {

          //todo:- 28.1.24 - when user tries to goes to payment method, in user details, pending payment flag is updated
          await updatePaymentPendingRequest(
            ref.read(UserDashListProvider.notifier).getDocId,
          );

          Constants.showToast(
              "Your Payment is under Processing", ToastGravity.BOTTOM);

        }).catchError((error) {
          print('$error');
        });
      } catch (error) {

        print('Error retrieving user details: $error');
      }
    } catch (error) {
      print(error);
    } finally {
      // setState(() {
      //   _isLoading = false;
      // });
    }

  }

  //todo:- 28.1.24 update new value about, pending payment in user details as ispending payment is true
  Future<void> updatePaymentPendingRequest(
      String? getDocId,
      ) async {
    String? documentId = getDocId;

    try {
      await fireStore.collection('users').doc(documentId).update({
        'isPendingPayment': true,
      }).then((value) {
        Constants.showToast("Pending Payment Request Updated Successfully",
            ToastGravity.CENTER);
      });
    } catch (error) {
      Constants.showToast(
          "Pending Payment Request Failed, Try again!", ToastGravity.CENTER);
    }
  }

  SliverPersistentHeader makeTitleHeader(
    String headerText,
  ) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 50.0,
        maxHeight: 70.0,
        child: Container(
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    headerText,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double? minHeight;
  final double? maxHeight;
  final Widget? child;

  @override
  double get minExtent => minHeight!;

  @override
  double get maxExtent => math.max(maxHeight!, minHeight!);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
