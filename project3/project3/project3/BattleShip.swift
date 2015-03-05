//
//  BattleShip.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

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
    
}
