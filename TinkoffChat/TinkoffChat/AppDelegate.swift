//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 20/09/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//  https://makeappicon.com/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
        //This can occur for certain types of temporary interruptions (such as an incoming phone call or
        //SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks.
        //Games should use this method to pause the game.
        printInfo(fromState: "active", toState: "inactive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers,
        //and store enough application state information to restore your application to its current state in case it is terminated
        //later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        printInfo(fromState: "inactive", toState: "background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        printInfo(fromState: "background", toState: "inactive")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        printInfo(fromState: "inactive", toState: "active")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        printInfo(fromState: "suspend", toState: "don't exist")
    }

    func printInfo(fromState: String, toState: String, funcName: String = #function) {
        print("Application moved from " + fromState+" to " + toState+" methood name:"+funcName)
    }

}
