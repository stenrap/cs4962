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
    private var fontSizeSlider: UISlider = UISlider()
    private var sliderAdded: Bool = false
    
    override func loadView() {
        tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        fontSizeSlider.minimumValue = 12
        fontSizeSlider.maximumValue = 18
        fontSizeSlider.value = Float(model.getFontSize())
        title = "settings"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
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
            if (model.getUpdates() == "doc" && indexPath.row == 0 || model.getUpdates() == "app" && indexPath.row == 1) {
                row!.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        } else {
            if (indexPath.row == 0) {
                row!.textLabel?.text = "Font (\(model.getFontName()))"
                row!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            } else {
                row!.textLabel?.text = "Size"
                if (!sliderAdded) {
                    fontSizeSlider.addTarget(self, action: "onFontSizeChange:", forControlEvents: UIControlEvents.ValueChanged)
                    fontSizeSlider.bounds = CGRectMake(0, 0, row!.contentView.bounds.width - 80, fontSizeSlider.bounds.size.height)
                    fontSizeSlider.center = CGPointMake(CGRectGetMidX(row!.contentView.bounds) + 20, CGRectGetMidY(row!.contentView.bounds))
                    row!.contentView.addSubview(fontSizeSlider)
                    sliderAdded = true
                }
            }
        }
        
        return row!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var section: Int = indexPath.section
        var row: Int = indexPath.row
        
        if (section == 0) {
            model.setUpdates(row == 0 ? "doc" : "app")
            var cellToCheck: UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath)
            cellToCheck?.accessoryType = UITableViewCellAccessoryType.Checkmark
            var rowToUncheck: Int = row == 0 ? 1 : 0
            var indexPathToUncheck: NSIndexPath = NSIndexPath(forRow: rowToUncheck, inSection: 0)
            var cellToUncheck: UITableViewCell? = tableView.cellForRowAtIndexPath(indexPathToUncheck)
            cellToUncheck?.accessoryType = UITableViewCellAccessoryType.None
        } else {
            if (row == 0) {
                var fontListController: FontListController = FontListController()
                fontListController.model = model
                fontListController.model.delegate = fontListController
                navigationController?.pushViewController(fontListController, animated: true)
            }
        }
    }
    
    func onFontSizeChange(slider: UISlider!) {
        var sliderValue: Float = slider.value
        if (sliderValue < 12.5) {
            slider.value = 12
        } else if (sliderValue >= 12.5 && sliderValue < 13.5) {
            slider.value = 13
        } else if (sliderValue >= 13.5 && sliderValue < 14.5) {
            slider.value = 14
        } else if (sliderValue >= 14.5 && sliderValue < 15.5) {
            slider.value = 15
        } else if (sliderValue >= 15.5 && sliderValue < 16.5) {
            slider.value = 16
        } else if (sliderValue >= 16.5 && sliderValue < 17.5) {
            slider.value = 17
        } else {
            slider.value = 18
        }
        model.setFontSize(Int(slider.value))
    }
    
}
