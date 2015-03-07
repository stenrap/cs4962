//
//  LocationView.swift
//  project3
//
//  Created by Robert Johansen on 3/7/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class LocationView: UIView {
    
    private var label: UILabel = UILabel()
    private var top: Bool = false
    private var last: Bool = false
    
    func setLabel(frame: CGRect, fontSize: CGFloat, text: String, top: Bool, last: Bool) {
        self.frame = frame
        label.frame = CGRectMake(0, 0, frame.width, frame.height)
        label.font = UIFont(name: "Helvetica", size: fontSize)
        label.text = text
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        self.top = top
        self.last = last
        self.addSubview(label)
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()
        CGContextClearRect(context, bounds)
        
        CGContextSetFillColorWithColor(context, UIColor(red: 17/255, green: 170/255, blue: 188/255, alpha: 1.0).CGColor)
        CGContextFillRect(context, bounds)
        
        var interiorWidth: CGFloat = bounds.width - 1
        var interiorHeight: CGFloat = bounds.height - 1
        if (last) {
            interiorWidth = top ? bounds.width - 2 : bounds.width - 1
            interiorHeight = top ? bounds.width - 1 : bounds.width - 2
        }
        var interior: CGRect = CGRectMake(1, 1, interiorWidth, interiorHeight)
        CGContextSetFillColorWithColor(context, UIColor(red: 28/255, green: 107/255, blue: 160/255, alpha: 1.0).CGColor)
        CGContextFillRect(context, interior)
    }
    
}
