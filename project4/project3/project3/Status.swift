//
//  Status.swift
//  project3
//
//  Created by Robert Johansen on 3/31/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

enum Status {
    
    case CREATED
    case WAITING
    case PLAYING
    case DONE
    
    func toString() -> String {
        switch self {
            case CREATED: return "CREATED"
            case WAITING: return "WAITING"
            case PLAYING: return "PLAYING"
            case DONE:    return "DONE"
        }
    }
    
}
