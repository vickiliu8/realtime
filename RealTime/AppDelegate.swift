//
//  AppDelegate.swift
//  RealTime
//
//  Created by Vicki  Liu on 8/19/15.
//  Copyright (c) 2015 vickiliu. All rights reserved.
//

import UIKit
import Parse
import Bolts
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.enableLocalDatastore()
    Parse.setApplicationId("XF7n0q72zIccNSK430zyyT8FOszS0ccykse2UGa1", clientKey: "I6oSUS731IQL2nRNadweHAef9zH1GZmOroVSr5JD")
        
        //PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
      PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)

        
        //var tableVC:EventsTableViewController = EventsTableViewController(className: "Event")
      //  tableVC.title = "RealTime"
        
        
        /*UINavigationBar.appearance().tintColor = UIColor(red: 0.05, green: 0.47, blue: 0.91, alpha: 1.0)
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.05, green: 0.47, blue: 0.91, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent*/
        
        
      /*  var navigationVC:UINavigationController = UINavigationController(rootViewController: tableVC)
        
        let frame = UIScreen.mainScreen().bounds
        window = UIWindow(frame: frame)
        
        window!.rootViewController = navigationVC
        window!.makeKeyAndVisible()*/
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIToolbar.appearance().barTintColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        //UIToolbar.appearance().setFrame(CGRectMake(0, 50, 320, 35))
        UIToolbar.appearance().tintColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        //PFUser.enableAutomaticUser()
        
        let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
        defaultACL.setPublicReadAccess(true)
        
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)
        
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let types = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
            var setting = UIUserNotificationSettings(forTypes: types, categories: nil);
            UIApplication.sharedApplication().registerUserNotificationSettings(setting);
            UIApplication.sharedApplication().registerForRemoteNotifications();
        }
        
        return true
    }
    
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject?) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(
                application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }

    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
        
        PFPush.subscribeToChannelInBackground("") { (succeeded: Bool, error: NSError?) in
            if succeeded {
                println("ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
            } else {
                println("ParseStarterProject failed to subscribe to push notifications on the broadcast channel with error = %@.", error)
            }
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }
    
    func applicationWillResignActive(application: UIApplication) { // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state. // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        }
    
    func applicationDidEnterBackground(application: UIApplication) { // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        }
    
    func applicationWillEnterForeground(application: UIApplication) { // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background. 
    }
    
    func applicationDidBecomeActive(application: UIApplication) { // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface. 
        
       FBSDKAppEvents.activateApp()
    }
    
    
    func applicationWillTerminate(application: UIApplication) { // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    }
    
    
   
    
    ///////////////////////////////////////////////////////////
    // Uncomment this method if you want to use Push Notifications with Background App Refresh
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    //     if application.applicationState == UIApplicationState.Inactive {
    //         PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
    //     }
    // }
    
    //--------------------------------------
    // MARK: Facebook SDK Integration
    //--------------------------------------
    
    ///////////////////////////////////////////////////////////
    // Uncomment this method if you are using Facebook
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
    //     return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication, session:PFFacebookUtils.session())
    // }
}
