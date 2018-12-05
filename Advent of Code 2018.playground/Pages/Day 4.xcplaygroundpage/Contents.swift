//: [Previous](@previous) | [Next](@next)
//: ## Day 4
//: ---
//: ### Prepare Input Values
import Foundation

guard let inputURL = Bundle.main.url(forResource: "Day4Input", withExtension: "txt") else { fatalError() }
guard let input = try? String(contentsOf: inputURL) else { fatalError() }
let inputValues = input.split(separator: "\n").sorted()
//: ---
//: ### Puzzle 1
var guards = [String: [Int]]()
var theGuard = ""
var guardTimeline = [Int]()
var sleepStartMinute = 0

inputValues.forEach { (entry) in
    let elements = entry.split(whereSeparator: { "[] :".contains($0) }).compactMap { String($0) }

    switch elements[3] {
    case "Guard":
        theGuard = elements[4]
        guardTimeline = guards[theGuard] ?? Array(repeating: 0, count: 60)
    case "falls":
        sleepStartMinute = Int(elements[2])!
    case "wakes":
        for minute in sleepStartMinute..<Int(elements[2])! {
            guardTimeline[minute] += 1
        }
        guards[theGuard] = guardTimeline
   default:
        preconditionFailure()
    }
}

let (guardID1, maxSleepTime1) = guards.max { $0.value.reduce(0, +) < $1.value.reduce(0, +) }!
let maxMinute1 = guards[guardID1]?.firstIndex(of: maxSleepTime1.max()!) ?? -1

Int(guardID1.dropFirst())! * maxMinute1
//: ---
//: ### Puzzle 2
let (guardID2, maxSleepTime2) = guards.max { $0.value.max()! < $1.value.max()! }!
let maxMinute2 = guards[guardID2]?.firstIndex(of: maxSleepTime2.max()!) ?? -1

Int(guardID2.dropFirst())! * maxMinute2
//: ---
//: ### Results
print("Puzzle 1 - The guard \(guardID1) was asleep most during minute \(maxMinute1)")
print("Puzzle 2 - The guard \(guardID2) spent minute \(maxMinute2) asleep more than any other guard or minute")
