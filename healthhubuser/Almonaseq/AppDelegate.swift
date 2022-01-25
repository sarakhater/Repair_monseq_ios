//
//  AppDelegate.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/9/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit
import KVSpinnerView
import SideMenu
import Firebase
import UserNotifications
import FirebaseMessaging


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    var mainNav: UINavigationController?
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    
    let userDefaults = UserDefaults.standard
    var navigationController : UINavigationController?;
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //Requesting Authorization for User Interactions
       
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        UIApplication.shared.registerForRemoteNotifications()
        configureFirebase(application: application)
        //setfont
        setupGlobalAppearance();
        //        userDefaults.set(true, forKey: "registered")
        //        userDefaults.set(false, forKey: "logged_in")
        //        userDefaults.set(true, forKey: "activated")
        // Override point for customization after application launch.
        // Spinner settings
        KVSpinnerView.settings.backgroundRectColor = .clear
        KVSpinnerView.settings.tintColor = secondaryColor
        KVSpinnerView.settings.spinnerRadius = 25.0
        KVSpinnerView.settings.linesCount = 1
        KVSpinnerView.settings.linesWidth = 3
        
        // Navigation bar settings
        //var headerImage = UIImage(named: "Header_Bg");
        
        let gradient:CALayer = Utils.initializeGradient()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 64)
        let navigationBarAppearance = UINavigationBar.appearance()
        gradient.frame = defaultNavigationBarFrame
        navigationBarAppearance.setBackgroundImage(self.image(fromLayer: gradient), for: .default)
        
        //        let backgroundImage = UIImageView(frame: defaultNavigationBarFrame)
        //        backgroundImage.image = headerImage
        //        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        //navigationBarAppearance.bringSubview(toFront: backgroundImage)
        //navigationBarAppearance.setBackgroundImage(headerImage!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch), for: .default)
        navigationBarAppearance.shadowImage = UIImage();
        
        navigationBarAppearance.tintColor = .white;
        navigationBarAppearance.barTintColor = .white;
        navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white];
        let font =  UIFont(name: "JannaLT-Bold", size:12)
        let appearance =  UITabBarItem.appearance()
       appearance.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
        

        
        // Show welcome message
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController();
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindow.makeKeyAndVisible()
        //alertWindow.rootViewController?.present(Utils.showIntroAlert(), animated: true)
        
        // Menu settings
        SideMenuManager.default.menuPushStyle = .popWhenPossible
        SideMenuManager.default.menuPresentMode = .viewSlideInOut
        SideMenuManager.default.menuAllowPushOfSameClassTwice = false
        
        // Show language page
        setInitialVC()
        // Firebase notifications
        //FirebaseApp.configure()
        
        UIApplication.shared.applicationIconBadgeNumber = 0;
        
        let types: UIUserNotificationType = UIUserNotificationType.badge
        let notificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(types: types, categories: nil)
        //UIUserNotificationSettings(forTypes: types, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        //        Messaging.messaging().delegate = self
        //
        //        if #available(iOS 10.0, *) {
        //            // For iOS 10 display notification (sent via APNS)
        //            UNUserNotificationCenter.current().delegate = self
        //            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        //            UNUserNotificationCenter.current().requestAuthorization(
        //                options: authOptions,
        //                completionHandler: {_, _ in })
        //            // For iOS 10 data message (sent via FCM
        //            Messaging.messaging().remoteMessageDelegate = self
        //        } else {
        //            let settings: UIUserNotificationSettings =
        //                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        //            application.registerUserNotificationSettings(settings)
        //        }
        //
        //        application.registerForRemoteNotifications()
        
        //FirebaseApp.configure()
        
        
        return true
    }
    
    func setupGlobalAppearance(){
          
      //global Appearance settings
       let customFont = UIFont.appRegularFontWith(size: 17)
       UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: customFont], for: .normal)
       UITextField.appearance().substituteFontName = Constants.regularFont;
       UILabel.appearance().substituteFontName = Constants.regularFont;
       UILabel.appearance().substituteFontNameBold = Constants.boldFont;
       UIButton.appearance().substituteFontName = Constants.boldFont;Constants.boldFont;
    }
    
    func configureFirebase(application: UIApplication){
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            //Messaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
    }
    func incrementBadgeNumberBy(badgeNumberIncrement: Int) {
        //        let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
        //        let updatedBadgeNumber = currentBadgeNumber + badgeNumberIncrement
        //        if (updatedBadgeNumber > -1) {
        UIApplication.shared.applicationIconBadgeNumber = badgeNumberIncrement
        //}
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return outputImage!
    }
    
    func setInitialVC() {
        let languageSet = UserDefaults.standard.bool(forKey: "language_set");
        self.window = UIWindow(frame: UIScreen.main.bounds)
        var mainController: UIViewController?
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        navigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController;
       if (!languageSet) {
            mainController = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
        navigationController!.setViewControllers([(mainController ?? LanguageVC())], animated: false)
                                //sara
                      navigationController!.navigationBar.isTranslucent = false;
                      self.window?.rootViewController = navigationController
                      self.window?.makeKeyAndVisible()
        }
       else{
          //check login or not
           // if login go to home else go to registeration services
        var isloggedIn = UserDefaults.standard.bool(forKey:"logged_in")
        if(isloggedIn){
            //goTo home
            
             let mainController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
            
//            if(L102Language.getRegisterType() == 2){
//                //school
//                mainController.viewControllers?.remove(at: 1)
//
//            }else if (L102Language.getRegisterType() == 1){
//                //family
//                mainController.viewControllers?.remove(at: 0)
//                 // mainController.viewControllers?.remove(at: 1)
//
//            }
            navigationController!.setViewControllers([mainController], animated: false)
                             //sara
                   navigationController!.navigationBar.isTranslucent = false;
                   self.window?.rootViewController = navigationController
                   self.window?.makeKeyAndVisible()
        
        }else{
            //go to select register as
             mainController = storyboard
                .instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            navigationController!.setViewControllers([(mainController ?? LoginVC())], animated: false)
                                    //sara
                          navigationController!.navigationBar.isTranslucent = false;
                          self.window?.rootViewController = navigationController
                          self.window?.makeKeyAndVisible()
        }
        }
       
       
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        //if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(userInfo)")
        //}
        
        // Print full message.
        print(userInfo)
        if application.applicationState == .active {
            //write your code here when app is in foreground
        } else {
            //write your code here for other state
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        //  if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(userInfo)")
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        //}
        
        // Print full message.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        UserDefaults.standard.setValue(userInfo, forKey: "userInfo");
        
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func moveToNextViewController(notificationType : String){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let rootViewController = self.window!.rootViewController as! UINavigationController

        if(notificationType as! String == "chat"){
            //open
            let chatVC = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController            
            rootViewController.pushViewController(chatVC, animated: true)
            
        }else{
            //open
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)

            let mainController = storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
            mainController.index = 3
            mainController.selectedIndex = 3
            
            //let chatVC = storyboard.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
            
            rootViewController.pushViewController(mainController, animated: true)
        }
        

        

    }
    
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(userInfo)
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(userInfo)
        print(userInfo["gcm.notification.type"])
        print(userInfo["gcm.notification.fathi"])
        //        guard let notificationType = (userInfo["gcm.notification.type"])  else {
        //
        //            return
        //        }
        //
        //        moveToNextViewController(notificationType: notificationType as! String);
        
        
       // guard let notificationLink = (userInfo["gcm.notification.fathi"])  else {
         //   guard let notificationType = (userInfo["gcm.notification.type"])  else {
                
           //     return
           // }
            
            moveToNextViewController(notificationType: "notification" as! String);
            return;
            
        //}
//        if(notificationLink as? String != ""){
//
//            guard let url = URL(string: notificationLink as! String) else {
//                return //be safe
//            }
//
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }else{
//            guard let notificationType = (userInfo["gcm.notification.type"])  else {
//
//                return
//            }
            
            moveToNextViewController(notificationType: "notification" as! String);
            //        }
            
        //}
//        guard let notificationLink = (userInfo["link"])  else {
//
//            return
//        }
//        if(notificationLink as? String != ""){
//
//            guard let url = URL(string: notificationLink as! String) else {
//                return //be safe
//            }
//
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }else{
//            guard let notificationType = (userInfo["gcm.notification.type"])  else {
//
//                return
//            }
//
//            moveToNextViewController(notificationType: notificationType as! String);
//        }
//
        
        completionHandler()
    }
    
    
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Firebase registration token: \(deviceToken)")
        //userDefaults.set(deviceToken, forKey: "fcmToken")
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        userDefaults.set(fcmToken, forKey: "fcmToken")
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        userDefaults.set(fcmToken, forKey: "fcmToken")
    }
    
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        // Convert to pretty-print JSON, just to show the message for testing
        guard let data =
            try? JSONSerialization.data(withJSONObject: remoteMessage.appData, options: .prettyPrinted),
            let prettyPrinted = String(data: data, encoding: .utf8) else {
                return
        }
        print("Received direct channel message:\n\(prettyPrinted)")
    }
    // [END ios_10_data_message]
}

