//
//  WatchViewController.swift
//  project2
//
//  Created by Robert Johansen on 2/21/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class WatchViewController: UIViewController {
    
    var watchView: WatchView { return view as WatchView }
    
    override func loadView() {
        view = WatchView(frame: CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Watch"
    }
    
}
