//
//  BattleShip.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import Foundation

protocol BattleShipDelegate: class {
    
    func createNewGame(id: Int)
    
}

class BattleShip {
    
    private var games = [Game]()
    weak var delegate: BattleShipDelegate? = nil
    
    /* Game State Methods */
    
    func newGame() {
        games.append(Game())
        delegate?.createNewGame(games.count - 1)
    }
    
    func setNames(id: Int, player1Name: String, player2Name: String) {
        games[id].setNames(player1Name, player2Name: player2Name)
        // WYLO .... Save all games to disk, then call a delegate method that "tells" the controller to go to the next state
    }
    
    func addShip(id: Int, startCell: Cell, vertical: Bool) {
        var game = games[id]
        if (game.addShip(startCell, vertical: vertical)) {
            // TODO: Call a delegate method that "tells" the controller which state to go to next
        } else {
            // TODO: Call a delegate method that "tells" the controller why adding the ship failed
        }
    }
    
    /*
        These are the types that can be written to .plist files:
        
            NSString
            NSNumber (integer)
            NSNumber (boolean)
            NSDate
            NSData (base-64 encoded)
            NSArray
            NSDictionary
        
    
        To read the contents of your battleship.plist.plist file:
    
            var array: NSArray = NSArray("battleship.plist")
    
    
        To write the contents of your battleship.plist.plist file:
    
            array.writeToFile("battleship.plist", atomically: true)
    
        
        See lecture 10 video at 01:17:40 for the tutorial
    */
    
    private func writeToFile() {
        var battleShipArray: NSMutableArray = []
        
        for (var i:Int = 0; i < games.count; i++) {
            var game: Game = games[i]
            var gameId: NSNumber = NSNumber(integer: i)
            
            // WYLO .... Move the player stuff into a separate func so you don't have to duplicate code for player1 and player2
            
            var player1GridCells: NSMutableDictionary = NSMutableDictionary()
            for (cellString, cellType) in game.getPlayer1().getGrid().getCells() {
                var rawType: NSString = "EMPTY"
                if (cellType == CellType.HIT) {
                    rawType = "HIT"
                } else if (cellType == CellType.MISS) {
                    rawType = "MISS"
                }
                player1GridCells.setObject(rawType, forKey: cellString)
            }
            
            var player1GridShips: NSMutableArray = []
            for ship in game.getPlayer1().getGrid().getShips() {
                var shipDictionary: NSMutableDictionary = NSMutableDictionary()
                
                var shipType: NSString = ""
                switch ship.getType() {
                    case .CARRIER:    shipType = "CARRIER"
                    case .BATTLESHIP: shipType = "BATTLESHIP"
                    case .CRUISER:    shipType = "CRUISER"
                    case .SUBMARINE:  shipType = "SUBMARINE"
                    case .DESTROYER:  shipType = "DESTROYER"
                }
                shipDictionary.setObject(shipType, forKey: "type")
                
                var shipStartCell: NSDictionary = [
                    "row" : ship.getStartCell().getRow(),
                    "col" : ship.getStartCell().getCol()
                ]
                shipDictionary.setObject(shipStartCell, forKey: "startCell")
                
                var shipVertical: NSNumber = ship.isVertical()
                shipDictionary.setObject(shipVertical, forKey: "vertical")
                
                var shipCells: NSMutableDictionary = NSMutableDictionary()
                for (cellString, cellType) in ship.getCells() {
                    var rawType: NSString = "EMPTY"
                    if (cellType == CellType.HIT) {
                        rawType = "HIT"
                    } else if (cellType == CellType.MISS) {
                        rawType = "MISS"
                    }
                    shipCells.setObject(rawType, forKey: cellString)
                }
                shipDictionary.setObject(shipCells, forKey: "cells")
                
                var shipSunk: NSNumber = ship.isSunk()
                shipDictionary.setObject(shipSunk, forKey: "sunk")
                
                player1GridShips.addObject(shipDictionary)
            }
            
            var player1: NSDictionary = [
                "name" : game.getPlayer1().getName() as NSString
            ]
            
            var gameDictionary: NSDictionary = [
                "id" : gameId
            ]
            battleShipArray.addObject(gameDictionary)
        }
        
        battleShipArray.writeToFile("~/battleship.plist", atomically: true)
    }
    
    private func getPlayerGridForWrite(player: Player) {
        
    }
    
}
