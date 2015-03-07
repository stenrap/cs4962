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
    func placeShip(ship: ShipType, playerNumber: Int)
    
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
        writeToFile()
        delegate?.placeShip(ShipType.CARRIER, playerNumber: 1)
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
    
    func readFromFile() {
        var path = "~/battleship.plist".stringByExpandingTildeInPath
        var rawGames: NSArray? = NSArray(contentsOfFile: "/Users/rob/battleship.plist")
        for (var i: Int = 0; i < rawGames?.count; i++) {
            var rawGame: NSDictionary = rawGames?.objectAtIndex(i) as NSDictionary
            var player1: Player = getPlayerFromRead(rawGame.objectForKey("player1") as NSDictionary)
            println(".")
        }
    }
    
    func getPlayerFromRead(rawPlayer: NSDictionary) -> Player {
        var player: Player = Player()
        
        player.setName(rawPlayer.objectForKey("name") as NSString)
        
        // WYLO .... Get the player's grid
        
        return player
    }
    
    private func writeToFile() {
        var battleShipArray: NSMutableArray = []
        
        for (var i:Int = 0; i < games.count; i++) {
            var game: Game = games[i]
            
            var gameDictionary: NSDictionary = [
                "player1" : getPlayerForWrite(game.getPlayer1()),
                "player2" : getPlayerForWrite(game.getPlayer2()),
                "state" : NSNumber(integer: game.getState().rawValue)
            ]
            
            battleShipArray.addObject(gameDictionary)
        }
        
        var path = "~/battleship.plist".stringByExpandingTildeInPath
        battleShipArray.writeToFile("/Users/rob/battleship.plist", atomically: true)
    }
    
    private func getPlayerForWrite(player: Player) -> NSDictionary {
        var playerGridShips: NSMutableArray = []
        for ship in player.getGrid().getShips() {
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
            
            shipDictionary.setObject(getCellsForWrite(ship.getCells()), forKey: "cells")
            
            var shipSunk: NSNumber = ship.isSunk()
            shipDictionary.setObject(shipSunk, forKey: "sunk")
            
            playerGridShips.addObject(shipDictionary)
        }
        
        var playerGrid: NSDictionary = [
            "cells" : getCellsForWrite(player.getGrid().getCells()),
            "ships" : playerGridShips
        ]
        
        var rawPlayer: NSDictionary = [
            "name" : player.getName() as NSString,
            "grid" : playerGrid
        ]
        
        return rawPlayer
    }
    
    private func getCellsForWrite(cells: [String: CellType]) -> NSMutableDictionary {
        var rawCells: NSMutableDictionary = NSMutableDictionary()
        for (cellString, cellType) in cells {
            var rawType: NSString = "EMPTY"
            if (cellType == CellType.HIT) {
                rawType = "HIT"
            } else if (cellType == CellType.MISS) {
                rawType = "MISS"
            }
            rawCells.setObject(rawType, forKey: cellString)
        }
        return rawCells
    }
    
}
