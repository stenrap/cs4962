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
        
        var myBackButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        myBackButton.addTarget(self, action: "popToRoot", forControlEvents: UIControlEvents.TouchUpInside)
        myBackButton.setTitle("< Back", forState: UIControlState.Normal)
        myBackButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        myBackButton.sizeToFit()
        
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        model.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        title = "Lobby"
    }
    
    func popToRoot() {
        model.stopPollingForGames()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    /* BEGIN Methods required by BattleShipDelegate (which may be no-ops, if necessary) */
    
    func newGameCreated() {}
    
    func alertNewGameError() {}
    
    func gameListUpdated() {
        tableView.reloadData()
    }
    
    func getNameForJoin() {
        var namesController: NamesController = NamesController(false)
        namesController.model = model
        model.delegate = namesController
        navigationController?.pushViewController(namesController, animated: true)
    }
    
    func alertJoinGameError() {}
    
    func gameJoined() {}
    
    func alertGetGameDetailError() {}
    
    func gotGameDetail() {}
    
    func gotPlayerGrids() {}
    
    /* END */
    
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
        model.loadGame(indexPath.row)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        /*
        TODO .... Delete the game
        model.deleteGame(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        */
    }

}

