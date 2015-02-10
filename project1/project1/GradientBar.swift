//
//  GradientBar.swift
//  project1
//
//  Created by Robert Johansen on 2/9/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class GradientBar: UIView {
    
    private var alphaGradient: Bool
    private var r: CGFloat = 1.0
    private var g: CGFloat = 1.0
    private var b: CGFloat = 1.0
    
    init(frame: CGRect, alphaGradient alphaGrad: Bool) {
        self.alphaGradient = alphaGrad
        // WYLO .... Add a ColorWheelDot like you did in the ColorWheel class, and move it based on the click location.
        super.init(frame: frame)
        self.frame.origin.x = (UIScreen.mainScreen().bounds.width - self.frame.width) / 2
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNewColor(h: CGFloat, s: CGFloat) {
        var v: CGFloat = 1.0
        var H = (360 * h) / 60
        var C = v * s
        var X = C * (1 - abs(H % 2 - 1))
        
        if (0 <= H && H < 1) {
            r = C
            g = X
            b = 0
        } else if (1 <= H && H < 2) {
            r = X
            g = C
            b = 0
        } else if (2 <= H && H < 3) {
            r = 0
            g = C
            b = X
        } else if (3 <= H && H < 4) {
            r = 0
            g = X
            b = C
        } else if (4 <= H && H < 5) {
            r = X
            g = 0
            b = C
        } else if (5 <= H && H < 6) {
            r = C
            g = 0
            b = X
        }
        
        var m = v - C
        r += m
        g += m
        b += m
        
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let context:CGContext = UIGraphicsGetCurrentContext()
        
        CGContextClearRect(context, self.bounds)
        
        var squareSize: CGFloat = 6
        var rowCount = 1
        var white: Bool = true;
        
        if (alphaGradient) {
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
        }
        
        var numLocations:size_t = 2
        var locations: [CGFloat] = [0.0, 1.0]
        var components: [CGFloat] = [r, g, b, 1.0, // start color
                                     0.0, 0.0, 0.0, alphaGradient ? 0.0 : 1.0] // end color
        
        var colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        var gradient: CGGradientRef = CGGradientCreateWithColorComponents(colorSpace, components, locations, numLocations)
        
        var startPoint: CGPoint = CGPoint(x: 0.0, y: frame.height / 2)
        var endPoint: CGPoint = CGPoint(x: frame.width, y: frame.height / 2)
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0)
    }
    
}
