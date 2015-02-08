//
//  AppDelegate.swift
//  project1
//
//  Created by Robert Johansen on 2/6/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

/*
    The hue has its 3 primary colors at the following angles:

        0 or 360 degrees = red
        120      degrees = green
        240      degrees = blue

    The 6 main colors around the edge are red, yellow, green, cyan, blue, and magenta

*/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        
        var side: CGFloat = min(window!.frame.width / 2, window!.frame.height / 2)
        
        var colorWheel = ColorWheel(frame: CGRectMake(0, 0, side, side))
        
        colorWheel.backgroundColor = UIColor.darkGrayColor()
        window?.addSubview(colorWheel)
        
        println("The width  is \(window!.frame.width)")
        println("The height is \(window!.frame.height)")
        println("The origin is (\(colorWheel.frame.origin.x),\(colorWheel.frame.origin.y))")
        
        return true
    }
    
    /*

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    */

}

