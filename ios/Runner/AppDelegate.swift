import UIKit
import Flutter
import FirebaseCore
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
 override func application(
   _ application: UIApplication,
   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
 ) -> Bool {
   GeneratedPluginRegistrant.register(with: self)
//     FirebaseApp.configure()
   return super.application(application, didFinishLaunchingWithOptions: launchOptions)
 }
}

//  class AppDelegate: NSObject, UIApplicationDelegate {
//    var window: UIWindow?
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//      FirebaseApp.configure()
//
//      return true
//    }
//  }
