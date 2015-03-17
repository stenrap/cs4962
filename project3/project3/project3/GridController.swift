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
    
    private var canConfirm: Bool = false
    
    override func loadView() {
        view = GridView()
        view.backgroundColor = UIColor(red: 28/255, green: 107/255, blue: 160/255, alpha: 1.0)
        setInfo()
        drawGrid()
        alertDeploy()
    }
    
    override func viewDidLayoutSubviews() {
        getGridView().rotateView?.delegate = self
    }
    
    private func setInfo() {
        getGridView().delegate = self
        getGridView().setPlayerName(model.getCurrentPlayerName(gameId)+":")
        getGridView().setInstruction(model.getCurrentInstruction(gameId))
    }
    
    private func drawGrid(showShips: Bool = true) {
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
                getGridView().updateCellView(rowString, col: col, hasShip: hasShip, type: type, showShips: showShips)
            }
        }
    }
    
    func cellViewTouched(row: String, col: Int) {
        if (model.getCurrentGameState(gameId).rawValue < State.GAME.rawValue) {
            if (model.addShip(gameId, startCell: Cell(row: row, col: col))) {
                canConfirm = true
                drawGrid()
                setInfo()
                alertFirstShip()
            } else {
                alertInvalidSpot()
            }
        } else {
            var cell: Cell =  Cell(row: row, col: col)
            var (dupe, hit, sunk, winner) = model.shotCalled(gameId, cell: cell)
            if (dupe) {
                alertDupe()
            } else {
                drawGrid(showShips: false)
                if (winner != nil) {
                    println("\(winner!.getName()) just won the game!")
                    return
                }
                
                // WYLO .... Create an alertShotResult() function that tells the player whether the shot miss, hit, or sunk.
                //           Tapping OK on this alert should clear the grid and alert the player to hand off the device.
                
                if (sunk) {
                    println("Sunk a ship at \(row + String(col))!")
                } else if (hit) {
                    println("Hit at \(row + String(col))!")
                } else {
                    println("You missed. Just hand the phone off, you loser.")
                }
            }
        }
        getGridView().setGridTouchAllowed(true)
    }
    
    func alertFirstShip() {
        if (firstShipAlertShown) {
            return
        }
        firstShipAlertShown = true
        var state: State = model.getCurrentGameState(gameId)
        if (state == State.CARRIER1 || state == State.CARRIER2) {
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
            alertInvalidSpot()
        }
    }
    
    func confirmTouched() {
        if (!canConfirm) {
            promptForShip()
            return
        }
        canConfirm = false
        
        model.confirmAddShip(gameId)
        
        setInfo()
        
        var state: State = model.getCurrentGameState(gameId)
        
        if (state == State.BATTLESHIP1 || state == State.BATTLESHIP2) {
            alertOnToVictory()
        }
        
        if (state == State.CARRIER2) {
            drawGrid()
            alertHandOff()
            firstShipAlertShown = false
        }
        
        if (state == State.GAME) {
            drawGrid(showShips: false) // Draw the empty grid of player2 so player1 can take his turn
            getGridView().removeRotatePlaceView()
            alertBattleBegins()
        }
    }
    
    // TODO .... Write a single showAlert() func that takes a title, message, and handler!
    
    func alertDeploy() {
        var alert = UIAlertController(title: "Deploy!",
                                      message: "Tap anywhere on the grid to place your carrier ship (5 holes).",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func promptForShip() {
        var alert = UIAlertController(title: "Oops!",
                                      message: "Place your \(model.getCurrentShipType(gameId)) first, then tap Confirm.",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func alertDupe() {
        var alert = UIAlertController(title: "Oops!",
                                      message: "You already took a shot there. Try again!",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func alertOnToVictory() {
        var alert = UIAlertController(title: "On to Victory!",
                                      message: "Now place the rest of your ships.",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func alertInvalidSpot() {
        var alert = UIAlertController(title: "Invalid Spot",
                                      message: "The \(model.getCurrentShipType(gameId)) can't fit or rotate there.",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // TODO .... Is there a way to say phone or tablet (programmatically) instead of the clunky phone/tablet?
    
    func alertHandOff() {
        var alert = UIAlertController(title: "Hand Off",
                                      message: "Give the phone/tablet to \(model.getCurrentPlayerName(gameId)).",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: onOtherPlayerOk))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func onOtherPlayerOk(alert: UIAlertAction!) {
        var state: State = model.getCurrentGameState(gameId)
        if (state == State.CARRIER2) {
            alertDeploy()
        }
    }
    
    func alertBattleBegins() {
        var alert = UIAlertController(title: "The Battle Begins!",
                                      message: "Give the phone/tablet to \(model.getCurrentPlayerName(gameId)).",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: onOtherPlayerOk))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
