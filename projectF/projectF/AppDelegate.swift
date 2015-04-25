//
//  AppDelegate.swift
//  projectF
//
//  Created by Robert Johansen on 4/11/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SplashControllerDelegate {

    var window: UIWindow?
    var splashController: SplashController = SplashController()
    var model: Digistrux = Digistrux()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        splashController.delegate = self
        window?.rootViewController = splashController
        window?.makeKeyAndVisible()
        
        model.readFromFile()
        
        return true
    }
    
    func splashTimeOut() {
        var struxListController: StruxListController = StruxListController()
        struxListController.model = model
        struxListController.model.delegate = struxListController
        window?.rootViewController = UINavigationController(rootViewController: struxListController)
    }

}

