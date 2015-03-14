//
//  GridController.swift
//  project3
//
//  Created by Robert Johansen on 3/7/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class GridController: BaseController, CellViewDelegate, RotatePlaceViewDelegate {
    
    func getGridView() -> GridView {return view as GridView}
    
    private var firstShipAlertShown: Bool = false
    
    override func loadView() {
        view = GridView()
        view.backgroundColor = UIColor(red: 28/255, green: 107/255, blue: 160/255, alpha: 1.0)
        setInfo()
        drawGrid()
        showDeployAlert()
    }
    
    override func viewDidLayoutSubviews() {
        getGridView().rotateView?.delegate = self
    }
    
    private func setInfo() {
        getGridView().delegate = self
        getGridView().setPlayerName(model.getCurrentPlayerName(gameId)+":")
        getGridView().setInstruction(model.getCurrentInstruction(gameId))
    }
    
    private func drawGrid() {
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
                drawGrid()
                setInfo()
                showFirstShipAlert()
            } else {
                showInvalidSpotAlert()
            }
        } else {
            // TODO: Call model.takeShot()...
        }
        getGridView().setGridTouchAllowed(true)
    }
    
    func showFirstShipAlert() {
        if (firstShipAlertShown) {
            return
        }
        firstShipAlertShown = true
        var state: Int = model.getCurrentGameState(gameId).rawValue
        if (state == State.CARRIER1.rawValue || state == State.CARRIER2.rawValue) {
            var alert = UIAlertController(title: "Splash!",
                                          message: "Your carrier is in the water! Tap another spot to move it, or tap Rotate to turn it. When it's ready, tap Confirm.",
                                          preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func rotateTouched() {
        var (rotated, existing) = model.rotateShip(gameId)
        if (rotated) {
            drawGrid()
        } else if (existing) {
            showInvalidSpotAlert()
        }
    }
    
    func confirmTouched() {
        model.confirmAddShip(gameId)
        showFirstShipAddedAlert()
        setInfo()
        
        var state: Int = model.getCurrentGameState(gameId).rawValue
        if (state == State.CARRIER2.rawValue) {
            drawGrid()
            showGiveDeviceToOtherPlayerAlert()
            firstShipAlertShown = false
        }
    }
    
    func showDeployAlert() {
        var state: Int = model.getCurrentGameState(gameId).rawValue
        if (state != State.CARRIER1.rawValue && state != State.CARRIER2.rawValue) {
            return
        }
        var alert = UIAlertController(title: "Deploy!",
                                      message: "Tap anywhere on the grid to place your carrier ship (5 holes).",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showFirstShipAddedAlert() {
        var state: Int = model.getCurrentGameState(gameId).rawValue
        if (state != State.BATTLESHIP1.rawValue && state != State.BATTLESHIP2.rawValue) {
            return
        }
        var alert = UIAlertController(title: "On to Victory!",
                                      message: "Now place the rest of your ships.",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showInvalidSpotAlert() {
        var alert = UIAlertController(title: "Invalid Spot",
                                      message: "The \(model.getCurrentShipType(gameId)) can't fit or rotate there.",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showGiveDeviceToOtherPlayerAlert() {
        var alert = UIAlertController(title: "Hand Off",
                                      message: "Give the phone/tablet to \(model.getCurrentPlayerName(gameId)).",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertActionStyle.Default,
                                      handler: onOtherPlayerOk))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func onOtherPlayerOk(alert: UIAlertAction!) {
        var state: Int = model.getCurrentGameState(gameId).rawValue
        if (state == State.CARRIER2.rawValue) {
            showDeployAlert()
        }

    }
    
}
