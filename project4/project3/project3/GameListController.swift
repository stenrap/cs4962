//
//  GameListController.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class GameListController: UITableViewController, BattleShipDelegate, UITableViewDelegate {
    
    var model: BattleShip = BattleShip()
    private var gridController: GridController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        title = "Lobby"
        
        /*
        
        WYLO .... Get this working so the model can "tell" this controller to reload data...
        
        model.dataChangedClosure = { [weak self] () in
            let tv: UITableView? = self?.tableView
            tv?.reloadData()
        }
        */
    }
    
    func createNewGame(id: Int) {
        /*
        var namesController = NamesController()
        namesController.model = model
        namesController.gameId = id
        navigationController?.pushViewController(namesController, animated: true)
        */
    }
    
    /* Methods required by BattleShipDelegate */
    func newGameCreated() {}
    func alertNewGameError() {}
    
    func promptForShip(id: Int, ship: ShipType, playerNumber: Int) {
        gridController = GridController()
        gridController!.model = model
        gridController!.gameId = id
        navigationController?.pushViewController(gridController!, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getGames().count
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var topText: String = ""
        var bottomText: String = ""
        var game: Game? = nil
        
        if (model.getGames().count > indexPath.row) {
            game = model.getGames()[indexPath.row]
        }
        
        if (game != nil) {
            topText = game!.getName()
            var status: Status = game!.getStatus()
            if (status == Status.DONE) {
                bottomText = "\(game!.getWinner()!.getName()) won the game"
            } else if (status == Status.WAITING) {
                bottomText = "Waiting for an opponent"
            } else if (status == Status.PLAYING) {
                topText += ": \(game!.getTurn().getName())'s turn"
                /*
                TODO .... Show the total number of missiles launched (which is now a single property of the game)
                bottomText = "Missiles Launched: \(game!.getPlayer1().getName()) (\(game!.getPlayer1().getShots())), \(game!.getPlayer2().getName()) (\(game!.getPlayer2().getShots()))"
                */
            }
        }
        
        var row: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell)) as UITableViewCell?
        
        if (row == nil) {
            row = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: NSStringFromClass(UITableViewCell))
        }
        
        row!.textLabel?.text = topText
        row!.detailTextLabel?.text = bottomText
        return row!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*
        TODO .... Show the grid
        gridController = GridController()
        gridController!.model = model
        gridController!.gameId = indexPath.row
        navigationController?.pushViewController(gridController!, animated: true)
        */
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        /*
        TODO .... Delete the game
        model.deleteGame(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        */
    }

}

