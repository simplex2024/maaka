import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:maaakanmoney/pages/User/UserScreen_Notifer.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

import '../../../components/ListView/ListController.dart';
import '../../../components/ListView/ListPageView.dart';
import '../../../components/NotificationService.dart';
import '../../../components/constants.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../budget_copy_widget.dart';

//todo: - following class designed to post new product

class CreateNewProduct extends ConsumerStatefulWidget {
  @override
  CreateNewProductState createState() => CreateNewProductState();
}

class CreateNewProductState extends ConsumerState<CreateNewProduct> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyHomePage = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _affiliateLinkController = TextEditingController();
  final _amntController = TextEditingController();
  final _minBargainAmntController = TextEditingController();
  final _detailsController = TextEditingController();
  final _specController = TextEditingController();

  final _amazonLinkController = TextEditingController();
  final _flipkartLinkController = TextEditingController();
  final _myntraLinkController = TextEditingController();
  final _ajioLinkController = TextEditingController();

  // final _meeshoLinkController = TextEditingController();

  List<Tuple2<String?, String?>?> productCategory = [];
  Tuple2<String?, String?>? getSelectedProductCategory = Tuple2("", "");

  List<PlatformFile>? _selectedFiles;
  final ValueNotifier<bool> _isCreatingProduct = ValueNotifier<bool>(false);

  CollectionReference? _collectionRefToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _collectionRefToken = FirebaseFirestore.instance.collection('HomePageLink');

    productCategory = [
      Tuple2("Men", "1"),
      Tuple2("Women", "2"),
      Tuple2("Kids", "3"),
      Tuple2("Home Appliances", "4"),
      Tuple2("Others", "0"),
    ];
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

  Future<void> _pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        _selectedFiles = result.files;
      });
    }
  }

  Future<void> _createProduct() async {
    _isCreatingProduct.value = true;

    try {
      if (_formKey.currentState!.validate()) {
        List<String> fileUrls = [];
        if (_selectedFiles != null) {
          // Upload each file and get the URL
          for (PlatformFile file in _selectedFiles!) {
            FirebaseStorage storage = FirebaseStorage.instance;
            Reference ref = storage.ref().child('banners/${file.name}');
            UploadTask uploadTask = ref.putFile(File(file.path!));
            TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
            String fileUrl = await snapshot.ref.getDownloadURL();
            fileUrls.add(fileUrl);
          }
        } else {
          Constants.showToast(
              "Please Attach Product Image", ToastGravity.BOTTOM);
          return;
        }

        // Save the product information in Firestore
        await FirebaseFirestore.instance.collection('banners').add({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'amount': _amntController.text,
          'minBargainAmount': _minBargainAmntController.text,
          'productDetails': _detailsController.text,
          'productSpec': _specController.text,
          'fileUrls': fileUrls,
          'affiliateLink': _affiliateLinkController.text,
          'productCategory': getSelectedProductCategory?.item2 ?? "0",
          'created_at': Timestamp.now(),
        });

        String getTitle = _titleController.text;
        String getAmount = _amntController.text;
        String getDescription = _descriptionController.text;

        // await NotificationService.postCommonNotificationRequest(
        //     "Get $getTitle for Rs.$getAmount ✨",
        //     "Maaka Posted New $getTitle✨\n$getDescription🥳\nMaaka filter useful products🏸🛼🛴 with the best offers💥\nShop now and save big!🪑💰🔦🛵⚽️");

        Response? getResult = await NotificationService.postNotificationWithImage(
            "Get $getTitle for Rs.$getAmount ✨",
            "Try bargaining for the best prices on your favorite products 🪑💰🔦🛵⚽️️",
            fileUrls[0] ?? null);

        Navigator.pop(context);
      }
    } catch (e) {
      // Handle any errors here
      print('Error creating product: $e');
    } finally {
      _isCreatingProduct.value = false;
    }
  }

  Future<void> _UpdateHomePageLink() async {
    try {
      if (_formKeyHomePage.currentState!.validate()) {
        // Save the product information in Firestore

        QuerySnapshot snapshot = await _collectionRefToken!.limit(1).get();
        if (snapshot.docs.isNotEmpty) {
          String documentId = snapshot.docs.first.id;
          await _collectionRefToken!.doc(documentId).update({
            'amazonHomePageUrl': _amazonLinkController.text,
            'flipkartHomePageUrl': _flipkartLinkController.text,
            'myntraHomePageUrl': _myntraLinkController.text,
            'ajioHomePageUrl': _ajioLinkController.text,
            // 'meeshoHomePageUrl': _meeshoLinkController.text,
            'created_at': Timestamp.now(),
          });

          await NotificationService.postCommonNotificationRequest(
              "Maaka gives Access for all shopping apps in one place✨",
              "Enjoy seamless browsing, exclusive deals, and secure transactions💥\nShop now and save big!🪑💰🔦🛵⚽️");

          Constants.showToast("Home page links updated", ToastGravity.BOTTOM);
        } else {
          // Create a new document since no document is found
          await _collectionRefToken!.add({
            'amazonHomePageUrl': _amazonLinkController.text,
            'flipkartHomePageUrl': _flipkartLinkController.text,
            'myntraHomePageUrl': _myntraLinkController.text,
            'ajioHomePageUrl': _ajioLinkController.text,
            // 'meeshoHomePageUrl': _meeshoLinkController.text,
            'created_at': Timestamp.now(),
          });
          await NotificationService.postCommonNotificationRequest(
              "Maaka gives Access for all shopping apps in one place✨",
              "Enjoy seamless browsing, exclusive deals, and secure transactions💥\nShop now and save big!🪑💰🔦🛵⚽️");
          Constants.showToast("Home page links created", ToastGravity.BOTTOM);
        }
      }
    } catch (e) {
      // Handle any errors here
      Constants.showToast(
          "Problem in updating Home page Links", ToastGravity.BOTTOM);
      print('Error creating home page link: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // This will dismiss the keyboard
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
                title: Text(
                  "Post Product",
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
        body: Consumer(builder: (context, ref, child) {
          return Stack(alignment: Alignment.center, children: [
            IgnorePointer(
              ignoring: _isCreatingProduct.value,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                        width: 100.w,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "Product Details",
                                  textAlign: TextAlign.start,
                                  style: GlobalTextStyles.secondaryText1(
                                      textColor: FlutterFlowTheme.of(context)
                                          .primaryBackground),
                                ),
                              ),
                              Expanded(
                                flex: 9,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextFormField(
                                        controller: _titleController,
                                        decoration: InputDecoration(
                                            labelText: 'Product Title'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a title';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        controller: _descriptionController,
                                        decoration: InputDecoration(
                                            labelText: 'Product Description'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a description';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        controller: _amntController,
                                        keyboardType: TextInputType.number,
                                        decoration:
                                            InputDecoration(labelText: 'Amount'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a amount';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        controller: _minBargainAmntController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText: 'Minimum Bargain Amount'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a Minimum Bargain Amount';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          ref
                                              .read(ListProvider.notifier)
                                              .getData = productCategory;
                                          ref
                                                  .read(ListProvider.notifier)
                                                  .getSelectionType =
                                              SelectionType
                                                  .postProductCategoryType;

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ListViewBuilder(
                                                        getListHeading:
                                                            "Choose Product Category",
                                                        getIndex: null,
                                                      )));
                                        },
                                        child: Consumer(
                                            builder: (context, ref, child) {
                                          getSelectedProductCategory =
                                              ref.watch(adminTypeProvider);

                                          return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 10),
                                                  child: Text(
                                                    "Product Category",
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        letterSpacing: 1),
                                                    maxLines: 2,
                                                    softWrap: false,
                                                    overflow: TextOverflow.fade,
                                                    textAlign: TextAlign.justify,
                                                  ),
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Container(
                                                            height: 50,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 10.0),
                                                              child:
                                                                  TextFormField(
                                                                enabled: false,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .none,
                                                                controller: ref
                                                                    .read(ListProvider
                                                                        .notifier)
                                                                    .txtGoalPriority,
                                                                focusNode: ref
                                                                    .read(ListProvider
                                                                        .notifier)
                                                                    .focusGoalPriority,
                                                                textCapitalization:
                                                                    TextCapitalization
                                                                        .words,
                                                                decoration:
                                                                    const InputDecoration(
                                                                        // labelText: data.success![1][index].item2!,
                                                                        suffixIcon:
                                                                            Icon(
                                                                          Icons
                                                                              .navigate_next,
                                                                          color: Color.fromARGB(
                                                                              125,
                                                                              1,
                                                                              2,
                                                                              2),
                                                                        ),
                                                                        border: InputBorder
                                                                            .none),
                                                                style: const TextStyle(
                                                                    letterSpacing:
                                                                        1),

                                                                // keyboardType:
                                                                //     TextInputType
                                                                //         .text,
                                                                validator:
                                                                    _validateMappedAdmin,
                                                              ),
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                              ]);
                                        }),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        controller: _detailsController,
                                        decoration: InputDecoration(
                                            labelText: 'Product Details'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a details';
                                          }
                                          return null;
                                        },
                                        maxLines: 8,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        controller: _specController,
                                        decoration: InputDecoration(
                                            labelText: 'Product Specification'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a specification';
                                          }
                                          return null;
                                        },
                                        maxLines: 8,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        controller: _affiliateLinkController,
                                        decoration: InputDecoration(
                                            labelText: 'Affiliate link'),
                                      ),
                                      SizedBox(height: 15.0),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: _pickFiles,
                                      child: Text(
                                        _selectedFiles == null
                                            ? 'Attach Image'
                                            : 'Change Image',
                                        style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            FlutterFlowTheme.of(context).primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Set the border radius here
                                        ), // Set the background color here
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    ElevatedButton(
                                      onPressed: _createProduct,
                                      child: Text(
                                        'Post Product',
                                        style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            FlutterFlowTheme.of(context).primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Set the border radius here
                                        ), // Set the background color here
                                      ),
                                    ),
                                  ],
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
            ValueListenableBuilder<bool>(
              valueListenable: _isCreatingProduct,
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
            ),
          ]);
        }),
      ),
    );
  }

  String? _validateMappedAdmin(String? value) {
    if (value == null || value.isEmpty) {
      Constants.showToast("Please map product Category", ToastGravity.BOTTOM);
      return 'Please map Product Category ';
    }

    return null;
  }
}

//todo:- following class is created to add new food
//todo:- important note - try to merge , both new product post and new food post commonly

class CreateNewFood extends ConsumerStatefulWidget {
  //todo:- to Know
  //when getIsUpdatingFoodPrice is true, then will allow to edit only title,description and amout
  //and also show only editable item in UI , for Edit case

  String? getMobNo;
  String? getDocId;
  String? getTitle;
  String? getDescription;
  String? getAmount;
  bool? getIsUpdatingFoodPrice;

  CreateNewFood({
    @required this.getMobNo,
    @required this.getDocId,
    @required this.getTitle,
    @required this.getDescription,
    @required this.getAmount,
    @required this.getIsUpdatingFoodPrice,
  });

  @override
  CreateNewFoodState createState() => CreateNewFoodState();
}

class CreateNewFoodState extends ConsumerState<CreateNewFood> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyHomePage = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _affiliateLinkController = TextEditingController();
  final _amntController = TextEditingController();
  final _minBargainAmntController = TextEditingController();
  final _detailsController = TextEditingController();
  final _specController = TextEditingController();

  final _amazonLinkController = TextEditingController();
  final _flipkartLinkController = TextEditingController();
  final _myntraLinkController = TextEditingController();
  final _ajioLinkController = TextEditingController();

  // final _meeshoLinkController = TextEditingController();

  List<Tuple2<String?, String?>?> foodCategory = [];
  Tuple2<String?, String?>? getSelectedFoodCategory = Tuple2("", "");

  List<PlatformFile>? _selectedFiles;
  final ValueNotifier<bool> _isCreatingFood = ValueNotifier<bool>(false);

  CollectionReference? _collectionRefToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _collectionRefToken = FirebaseFirestore.instance.collection('HomePageLink');

    foodCategory = [
      Tuple2("Main Course", "1"),
      Tuple2("Gravy", "2"),
      Tuple2("Starters", "3"),
      Tuple2("Desserts", "4"),
      Tuple2("Juices", "5"),
      Tuple2("Ice Creams", "6"),
      Tuple2("Tiffin", "7"),
      Tuple2("Lunch", "8"),
    ];

    if (widget.getIsUpdatingFoodPrice ?? false) {
      _titleController.text = widget.getTitle ?? "";
      _descriptionController.text = widget.getDescription ?? "";
      _amntController.text = widget.getAmount ?? "";
    }

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

  Future<void> _pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        _selectedFiles = result.files;
      });
    }
  }

  Future<void> _createFood() async {
    _isCreatingFood.value = true;

    try {
      if (_formKey.currentState!.validate()) {
        List<String> fileUrls = [];
        if (_selectedFiles != null) {
          // Upload each file and get the URL
          for (PlatformFile file in _selectedFiles!) {
            FirebaseStorage storage = FirebaseStorage.instance;
            Reference ref = storage.ref().child('AreaFoodPrices/${file.name}');
            UploadTask uploadTask = ref.putFile(File(file.path!));
            TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
            String fileUrl = await snapshot.ref.getDownloadURL();
            fileUrls.add(fileUrl);
          }
        } else {
          Constants.showToast("Please Attach Food Image", ToastGravity.BOTTOM);
          return;
        }

        final String docId =
            widget.getMobNo ?? ""; // Use mobile number as document ID

        DocumentReference docRef =
            FirebaseFirestore.instance.collection('AreaFoodPrices').doc(docId);

// Check if the document exists
        final docSnapshot = await docRef.get();

        if (!docSnapshot.exists) {
          // If document does not exist, create it first
          await docRef.set({
            'created_at': Timestamp.now(),
            'foodAdminNo': widget.getMobNo ?? "N/A",
            'foodAdminCloudShopName': (Constants.getUserName ?? "N/A").isEmpty ? "Maaka Foods" : Constants.getUserName,
            'foodAdminCloudShopTitle': "",
            'foodAdminCloudShopDescription': "",
          });
        }

        // Save the product information in Firestore
        await docRef.collection('Foods').add({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'amount': _amntController.text,
          'minBargainAmount': "0",
          'productDetails': _detailsController.text,
          'productSpec': _specController.text,
          'fileUrls': fileUrls,
          'productCategory': getSelectedFoodCategory?.item2 ?? "0",
          'created_at': Timestamp.now(),
          'foodAdminNo': widget.getMobNo ?? ""
        });

        String getTitle = _titleController.text;
        String getAmount = _amntController.text;
        String getDescription = _descriptionController.text;

        // await NotificationService.postCommonNotificationRequest(
        //     "Get $getTitle for Rs.$getAmount ✨",
        //     "Maaka Posted New $getTitle✨\n$getDescription🥳\nMaaka filter useful products🏸🛼🛴 with the best offers💥\nShop now and save big!🪑💰🔦🛵⚽️");

        // Response? getResult = await NotificationService.postNotificationWithImage("Get $getTitle for Rs.$getAmount ✨","Food is always a good idea.",fileUrls[0] ?? null);

        Navigator.pop(context);
      }
    } catch (e) {
      // Handle any errors here
      print('Error creating product: $e');
    } finally {
      _isCreatingFood.value = false;
    }
  }

  Future<void> _updateFoodDetails(String? getDocId, String? getTitle,
      String? getDescription, String? getAmount) async {
    final String docId =
        widget.getMobNo ?? ""; // Use mobile number as document ID

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('AreaFoodPrices').doc(docId);

    if (docId == null || docId.isEmpty) {
      print("Error: Document ID cannot be null or empty.");
      return;
    }

    docRef.collection('Foods').doc(getDocId)
      ..update({
        'title': getTitle ?? "",
        'description': getDescription ?? "",
        'amount': getAmount ?? "",
      }).then((value) {
        setState(() {
          _titleController.text = "";
          _descriptionController.text = "";
          _amntController.text = "";
        });
        Constants.showToast(
            "Food Details Updated Successfully", ToastGravity.BOTTOM);
        Navigator.pop(context);
      }).catchError((error) {
        print("Failed to update area prices: $error");
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // This will dismiss the keyboard
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
                title: Text(
                  "Create Food",
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
        body: Consumer(builder: (context, ref, child) {
          return (widget.getIsUpdatingFoodPrice ?? false)
              ? Stack(alignment: Alignment.center, children: [
                  IgnorePointer(
                    ignoring: _isCreatingFood.value,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Expanded(
                                child: Container(
                              width: 100.w,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Food Details",
                                        textAlign: TextAlign.start,
                                        style: GlobalTextStyles.secondaryText1(
                                            textColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryBackground),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 9,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextFormField(
                                              controller: _titleController,
                                              decoration: InputDecoration(
                                                  labelText: 'Food Title'),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a title';
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            TextFormField(
                                              controller: _descriptionController,
                                              decoration: InputDecoration(
                                                  labelText: 'Food Description'),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a description';
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            TextFormField(
                                              controller: _amntController,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                  labelText: 'Amount'),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a amount';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              _updateFoodDetails(
                                                  widget.getDocId,
                                                  _titleController.text,
                                                  _descriptionController.text,
                                                  _amntController.text);
                                            },
                                            child: Text(
                                              'Update Details',
                                              style: TextStyle(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    10.0), // Set the border radius here
                                              ), // Set the background color here
                                            ),
                                          ),
                                        ],
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
                  ValueListenableBuilder<bool>(
                    valueListenable: _isCreatingFood,
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
                  ),
                ])
              : Stack(alignment: Alignment.center, children: [
                  IgnorePointer(
                    ignoring: _isCreatingFood.value,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Expanded(
                                child: Container(
                              width: 100.w,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Food Details",
                                        textAlign: TextAlign.start,
                                        style: GlobalTextStyles.secondaryText1(
                                            textColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryBackground),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 9,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextFormField(
                                              controller: _titleController,
                                              decoration: InputDecoration(
                                                  labelText: 'Food Title'),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a title';
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            TextFormField(
                                              controller: _descriptionController,
                                              decoration: InputDecoration(
                                                  labelText: 'Food Description'),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a description';
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            TextFormField(
                                              controller: _amntController,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                  labelText: 'Amount'),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a amount';
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            //todo:- use below snippet to set bargain amount amount by user
                                            // TextFormField(
                                            //   controller: _minBargainAmntController,
                                            //   keyboardType: TextInputType.number,
                                            //   decoration:
                                            //   InputDecoration(labelText: 'Minimum Bargain Amount'),
                                            //   validator: (value) {
                                            //     if (value == null || value.isEmpty) {
                                            //       return 'Please enter a Minimum Bargain Amount';
                                            //     }
                                            //     return null;
                                            //   },
                                            // ),

                                            SizedBox(
                                              height: 15,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                ref
                                                    .read(ListProvider.notifier)
                                                    .getData = foodCategory;
                                                ref
                                                        .read(ListProvider.notifier)
                                                        .getSelectionType =
                                                    SelectionType
                                                        .postFoodCategoryType;

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ListViewBuilder(
                                                              getListHeading:
                                                                  "Choose Food Category",
                                                              getIndex: null,
                                                            )));
                                              },
                                              child: Consumer(
                                                  builder: (context, ref, child) {
                                                getSelectedFoodCategory =
                                                    ref.watch(adminTypeProvider);

                                                return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                left: 10),
                                                        child: Text(
                                                          "Food Category",
                                                          style: const TextStyle(
                                                              color: Colors.grey,
                                                              fontWeight:
                                                                  FontWeight.w400,
                                                              letterSpacing: 1),
                                                          maxLines: 2,
                                                          softWrap: false,
                                                          overflow:
                                                              TextOverflow.fade,
                                                          textAlign:
                                                              TextAlign.justify,
                                                        ),
                                                      ),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5.0),
                                                                child: Container(
                                                                  height: 50,
                                                                  child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                10.0),
                                                                    child:
                                                                        TextFormField(
                                                                      enabled:
                                                                          false,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .none,
                                                                      controller: ref
                                                                          .read(ListProvider
                                                                              .notifier)
                                                                          .txtGoalPriority,
                                                                      focusNode: ref
                                                                          .read(ListProvider
                                                                              .notifier)
                                                                          .focusGoalPriority,
                                                                      textCapitalization:
                                                                          TextCapitalization
                                                                              .words,
                                                                      decoration: const InputDecoration(
                                                                          // labelText: data.success![1][index].item2!,
                                                                          suffixIcon: Icon(
                                                                            Icons
                                                                                .navigate_next,
                                                                            color: Color.fromARGB(
                                                                                125,
                                                                                1,
                                                                                2,
                                                                                2),
                                                                          ),
                                                                          border: InputBorder.none),
                                                                      style: const TextStyle(
                                                                          letterSpacing:
                                                                              1),

                                                                      // keyboardType:
                                                                      //     TextInputType
                                                                      //         .text,
                                                                      validator:
                                                                          _validateMappedAdmin,
                                                                    ),
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                10),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ]),
                                                    ]);
                                              }),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            TextFormField(
                                              controller: _detailsController,
                                              decoration: InputDecoration(
                                                  labelText: 'Food Details'),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a details';
                                                }
                                                return null;
                                              },
                                              maxLines: 8,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            TextFormField(
                                              controller: _specController,
                                              decoration: InputDecoration(
                                                  labelText:
                                                      'Food Specification'),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a specification';
                                                }
                                                return null;
                                              },
                                              maxLines: 8,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: _pickFiles,
                                            child: Text(
                                              _selectedFiles == null
                                                  ? 'Attach Image'
                                                  : 'Change Image',
                                              style: TextStyle(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    10.0), // Set the border radius here
                                              ), // Set the background color here
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          ElevatedButton(
                                            onPressed: _createFood,
                                            child: Text(
                                              'Post Food',
                                              style: TextStyle(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    10.0), // Set the border radius here
                                              ), // Set the background color here
                                            ),
                                          ),
                                        ],
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
                  ValueListenableBuilder<bool>(
                    valueListenable: _isCreatingFood,
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
                  ),
                ]);
        }),
      ),
    );
  }

  String? _validateMappedAdmin(String? value) {
    if (value == null || value.isEmpty) {
      Constants.showToast("Please map Food Category", ToastGravity.BOTTOM);
      return 'Please map Product Category ';
    }

    return null;
  }
}


//todo:- following class is created to add new grocery

class CreateNewGrocery extends ConsumerStatefulWidget {
  //todo:- to Know
  //when getIsUpdatingFoodPrice is true, then will allow to edit only title,description and amout
  //and also show only editable item in UI , for Edit case

  String? getMobNo;
  String? getDocId;
  String? getTitle;
  String? getDescription;
  String? getAmount;
  bool? getIsUpdatingGroceryPrice;

  CreateNewGrocery({
    @required this.getMobNo,
    @required this.getDocId,
    @required this.getTitle,
    @required this.getDescription,
    @required this.getAmount,
    @required this.getIsUpdatingGroceryPrice,
  });

  @override
  CreateNewGroceryState createState() => CreateNewGroceryState();
}

class CreateNewGroceryState extends ConsumerState<CreateNewGrocery> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amntController = TextEditingController();
  final _detailsController = TextEditingController();
  final _specController = TextEditingController();

  List<Tuple2<String?, String?>?> groceryCategory = [];
  Tuple2<String?, String?>? getSelectedGroceryCategory = Tuple2("", "");

  List<PlatformFile>? _selectedFiles;
  final ValueNotifier<bool> _isCreatingGrocery = ValueNotifier<bool>(false);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    groceryCategory = [
      Tuple2("Daily Needs", "1"),
      Tuple2("Weekly Needs", "2"),
      Tuple2("Monthly Needs", "3"),
      Tuple2("Milk", "4"),
      Tuple2("Maavu", "5"),
      Tuple2("Water Can", "6"),


    ];

    if (widget.getIsUpdatingGroceryPrice ?? false) {
      _titleController.text = widget.getTitle ?? "";
      _descriptionController.text = widget.getDescription ?? "";
      _amntController.text = widget.getAmount ?? "";
    }

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

  Future<void> _pickFiles() async {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        _selectedFiles = result.files;
      });
    }
  }

  Future<void> _createGrocery() async {
    _isCreatingGrocery.value = true;

    try {
      if (_formKey.currentState!.validate()) {
        List<String> fileUrls = [];
        if (_selectedFiles != null) {
          // Upload each file and get the URL
          for (PlatformFile file in _selectedFiles!) {
            FirebaseStorage storage = FirebaseStorage.instance;
            Reference ref = storage.ref().child('AreaGroceryPrices/${file.name}');
            UploadTask uploadTask = ref.putFile(File(file.path!));
            TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
            String fileUrl = await snapshot.ref.getDownloadURL();
            fileUrls.add(fileUrl);
          }
        } else {
          Constants.showToast("Please Attach Grocery Image", ToastGravity.CENTER);
          return;
        }

        final String docId =
            widget.getMobNo ?? ""; // Use mobile number as document ID

        DocumentReference docRef =
        FirebaseFirestore.instance.collection('AreaGroceryPrices').doc(docId);

// Check if the document exists
        final docSnapshot = await docRef.get();

        if (!docSnapshot.exists) {
          // If document does not exist, create it first
          await docRef.set({
            'created_at': Timestamp.now(),
            'GroceryAdminNo': widget.getMobNo ?? "N/A",
            'GroceryAdminCloudShopName': (Constants.getUserName ?? "N/A").isEmpty ? "Maaka Grocery" : Constants.getUserName,
            'GroceryAdminCloudShopTitle': "",
            'GroceryAdminCloudShopDescription': "",
          });
        }

        // Save the product information in Firestore
        await docRef.collection('Grocery').add({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'amount': _amntController.text,
          'minBargainAmount': "0",
          'productDetails': _detailsController.text,
          'productSpec': _specController.text,
          'fileUrls': fileUrls,
          'productCategory': getSelectedGroceryCategory?.item2 ?? "0",
          'created_at': Timestamp.now(),
          'groceryAdminNo': widget.getMobNo ?? ""
        });

        String getTitle = _titleController.text;
        String getAmount = _amntController.text;
        String getDescription = _descriptionController.text;

        // await NotificationService.postCommonNotificationRequest(
        //     "Get $getTitle for Rs.$getAmount ✨",
        //     "Maaka Posted New $getTitle✨\n$getDescription🥳\nMaaka filter useful products🏸🛼🛴 with the best offers💥\nShop now and save big!🪑💰🔦🛵⚽️");

        // Response? getResult = await NotificationService.postNotificationWithImage("Get $getTitle for Rs.$getAmount ✨","Food is always a good idea.",fileUrls[0] ?? null);

        Navigator.pop(context);
      }
    } catch (e) {
      // Handle any errors here
      print('Error creating Grocery: $e');
    } finally {
      _isCreatingGrocery.value = false;
    }
  }

  Future<void> _updateGroceryDetails(String? getDocId, String? getTitle,
      String? getDescription, String? getAmount) async {
    final String docId =
        widget.getMobNo ?? ""; // Use mobile number as document ID

    DocumentReference docRef =
    FirebaseFirestore.instance.collection('AreaGroceryPrices').doc(docId);

    if (docId == null || docId.isEmpty) {
      print("Error: Document ID cannot be null or empty.");
      return;
    }

    docRef.collection('Grocery').doc(getDocId)
      ..update({
        'title': getTitle ?? "",
        'description': getDescription ?? "",
        'amount': getAmount ?? "",
      }).then((value) {
        setState(() {
          _titleController.text = "";
          _descriptionController.text = "";
          _amntController.text = "";
        });
        Constants.showToast(
            "Grocery Details Updated Successfully", ToastGravity.BOTTOM);
        Navigator.pop(context);
      }).catchError((error) {
        print("Failed to update Grocery prices: $error");
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // This will dismiss the keyboard
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
          title: Text(
            "Create Grocery",
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
        body: Consumer(builder: (context, ref, child) {
          return (widget.getIsUpdatingGroceryPrice ?? false)
              ? Stack(alignment: Alignment.center, children: [
            IgnorePointer(
              ignoring: _isCreatingGrocery.value,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                            width: 100.w,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Grocery Details",
                                      textAlign: TextAlign.start,
                                      style: GlobalTextStyles.secondaryText1(
                                          textColor:
                                          FlutterFlowTheme.of(context)
                                              .primaryBackground),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 9,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextFormField(
                                            controller: _titleController,
                                            decoration: InputDecoration(
                                                labelText: 'Grocery Title'),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a title';
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          TextFormField(
                                            controller: _descriptionController,
                                            decoration: InputDecoration(
                                                labelText: 'Grocery Description'),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a description';
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          TextFormField(
                                            controller: _amntController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText: 'Amount'),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a amount';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _updateGroceryDetails(
                                                widget.getDocId,
                                                _titleController.text,
                                                _descriptionController.text,
                                                _amntController.text);
                                          },
                                          child: Text(
                                            'Update Grocery',
                                            style: TextStyle(
                                              color:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  10.0), // Set the border radius here
                                            ), // Set the background color here
                                          ),
                                        ),
                                      ],
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
            ValueListenableBuilder<bool>(
              valueListenable: _isCreatingGrocery,
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
            ),
          ])
              : Stack(alignment: Alignment.center, children: [
            IgnorePointer(
              ignoring: _isCreatingGrocery.value,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                            width: 100.w,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Grocery Details",
                                      textAlign: TextAlign.start,
                                      style: GlobalTextStyles.secondaryText1(
                                          textColor:
                                          FlutterFlowTheme.of(context)
                                              .primaryBackground),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 9,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextFormField(
                                            controller: _titleController,
                                            decoration: InputDecoration(
                                                labelText: 'Grocery Title'),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a title';
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          TextFormField(
                                            controller: _descriptionController,
                                            decoration: InputDecoration(
                                                labelText: 'Grocery Description'),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a description';
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          TextFormField(
                                            controller: _amntController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText: 'Amount'),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a amount';
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          //todo:- use below snippet to set bargain amount amount by user
                                          // TextFormField(
                                          //   controller: _minBargainAmntController,
                                          //   keyboardType: TextInputType.number,
                                          //   decoration:
                                          //   InputDecoration(labelText: 'Minimum Bargain Amount'),
                                          //   validator: (value) {
                                          //     if (value == null || value.isEmpty) {
                                          //       return 'Please enter a Minimum Bargain Amount';
                                          //     }
                                          //     return null;
                                          //   },
                                          // ),

                                          SizedBox(
                                            height: 15,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              ref
                                                  .read(ListProvider.notifier)
                                                  .getData = groceryCategory;
                                              ref
                                                  .read(ListProvider.notifier)
                                                  .getSelectionType =
                                                  SelectionType
                                                      .postFoodCategoryType;

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ListViewBuilder(
                                                            getListHeading:
                                                            "Choose Grocery Category",
                                                            getIndex: null,
                                                          )));
                                            },
                                            child: Consumer(
                                                builder: (context, ref, child) {
                                                  getSelectedGroceryCategory =
                                                      ref.watch(adminTypeProvider);

                                                  return Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                          child: Text(
                                                            "Grocery Category",
                                                            style: const TextStyle(
                                                                color: Colors.grey,
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                letterSpacing: 1),
                                                            maxLines: 2,
                                                            softWrap: false,
                                                            overflow:
                                                            TextOverflow.fade,
                                                            textAlign:
                                                            TextAlign.justify,
                                                          ),
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                                  child: Container(
                                                                    height: 50,
                                                                    child: Padding(
                                                                      padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                          10.0),
                                                                      child:
                                                                      TextFormField(
                                                                        enabled:
                                                                        false,
                                                                        keyboardType:
                                                                        TextInputType
                                                                            .none,
                                                                        controller: ref
                                                                            .read(ListProvider
                                                                            .notifier)
                                                                            .txtGoalPriority,
                                                                        focusNode: ref
                                                                            .read(ListProvider
                                                                            .notifier)
                                                                            .focusGoalPriority,
                                                                        textCapitalization:
                                                                        TextCapitalization
                                                                            .words,
                                                                        decoration: const InputDecoration(
                                                                          // labelText: data.success![1][index].item2!,
                                                                            suffixIcon: Icon(
                                                                              Icons
                                                                                  .navigate_next,
                                                                              color: Color.fromARGB(
                                                                                  125,
                                                                                  1,
                                                                                  2,
                                                                                  2),
                                                                            ),
                                                                            border: InputBorder.none),
                                                                        style: const TextStyle(
                                                                            letterSpacing:
                                                                            1),

                                                                        // keyboardType:
                                                                        //     TextInputType
                                                                        //         .text,
                                                                        validator:
                                                                        _validateMappedAdmin,
                                                                      ),
                                                                    ),
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .grey),
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          10),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]),
                                                      ]);
                                                }),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          TextFormField(
                                            controller: _detailsController,
                                            decoration: InputDecoration(
                                                labelText: 'Grocery Details'),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a details';
                                              }
                                              return null;
                                            },
                                            maxLines: 8,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          TextFormField(
                                            controller: _specController,
                                            decoration: InputDecoration(
                                                labelText:
                                                'Grocery Specification'),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a specification';
                                              }
                                              return null;
                                            },
                                            maxLines: 8,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: _pickFiles,
                                          child: Text(
                                            _selectedFiles == null
                                                ? 'Attach Image'
                                                : 'Change Image',
                                            style: TextStyle(
                                              color:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  10.0), // Set the border radius here
                                            ), // Set the background color here
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        ElevatedButton(
                                          onPressed: _createGrocery,
                                          child: Text(
                                            'Post Grocery',
                                            style: TextStyle(
                                              color:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  10.0), // Set the border radius here
                                            ), // Set the background color here
                                          ),
                                        ),
                                      ],
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
            ValueListenableBuilder<bool>(
              valueListenable: _isCreatingGrocery,
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
            ),
          ]);
        }),
      ),
    );
  }

  String? _validateMappedAdmin(String? value) {
    if (value == null || value.isEmpty) {
      Constants.showToast("Please map Food Category", ToastGravity.BOTTOM);
      return 'Please map Product Category ';
    }

    return null;
  }
}