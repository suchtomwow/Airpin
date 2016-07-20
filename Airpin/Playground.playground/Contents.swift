//: Playground - noun: a place where people can play
import UIKit

let token = "thomasjcarey:"

let parts = token.components(separatedBy: ":").filter { $0.characters.count > 0 }

print(parts)

