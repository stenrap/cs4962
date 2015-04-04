//
//  GridView.swift
//  project3
//
//  Created by Robert Johansen on 3/7/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

protocol ViewGridDelegate: class {
    
    func viewGridTouched()
    
}

class GridView: UIView, CellViewDelegate {
    
    private var infoLabel: UILabel = UILabel()
    func setInfo(info: String) {infoLabel.text = info}
    
    private var cellSize: CGFloat = 0
    
    private var cellViews = [String: CellView]()
    
    private var startY: CGFloat = 162
    
    private var addedLocations: Bool = false
    
    private var gridTouchAllowed: Bool = false
    func getGridTouchAllowed() -> Bool {return gridTouchAllowed}
    func setGridTouchAllowed(gridTouchAllowed: Bool) {self.gridTouchAllowed = gridTouchAllowed}
    
    weak var cellViewDelegate: CellViewDelegate? = nil
    
    private let BUTTON_HEIGHT: CGFloat = 50
    
    var viewGridButton: UIButton? = nil
    
    weak var viewGridDelegate: ViewGridDelegate? = nil
    
    override func layoutSubviews() {
        if (!addedLocations) {
            var labelY: CGFloat = 74
            var labelX: CGFloat = 10
            var labelWidth: CGFloat = UIScreen.mainScreen().bounds.width
            var labelHeight: CGFloat = 30
            
            infoLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight)
            infoLabel.textColor = UIColor.whiteColor()
            infoLabel.font = UIFont(name: infoLabel.font.fontName, size: 15)
            
            self.addSubview(infoLabel)
            
            cellSize = bounds.width / 11
            
            addLocations()
            
            addedLocations = true
        }
    }
    
    private func addLocations() {
        for (var i: Int = 1; i <= 20; i++) {
            var location: LocationView = LocationView()
            var x: CGFloat = 0
            var y: CGFloat = 0
            var text: String = ""
            var top: Bool = false
            var last: Bool = false
            
            if (i <= 10) {
                x = cellSize * CGFloat(i)
                y = startY
                text = String(i)
                top = true
            } else {
                x = 0
                y = startY + (cellSize * CGFloat(i - 10))
                text = String(UnicodeScalar(i + 54))
                top = false
            }
            
            last = i == 10 || i == 20
            
            location.setLabel(CGRectMake(x, y, cellSize, cellSize), fontSize: 14, text: text, top: top, last: last)
            self.addSubview(location)
        }
    }
    
    func updateCellView(row: String, col: Int, hasShip: Bool, type: CellType, showShips: Bool) {
        var location: String = row + String(col)
        var cellView: CellView? = cellViews[location]
        
        if (cellView == nil) {
            cellSize = UIScreen.mainScreen().bounds.width / 11
            var x: CGFloat = cellSize * CGFloat(col)
            var multiplier: CGFloat = 1
            switch row {
                case "B": multiplier = 2
                case "C": multiplier = 3
                case "D": multiplier = 4
                case "E": multiplier = 5
                case "F": multiplier = 6
                case "G": multiplier = 7
                case "H": multiplier = 8
                case "I": multiplier = 9
                case "J": multiplier = 10
                default: break
            }
            var y: CGFloat = startY + (cellSize * multiplier)
            cellView = CellView(frame: CGRectMake(x, y, cellSize, cellSize))
            cellView!.delegate = self
            cellView!.setRow(row)
            cellView!.setCol(col)
            self.addSubview(cellView!)
        }
        
        cellView!.setHasShip(hasShip)
        cellView!.setType(type)
        cellView!.setShowShips(showShips)
        
        cellViews[location] = cellView!
    }
    
    func cellViewTouched(row: String, col: Int) {
        if (!gridTouchAllowed) {
            return
        }
        gridTouchAllowed = false
        cellViewDelegate?.cellViewTouched(row, col: col)
    }
    
    func addViewGridButtion() {
        viewGridButton = UIButton(frame: CGRectMake(frame.width / 6, frame.height - BUTTON_HEIGHT, 2 * frame.width / 3, BUTTON_HEIGHT))
        viewGridButton!.backgroundColor = UIColor.whiteColor()
        viewGridButton!.setTitle("View My Grid", forState: .Normal)
        viewGridButton!.setTitleColor(UIColor.blackColor(), forState: .Normal)
        viewGridButton!.addTarget(self, action: "viewGridTouched", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(viewGridButton!)
    }
    
    func viewGridTouched() {
        viewGridDelegate?.viewGridTouched()
    }
    
    func changeViewGridButtonLabel(viewingMyGrid: Bool) {
        var text: String = viewingMyGrid ? "View Enemy Grid" : "View My Grid"
        viewGridButton!.setTitle(text, forState: .Normal)
    }
    
}
