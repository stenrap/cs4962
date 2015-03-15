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
    
    private var currentStartCell: Cell? = nil
    
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
                if (game.getState() == State.GAME) {
                    currentPlayerName = game.getTurn().getName()
                }
            }
        }
        
        return currentPlayerName
    }
    
    func getCurrentInstruction(id: Int) -> String {
        var currentInstruction: String = ""
        
        if (id < games.count) {
            var game: Game = games[id]
            switch game.getState() {
                case .CARRIER1,
                     .CARRIER2: currentInstruction = "Tap to place your carrier ship (5 holes)"
                case .BATTLESHIP1,
                     .BATTLESHIP2: currentInstruction = "Tap to place your battleship (4 holes)"
                case .CRUISER1,
                     .CRUISER2: currentInstruction = "Tap to place your cruiser ship (3 holes)"
                case .SUBMARINE1,
                     .SUBMARINE2: currentInstruction = "Tap to place your submarine (3 holes)"
                case .DESTROYER1,
                     .DESTROYER2: currentInstruction = "Tap to place your destroyer ship (2 holes)"
                default: break
            }
            if (countElements(currentInstruction) == 0) {
                if (game.getState() == State.GAME) {
                    currentInstruction = "It's your turn! Take a shot at the enemy!"
                }
            }
        }
        
        return currentInstruction
    }
    
    func getCurrentGrid(id: Int) -> Grid {
        var game: Game = games[id]
        var currentGrid: Grid = game.getPlayer1().getGrid()
        
        if (game.getState().rawValue >= State.CARRIER2.rawValue && game.getState().rawValue < State.GAME.rawValue) {
            currentGrid = game.getPlayer2().getGrid()
        }
        
        if (game.getState() == State.GAME) {
            if (game.getTurn() === game.getPlayer1()) {
                currentGrid = game.getPlayer2().getGrid()
            } else {
                currentGrid = game.getPlayer1().getGrid()
            }
        }
        
        return currentGrid
    }
    
    func getCurrentGameState(id: Int) -> State {
        return games[id].getState()
    }
    
    func getCurrentShipType(id: Int) -> String {
        var game: Game = games[id]
        var shipType: ShipType = ShipType.CARRIER
        switch game.getState() {
            case .CARRIER1,
                 .CARRIER2: shipType = ShipType.CARRIER
            case .BATTLESHIP1,
                 .BATTLESHIP2: shipType = ShipType.BATTLESHIP
            case .CRUISER1,
                 .CRUISER2: shipType = ShipType.CRUISER
            case .SUBMARINE1,
                 .SUBMARINE2: shipType = ShipType.SUBMARINE
            case .DESTROYER1,
                 .DESTROYER2: shipType = ShipType.DESTROYER
            default: break
        }
        return shipType.toString()
    }
    
    func addShip(id: Int, startCell: Cell) -> Bool {
        var game = games[id]
        if (game.addShip(startCell, vertical: true) || game.addShip(startCell, vertical: false)) {
            currentStartCell = startCell
            return true
        }
        return false
    }
    
    func rotateShip(id: Int) -> (rotated: Bool, existing: Bool) {
        var game = games[id]
        if (currentStartCell != nil) {
            var wasRotated: Bool = game.rotateShip(currentStartCell!)
            return (wasRotated, true)
        }
        return (false, false)
    }
    
    func confirmAddShip(id: Int) {
        var game = games[id]
        var state = game.getState()
        if (state == State.DESTROYER2) {
            game.setTurn(game.getPlayer1())
        }
        game.nextState()
        writeToFile()
        currentStartCell = nil
    }
    
    func shotCalled(id: Int, cell: Cell) {
        var game = games[id]
        
        // TODO: How to handle duplicate shot calls? Just ignore them. Do a check here first and return the tuple early
        
        var hit: Bool = game.shotCalled(cell)
        var sunk: Bool = game.isShipSunk(cell)
        var winner: Player? = game.getWinner()
        
        // WYLO .... Return a tuple with the above info...
    }
    
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
