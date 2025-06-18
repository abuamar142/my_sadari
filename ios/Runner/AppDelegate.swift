import Flutter
import UIKit

// add
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//     add
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
    GeneratedPluginRegistrant.register(with: registry)}
    GeneratedPluginRegistrant.register(with: self)

//     add
    if #available(iOS 10.0,  *){
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenter
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
