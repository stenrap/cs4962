//
//  Player.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

class Player {
    
    private var name: String = ""
    private var grid: Grid = Grid()
    private var enemyGrid: Grid = Grid()
    
    func getName() -> String {return name}
    func setName(name: String) {self.name = name}
    
    func getGrid() -> Grid {return grid}
    
    func addShip(type: ShipType, startCell: Cell, vertical: Bool, myGrid: Bool) -> Bool {
        if (myGrid) {
            return grid.addShip(type, startCell: startCell, vertical: true)
        } else {
            return enemyGrid.addShip(type, startCell: startCell, vertical: true)
        }
    }
}
