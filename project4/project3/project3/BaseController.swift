//
//  BaseController.swift
//  project3
//
//  Created by Robert Johansen on 3/4/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class BaseController: UIViewController {
    
    var model: BattleShip = BattleShip()
    var gameId: Int = -1
    
    func showAlert(title: String, message: String, handler: ((UIAlertAction!) -> Void)! = nil) {
        var alert = UIAlertController(title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: handler))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
