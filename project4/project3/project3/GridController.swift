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
    
    private var gameOver: Bool = false
    
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
    
    func gotGameDetail() {
        model.getPlayerGrids()
    }
    
    func gotPlayerGrids() {
        if (!viewGridButtonAdded) {
            addViewGridButton()
        }
        drawGrid(showShips: model.getViewingMyGrid())
    }
    
    func isPlayerTurn() {
        if (model.getViewingMyGrid()) {
            viewGridTouched()
        }
        setInfo()
        getGridView().setGridTouchAllowed(true)
        if (!viewGridButtonAdded) {
            model.getGameDetail(model.getCurrentGame().getId(), forGrid: true)
        } else {
            model.getPlayerGrids()
        }
    }
    
    func shotDone() {
        getGridView().indicator?.stopAnimating()
        setInfo()
        model.startPollingForTurn()
        model.getPlayerGrids()
    }
    
    func sunkShip(size: Int, gameOver: Bool) {
        var title: String = gameOver ? "Victory!" : "Sunk!"
        var three: String = size == 3 ? "one of " : ""
        var plural: String = size == 3 ? "s" : ""
        var message: String = gameOver ? "You won the game!" : "You sunk \(three)the \(size)-hole ship\(plural)!"
        if (gameOver) {
            getGridView().indicator?.stopAnimating()
            self.gameOver = true
        }
        showAlert(title, message: message, handler: nil)
    }
    
    func continueGame(id: String) {}
    
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
                var hasShip: Bool = type == CellType.SHIP || type == CellType.HIT
                getGridView().updateCellView(rowString, col: col, hasShip: hasShip, type: type, showShips: showShips)
            }
        }
    }
    
    func cellViewTouched(row: String, col: Int) {
        getGridView().setGridTouchAllowed(false)
        model.shotCalled(row, col: col)
    }
    
    func viewGridTouched() {
        var viewingMyGrid: Bool = model.changeViewingMyGrid()
        
        if (viewingMyGrid) {
            getGridView().setGridTouchAllowed(false)
        } else {
            getGridView().setGridTouchAllowed(model.getCurrentGame().getTurn().getId() == model.getCurrentPlayerId())
        }
        
        if (gameOver) {
            getGridView().setGridTouchAllowed(!viewingMyGrid)
        }
        
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
