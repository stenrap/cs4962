//
//  ColorWheel.swift
//  project1
//
//  Created by Robert Johansen on 2/7/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

protocol ColorWheelDelegate: class {
    
    func color(colorWheel: ColorWheel, newHue hue: CGFloat, newSaturation saturation: CGFloat)
    
}

class ColorWheel: UIView {
    
    private var dot: ColorWheelDot
    private let DOT_SIZE: CGFloat = 32
    
    weak var delegate: ColorWheelDelegate? = nil
    
    override init(frame: CGRect) {
        dot = ColorWheelDot(frame: CGRectMake(frame.midX - DOT_SIZE / 2, frame.midY - DOT_SIZE / 2 - 20, DOT_SIZE, DOT_SIZE))
        super.init(frame: frame)
        self.addSubview(dot)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let context:CGContext = UIGraphicsGetCurrentContext()
        
        let radius: Int = Int(frame.width) / 2
        
        for var row = 0; row < Int(frame.height); row++ {
            for var col = 0; col < Int(frame.width); col++ {
                var (result, thisHue, thisSaturation) = withinColorWheel(col, y: row, radius: radius)
                if (result) {
                    CGContextAddRect(context, CGRectMake(CGFloat(col), CGFloat(row), 1, 1))
                    CGContextSetFillColorWithColor(context, UIColor(hue: thisHue, saturation: thisSaturation, brightness: 1, alpha: 1).CGColor)
                    CGContextDrawPath(context, kCGPathFill)
                }
            }
        }
        
        self.frame.origin.x = (UIScreen.mainScreen().bounds.width - self.frame.width) / 2
    }
    
    func withinColorWheel(x: Int, y: Int, radius: Int) -> (result: Bool, hue: CGFloat, saturation: CGFloat) {
        var opposite = abs(radius - x)
        var adjacent = abs(radius - y)
        var arctan = 0.0
        var quadrant = 0
        if (x < radius) {
            if (y < radius) {
                quadrant = 1
            } else {
                quadrant = 2
            }
        } else {
            if (y >= radius) {
                quadrant = 3
            }
        }
        var angle = 0.0
        if (adjacent == 0) {
            if (quadrant == 1 || quadrant == 2) {
                angle = 180
            }
        } else {
            if (quadrant == 2) {
                var temp = opposite
                opposite = adjacent
                adjacent = temp
            }
            arctan = atan(Double(opposite) / Double(adjacent))
            angle = arctan * (180 / M_PI) + (Double(quadrant) * 90)
        }
        if (quadrant == 0) {
            angle = 90 - angle
        }
        var hypotenuse = sqrt(Double(opposite * opposite + adjacent * adjacent))
        if (Int(hypotenuse) > radius) {
            return (false, CGFloat(0.0), CGFloat(0.0))
        } else {
            return (true, CGFloat(angle) / 360.0, CGFloat(hypotenuse) / CGFloat(radius))
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let touch: UITouch = touches.anyObject() as UITouch
        let touchPoint: CGPoint = touch.locationInView(self)
        var (result, thisHue, thisSaturation) = withinColorWheel(Int(touchPoint.x), y: Int(touchPoint.y), radius: Int(frame.width) / 2)
        if (result) {
            println("The touch point is (\(touchPoint.x),\(touchPoint.y))")
            dot.frame = CGRectMake(touchPoint.x - DOT_SIZE / 2, touchPoint.y - DOT_SIZE / 2, dot.frame.width, dot.frame.height)
            delegate?.color(self, newHue: thisHue, newSaturation: thisSaturation)
        }
    }

}
