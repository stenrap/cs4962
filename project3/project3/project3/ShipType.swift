//
//  ShipType.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

enum ShipType {
    case CARRIER
    case BATTLESHIP
    case CRUISER
    case SUBMARINE
    case DESTROYER
    
    func getSize() -> Int {
        switch self {
            case CARRIER:    return 5
            case BATTLESHIP: return 4
            case CRUISER,
                 SUBMARINE:  return 3
            case DESTROYER:  return 2
        }
    }
}
