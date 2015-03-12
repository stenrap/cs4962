//
//  NamesView.swift
//  project3
//
//  Created by Robert Johansen on 3/4/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class NamesView: UIView {
    
    private var player1NameField: UITextField = UITextField()
    private var player2NameField: UITextField = UITextField()
    
    override func layoutSubviews() {
        if (self.subviews.count == 0) {
            var fieldY: CGFloat = 84
            var fieldWidth: CGFloat = UIScreen.mainScreen().bounds.width / 2
            var fieldHeight: CGFloat = 40
            var fieldX = (UIScreen.mainScreen().bounds.width - fieldWidth) / 2
            
            player1NameField.frame = CGRectMake(fieldX, fieldY, fieldWidth, fieldHeight)
            player1NameField.borderStyle = UITextBorderStyle.Bezel
            player1NameField.placeholder = "Player 1 Name"
            
            fieldY = fieldY + player1NameField.bounds.height + 20
            
            player2NameField.frame = CGRectMake(fieldX, fieldY, fieldWidth, fieldHeight)
            player2NameField.borderStyle = UITextBorderStyle.Bezel
            player2NameField.placeholder = "Player 2 Name"
            
            self.addSubview(player1NameField)
            self.addSubview(player2NameField)
            
            player1NameField.becomeFirstResponder()
        }
    }
    
    func getPlayer1Name() -> String {
        return player1NameField.text
    }
    
    func getPlayer2Name() -> String {
        return player2NameField.text
    }
    
}
