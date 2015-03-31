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
        var namesController = NamesController(true)
        namesController.model = model
        navigationController?.pushViewController(namesController, animated: true)
    }
    
    func waitingTouched() {
        // WYLO .... Make an API call to get a list of 10 waiting games, but don't display any that are in model.savedGames!
        //
        //           
        println("waitingTouched")
    }
    
    func playingTouched() {
        println("playingTouched")
    }
    
    func doneTouched() {
        println("doneTouched")
    }
    
}
