//
//  NamesView.swift
//  project3
//
//  Created by Robert Johansen on 3/4/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class NamesView: UIView {
    
    private var playerNameField: UITextField = UITextField()
    private var gameNameField: UITextField = UITextField()
    private var gameNameVisible: Bool
    
    init(_ gameNameVisible: Bool) {
        self.gameNameVisible = gameNameVisible
        super.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        if (self.subviews.count == 0) {
            var fieldY: CGFloat = 84
            var fieldWidth: CGFloat = UIScreen.mainScreen().bounds.width / 2
            var fieldHeight: CGFloat = 40
            var fieldX = (UIScreen.mainScreen().bounds.width - fieldWidth) / 2
            
            playerNameField.frame = CGRectMake(fieldX, fieldY, fieldWidth, fieldHeight)
            playerNameField.borderStyle = UITextBorderStyle.Bezel
            playerNameField.placeholder = "Player Name"
            
            fieldY = fieldY + playerNameField.bounds.height + 20
            
            gameNameField.frame = CGRectMake(fieldX, fieldY, fieldWidth, fieldHeight)
            gameNameField.borderStyle = UITextBorderStyle.Bezel
            gameNameField.placeholder = "Game Name"
            
            self.addSubview(playerNameField)
            
            if (gameNameVisible) {
                self.addSubview(gameNameField)
            }
            
            playerNameField.becomeFirstResponder()
        }
    }
    
    func getPlayerName() -> String {
        return playerNameField.text
    }
    
    func getGameName() -> String {
        return gameNameField.text
    }
    
    func disableNameFields() {
        playerNameField.enabled = false
        gameNameField.enabled = false
    }
    
}
