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
    private var state: State = State.NAMES
    
    func getPlayer1() -> Player {return player1}
    func getPlayer2() -> Player {return player2}
    func getState() -> State {return state}
    
    /* Game State Methods */
    
    func setNames(player1Name: String, player2Name: String) {
        player1.setName(player1Name)
        player2.setName(player2Name)
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
            case .GAME:                      break
        }
        var forPlayer1: Bool = state.rawValue >= State.CARRIER1.rawValue && state.rawValue <= State.DESTROYER1.rawValue
        if (forPlayer1) {
            if (player1.addShip(type, startCell: startCell, vertical: vertical, myGrid: true)) {
                player2.addShip(type, startCell: startCell, vertical: vertical, myGrid: false)
            } else {
                return false
            }
        } else {
            if (player2.addShip(type, startCell: startCell, vertical: vertical, myGrid: true)) {
                player1.addShip(type, startCell: startCell, vertical: vertical, myGrid: false)
            } else {
                return false
            }
        }
        return true
    }
    
}
