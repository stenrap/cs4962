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
    
    func alertNewGameError() {
        showAlert("Error", message: "Check your network connection and try again.", handler: nil)
    }
    
    func alertNewGameCreated() {
        showAlert("Success!", message: "A new game was created. Tap 'Playing' on the previous screen to see if another player has joined.", handler: nil)
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
            model.newGame(playerName, gameName: gameName)
            /*
            TODO: 
            self.navigationItem.rightBarButtonItem = nil
            getNamesView().disableNameFields()
            model.setNames(gameId, player1Name: playerName, player2Name: gameName)
            */
        }
    }
    
}
