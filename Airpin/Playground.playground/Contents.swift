//: Playground - noun: a place where people can play
extension Bool {
  init(string: String) {
    assert(string == "yes" || string == "no", "Bool(string:) accepts \"yes\" or \"no\" arguments.")
    
    if string == "yes" {
      self = true
    } else {
      self = false
    }
  }
}

let hi = Bool(string: "yes")
