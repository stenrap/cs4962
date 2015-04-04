//
//  GridController.swift
//  project3
//
//  Created by Robert Johansen on 3/7/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class GridController: BaseController, CellViewDelegate, ViewGridDelegate, BattleShipDelegate {
    
    func getGridView() -> GridView {return view as GridView}
    
    private var viewGridButtonAdded = false
    
    private var canConfirm: Bool = false
    
    override func loadView() {
        model.delegate = self
        
        view = GridView()
        view.backgroundColor = UIColor(red: 28/255, green: 107/255, blue: 160/255, alpha: 1.0)
        
        var myBackButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        myBackButton.addTarget(self, action: "popToRoot", forControlEvents: UIControlEvents.TouchUpInside)
        myBackButton.setTitle("< Back", forState: UIControlState.Normal)
        myBackButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        myBackButton.sizeToFit()
        
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        setInfo()
        
        var status: Status = model.getCurrentGameStatus()
        
        drawGrid(showShips: false)
        
        if (status == Status.DONE) {
            getGridView().setGridTouchAllowed(false)
        }
    }
    
    func popToRoot() {
        model.stopPollingForTurn()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    /* BEGIN Methods required by BattleShipDelegate (which may be no-ops, if necessary) */
    
    func alertNewGameError() {}
    
    func newGameCreated() {}
    
    func gameListUpdated() {}
    
    func getNameForJoin() {}
    
    func alertJoinGameError() {}
    
    func gameJoined() {}
    
    func alertGetGameDetailError() {}
    
    func gotGameDetail() {}
    
    func gotPlayerGrids() {
        if (!viewGridButtonAdded) {
            addViewGridButton()
        }
    }
    
    func isPlayerTurn() {
        if (model.getViewingMyGrid()) {
            viewGridTouched()
        }
        setInfo()
        getGridView().setGridTouchAllowed(true)
        if (!viewGridButtonAdded) {
            model.getPlayerGrids()
        }
    }
    
    /* END */
    
    override func viewDidLayoutSubviews() {
        var status: Status = model.getCurrentGameStatus()
        if (status == Status.PLAYING || status == Status.DONE) {
            addViewGridButton()
        }
    }
    
    func addViewGridButton() {
        getGridView().addViewGridButton()
        viewGridButtonAdded = true
    }
    
    private func setInfo() {
        getGridView().cellViewDelegate = self
        getGridView().viewGridDelegate = self
        getGridView().setInfo(model.getCurrentInfo())
    }
    
    private func drawGrid(showShips: Bool = true) {
        var grid: Grid = model.getCurrentGrid()
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
                var type: CellType = CellType.NONE
                if (grid.getCells()[rowString + String(col)] != nil) {
                    type = grid.getCells()[rowString + String(col)]!
                }
                var hasShip: Bool = type == CellType.SHIP
                getGridView().updateCellView(rowString, col: col, hasShip: hasShip, type: type, showShips: showShips)
            }
        }
    }
    
    func cellViewTouched(row: String, col: Int) {
        
        println("Touched a cell...")
        
        // WYLO .... See if you can get this working after you've joined a waiting game created on your MacBook Air...
        
        // TODO
        
        /*
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
                    getGridView().setPlayerName(winner!.getName()+":")
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
        */
    }
    
    func viewGridTouched() {
        var viewingMyGrid: Bool = model.changeViewingMyGrid()
        
        /*
        
        TODO .... Disable the grid if this is a DONE game.
        
        if (!model.hasWinner(gameId)) {
            getGridView().setGridTouchAllowed(!viewingMyGrid)
        }
        */
        
        drawGrid(showShips: viewingMyGrid)
        getGridView().changeViewGridButtonLabel(viewingMyGrid)
    }
    
    func alertDupe() {
        showAlert("Oops!", message: "You already took a shot there.\nTry again!", handler: nil)
    }
    
    func alertBattleBegins() {
        showAlert("The Battle Begins!", message: "TODO", handler: nil)
    }
    
}
