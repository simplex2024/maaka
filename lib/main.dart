// ignore_for_file: library_private_types_in_public_api

// import 'dart:html';
import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:maaakanmoney/pages/splash/SplashScreen.dart';
import 'package:sizer/sizer.dart';
import 'package:upgrader/upgrader.dart';
import 'components/constants.dart';
import 'firebase_options.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/internationalization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;


///background notification, receives even without below function,below function is used to view incoming notification data.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }

}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Upgrader.clearSavedSettings();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp(
    // todo cloud msg
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final messaging = FirebaseMessaging.instance;

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //todo:- 22.9.23 ,as of now, configuration to get push notification is setup only for android platform
  ////todo:- 4.12.23 commented below line, to check notification for ios also
  // if (Platform.isAndroid) {
  //todo:- 19.9.23, notification subscription, which device can receive notification
  messaging.subscribeToTopic('all').then((_) {
    print('Subscribed to "all" topic');
  }).catchError((error) {
    print('Error subscribing to "all" topic: $error');
  });

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }

  // String? token = await messaging.getToken();
  String? token;
  //handling null
  try{
    token = await messaging.getToken();
  }catch(e){
    print(e);
  }

  Constants.adminDeviceToken = token ?? "";
  Constants.userDeviceToken = token ?? "";

  if (kDebugMode) {
    print('Registration Token=$token');
  }

  await FlutterFlowTheme.initialize();
  await FFLocalizations.initialize();

//todo;:- foreground notification
  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  runApp(const ProviderScope(child: MyApp()));
}


late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {

  String? initialMessage;
  bool _resolved = false;

  Locale? _locale = FFLocalizations.getStoredLocale();
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;


  // String primaryColor = '#0B4D40';
  String primaryColor = '#101213';
  String constantsPrimaryColor = '#001B48';
  String _lastMessage = "";

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
    FFLocalizations.storeLocale(language);
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  void initState() {
    ///try below method for desired page navigation when notification tapped
    // FirebaseMessaging.instance.getInitialMessage().then(
    //       (value) => setState(
    //         () {
    //       _resolved = true;
    //       initialMessage = value?.data.toString();
    //       if (initialMessage != null) {
    //         // var route = NavigationHistoryObserver().top;
    //         // if(route!=null && route.settings.name!=NotificationScreen.routeName){
    //         //   NavigationService.navigatorKey.currentState?.pushNamed(NotificationScreen.routeName);
    //         // }
    //       }
    //     },
    //   ),
    // );
    //

    //
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   // var route = NavigationHistoryObserver().top;
    //   // if(route!=null && route.settings.name!=NotificationScreen.routeName){
    //   //   NavigationService.navigatorKey.currentState?.pushNamed(NotificationScreen.routeName);
    //   // }
    // });

///foreground notification receives, below method triggers when
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showFlutterNotification(message);
    });

    super.initState();
  }



  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            styleInformation: BigTextStyleInformation(
              notification.body ?? '',
              contentTitle: notification.title,
            ),
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }


  ///below two functions responsible for showing image in notification
  // Future<void> showFlutterNotification(RemoteMessage message) async {
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;
  //   if (notification != null && android != null && !kIsWeb) {
  //     String? imageUrl = message.data['image'] ?? "https://via.placeholder.com/600x200"; // URL of the image
  //
  //     BigPictureStyleInformation? bigPictureStyleInformation;
  //     if (imageUrl != null && imageUrl.isNotEmpty) {
  //       try {
  //         final String largeIconPath = await _downloadAndSaveFile(
  //             imageUrl, 'largeIcon');
  //         bigPictureStyleInformation = BigPictureStyleInformation(
  //           FilePathAndroidBitmap(largeIconPath),
  //           largeIcon: FilePathAndroidBitmap(largeIconPath),
  //           contentTitle: notification.title,
  //           htmlFormatContentTitle: true,
  //           summaryText: notification.body,
  //           htmlFormatSummaryText: true,
  //         );
  //       } catch (e) {
  //         print('Error downloading image: $e');
  //       }
  //     }
  //
  //     flutterLocalNotificationsPlugin.show(
  //       notification.hashCode,
  //       notification.title,
  //       notification.body,
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           channel.id,
  //           channel.name,
  //           channelDescription: channel.description,
  //           styleInformation: bigPictureStyleInformation ??
  //               BigTextStyleInformation(
  //                 notification.body ?? '',
  //                 contentTitle: notification.title,
  //               ),
  //           icon: 'ic_launcher',
  //         ),
  //       ),
  //     );
  //   }
  // }
  //
  // Future<String> _downloadAndSaveFile(String url, String fileName) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final filePath = '${directory.path}/$fileName';
  //   final response = await http.get(Uri.parse(url));
  //   final file = File(filePath);
  //   await file.writeAsBytes(response.bodyBytes);
  //   return filePath;
  // }



  //todo:- 18.6.24 use below code, to show notification with and without image by checking for image url
  // Future<void> showFlutterNotification(RemoteMessage message) async {
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;
  //   if (notification != null && android != null && !kIsWeb) {
  //     String? imageUrl = message.data['image']; // URL of the image, if present
  //
  //     if (imageUrl != null && imageUrl.isNotEmpty) {
  //       _showNotificationWithImage(notification, imageUrl);
  //     } else {
  //       _showNotificationWithoutImage(notification);
  //     }
  //   }
  // }
  //
  //
  // Future<void> _showNotificationWithImage(RemoteNotification notification, String imageUrl) async {
  //   try {
  //     final String largeIconPath = await _downloadAndSaveFile(imageUrl, 'largeIcon');
  //     final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
  //       FilePathAndroidBitmap(largeIconPath),
  //       largeIcon: FilePathAndroidBitmap(largeIconPath),
  //       contentTitle: notification.title,
  //       htmlFormatContentTitle: true,
  //       summaryText: notification.body,
  //       htmlFormatSummaryText: true,
  //     );
  //
  //     flutterLocalNotificationsPlugin.show(
  //       notification.hashCode,
  //       notification.title,
  //       notification.body,
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           channel.id, // Channel ID
  //           channel.name, // Channel name
  //           channelDescription: channel.description, // Channel description
  //           styleInformation: bigPictureStyleInformation,
  //           icon: 'ic_launcher',
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     print('Error downloading image: $e');
  //     _showNotificationWithoutImage(notification); // Fallback to notification without image
  //   }
  // }
  //
  // Future<void> _showNotificationWithoutImage(RemoteNotification notification) async {
  //   flutterLocalNotificationsPlugin.show(
  //     notification.hashCode,
  //     notification.title,
  //     notification.body,
  //     NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         channel.id, // Channel ID
  //         channel.name, // Channel name
  //         channelDescription: channel.description, // Channel description
  //         styleInformation: BigTextStyleInformation(
  //           notification.body ?? '',
  //           contentTitle: notification.title,
  //         ),
  //         icon: 'ic_launcher',
  //       ),
  //     ),
  //   );
  // }
  //
  // Future<String> _downloadAndSaveFile(String url, String fileName) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final filePath = '${directory.path}/$fileName';
  //   final response = await http.get(Uri.parse(url));
  //   final file = File(filePath);
  //   await file.writeAsBytes(response.bodyBytes);
  //   return filePath;
  // }



  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Maaka App',
        localizationsDelegates: const [
          FFLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: _locale,
        supportedLocales: const [
          Locale('en'),
          Locale('ta'),
        ],
        // theme: ThemeData(
        //   primarySwatch: getColorFromHex(primaryColor),
        //   appBarTheme: AppBarTheme(
        //     iconTheme: IconThemeData(
        //       color: Constants.secondary, // Change this to the desired color
        //     ),
        //   ),
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
        // ),
        // darkTheme: ThemeData(
        //   primarySwatch: getColorFromHex(primaryColor),
        //   appBarTheme: AppBarTheme(
        //     iconTheme: IconThemeData(
        //       color: Constants.secondary, // Change this to the desired color
        //     ),
        //   ),
        // ),
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: getColorFromHex(constantsPrimaryColor),
          textTheme: TextTheme(
            headlineLarge: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.black,overflow: TextOverflow.visible,),
            headlineMedium: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, color: Colors.black,overflow: TextOverflow.visible,),
            headlineSmall: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black,overflow: TextOverflow.visible,),
            titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black,overflow: TextOverflow.visible,),
            titleMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black,overflow: TextOverflow.visible,),
            titleSmall: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black,overflow: TextOverflow.visible,),
            bodyLarge: TextStyle(fontSize: 14.0, color: Colors.black,overflow: TextOverflow.visible,),
            bodyMedium: TextStyle(fontSize: 12.0, color: Colors.black,overflow: TextOverflow.visible,),
            bodySmall: TextStyle(fontSize: 10.0, color: Colors.black,overflow: TextOverflow.visible,),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: getColorFromHex(constantsPrimaryColor),
          textTheme: TextTheme(
            headlineLarge: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.black,overflow: TextOverflow.visible,),
            headlineMedium: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, color: Colors.black,overflow: TextOverflow.visible,),
            headlineSmall: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black,overflow: TextOverflow.visible,),
            titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black,overflow: TextOverflow.visible,),
            titleMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black,overflow: TextOverflow.visible,),
            titleSmall: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black,overflow: TextOverflow.visible,),
            bodyLarge: TextStyle(fontSize: 14.0, color: Colors.black,overflow: TextOverflow.visible,),
            bodyMedium: TextStyle(fontSize: 12.0, color: Colors.black,overflow: TextOverflow.visible,),
            bodySmall: TextStyle(fontSize: 10.0, color: Colors.black,overflow: TextOverflow.visible,),
          ),
        ),
        themeMode: _themeMode,
        home: FillingAnimationScreen2(),
      );
    });
  }

  MaterialColor getColorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return MaterialColor(
      int.parse('FF$hexCode', radix: 16),
      <int, Color>{
        50: Color(int.parse('FF$hexCode', radix: 16)).withOpacity(0.1),
        100: Color(int.parse('FF$hexCode', radix: 16)).withOpacity(0.2),
        200: Color(int.parse('FF$hexCode', radix: 16)).withOpacity(0.3),
        300: Color(int.parse('FF$hexCode', radix: 16)).withOpacity(0.4),
        400: Color(int.parse('FF$hexCode', radix: 16)).withOpacity(0.5),
        500: Color(int.parse('FF$hexCode', radix: 16)).withOpacity(0.6),
        600: Color(int.parse('FF$hexCode', radix: 16)).withOpacity(0.7),
        700: Color(int.parse('FF$hexCode', radix: 16)).withOpacity(0.8),
        800: Color(int.parse('FF$hexCode', radix: 16)).withOpacity(0.9),
        900: Color(int.parse('FF$hexCode', radix: 16)).withOpacity(1.0),
      },
    );
  }
}
