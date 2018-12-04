//: [Previous](@previous) | [Next](@next)
//: ## Day 3
//: ---
//: ### Prepare Input Values
import Foundation

guard let inputURL = Bundle.main.url(forResource: "Day3Input", withExtension: "txt") else { fatalError() }
guard let input = try? String(contentsOf: inputURL) else { fatalError() }
let inputValues = input.split(separator: "\n").compactMap{ $0.split(whereSeparator: { "# ,:x".contains($0) }).compactMap { Int($0) } }

var fabric = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)
//: ---
//: ### Puzzle 1
var overlappingClaims = 0

inputValues.forEach { (claim) in
    for x in claim[1]..<claim[1] + claim[3] {
        for y in claim[2]..<claim[2] + claim[4] {
            fabric[x][y] += 1
            if fabric[x][y] == 2 { overlappingClaims += 1 }
        }
    }
}

overlappingClaims

//: ---
//: ### Puzzle 2
var claimID = 0

for claim in inputValues {
    var square = 0
    for x in claim[1]..<claim[1] + claim[3] {
        for y in claim[2]..<claim[2] + claim[4] {
            square += fabric[x][y]
        }
    }

    if square == claim[3] * claim[4] {
        claimID = claim[0]
        break
    }
}

claimID
//: ---
//: ### Results
print("Puzzle 1 - \(overlappingClaims) square inches are within two or more claims.")
print("Puzzle 2 - The id of the only claim that doesn't overlap is: \(claimID)")
