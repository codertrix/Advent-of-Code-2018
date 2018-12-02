//: [Previous](@previous) | [Next](@next)
//: ## Day 2
//: ---
//: ### Prepare Input Values
import Foundation

guard let inputURL = Bundle.main.url(forResource: "Day2Input", withExtension: "txt") else { fatalError() }
guard let input = try? String(contentsOf: inputURL) else { fatalError() }
let inputValues = input.split(separator: "\n").compactMap { String($0) }
//: ---
//: ### Puzzle 1
var twoTimesCount = 0
var threeTimesCount = 0

inputValues.forEach { (id) in
    var foundTwoTimes = false
    var foundThreeTimes = false
    let countedSet = NSCountedSet(array: Array(id))

    countedSet.objectEnumerator().forEach({
        let count = countedSet.count(for: $0)
        if count == 2 { foundTwoTimes = true }
        if count == 3 { foundThreeTimes = true }
    })

    if foundTwoTimes { twoTimesCount += 1 }
    if foundThreeTimes { threeTimesCount += 1 }
}

let checksum = twoTimesCount * threeTimesCount
checksum
//: ---
//: ### Puzzle 2
var commonLetters = ""
let commonIDLength = 25
let inputCount = inputValues.count

outerLoop: for index1 in 0..<inputCount - 1 {
    let id1 = inputValues[index1]

    for index2 in (index1 + 1)..<inputCount {
        let id2 = inputValues[index2]
        commonLetters = ""

        for (char1, char2) in zip(id1, id2) {
            if char1 == char2 { commonLetters.append(char1) }
        }

        if commonLetters.count == commonIDLength {
            break outerLoop
        }
    }
}

commonLetters
//: ---
//: ### Results
print("Puzzle 1 - The checksum is: \(checksum)")
print("Puzzle 2 - The common letters are: \(commonLetters)")
