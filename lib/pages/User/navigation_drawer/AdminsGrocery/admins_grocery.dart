import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:maaakanmoney/components/reusable_code.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_theme.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_util.dart';
import 'package:maaakanmoney/pages/User/UserScreen_Notifer.dart';
import 'package:maaakanmoney/pages/budget_copy/BudgetCopyController.dart';
import 'package:maaakanmoney/pages/budget_copy/navigation_drawer/post_product_screen.dart';
import 'package:sizer/sizer.dart';

class AdminsGroceryListScreen extends ConsumerStatefulWidget {
  final String getAdminMobile;

  AdminsGroceryListScreen({Key? key, required this.getAdminMobile})
      : super(key: key);

  @override
  GroceryListScreenState createState() => GroceryListScreenState();
}

class GroceryListScreenState extends ConsumerState<AdminsGroceryListScreen>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<bool> _isDeleting = ValueNotifier<bool>(false);
  final SingletonReusableCode _singleton = SingletonReusableCode();

  final Map<String, String> _categoryMapping = {
    '0': 'All',
    '1': 'Daily Needs',
    '2': 'Weekly Needs',
    '3': 'Monthly Needs',
    '4': 'Milk',
    '5': 'Maavu',
    '6': 'Water Can',
  };

  List<GroceryList>? getGroceryList = [];

  final ValueNotifier<String> _searchQuery = ValueNotifier<String>("");
  final ValueNotifier<int> _selectedCategoryIndex = ValueNotifier<int>(0);
  final Map<int, ValueNotifier<int>> _selectedIndexNotifiers = {};

  final double itemWidth = 160.0;
  final Map<int, ScrollController> _scrollControllers = {};

  @override
  void initState() {
    // TODO: implement initState

    getGroceryList = ref.read(adminDashListProvider.notifier).groceryList;

    super.initState();
    getNotificationAccessToken();

    for (int i = 0; i < _categoryMapping.length; i++) {
      _scrollControllers[i] = ScrollController();
      _selectedIndexNotifiers[i] = ValueNotifier<int>(0);
      _scrollControllers[i]!.addListener(() => _onScroll(i));
    }
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
                  "Grocery Deals",
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
            Container(
                height: 100.h,
                child: Stack(
                  children: [
                    CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Center(
                            child: Container(
                              alignment: Alignment.center,
                              height: 100.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondary,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: ValueListenableBuilder<String>(
                                  valueListenable: _searchQuery,
                                  builder: (context, query, child) {
                                    return ValueListenableBuilder<int>(
                                      valueListenable: _selectedCategoryIndex,
                                      builder: (context, selectedIndex, child) {
                                        List<GroceryList>? filteredItems = query
                                                .isNotEmpty
                                            ? ref
                                                .read(UserDashListProvider
                                                    .notifier)
                                                .categoryGroceryProducts
                                                ?.where((item) => (item.title ??
                                                        "")
                                                    .toLowerCase()
                                                    .contains(
                                                        query.toLowerCase()))
                                                .toList()
                                            : _getGroceryItemsByProdCode(
                                                _categoryMapping.keys
                                                    .toList()[selectedIndex]);

                                        return ListView.builder(
                                          itemCount: _categoryMapping.length,
                                          itemBuilder: (context, sectionIndex) {
                                            var categoryKeys =
                                                _categoryMapping.keys.toList();
                                            String prodCode =
                                                categoryKeys[sectionIndex];

                                            print(ref
                                                .read(UserDashListProvider
                                                    .notifier)
                                                .categoryGroceryProducts);

                                            List<GroceryList> sectionItems =
                                                (filteredItems ?? [])
                                                    .where((item) =>
                                                        item.productCategory ==
                                                        prodCode)
                                                    .toList();
                                            if (sectionItems.isEmpty)
                                              return const SizedBox.shrink();

                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${_categoryMapping[prodCode]} ',
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            'Encode Sans Condensed',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 300,
                                                  child: ListView.builder(
                                                    controller:
                                                        _scrollControllers[
                                                            sectionIndex],
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        sectionItems?.length,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 80),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Center(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            _selectedIndexNotifiers[
                                                                    sectionIndex]!
                                                                .value = index;
                                                            _scrollToIndex(
                                                                sectionIndex,
                                                                index);

                                                            GroceryList?
                                                                product =
                                                                sectionItems?[
                                                                    index];

                                                            String? getAmount =
                                                                product?.amount ??
                                                                    "";
                                                            String? getTitle =
                                                                product?.title ??
                                                                    "";
                                                            String? getDocId =
                                                                product?.docID ??
                                                                    "";
                                                            String?
                                                                getDescription =
                                                                product?.description ??
                                                                    "";

                                                            String?
                                                                getFoodAdminNo =
                                                                product?.getGroceryAdminNo ??
                                                                    "";

                                                            final List<dynamic>
                                                                imageUrls =
                                                                product?.fileUrls ??
                                                                    [];
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => CreateNewGrocery(
                                                                    getMobNo:
                                                                        getFoodAdminNo,
                                                                    getDocId:
                                                                        getDocId,
                                                                    getTitle:
                                                                        getTitle,
                                                                    getDescription:
                                                                        getDescription,
                                                                    getAmount:
                                                                        getAmount,
                                                                    getIsUpdatingGroceryPrice:
                                                                        true),
                                                              ),
                                                            ).then((value) {
                                                              //todo:- below code refresh firebase records automatically when come back to same screen
                                                              // ref.read(adminDashListProvider.notifier).getDashboardDetails();
                                                            });
                                                          },
                                                          child:
                                                              ValueListenableBuilder<
                                                                  int>(
                                                            valueListenable:
                                                                _selectedIndexNotifiers[
                                                                    sectionIndex]!,
                                                            builder: (context,
                                                                selectedIndex,
                                                                child) {
                                                              bool isSelected =
                                                                  index ==
                                                                      selectedIndex;
                                                              return AnimatedContainer(
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            300),
                                                                curve: Curves
                                                                    .easeInOut,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          10.0,
                                                                      right:
                                                                          10),
                                                                  child:
                                                                      Transform
                                                                          .scale(
                                                                    scale: isSelected
                                                                        ? 1.2
                                                                        : 0.9,
                                                                    child:
                                                                        Opacity(
                                                                      opacity: isSelected
                                                                          ? 1.0
                                                                          : 0.6,
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            160,
                                                                        height:
                                                                            220,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.grey.withOpacity(0.4),
                                                                              blurRadius: 10,
                                                                              spreadRadius: 3,
                                                                            )
                                                                          ],
                                                                        ),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      color: Colors.white,
                                                                                      child: Center(
                                                                                        child: (sectionItems ?? [])[index].fileUrls.isNotEmpty
                                                                                            ? Hero(
                                                                                                tag: 'imageHero$index${sectionItems?[index].title}${sectionItems?[index].amount}',
                                                                                                child: FutureBuilder(
                                                                                                  future: precacheImage(
                                                                                                    NetworkImage(sectionItems?[index].fileUrls[0] ?? ''),
                                                                                                    context,
                                                                                                  ),
                                                                                                  builder: (context, snapshot) {
                                                                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                                      return CircleAvatar(
                                                                                                        radius: 80,
                                                                                                        backgroundColor: Colors.white,
                                                                                                        child: CircularProgressIndicator(),
                                                                                                      );
                                                                                                    } else {
                                                                                                      return CircleAvatar(
                                                                                                        radius: 80,
                                                                                                        backgroundImage: NetworkImage(
                                                                                                          sectionItems?[index].fileUrls[0] ?? '',
                                                                                                        ),
                                                                                                        backgroundColor: Colors.white,
                                                                                                      );
                                                                                                    }
                                                                                                  },
                                                                                                ),
                                                                                              )
                                                                                            : CircleAvatar(
                                                                                                radius: 80,
                                                                                                backgroundColor: Colors.grey,
                                                                                              ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    sectionItems?[index].title ?? "",
                                                                                    style: TextStyle(
                                                                                      color: isSelected ? Colors.black : Colors.grey,
                                                                                      fontSize: isSelected ? 18 : 14,
                                                                                      fontWeight: FontWeight.w900,
                                                                                      fontFamily: 'Encode Sans Condensed',
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    '₹${sectionItems?[index].amount}',
                                                                                    style: TextStyle(
                                                                                      fontSize: 16,
                                                                                      color: Constants.colorFoodCPrimary,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                    IconButton(
                                                                                      onPressed: () {
                                                                                        _singleton.showAlertDialog(
                                                                                          context: context,
                                                                                          title: "Are you sure?",
                                                                                          message: "Do you want to Delete this Grocery Item?",
                                                                                          onCancelPressed: () {},
                                                                                          onOkPressed: () async {
                                                                                            _deleteTicket(sectionItems?[index].docID ?? "", sectionItems?[index].fileUrls ?? []);
                                                                                          },
                                                                                        );
                                                                                      },
                                                                                      icon: Icon(
                                                                                        Icons.delete,
                                                                                        color: Constants.colorFoodCPrimary,
                                                                                        size: 20,
                                                                                      ),
                                                                                    ),
                                                                                  ])
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            // Heart Icon in Top-Right
                                                                            Positioned(
                                                                              top: 8,
                                                                              right: 8,
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  shape: BoxShape.circle,
                                                                                  border: Border.all(color: Colors.transparent, width: 2),
                                                                                  color: Colors.white.withOpacity(0.1),
                                                                                ),
                                                                                padding: EdgeInsets.all(4),
                                                                                child: Icon(
                                                                                  isSelected ? Icons.favorite : null,
                                                                                  color: isSelected ? Colors.redAccent : null,
                                                                                  size: 20,
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            ValueListenableBuilder<bool>(
                                                                              valueListenable: _isDeleting,
                                                                              builder: (context, isCreating, child) {
                                                                                if (isCreating) {
                                                                                  return Container(
                                                                                    // color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
                                                                                    child: Center(
                                                                                      child: CircularProgressIndicator(),
                                                                                    ),
                                                                                  );
                                                                                }
                                                                                return SizedBox.shrink();
                                                                              },
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          physics: BouncingScrollPhysics(),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
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

  List<GroceryList>? _getGroceryItemsByProdCode(String prodCode) {
    print(prodCode);
    if (prodCode == '0') {
      return ref.read(adminDashListProvider.notifier).groceryList;
    }
    return ref
        .read(adminDashListProvider.notifier)
        .groceryList
        ?.where((item) => item.productCategory == prodCode)
        .toList();
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
          .collection('AreaGroceryPrices')
          .doc(Constants.adminNo2)
          .collection("Grocery")
          .doc(docId ?? "")
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
              "Image Not Found To Delete! \nLets Delete Record and Exit!\nRefresh User List to See updated Grocery List",
          onCancelPressed: () {
            _isDeleting.value = false;
          },
          onOkPressed: () async {
            try {
              await FirebaseFirestore.instance
                  .collection('AreaGroceryPrices')
                  .doc(Constants.adminNo2)
                  .collection("Grocery")
                  .doc(docId ?? "")
                  .delete();

              _isDeleting.value = false;

              Navigator.pop(context);
            } catch (e) {
              _isDeleting.value = false;

              _singleton.showAlertDialog(
                context: context,
                title: "Message",
                message: "Unable to Delete Grocery Record",
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
    //
    //   if(mounted){
    //
    //
    //     Navigator.pop(context);
    //   }
    //   // setState(() {
    //   //   // _handleRefresh();
    //   // });
    // }
  }

  void _updateSelectedIndex(int sectionIndex) {
    double offset = _scrollControllers[sectionIndex]!.offset;
    int centerIndex = (offset / itemWidth).round();
    var categoryKeys = _categoryMapping.keys.toList();
    String prodCode = categoryKeys[sectionIndex];
    int? itemCount = _getGroceryItemsByProdCode(prodCode)?.length;

    if (_scrollControllers[sectionIndex]!.position.pixels >=
        _scrollControllers[sectionIndex]!.position.maxScrollExtent) {
      centerIndex = (itemCount ?? 0) - 1;
    }

    if (centerIndex != _selectedIndexNotifiers[sectionIndex]!.value) {
      _selectedIndexNotifiers[sectionIndex]!.value =
          max(0, min(centerIndex, (itemCount ?? 0) - 1));
    }
  }

  void _scrollToIndex(int sectionIndex, int index, {bool animate = true}) {
    double targetOffset = index * itemWidth;

    if (animate) {
      _scrollControllers[sectionIndex]!.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollControllers[sectionIndex]!.jumpTo(targetOffset);
    }
  }

  void _onScroll(int sectionIndex) {
    _updateSelectedIndex(sectionIndex);
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
