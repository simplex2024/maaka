import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:sizer/sizer.dart';

import '../../../components/NotificationService.dart';
import '../../../components/constants.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../budget_copy_widget.dart';

class UpdateAffiliateLink extends StatefulWidget {
  @override
  UpdateAffiliateLinkState createState() => UpdateAffiliateLinkState();
}

class UpdateAffiliateLinkState extends State<UpdateAffiliateLink> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyHomePage = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _affiliateLinkController = TextEditingController();
  final _amntController = TextEditingController();
  final _detailsController = TextEditingController();
  final _specController = TextEditingController();

  final _amazonLinkController = TextEditingController();
  final _flipkartLinkController = TextEditingController();
  final _myntraLinkController = TextEditingController();
  final _ajioLinkController = TextEditingController();
  // final _meeshoLinkController = TextEditingController();

  List<PlatformFile>? _selectedFiles;
  final ValueNotifier<bool> _isCreatingProduct = ValueNotifier<bool>(false);

  CollectionReference? _collectionRefToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _collectionRefToken = FirebaseFirestore.instance.collection('HomePageLink');
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
          'productDetails': _detailsController.text,
          'productSpec': _specController.text,
          'fileUrls': fileUrls,
          'affiliateLink': _affiliateLinkController.text,
          'created_at': Timestamp.now(),
        });

        String getTitle = _titleController.text;
        String getAmount = _amntController.text;
        String getDescription = _descriptionController.text;

        // await NotificationService.postCommonNotificationRequest(
        //     "Get $getTitle for Rs.$getAmount ✨",
        //     "Maaka Posted New $getTitle✨\n$getDescription🥳\nMaaka filter useful products🏸🛼🛴 with the best offers💥\nShop now and save big!🪑💰🔦🛵⚽️");

        Response? getResult = await NotificationService.postNotificationWithImage("Get $getTitle for Rs.$getAmount ✨","Maaka filter the best offers🪑💰🔦🛵⚽️",fileUrls[0] ?? null);

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
    return Scaffold(
      appBar: responsiveVisibility(
        context: context,
        tabletLandscape: false,
        desktop: false,
      )
          ? AppBar(
        title: Text(
          "Affiliate Links",
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
      body: Stack(alignment: Alignment.center, children: [
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
                        key: _formKeyHomePage,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "Home Page Links",
                                textAlign: TextAlign.start,
                                style: GlobalTextStyles.secondaryText1(
                                    textColor: FlutterFlowTheme.of(context)
                                        .primaryBackground),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: _amazonLinkController,
                                      decoration: InputDecoration(
                                          labelText: 'amazon home page'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter amazon link';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: _flipkartLinkController,
                                      decoration: InputDecoration(
                                          labelText: 'flipkart home page'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter flipkart link';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: _myntraLinkController,
                                      decoration: InputDecoration(
                                          labelText: 'myntra home page'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter myntra link';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: _ajioLinkController,
                                      decoration: InputDecoration(
                                          labelText: 'ajio home page'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter ajio link';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    // TextFormField(
                                    //   controller: _meeshoLinkController,
                                    //   decoration: InputDecoration(
                                    //       labelText: 'meesho home page'),
                                    //   validator: (value) {
                                    //     if (value == null || value.isEmpty) {
                                    //       return 'Please enter meesho link';
                                    //     }
                                    //     return null;
                                    //   },
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _UpdateHomePageLink,
                                      child: Text(
                                        'Update Affiliate Links',
                                        style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
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
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
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
      ]),
    );
  }
}
