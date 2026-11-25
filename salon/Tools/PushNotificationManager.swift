//
//  PushNotificationManager.swift
//  harajKamel
//
//  Created by AL Badr  on 10/31/19.
//  Copyright © 2019 ALBadr. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Firebase
import FirebaseFirestore
import FirebaseMessaging
import UserNotifications

class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    let userID: String
    var window: UIWindow?
    
    init(userID: String) {
        self.userID = userID
        super.init()
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        updateFirestorePushTokenIfNeeded()
    }
    
    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            let usersRef = Firestore.firestore().collection("users_table").document(userID)
            usersRef.setData(["fcmToken": token], merge: true)
            print("fcmToken", token)
            Helper.saveUserDefault(key: UserDefault.player_id, value: token)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        updateFirestorePushTokenIfNeeded()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let dict = response.notification.request.content.userInfo as! [String: Any]
        
        let json = JSON(dict)
        print("Message userInfo", json)

         let userDate = Helper.getObjectDefault(key: UserDefault.userData) as? LoginData
         let userType = userDate?.type ?? ""
         
        let type = json["type"].stringValue
        let reservation_id = json["reservation_id"].stringValue
        let reciver_id = json["msg"].stringValue
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        switch (type) {
//        case "payment":
//            if let controller = UIStoryboard(name: Storyboards.provider, bundle: nil).instantiateViewController(withIdentifier: "paymentNC") as? UINavigationController,
//                let vc = controller.viewControllers.first as? PayDueVC {
//                vc.title = "دفع العمولة"
//                vc.fromRemoteNotifications = true
//                self.window?.rootViewController = controller
//                self.window?.makeKeyAndVisible()
//            }
//
//        case "admin":
//            if let controller = UIStoryboard(name: Storyboards.user, bundle: nil).instantiateViewController(withIdentifier: "notificationsNC") as? UINavigationController,
//                let vc = controller.viewControllers.first as? NotificationsVC {
//                vc.title = "الإشعارات"
//                vc.fromRemoteNotifications = true
//                self.window?.rootViewController = controller
//                self.window?.makeKeyAndVisible()
//            }
    
        case "new message":
            if let controller = UIStoryboard(name: Storyboards.user, bundle: nil).instantiateViewController(withIdentifier: "chatNC") as? UINavigationController,
                let vc = controller.viewControllers.first as? ChatVC {
                vc.title = "الرسائل"
                vc.clientId = String(reciver_id).replacingOccurrences(of: "chat/", with: "")
                vc.fromRemoteNotifications = true
                self.window?.rootViewController = controller
                self.window?.makeKeyAndVisible()
            }

        case "reservation":
            if userType == "provider" {
                if let controller = UIStoryboard(name: Storyboards.provider, bundle: nil).instantiateViewController(withIdentifier: "providerOrdersNC") as? UINavigationController,
                    let vc = controller.viewControllers.first as? ProviderOrdersVC {
                    vc.title = "مطلوب"
                    vc.reservation_id = String(reservation_id)
                    vc.fromRemoteNotifications = true
                    self.window?.rootViewController = controller
                    self.window?.makeKeyAndVisible()
                }
            }else {
                if let controller = UIStoryboard(name: Storyboards.user, bundle: nil).instantiateViewController(withIdentifier: "clientOrdersNC") as? UINavigationController,
                    let vc = controller.viewControllers.first as? MyOrdersVC {
                    vc.title = "طلباتي"
                    vc.reservation_id = String(reservation_id)
                    vc.fromRemoteNotifications = true
                    self.window?.rootViewController = controller
                    self.window?.makeKeyAndVisible()
                }
            }

        default:
//            let main = UIStoryboard(name: Storyboards.main, bundle: nil)
//            let mainvc = main.instantiateViewController(withIdentifier: "mainNC")
//            self.window?.rootViewController = mainvc
//            self.window?.makeKeyAndVisible()
            
            if let controller = UIStoryboard(name: Storyboards.user, bundle: nil).instantiateViewController(withIdentifier: "notificationsNC") as? UINavigationController,
                let vc = controller.viewControllers.first as? NotificationsVC {
                vc.title = "الإشعارات"
                vc.fromRemoteNotifications = true
                self.window?.rootViewController = controller
                self.window?.makeKeyAndVisible()
            }
        }
        
        Messaging.messaging().appDidReceiveMessage(dict)
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        print("Message = didReceiveRemoteNotification = ", JSON(userInfo))
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        
        
        // Print full message.
        print("Message = willPresent", JSON(userInfo))
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
    }
}
