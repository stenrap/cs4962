//
//  BattleShipController.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class BattleShipController: UITableViewController, BattleShipDelegate, UITableViewDelegate {
    
    private var model: BattleShip = BattleShip()
    private var gridController: GridController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        model.readFromFile()
        model.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Game", style: UIBarButtonItemStyle.Plain, target: self, action: "newGameTapped")
        title = "Battleship"
    }
    
    func newGameTapped() {
        model.newGame()
    }
    
    func createNewGame(id: Int) {
        var namesController = NamesController()
        namesController.model = model
        namesController.gameId = id
        navigationController?.pushViewController(namesController, animated: true)
    }
    
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
            var state: State = game!.getState()
            if (state == State.ENDED) {
                topText = "\(game!.getWinner()!.getName()) won the game"
            } else {
                if (state.rawValue < State.CARRIER2.rawValue) {
                    topText = "\(game!.getPlayer1().getName())'s turn to place ships"
                } else if (state.rawValue < State.GAME.rawValue) {
                    topText = "\(game!.getPlayer2().getName())'s turn to place ships"
                } else {
                    topText = "\(game!.getTurn().getName())'s turn to take a shot"
                    bottomText = "Missiles Launched: \(game!.getPlayer1().getName()) (\(game!.getPlayer1().getShots())), \(game!.getPlayer2().getName()) (\(game!.getPlayer2().getShots()))"
                }
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
        gridController = GridController()
        gridController!.model = model
        gridController!.gameId = indexPath.row
        navigationController?.pushViewController(gridController!, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        model.deleteGame(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }

}

