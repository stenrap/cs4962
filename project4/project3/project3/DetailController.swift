//
//  DetailController.swift
//  project3
//
//  Created by Robert Johansen on 4/5/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class DetailController: BaseController, BattleShipDelegate {
    
    func getDetailView() -> DetailView {return view as DetailView}
    
    override func loadView() {
        view = DetailView()
        view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        getDetailView().setId(model.getDetailGame().getId())
        getDetailView().setGame(model.getDetailGame().getName())
        getDetailView().setPlayer(1, name: model.getDetailGame().getPlayer1().getName())
        getDetailView().setPlayer(2, name: model.getDetailGame().getPlayer2().getName())
        getDetailView().setMissiles(model.getDetailGame().getMissiles())
        getDetailView().setStatus(model.getDetailGame().getStatus().toString())
        getDetailView().setWinner(model.getDetailGame().getWinnerName())
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
    func gotPlayerGrids() {}
    func isPlayerTurn() {}
    func shotDone() {}
    func sunkShip(size: Int, gameOver: Bool) {}
    func continueGame(id: String) {}
    
    /* END */
    
}
