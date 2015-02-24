//
//  ColorController.swift
//  project2
//
//  Created by Robert Johansen on 2/21/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class ColorController: UIViewController {
    
    var colorView: ColorView { return view as ColorView }
    
    override func loadView() {
        var side: CGFloat = min(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2)
        view = ColorView(frame: CGRectMake(0, 20, side, side))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Color"
    }
    
}
