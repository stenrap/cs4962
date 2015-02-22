//
//  PaintView.swift
//  project2
//
//  Created by Robert Johansen on 2/21/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class PaintView: UIView {
    
    private let BUTTON_HEIGHT: CGFloat = 50
    var menuView: MenuView
    weak var delegate: MenuViewDelegate? = nil
    
    override init(frame: CGRect) {
        menuView = MenuView(frame: CGRectMake(0, frame.height - BUTTON_HEIGHT, frame.width, BUTTON_HEIGHT))
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.addSubview(menuView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()
    }
    
    override func layoutSubviews() {
        menuView.frame = CGRectMake(0, frame.height - BUTTON_HEIGHT, frame.width, BUTTON_HEIGHT)
    }
    
}
