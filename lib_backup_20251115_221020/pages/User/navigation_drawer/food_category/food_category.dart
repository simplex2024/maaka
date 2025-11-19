

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_theme.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_util.dart';
import 'package:maaakanmoney/pages/User/UserScreen_Notifer.dart';
import 'package:maaakanmoney/pages/User/navigation_drawer/order_food/create_foodOrder.dart';
import 'package:maaakanmoney/pages/budget_copy/BudgetCopyController.dart';
import 'package:sizer/sizer.dart';

class FoodCategoryScreen extends ConsumerStatefulWidget {
  FoodCategoryScreen({
    Key? key,
    @required this.selectedCategoryIndex,

  }) : super(key: key);
  int? selectedCategoryIndex;

  @override
  _FoodCategoryScreenState createState() => _FoodCategoryScreenState();
}

class _FoodCategoryScreenState extends ConsumerState<FoodCategoryScreen> {


  final double itemWidth = 160.0;
  final Map<int, ScrollController> _scrollControllers = {};
  final Map<int, ValueNotifier<int>> _selectedIndexNotifiers = {};
  final ValueNotifier<String> _searchQuery = ValueNotifier<String>("");
  TextEditingController getSearchText = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();


  final ValueNotifier<int> _selectedCategoryIndex = ValueNotifier<int>(0);
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



  @override
  void dispose() {
    getSearchText.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    // Delay time initialization until the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });

    for (int i = 0; i < _categoryMapping.length; i++) {
      _scrollControllers[i] = ScrollController();
      _selectedIndexNotifiers[i] = ValueNotifier<int>(0);
      _scrollControllers[i]!.addListener(() => _onScroll(i));

      // _selectedCategoryIndex.value = widget.selectedCategoryIndex ?? 0;
    }
  }

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
            child:  Container(
            color: Constants.secondary,
            height: 100.h,
            child: Stack(
              children: [
                // Portion A (Background)
                Container(
                    height: 100.h,
                    child: Stack(
                      children: [
                        // RefreshIndicator(
                          // onRefresh: _handleRefresh,
                          // child:

                          CustomScrollView(
                            slivers: [

                              SliverToBoxAdapter(
                                child: Center(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 15.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Constants
                                              .colorFoodCSecondaryWhite,
                                          // Light gray background
                                          borderRadius:
                                          BorderRadius.circular(30),
                                          // Smooth corners
                                          boxShadow: [
                                            BoxShadow(
                                              color: Constants
                                                  .colorFoodCSecondaryGrey2,
                                              // Light shadow effect
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                              offset: Offset(0,
                                                  4), // Slight downward shadow
                                            ),
                                          ],
                                        ),
                                        child: TextField(
                                          controller: getSearchText,
                                            focusNode: _searchFocusNode,
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                fontFamily:
                                                'Encode Sans Condensed',
                                              ),
                                              hintText:
                                              'Search Your Favourite Food!',
                                              prefixIcon: Icon(
                                                  Icons.search,
                                                  color: Constants
                                                      .colorFoodCPrimary),
                                              border: InputBorder.none,
                                              // Remove default border
                                              contentPadding:
                                              EdgeInsets.symmetric(
                                                  vertical: 15,
                                                  horizontal: 20),
                                            ),
                                            onChanged: (value) {
                                              _searchQuery.value = value;
                                              _selectedCategoryIndex
                                                  .value = 0;
                                            }),
                                      ),
                                    ),


                                  ),
                                ),
                              ),

                              // SliverToBoxAdapter(
                              //   child: Center(
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(10.0),
                              //       child: Container(
                              //         color: Colors.white,
                              //         height: 10.h,
                              //         child: Center(
                              //           child: Container(
                              //             height: 5.h,
                              //             child:
                              //             ValueListenableBuilder<int>(
                              //               valueListenable:
                              //               _selectedCategoryIndex,
                              //               builder: (context,
                              //                   selectedIndex, child) {
                              //                 return ListView.builder(
                              //                   scrollDirection:
                              //                   Axis.horizontal,
                              //                   itemCount:
                              //                   _categoryMapping
                              //                       .length,
                              //                   itemBuilder:
                              //                       (context, index) {
                              //                     String category =
                              //                     _categoryMapping
                              //                         .values
                              //                         .toList()[
                              //                     index];
                              //                     return GestureDetector(
                              //                       onTap: () {
                              //                         _selectedCategoryIndex
                              //                             .value = index;
                              //                         _searchQuery.value =
                              //                         "";
                              //                       },
                              //                       child: Container(
                              //                         padding:
                              //                         const EdgeInsets
                              //                             .symmetric(
                              //                             horizontal:
                              //                             16,
                              //                             vertical:
                              //                             8),
                              //                         margin:
                              //                         const EdgeInsets
                              //                             .symmetric(
                              //                             horizontal:
                              //                             5),
                              //                         decoration:
                              //                         BoxDecoration(
                              //                           color: index ==
                              //                               selectedIndex
                              //                               ? Constants
                              //                               .colorFoodCPrimary
                              //                               : Colors
                              //                               .grey[50],
                              //                           borderRadius:
                              //                           BorderRadius
                              //                               .circular(
                              //                               15),
                              //                           // border: Border.all(
                              //                           //     color: Colors.grey),
                              //                           // Light gray background
                              //                           // Smooth corners
                              //                           // boxShadow: [
                              //                           //   BoxShadow(
                              //                           //     color: Colors.black.withOpacity(
                              //                           //         0.1), // Light shadow effect
                              //                           //     blurRadius: 10,
                              //                           //     spreadRadius: 2,
                              //                           //     offset: Offset(0,
                              //                           //         4), // Slight downward shadow
                              //                           //   ),
                              //                           // ],
                              //                         ),
                              //                         child: Center(
                              //                           child: Text(
                              //                             category,
                              //                             style:
                              //                             TextStyle(
                              //                               color: index ==
                              //                                   selectedIndex
                              //                                   ? Colors
                              //                                   .white
                              //                                   : Colors
                              //                                   .black,
                              //                               fontWeight:
                              //                               FontWeight
                              //                                   .bold,
                              //                             ),
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     );
                              //                   },
                              //                 );
                              //               },
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              SliverToBoxAdapter(
                                child: Center(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 100.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0),
                                      child:
                                      ValueListenableBuilder<String>(
                                        valueListenable: _searchQuery,
                                        builder: (context, query, child) {
                                          return ValueListenableBuilder<
                                              int>(
                                            valueListenable:
                                            _selectedCategoryIndex,
                                            builder: (context,
                                                selectedIndex, child) {
                                              // List<FoodList> filteredItems =
                                              //     _getFilteredItems();

                                              List<
                                                  FoodList>? filteredItems = query
                                                  .isNotEmpty
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
                                                  _categoryMapping
                                                      .keys
                                                      .toList()[
                                                  selectedIndex]);

                                              return ListView.builder(
                                                itemCount:
                                                _categoryMapping
                                                    .length,
                                                itemBuilder: (context,
                                                    sectionIndex) {
                                                  var categoryKeys =
                                                  _categoryMapping
                                                      .keys
                                                      .toList();
                                                  String prodCode =
                                                  categoryKeys[
                                                  sectionIndex];

                                                  print(ref
                                                      .read(
                                                      UserDashListProvider
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

                                                  List<FoodList>
                                                  sectionItems =
                                                  (filteredItems ??
                                                      [])
                                                      .where((item) =>
                                                  item.productCategory ==
                                                      prodCode)
                                                      .toList();
                                                  if (sectionItems
                                                      .isEmpty)
                                                    return const SizedBox
                                                        .shrink();

                                                  return Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(8.0),
                                                        child: Text(
                                                          '${_categoryMapping[prodCode]} ',
                                                          style: const TextStyle(
                                                              fontFamily:
                                                              'Encode Sans Condensed',
                                                              fontSize:
                                                              20,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 300,
                                                        child: ListView
                                                            .builder(
                                                          controller:
                                                          _scrollControllers[
                                                          sectionIndex],
                                                          scrollDirection:
                                                          Axis.horizontal,
                                                          itemCount:
                                                          sectionItems
                                                              ?.length,
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                              80),
                                                          itemBuilder:
                                                              (context,
                                                              index) {
                                                            return Center(
                                                              child:
                                                              GestureDetector(
                                                                onTap:
                                                                    () {
                                                                  _selectedIndexNotifiers[sectionIndex]!.value =
                                                                      index;
                                                                  _scrollToIndex(
                                                                      sectionIndex,
                                                                      index);

                                                                  FoodList?
                                                                  product =
                                                                  sectionItems?[index];

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
                                                                  final List<dynamic>
                                                                  imageUrls =
                                                                      product?.fileUrls ??
                                                                          [];

                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          FoodDetailScreen(
                                                                            title: getTitle,
                                                                            description: getDescription,
                                                                            affiliateLink: "",
                                                                            prodDetails: "getProdDetails",
                                                                            prodSpec: "getProdSpec",
                                                                            imageUrls: imageUrls,
                                                                            amount: getAmount,
                                                                            userName: ref.read(UserDashListProvider.notifier).getUser ?? "",
                                                                            getAdminType: ref.read(UserDashListProvider.notifier).getAdminType ?? "",
                                                                            minBargainAmount: "",
                                                                            getHeroTag: 'imageHero$index',
                                                                          ),
                                                                    ),
                                                                  ).then((_) {
                                                                    Navigator.pop(context);
                                                                  });;
                                                                },
                                                                child: ValueListenableBuilder<
                                                                    int>(
                                                                  valueListenable:
                                                                  _selectedIndexNotifiers[sectionIndex]!,
                                                                  builder: (context,
                                                                      selectedIndex,
                                                                      child) {
                                                                    bool
                                                                    isSelected =
                                                                        index == selectedIndex;
                                                                    return AnimatedContainer(
                                                                      duration:
                                                                      const Duration(milliseconds: 300),
                                                                      curve:
                                                                      Curves.easeInOut,
                                                                      child:
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                                                                        child: Transform.scale(
                                                                          scale: isSelected ? 1.2 : 0.9,
                                                                          child: Opacity(
                                                                            opacity: isSelected ? 1.0 : 0.6,
                                                                            child: Container(
                                                                              width: 160,
                                                                              height: 220,
                                                                              decoration: BoxDecoration(
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
                                                                              child: Stack(
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
                                                physics:
                                                BouncingScrollPhysics(),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),


                                  ),
                                ),
                              )
                            ],
                          ),
                        // ),
                        // (isLoading ?? false)
                        //     ? isRefresh == true
                        //     ? Container()
                        //     : Container(
                        //   color: Colors.transparent,
                        //   child: Center(
                        //       child: CircularProgressIndicator(
                        //         color: isRefresh == true
                        //             ? Colors.transparent
                        //             : FlutterFlowTheme.of(context)
                        //             .primary,
                        //       )),
                        // )
                        //     : Container()
                      ],
                    )),
              ],
            ),
          )
          ),
        );
      },
    );
  }

  List<FoodList>? _getFoodItemsByProdCode(String prodCode) {
    print(prodCode);
    if (prodCode == '0') {
      return ref.read(UserDashListProvider.notifier).categoryProducts;
    }
    return ref
        .read(UserDashListProvider.notifier)
        .categoryProducts
        ?.where((item) => item.productCategory == prodCode)
        .toList();
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

}
