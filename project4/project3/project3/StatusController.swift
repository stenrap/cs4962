//
//  StatusController.swift
//  project3
//
//  Created by Robert Johansen on 3/30/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class StatusController: BaseController, StatusViewDelegate {
    
    func getStatusView() -> StatusView {return view as StatusView}
    
    override func loadView() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Game", style: UIBarButtonItemStyle.Plain, target: self, action: "newGameTapped")
        model = BattleShip()
        model.readFromFile()
        view = StatusView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        getStatusView().delegate = self
        view.backgroundColor = UIColor.whiteColor()
    }
    
    func newGameTapped() {
        var namesController: NamesController = NamesController(true)
        namesController.model = model
        navigationController?.pushViewController(namesController, animated: true)
    }
    
    func waitingTouched() {
        model.lookUpGames(Status.WAITING)
        var gameListController: GameListController = GameListController()
        gameListController.model = model
        navigationController?.pushViewController(gameListController, animated: true)
    }
    
    func playingTouched() {
        println("playingTouched")
    }
    
    func doneTouched() {
        println("doneTouched")
    }
    
}
