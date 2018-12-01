//: [Previous](@previous) [Next](@next)
//: ## Day 1
//: ---
//: ### Prepare Input Values
import Foundation

guard let inputURL = Bundle.main.url(forResource: "Day1Input", withExtension: "txt") else { fatalError() }
guard let input = try? String(contentsOf: inputURL) else { fatalError() }
let inputValues = input.split(separator: "\n").compactMap { Int($0) }
//: ---
//: ### Puzzle 1
let result = inputValues.reduce(0) { $0 + $1 }
//: ---
//: ### Puzzle 2
var frequencies: Set = [0]
var frequency = 0

endlessLoop: while true {
    for value in inputValues {
        frequency += value
        if frequencies.contains(frequency) {
            break endlessLoop
        }
        frequencies.insert(frequency)
    }
}
//: ---
//: ### Results
print("Puzzle 1 - The resulting frequency is: \(result)")
print("Puzzle 2 - The first frequency the device reaches twice is: \(frequency)")
