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
    
    func setColor(color: UIColor) {
        menuView.colorButton.backgroundColor = color
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        menuView.colorButton.setTitleColor(red == 1.0 && green == 1.0 && blue == 0.0 ? UIColor.blackColor() : UIColor.whiteColor(), forState: .Normal)
    }
    
}
