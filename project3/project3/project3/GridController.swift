//
//  GridController.swift
//  project3
//
//  Created by Robert Johansen on 3/7/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class GridController: BaseController {
    
    func getGridView() -> GridView {return view as GridView}
    
    override func loadView() {
        view = GridView()
        view.backgroundColor = UIColor(red: 28/255, green: 107/255, blue: 160/255, alpha: 1.0)
        setLabels()
        setGrid()
    }
    
    private func setLabels() {
        getGridView().setPlayerName(model.getCurrentPlayerName(gameId))
        getGridView().setInstruction(model.getCurrentInstruction(gameId))
    }
    
    private func setGrid() {
        // WYLO .... Get the current grid from the model and pass it to the view (somehow in a way that the view doesn't have to "know" about model objects)...
    }
    
}
