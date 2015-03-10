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
        var currentGrid: Grid = model.getCurrentGrid(gameId)
        // TODO .... Draw the grid for actual real...
    }
    
}
