//
//  StruxController.swift
//  projectF
//
//  Created by Robert Johansen on 4/18/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class StruxController: UIViewController, DigistruxDelegate {
    
    var model: Digistrux = Digistrux()
    
    func getStruxView() -> StruxView {return view as StruxView}
    
    override func loadView() {
        view = StruxView()
        // WYLO .... Call getStruxView().setUrl() with the correct parameters...
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var myBackButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        myBackButton.addTarget(self, action: "popToRoot", forControlEvents: UIControlEvents.TouchUpInside)
        myBackButton.setTitle("< home", forState: UIControlState.Normal)
        myBackButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        myBackButton.sizeToFit()
        
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    func popToRoot() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
