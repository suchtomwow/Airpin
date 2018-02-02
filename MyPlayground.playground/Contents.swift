//: Playground - noun: a place where people can play

import SwiftSoup

let path = Bundle.main.path(forResource: "File", ofType: nil)

let contentData = FileManager.default.contents(atPath: path!)

let content = String(data: contentData!, encoding: .utf8)!

do {
  let head = try SwiftSoup.parse(content).head()!
  print(head)
  let title = try head.getElementsByAttributeValue("property", "og:title").array().first?.attr("content")
}

