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
    
    override func layoutSubviews() {
        if (self.subviews.count == 0) {
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
            
            // WYLO .... Add the cells (somehow...this view should not get them directly from the model)
        }
    }
    
    private func addLocations() {
        var startY: CGFloat = 162
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
    
}
