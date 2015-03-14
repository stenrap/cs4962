//
//  Grid.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

class Grid {
    
    private var cells = [String: CellType]()
    private var ships = [Ship]()
    
    func getCells() -> [String: CellType] {return cells}
    func getShips() -> [Ship] {return ships}
    
    func addShip(type: ShipType, startCell: Cell, vertical: Bool) -> Bool {
        if (shipOnGrid(type)) {
            removeShip(type)
        }
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
    
    func rotateShip(currentStartCell: Cell) -> Bool {
        for ship in ships {
            if (ship.hasCell(currentStartCell)) {
                var vertical: Bool = ship.isVertical()
                if (addShip(ship.getType(), startCell: currentStartCell, vertical: !vertical)) {
                    return true
                } else {
                    addShip(ship.getType(), startCell: currentStartCell, vertical: vertical)
                    return false
                }
            }
        }
        return false
    }
    
    func shipOnGrid(type: ShipType) -> Bool {
        for ship in ships {
            if (ship.getType() == type && ship.getCells().count > 0) {
                return true
            }
        }
        return false
    }
    
    func removeShip(type: ShipType) {
        var index = -1
        for (var i: Int = 0; i < ships.count; i++) {
            var ship: Ship = ships[i]
            if (ship.getType() == type) {
                ship.removeFromGrid()
                index = i
                break
            }
        }
        if (index > -1 && index < ships.count) {
            ships.removeAtIndex(index)
        }
    }
    
    func isCellEmpty(cell: Cell) -> Bool {
        return cells[cell.toString()] == nil
    }
    
    func shotCalled(cell: Cell) -> Bool {
        var hit = false
        for ship in ships {
            if (ship.shotCalled(cell)) {
                hit = true
                break
            }
        }
        cells[cell.toString()] = hit ? CellType.HIT : CellType.MISS
        return hit
    }
    
}
