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
    
    override func layoutSubviews() {
        if (self.subviews.count == 0) {
            var labelY: CGFloat = 74
            var labelX: CGFloat = 10
            var labelWidth: CGFloat = UIScreen.mainScreen().bounds.width
            var labelHeight: CGFloat = 30
            
            playerNameLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight)
            instructionLabel.frame = CGRectMake(labelX, labelY + labelHeight, labelWidth, labelHeight)
            
            self.addSubview(playerNameLabel)
            self.addSubview(instructionLabel)
        }
    }
    
    override func drawRect(rect: CGRect) {
        // WYLO .... Draw the grid for real!
    }
    
}
