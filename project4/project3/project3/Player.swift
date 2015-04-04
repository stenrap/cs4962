//
//  Player.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

class Player {
    
    private var id: String = ""
    func getId() -> String {return id}
    func setId(id: String) {self.id = id}
    
    private var name: String = ""
    func getName() -> String {return name}
    func setName(name: String) {self.name = name}
    
    private var grid: Grid = Grid()
    func getGrid() -> Grid {return grid}
    
    private var shots: Int = 0
    func addShot() {shots++}
    func getShots() -> Int {return shots}
    func setShots(shots: Int) {self.shots = shots}
    
    func addShip(type: ShipType, startCell: Cell, vertical: Bool) -> Bool {
        return grid.addShip(type, startCell: startCell, vertical: vertical)
    }
    
    func rotateShip(currentStartCell: Cell) -> Bool {
        return grid.rotateShip(currentStartCell)
    }
    
    func isCellEmpty(cell: Cell) -> Bool {
        return grid.isCellEmpty(cell)
    }
    
    func shotCalled(cell: Cell) -> Bool {
        return grid.shotCalled(cell)
    }
    
    func isShipSunk(cell: Cell) -> Bool {
        return grid.isShipSunk(cell)
    }
    
    func allShipsSunk() -> Bool {
        return grid.allShipsSunk()
    }
    
}
