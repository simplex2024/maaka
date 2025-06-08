//todo:- show all food in server

//todo:- important about this screen
//1. now showing list based on admin no in constructor,
//2. add one more parameter to whether incoming parameter is user or admin,if admin, allow to update price , if user allow to order of concerned food owner



import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:maaakanmoney/components/reusable_code.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_theme.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_util.dart';
import 'package:maaakanmoney/pages/User/UserScreen_Notifer.dart';
import 'package:maaakanmoney/pages/budget_copy/BudgetCopyController.dart';
import 'package:maaakanmoney/pages/budget_copy/navigation_drawer/post_product_screen.dart';
import 'package:sizer/sizer.dart';


//todo:- this screen shows foods of each food admins collection

class AdminsFoodListScreen extends ConsumerStatefulWidget {
  final String getAdminMobile;

  AdminsFoodListScreen({Key? key, required this.getAdminMobile}) : super(key: key);

  @override
  FoodListScreenState createState() => FoodListScreenState();
}

class FoodListScreenState extends ConsumerState<AdminsFoodListScreen>
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
    '0': 'All',
    '1': 'Main Course',
    '2': 'Gravy',
    '3': 'Starters',
    '4': 'Desserts',
    '5': 'Juices',
    '6': 'Ice Creams',
    '7': 'Tiffin',
    '8': 'Lunch',
  };

  List<FoodList>? getFoodList = [];


  final ValueNotifier<String> _searchQuery = ValueNotifier<String>("");
  final ValueNotifier<int> _selectedCategoryIndex = ValueNotifier<int>(0);
  final Map<int, ValueNotifier<int>> _selectedIndexNotifiers = {};

  final double itemWidth = 160.0;
  final Map<int, ScrollController> _scrollControllers = {};
  @override
  void initState() {
    // TODO: implement initState

    // getFoodList = ref.read(UserDashListProvider.notifier).categoryProducts;
    getFoodList = ref
        .read(adminDashListProvider.notifier)
        .foodList;

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
                                color:
                                FlutterFlowTheme.of(context).secondary,
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
                                      valueListenable:
                                      _selectedCategoryIndex,
                                      builder:
                                          (context, selectedIndex, child) {
                                        // List<FoodList> filteredItems =
                                        //     _getFilteredItems();

                                        List<FoodList>? filteredItems =
                                        query.isNotEmpty
                                            ? ref
                                            .read(
                                            UserDashListProvider
                                                .notifier)
                                            .categoryProducts
                                            ?.where((item) => (item
                                            .title ??
                                            "")
                                            .toLowerCase()
                                            .contains(query
                                            .toLowerCase()))
                                            .toList()
                                            : _getFoodItemsByProdCode(
                                            _categoryMapping.keys
                                                .toList()[
                                            selectedIndex]);

                                        return ListView.builder(
                                          itemCount:
                                          _categoryMapping.length,
                                          itemBuilder:
                                              (context, sectionIndex) {
                                            var categoryKeys =
                                            _categoryMapping.keys
                                                .toList();
                                            String prodCode =
                                            categoryKeys[sectionIndex];

                                            print(ref
                                                .read(UserDashListProvider
                                                .notifier)
                                                .categoryProducts);

                                            // categoryProducts = ref
                                            //     .read(adminDashListProvider
                                            //     .notifier)
                                            //     .foodList;

                                            // List<FoodList>? sectionItems =
                                            // _getFoodItemsByProdCode(
                                            //     prodCode);
                                            // if ((sectionItems ?? []).isEmpty)
                                            //   return const SizedBox.shrink();

                                            List<FoodList> sectionItems =
                                            (filteredItems ?? [])
                                                .where((item) =>
                                            item.productCategory ==
                                                prodCode)
                                                .toList();
                                            if (sectionItems.isEmpty)
                                              return const SizedBox
                                                  .shrink();

                                            return Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      8.0),
                                                  child: Text(
                                                    '${_categoryMapping[prodCode]} ',
                                                    style: const TextStyle(
                                                        fontFamily:
                                                        'Encode Sans Condensed',
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
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
                                                    itemCount: sectionItems
                                                        ?.length,
                                                    padding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 80),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Center(
                                                        child:
                                                        GestureDetector(
                                                          onTap: () {
                                                            _selectedIndexNotifiers[
                                                            sectionIndex]!
                                                                .value = index;
                                                            _scrollToIndex(
                                                                sectionIndex,
                                                                index);

                                                            FoodList?
                                                            product =
                                                            sectionItems?[
                                                            index];

                                                            String?
                                                            getAmount =
                                                                product?.amount ??
                                                                    "";
                                                            String?
                                                            getTitle =
                                                                product?.title ??
                                                                    "";
                                                            String?
                                                            getDocId =
                                                                product?.docID ??
                                                                    "";
                                                            String?
                                                            getDescription =
                                                                product?.description ??
                                                                    "";

                                                            String?
                                                            getFoodAdminNo =
                                                                product?.getFoodAdminNo ??
                                                                    "";

                                                            final List<
                                                                dynamic>
                                                            imageUrls =
                                                                product?.fileUrls ??
                                                                    [];
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => CreateNewFood(
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
                                                                    getIsUpdatingFoodPrice:
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
                                                              bool
                                                              isSelected =
                                                                  index ==
                                                                      selectedIndex;
                                                              return AnimatedContainer(
                                                                duration: const Duration(
                                                                    milliseconds:
                                                                    300),
                                                                curve: Curves
                                                                    .easeInOut,
                                                                child:
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                      10.0,
                                                                      right:
                                                                      10),
                                                                  child: Transform
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
                                                                          color: Colors.white,
                                                                          borderRadius: BorderRadius.circular(12),
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
                                                                                          message: "Do you want to Delete this Food Item?",
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

                              //  ListView.builder(
                              //
                              //   scrollDirection: Axis.vertical,
                              //   itemCount: _categories.length,
                              //   itemBuilder: (context, index) {
                              //     String category =
                              //         _categories[index];
                              //     String categoryId =
                              //         _categoryMapping.entries
                              //             .firstWhere((element) =>
                              //                 element.value ==
                              //                 category)
                              //             .key;
                              //
                              //      categoryProducts =
                              //         ref
                              //             .read(
                              //                 adminDashListProvider
                              //                     .notifier)
                              //             .foodList
                              //             ?.where((product) =>
                              //                 product
                              //                     .productCategory ==
                              //                 categoryId)
                              //             .toList();
                              //
                              //     if (categoryProducts == null) {
                              //       return Container();
                              //     }
                              //
                              //     return Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.start,
                              //       children: [
                              //         (categoryProducts ?? []).isEmpty
                              //             ? Container()
                              //             : Column(
                              //                 crossAxisAlignment:
                              //                     CrossAxisAlignment
                              //                         .start,
                              //                 children: [
                              //                   Padding(
                              //                     padding:
                              //                         const EdgeInsets
                              //                             .only(
                              //                             left:
                              //                                 8.0),
                              //                     child: Text(
                              //                         category,
                              //                         style: Theme.of(
                              //                                 context)
                              //                             .textTheme
                              //                             .titleLarge),
                              //                   ),
                              //                   SizedBox(
                              //                     height: 30.h,
                              //                     // Set static height for the GridView
                              //                     child: GridView
                              //                         .builder(
                              //                       shrinkWrap:
                              //                           true,
                              //                       physics:
                              //                           NeverScrollableScrollPhysics(),
                              //                       padding:
                              //                           const EdgeInsets
                              //                               .all(
                              //                               8.0),
                              //                       gridDelegate:
                              //                           SliverGridDelegateWithFixedCrossAxisCount(
                              //                         crossAxisCount:
                              //                             2,
                              //                         crossAxisSpacing:
                              //                             8.0,
                              //                         mainAxisSpacing:
                              //                             8.0,
                              //                         childAspectRatio:
                              //                             0.8, // Adjust ratio as needed
                              //                       ),
                              //                       itemCount:
                              //                           categoryProducts
                              //                               ?.length,
                              //                       itemBuilder:
                              //                           (context,
                              //                               index) {
                              //                         FoodList?
                              //                             product =
                              //                             categoryProducts?[
                              //                                 index];
                              //
                              //                         String?
                              //                             getAmount =
                              //                             product?.amount ??
                              //                                 "";
                              //                         String?
                              //                             getTitle =
                              //                             product?.title ??
                              //                                 "";
                              //                         String?
                              //                             getDocId =
                              //                             product?.docID ??
                              //                                 "";
                              //                         String?
                              //                             getDescription =
                              //                             product?.description ??
                              //                                 "";
                              //                         final List<
                              //                                 dynamic>
                              //                             imageUrls =
                              //                             (product ?? FoodList(amount: "N/A", description: "N/A", fileUrls: [], minBargainAmount: "N/A", productCategory: "N/A", productDetails: "N/A", productSpec: "N/A", title: "N/A", docID: "N/A"))
                              //                                 .fileUrls ?? [];
                              //
                              //                         return SizedBox(
                              //                           height: 250,
                              //                           // Set a fixed height for each grid item
                              //                           child:
                              //                               GridTile(
                              //                             child:
                              //                                 GestureDetector(
                              //                               onTap:
                              //                                   () {
                              //                                 Navigator
                              //                                     .push(
                              //                                   context,
                              //                                   MaterialPageRoute(
                              //                                     builder: (context) => FoodDetailScreen(
                              //                                       title: getTitle,
                              //                                       description: getDescription,
                              //                                       affiliateLink: "",
                              //                                       prodDetails: "getProdDetails",
                              //                                       prodSpec: "getProdSpec",
                              //                                       imageUrls: imageUrls,
                              //                                       amount: getAmount,
                              //                                       userName: ref.read(UserDashListProvider.notifier).getUser ?? "",
                              //                                       getAdminType: ref.read(UserDashListProvider.notifier).getAdminType ?? "",
                              //                                       minBargainAmount: "",
                              //                                       getHeroTag: 'imageHero$index',
                              //                                     ),
                              //                                   ),
                              //                                 );
                              //                               },
                              //                               child:
                              //                                   Container(
                              //                                 decoration:
                              //                                     BoxDecoration(
                              //                                   color:
                              //                                       _singleton.lighten(
                              //                                     Constants.secondary2,
                              //                                     amount: _singleton.generateRandomColorDouble(),
                              //                                   ),
                              //                                   borderRadius:
                              //                                       BorderRadius.circular(15.0),
                              //                                 ),
                              //                                 child:
                              //                                     Column(
                              //                                   mainAxisAlignment:
                              //                                       MainAxisAlignment.spaceBetween,
                              //                                   crossAxisAlignment:
                              //                                       CrossAxisAlignment.start,
                              //                                   children: [
                              //                                     Expanded(
                              //                                       flex: 3,
                              //                                       child: ClipRRect(
                              //                                         borderRadius: const BorderRadius.only(
                              //                                           topLeft: Radius.circular(15),
                              //                                           topRight: Radius.circular(15),
                              //                                         ),
                              //                                         child:  (product ?? FoodList(amount: "N/A", description: "N/A", fileUrls: [], minBargainAmount: "N/A", productCategory: "N/A", productDetails: "N/A", productSpec: "N/A", title: "N/A", docID: "N/A")).fileUrls.isNotEmpty
                              //                                             ? Hero(
                              //                                                 tag: 'imageHero$index$getTitle$getAmount',
                              //                                                 child: Image.network(
                              //                                                   (product ?? FoodList(amount: "N/A", description: "N/A", fileUrls: [], minBargainAmount: "N/A", productCategory: "N/A", productDetails: "N/A", productSpec: "N/A", title: "N/A", docID: "N/A")).fileUrls[0],
                              //                                                   fit: BoxFit.cover,
                              //                                                   width: double.infinity,
                              //                                                   height: double.infinity,
                              //                                                   loadingBuilder: (context, child, loadingProgress) {
                              //                                                     if (loadingProgress == null) return child;
                              //                                                     return Center(
                              //                                                       child: CircularProgressIndicator(
                              //                                                         value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                              //                                                       ),
                              //                                                     );
                              //                                                   },
                              //                                                 ),
                              //                                               )
                              //                                             : Container(color: Colors.grey),
                              //                                       ),
                              //                                     ),
                              //                                     Padding(
                              //                                       padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                              //                                       child: Text(
                              //                                         product?.title ?? "",
                              //                                         style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                              //                                       ),
                              //                                     ),
                              //                                     Padding(
                              //                                       padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                              //                                       child: Text(
                              //                                         "Rs. $getAmount",
                              //                                         style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                              //                                       ),
                              //                                     ),
                              //                                     Visibility(
                              //                                       visible: Constants.isAdmin,
                              //                                       child: Padding(
                              //                                         padding: const EdgeInsets.only(top: 8.0),
                              //                                         child: Row(
                              //                                           children: [
                              //                                             IconButton(
                              //                                               icon: Icon(Icons.delete, color: Constants.secondary3),
                              //                                               onPressed: () {
                              //                                                 // Delete action
                              //                                               },
                              //                                             ),
                              //                                             IconButton(
                              //                                               onPressed: () async {
                              //                                                 _singleton.showAlertDialog(
                              //                                                   context: context,
                              //                                                   title: "Are you sure?",
                              //                                                   message: "Do you want to Post Notification for this Product?",
                              //                                                   onCancelPressed: () {},
                              //                                                   onOkPressed: () async {
                              //                                                     Response? getResult = await NotificationService.postNotificationWithImage(
                              //                                                       "Get $getTitle for Rs.$getAmount ✨",
                              //                                                       "Try bargaining for the best prices on your favorite products 🪑💰🔦🛵⚽️",
                              //                                                       (product ?? FoodList(amount: "N/A", description: "N/A", fileUrls: [], minBargainAmount: "N/A", productCategory: "N/A", productDetails: "N/A", productSpec: "N/A", title: "N/A", docID: "N/A")).fileUrls[0] ?? null,
                              //                                                     );
                              //
                              //                                                     getResult?.statusCode == 200 ? Constants.showToast("Posted Notification to Maaka Users", ToastGravity.BOTTOM) : Constants.showToast("Problem in sending Notification!", ToastGravity.BOTTOM);
                              //                                                   },
                              //                                                 );
                              //                                               },
                              //                                               icon: Icon(Icons.notification_add, color: Constants.secondary3),
                              //                                             ),
                              //                                           ],
                              //                                         ),
                              //                                       ),
                              //                                     ),
                              //                                   ],
                              //                                 ),
                              //                               ),
                              //                             ),
                              //                           ),
                              //                         );
                              //                       },
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //       ],
                              //     );
                              //
                              //     //todo:- food section
                              //    // return Center(
                              //    //    child: GestureDetector(
                              //    //      onTap: () {
                              //    //        _selectedIndexNotifier.value = index;
                              //    //        _scrollToIndex(index);
                              //    //      },
                              //    //      child: ValueListenableBuilder<int>(
                              //    //        valueListenable: _selectedIndexNotifier,
                              //    //        builder: (context, selectedIndex, child) {
                              //    //          bool isSelected = index == selectedIndex;
                              //    //          return AnimatedContainer(
                              //    //            duration: const Duration(milliseconds: 300),
                              //    //            curve: Curves.easeInOut,
                              //    //            child: Padding(
                              //    //              padding: const EdgeInsets.only(left: 10.0, right: 10),
                              //    //              child: Transform.scale(
                              //    //                scale: isSelected ? 1.2 : 0.9,
                              //    //                child: Opacity(
                              //    //                  opacity: isSelected ? 1.0 : 0.6,
                              //    //                  child: Stack(
                              //    //                    clipBehavior: Clip.none,
                              //    //                    children: [
                              //    //                      Container(
                              //    //                        width: 160,
                              //    //                        height: 220,
                              //    //                        decoration: BoxDecoration(
                              //    //                          color: Colors.white,
                              //    //                          borderRadius: BorderRadius.circular(12),
                              //    //                          boxShadow: [
                              //    //                            BoxShadow(
                              //    //                              color: Colors.grey.withOpacity(0.4),
                              //    //                              blurRadius: 10,
                              //    //                              spreadRadius: 3,
                              //    //                            )
                              //    //                          ],
                              //    //                        ),
                              //    //                        child: Padding(
                              //    //                          padding: const EdgeInsets.only(top: 0.0),
                              //    //                          child: Column(
                              //    //                            mainAxisAlignment: MainAxisAlignment.end,
                              //    //                            children: [
                              //    //                              Text(
                              //    //                                "name",
                              //    //                                style: TextStyle(
                              //    //                                  color: isSelected ? Colors.black : Colors.grey,
                              //    //                                  fontSize: isSelected ? 18 : 14,
                              //    //                                  fontWeight: FontWeight.bold,
                              //    //                                ),
                              //    //                              ),
                              //    //                              const SizedBox(height: 4),
                              //    //                              Text(
                              //    //                                '₹400',
                              //    //                                style: const TextStyle(
                              //    //                                  fontSize: 16,
                              //    //                                  fontWeight: FontWeight.bold,
                              //    //                                  color: Colors.green,
                              //    //                                ),
                              //    //                              ),
                              //    //                              Text(
                              //    //                                '₹550',
                              //    //                                style: const TextStyle(
                              //    //                                  fontSize: 14,
                              //    //                                  color: Colors.red,
                              //    //                                  decoration: TextDecoration.lineThrough,
                              //    //                                ),
                              //    //                              ),
                              //    //                              const SizedBox(height: 10),
                              //    //                            ],
                              //    //                          ),
                              //    //                        ),
                              //    //                      ),
                              //    //                      Positioned(
                              //    //                        top: -20,
                              //    //                        left: 20,
                              //    //                        child: Container(
                              //    //                          width: 100,
                              //    //                          height: 100,
                              //    //                          decoration: BoxDecoration(
                              //    //                            boxShadow: [
                              //    //                              BoxShadow(
                              //    //                                color: Colors.grey.withOpacity(0.3),
                              //    //                                blurRadius: 10,
                              //    //                                spreadRadius: 2,
                              //    //                              ),
                              //    //                            ],
                              //    //                          ),
                              //    //                          child: ClipRRect(
                              //    //                            borderRadius: BorderRadius.circular(50),
                              //    //                            child: Image.asset(
                              //    //                              "foodItems[index].imagePath",
                              //    //                              fit: BoxFit.cover,
                              //    //                            ),
                              //    //                          ),
                              //    //                        ),
                              //    //                      ),
                              //    //                    ],
                              //    //                  ),
                              //    //                ),
                              //    //              ),
                              //    //            ),
                              //    //          );
                              //    //        },
                              //    //      ),
                              //    //    ),
                              //    //  );
                              //   },
                              // )
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                )),




            //todo:-25.3.25
            // StreamBuilder(
            //   stream:
            //
            //   // FirebaseFirestore.instance
            //   //     .collectionGroup('Foods') // ✅ Fetches all "Foods"
            //   //     .snapshots(),
            //
            //   FirebaseFirestore
            //       .instance
            //       .collection(
            //       'AreaFoodPrices').doc(widget.getAdminMobile ?? "").collection("Foods")
            //       .snapshots(),
            //   builder: (context,
            //       AsyncSnapshot<
            //           QuerySnapshot>
            //       snapshot) {
            //     if (!snapshot.hasData) {
            //       return Center(
            //           child:
            //           CircularProgressIndicator());
            //     }
            //
            //     if (snapshot.data!.docs ==
            //         null ||
            //         snapshot.data!.docs
            //             .isEmpty) {
            //       return Center(
            //         child: Column(
            //           mainAxisAlignment:
            //           MainAxisAlignment
            //               .spaceEvenly,
            //           crossAxisAlignment:
            //           CrossAxisAlignment
            //               .center,
            //           children: [
            //
            //             Text(
            //               "New Food Partners are About to Load!",
            //               style: TextStyle(
            //                   fontSize: 20,
            //                   fontWeight:
            //                   FontWeight
            //                       .bold),
            //               textAlign:
            //               TextAlign
            //                   .center,
            //             ),
            //             Text(
            //               "Cheers to Smart Food Buying Plans.",
            //               textAlign:
            //               TextAlign
            //                   .center,
            //             ),
            //           ],
            //         ),
            //       );
            //     }
            //
            //     return ListView.builder(
            //       shrinkWrap: true,
            //       physics:
            //       NeverScrollableScrollPhysics(),
            //       itemCount: snapshot
            //           .data!.docs.length,
            //       itemBuilder: (context, index) {
            //         if (index > 2) {
            //           return SizedBox
            //               .shrink(); // Return an empty widget for transactions beyond the last three
            //         }
            //
            //         var doc = snapshot
            //             .data!.docs[index];
            //
            //
            //         String getFoodTitle = (doc
            //             .data()
            //         as Map<
            //             String,
            //             dynamic>?)
            //             ?.containsKey(
            //             'title') ??
            //             false
            //             ? doc['title']
            //             : "";
            //
            //         String getFoodAmount = (doc
            //             .data()
            //         as Map<
            //             String,
            //             dynamic>?)
            //             ?.containsKey(
            //             'amount') ??
            //             false
            //             ? doc['amount']
            //             : "";
            //
            //         return Container(
            //           color: Constants.secondary
            //               .withOpacity(0.95),
            //           child: Padding(
            //             padding:
            //             const EdgeInsets.all(5),
            //             child: Card(
            //               shape: RoundedRectangleBorder(
            //                 borderRadius:
            //                 BorderRadius.circular(
            //                     6.0),
            //               ),
            //               color:  Constants.secondary,
            //               elevation: 4.0,
            //               child: ListTile(
            //                 leading: Card(
            //                   color:  FlutterFlowTheme.of(
            //                       context)
            //                       .primary
            //                   ,
            //                   clipBehavior: Clip
            //                       .antiAliasWithSaveLayer,
            //                   elevation: 5.0,
            //                   shape:
            //                   RoundedRectangleBorder(
            //                     borderRadius:
            //                     BorderRadius
            //                         .circular(8.0),
            //                   ),
            //                   child: Padding(
            //                     padding:
            //                     const EdgeInsets
            //                         .all(8.0),
            //                     child: Icon(
            //                       Icons
            //                           .food_bank,
            //                       color: Constants
            //                           .secondary,
            //                       size: 24.0,
            //                     ),
            //                   ),
            //                 ),
            //                 title: Text(
            //                   getFoodTitle ?? "N/A",
            //                   style: Theme.of(context)
            //                       .textTheme
            //                       .bodyLarge
            //                       ?.copyWith(
            //                       color:Constants
            //                           .primary,
            //                       fontWeight:
            //                       FontWeight
            //                           .bold,
            //                       overflow:
            //                       TextOverflow
            //                           .ellipsis),
            //                 ),
            //                 subtitle: Text(
            //                   getFoodAmount ?? "N/A",
            //                   style: Theme.of(context)
            //                       .textTheme
            //                       .bodyMedium
            //                       ?.copyWith(
            //                       color: Colors
            //                           .black,
            //                       fontWeight:
            //                       FontWeight
            //                           .bold,
            //                       overflow:
            //                       TextOverflow
            //                           .ellipsis),
            //                 ),
            //
            //                 onTap: () {},
            //               ),
            //             ),
            //           ),
            //         );
            //       },
            //     );
            //   },
            // ),

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

  List<FoodList>? _getFoodItemsByProdCode(String prodCode) {
    print(prodCode);
    if (prodCode == '0') {
      return ref
          .read(adminDashListProvider.notifier)
          .foodList;
    }
    return ref
        .read(adminDashListProvider.notifier)
        .foodList
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
          .collection('AreaFoodPrices')
          .doc(Constants.adminNo2)
          .collection("Foods")
          .doc(docId ?? "")
          .delete();


      if(mounted){


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
          "Image Not Found To Delete! \nLets Delete Record and Exit!\nRefresh User List to See updated Food List",
          onCancelPressed: () {
            _isDeleting.value = false;
          },
          onOkPressed: () async {
            try {
              await FirebaseFirestore.instance
                  .collection('AreaFoodPrices')
                  .doc(Constants.adminNo2)
                  .collection("Foods")
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
    //   setState(() {
    //   // _handleRefresh();
    //   });
    // }
  }
  void _updateSelectedIndex(int sectionIndex) {
    double offset = _scrollControllers[sectionIndex]!.offset;
    int centerIndex = (offset / itemWidth).round();
    var categoryKeys = _categoryMapping.keys.toList();
    String prodCode = categoryKeys[sectionIndex];
    int? itemCount = _getFoodItemsByProdCode(prodCode)?.length;

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