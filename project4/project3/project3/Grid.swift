//
//  Grid.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

class Grid {
    
    private var cells = [String: CellType]()
    func getCells() -> [String: CellType] {return cells}
    
    func isCellEmpty(cell: Cell) -> Bool {
        return cells[cell.toString()] == nil
    }
    
    func shotCalled(cell: Cell) -> Bool {
        /*
        
        TODO .... Implement this for networked battleship?
        
        var hit = false
        for ship in ships {
            if (ship.shotCalled(cell)) {
                hit = true
                break
            }
        }
        cells[cell.toString()] = hit ? CellType.HIT : CellType.MISS
        return hit
        */
        return false
    }
    
    func addCell(location: String, type: CellType) {
        cells[location] = type
    }
    
}
