//
//  SettingsController.swift
//  projectF
//
//  Created by Robert Johansen on 4/18/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController, UITableViewDelegate, DigistruxDelegate {
    
    var model: Digistrux = Digistrux()
    
    override func loadView() {
        tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        title = "settings"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        title = section == 0 ? "Updates" : "Display"
        return title
    }    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var row: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell)) as UITableViewCell?
        
        if (row == nil) {
            row = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: NSStringFromClass(UITableViewCell))
        }
        
        if (indexPath.section == 0) {
            row!.textLabel?.text = indexPath.row == 0 ? "Check on document launch" : "Check on app launch"
            // TODO .... Set which option is checked based on the model, defaulting to 0 (Check on document launch)
        }
        
        return row!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var section: Int = indexPath.section
        var row: Int = indexPath.row
        
        if (section == 0) {
            // TODO .... Set which option is checked in the model
            var cellToCheck: UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath)
            cellToCheck?.accessoryType = UITableViewCellAccessoryType.Checkmark
            var rowToUncheck: Int = row == 0 ? 1 : 0
            var indexPathToUncheck: NSIndexPath = NSIndexPath(forRow: rowToUncheck, inSection: 0)
            var cellToUncheck: UITableViewCell? = tableView.cellForRowAtIndexPath(indexPathToUncheck)
            cellToUncheck?.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
}
