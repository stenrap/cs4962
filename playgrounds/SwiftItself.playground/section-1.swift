// Playground - noun: a place where people can play

import UIKit

var test: Bool = true

var num: Int = 2

if (test) {
    num = 1
}

var someNum: Int?
someNum = 1

if someNum != nil {
    var anotherNum = 1 + someNum!
}

if var num = someNum {
    var result = num + 4
}

let age = 2

assert(age >= 0, "Must be greater than or equal to zero")

var hey = "Hey"

var yo = "yo"

var pets = [
    "dog"  : "poodle",
    "bird" : "seagull"
]

pets["dog"]

enum Hole {
    case EMPTY
    case MISS
    case HIT
    
    func getValue() -> String {
        switch self {
            case EMPTY: return "empty"
            case MISS:  return "miss"
            case HIT:   return "hit"
        }
    }
}

var A1: Hole = Hole.HIT

A1.getValue()

var row: String = "A"
var s = row.unicodeScalars
var value = s[s.startIndex].value
if (value <= 74) {
    println("Valid!")
}

value += 1

var colValue = 1
++colValue

if (A1 == Hole.HIT) {
    println("Yep")
} else {
    println("Nope")
}

class Player {}

var player1: Player = Player()
var player2: Player = Player()

player1 === player1
player1 === player2

enum State: Int {
    case NAMES = 1, CARRIER1
    mutating func next() {
        switch self {
            case NAMES: self = CARRIER1
            case CARRIER1: break
        }
    }
}

var state: State = State.NAMES
state.next()
state.rawValue
state == State.CARRIER1



















