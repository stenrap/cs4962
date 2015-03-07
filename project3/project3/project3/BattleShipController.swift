//
//  BattleShipController.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class BattleShipController: UITableViewController, BattleShipDelegate {
    
    /*
        When the game is first launched:
        
        1. BattleShipController instantiates BattlesShip (the model) and calls its loadGames() method.
        2. BattlesShip.loadGames() reads the list of games from disk and returns them.
        3. BattleShipController instantiates BattleShipView and sets its view property equal to it.
        4. BattleShipController calls the updateGames() method on the BattleShipView instance, passing the appropriate model data.
        5. BattleShipView renders the list of games and a 'New Game' button.
    */
    
    /*
        Because you must provide a 'New Game' button, it might be necessary to override loadView()
        and set 'view' equal to an instance of BattleShipView (which extends UITableView)...
    */
    
    private var model: BattleShip = BattleShip()
    private var gridController: GridController? = nil
    
    private var numRows: Int = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        model.readFromFile()
        model.delegate = self
        tableView.dataSource = self
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TODO: Figure out how to display all the shiz required by the assignment
        var row: UITableViewCell = UITableViewCell()
        row.textLabel?.text = "Item \(indexPath.row)"
        return row
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: Delete the game from the model
        numRows--
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }

}

