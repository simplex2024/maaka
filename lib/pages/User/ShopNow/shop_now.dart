import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';
import 'package:maaakanmoney/pages/User/ShopNow/shop_now_model.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/NotificationService.dart';
import '../../../components/constants.dart';
import '../../../components/reusable_code.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';

class AffiliateListScreen extends ConsumerStatefulWidget {
  final String userName;

  AffiliateListScreen({Key? key, required this.userName}) : super(key: key);

  @override
  AffiliateListScreenState createState() => AffiliateListScreenState();
}

class AffiliateListScreenState extends ConsumerState<AffiliateListScreen>
    with TickerProviderStateMixin {

  final SingletonReusableCode _singleton = SingletonReusableCode();

  final ValueNotifier<bool> _isTappingAffiliateApp = ValueNotifier<bool>(false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondary,
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
                title: Text(
                  "Happy Shopping",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Constants.secondary3,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold

                  ),
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
        body: SafeArea(
            child: IgnorePointer(
              ignoring: _isTappingAffiliateApp.value,
              child: Stack(
                children: [GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of items per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 2, // Width / Height ratio
                          ),
                          padding: EdgeInsets.all(10),
                          itemCount: _singleton.shopNowItems.length,
                          itemBuilder: (context, index) {
                return GestureDetector(
                  child: GridItemWidget(item: _singleton.shopNowItems[index],showRandomColor: true,),
                  onTap: () async {
                    _isTappingAffiliateApp.value = true;
                    String? getApp;
                    getApp = _singleton.shopNowItems[index].title;
                    String getUser;
                    getUser = widget.userName ?? "";

                    String? token =
                        await NotificationService.getDocumentIDsAndData();

                    if (await canLaunch(_singleton.shopNowItems[index].affiliateLink ?? "")) {
                      await NotificationService.postNotificationRequest(
                          token ?? "",
                          "Hi Admin,\n$getUser Started Shopping 😍😍😍",
                          "Interested on Shopping\nIts Affiliate Shopping\nStarted Shopping using $getApp!");
                      _isTappingAffiliateApp.value = false;
                      await launch(_singleton.shopNowItems[index].affiliateLink ?? "");
                    } else {
                      Constants.showToast(
                          "Try Again After SomeTimes", ToastGravity.BOTTOM);
                      _isTappingAffiliateApp.value = false;
                      await NotificationService.postNotificationRequest(
                          token ?? "",
                          "Hi Admin,\n$getUser facing Issue 😖🙁🤯",
                          "Trying for Shopping\nProblem in opening $getApp Affiliate App!");

                      throw 'Could not launch $getApp';
                    }
                  },
                );
                          },
                        ),  ValueListenableBuilder<bool>(
                  valueListenable: _isTappingAffiliateApp,
                  builder: (context, isCreating, child) {
                    if (isCreating) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),]
              ),
            )),
      ),
    );
  }

  void _openAffiliateApp(
      String? getAffiliateLink, AffiliateAppType getAppType) async {
    String? getApp;

    switch (getAppType) {
      case AffiliateAppType.amazon:
        getApp = "Amazon";
        break;
      case AffiliateAppType.flipkart:
        getApp = "Flipkart";
        break;
      case AffiliateAppType.myntra:
        getApp = "Myntra";
        break;
      case AffiliateAppType.ajio:
        getApp = "Ajio";
        break;
      case AffiliateAppType.meesho:
        getApp = "Meesho";
        break;
      default:
        getApp = "xxx";
    }

    if (await canLaunch(getAffiliateLink ?? "")) {
      await launch(getAffiliateLink ?? "");
    } else {
      Constants.showToast("Try Again After SomeTimes", ToastGravity.BOTTOM);
      String? token = await NotificationService.getDocumentIDsAndData();
      await NotificationService.postNotificationRequest(
          token ?? "",
          "Hi Admin,\nSome User facing Issue 😖🙁🤯",
          "Trying to open $getApp Affiliate App\nProblem in opening $getApp Affiliate App!");
      throw 'Could not launch $getAffiliateLink';
    }
  }
}



class GridItemWidget extends StatelessWidget {
  final GridItem item;
  final bool showRandomColor;

  GridItemWidget({required this.item,required this.showRandomColor});

  final SingletonReusableCode _singleton = SingletonReusableCode();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade400,
            Constants.secondary2,
            Colors.blue.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(
            Radius.circular(10.0) //         <--- border radius here
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: ClipOval(
                // borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                child: Image.asset(
                  item.imagePath,
                  opacity: const AlwaysStoppedAnimation(.9),
                  fit: BoxFit.fill,
                  width: 50.0,
                  height: 50.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              item.title,
              style:


              Theme.of(context).textTheme.titleMedium?.copyWith(color: Constants.secondary,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),

              // GlobalTextStyles.secondaryText2(
              //   textColor: Constants.secondary3,
              //   txtWeight: FontWeight.bold,
              //   txtOverflow: TextOverflow.ellipsis,
              // ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
