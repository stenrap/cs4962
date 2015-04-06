//
//  DetailView.swift
//  project3
//
//  Created by Robert Johansen on 4/5/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class DetailView: UIView {
    
    private var idLabel: UILabel = UILabel()
    func setId(id: String) {idLabel.text = "ID: \(id)"}
    
    private var gameLabel: UILabel = UILabel()
    func setGame(name: String) {gameLabel.text = "Game: \(name)"}
    
    private var player1Label: UILabel = UILabel()
    private var player2Label: UILabel = UILabel()
    func setPlayer(number: Int, name: String) {
        if (number == 1) {
            player1Label.text = "Player 1: \(name)"
        } else {
            player2Label.text = "Player 2: \(name)"
        }
    }
    
    private var missilesLabel: UILabel = UILabel()
    func setMissiles(missiles: Int) {missilesLabel.text = "Missiles Launched: \(missiles)"}
    
    private var statusLabel: UILabel = UILabel()
    func setStatus(status: String) {statusLabel.text = "Status: \(status)"}
    
    private var winnerLabel: UILabel = UILabel()
    func setWinner(name: String) {winnerLabel.text = "Winner: \(name)"}
    
    override func layoutSubviews() {
        if (self.subviews.count == 0) {
            var labelY: CGFloat = 74
            var labelX: CGFloat = 10
            var labelWidth: CGFloat = UIScreen.mainScreen().bounds.width
            var labelHeight: CGFloat = 20
            
            idLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight)
            idLabel.font = UIFont(name: idLabel.font.fontName, size: 13)
            self.addSubview(idLabel)
            
            labelY += 30
            
            gameLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight)
            gameLabel.font = UIFont(name: gameLabel.font.fontName, size: 13)
            self.addSubview(gameLabel)
            
            labelY += 30
            
            player1Label.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight)
            player1Label.font = UIFont(name: player1Label.font.fontName, size: 13)
            self.addSubview(player1Label)
            
            labelY += 30
            
            player2Label.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight)
            player2Label.font = UIFont(name: player2Label.font.fontName, size: 13)
            self.addSubview(player2Label)
            
            labelY += 30
            
            missilesLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight)
            missilesLabel.font = UIFont(name: missilesLabel.font.fontName, size: 13)
            self.addSubview(missilesLabel)
            
            labelY += 30
            
            statusLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight)
            statusLabel.font = UIFont(name: statusLabel.font.fontName, size: 13)
            self.addSubview(statusLabel)
            
            labelY += 30
            
            winnerLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight)
            winnerLabel.font = UIFont(name: winnerLabel.font.fontName, size: 13)
            self.addSubview(winnerLabel)
        }
    }
    
}
