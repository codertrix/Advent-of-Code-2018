import Foundation

class Step {
    let name: String
    var duration: Int
    var waitCount = 0
    var nextSteps = [String]()

    init(name: String) {
        self.name = name
        duration = Int(name.utf8[name.utf8.startIndex]) - 4
    }
}

extension Array where Element:Step {
    func stepWith(name: String) -> Step? {
        return self.first { $0.name == name }
    }
}


let inputLines = input.split(separator: "\n").map { String($0).split(separator: " ") }
let instructions = inputLines.map { (String($0[1]), String($0[7])) }

func stepsFor(instructions: [(String, String)]) -> [Step] {
    var steps = [Step]()
    instructions.forEach { (instruction) in
        if steps.stepWith(name: instruction.0) == nil {
            steps.append(Step(name: instruction.0))
        }
        if steps.stepWith(name: instruction.1) == nil {
            steps.append(Step(name: instruction.1))
        }
    }

    instructions.forEach { (instruction) in
        if let step = steps.stepWith(name: instruction.0) {
            step.nextSteps.append(instruction.1)
        }
        if let step = steps.stepWith(name: instruction.1) {
            step.waitCount += 1
        }
    }

    return steps.sorted { $0.name < $1.name }
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

var order = ""
var steps = stepsFor(instructions: instructions)

for _ in 1...steps.count {
    if let nextAvailableStep = steps.first(where: { $0.waitCount == 0 }) {
        order += nextAvailableStep.name
        nextAvailableStep.waitCount = -1
        nextAvailableStep.nextSteps.forEach { (step) in
            steps.stepWith(name: step)?.waitCount -= 1
        }
    }
}

print("Puzzle 1 - The steps should be completed in the order: \(order)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

var time = 0
let workers = 5
steps = stepsFor(instructions: instructions)

var workerSteps = steps.filter({ $0.waitCount == 0 })
if workerSteps.count > workers {
    workerSteps = Array(workerSteps[0..<workers])
}

while !workerSteps.isEmpty {
    time += 1

    workerSteps.forEach { (step) in
        step.duration -= 1
        if step.duration == 0 {
            step.waitCount = -1
            step.nextSteps.forEach { (step) in
                steps.stepWith(name: step)?.waitCount -= 1
            }
        }
    }
    workerSteps = workerSteps.filter({ $0.waitCount == 0 })

    let availableSteps = steps.filter({ $0.waitCount == 0 })
    for step in availableSteps {
        if workerSteps.count == workers { break }
        if workerSteps.stepWith(name: step.name) == nil {
            workerSteps.append(step)
        }
    }
}

print("Puzzle 2 - It will take \(time) seconds to complete all steps")
