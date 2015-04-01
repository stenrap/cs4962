//
//  BattleShip.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import Foundation

protocol BattleShipDelegate: class {
    
    func alertNewGameError()
    func newGameCreated()
    //func createNewGame(id: Int)
    //func promptForShip(id: Int, ship: ShipType, playerNumber: Int)
    
}

class BattleShip {
    
    /* OLD */
    private var games = [Game]()
    func getGames() -> [Game] {return games}
    
    /* NEW */
    private var savedGames: NSMutableArray = []
    
    private var currentGame = Game()
    func getCurrentGame() -> Game {return currentGame}
    
    private var currentPlayerId: String = ""
    private var keepPolling: Bool = false
    
    weak var delegate: BattleShipDelegate? = nil
    
    private var currentStartCell: Cell? = nil
    private var currentVertical: Bool? = nil
    private var viewingMyGrid: Bool = false
    
    /* Game State Methods */
    
    func createNewGame(playerName: String, gameName: String) {
        var url: NSURL = NSURL(string: "http://battleship.pixio.com/api/v2/lobby")!
        
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        var bodyData: NSData = ("playerName=\(playerName)&gameName=\(gameName)" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        request.HTTPBody = bodyData
        
        var queue: NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: 
            { [weak self] (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    if (data == nil) {
                        self!.delegate?.alertNewGameError()
                        return
                    } else {
                        var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil) as NSDictionary
                        self!.currentGame = Game()
                        self!.currentGame.setId(response.objectForKey("gameId") as NSString)
                        self!.currentGame.setNames(playerName, player2Name: "")
                        self!.currentPlayerId = response.objectForKey("playerId") as NSString
                        var rawGame: NSDictionary = [
                            "playerId" : self!.currentPlayerId,
                            "gameId"   : self!.currentGame.getId(),
                            "status"   : Status.CREATED.toString()
                        ]
                        self!.appendGameToFile(rawGame)
                        self!.delegate?.newGameCreated()
                        self!.keepPolling = true
                        self!.pollForTurn(NSTimer())
                    }
                })
        })
    }
    
    func setNames(player1Name: String, player2Name: String) {
        currentGame.setNames(player1Name, player2Name: player2Name)
        writeToFile()
    }
    
    func getCurrentInfo() -> String {
        var currentInfo: String = "Waiting for another player to join..."
        
        if (currentGame.getStatus() == Status.PLAYING) {
            if (currentGame.getTurn() === currentGame.getPlayer1()) {
                currentInfo = "It's your turn! Take a shot at the enemy!"
            } else if (currentGame.getTurn() === currentGame.getPlayer2()) {
                currentInfo = "Waiting for \(currentGame.getPlayer2())to take a shot..."
            } else {
                currentInfo = "\(currentGame.getWinner()?.getName()) won the game!"
            }
        }
        
        return currentInfo
    }
    
    func pollForTurn(timer: NSTimer) {        
        if (keepPolling) {
            println("Polling for turn...")
            
            // WYLO .... Clearly this timer approach doesn't work...How can you poll the server?!
            
            NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("pollForTurn:"), userInfo: nil, repeats: false)
            
            var url: NSURL = NSURL(string: "http://battleship.pixio.com/api/v2/games/\(currentGame.getId())?playerId=\(currentPlayerId)")!
            
            var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            
            var queue: NSOperationQueue = NSOperationQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: 
                { [weak self] (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        if (data == nil) {
                            self!.keepPolling = true
                        } else {
                            var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil) as NSDictionary
                            var isYourTurn: Bool = response.objectForKey("isYourTurn") as Bool
                            self!.keepPolling = !isYourTurn
                        }
                    })
            })
        }
    }
    
    func getCurrentGrid(id: Int) -> Grid {
        var currentGrid: Grid = currentGame.getPlayer1().getGrid()
        
        // TODO
        
        /*
        if (game.getStatus().rawValue >= Status.GAME) {
            if (game.getTurn() === game.getPlayer1()) {
                currentGrid = viewingMyGrid ? game.getPlayer1().getGrid() : game.getPlayer2().getGrid()
            } else {
                currentGrid = viewingMyGrid ? game.getPlayer2().getGrid() : game.getPlayer1().getGrid()
            }
        }
        */
        
        return currentGrid
    }
    
    func changeViewingMyGrid() -> Bool {
        viewingMyGrid = !viewingMyGrid
        return viewingMyGrid
    }
    
    func getCurrentGameStatus() -> Status {
        return currentGame.getStatus()
    }
    
    func getCurrentShipType(id: Int) -> String {
        var game: Game = games[id]
        var shipType: ShipType = ShipType.CARRIER
        
        // TODO
        
        /*
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
        */

        return shipType.toString()
    }
    
    func addShip(id: Int, startCell: Cell) -> Bool {
        var game = games[id]
        if (game.addShip(startCell, vertical: true)) {
            currentVertical = true
            currentStartCell = startCell
            return true
        } else if (game.addShip(startCell, vertical: false)) {
            currentVertical = false
            currentStartCell = startCell
            return true
        }
        if (currentStartCell != nil) {
            game.addShip(currentStartCell!, vertical: currentVertical!)
        }
        return false
    }
    
    func rotateShip(id: Int) -> (rotated: Bool, existing: Bool) {
        var game = games[id]
        if (currentStartCell != nil) {
            var wasRotated: Bool = game.rotateShip(currentStartCell!)
            if (wasRotated) {
                currentVertical = !currentVertical!
            }
            return (wasRotated, true)
        }
        return (false, false)
    }
    
    func shotCalled(id: Int, cell: Cell) -> (dupe: Bool, hit: Bool, sunk: Bool, winner: Player?) {        
        // Return early if this is a duplicate shot call
        if (currentGame.isDupeShot(cell)) {
            return (true, false, false, nil)
        }
        
        var hit: Bool = currentGame.shotCalled(cell)
        var sunk: Bool = currentGame.isShipSunk(cell)
        var winner: Player? = currentGame.getWinner()

        if (currentGame.getStatus() == Status.PLAYING && winner != nil) {
            currentGame.setStatus(Status.DONE)
        }
        
        writeToFile()
        
        return (false, hit, sunk, winner)
    }
    
    func changePlayerTurn(id: Int) {
        games[id].changeTurn()
        writeToFile()
    }
    
    func hasWinner(id: Int) -> Bool {
        var game = games[id]
        return game.getWinner() != nil
    }
    
    func deleteGame(id: Int) {
        games.removeAtIndex(id)
        writeToFile()
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
            savedGames.addObject(rawGames?.objectAtIndex(i) as NSDictionary)
        }
        
        /*
        
        Save this code in case you can use it to create games for your model...
        
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
                case 13: state = State.ENDED
                default: break
            }
            var rawTurn: NSNumber = rawGame.objectForKey("turn") as NSNumber
            var turn: Player = Player()
            if (rawTurn == 1) {
                turn = player1
            } else if (rawTurn == 2) {
                turn = player2
            }
            var game: Game = Game()
            game.setPlayer1(player1)
            game.setPlayer2(player2)
            game.setState(state)
            game.setTurn(turn)
            games.append(game)
        }
        */
    }
    
    private func getPlayerFromRead(rawPlayer: NSDictionary) -> Player {
        var player: Player = Player()
        
        player.setName(rawPlayer.objectForKey("name") as NSString)
        player.setShots(rawPlayer.objectForKey("shots") as Int)
        
        var rawGrid: NSDictionary = rawPlayer.objectForKey("grid") as NSDictionary
        
        var rawShips: NSArray = rawGrid.objectForKey("ships") as NSArray
        for (var i: Int = 0; i < rawShips.count; i++) {
            var type: ShipType = ShipType.CARRIER
            switch i {
                case 1: type = ShipType.BATTLESHIP
                case 2: type = ShipType.CRUISER
                case 3: type = ShipType.SUBMARINE
                case 4: type = ShipType.DESTROYER
                default: break
            }
            
            var rawStartCell: NSDictionary = rawShips[i].objectForKey("startCell") as NSDictionary
            var row: String = rawStartCell.objectForKey("row") as NSString
            var col: Int = rawStartCell.objectForKey("col") as Int
            var startCell: Cell = Cell(row: row, col: col)
            
            var vertical: Bool = rawShips[i].objectForKey("vertical") as Bool
            
            var ship: Ship = Ship(type: type, startCell: startCell, vertical: vertical)
            var rawShipCells: NSDictionary = rawShips[i].objectForKey("cells") as NSDictionary
            for (location, cellType) in rawShipCells {
                if (cellType as NSString == "HIT") {
                    ship.addCell(location as NSString, type: CellType.HIT)
                }
            }
            
            var sunk: Bool = rawShips[i].objectForKey("sunk") as Bool
            ship.setSunk(sunk)
            
            player.getGrid().addShipFromFile(ship)
        }
        
        var rawGridCells: NSDictionary = rawGrid.objectForKey("cells") as NSDictionary
        for (rawLocation, rawCellType) in rawGridCells {
            var cellType: CellType = CellType.EMPTY
            if (rawCellType as NSString == "HIT") {
                cellType = CellType.HIT
            } else if (rawCellType as NSString == "MISS") {
                cellType = CellType.MISS
            }
            player.getGrid().addCell(rawLocation as NSString, type: cellType)
        }
        
        return player
    }
    
    private func appendGameToFile(rawGame: NSDictionary) {
        savedGames.addObject(rawGame)
        writeToFile()
    }
    
    private func writeToFile() {
        savedGames.writeToFile(getModelPath(), atomically: true)
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
            "grid" : playerGrid,
            "shots" : player.getShots() as NSNumber
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