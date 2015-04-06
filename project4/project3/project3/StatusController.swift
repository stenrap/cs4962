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
        showGameList(Status.WAITING)
    }
    
    func playingTouched() {
        showGameList(Status.PLAYING)
    }
    
    func doneTouched() {
        showGameList(Status.DONE)
    }
    
    func showGameList(status: Status) {
        model.readFromFile()
        var gameListController: GameListController = GameListController()
        gameListController.model = model
        model.delegate = gameListController
        model.lookUpGames(status)
        navigationController?.pushViewController(gameListController, animated: true)
    }
    
}
