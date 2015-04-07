//
//  NamesController.swift
//  project3
//
//  Created by Robert Johansen on 3/4/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class NamesController: BaseController, BattleShipDelegate {
    
    private var gameNameVisible: Bool
    
    func getNamesView() -> NamesView {return view as NamesView}
    
    init(_ gameNameVisible: Bool) {
        self.gameNameVisible = gameNameVisible
        super.init(nibName: nil, bundle: nil);
    }
    
    override func viewWillAppear(animated: Bool) {
        var myBackButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        myBackButton.addTarget(self, action: "popToRoot", forControlEvents: UIControlEvents.TouchUpInside)
        myBackButton.setTitle("< Back", forState: UIControlState.Normal)
        myBackButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        myBackButton.sizeToFit()
        
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    /* BEGIN Methods required by BattleShipDelegate (which may be no-ops, if necessary) */
    
    func alertNewGameError() {
        showAlert("Error", message: "Check your network connection and try again.", handler: nil)
    }
    
    func newGameCreated() {
        showGridAndPollForTurn()
    }
    
    func gameListUpdated() {}
    
    func getNameForJoin() {}
    
    func alertJoinGameError() {
        showAlert("Error", message: "The game could not be joined.", handler: gameErrorClosed)
    }
    
    func gameJoined() {
        model.getGameAfterJoin()
    }
    
    func alertGetGameDetailError() {
        showAlert("Error", message: "Battleship encountered an unknown error.", handler: gameErrorClosed)
    }
    
    func gotGameDetail() {
        model.getPlayerGrids()
    }
    
    func gotPlayerGrids() {
        showGridAndPollForTurn()
    }
    
    func isPlayerTurn() {}
    
    func shotDone() {}
    
    func sunkShip(size: Int, gameOver: Bool) {}
    
    func continueGame(id: String) {}
    
    /* END */
    
    func showGridAndPollForTurn() {
        var gridController: GridController = GridController()
        gridController.model = model
        model.delegate = gridController
        navigationController?.pushViewController(gridController, animated: true)
        model.startPollingForTurn()
    }
    
    func gameErrorClosed(alert: UIAlertAction!) {
        popToRoot()
    }
    
    func popToRoot() {
        model.stopPollingForGames()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func loadView() {
        view = NamesView(gameNameVisible)
        view.backgroundColor = UIColor.whiteColor()
        model.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: "nextTapped")
    }
    
    override func viewWillDisappear(animated: Bool) {
        var playerName: String = getNamesView().getPlayerName()
        var gameName: String = getNamesView().getGameName()
        
        if (countElements(playerName) == 0 || countElements(gameName) == 0) {
            // model.deleteGame(gameId)
        }
        
        super.viewWillDisappear(true)
    }
    
    func nextTapped() {
        var playerName: String = getNamesView().getPlayerName()
        var gameName: String = getNamesView().getGameName()
        
        if (countElements(playerName) == 0 || (gameNameVisible && countElements(gameName) == 0)) {
            var message: String = gameNameVisible ? "Player and game names are required" : "Player name is required"
            var alert = UIAlertController(title: "Missing Name(s)", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { action in } ))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.navigationItem.rightBarButtonItem = nil
            getNamesView().disableNameFields()
            if (gameNameVisible) {
                model.createNewGame(playerName, gameName: gameName)
            } else {
                model.setJoinPlayerName(playerName)
                model.joinGame()
            }
        }
    }
    
}
