//
//  BattleShipController.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class BattleShipController: UITableViewController {
    
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
    
    // WYLO .... The below experimentation was fun, but you should focus on getting a 'New Game' button to display in the top right of the 
    
    private var numRows: Int = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = "Battleship"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var row: UITableViewCell = UITableViewCell()
        row.textLabel?.text = "Item \(indexPath.row)"
        return row
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        numRows--
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }

}

