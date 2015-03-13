//
//  GridController.swift
//  project3
//
//  Created by Robert Johansen on 3/7/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class GridController: BaseController, CellViewDelegate {
    
    func getGridView() -> GridView {return view as GridView}
    
    override func loadView() {
        view = GridView()
        view.backgroundColor = UIColor(red: 28/255, green: 107/255, blue: 160/255, alpha: 1.0)
        setInfo()
        setGrid()
    }
    
    private func setInfo() {
        getGridView().delegate = self
        getGridView().setPlayerName(model.getCurrentPlayerName(gameId))
        getGridView().setInstruction(model.getCurrentInstruction(gameId))
    }
    
    private func setGrid() {
        var grid: Grid = model.getCurrentGrid(gameId)
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
                for ship in grid.getShips() {
                    if (ship.hasCell(cell)) {
                        hasShip = true
                        break
                    }
                }
                var type: CellType = CellType.EMPTY
                if (grid.getCells()[rowString + String(col)] != nil) {
                    type = grid.getCells()[rowString + String(col)]!
                }
                getGridView().updateCellView(rowString, col: col, hasShip: hasShip, type: type)
            }
        }
    }
    
    func cellViewTouched(row: String, col: Int) {
        if (model.getCurrentGameState(gameId).rawValue < State.GAME.rawValue) {
            if (model.addShip(gameId, startCell: Cell(row: row, col: col))) {
                println("Ship added...draw it on the grid!")
                // WYLO .... Add the ship to the grid, show a success alert, allow grid touch
            } else {
                showInvalidSpotAlert()
                getGridView().setGridTouchAllowed(true)
            }
        } else {
            // TODO: Call model.takeShot()...
        }
    }
    
    func showInvalidSpotAlert() {
        var alert = UIAlertController(title: "Invalid Spot",
                                      message: "The \(model.getCurrentShipType(gameId)) can't fit there.",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
