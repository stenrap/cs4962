//
//  FontListController.swift
//  projectF
//
//  Created by Robert Johansen on 4/25/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class FontListController: UITableViewController, UITableViewDelegate, DigistruxDelegate {
    
    var model: Digistrux = Digistrux()
    private var fontNames: [String] = [String]()
    
    override func loadView() {
        super.loadView()
        var allFontNames: [String] = UIFont.familyNames() as [String]
        var unsortedFontNames: [String] = [String]()
        for (var i: Int = 0;  i < allFontNames.count; i++) {
            if (allFontNames[i].rangeOfString(" ") != nil) {
                continue
            } else {
                unsortedFontNames.append(allFontNames[i])
            }
        }
        fontNames = sorted(unsortedFontNames, <)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        title = "font"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fontNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var row: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell)) as UITableViewCell?
        
        if (row == nil) {
            row = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: NSStringFromClass(UITableViewCell))
        } else {
            row!.accessoryType = UITableViewCellAccessoryType.None
        }
        
        row!.textLabel?.text = fontNames[indexPath.row]
        
        if (row!.textLabel?.text == model.getFontName()) {
            row!.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return row!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToCheck: UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath)
        model.setFontName(cellToCheck!.textLabel!.text!)
        for (var i: Int = 0; i < fontNames.count; i++) {
            var cellToUncheck: UITableViewCell? = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0))
            cellToUncheck?.accessoryType = UITableViewCellAccessoryType.None
        }
        cellToCheck?.accessoryType = UITableViewCellAccessoryType.Checkmark
        tableView.setNeedsDisplay()
    }
    
}
