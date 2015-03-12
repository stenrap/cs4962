//
//  GridView.swift
//  project3
//
//  Created by Robert Johansen on 3/7/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class GridView: UIView {
    
    private var playerNameLabel: UILabel = UILabel()
    func setPlayerName(playerName: String) {playerNameLabel.text = playerName}
    
    private var instructionLabel: UILabel = UILabel()
    func setInstruction(instruction: String) {instructionLabel.text = instruction}
    
    private var cellSize: CGFloat = 0
    
    private var cellViews = [String: CellView]()
    
    private var startY: CGFloat = 162
    
    private var addedLocations: Bool = false
    
    override func layoutSubviews() {
        if (!addedLocations) {
            var labelY: CGFloat = 74
            var labelX: CGFloat = 10
            var labelWidth: CGFloat = UIScreen.mainScreen().bounds.width
            var labelHeight: CGFloat = 30
            
            playerNameLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight)
            playerNameLabel.textColor = UIColor.whiteColor()
            
            instructionLabel.frame = CGRectMake(labelX, labelY + labelHeight, labelWidth, labelHeight)
            instructionLabel.textColor = UIColor.whiteColor()
            
            self.addSubview(playerNameLabel)
            self.addSubview(instructionLabel)
            
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
    
    func updateCellView(row: String, col: Int, hasShip: Bool, type: CellType) {
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
            cellView!.setRow(row)
            cellView!.setCol(col)
            self.addSubview(cellView!)
        }
        
        cellView!.setHasShip(hasShip)
        cellView!.setType(type)
        
        cellViews[location] = cellView!
    }
    
}
