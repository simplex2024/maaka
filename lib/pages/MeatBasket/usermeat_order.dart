import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maaakanmoney/components/NotificationService.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_util.dart';
import 'package:maaakanmoney/pages/User/ShopNow/shop_now.dart';
import 'package:maaakanmoney/pages/User/UserScreen_Notifer.dart';
import 'package:maaakanmoney/pages/budget_copy/ecommerce/ecommerce.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class UserMeatOrderScreen extends StatefulWidget {
  final String title;
  final String description;
  final String affiliateLink;
  final String amount;
  final String minBargainAmount;
  final String prodDetails;
  final String prodSpec;
  final List<dynamic> imageUrls;
  final String userName;
  final String getAdminType;
  final String getHeroTag;

  UserMeatOrderScreen(
      {required this.title,
        required this.description,
        required this.affiliateLink,
        required this.prodDetails,
        required this.prodSpec,
        required this.imageUrls,
        required this.amount,
        required this.minBargainAmount,
        required this.userName,
        required this.getAdminType,
        required this.getHeroTag});

  @override
  _UserMeatOrderScreenState createState() => _UserMeatOrderScreenState();
}

class _UserMeatOrderScreenState extends State<UserMeatOrderScreen> {
  int _currentPage = 0;

  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return Scaffold(
          backgroundColor: Constants.secondary,
          appBar: responsiveVisibility(
            context: context,
            tabletLandscape: false,
            desktop: false,
          )
              ? AppBar(
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
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 100.w,
                        margin: EdgeInsets.only(top: 100.h * 0.4),
                        padding: EdgeInsets.only(
                          top: 100.h * 0.07,
                          left: 0,
                          right: 0,
                        ),
                        // height: 500,
                        decoration: BoxDecoration(
                          color: Constants.secondary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [

                            Expanded(
                              flex: 9,
                              child: SingleChildScrollView(
                                child: Container(
                                  color: Constants.secondary,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [

                                      SizedBox(
                                        height: 10,
                                      ),
                                      widget.affiliateLink.isNotEmpty
                                          ? Container()
                                          : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text("Product Details",
                                                textAlign:
                                                TextAlign.start,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                    color: Constants
                                                        .primary,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold)),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  top: 20.0,
                                                  left: 8.0,
                                                  right: 8.0),
                                              child: Container(
                                                width: double.infinity,
                                                color:
                                                Constants.secondary,
                                                child: Text(
                                                  widget.prodDetails,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      color: Constants
                                                          .secondary3),
                                                  textAlign:
                                                  TextAlign.justify,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("Product Specification",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                    color: Constants
                                                        .primary,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold)),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  top: 20.0,
                                                  left: 8.0,
                                                  right: 8.0),
                                              child: Container(
                                                width: double.infinity,
                                                color:
                                                Constants.secondary,
                                                child: Text(
                                                  widget.prodSpec,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      color: Constants
                                                          .secondary3),
                                                  textAlign:
                                                  TextAlign.justify,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            widget.affiliateLink.isNotEmpty
                                ? Container(
                              height: 25.h,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 60.w,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          Constants.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                10.0), // Set the border radius here
                                          ), // Set the background color here
                                        ),
                                        onPressed: () async {
                                          if (widget
                                              .affiliateLink.isEmpty) {
                                            return;
                                          }
                                          _openWebView();
                                          String? token =
                                          await NotificationService
                                              .getDocumentIDsAndData();
                                          String? getUser =
                                              widget.userName;
                                          String? getTitle = widget.title;

                                          await NotificationService
                                              .postNotificationRequest(
                                              token ?? "",
                                              "Hi Admin,\n$getUser is showing interest.",
                                              "Interested on $getTitle\nIts Affiliate Product\nHurry up, Arrange immediate Assistance!");
                                        },
                                        child: Text('Get More Details ?',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                color: Constants
                                                    .secondary,
                                                overflow: TextOverflow
                                                    .ellipsis,
                                                fontWeight:
                                                FontWeight.bold)),
                                      ),
                                      height: 5.h,
                                    ),
                                  ],
                                ),
                              ),
                            )
                                : Container(
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        Constants.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ), // Set the border radius here
                                        ), // S// Set the background color here
                                      ),
                                      onPressed: () async {
                                        //todo:- 26.4.24 uncomment all code below

                                        //todo:- 2.6.24 when user shows interest in product, then should push notification to admin
                                        String? token =
                                        await NotificationService
                                            .getDocumentIDsAndData();

                                        String? getUserName =
                                            widget.userName ?? "";
                                        String? getTitle =
                                            widget.title ?? "";

                                        String? getAmount =
                                            widget.amount ?? "";
                                        String? getBargainingAmnt =
                                            widget.minBargainAmount ?? "";

                                        await NotificationService
                                            .postNotificationRequest(
                                            token ?? "",
                                            "Hi Admin,\n$getUserName Started Bargaining.",
                                            "Trying to Bargain on $getTitle Costs $getAmount\nWe set Minimum Bargain Price as $getBargainingAmnt");

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductBargainScreen(
                                                  title: widget.title,
                                                  description:
                                                  widget.description,
                                                  affiliateLink:
                                                  widget.affiliateLink,
                                                  prodDetails:
                                                  widget.prodDetails,
                                                  prodSpec: widget.prodSpec,
                                                  imageUrls: widget.imageUrls,
                                                  amount: widget.amount,
                                                  minBargainAmount:
                                                  widget.minBargainAmount,
                                                  userName: widget.userName,
                                                  getAdminType:
                                                  widget.getAdminType,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Text('Start Bargain ?',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                              color:
                                              Constants.secondary,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                              fontWeight:
                                              FontWeight.bold)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        Constants.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ), // Set the border radius here
                                        ), // Set the background color here
                                      ),
                                      onPressed: () async {
                                        //todo:- 26.4.24 uncomment all code below

                                        _openWhatsAppChat(widget.title,
                                            widget.getAdminType);

                                        //todo:- 2.6.24 when user shows interest in product, then should push notification to admin
                                        String? token =
                                        await NotificationService
                                            .getDocumentIDsAndData();

                                        String? getUserName =
                                            widget.userName ?? "";
                                        String? getTitle =
                                            widget.title ?? "";

                                        await NotificationService
                                            .postNotificationRequest(
                                            token ?? "",
                                            "Hi Admin,\n$getUserName is showing interest.",
                                            "Pressed Cofirm\nInterested on $getTitle\nInterested on your own listings\nHurry up, Arrange immediate Assistance!");
                                      },
                                      child: Text('Place Order ?',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                              color:
                                              Constants.secondary,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                              fontWeight:
                                              FontWeight.bold)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.description,
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(color: Constants.secondary3)),
                            Text(widget.title,
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(color: Constants.primary)),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Price\n",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                              color: Constants.primary)),
                                      TextSpan(
                                        text: ' ₹' + widget.amount,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                            color: Constants.secondary3),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 35.h,
                                        width: 60.w, // Adjust height as needed
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          // Rounded corners
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20), //
                                            topLeft: Radius.circular(20),
                                          ),
                                          child: Stack(
                                            children: [
                                              PageView.builder(
                                                itemCount:
                                                widget.imageUrls.length,
                                                onPageChanged: (int page) {
                                                  setState(() {
                                                    _currentPage = page;
                                                  });
                                                },
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              FullImageScreen(
                                                                imageUrl: widget
                                                                    .imageUrls[
                                                                index],
                                                                heroTag:
                                                                'image_$index',
                                                                affiliateLink: widget
                                                                    .affiliateLink,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    child: Hero(
                                                      tag: widget.getHeroTag,
                                                      child: Image.network(
                                                        widget.imageUrls[index],
                                                        fit: BoxFit.cover,
                                                        loadingBuilder:
                                                            (BuildContext
                                                        context,
                                                            Widget child,
                                                            ImageChunkEvent?
                                                            loadingProgress) {
                                                          if (loadingProgress ==
                                                              null) {
                                                            return child;
                                                          } else {
                                                            return Center(
                                                              child:
                                                              CircularProgressIndicator(
                                                                value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                    null
                                                                    ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                    loadingProgress
                                                                        .expectedTotalBytes!
                                                                    : null,
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              Positioned(
                                                bottom: 10,
                                                left: 0,
                                                right: 0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children:
                                                  List<Widget>.generate(
                                                    widget.imageUrls.length,
                                                        (int index) {
                                                      return Container(
                                                        width: 8,
                                                        height: 8,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                            horizontal: 4),
                                                        decoration:
                                                        BoxDecoration(
                                                          shape:
                                                          BoxShape.circle,
                                                          color: _currentPage ==
                                                              index
                                                              ? Colors.blue
                                                              : Colors.grey,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0, right: 0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                            Constants.secondary3,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ), // Set the border radius here
                                            ), // Set the background color here
                                          ),
                                          onPressed: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AffiliateListScreen(
                                                        userName: ref
                                                            .read(UserDashListProvider
                                                            .notifier)
                                                            .getUser ??
                                                            ""),
                                              ),
                                            ).then((value) {
                                              //todo:- below code refresh firebase records automatically when come back to same screen
                                              // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                                            });
                                          },
                                          child: Text('Shop More ?',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                  color:
                                                  Constants.secondary,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  fontWeight:
                                                  FontWeight.bold)),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openWebView() {
    _openAffiliateApp(widget.affiliateLink);
  }

  tapped(int step) {
    print(step);
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 1 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  Future<void> _onButtonTapped(
      String buttonType,
      int step,
      ) async {
    if (step == 1) {
      _openWhatsAppChat(widget.title, widget.getAdminType);

      //todo:- 2.6.24 when user shows interest in product, then should push notification to admin
      String? token = await NotificationService.getDocumentIDsAndData();

      String? getUserName = widget.userName ?? "";
      String? getTitle = widget.title ?? "";

      await NotificationService.postNotificationRequest(
          token ?? "",
          "Hi Admin,\n$getUserName is showing interest.",
          "Interested on $getTitle\nInterested on your own listings\nHurry up, Arrange immediate Assistance!");

      // showJourneyComDialog(
      // context,
      // TextEditingController(),widget.userName,widget.title);
    }
  }

  void _openWhatsAppChat(String? getProductName, String getAdminType) async {
    getAdminType == "1" ? Constants.admin1Gpay : Constants.admin2Gpay;

    final String phoneNumber = getAdminType == "1"
        ? Constants.admin1Gpay
        : Constants.admin2Gpay; // Replace with the desired phone number
    final String defaultMessage =
        'I saw your product $getProductName on the Maaka app and am interested. Could you provide more details about it?'; // Replace with your default message
    final String whatsappUrl =
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(defaultMessage)}";

    ///use following link to open group chat in whats app :- // https://chat.whatsapp.com/KrdGBPuTKal7btZVlj5dHE

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      String? token = await NotificationService.getDocumentIDsAndData();
      String? getUser = widget.userName;
      String? getTitle = widget.title;
      await NotificationService.postNotificationRequest(
          token ?? "",
          "Hi Admin,\n$getUser facing Issue 😖🙁🤯",
          "Interested on $getTitle\nTrying to open Whats App\nProblem in opening Whats App!");
      throw 'Could not launch $whatsappUrl';
    }
  }

  void _openAffiliateApp(String? getAffiliateLink) async {
    if (await canLaunch(getAffiliateLink ?? "")) {
      await launch(getAffiliateLink ?? "");
    } else {
      String? token = await NotificationService.getDocumentIDsAndData();
      String? getUser = widget.userName;
      String? getTitle = widget.title;
      await NotificationService.postNotificationRequest(
          token ?? "",
          "Hi Admin,\n$getUser facing Issue 😖🙁🤯",
          "Interested on $getTitle\nTrying to open Affiliate App\nProblem in opening Affiliate App!");
      throw 'Could not launch $getAffiliateLink';
    }
  }
}
