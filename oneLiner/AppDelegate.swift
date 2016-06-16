//
//  AppDelegate.swift
//  oneLiner
//
//  Created by Karthik Kannan on 08/05/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseInstanceID
import FirebaseMessaging


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        FIRApp.configure()  //Configure Firebase according to the new
        
        // Add observer for InstanceID token refresh callback.
        
        func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                         fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
            
            // Print message ID.
            print("Message ID: \(userInfo["gcm.message_id"]!)")
            
            // Print full message.
            print("%@", userInfo)
        }
        func tokenRefreshNotificaiton(notification: NSNotification) {
            let refreshedToken = FIRInstanceID.instanceID().token()!
            print("InstanceID token: \(refreshedToken)")
            
            // Connect to FCM since connection may have failed when attempted before having a token.
            connectToFcm()
        }
        
        func connectToFcm() {
            FIRMessaging.messaging().connectWithCompletion { (error) in
                if (error != nil) {
                    print("Unable to connect with FCM. \(error)")
                } else {
                    print("Connected to FCM.")
                }
            }
        }

        func applicationDidBecomeActive(application: UIApplication) {
            connectToFcm()
        }
        
        func applicationDidEnterBackground(application: UIApplication) {
            FIRMessaging.messaging().disconnect()
            print("Disconnected from FCM.")
        }
        UINavigationBar.appearance().barTintColor = UIColor(red:0.957, green:0.925, blue:0.055, alpha:1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        if let barFont = UIFont(name: "Avenir-Light", size: 24.0) {
            UINavigationBar.appearance().titleTextAttributes =
                [NSForegroundColorAttributeName:UIColor.blackColor(),
                 NSFontAttributeName:barFont]
        
        }
        
        
        
        return true
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
       // print(notificationSettings.types.rawValue)
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        if (application.applicationState == UIApplicationState.Inactive) {
            print("You're here from the push notification, aren't you?")
            self.redirectToView(notification.userInfo)
        }
    }
    
        func redirectToView(userInfo:[NSObject: AnyObject]!) {
            
            let redirectViewController:UIViewController!
        if userInfo != nil {
            if let pageType = userInfo!["TYPE"] {
                if pageType as! String == "SharePage" {
                    redirectViewController = ShareViewController()
                
                }
                
//                if redirectViewController != nil {
//                    if self.window != nil && self.window?.rootViewController != nil {
                       let rootVC = self.window?.rootViewController as! UINavigationController
//                        
                       let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let shareVC = mainStoryboard.instantiateViewControllerWithIdentifier("ShareViewController") as! ShareViewController
                
                        rootVC.pushViewController(shareVC, animated: true)
//                        if rootVC is UINavigationController {
//                            (rootVC as! UINavigationController).pushViewController(redirectViewController, animated: true)
//                        } else {
//                            rootVC?.presentViewController(redirectViewController, animated: false, completion: nil)
//                        }
                    }
                }
                
            }
        }

    


    // MARK: - Core Data stack



