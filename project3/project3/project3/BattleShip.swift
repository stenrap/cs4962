//
//  BattleShip.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

class BattleShip {
    
    private var games = [Game]()
    
    /* Game State Methods */
    
    func newGame() {
        games.append(Game())
        // TODO: Call a delegate method that "tells" the view controller to go to State.NAMES for the new game (games.count - 1)
    }
    
    func setNames(id: Int, player1: Player, player2: Player) {
        games[id].setNames(player1, player2: player2)
    }
    
    // WYLO .... Write the addShip(id: Int, ...) method
    
}
