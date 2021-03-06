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
    
    var payload: NSString?
    var payloadSource: NSString?
    var payloadTopic: NSString?
    
    

    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }

    func tokenRefreshNotificaiton(notification: NSNotification) {
        if (FIRInstanceID.instanceID().token() != nil) {
        let refreshedToken = FIRInstanceID.instanceID().token()!
            print("InstanceID token: \(refreshedToken)")

        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
       // print("in didfinish launching.")
        
        //Create the 'Share' Notification Category. Swipe right and I see 'Share'.
        
        if launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] != nil {
            print("From launchOptions push notification.")
            payload =   launchOptions![UIApplicationLaunchOptionsRemoteNotificationKey] as? NSString
            let rootVC = self.window?.rootViewController as! UINavigationController
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let shareVC = mainStoryboard.instantiateViewControllerWithIdentifier("ShareViewController") as! ShareViewController
            
            rootVC.pushViewController(shareVC, animated: true)
            
        }

        let notificationShare :UIMutableUserNotificationAction =
            UIMutableUserNotificationAction()
        notificationShare.identifier = "SHARE_IDENTIFIER"
        notificationShare.title = "👍 Share" //some inspiration from the Quartz App. TODO: Find a way to make it new everyday.
        notificationShare.destructive = false
        notificationShare.activationMode = .Background
        
        //the 'Share Category'
        
        let notificationCategory: UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        notificationCategory.identifier = "SHARE_CATEGORY"
        notificationCategory.setActions([notificationShare], forContext: .Minimal)
        
        
        
        
        let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories:[notificationCategory])
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        FIRApp.configure()  //Configure Firebase according to the new
        
        // Add observer for InstanceID token refresh callback.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.tokenRefreshNotificaiton),name: kFIRInstanceIDTokenRefreshNotification, object: nil)
        
                UINavigationBar.appearance().barTintColor = UIColor(red:0.957, green:0.925, blue:0.055, alpha:1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        if let barFont = UIFont(name: "Avenir-Light", size: 24.0) {
            UINavigationBar.appearance().titleTextAttributes =
                [NSForegroundColorAttributeName:UIColor.blackColor(),
                 NSFontAttributeName:barFont]
                        
        
        }
        
        return true
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        // Print message ID.
      //  print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
       // print("%@", userInfo)
        //print(userInfo["aps"]!["alert"]!)
        //print(userInfo["source"]!)
        
        print("Called from didRecieveRemoteNotification.")
        
        if let source = userInfo["source"] as? NSString {
            self.payloadSource = source
        }
        
        if let topic = userInfo["topic"] as? NSString {
            self.payloadTopic = topic
        }
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let message = alert["message"] as? NSString {
                    
                    //save the payload to a global variable. Call it in ShareViewController.
                    print("This is the message: \(message)")
                }
            } else if let alert = aps["alert"] as? NSString {
                print("This is alert and not a message \(alert)")
                self.payload = alert
                
                //NSUserDefaults.standardUserDefaults().setValue(Massage!, forKey: "payload")
                

            }
        }

        if(application.applicationState == .Inactive) {
            print("application is inactive.")
            redirectToView(userInfo)
        }
        
        if (application.applicationState == .Active) {
            print("application in foreground")
            redirectToView(userInfo)
        }
        
        if (application.applicationState == .Background ) {
            print("New data in.")
            redirectToView(userInfo)
        }
        
        completionHandler(.NewData)

        
//        redirectToView(userInfo)
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Prod)
    }
    
    
    func redirectToView(userInfo:[NSObject: AnyObject]!) {
        
        let redirectViewController:UIViewController!
        if userInfo != nil {
            if userInfo!["aps"] != nil {
                    redirectViewController = ShareViewController()
                    
                
                
                                let rootVC = self.window?.rootViewController as! UINavigationController
                //
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let shareVC = mainStoryboard.instantiateViewControllerWithIdentifier("ShareViewController") as! ShareViewController
                
                rootVC.pushViewController(shareVC, animated: true)
            }
        }
        
    }
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        connectToFcm()
        //print("This is from application did become active \(payload)")
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }

    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
       // print(notificationSettings.types.rawValue)
    }
    
    
        }




