//
//  GridController.swift
//  project3
//
//  Created by Robert Johansen on 3/7/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class GridController: BaseController, CellViewDelegate, RotatePlaceViewDelegate, ViewGridDelegate {
    
    func getGridView() -> GridView {return view as GridView}
    
    private var firstShipAlertShown: Bool = false
    private var canConfirm: Bool = false
    
    override func loadView() {
        view = GridView()
        view.backgroundColor = UIColor(red: 28/255, green: 107/255, blue: 160/255, alpha: 1.0)
        
        /*
            WYLO A .... This looks to be fixed, but you'll have to test further: The 'Rotate' and 'Confirm' buttons appear when state == GAME.
        
            WYLO 2 .... Things to test:
        
                1. Tapping 'Back' during a game.
                2. Loading an ended game.
        */
        
        setInfo()
        
        var state: State = model.getCurrentGameState(gameId)
        
        drawGrid(showShips: state != State.GAME)
        
        if (state == State.CARRIER1 || state == State.CARRIER2) {
            alertDeploy()
        }
    }
    
    override func viewDidLayoutSubviews() {
        getGridView().rotateView?.delegate = self
        var state: State = model.getCurrentGameState(gameId)
        if (state == State.GAME) {
            getGridView().removeRotatePlaceView()
            getGridView().addViewGridButtion()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        /*
        var state: State = model.getCurrentGameState(gameId)
        if (state == State.GAME) {
            getGridView().removeRotatePlaceView()
            getGridView().addViewGridButtion()
        }
        */
    }
    
    private func setInfo() {
        getGridView().cellViewDelegate = self
        getGridView().viewGridDelegate = self
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
                    showAlert("You Won!", message: "Congratulations, \(winner!.getName())!\nThe enemy was no match for you!", handler: nil)
                    getGridView().setPlayerName(winner!.getName())
                    getGridView().setInstruction("You won the game!")
                    return
                }
                model.changePlayerTurn(gameId)
                if (sunk) {
                    showAlert("Sunk!", message: "Down to the depths she goes!\nGive the \(UIDevice.currentDevice().model) to \(model.getCurrentPlayerName(gameId)).", handler: onOtherPlayerOk)
                } else if (hit) {
                    showAlert("Hit!", message: "Your aim is impeccable, captain!\nGive the \(UIDevice.currentDevice().model) to \(model.getCurrentPlayerName(gameId)).", handler: onOtherPlayerOk)
                } else {
                    showAlert("Miss!", message: "Recalibrate your sights!\nGive the \(UIDevice.currentDevice().model) to \(model.getCurrentPlayerName(gameId)).", handler: onOtherPlayerOk)
                }
            }
        }
        getGridView().setGridTouchAllowed(true)
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
            alertHandOff(nil)
            firstShipAlertShown = false
        }
        
        if (state == State.GAME) {
            drawGrid(showShips: false) // Draw the empty grid of player2 so player1 can take his turn
            getGridView().removeRotatePlaceView()
            getGridView().addViewGridButtion()
            alertBattleBegins()
        }
    }
    
    func viewGridTouched() {
        var viewingMyGrid: Bool = model.changeViewingMyGrid()
        if (!model.hasWinner(gameId)) {
            getGridView().setGridTouchAllowed(!viewingMyGrid)
        }
        drawGrid(showShips: viewingMyGrid)
        getGridView().changeViewGridButtonLabel(viewingMyGrid)
    }
    
    func showAlert(title: String, message: String, handler: ((UIAlertAction!) -> Void)! = nil) {
        var alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: handler))
        self.presentViewController(alert, animated: true, completion: nil)
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
    
    func alertDeploy() {
        showAlert("Deploy!", message: "Tap anywhere on the grid to place your carrier ship (5 holes).", handler: nil)
    }
    
    func promptForShip() {
        showAlert("Oops!", message: "Place your \(model.getCurrentShipType(gameId)) first, then tap Confirm.", handler: nil)
    }
    
    func alertDupe() {
        showAlert("Oops!", message: "You already took a shot there.\nTry again!", handler: nil)
    }
    
    func alertOnToVictory() {
        showAlert("On to Victory!", message: "Now place the rest of your ships.", handler: nil)
    }
    
    func alertInvalidSpot() {
        showAlert("Invalid Spot!", message: "The \(model.getCurrentShipType(gameId)) can't fit or rotate there.", handler: nil)
    }
    
    func alertHandOff(alert: UIAlertAction!) {
        showAlert("Hand Off", message: "Give the \(UIDevice.currentDevice().model) to \(model.getCurrentPlayerName(gameId)).", handler: onOtherPlayerOk)
    }
    
    func onOtherPlayerOk(alert: UIAlertAction!) {
        var state: State = model.getCurrentGameState(gameId)
        if (state == State.CARRIER2) {
            alertDeploy()
        } else if (state == State.GAME) {
            setInfo()
            drawGrid(showShips: false)
        }
    }
    
    func alertBattleBegins() {
        showAlert("The Battle Begins!", message: "Give the \(UIDevice.currentDevice().model) to \(model.getCurrentPlayerName(gameId)).", handler: onOtherPlayerOk)
    }
    
}
