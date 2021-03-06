//
//  Ship.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

class Ship {
    
    private var type: ShipType
    private var startCell: Cell
    private var vertical: Bool
    private var cells = [String: CellType]()
    private var sunk = false
    
    func getType() -> ShipType {return type}
    func getStartCell() -> Cell {return startCell}
    func isVertical() -> Bool {return vertical}
    func getCells() -> [String: CellType] {return cells}
    func isSunk() -> Bool {return sunk}
    
    init(type: ShipType, startCell: Cell, vertical: Bool) {
        self.type = type
        self.startCell = startCell
        self.vertical = vertical
        var size = type.getSize()
        var currentRow = startCell.getRow()
        var currentCol = startCell.getCol()
        while (size > 0) {
            cells[currentRow + String(currentCol)] = CellType.NONE
            if (vertical) {
                switch currentRow {
                    case "A": currentRow = "B"
                    case "B": currentRow = "C"
                    case "C": currentRow = "D"
                    case "D": currentRow = "E"
                    case "E": currentRow = "F"
                    case "F": currentRow = "G"
                    case "G": currentRow = "H"
                    case "H": currentRow = "I"
                    default:  currentRow = "J"
                }
            } else {
                currentCol++
            }
            size--
        }
    }
    
    func hasCell(cell: Cell) -> Bool {
        return cells[cell.toString()] != nil
    }
    
    func shotCalled(cell: Cell) -> Bool {
        if (hasCell(cell)) {
            cells[cell.toString()] = CellType.HIT
            var hits = 0
            for currentCell in cells.values {
                if (currentCell == CellType.HIT) {
                    hits++
                } else {
                    break
                }
            }
            sunk = hits == cells.count
            return true
        }
        return false
    }
    
    func removeFromGrid() {
        cells.removeAll()
    }
    
    /* Helper methods for when a ship is read in from battleship.plist */
    
    func addCell(location: String, type: CellType) {
        cells[location] = type
    }
    
    func setSunk(sunk: Bool) {
        self.sunk = sunk
    }
    
}
