//
//  Cell.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

class Cell {
    
    private var row: String
    private var col: Int
    
    func getRow() -> String {return row}
    func setRow(row: String) {self.row = row}
    
    func getCol() -> Int {return col}
    func setCol(col: Int) {self.col = col}
    
    init(row: String, col: Int) {
        self.row = row
        self.col = col
    }
    
    func toString() -> String {
        return row + String(col)
    }
    
}
