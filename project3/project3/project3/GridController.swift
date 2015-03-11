//
//  GridController.swift
//  project3
//
//  Created by Robert Johansen on 3/7/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class GridController: BaseController {
    
    func getGridView() -> GridView {return view as GridView}
    
    override func loadView() {
        view = GridView()
        view.backgroundColor = UIColor(red: 28/255, green: 107/255, blue: 160/255, alpha: 1.0)
        setLabels()
        setGrid()
    }
    
    private func setLabels() {
        getGridView().setPlayerName(model.getCurrentPlayerName(gameId))
        getGridView().setInstruction(model.getCurrentInstruction(gameId))
    }
    
    private func setGrid() {
        var currentGrid: Grid = model.getCurrentGrid(gameId)
        for (var row = 1; row <= 10; row++) {
            var rowString: String = "A"
            switch row {
                case 2: rowString = "B"
                case 3: rowString = "C"
                case 4: rowString = "D"
                case 5: rowString = "E"
                case 6: rowString = "F"
                case 7: rowString = "G"
                case 8: rowString = "H"
                case 9: rowString = "I"
                case 10: rowString = "J"
                default: break
            }
            for (var col = 1; col <= 10; col++) {
                var cell: Cell = Cell(row: rowString, col: col)
                var hasShip: Bool = false
                for ship in currentGrid.getShips() {
                    if (ship.hasCell(cell)) {
                        hasShip = true
                        break
                    }
                }
                var type: CellType = CellType.EMPTY
                if (currentGrid.getCells()[rowString + String(col)] != nil) {
                    type = currentGrid.getCells()[rowString + String(col)]!
                }
                getGridView().updateCellView(rowString, col: col, hasShip: hasShip, type: type)
            }
        }
    }
    
}
