//
//  StruxListController.swift
//  projectF
//
//  Created by Robert Johansen on 4/13/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class StruxListController: UITableViewController, UITableViewDelegate, DigistruxDelegate {
    
    var model: Digistrux = Digistrux()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var leftButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "showSettings")
        self.navigationItem.leftBarButtonItem  = leftButtonItem
        
        var rightButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "showCamera")
        self.navigationItem.rightBarButtonItem  = rightButtonItem
        
        title = "digistrux"
    }
    
    func showSettings() {
        var settingsController: SettingsController = SettingsController()
        settingsController.model = model
        settingsController.model.delegate = settingsController
        navigationController?.pushViewController(settingsController, animated: true)
    }
    
    func showCamera() {
        var scanController: ScanController = ScanController()
        scanController.model = model
        scanController.model.delegate = scanController
        navigationController?.pushViewController(scanController, animated: true)
    }
    
}
