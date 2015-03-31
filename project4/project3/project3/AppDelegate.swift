//
//  AppDelegate.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = UINavigationController(rootViewController: StatusController())
        window?.makeKeyAndVisible()
        return true
    }
    
    /*
        Networked Battleship Pseudo Code:
    
        1. App launches.
    
                2. App reads array of playerIds from file:
                    481a2b7e-fc92-4b80-af98-89ac168a09f
                    a9668def-1ef0-41e1-b756-ebafb3e7993
                    fc08046d-bb29-402c-93bf-3e598aae6b1c
    
        2. App reads array of gameIds from file:
            1e21d010-30d8-4757-ad6a-6f16ce6697e
            b7d1066b-b2a0-493c-b55b-060e2e4bf99
    
        3. 
    */
    
}

