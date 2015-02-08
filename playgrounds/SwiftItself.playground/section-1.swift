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