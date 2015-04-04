//
//  CellView.swift
//  project3
//
//  Created by Robert Johansen on 3/7/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

protocol CellViewDelegate: class {
    
    func cellViewTouched(row: String, col: Int)
    
}

class CellView: UIView {
    
    private var row: String = ""
    func getRow() -> String {return row}
    func setRow(row: String) {self.row = row}
    
    private var col: Int = 0
    func getCol() -> Int {return col}
    func setCol(col: Int) {self.col = col}
    
    private var hasShip: Bool = false
    func getHasShip() -> Bool {return hasShip}
    func setHasShip(hasShip: Bool) {
        self.hasShip = hasShip
    }
    
    private var type: CellType = CellType.NONE
    func getType() -> CellType {return type}
    func setType(type: CellType) {
        self.type = type
        setNeedsDisplay()
    }
    
    private var showShips: Bool = true
    func getShowShips() -> Bool {return showShips}
    func setShowShips(showShips: Bool) {
        self.showShips = showShips
        setNeedsDisplay()
    }
    
    weak var delegate: CellViewDelegate? = nil
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if (getRow() == "" || getCol() == 0) {
            return
        }
        delegate?.cellViewTouched(getRow(), col: getCol())
    }
    
    override func drawRect(rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()
        CGContextClearRect(context, bounds)
        
        CGContextSetFillColorWithColor(context, UIColor(red: 17/255, green: 170/255, blue: 188/255, alpha: 1.0).CGColor)
        CGContextFillRect(context, bounds)
        
        var interiorWidth: CGFloat = bounds.width - 1
        var interiorHeight: CGFloat = bounds.height - 1
        
        if (getCol() == 10) {
            interiorWidth -= 1
        }
        
        if (getRow() == "J") {
            interiorHeight -= 1
        }
        
        // Default to the ocean color
        var r: CGFloat = 28/255
        var g: CGFloat = 107/255
        var b: CGFloat = 160/255
        var a: CGFloat = 1
        
        if (hasShip && showShips) {
            var gray: CGFloat = 150/255
            r = gray
            g = gray
            b = gray
        }
        
        var interior: CGRect = CGRectMake(1, 1, interiorWidth, interiorHeight)
        CGContextSetFillColorWithColor(context, UIColor(red: r, green: g, blue: b, alpha: a).CGColor)
        CGContextFillRect(context, interior)
        
        // Draw the hole (dark for empty, red for hit, white for miss)
        var circleSize: CGFloat = bounds.width / 3
        var circle: CGRect = CGRectMake(circleSize, circleSize, circleSize, circleSize)
        
        // Default to black
        r = 0
        g = 0
        b = 0
        a = hasShip && showShips ? 0.5 : 0.1875
        
        if (type == CellType.MISS) {
            r = 255
            g = 255
            b = 255
            a = 1
        } else if (type == CellType.HIT) {
            r = 255
            g = 0
            b = 0
            a = 1
        }
        
        CGContextSetFillColorWithColor(context, UIColor(red: r, green: g, blue: b, alpha: a).CGColor)
        CGContextFillEllipseInRect(context, circle)
    }
    
}
