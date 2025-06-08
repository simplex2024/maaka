import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maaakanmoney/pages/User/navigation_drawer/foodAdminsFoods/food_admins_foods.dart';
import 'package:maaakanmoney/pages/User/navigation_drawer/order_food/create_foodOrder.dart';
import 'package:maaakanmoney/pages/budget_copy/ecommerce/product_detail_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../components/ListView/ListController.dart';
import '../../../components/ListView/ListPageView.dart';
import '../../../components/NotificationService.dart';
import '../../../components/constants.dart';
import '../../../components/reusable_code.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../Auth/phone_auth_widget.dart';
import '../../User/ShopNow/shop_now.dart';
import '../../User/UserScreen_Notifer.dart';
import '../BudgetCopyController.dart';
import '../budget_copy_widget.dart';


//todo:- shows all products in server
class ProductListScreen extends ConsumerStatefulWidget {
  final String userName;

  ProductListScreen({Key? key, required this.userName}) : super(key: key);

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends ConsumerState<ProductListScreen>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<bool> _isDeleting = ValueNotifier<bool>(false);
  final SingletonReusableCode _singleton = SingletonReusableCode();

  final List<String> _categories = [
    'Men',
    'Women',
    'Kids',
    'Home Appliances',
    'Others'
  ];
  final Map<String, String> _categoryMapping = {
    '1': 'Men',
    '2': 'Women',
    '3': 'Kids',
    '4': 'Home Appliances',
    '0': 'Others',
  };

  List<ProductList>? getProductList = [];

  @override
  void initState() {
    // TODO: implement initState

    getProductList = ref.read(adminDashListProvider.notifier).productList;

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
        backgroundColor: Constants.secondary,
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
                title: Text(
                  "Best Deals",
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
        body: SafeArea(
          child: Stack(children: [
            // ListView.builder(
            //   itemCount: _categories.length,
            //   itemBuilder: (context, index) {
            //     String category = _categories[index];
            //     return Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.only(left: 8.0),
            //           child: Text(
            //             category,
            //             style: GlobalTextStyles.primaryText2()
            //           ),
            //         ),
            //         Container(
            //           margin: EdgeInsets.all(10.0),
            //           decoration: BoxDecoration(
            //
            //             borderRadius: BorderRadius.circular(10.0),
            //           ),
            //           child:
            //
            //
            //
            //
            //
            //           StreamBuilder(
            //             stream: FirebaseFirestore.instance
            //                 .collection('banners')
            //                 .where('productCategory',
            //                     isEqualTo: _categoryMapping.entries
            //                         .firstWhere(
            //                             (element) => element.value == category)
            //                         .key)
            //                 .snapshots(),
            //             builder:
            //                 (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //               if (!snapshot.hasData) {
            //                 return Center(child: CircularProgressIndicator());
            //               }
            //               List<DocumentSnapshot> docs = snapshot.data!.docs;
            //
            //               // if (docs.isEmpty) {
            //               //   return Padding(
            //               //     padding: const EdgeInsets.all(8.0),
            //               //     child: Text('No images found.'),
            //               //   );
            //               // }
            //
            //               return docs.isEmpty ? Container() : GridView.builder(
            //                 shrinkWrap: true,
            //                 physics: NeverScrollableScrollPhysics(),
            //                 padding: const EdgeInsets.all(8.0),
            //                 gridDelegate:
            //                     SliverGridDelegateWithFixedCrossAxisCount(
            //                   crossAxisCount: 2,
            //                   crossAxisSpacing: 8.0,
            //                   mainAxisSpacing: 8.0,
            //                   childAspectRatio: 0.7,
            //                 ),
            //                 itemCount: docs.length,
            //                 itemBuilder: (context, index) {
            //                   var doc = docs[index];
            //                   List<dynamic> imageUrls =
            //                       (doc.data() as Map<String, dynamic>?)
            //                                   ?.containsKey('fileUrls') ??
            //                               false
            //                           ? doc['fileUrls']
            //                           : [];
            //
            //                   String getTitle =
            //                       (doc.data() as Map<String, dynamic>?)
            //                                   ?.containsKey('title') ??
            //                               false
            //                           ? doc['title']
            //                           : "";
            //
            //                   String getDescription =
            //                       (doc.data() as Map<String, dynamic>?)
            //                                   ?.containsKey('description') ??
            //                               false
            //                           ? doc['description']
            //                           : "";
            //
            //                   String getAmount =
            //                       (doc.data() as Map<String, dynamic>?)
            //                                   ?.containsKey('amount') ??
            //                               false
            //                           ? doc['amount']
            //                           : "";
            //                   String getBargainAmount = (doc.data()
            //                                   as Map<String, dynamic>?)
            //                               ?.containsKey('minBargainAmount') ??
            //                           false
            //                       ? doc['minBargainAmount']
            //                       : "";
            //
            //                   String getProdDetails =
            //                       (doc.data() as Map<String, dynamic>?)
            //                                   ?.containsKey('productDetails') ??
            //                               false
            //                           ? doc['productDetails']
            //                           : "";
            //
            //                   String getProdSpec =
            //                       (doc.data() as Map<String, dynamic>?)
            //                                   ?.containsKey('productSpec') ??
            //                               false
            //                           ? doc['productSpec']
            //                           : "";
            //
            //                   String getAffiliate =
            //                       (doc.data() as Map<String, dynamic>?)
            //                                   ?.containsKey('affiliateLink') ??
            //                               false
            //                           ? doc['affiliateLink']
            //                           : "";
            //
            //                   return GridTile(
            //                     child: GestureDetector(
            //                       onTap: () {
            //                         Navigator.push(
            //                           context,
            //                           MaterialPageRoute(
            //                             builder: (context) =>
            //                                 ProductDetailScreen(
            //                               title: getTitle,
            //                               description: getDescription,
            //                               affiliateLink: getAffiliate,
            //                               prodDetails: getProdDetails,
            //                               prodSpec: getProdSpec,
            //                               imageUrls: imageUrls,
            //                               amount: getAmount,
            //                               userName: widget.userName,
            //                               getAdminType: ref
            //                                       .read(UserDashListProvider
            //                                           .notifier)
            //                                       .getAdminType ??
            //                                   "",
            //                               minBargainAmount: getBargainAmount,
            //                               getHeroTag: 'imageHero$index',
            //                             ),
            //                           ),
            //                         );
            //                       },
            //                       child: Container(
            //                         decoration: BoxDecoration(
            //                           color: _singleton.lighten(
            //                               Constants.secondary2,
            //                               amount: _singleton
            //                                   .generateRandomColorDouble()),
            //                           borderRadius: BorderRadius.circular(15.0),
            //                         ),
            //                         alignment: Alignment.center,
            //                         child: Column(
            //                           mainAxisAlignment:
            //                               MainAxisAlignment.spaceEvenly,
            //                           crossAxisAlignment:
            //                               CrossAxisAlignment.start,
            //                           children: [
            //                             Expanded(
            //                               child: Container(
            //                                 child: ClipRRect(
            //                                   borderRadius: BorderRadius.only(
            //                                     topLeft: Radius.circular(15),
            //                                     topRight: Radius.circular(15),
            //                                   ),
            //                                   child: imageUrls.isNotEmpty
            //                                       ? Hero(
            //                                           tag: 'imageHero$index',
            //                                           child: Image.network(
            //                                             imageUrls[0],
            //                                             fit: BoxFit.cover,
            //                                             loadingBuilder:
            //                                                 (BuildContext
            //                                                         context,
            //                                                     Widget child,
            //                                                     ImageChunkEvent?
            //                                                         loadingProgress) {
            //                                               if (loadingProgress ==
            //                                                   null) {
            //                                                 return child;
            //                                               } else {
            //                                                 return Center(
            //                                                   child:
            //                                                       CircularProgressIndicator(
            //                                                     value: loadingProgress
            //                                                                 .expectedTotalBytes !=
            //                                                             null
            //                                                         ? loadingProgress
            //                                                                 .cumulativeBytesLoaded /
            //                                                             loadingProgress
            //                                                                 .expectedTotalBytes!
            //                                                         : null,
            //                                                   ),
            //                                                 );
            //                                               }
            //                                             },
            //                                           ),
            //                                         )
            //                                       : Container(
            //                                           color: Colors.grey),
            //                                 ),
            //                                 width: 200,
            //                               ),
            //                             ),
            //                             Padding(
            //                               padding: const EdgeInsets.only(
            //                                   top: 5.0, left: 5.0),
            //                               child: Text(
            //                                 doc['title'],
            //                                 style:
            //                                     GlobalTextStyles.secondaryText1(
            //                                   txtSize: 13,
            //                                   textColor:
            //                                       FlutterFlowTheme.of(context)
            //                                           .primaryBackground,
            //                                   txtWeight: FontWeight.bold,
            //                                   txtOverflow:
            //                                       TextOverflow.ellipsis,
            //                                 ),
            //                               ),
            //                             ),
            //                             Padding(
            //                               padding: const EdgeInsets.only(
            //                                   top: 2.0, left: 5.0),
            //                               child: Text(
            //                                 "Rs. " + doc['amount'],
            //                                 style:
            //                                     GlobalTextStyles.secondaryText2(
            //                                   txtSize: 11,
            //                                   textColor:
            //                                       FlutterFlowTheme.of(context)
            //                                           .primary,
            //                                   txtWeight: FontWeight.bold,
            //                                   txtOverflow:
            //                                       TextOverflow.ellipsis,
            //                                 ),
            //                               ),
            //                             ),
            //                             Padding(
            //                               padding:
            //                                   const EdgeInsets.only(top: 8.0),
            //                               child: Visibility(
            //                                 child: Row(
            //                                   children: [
            //                                     IconButton(
            //                                       icon: Icon(
            //                                         Icons.delete,
            //                                         color: Constants.secondary3,
            //                                       ),
            //                                       onPressed: () {
            //                                         _singleton.showAlertDialog(
            //                                           context: context,
            //                                           title: "Are you sure?",
            //                                           message:
            //                                               "Do you want to delete this Product?",
            //                                           onCancelPressed: () {},
            //                                           onOkPressed: () {
            //                                             _deleteTicket(
            //                                                 doc.id, imageUrls);
            //                                           },
            //                                         );
            //                                       },
            //                                     ),
            //                                     IconButton(
            //                                       onPressed: () async {
            //                                         _singleton.showAlertDialog(
            //                                           context: context,
            //                                           title: "Are you sure?",
            //                                           message:
            //                                               "Do you want to Post Notification for this Product?",
            //                                           onCancelPressed: () {},
            //                                           onOkPressed: () async {
            //                                             Response? getResult =
            //                                                 await NotificationService
            //                                                     .postNotificationWithImage(
            //                                               "Get $getTitle for Rs.$getAmount ✨",
            //                                               "Try bargaining for the best prices on your favorite products 🪑💰🔦🛵⚽️",
            //                                               imageUrls[0] ?? null,
            //                                             );
            //
            //                                             getResult?.statusCode ==
            //                                                     200
            //                                                 ? Constants.showToast(
            //                                                     "Posted Notification to Maaka Users",
            //                                                     ToastGravity
            //                                                         .BOTTOM)
            //                                                 : Constants.showToast(
            //                                                     "Problem in sending Notification!",
            //                                                     ToastGravity
            //                                                         .BOTTOM);
            //                                           },
            //                                         );
            //                                       },
            //                                       icon: Icon(
            //                                         Icons.notification_add,
            //                                         color: Constants.secondary3,
            //                                       ),
            //                                     ),
            //                                   ],
            //                                 ),
            //                                 visible: Constants.isAdmin,
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   );
            //                 },
            //               );
            //             },
            //           ),
            //         ),
            //       ],
            //     );
            //   },
            // ),

            ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                String category = _categories[index];
                String categoryId = _categoryMapping.entries
                    .firstWhere((element) => element.value == category)
                    .key;

                List<ProductList>? categoryProducts = getProductList
                    ?.where((product) => product.productCategory == categoryId)
                    .toList();

                if (categoryProducts == null) {
                  return Container();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    categoryProducts.isEmpty
                        ? Container()
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  category,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          color: Constants.primary,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(8.0),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                  childAspectRatio: 0.7,
                                ),
                                itemCount: categoryProducts.length,
                                itemBuilder: (context, index) {
                                  ProductList? product =
                                      categoryProducts[index];

                                  String? getAmount = product.amount ?? "";
                                  String? getTitle = product.title ?? "";
                                  String? getDocId = product.docID ?? "";

                                  return GridTile(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailScreen(
                                              title: getTitle,
                                              description:
                                                  product.description ?? "",
                                              affiliateLink:
                                                  product.affiliateLink ?? "",
                                              prodDetails:
                                                  product.productDetails ?? "",
                                              prodSpec:
                                                  product.productSpec ?? "",
                                              imageUrls: product.fileUrls ?? [],
                                              amount: getAmount,
                                              userName: widget.userName,
                                              getAdminType: ref
                                                      .read(UserDashListProvider
                                                          .notifier)
                                                      .getAdminType ??
                                                  "",
                                              minBargainAmount:
                                                  product.minBargainAmount ??
                                                      "",
                                              getHeroTag:
                                                  'imageHero$index$getTitle$getAmount',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: _singleton.lighten(
                                              Constants.secondary2,
                                              amount: _singleton
                                                  .generateRandomColorDouble()),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15),
                                                  ),
                                                  child: product
                                                          .fileUrls.isNotEmpty
                                                      ? Hero(
                                                          tag:
                                                              'imageHero$index$getTitle$getAmount',
                                                          child: Image.network(
                                                            product.fileUrls[0],
                                                            fit: BoxFit.cover,
                                                            loadingBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child,
                                                                    ImageChunkEvent?
                                                                        loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child;
                                                              } else {
                                                                return Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    value: loadingProgress.expectedTotalBytes !=
                                                                            null
                                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                                            loadingProgress.expectedTotalBytes!
                                                                        : null,
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        )
                                                      : Container(
                                                          color: Colors.grey),
                                                ),
                                                width: 200,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0, left: 5.0),
                                              child: Text(
                                                product.title ?? "",
                                                style:

                                  Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),

                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, left: 5.0),
                                              child: Text(
                                                "Rs. " + getAmount,
                                                style:  Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Visibility(
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: Constants
                                                            .secondary3,
                                                      ),
                                                      onPressed: () {
                                                        _singleton
                                                            .showAlertDialog(
                                                          context: context,
                                                          title:
                                                              "Are you sure?",
                                                          message:
                                                              "Do you want to delete this Product?",
                                                          onCancelPressed:
                                                              () {},
                                                          onOkPressed: () {
                                                            _deleteTicket(
                                                                getDocId,
                                                                product
                                                                    .fileUrls);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                    IconButton(
                                                      onPressed: () async {
                                                        _singleton
                                                            .showAlertDialog(
                                                          context: context,
                                                          title:
                                                              "Are you sure?",
                                                          message:
                                                              "Do you want to Post Notification for this Product?",
                                                          onCancelPressed:
                                                              () {},
                                                          onOkPressed:
                                                              () async {
                                                            Response?
                                                                getResult =
                                                                await NotificationService
                                                                    .postNotificationWithImage(
                                                              "Get $getTitle for Rs.$getAmount ✨",
                                                              "Try bargaining for the best prices on your favorite products 🪑💰🔦🛵⚽️",
                                                              product.fileUrls[
                                                                      0] ??
                                                                  null,
                                                            );

                                                            getResult?.statusCode ==
                                                                    200
                                                                ? Constants.showToast(
                                                                    "Posted Notification to Maaka Users",
                                                                    ToastGravity
                                                                        .BOTTOM)
                                                                : Constants.showToast(
                                                                    "Problem in sending Notification!",
                                                                    ToastGravity
                                                                        .BOTTOM);
                                                          },
                                                        );
                                                      },
                                                      icon: Icon(
                                                        Icons.notification_add,
                                                        color: Constants
                                                            .secondary3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                visible: Constants.isAdmin,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                  ],
                );
              },
            )
          ]),
        ),
      ),
      // floatingActionButton: Visibility(
      //   visible: Constants.isAdmin,
      //   child: FloatingActionButton(
      //     backgroundColor: FlutterFlowTheme.of(context).primary,
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => CreateNewProductScreen(),
      //         ),
      //       );
      //     },
      //     child: Icon(
      //       Icons.add,
      //       color: FlutterFlowTheme.of(context).secondary,
      //     ),
      //   ),
      // ),
    );
  }

  Future<void> _deleteTicket(String docId, List<dynamic> fileUrls) async {
    _isDeleting.value = true;

    try {
      // Delete the files from Firebase Storage if they exist
      for (String fileUrl in fileUrls) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.refFromURL(fileUrl);
        await ref.delete();
      }

      // Delete the document from Firestore
      await FirebaseFirestore.instance
          .collection('banners')
          .doc(docId)
          .delete();

      _isDeleting.value = false;

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      // Handle any errors here
      print('Error deleting ticket: $e');

      if (mounted) {
        _singleton.showAlertDialog(
          context: context,
          title: "Message",
          message:
          "Image Not Found To Delete! \nLets Delete Record and Exit!\nRefresh User List to See updated Product List",
          onCancelPressed: () {
            _isDeleting.value = false;
          },
          onOkPressed: () async {
            try {
              await FirebaseFirestore.instance
                  .collection('banners')
                  .doc(docId ?? "")
                  .delete();

              _isDeleting.value = false;

              Navigator.pop(context);
            } catch (e) {
              _isDeleting.value = false;

              _singleton.showAlertDialog(
                context: context,
                title: "Message",
                message: "Unable to Delete Product Record",
                onCancelPressed: () {
                  _isDeleting.value = false;
                  Navigator.pop(context);
                },
                onOkPressed: () async {
                  _isDeleting.value = false;

                  Navigator.pop(context);
                },
              );
            }
          },
        );
      }

    }
    // finally {
    //   _isDeleting.value = false;
    // }
  }

  // static Future<Response?> postNotificationWithImage(
  //     String getToken,
  //     String getTitleMessage,
  //     String getBodyMessage,
  //     String? getProductImage) async {
  //   String fileId = _extractFileId(
  //       "https://drive.google.com/file/d/1wANZHruoYJ5uO-q8bdt-jIz4MSu2seh8/view?usp=sharing");
  //
  //   // Convert to a direct link
  //   String? directImageUrl =
  //       'https://drive.google.com/uc?export=view&id=$fileId';
  //
  //   Response? res;
  //   var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
  //
  //   try {
  //     var response = await http.Client().post(url,
  //         body: jsonEncode({
  //           "to": getToken ?? "",
  //           "priority": "high",
  //           "notification": {
  //             "title": getTitleMessage,
  //             "body": getBodyMessage,
  //             "image": getProductImage ?? directImageUrl,
  //           },
  //           "data": {
  //             "custom_key":
  //                 "custom_value" // Optional: You can include custom data here
  //           }
  //         }),
  //         headers: {
  //           "Accept": "application/json",
  //           "Content-type": "application/json",
  //           "Authorization":
  //               "key=AAAAb-_MBP8:APA91bFubSJ4pOcNkYMD9uFXekSyOQel1Mzojc1Q7noOPRiR-WNu_C_FgoZ-lQ6Maa1A52NqAoLM7tdQTZ7nEeXs_WUhhqjUg5B0P2lCp2rf95PxdR0PaOSVZUz8UeWJArogfm3gFKRp",
  //         });
  //
  //     var body = response.body;
  //     print("JSON Response -- $body");
  //     if (response.statusCode == 200) {
  //       body = await response.body;
  //     }
  //     res = Response(response.statusCode, body);
  //   } on SocketException catch (e) {
  //     print(e);
  //     res = Response(
  //         001, 'No Internet Connection\nPlease check your network status');
  //   }
  //
  //   print("res <- ${res?.resBody.toString()}");
  //   return res;
  // }

  //todo:- to convert drive link to direct link
  static String _extractFileId(String url) {
    // Extract the file ID from the Google Drive link
    final RegExp regExp = RegExp(r'/d/(.*?)/');
    final match = regExp.firstMatch(url);
    if (match != null && match.groupCount > 0) {
      return match.group(1) ?? '';
    }
    return '';
  }
}



//todo:- shows details of selected product
class ProductDetailScreen extends StatefulWidget {
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

  ProductDetailScreen(
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
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
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
                            // Expanded(
                            //   flex: 1,
                            //   child: Container(
                            //     color: Constants.secondary,
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.start,
                            //       children: [
                            //         Padding(
                            //           padding: const EdgeInsets.only(left: 10.0),
                            //           child: SingleChildScrollView(
                            //             child: Column(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.spaceEvenly,
                            //               crossAxisAlignment:
                            //                   CrossAxisAlignment.start,
                            //               children: [
                            //                 Text(
                            //                   widget.title,
                            //                   textAlign: TextAlign.start,
                            //                   style: GlobalTextStyles.primaryText2(
                            //                       textColor:
                            //                           FlutterFlowTheme.of(context)
                            //                               .primaryBackground),
                            //                 ),
                            //                 Text(
                            //                   widget.description,
                            //                   textAlign: TextAlign.start,
                            //                   style:
                            //                       GlobalTextStyles.secondaryText1(
                            //                           textColor:
                            //                               FlutterFlowTheme.of(
                            //                                       context)
                            //                                   .primaryBackground),
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              flex: 9,
                              child: SingleChildScrollView(
                                child: Container(
                                  color: Constants.secondary,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      // Padding(
                                      //     padding: const EdgeInsets.all(8.0),
                                      //     child: Container(
                                      //       height: 50.h, // Adjust height as needed
                                      //       decoration: BoxDecoration(
                                      //         color: Colors.white,
                                      //         borderRadius:
                                      //             BorderRadius.circular(12),
                                      //         // Rounded corners
                                      //         boxShadow: [
                                      //           BoxShadow(
                                      //             color:
                                      //                 Colors.black.withOpacity(0.4),
                                      //             // Shadow color
                                      //             spreadRadius: 2,
                                      //             // Spread radius
                                      //             blurRadius: 5,
                                      //             // Blur radius
                                      //             offset:
                                      //                 Offset(0, 3), // Shadow offset
                                      //           ),
                                      //         ],
                                      //       ),
                                      //       child: ClipRRect(
                                      //         borderRadius:
                                      //             BorderRadius.circular(12),
                                      //         child: Stack(
                                      //           children: [
                                      //             PageView.builder(
                                      //               itemCount:
                                      //                   widget.imageUrls.length,
                                      //               onPageChanged: (int page) {
                                      //                 setState(() {
                                      //                   _currentPage = page;
                                      //                 });
                                      //               },
                                      //               itemBuilder: (context, index) {
                                      //                 return GestureDetector(
                                      //                   onTap: () {
                                      //                     Navigator.push(
                                      //                       context,
                                      //                       MaterialPageRoute(
                                      //                         builder: (context) =>
                                      //                             FullImageScreen(
                                      //                           imageUrl: widget
                                      //                                   .imageUrls[
                                      //                               index],
                                      //                           heroTag:
                                      //                               'image_$index',
                                      //                           affiliateLink: widget
                                      //                               .affiliateLink,
                                      //                         ),
                                      //                       ),
                                      //                     );
                                      //                   },
                                      //                   child: Hero(
                                      //                     tag: widget.getHeroTag,
                                      //                     child: Image.network(
                                      //                       widget.imageUrls[index],
                                      //                       fit: BoxFit.cover,
                                      //                       loadingBuilder:
                                      //                           (BuildContext
                                      //                                   context,
                                      //                               Widget child,
                                      //                               ImageChunkEvent?
                                      //                                   loadingProgress) {
                                      //                         if (loadingProgress ==
                                      //                             null) {
                                      //                           return child;
                                      //                         } else {
                                      //                           return Center(
                                      //                             child:
                                      //                                 CircularProgressIndicator(
                                      //                               value: loadingProgress
                                      //                                           .expectedTotalBytes !=
                                      //                                       null
                                      //                                   ? loadingProgress
                                      //                                           .cumulativeBytesLoaded /
                                      //                                       loadingProgress
                                      //                                           .expectedTotalBytes!
                                      //                                   : null,
                                      //                             ),
                                      //                           );
                                      //                         }
                                      //                       },
                                      //                     ),
                                      //                   ),
                                      //                 );
                                      //               },
                                      //             ),
                                      //             Positioned(
                                      //               bottom: 10,
                                      //               left: 0,
                                      //               right: 0,
                                      //               child: Row(
                                      //                 mainAxisAlignment:
                                      //                     MainAxisAlignment.center,
                                      //                 children:
                                      //                     List<Widget>.generate(
                                      //                   widget.imageUrls.length,
                                      //                   (int index) {
                                      //                     return Container(
                                      //                       width: 8,
                                      //                       height: 8,
                                      //                       margin: EdgeInsets
                                      //                           .symmetric(
                                      //                               horizontal: 4),
                                      //                       decoration:
                                      //                           BoxDecoration(
                                      //                         shape:
                                      //                             BoxShape.circle,
                                      //                         color: _currentPage ==
                                      //                                 index
                                      //                             ? Colors.blue
                                      //                             : Colors.grey,
                                      //                       ),
                                      //                     );
                                      //                   },
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     )),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      // widget.affiliateLink.isNotEmpty
                                      //     ? Container()
                                      //     : Padding(
                                      //         padding: const EdgeInsets.only(
                                      //             right: 10.0),
                                      //         child: Text(
                                      //           ' ₹ss' + widget.amount,
                                      //           textAlign: TextAlign.end,
                                      //           style:
                                      //               GlobalTextStyles.primaryText1(
                                      //                   textColor:
                                      //                       FlutterFlowTheme.of(
                                      //                               context)
                                      //                           .primaryBackground),
                                      //         ),
                                      //       ),
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


//todo:- shows image with full screen
class FullImageScreen extends StatefulWidget {
  final String imageUrl;
  final String heroTag;
  final String affiliateLink;

  FullImageScreen(
      {Key? key,
      required this.imageUrl,
      required this.heroTag,
      required this.affiliateLink})
      : super(key: key);

  @override
  FullImageScreenState createState() => FullImageScreenState();
}

class FullImageScreenState extends State<FullImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: true,
        toolbarHeight: 8.h,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Center(
        child: Hero(
          tag: widget.heroTag,
          child: Image.network(
            widget.imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

// class CreateNewProductScreen extends ConsumerStatefulWidget {
//   @override
//   CreateNewProductScreenState createState() => CreateNewProductScreenState();
// }
//
// class CreateNewProductScreenState
//     extends ConsumerState<CreateNewProductScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _formKeyHomePage = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _affiliateLinkController = TextEditingController();
//   final _amntController = TextEditingController();
//   final _minBargainAmntController = TextEditingController();
//   final _detailsController = TextEditingController();
//   final _specController = TextEditingController();
//
//   final _amazonLinkController = TextEditingController();
//   final _flipkartLinkController = TextEditingController();
//   final _myntraLinkController = TextEditingController();
//   final _ajioLinkController = TextEditingController();
//
//   List<Tuple2<String?, String?>?> productCategory = [];
//   Tuple2<String?, String?>? getSelectedProductCategory = Tuple2("", "");
//
//   // final _meeshoLinkController = TextEditingController();
//
//   List<PlatformFile>? _selectedFiles;
//   final ValueNotifier<bool> _isCreatingProduct = ValueNotifier<bool>(false);
//
//   CollectionReference? _collectionRefToken;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _collectionRefToken = FirebaseFirestore.instance.collection('HomePageLink');
//
//     productCategory = [
//       Tuple2("Men", "1"),
//       Tuple2("Women", "2"),
//       Tuple2("Kids", "3"),
//       Tuple2("Home Appliances", "4"),
//       Tuple2("Others", "5"),
//     ];
//   }
//
//   Future<void> _pickFiles() async {
//     FilePickerResult? result =
//         await FilePicker.platform.pickFiles(allowMultiple: true);
//     if (result != null) {
//       setState(() {
//         _selectedFiles = result.files;
//       });
//     }
//   }
//
//   Future<void> _createProduct() async {
//     _isCreatingProduct.value = true;
//
//     try {
//       if (_formKey.currentState!.validate()) {
//         List<String> fileUrls = [];
//         if (_selectedFiles != null) {
//           // Upload each file and get the URL
//           for (PlatformFile file in _selectedFiles!) {
//             FirebaseStorage storage = FirebaseStorage.instance;
//             Reference ref = storage.ref().child('banners/${file.name}');
//             UploadTask uploadTask = ref.putFile(File(file.path!));
//             TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
//             String fileUrl = await snapshot.ref.getDownloadURL();
//             fileUrls.add(fileUrl);
//           }
//         } else {
//           Constants.showToast(
//               "Please Attach Product Image", ToastGravity.BOTTOM);
//           return;
//         }
//
//         // Save the product information in Firestore
//         await FirebaseFirestore.instance.collection('banners').add({
//           'title': _titleController.text,
//           'description': _descriptionController.text,
//           'amount': _amntController.text,
//           'minBargainAmount': _minBargainAmntController.text,
//           'productDetails': _detailsController.text,
//           'productSpec': _specController.text,
//           'fileUrls': fileUrls,
//           'productCategory': "",
//           'affiliateLink': _affiliateLinkController.text,
//           'created_at': Timestamp.now(),
//         });
//
//         String getTitle = _titleController.text;
//         String getAmount = _amntController.text;
//         String getDescription = _descriptionController.text;
//
//         // await NotificationService.postCommonNotificationRequest(
//         //     "Get $getTitle for Rs.$getAmount ✨",
//         //     "Maaka Posted New $getTitle✨\n$getDescription🥳\nMaaka filter useful products🏸🛼🛴 with the best offers💥\nShop now and save big!🪑💰🔦🛵⚽️");
//
//         Response? getResult = await NotificationService.postNotificationWithImage(
//             "Get $getTitle for Rs.$getAmount ✨",
//             "Try bargaining for the best prices on your favorite products 🪑💰🔦🛵⚽️",
//             fileUrls[0] ?? null);
//
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       // Handle any errors here
//       print('Error creating product: $e');
//     } finally {
//       _isCreatingProduct.value = false;
//     }
//   }
//
//   Future<void> _UpdateHomePageLink() async {
//     try {
//       if (_formKeyHomePage.currentState!.validate()) {
//         // Save the product information in Firestore
//
//         QuerySnapshot snapshot = await _collectionRefToken!.limit(1).get();
//         if (snapshot.docs.isNotEmpty) {
//           String documentId = snapshot.docs.first.id;
//           await _collectionRefToken!.doc(documentId).update({
//             'amazonHomePageUrl': _amazonLinkController.text,
//             'flipkartHomePageUrl': _flipkartLinkController.text,
//             'myntraHomePageUrl': _myntraLinkController.text,
//             'ajioHomePageUrl': _ajioLinkController.text,
//             // 'meeshoHomePageUrl': _meeshoLinkController.text,
//             'created_at': Timestamp.now(),
//           });
//
//           await NotificationService.postCommonNotificationRequest(
//               "Maaka gives Access for all shopping apps in one place✨",
//               "Enjoy seamless browsing, exclusive deals, and secure transactions💥\nShop now and save big!🪑💰🔦🛵⚽️");
//
//           Constants.showToast("Home page links updated", ToastGravity.BOTTOM);
//         } else {
//           // Create a new document since no document is found
//           await _collectionRefToken!.add({
//             'amazonHomePageUrl': _amazonLinkController.text,
//             'flipkartHomePageUrl': _flipkartLinkController.text,
//             'myntraHomePageUrl': _myntraLinkController.text,
//             'ajioHomePageUrl': _ajioLinkController.text,
//             // 'meeshoHomePageUrl': _meeshoLinkController.text,
//             'created_at': Timestamp.now(),
//           });
//           await NotificationService.postCommonNotificationRequest(
//               "Maaka gives Access for all shopping apps in one place✨",
//               "Enjoy seamless browsing, exclusive deals, and secure transactions💥\nShop now and save big!🪑💰🔦🛵⚽️");
//           Constants.showToast("Home page links created", ToastGravity.BOTTOM);
//         }
//       }
//     } catch (e) {
//       // Handle any errors here
//       Constants.showToast(
//           "Problem in updating Home page Links", ToastGravity.BOTTOM);
//       print('Error creating home page link: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: responsiveVisibility(
//         context: context,
//         tabletLandscape: false,
//         desktop: false,
//       )
//           ? AppBar(
//               title: Text(
//                 "Post Product",
//                 style: GlobalTextStyles.secondaryText1(
//                     textColor: FlutterFlowTheme.of(context).secondary2,
//                     txtWeight: FontWeight.w700),
//               ),
//               backgroundColor: FlutterFlowTheme.of(context).primary,
//               automaticallyImplyLeading: true,
//               toolbarHeight: 8.h,
//               leading: IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: const Icon(Icons.arrow_back_ios_rounded,
//                     color: Colors.white),
//               ),
//               centerTitle: true,
//               elevation: 0.0,
//             )
//           : null,
//       body: Stack(alignment: Alignment.center, children: [
//         IgnorePointer(
//           ignoring: _isCreatingProduct.value,
//           child: Container(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   Expanded(
//                       child: Container(
//                     width: 100.w,
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               "Product Details",
//                               textAlign: TextAlign.start,
//                               style: GlobalTextStyles.secondaryText1(
//                                   textColor: FlutterFlowTheme.of(context)
//                                       .primaryBackground),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 9,
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   TextFormField(
//                                     controller: _titleController,
//                                     decoration: InputDecoration(
//                                         labelText: 'Product Title'),
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter a title';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(
//                                     height: 15,
//                                   ),
//                                   TextFormField(
//                                     controller: _descriptionController,
//                                     decoration: InputDecoration(
//                                         labelText: 'Product Description'),
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter a description';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(
//                                     height: 15,
//                                   ),
//                                   TextFormField(
//                                     controller: _amntController,
//                                     keyboardType: TextInputType.number,
//                                     decoration:
//                                         InputDecoration(labelText: 'Amount'),
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter a amount';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(
//                                     height: 15,
//                                   ),
//                                   TextFormField(
//                                     controller: _minBargainAmntController,
//                                     keyboardType: TextInputType.number,
//                                     decoration: InputDecoration(
//                                         labelText: 'Minimum Bargain Amount'),
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter a Minimum Bargain Amount';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(
//                                     height: 15,
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       ref.read(ListProvider.notifier).getData =
//                                           productCategory;
//                                       ref
//                                               .read(ListProvider.notifier)
//                                               .getSelectionType =
//                                           SelectionType.postProductCategoryType;
//
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   ListViewBuilder(
//                                                     getListHeading:
//                                                         "Choose Product Category",
//                                                     getIndex: null,
//                                                   )));
//                                     },
//                                     child: Consumer(
//                                         builder: (context, ref, child) {
//                                       // getSelectedProductCategory = ref
//                                       //     .watch(productCategoryTypeProvider);
//
//                                       return Padding(
//                                         padding: const EdgeInsetsDirectional
//                                             .fromSTEB(20.0, 10.0, 20.0, 16.0),
//                                         child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left: 10),
//                                                 child: Text(
//                                                   "Product Category",
//                                                   style: const TextStyle(
//                                                       color: Colors.grey,
//                                                       fontWeight:
//                                                           FontWeight.w400,
//                                                       letterSpacing: 1),
//                                                   maxLines: 2,
//                                                   softWrap: false,
//                                                   overflow: TextOverflow.fade,
//                                                   textAlign: TextAlign.justify,
//                                                 ),
//                                               ),
//                                               Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceEvenly,
//                                                   children: [
//                                                     Expanded(
//                                                       child: Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(5.0),
//                                                         child: Container(
//                                                           height: 50,
//                                                           child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .only(
//                                                                     left: 10.0),
//                                                             child:
//                                                                 TextFormField(
//                                                               enabled: false,
//                                                               keyboardType:
//                                                                   TextInputType
//                                                                       .none,
//                                                               controller: ref
//                                                                   .read(ListProvider
//                                                                       .notifier)
//                                                                   .txtGoalPriority,
//                                                               focusNode: ref
//                                                                   .read(ListProvider
//                                                                       .notifier)
//                                                                   .focusGoalPriority,
//                                                               textCapitalization:
//                                                                   TextCapitalization
//                                                                       .words,
//                                                               decoration:
//                                                                   const InputDecoration(
//                                                                       // labelText: data.success![1][index].item2!,
//                                                                       suffixIcon:
//                                                                           Icon(
//                                                                         Icons
//                                                                             .navigate_next,
//                                                                         color: Color.fromARGB(
//                                                                             125,
//                                                                             1,
//                                                                             2,
//                                                                             2),
//                                                                       ),
//                                                                       border: InputBorder
//                                                                           .none),
//                                                               style: const TextStyle(
//                                                                   letterSpacing:
//                                                                       1),
//
//                                                               // keyboardType:
//                                                               //     TextInputType
//                                                               //         .text,
//                                                               validator:
//                                                                   _validateMappedAdmin,
//                                                             ),
//                                                           ),
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             border: Border.all(
//                                                                 color: Colors
//                                                                     .grey),
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         10),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ]),
//                                             ]),
//                                       );
//                                     }),
//                                   ),
//                                   SizedBox(
//                                     height: 15,
//                                   ),
//                                   TextFormField(
//                                     controller: _detailsController,
//                                     decoration: InputDecoration(
//                                         labelText: 'Product Details'),
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter a details';
//                                       }
//                                       return null;
//                                     },
//                                     maxLines: 8,
//                                   ),
//                                   SizedBox(
//                                     height: 15,
//                                   ),
//                                   TextFormField(
//                                     controller: _specController,
//                                     decoration: InputDecoration(
//                                         labelText: 'Product Specification'),
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter a specification';
//                                       }
//                                       return null;
//                                     },
//                                     maxLines: 8,
//                                   ),
//                                   SizedBox(
//                                     height: 15,
//                                   ),
//                                   TextFormField(
//                                     controller: _affiliateLinkController,
//                                     decoration: InputDecoration(
//                                         labelText: 'Affiliate link'),
//                                   ),
//                                   SizedBox(height: 15.0),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 2,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 ElevatedButton(
//                                   onPressed: _pickFiles,
//                                   child: Text(
//                                     _selectedFiles == null
//                                         ? 'Attach Image'
//                                         : 'Change Image',
//                                     style: TextStyle(
//                                       color: FlutterFlowTheme.of(context)
//                                           .secondary,
//                                     ),
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor:
//                                         FlutterFlowTheme.of(context).primary,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(
//                                           10.0), // Set the border radius here
//                                     ), // Set the background color here
//                                   ),
//                                 ),
//                                 SizedBox(width: 10.0),
//                                 ElevatedButton(
//                                   onPressed: _createProduct,
//                                   child: Text(
//                                     'Post Product',
//                                     style: TextStyle(
//                                       color: FlutterFlowTheme.of(context)
//                                           .secondary,
//                                     ),
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor:
//                                         FlutterFlowTheme.of(context).primary,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(
//                                           10.0), // Set the border radius here
//                                     ), // Set the background color here
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )),
//                   Expanded(
//                     child: Container(
//                       width: 100.w,
//                       child: Form(
//                         key: _formKeyHomePage,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 "Home Page Links",
//                                 textAlign: TextAlign.start,
//                                 style: GlobalTextStyles.secondaryText1(
//                                     textColor: FlutterFlowTheme.of(context)
//                                         .primaryBackground),
//                               ),
//                             ),
//                             Expanded(
//                               flex: 7,
//                               child: SingleChildScrollView(
//                                 child: Column(
//                                   children: [
//                                     SizedBox(
//                                       height: 15,
//                                     ),
//                                     TextFormField(
//                                       controller: _amazonLinkController,
//                                       decoration: InputDecoration(
//                                           labelText: 'amazon home page'),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter amazon link';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                     SizedBox(
//                                       height: 15,
//                                     ),
//                                     TextFormField(
//                                       controller: _flipkartLinkController,
//                                       decoration: InputDecoration(
//                                           labelText: 'flipkart home page'),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter flipkart link';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                     SizedBox(
//                                       height: 15,
//                                     ),
//                                     TextFormField(
//                                       controller: _myntraLinkController,
//                                       decoration: InputDecoration(
//                                           labelText: 'myntra home page'),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter myntra link';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                     SizedBox(
//                                       height: 15,
//                                     ),
//                                     TextFormField(
//                                       controller: _ajioLinkController,
//                                       decoration: InputDecoration(
//                                           labelText: 'ajio home page'),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter ajio link';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                     SizedBox(
//                                       height: 15,
//                                     ),
//                                     // TextFormField(
//                                     //   controller: _meeshoLinkController,
//                                     //   decoration: InputDecoration(
//                                     //       labelText: 'meesho home page'),
//                                     //   validator: (value) {
//                                     //     if (value == null || value.isEmpty) {
//                                     //       return 'Please enter meesho link';
//                                     //     }
//                                     //     return null;
//                                     //   },
//                                     // ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               flex: 3,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   Expanded(
//                                     child: ElevatedButton(
//                                       onPressed: _UpdateHomePageLink,
//                                       child: Text(
//                                         'Update Home Page',
//                                         style: TextStyle(
//                                           color: FlutterFlowTheme.of(context)
//                                               .secondary,
//                                         ),
//                                       ),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor:
//                                             FlutterFlowTheme.of(context)
//                                                 .primary,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                               10.0), // Set the border radius here
//                                         ), // Set the background color here
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//         ValueListenableBuilder<bool>(
//           valueListenable: _isCreatingProduct,
//           builder: (context, isCreating, child) {
//             if (isCreating) {
//               return Container(
//                 child: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               );
//             }
//             return SizedBox.shrink();
//           },
//         ),
//       ]),
//     );
//   }
//
//   String? _validateMappedAdmin(String? value) {
//     if (value == null || value.isEmpty) {
//       Constants.showToast("Please map product Category", ToastGravity.BOTTOM);
//       return 'Please map Product Category ';
//     }
//
//     return null;
//   }
// }

//todo:- 25.6.24 , below code demonstrate bargain screen for user to bargain on products
//todo:- shows bargain screen
class ProductBargainScreen extends StatefulWidget {
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

  ProductBargainScreen(
      {required this.title,
      required this.description,
      required this.affiliateLink,
      required this.prodDetails,
      required this.prodSpec,
      required this.imageUrls,
      required this.amount,
      required this.minBargainAmount,
      required this.userName,
      required this.getAdminType});

  @override
  ProductBargainScreenState createState() => ProductBargainScreenState();
}

class ProductBargainScreenState extends State<ProductBargainScreen> {
  int _currentPage = 0;
  final _txtBargainController = TextEditingController();

  void _openWhatsAppChat(String? getProductName, String getAdminType,
      String getProductPrice, double getUserBargainPrice) async {
    getAdminType == "1" ? Constants.admin1Gpay : Constants.admin2Gpay;

    final String phoneNumber = getAdminType == "1"
        ? Constants.admin1Gpay
        : Constants.admin2Gpay; // Replace with the desired phone number
    final String defaultMessage =
        'I saw your product $getProductName on the Maaka app with price $getProductPrice, Am interested to Buy it for $getUserBargainPrice. Could you provide more details about it?'; // Replace with your default message
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

  void _showResultDialog(
      BuildContext context,
      bool isAccepted,
      double getUserBargainingAmnt,
      double getMinimumBargainAmnt,
      String getProductPrice) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isAccepted ? 'Deal Accepted' : 'Deal Rejected',
            style: GlobalTextStyles.primaryText2(),
          ),
          content: Text(
            isAccepted
                ? 'We are ok and you can get for this Price!'
                : 'We are not ok with your Price.',
            style: GlobalTextStyles.secondaryText2(),
          ),
          actions: isAccepted
              ? [
                  TextButton(
                      onPressed: () async {
                        if (isAccepted) {
                          _openWhatsAppChat(widget.title, widget.getAdminType,
                              getProductPrice, getUserBargainingAmnt);

                          //todo:- 2.6.24 when user shows interest in product, then should push notification to admin
                          String? token =
                              await NotificationService.getDocumentIDsAndData();

                          String? getUserName = widget.userName ?? "";
                          String? getTitle = widget.title ?? "";
                          String? getAmount = widget.amount ?? "";

                          await NotificationService.postNotificationRequest(
                              token ?? "",
                              "Hi Admin,\n$getUserName is Finalized Bargaining.",
                              "Our Price for $getTitle is $getAmount\nOur Minimum Bargain Price is $getMinimumBargainAmnt\n$getUserName is Confiming for $getUserBargainingAmnt");

                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Message to Confirm Order')),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ]
              : [
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text('Try Again'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.secondary,
      appBar: responsiveVisibility(
        context: context,
        tabletLandscape: false,
        desktop: false,
      )
          ? AppBar(
              title: Text(
                "Bargain",
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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: Constants.secondary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹' + widget.amount,
                              textAlign: TextAlign.end,
                              style: GlobalTextStyles.primaryText1(
                                  textColor: FlutterFlowTheme.of(context)
                                      .primaryBackground),
                            ),
                            Text(
                              widget.title,
                              textAlign: TextAlign.start,
                              style: GlobalTextStyles.secondaryText1(
                                  textColor: FlutterFlowTheme.of(context)
                                      .primaryBackground),
                            ),
                            Text(
                              widget.description,
                              textAlign: TextAlign.start,
                              style: GlobalTextStyles.secondaryText2(
                                  textColor: FlutterFlowTheme.of(context)
                                      .primaryBackground),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                child: Visibility(
                  visible: true,
                  child: Container(
                    color: Constants.secondary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 30.h, // Adjust height as needed
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    // Shadow color
                                    spreadRadius: 2,
                                    // Spread radius
                                    blurRadius: 5,
                                    // Blur radius
                                    offset: Offset(0, 3), // Shadow offset
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  children: [
                                    PageView.builder(
                                      itemCount: widget.imageUrls.length,
                                      onPageChanged: (int page) {
                                        setState(() {
                                          _currentPage = page;
                                        });
                                      },
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {},
                                          child: Hero(
                                            tag: 'image_$index',
                                            child: Image.network(
                                              widget.imageUrls[index],
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
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
                                        children: List<Widget>.generate(
                                          widget.imageUrls.length,
                                          (int index) {
                                            return Container(
                                              width: 8,
                                              height: 8,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 4),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _currentPage == index
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
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                color: Constants.secondary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _txtBargainController,
                          decoration: InputDecoration(
                            labelText: 'Bargaining Amount',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Bargain Amount';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0), // Set the border radius here
                            ), // S// Set the background color here
                          ),
                          onPressed: () async {
                            final getUserBargainAmount =
                                double.tryParse(_txtBargainController.text);
                            double getMinMarginAmount =
                                double.parse(widget.minBargainAmount ?? "0");
                            double getProductPrice =
                                double.parse(widget.amount ?? "0");

                            if (getUserBargainAmount != null) {
                              if (getUserBargainAmount > getProductPrice) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Please enter a valid Bargaining Amount')),
                                );
                                return;
                              }

                              if (getUserBargainAmount == 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Please enter a valid Bargaining Amount')),
                                );
                                return;
                              }

                              if (getUserBargainAmount >= getMinMarginAmount) {
                                _showResultDialog(
                                    context,
                                    true,
                                    getUserBargainAmount,
                                    getMinMarginAmount,
                                    widget.amount);
                              } else {
                                _showResultDialog(
                                    context,
                                    false,
                                    getUserBargainAmount,
                                    getMinMarginAmount,
                                    widget.amount);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Please enter a valid Bargaining Amount')),
                              );
                            }
                          },
                          child: Text('Start Bargaining!',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Constants.secondary,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final double minBargainAmount;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.minBargainAmount,
  });
}





//todo:- show all food in server
class FoodListScreen extends ConsumerStatefulWidget {
  final String userName;

  FoodListScreen({Key? key, required this.userName}) : super(key: key);

  @override
  FoodListScreenState createState() => FoodListScreenState();
}

class FoodListScreenState extends ConsumerState<FoodListScreen>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<bool> _isDeleting = ValueNotifier<bool>(false);
  final SingletonReusableCode _singleton = SingletonReusableCode();


  final List<String> _categories = [
    'Main Course',
    'Gravy',
    'Starters',
    'Desserts',
  ];
  final Map<String, String> _categoryMapping = {
    '1': 'Main Course',
    '2': 'Gravy',
    '3': 'Starters',
    '4': 'Desserts',
  };

  List<FoodList>? getFoodList = [];

  @override
  void initState() {
    // TODO: implement initState

    getFoodList = ref.read(UserDashListProvider.notifier).categoryProducts;

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
        backgroundColor: Constants.secondary,
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
          title: Text(
            "Best Deals",
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
        body: SafeArea(
          child: Stack(children: [


            StreamBuilder(
              stream:

              // FirebaseFirestore.instance
              //     .collectionGroup('Foods') // ✅ Fetches all "Foods"
              //     .snapshots(),

              FirebaseFirestore
                  .instance
                  .collection(
                      'AreaFoodPrices')
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<
                      QuerySnapshot>
                  snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child:
                      CircularProgressIndicator());
                }

                if (snapshot.data!.docs ==
                    null ||
                    snapshot.data!.docs
                        .isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceEvenly,
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .center,
                      children: [

                        Text(
                          "New Food Partners are About to Load!",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                              FontWeight
                                  .bold),
                          textAlign:
                          TextAlign
                              .center,
                        ),
                        Text(
                          "Cheers to Smart Food Buying Plans.",
                          textAlign:
                          TextAlign
                              .center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics:
                  NeverScrollableScrollPhysics(),
                  itemCount: snapshot
                      .data!.docs.length,
                  itemBuilder: (context, index) {
                    if (index > 2) {
                      return SizedBox
                          .shrink(); // Return an empty widget for transactions beyond the last three
                    }

                    var doc = snapshot
                        .data!.docs[index];


                    String getFoodAdminCloudShopName = (doc
                        .data()
                    as Map<
                        String,
                        dynamic>?)
                        ?.containsKey(
                        'foodAdminCloudShopName') ??
                        false
                        ? doc['foodAdminCloudShopName']
                        : "";

                    String getFoodAdminNo = (doc
                        .data()
                    as Map<
                        String,
                        dynamic>?)
                        ?.containsKey(
                        'foodAdminNo') ??
                        false
                        ? doc['foodAdminNo']
                        : "";

                    return Container(
                      color: Constants.secondary
                          .withOpacity(0.95),
                      child: Padding(
                        padding:
                        const EdgeInsets.all(5),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                                6.0),
                          ),
                          color:  Constants.secondary,
                          elevation: 4.0,
                          child: ListTile(
                            leading: Card(
                              color:  FlutterFlowTheme.of(
                                  context)
                                  .primary
                                  ,
                              clipBehavior: Clip
                                  .antiAliasWithSaveLayer,
                              elevation: 5.0,
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(8.0),
                              ),
                              child: Padding(
                                padding:
                                const EdgeInsets
                                    .all(8.0),
                                child: Icon(
                                  Icons
                                      .food_bank,
                                  color: Constants
                                      .secondary,
                                  size: 24.0,
                                ),
                              ),
                            ),
                            title: Text(
                              getFoodAdminCloudShopName ?? "N/A",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                  color:Constants
                                      .primary,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                  overflow:
                                  TextOverflow
                                      .ellipsis),
                            ),
                            subtitle: Text(
                              getFoodAdminNo ?? "N/A",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                  color: Colors
                                      .black,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                  overflow:
                                  TextOverflow
                                      .ellipsis),
                            ),

                            onTap: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                      AdminsFoodListScreen(
                                        getAdminMobile: getFoodAdminNo ??
                                            "",
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
                    );
                  },
                );
              },
            ),

            //todo:- 23.3.25 commented
            // ListView.builder(
            //   itemCount: _categories.length,
            //   itemBuilder: (context, index) {
            //     String category = _categories[index];
            //     String categoryId = _categoryMapping.entries
            //         .firstWhere((element) => element.value == category)
            //         .key;
            //
            //     List<FoodList>? categoryProducts = getFoodList
            //         ?.where((product) => product.productCategory == categoryId)
            //         .toList();
            //
            //     if (categoryProducts == null) {
            //       return Container();
            //     }
            //
            //     return Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         categoryProducts.isEmpty
            //             ? Container()
            //             : Column(
            //           children: [
            //             Padding(
            //               padding: const EdgeInsets.only(left: 8.0),
            //               child: Text(
            //                 category,
            //                 style: Theme.of(context)
            //                     .textTheme
            //                     .headlineSmall
            //                     ?.copyWith(
            //                     color: Constants.primary,
            //                     fontWeight: FontWeight.bold),
            //               ),
            //             ),
            //             GridView.builder(
            //               shrinkWrap: true,
            //               physics: NeverScrollableScrollPhysics(),
            //               padding: const EdgeInsets.all(8.0),
            //               gridDelegate:
            //               SliverGridDelegateWithFixedCrossAxisCount(
            //                 crossAxisCount: 2,
            //                 crossAxisSpacing: 8.0,
            //                 mainAxisSpacing: 8.0,
            //                 childAspectRatio: 0.7,
            //               ),
            //               itemCount: categoryProducts.length,
            //               itemBuilder: (context, index) {
            //                 FoodList? product =
            //                 categoryProducts[index];
            //
            //                 String? getAmount = product.amount ?? "";
            //                 String? getTitle = product.title ?? "";
            //                 String? getDocId = product.docID ?? "";
            //                 String? getDescription = product.description ?? "";
            //                 final List<dynamic> imageUrls =   product.fileUrls;
            //
            //                 return GridTile(
            //                   child: GestureDetector(
            //                     onTap: () {
            //                       Navigator.push(
            //                         context,
            //                         MaterialPageRoute(
            //                           builder: (context) =>
            //                               FoodDetailScreen(
            //                                 title: getTitle,
            //                                 description:
            //                                 getDescription,
            //                                 affiliateLink: "",
            //                                 prodDetails:
            //                                 "getProdDetails",
            //                                 prodSpec: "getProdSpec",
            //                                 imageUrls: imageUrls,
            //                                 amount: getAmount,
            //                                 userName: ref
            //                                     .read(
            //                                     UserDashListProvider
            //                                         .notifier)
            //                                     .getUser ??
            //                                     "",
            //                                 getAdminType: ref
            //                                     .read(
            //                                     UserDashListProvider
            //                                         .notifier)
            //                                     .getAdminType ??
            //                                     "",
            //                                 minBargainAmount:
            //                                 "",
            //                                 getHeroTag:
            //                                 'imageHero$index',
            //                               ),
            //                         ),
            //                       );
            //                     },
            //                     child: Container(
            //                       decoration: BoxDecoration(
            //                         color: _singleton.lighten(
            //                             Constants.secondary2,
            //                             amount: _singleton
            //                                 .generateRandomColorDouble()),
            //                         borderRadius:
            //                         BorderRadius.circular(15.0),
            //                       ),
            //                       alignment: Alignment.center,
            //                       child: Column(
            //                         mainAxisAlignment:
            //                         MainAxisAlignment.spaceEvenly,
            //                         crossAxisAlignment:
            //                         CrossAxisAlignment.start,
            //                         children: [
            //                           Expanded(
            //                             child: Container(
            //                               child: ClipRRect(
            //                                 borderRadius:
            //                                 BorderRadius.only(
            //                                   topLeft:
            //                                   Radius.circular(15),
            //                                   topRight:
            //                                   Radius.circular(15),
            //                                 ),
            //                                 child: product
            //                                     .fileUrls.isNotEmpty
            //                                     ? Hero(
            //                                   tag:
            //                                   'imageHero$index$getTitle$getAmount',
            //                                   child: Image.network(
            //                                     product.fileUrls[0],
            //                                     fit: BoxFit.cover,
            //                                     loadingBuilder:
            //                                         (BuildContext
            //                                     context,
            //                                         Widget
            //                                         child,
            //                                         ImageChunkEvent?
            //                                         loadingProgress) {
            //                                       if (loadingProgress ==
            //                                           null) {
            //                                         return child;
            //                                       } else {
            //                                         return Center(
            //                                           child:
            //                                           CircularProgressIndicator(
            //                                             value: loadingProgress.expectedTotalBytes !=
            //                                                 null
            //                                                 ? loadingProgress.cumulativeBytesLoaded /
            //                                                 loadingProgress.expectedTotalBytes!
            //                                                 : null,
            //                                           ),
            //                                         );
            //                                       }
            //                                     },
            //                                   ),
            //                                 )
            //                                     : Container(
            //                                     color: Colors.grey),
            //                               ),
            //                               width: 200,
            //                             ),
            //                           ),
            //                           Padding(
            //                             padding: const EdgeInsets.only(
            //                                 top: 5.0, left: 5.0),
            //                             child: Text(
            //                               product.title ?? "",
            //                               style:
            //
            //                               Theme.of(context)
            //                                   .textTheme
            //                                   .titleSmall
            //                                   ?.copyWith(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),
            //
            //                             ),
            //                           ),
            //                           Padding(
            //                             padding: const EdgeInsets.only(
            //                                 top: 2.0, left: 5.0),
            //                             child: Text(
            //                               "Rs. " + getAmount,
            //                               style:  Theme.of(context)
            //                                   .textTheme
            //                                   .bodyLarge
            //                                   ?.copyWith(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),
            //                             ),
            //                           ),
            //                           Padding(
            //                             padding: const EdgeInsets.only(
            //                                 top: 8.0),
            //                             child: Visibility(
            //                               child: Row(
            //                                 children: [
            //                                   IconButton(
            //                                     icon: Icon(
            //                                       Icons.delete,
            //                                       color: Constants
            //                                           .secondary3,
            //                                     ),
            //                                     onPressed: () {
            //                                       _singleton
            //                                           .showAlertDialog(
            //                                         context: context,
            //                                         title:
            //                                         "Are you sure?",
            //                                         message:
            //                                         "Do you want to delete this Product?",
            //                                         onCancelPressed:
            //                                             () {},
            //                                         onOkPressed: () {
            //                                           _deleteTicket(
            //                                               getDocId,
            //                                               product
            //                                                   .fileUrls);
            //                                         },
            //                                       );
            //                                     },
            //                                   ),
            //                                   IconButton(
            //                                     onPressed: () async {
            //                                       _singleton
            //                                           .showAlertDialog(
            //                                         context: context,
            //                                         title:
            //                                         "Are you sure?",
            //                                         message:
            //                                         "Do you want to Post Notification for this Product?",
            //                                         onCancelPressed:
            //                                             () {},
            //                                         onOkPressed:
            //                                             () async {
            //                                           Response?
            //                                           getResult =
            //                                           await NotificationService
            //                                               .postNotificationWithImage(
            //                                             "Get $getTitle for Rs.$getAmount ✨",
            //                                             "Try bargaining for the best prices on your favorite products 🪑💰🔦🛵⚽️",
            //                                             product.fileUrls[
            //                                             0] ??
            //                                                 null,
            //                                           );
            //
            //                                           getResult?.statusCode ==
            //                                               200
            //                                               ? Constants.showToast(
            //                                               "Posted Notification to Maaka Users",
            //                                               ToastGravity
            //                                                   .BOTTOM)
            //                                               : Constants.showToast(
            //                                               "Problem in sending Notification!",
            //                                               ToastGravity
            //                                                   .BOTTOM);
            //                                         },
            //                                       );
            //                                     },
            //                                     icon: Icon(
            //                                       Icons.notification_add,
            //                                       color: Constants
            //                                           .secondary3,
            //                                     ),
            //                                   ),
            //                                 ],
            //                               ),
            //                               visible: Constants.isAdmin,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 );
            //               },
            //             ),
            //           ],
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //         ),
            //       ],
            //     );
            //   },
            // )
          ]),
        ),
      ),
      // floatingActionButton: Visibility(
      //   visible: Constants.isAdmin,
      //   child: FloatingActionButton(
      //     backgroundColor: FlutterFlowTheme.of(context).primary,
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => CreateNewProductScreen(),
      //         ),
      //       );
      //     },
      //     child: Icon(
      //       Icons.add,
      //       color: FlutterFlowTheme.of(context).secondary,
      //     ),
      //   ),
      // ),
    );
  }

  Future<void> _deleteTicket(String docId, List<dynamic> fileUrls) async {
    _isDeleting.value = true;

    try {
      // Delete the files from Firebase Storage if they exist
      for (String fileUrl in fileUrls) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.refFromURL(fileUrl);
        await ref.delete();
      }

      // Delete the document from Firestore
      await FirebaseFirestore.instance
          .collection('banners')
          .doc(docId)
          .delete();
    } catch (e) {
      // Handle any errors here
      print('Error deleting ticket: $e');
    } finally {
      _isDeleting.value = false;
    }
  }

  // static Future<Response?> postNotificationWithImage(
  //     String getToken,
  //     String getTitleMessage,
  //     String getBodyMessage,
  //     String? getProductImage) async {
  //   String fileId = _extractFileId(
  //       "https://drive.google.com/file/d/1wANZHruoYJ5uO-q8bdt-jIz4MSu2seh8/view?usp=sharing");
  //
  //   // Convert to a direct link
  //   String? directImageUrl =
  //       'https://drive.google.com/uc?export=view&id=$fileId';
  //
  //   Response? res;
  //   var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
  //
  //   try {
  //     var response = await http.Client().post(url,
  //         body: jsonEncode({
  //           "to": getToken ?? "",
  //           "priority": "high",
  //           "notification": {
  //             "title": getTitleMessage,
  //             "body": getBodyMessage,
  //             "image": getProductImage ?? directImageUrl,
  //           },
  //           "data": {
  //             "custom_key":
  //                 "custom_value" // Optional: You can include custom data here
  //           }
  //         }),
  //         headers: {
  //           "Accept": "application/json",
  //           "Content-type": "application/json",
  //           "Authorization":
  //               "key=AAAAb-_MBP8:APA91bFubSJ4pOcNkYMD9uFXekSyOQel1Mzojc1Q7noOPRiR-WNu_C_FgoZ-lQ6Maa1A52NqAoLM7tdQTZ7nEeXs_WUhhqjUg5B0P2lCp2rf95PxdR0PaOSVZUz8UeWJArogfm3gFKRp",
  //         });
  //
  //     var body = response.body;
  //     print("JSON Response -- $body");
  //     if (response.statusCode == 200) {
  //       body = await response.body;
  //     }
  //     res = Response(response.statusCode, body);
  //   } on SocketException catch (e) {
  //     print(e);
  //     res = Response(
  //         001, 'No Internet Connection\nPlease check your network status');
  //   }
  //
  //   print("res <- ${res?.resBody.toString()}");
  //   return res;
  // }

  //todo:- to convert drive link to direct link
  static String _extractFileId(String url) {
    // Extract the file ID from the Google Drive link
    final RegExp regExp = RegExp(r'/d/(.*?)/');
    final match = regExp.firstMatch(url);
    if (match != null && match.groupCount > 0) {
      return match.group(1) ?? '';
    }
    return '';
  }
}
