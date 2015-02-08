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
        CGContextClosePath(context);
        
        var inner:CGRect = CGRectMake(2, 2, bounds.width - 4, bounds.height - 4)
        CGContextAddEllipseInRect(context, inner)
        CGContextClosePath(context);
        
        CGContextSetFillColorWithColor(context, UIColor(hue: 0, saturation: 0, brightness: 0.125, alpha: 1).CGColor)
        CGContextEOFillPath(context);
    }
    
}
