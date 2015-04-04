//
//  CellType.swift
//  project3
//
//  Created by Robert Johansen on 2/28/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

enum CellType {
    
    case NONE
    case MISS
    case HIT
    
    func toString() -> String {
        switch self {
            case NONE: return "NONE"
            case MISS: return "MISS"
            case HIT:  return "HIT"
        }
    }
    
}
