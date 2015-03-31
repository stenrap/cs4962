//
//  Game.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

class Game {
    
    private var player1: Player = Player()
    private var player2: Player = Player()
    private var turn: Player = Player()
    private var state: State = State.NAMES
    
    func getPlayer1() -> Player {return player1}
    func setPlayer1(player1: Player)  {self.player1 = player1}
    
    func getPlayer2() -> Player {return player2}
    func setPlayer2(player2: Player)  {self.player2 = player2}
    
    func getTurn() -> Player {return turn}
    func setTurn(turn: Player) {self.turn = turn}
    func changeTurn() {
        if (turn === player1) {
            turn = player2
        } else {
            turn = player1
        }
    }
    
    func getState() -> State {return state}
    func setState(state: State) {self.state = state}
    func nextState() {state.next()}
    
    /* Game State Methods */
    
    func setNames(player1Name: String, player2Name: String) {
        player1.setName(player1Name)
        player2.setName(player2Name)
    }
    
    func forPlayer1() -> Bool {
        return state.rawValue >= State.CARRIER1.rawValue && state.rawValue <= State.DESTROYER1.rawValue
    }
    
    func addShip(startCell: Cell, vertical: Bool) -> Bool {
        var type: ShipType = ShipType.CARRIER
        switch state {
            case .NAMES:                     break
            case .CARRIER1, .CARRIER2:       type = ShipType.CARRIER
            case .BATTLESHIP1, .BATTLESHIP2: type = ShipType.BATTLESHIP
            case .CRUISER1, .CRUISER2:       type = ShipType.CRUISER
            case .SUBMARINE1, .SUBMARINE2:   type = ShipType.SUBMARINE
            case .DESTROYER1, .DESTROYER2:   type = ShipType.DESTROYER
            case .GAME, .ENDED:                      break
        }
        
        if (forPlayer1()) {
            return player1.addShip(type, startCell: startCell, vertical: vertical)
        } else {
            return player2.addShip(type, startCell: startCell, vertical: vertical)
        }
    }
    
    func rotateShip(currentStartCell: Cell) -> Bool {
        if (forPlayer1()) {
            return player1.rotateShip(currentStartCell)
        } else {
            return player2.rotateShip(currentStartCell)
        }
    }
    
    func isDupeShot(cell: Cell) -> Bool {
        if (turn === player1) {
            return !player2.isCellEmpty(cell)
        }
        return !player1.isCellEmpty(cell)
    }
    
    func shotCalled(cell: Cell) -> Bool {
        turn.addShot()
        if (turn === player1) {
            return player2.shotCalled(cell)
        }
        return player1.shotCalled(cell)
    }
    
    func isShipSunk(cell: Cell) -> Bool {
        if (turn === player1) {
            return player2.isShipSunk(cell)
        }
        return player1.isShipSunk(cell)
    }
    
    func getWinner() -> Player? {
        if (player1.allShipsSunk()) {
            return player2
        } else if (player2.allShipsSunk()) {
            return player1
        }
        return nil
    }
    
}
