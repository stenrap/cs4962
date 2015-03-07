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
    func promptForShip(id: Int, ship: ShipType, playerNumber: Int)
    
}

class BattleShip {
    
    private var games = [Game]()
    func getGames() -> [Game] {return games}
    
    weak var delegate: BattleShipDelegate? = nil
    
    /* Game State Methods */
    
    func newGame() {
        games.append(Game())
        delegate?.createNewGame(games.count - 1)
    }
    
    func setNames(id: Int, player1Name: String, player2Name: String) {
        games[id].setNames(player1Name, player2Name: player2Name)
        games[id].nextState()
        writeToFile()
        delegate?.promptForShip(id, ship: ShipType.CARRIER, playerNumber: 1)
    }
    
    /*
        Get the player whose name should be displayed in a game based on its current state.
    */
    func getCurrentPlayerName(id: Int) -> String {
        var currentPlayerName: String = ""
        
        if (id < games.count) {
            var game: Game = games[id]
            switch game.getState() {
                case .CARRIER1,
                     .BATTLESHIP1,
                     .CRUISER1,
                     .SUBMARINE1,
                     .DESTROYER1: currentPlayerName = game.getPlayer1().getName()
                case .CARRIER2,
                     .BATTLESHIP2,
                     .CRUISER2,
                     .SUBMARINE2,
                     .DESTROYER2: currentPlayerName = game.getPlayer2().getName()
                default: break
            }
            if (countElements(currentPlayerName) == 0) {
                // TODO: Handle more cases
            }
        }
        
        if (countElements(currentPlayerName) > 0) {
            currentPlayerName += ":"
        }
        
        return currentPlayerName
    }
    
    func getCurrentInstruction(id: Int) -> String {
        var currentInstruction: String = ""
        
        if (id < games.count) {
            var game: Game = games[id]
            switch game.getState() {
                case .CARRIER1,
                     .CARRIER2: currentInstruction = "Place your carrier ship (5 holes)"
                case .BATTLESHIP1,
                     .BATTLESHIP2: currentInstruction = "Place your battleship (4 holes)"
                case .CRUISER1,
                     .CRUISER2: currentInstruction = "Place your cruiser ship (3 holes)"
                case .SUBMARINE1,
                     .SUBMARINE2: currentInstruction = "Place your submarine (3 holes)"
                case .DESTROYER1,
                     .DESTROYER2: currentInstruction = "Place your destroyer ship (3 holes)"
                default: break
            }
        }
        
        return currentInstruction
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
    
    private func getModelPath() -> String {
        let documentsDirectory: String? = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)?[0] as String?
        var filePath: String? = documentsDirectory?.stringByAppendingPathComponent("battleship.plist")
        
        let env = NSProcessInfo.processInfo().environment
        if let local = env["ROB_LOCAL"] as? String {
            filePath = local
        }
        
        return filePath!
    }
    
    func readFromFile() {
        var rawGames: NSArray? = NSArray(contentsOfFile: getModelPath())
        for (var i: Int = 0; i < rawGames?.count; i++) {
            var rawGame: NSDictionary = rawGames?.objectAtIndex(i) as NSDictionary
            var player1: Player = getPlayerFromRead(rawGame.objectForKey("player1") as NSDictionary)
            var player2: Player = getPlayerFromRead(rawGame.objectForKey("player2") as NSDictionary)
            var state: State = State.NAMES
            switch rawGame.objectForKey("state") as NSNumber {
                case 1:  state = State.NAMES
                case 2:  state = State.CARRIER1
                case 3:  state = State.BATTLESHIP1
                case 4:  state = State.CRUISER1
                case 5:  state = State.SUBMARINE1
                case 6:  state = State.DESTROYER1
                case 7:  state = State.CARRIER2
                case 8:  state = State.BATTLESHIP2
                case 9:  state = State.CRUISER2
                case 10: state = State.SUBMARINE2
                case 11: state = State.DESTROYER2
                case 12: state = State.GAME
                default: break
            }
            var game: Game = Game()
            game.setPlayer1(player1)
            game.setPlayer2(player2)
            game.setState(state)
            games.append(game)
        }
    }
    
    private func getPlayerFromRead(rawPlayer: NSDictionary) -> Player {
        var player: Player = Player()
        
        player.setName(rawPlayer.objectForKey("name") as NSString)
        
        var rawGrid: NSDictionary = rawPlayer.objectForKey("grid") as NSDictionary
        
        // TODO: When the grid actually has ships, get them...
        
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
        
        battleShipArray.writeToFile(getModelPath(), atomically: true)
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
