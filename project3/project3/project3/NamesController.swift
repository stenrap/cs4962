//
//  NamesController.swift
//  project3
//
//  Created by Robert Johansen on 3/4/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class NamesController: BaseController {
    
    func getNamesView() -> NamesView {return view as NamesView}
    
    override func loadView() {
        view = NamesView()
        view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: "nextTapped")
    }
    
    override func viewWillDisappear(animated: Bool) {
        var player1Name: String = getNamesView().getPlayer1Name()
        var player2Name: String = getNamesView().getPlayer2Name()
        
        if (countElements(player1Name) == 0 || countElements(player2Name) == 0) {
            model.deleteGame(gameId)
        }
        
        super.viewWillDisappear(true)
    }
    
    func nextTapped() {
        var player1Name: String = getNamesView().getPlayer1Name()
        var player2Name: String = getNamesView().getPlayer2Name()
        
        if (countElements(player1Name) == 0 || countElements(player2Name) == 0) {
            var alert = UIAlertController(title: "Missing Name(s)", message: "Both player names are required", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { action in } ))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.navigationItem.rightBarButtonItem = nil
            getNamesView().disableNameFields()
            model.setNames(gameId, player1Name: player1Name, player2Name: player2Name)
        }
    }
    
}
