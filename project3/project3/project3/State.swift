//
//  State.swift
//  project3
//
//  Created by Robert Johansen on 3/2/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

enum State: Int {
    case NAMES = 1, CARRIER1, BATTLESHIP1, CRUISER1, SUBMARINE1, DESTROYER1, CARRIER2, BATTLESHIP2, CRUISER2, SUBMARINE2, DESTROYER2, GAME, ENDED
    mutating func next() {
        switch self {
            case NAMES:       self = CARRIER1
            case CARRIER1:    self = BATTLESHIP1
            case BATTLESHIP1: self = CRUISER1
            case CRUISER1:    self = SUBMARINE1
            case SUBMARINE1:  self = DESTROYER1
            case DESTROYER1:  self = CARRIER2
            case CARRIER2:    self = BATTLESHIP2
            case BATTLESHIP2: self = CRUISER2
            case CRUISER2:    self = SUBMARINE2
            case SUBMARINE2:  self = DESTROYER2
            case DESTROYER2:  self = GAME
            case GAME, ENDED: break
        }
    }
}
