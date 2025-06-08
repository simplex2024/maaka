import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:sizer/sizer.dart';

import '../../../components/NotificationService.dart';
import '../../../components/constants.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../budget_copy_widget.dart';

class CreateNewNotificationScreen extends StatefulWidget {
  String? isIndividualNotificationToken;
  CreateNewNotificationScreen(
      {Key? key,
        @required this.isIndividualNotificationToken,})
      : super(key: key);
  @override
  CreateNewNotificationScreenState createState() =>
      CreateNewNotificationScreenState();
}

class CreateNewNotificationScreenState
    extends State<CreateNewNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageLinkController = TextEditingController();
  final ValueNotifier<bool> _isCreatingNotification =
      ValueNotifier<bool>(false);

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

  Future<void> _createNotification() async {
    _isCreatingNotification.value = true;

    try {
      if (_formKey.currentState!.validate()) {
        String? getTitle = _titleController.text;
        String? getDescription = _descriptionController.text;
        String? getImgLink = _imageLinkController.text;

        ///below found text can be used for custom notification
        ///"Earn While You Shop – Shopping into Earnings💵₹💰",
        /// "Maaka Adds Commision for your Purchase - Just Try It",
        /// https://drive.google.com/file/d/1rU-Okb9Xwokt1BbSoC-VJ-9qm5mVdaW3/view?usp=drivesdk

        //todo:- 19.6.24, post common notification with image
        Response? res = await NotificationService.postCustomNotificationWithImage(widget.isIndividualNotificationToken ?? null,
            "$getTitle",
            "$getDescription",
            "$getImgLink");

        if (res?.statusCode == 200) {
          _titleController.text = "";
          _descriptionController.text = "";
          _imageLinkController.text = "";
          Constants.showToast(
              "Notification Sent Successfully!", ToastGravity.CENTER);
        } else {
          _titleController.text = "";
          _descriptionController.text = "";
          _imageLinkController.text = "";
          Constants.showToast(
              "Problem in Sending Notification!", ToastGravity.CENTER);
        }
      }
    } catch (e) {
      // Handle any errors here
      print('Error sending notification: $e');
    } finally {
      _isCreatingNotification.value = false;
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
                "Create Notification",
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
          ignoring: _isCreatingNotification.value,
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
                              "Notification Details",
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
                                    decoration:
                                        InputDecoration(labelText: 'Title'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Title';
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
                                        labelText: 'Description'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Description';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: _imageLinkController,
                                    decoration: InputDecoration(
                                        labelText: 'Image Link Drive'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Image Link';
                                      }
                                      return null;
                                    },
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: _createNotification,
                                  child: Text(
                                    'Create Notification',
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
          valueListenable: _isCreatingNotification,
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
