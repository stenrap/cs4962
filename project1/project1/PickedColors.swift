//
//  PickedColors.swift
//  project1
//
//  Created by Robert Johansen on 2/9/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class PickedColors: UIView {
    
    var newHue: CGFloat = 0.0
    var newSaturation: CGFloat = 0.0
    var newValue: CGFloat = 1.0
    var newAlpha: CGFloat = 1.0
    
    var oldHue: CGFloat = 1.0
    var oldSaturation: CGFloat = 1.0
    var oldValue: CGFloat = 1.0
    var oldAlpha: CGFloat = 0.0
    
    func setNewColor(hue: CGFloat, saturation: CGFloat, value: CGFloat, alpha: CGFloat) {
        oldHue = newHue
        oldSaturation = newSaturation
        oldValue = newValue
        oldAlpha = newAlpha
        
        newHue = hue
        newSaturation = saturation
        newValue = value
        newAlpha = alpha
        
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let context:CGContext = UIGraphicsGetCurrentContext()
        CGContextClearRect(context, self.bounds)
        
        var squareSize: CGFloat = 6
        var rowCount = 1
        var white: Bool = true;
        
        for (var row = 0; row < Int(frame.height); row += Int(squareSize)) {
            white = rowCount % 2 == 0 ? false : true
            for (var col = 0; col < Int(frame.width); col += Int(squareSize)) {
                var square: CGRect = CGRectMake(CGFloat(col), CGFloat(row), squareSize, squareSize)
                CGContextAddRect(context, square)
                CGContextSetFillColorWithColor(context, white ? UIColor.whiteColor().CGColor : UIColor.blackColor().CGColor)
                CGContextDrawPath(context, kCGPathFill)
                white = !white
            }
            rowCount++
        }
        
        var oldColor: CGRect = CGRectMake(0, 0, bounds.width / 2, bounds.height)
        CGContextAddRect(context, oldColor)
        CGContextSetFillColorWithColor(context, UIColor(hue: oldHue, saturation: oldSaturation, brightness: oldValue, alpha: oldAlpha).CGColor)
        CGContextDrawPath(context, kCGPathFill)
        
        var newColor: CGRect = CGRectMake(bounds.width / 2, 0, bounds.width / 2, bounds.height)
        CGContextAddRect(context, newColor)
        CGContextSetFillColorWithColor(context, UIColor(hue: newHue, saturation: newSaturation, brightness: newValue, alpha: newAlpha).CGColor)
        CGContextDrawPath(context, kCGPathFill)
        
        self.frame.origin.x = (UIScreen.mainScreen().bounds.width - self.frame.width) / 2
    }
    
}
