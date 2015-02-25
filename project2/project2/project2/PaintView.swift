//
//  PaintView.swift
//  project2
//
//  Created by Robert Johansen on 2/21/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

protocol PaintViewDelegate: class {
    
    func addPolyLine(polyline: [CGPoint])
    
}

class PaintView: UIView {
    
    private var _polylines: [[CGPoint]] = []
    private var _points: [CGPoint] = []
    private var _color: UIColor = UIColor.redColor()
    private var _colorChanges = [Int : UIColor]()
    
    private let BUTTON_HEIGHT: CGFloat = 50
    var menuView: MenuView
    weak var delegate: PaintViewDelegate? = nil
    
    override init(frame: CGRect) {
        menuView = MenuView(frame: CGRectMake(0, frame.height - BUTTON_HEIGHT, frame.width, BUTTON_HEIGHT))
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.addSubview(menuView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func collectPointFromTouch(touch: UITouch) {
        let touchPoint: CGPoint  = touch.locationInView(self)
        _points.append(touchPoint)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        collectPointFromTouch(touches.anyObject() as UITouch)
        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        collectPointFromTouch(touches.anyObject() as UITouch)
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        collectPointFromTouch(touches.anyObject() as UITouch)
        _polylines.append(_points)
        _points = []
        setNeedsDisplay()
        delegate?.addPolyLine(_polylines[_polylines.count - 1])
    }
    
    override func drawRect(rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()
        CGContextClearRect(context, bounds)
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, bounds)
        
        var pointIndex: Int
        var point: CGPoint
        
        for (pointIndex = 0; pointIndex < _points.count; pointIndex++) {
            point = _points[pointIndex]
            if (pointIndex == 0) {
                CGContextMoveToPoint(context, point.x, point.y)
            } else {
                CGContextAddLineToPoint(context, point.x, point.y)
            }
        }
        
        for (var polylineIndex: Int = 0; polylineIndex < _polylines.count; polylineIndex++) {
            var points = _polylines[polylineIndex]
            for (pointIndex = 0; pointIndex < points.count; pointIndex++) {
                point = points[pointIndex]
                if (pointIndex == 0) {
                    CGContextMoveToPoint(context, point.x, point.y)
                } else {
                    CGContextAddLineToPoint(context, point.x, point.y)
                }
            }
        }
        
        CGContextSetStrokeColorWithColor(context, _color.CGColor)
        CGContextDrawPath(context, kCGPathStroke)
    }
    
    override func layoutSubviews() {
        menuView.frame = CGRectMake(0, frame.height - BUTTON_HEIGHT, frame.width, BUTTON_HEIGHT)
    }
    
    func setColor(color: UIColor) {
        _color = color
        menuView.colorButton.backgroundColor = color
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        menuView.colorButton.setTitleColor(red == 1.0 && green == 1.0 && blue == 0.0 ? UIColor.blackColor() : UIColor.whiteColor(), forState: .Normal)
    }
    
}
