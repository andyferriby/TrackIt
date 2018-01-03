//: Playground - noun: a place where people can play

import UIKit
import CSwiftV

var str = "Hello, playground"

let path = Bundle.main.path(forResource: "July-Entertainment", ofType: "csv")
let url = URL(fileURLWithPath: path!)
let string = try! String(contentsOf: url)

let csv = CSwiftV(with: string)
csv.rows

for row in csv.rows {
    let date = row[0]
    let amount = row[1]
    let description = row[2]
    let tag = row[3]
    
    print("\(date)        \(amount)       \(description)      \(tag)      END")
}