import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import UserNotifications
import flutter_background_service_ios

@main
@objc class AppDelegate: FlutterAppDelegate {
    var firebaseToken : String = "";
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    Messaging.messaging().delegate = self;
      SwiftFlutterBackgroundServicePlugin.taskIdentifier = "dev.flutter.background.refresh";
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    Messaging.messaging().isAutoInitEnabled = true;
    self.registerForFirebaseNotification(application: application);
//    return true;
      return super.application(application, didFinishLaunchingWithOptions: launchOptions);
   // GeneratedPluginRegistrant.register(with: self)
    
  }
    
   override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken : Data){
    print("X__APNS: \(String(describing: deviceToken))")
       Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)
       Messaging.messaging().apnsToken = deviceToken;
    //Messaging.messaging().setAPNSToken(deviceToken, type:MessagingAPNSTokenType.prod )
    }
    
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("X_ERR",error);
    }
    
    override func application(_ application: UIApplication,
        didReceiveRemoteNotification notification: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      if Auth.auth().canHandleNotification(notification) {
        completionHandler(.noData)
        return
      }
      // This notification is not auth related; it should be handled separately.
    }
    
     func registerForFirebaseNotification(application : UIApplication){
    //    Messaging.messaging().delegate     = self;
        if #available(iOS 10.0, *) {
            //UNUserNotificationCenter.current().delegate = self ;
            let authOpt : UNAuthorizationOptions = [.alert, .badge, .sound];
            UNUserNotificationCenter.current().requestAuthorization(options: authOpt, completionHandler: {_, _ in})
            UNUserNotificationCenter.current().delegate = self ;
        }else{
            let settings : UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)                
            application.registerUserNotificationSettings(settings);
        }
        application.registerForRemoteNotifications();
    }
}


extension AppDelegate : MessagingDelegate{
    func messaging(_messagin : Messaging, didRecieveRegistrationToken fcmToken : String){
        self.firebaseToken = fcmToken;
        print("X__FCM: \(String(describing: fcmToken))")
    }
    func messaging(_messagin : Messaging, didRecieve remoteMessage : Any){
        //self.firebaseToken = fcmToken;
        print("REMOTE__MSG: \(remoteMessage)")
    }
    func application(_ application : UIApplication,didRecieveRemoteNotification uinfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        print("WITH__APN: \(uinfo)")
    }
}
