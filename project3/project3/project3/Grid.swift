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
        var size = type.getSize()
        var scalars = startCell.getRow().unicodeScalars
        var rowValue = scalars[scalars.startIndex].value
        var colValue = startCell.getCol()
        var currentCell: Cell = Cell(row: startCell.getRow(), col: startCell.getCol())
        while (size > 0) {
            if (vertical) {
                if (rowValue > 74) {
                    return false
                }
                currentCell.setRow(String(UnicodeScalar(rowValue++)))
            } else {
                if (colValue > 10) {
                    return false
                }
                currentCell.setCol(colValue++)
            }
            for ship in ships {
                if (ship.hasCell(currentCell)) {
                    return false
                }
            }
            size--
        }
        ships.append(Ship(type: type, startCell: startCell, vertical: vertical))
        return true
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
