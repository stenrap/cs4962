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
    func gameListUpdated()
    func getNameForJoin()
    func alertJoinGameError()
    func gameJoined()
    func alertGetGameDetailError()
    func gotGameDetail()
    func gotPlayerGrids()
    func isPlayerTurn()
    func shotDone()
    func sunkShip(size: Int, gameOver: Bool)
    
}

class BattleShip {
    
    /* OLD */
    private var games = [Game]()
    func getGames() -> [Game] {return games}
    
    /* NEW */
    private var savedGames: NSMutableArray = []
    
    private var currentGame = Game()
    func getCurrentGame() -> Game {return currentGame}
    
    private var detailGame = Game()
    func getDetailGame() -> Game {return detailGame}
    
    private var currentPlayerId: String = ""
    func getCurrentPlayerId() -> String {return currentPlayerId}
    
    private var keepPollingForTurn: Bool = false
    
    private var keepPollingForGames: Bool = false
    private var gamesToPollFor: Status = Status.DONE
    
    private var joinId: String = ""
    private var joinPlayerName: String = ""
    func setJoinPlayerName(joinPlayerName: String) {self.joinPlayerName = joinPlayerName}
    
    weak var delegate: BattleShipDelegate? = nil
    
    private var currentStartCell: Cell? = nil
    private var currentVertical: Bool? = nil
    
    private var viewingMyGrid: Bool = false
    func getViewingMyGrid() -> Bool {return viewingMyGrid}
    
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
                        // TODO .... Names must be alphanumeric! Maybe enforce that in the view...
                        self!.currentPlayerId = response.objectForKey("playerId") as NSString
                        self!.currentGame.setId(response.objectForKey("gameId") as NSString)
                        self!.currentGame.setNames(playerName, player2Name: "")
                        self!.currentGame.getPlayer1().setId(self!.currentPlayerId)
                        
                        println("Successfully created game \(self!.currentGame.getId()) as player \(self!.currentPlayerId)")
                        
                        var rawGame: NSDictionary = [
                            "playerId" : self!.currentPlayerId,
                            "gameId"   : self!.currentGame.getId(),
                            "status"   : Status.CREATED.toString()
                        ]
                        self!.appendGameToFile(rawGame)
                        self!.delegate?.newGameCreated()
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
            
            // WYLO .... What the freak is going on here?
            
            println("At the moment of getting info, currentGame.getTurn().getId() is \(currentGame.getTurn().getId()) and currentPlayerId is \(currentPlayerId)")
            
            if (currentGame.getTurn().getId() == currentPlayerId) {
                currentInfo = "It's your turn! Take a shot at the enemy!"
            } else {
                currentInfo = "Waiting for \(currentGame.getTurn().getName()) to take a shot..."
            }
        }
        
        return currentInfo
    }
    
    func startPollingForTurn() {
        keepPollingForTurn = true
        pollForTurn()
    }
    
    dynamic func pollForTurn() {
        if (keepPollingForTurn) {
            NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("pollForTurn"), userInfo: nil, repeats: false)
            if (currentPlayerId != "") {
                println("Polling for turn in game \(currentGame.getId()) as player \(currentPlayerId)...")
                
                var url: NSURL = NSURL(string: "http://battleship.pixio.com/api/v2/games/\(currentGame.getId())?playerId=\(currentPlayerId)")!
                
                var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "GET"
                
                var queue: NSOperationQueue = NSOperationQueue()
                NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: 
                    { [weak self] (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            if (data == nil) {
                                self!.keepPollingForTurn = true
                            } else {
                                var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil) as NSDictionary
                                var isYourTurn: Bool = response.objectForKey("isYourTurn") as Bool
                                self!.keepPollingForTurn = !isYourTurn
                                if (isYourTurn) {
                                    self!.currentGame.changeTurn(self!.currentPlayerId)
                                    println("After changeTurn() in pollForTurn(), turn ID is: \(self!.currentGame.getTurn().getId())")
                                    if (self!.currentGame.getStatus() == Status.CREATED) {
                                        self!.currentGame.setStatus(Status.PLAYING)
                                    }
                                    
                                    self!.delegate?.isPlayerTurn()
                                } else {
                                    // TODO .... Is it necessary to set the turn's ID to the opponent?
                                    //           Also, would it be easier to have a class-level currentPlayer and opponentPlayer?
                                }
                            }
                        })
                })
            }
        }
    }
    
    func stopPollingForTurn() {
        keepPollingForTurn = false
    }
    
    func lookUpGames(status: Status) {
        gamesToPollFor = status
        keepPollingForGames = true
        games = [Game]()
        delegate?.gameListUpdated()
        pollForGames()
    }
    
    dynamic func pollForGames() {
        if (keepPollingForGames) {
            NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("pollForGames"), userInfo: nil, repeats: false)
            if (gamesToPollFor != Status.CREATED) {
                println("Polling for '\(gamesToPollFor.toString())' games...")
                
                var url: NSURL = NSURL(string: "http://battleship.pixio.com/api/v2/lobby?status=\(gamesToPollFor.toString())")!
                
                var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "GET"
                
                var queue: NSOperationQueue = NSOperationQueue()
                NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: 
                    { [weak self] (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            if (data == nil) {
                                self!.keepPollingForGames = true
                                // TODO .... Add a counter that stops after X consecutive failed attempts?
                            } else {
                                var response: NSArray = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil) as NSArray
                                self!.games = [Game]()
                                for (var i: Int = 0; i < response.count; i++) {
                                    var rawGame: NSDictionary = response[i] as NSDictionary
                                    
                                    var game: Game = Game()
                                    game.setId(rawGame.objectForKey("id") as NSString)
                                    game.setName(rawGame.objectForKey("name") as NSString)
                                    
                                    var rawStatus: String = rawGame.objectForKey("status") as NSString
                                    var status: Status = Status.WAITING
                                    if (rawStatus == Status.PLAYING.toString()) {
                                        status = Status.PLAYING
                                    } else if (rawStatus == Status.DONE.toString()) {
                                        status = Status.DONE
                                    }
                                    
                                    game.setStatus(status)
                                    
                                    if (game.getStatus() == Status.WAITING) {
                                        var isSavedGame: Bool = false
                                        
                                        for (var j: Int = 0; j < self!.savedGames.count; j++) {
                                            if (game.getId() == self!.savedGames[j].objectForKey("gameId") as NSString) {
                                                isSavedGame = true
                                                break
                                            }
                                        }
                                        
                                        if (isSavedGame) {
                                            continue
                                        }
                                    }
                                    
                                    self!.games.append(game)
                                }
                                
                                if (self!.games.count > 0) {
                                    self!.delegate?.gameListUpdated()
                                }
                            }
                        })
                })
            }
        }
    }
    
    func stopPollingForGames() {
        keepPollingForGames = false
    }
    
    func loadGame(index: Int) {
        if (index < games.count) {
            stopPollingForGames()
            var game: Game = games[index]
            if (game.getStatus() == Status.WAITING) {
                joinId = game.getId()
                delegate?.getNameForJoin()
            } else if (game.getStatus() == Status.PLAYING || game.getStatus() == Status.DONE) {
                var saved: Bool = false
                for (var i: Int = 0; i < savedGames.count; i++) {
                    var gameId: String = savedGames[i].objectForKey("gameId") as NSString
                    if (gameId == game.getId()) {
                        saved = true
                        break
                    }
                }
                if (saved) {
                    // WYLO .... 
                    println("Saved game...load it and show the grid...")
                } else {
                    getGameDetail(game.getId(), forGrid: false)
                }
            }
        }
    }
    
    func joinGame() {
        var url: NSURL = NSURL(string: "http://battleship.pixio.com/api/v2/lobby/\(joinId)")!
        
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var bodyData: NSData = ("playerName=\(joinPlayerName)&id=\(joinId)" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        request.HTTPBody = bodyData
        
        var queue: NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: 
            { [weak self] (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    if (data == nil) {
                        self!.delegate?.alertJoinGameError()
                        return
                    } else {
                        var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil) as NSDictionary
                        
                        var playerId: String? = response.objectForKey("playerId") as? NSString
                        if (playerId == nil) {
                            self!.delegate?.alertJoinGameError()
                            return
                        }
                        
                        println("Successfully joined game \(self!.joinId) as player \(playerId!)")
                        
                        self!.currentGame = Game()
                        self!.currentGame.setId(self!.joinId)
                        self!.currentGame.setNames("", player2Name: self!.joinPlayerName)
                        self!.currentGame.getPlayer2().setId(playerId!)
                        self!.currentGame.setTurn(self!.currentGame.getPlayer1())
                        self!.currentGame.setStatus(Status.PLAYING)
                        self!.currentPlayerId = playerId!
                        var rawGame: NSDictionary = [
                            "playerId" : self!.currentPlayerId,
                            "gameId"   : self!.currentGame.getId(),
                            "status"   : Status.PLAYING.toString()
                        ]
                        self!.appendGameToFile(rawGame)
                        self!.delegate?.gameJoined()
                    }
                })
        })
    }
    
    func getGameAfterJoin() {
        getGameDetail(currentGame.getId(), forGrid: true)
    }
    
    func getGameDetail(id: String, forGrid: Bool) {
        var url: NSURL = NSURL(string: "http://battleship.pixio.com/api/v2/lobby/\(id)")!
        
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        var queue: NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: 
            { [weak self] (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    if (data == nil) {
                        self!.delegate?.alertJoinGameError()
                        return
                    } else {
                        var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil) as NSDictionary
                        
                        var id: String?         = response.objectForKey("id") as? NSString
                        var name: String?       = response.objectForKey("name") as? NSString
                        var player1: String?    = response.objectForKey("player1") as? NSString
                        var player2: String?    = response.objectForKey("player2") as? NSString
                        var winner: String?     = response.objectForKey("winner") as? NSString
                        var rawStatus: String?  = response.objectForKey("status") as? NSString
                        var missiles: NSNumber? = response.objectForKey("missilesLaunched") as? NSNumber
                        
                        if (id        == nil ||
                            name      == nil ||
                            player1   == nil ||
                            player2   == nil ||
                            winner    == nil ||
                            rawStatus == nil ||
                            missiles  == nil) {
                            if (forGrid) {
                                self!.delegate?.alertGetGameDetailError()
                            }
                            return
                        }
                        
                        var status: Status = Status.WAITING
                        
                        if (rawStatus == Status.PLAYING.toString()) {
                            status = Status.PLAYING
                        } else if (rawStatus == Status.DONE.toString()) {
                            status = Status.DONE
                        }
                        
                        if (forGrid) {
                            self!.currentGame.setId(id!)
                            self!.currentGame.setNames(player1!, player2Name: player2!)
                            self!.currentGame.setWinnerName(winner!)
                            self!.currentGame.setStatus(status)
                        } else {
                            self!.detailGame.setId(id!)
                            self!.detailGame.setName(name!)
                            self!.detailGame.setNames(player1!, player2Name: player2!)
                            self!.detailGame.setWinnerName(winner!)
                            self!.detailGame.setStatus(status)
                            self!.detailGame.setMissiles(Int(missiles!))
                        }
                        
                        self!.delegate?.gotGameDetail()
                    }
                })
        })
    }
    
    func getPlayerGrids() {
        var url: NSURL = NSURL(string: "http://battleship.pixio.com/api/v2/games/\(currentGame.getId())/boards?playerId=\(currentPlayerId)")!
        
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        var queue: NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: 
            { [weak self] (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    if (data == nil) {
                        self!.delegate?.alertJoinGameError()
                        return
                    } else {
                        var response: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil) as NSDictionary
                        
                        var playerBoard: NSArray? = response.objectForKey("playerBoard") as? NSArray
                        var opponentBoard: NSArray? = response.objectForKey("opponentBoard") as? NSArray
                        
                        if (playerBoard == nil || opponentBoard == nil) {
                            self!.delegate?.alertGetGameDetailError()
                            return
                        }
                        
                        var currentPlayer: Player? = nil
                        var opponentPlayer: Player? = nil
                        
                        if (self!.currentGame.getPlayer1().getId() == self!.currentPlayerId) {
                            currentPlayer = self!.currentGame.getPlayer1()
                            opponentPlayer = self!.currentGame.getPlayer2()
                        } else if (self!.currentGame.getPlayer2().getId() == self!.currentPlayerId) {
                            currentPlayer = self!.currentGame.getPlayer2()
                            opponentPlayer = self!.currentGame.getPlayer1()
                        }
                        
                        if (currentPlayer != nil) {
                            self!.setPlayerGrid(currentPlayer!, grid: playerBoard!)
                            self!.setPlayerGrid(opponentPlayer!, grid: opponentBoard!)
                        }
                        
                        self!.delegate?.gotPlayerGrids()
                    }
                })
        })
    }
    
    func setPlayerGrid(player: Player, grid: NSArray) {
        for (var i: Int = 0; i < grid.count; i++) {
            var rawCell: NSDictionary = grid[i] as NSDictionary
            var rawRow: NSNumber = rawCell.objectForKey("yPos") as NSNumber
            var rawCol: NSNumber = rawCell.objectForKey("xPos") as NSNumber
            var rawStatus: String = rawCell.objectForKey("status") as NSString
            
            var row: String = ""
            switch (rawRow) {
                case 0:  row = "A"
                case 1:  row = "B"
                case 2:  row = "C"
                case 3:  row = "D"
                case 4:  row = "E"
                case 5:  row = "F"
                case 6:  row = "G"
                case 7:  row = "H"
                case 8:  row = "I"
                default: row = "J"
            }
            
            var col: Int = Int(rawCol.integerValue + 1)
            
            var cellType: CellType = CellType.NONE
            switch (rawStatus) {
                case CellType.SHIP.toString(): cellType = CellType.SHIP
                case CellType.MISS.toString(): cellType = CellType.MISS
                case CellType.HIT.toString(): cellType = CellType.HIT
                default: break
            }
            
            player.getGrid().addCell(row + String(col), type: cellType)
        }
    }
    
    func getCurrentGrid() -> Grid {
        var currentGrid: Grid? = nil
        
        if (viewingMyGrid) {
            if (currentGame.getPlayer1().getId() == currentPlayerId) {
                currentGrid = currentGame.getPlayer1().getGrid()
            } else {
                currentGrid = currentGame.getPlayer2().getGrid()
            }
        } else {
            if (currentGame.getPlayer1().getId() == currentPlayerId) {
                currentGrid = currentGame.getPlayer2().getGrid()
            } else {
                currentGrid = currentGame.getPlayer1().getGrid()
            }
        }
        
        return currentGrid!
    }
    
    func changeViewingMyGrid() -> Bool {
        viewingMyGrid = !viewingMyGrid
        return viewingMyGrid
    }
    
    func getCurrentGameStatus() -> Status {
        return currentGame.getStatus()
    }
    
    func shotCalled(row: String, col: Int) {
        
        // TODO .... Check for duplicate shots to save bandwidth and make for a better gameplay experience?
        
        var yPos: Int = 0
        
        switch (row) {
            case "B": yPos = 1
            case "C": yPos = 2
            case "D": yPos = 3
            case "E": yPos = 4
            case "F": yPos = 5
            case "G": yPos = 6
            case "H": yPos = 7
            case "I": yPos = 8
            case "J": yPos = 9
            default: break
        }
        
        var xPos: Int = col - 1
        
        var url: NSURL = NSURL(string: "http://battleship.pixio.com/api/v2/games/\(currentGame.getId())")!
        
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        var bodyData: NSData = ("playerId=\(currentPlayerId)&xPos=\(xPos)&yPos=\(yPos)" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
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
                        
                        var hit: Bool = response.objectForKey("hit") as Bool
                        var shipSize: NSNumber = response.objectForKey("shipSunk") as NSNumber
                        
                        // It may look weird to be checking for a sunk ship twice, but it's necessary in order to achieve the proper sequence of events.
                        
                        if (shipSize.integerValue > 0) {
                            self!.currentGame.shipsSunk++
                        }
                        
                        if (self!.currentGame.shipsSunk < 5) {
                            self!.currentGame.changeTurn("")
                            println("After changeTurn() in shotCalled(), turn ID is: \(self!.currentGame.getTurn().getId())")
                            self!.delegate?.shotDone()
                        }
                        
                        if (shipSize.integerValue > 0) {
                            self!.delegate?.sunkShip(shipSize.integerValue, gameOver: self!.currentGame.shipsSunk == 5)
                        }
                    }
                })
        })
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
        savedGames = []
        for (var i: Int = 0; i < rawGames?.count; i++) {
            savedGames.addObject(rawGames?.objectAtIndex(i) as NSDictionary)
        }
    }
    
    private func appendGameToFile(rawGame: NSDictionary) {
        savedGames.addObject(rawGame)
        writeToFile()
    }
    
    private func writeToFile() {
        savedGames.writeToFile(getModelPath(), atomically: true)
    }
    
}
