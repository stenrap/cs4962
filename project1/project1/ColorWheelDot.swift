//
//  ColorWheelDot.swift
//  project1
//
//  Created by Robert Johansen on 2/7/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class ColorWheelDot: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let context:CGContext = UIGraphicsGetCurrentContext()
        
        CGContextAddEllipseInRect(context, bounds)
        CGContextSetFillColorWithColor(context, UIColor(hue: 1, saturation: 1, brightness: 1, alpha: 0.375).CGColor)
        CGContextDrawPath(context, kCGPathFill)
    }
    
}
