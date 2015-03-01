//
//  Grid.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

class Grid {
    
    private var grid = [String: CellType]()
    private var ships = [Ship]()
    
    func addShip(type: ShipType, startCell: Cell, vertical: Bool) -> Bool {
        var withinGrid = true
        var noConflict = true
        // WYLO .... Need to validate whether startCell is valid for type
        ships.append(Ship(type: type, startCell: startCell, vertical: vertical))
    }
    
    func isCellEmpty(cell: Cell) -> Bool {
        return grid[cell.toString()] == nil
    }
    
    func shotCalled(cell: Cell) -> Bool {
        var hit = false
        for ship in ships {
            if (ship.shotCalled(cell)) {
                hit = true
                break
            }
        }
        grid[cell.toString()] = hit ? CellType.HIT : CellType.MISS
        return hit
    }
    
}
