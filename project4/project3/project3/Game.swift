//
//  Game.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

class Game {
    
    private var id: String = ""
    func getId() -> String {return id}
    func setId(id: String) {self.id = id}
    
    private var name: String = ""
    func getName() -> String {return name}
    func setName(name: String) {self.name = name}
    
    private var player1: Player = Player()
    func getPlayer1() -> Player {return player1}
    func setPlayer1(player1: Player)  {self.player1 = player1}
    
    private var player2: Player = Player()
    func getPlayer2() -> Player {return player2}
    func setPlayer2(player2: Player)  {self.player2 = player2}
    
    private var turn: Player = Player()
    func getTurn() -> Player {return turn}
    func setTurn(turn: Player) {self.turn = turn}
    
    private var status: Status = Status.CREATED
    func getStatus() -> Status {return status}
    func setStatus(status: Status) {self.status = status}
    
    private var missiles: Int = 0
    func getMissiles() -> Int {return missiles}
    func setMissiles(missiles: Int) {self.missiles = missiles}
    
    /* Game State Methods */
    
    func setNames(player1Name: String, player2Name: String) {
        player1.setName(player1Name)
        player2.setName(player2Name)
    }
    
    func setWinnerName(name: String) {
        var winner: Player? = getWinner()
        if (winner != nil) {
            winner?.setName(name)
        }
    }
    
    func changeTurn() {
        turn = turn.getId() == player1.getId() ? player2 : player1
    }
    
    func isDupeShot(cell: Cell) -> Bool {
        if (turn === player1) {
            return !player2.isCellEmpty(cell)
        }
        return !player1.isCellEmpty(cell)
    }
    
    func getWinner() -> Player? {
        /*
        
        TODO .... 
        
        if (player1.allShipsSunk()) {
            return player2
        } else if (player2.allShipsSunk()) {
            return player1
        }
        */
        return nil
    }
    
}
