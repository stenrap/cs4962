//
//  CellView.swift
//  project3
//
//  Created by Robert Johansen on 3/7/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

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
        setNeedsDisplay()
    }
    
    private var type: CellType = CellType.EMPTY
    func getType() -> CellType {return type}
    func setType(type: CellType) {
        self.type = type
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()
        CGContextClearRect(context, bounds)
        
        CGContextSetFillColorWithColor(context, UIColor(red: 17/255, green: 170/255, blue: 188/255, alpha: 1.0).CGColor)
        CGContextFillRect(context, bounds)
        
        var interiorWidth: CGFloat = bounds.width - 1
        var interiorHeight: CGFloat = bounds.height - 1
        
        // Default to the ocean color
        var cellRed: CGFloat = 28/255
        var cellGreen: CGFloat = 107/255
        var cellBlue: CGFloat = 160/255
        
        if (hasShip) {
            var gray: CGFloat = 150/255
            cellRed = gray
            cellGreen = gray
            cellBlue = gray
        }
        
        var interior: CGRect = CGRectMake(1, 1, interiorWidth, interiorHeight)
        CGContextSetFillColorWithColor(context, UIColor(red: cellRed, green: cellGreen, blue: cellBlue, alpha: 1.0).CGColor)
        CGContextFillRect(context, interior)
        
        // TODO .... Draw the hole (dark for empty, red for hit, white for miss)
    }
    
}
