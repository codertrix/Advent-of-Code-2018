import Foundation

enum Opcode: CaseIterable {
    case addr, addi, mulr, muli, banr, bani, borr, bori, setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr
}

struct CPU {
    var register = [0, 0, 0, 0]
    var instruction: Int
    var A: Int
    var B: Int
    var C: Int
    let opcodeMap: [Int: Opcode]

    mutating func execute() {
        if let opcode = opcodeMap[instruction] {
            switch opcode {
            case .addr: register[C] = register[A] + register[B]
            case .addi: register[C] = register[A] + B
            case .mulr: register[C] = register[A] * register[B]
            case .muli: register[C] = register[A] * B
            case .banr: register[C] = register[A] & register[B]
            case .bani: register[C] = register[A] & B
            case .borr: register[C] = register[A] | register[B]
            case .bori: register[C] = register[A] | B
            case .setr: register[C] = register[A]
            case .seti: register[C] = A
            case .gtir: register[C] = A > register[B] ? 1 : 0
            case .gtri: register[C] = register[A] > B ? 1 : 0
            case .gtrr: register[C] = register[A] > register[B] ? 1 : 0
            case .eqir: register[C] = A == register[B] ? 1 : 0
            case .eqri: register[C] = register[A] == B ? 1 : 0
            case .eqrr: register[C] = register[A] == register[B] ? 1 : 0
            }
        } else {
            fatalError("Bad instruction!")
        }
    }
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

let samples = input1.split(separator: "\n").map { String($0) }
var sampleCount = 0
var matchingInstructions = Array(repeating: Set<Int>(), count: 16)

var opcodeMap = [Int: Opcode]()
for (instruction, opcode) in Opcode.allCases.enumerated() { opcodeMap[instruction] = opcode }

for lineIndex in stride(from: 0, to: samples.count - 1, by: 3) {
    var before = [Int]()
    var instruction = [Int]()
    var after = [Int]()

    for line in samples[lineIndex..<lineIndex + 3] {
        if line.hasPrefix("Before:") {
            before = line.split(whereSeparator: { "[, ]".contains($0) }).compactMap({ Int($0) })
        } else if line.hasPrefix("After:") {
            after = line.split(whereSeparator: { "[, ]".contains($0) }).compactMap({ Int($0) })
        } else {
            instruction = line.split(separator: " ").compactMap({ Int($0) })
        }
    }

    var matches = 0

    for instructionX in 0...15 {
        var cpu = CPU(register: before, instruction: instructionX, A: instruction[1], B: instruction[2], C: instruction[3], opcodeMap: opcodeMap)
        cpu.execute()

        if cpu.register == after {
            matchingInstructions[instruction[0]].insert(instructionX)
            matches += 1
        }
    }

    if matches >= 3 {
        sampleCount += 1
    }
}

print("Puzzle 1 - \(sampleCount) samples behave like three or more opcodes")


// --------------------
//   MARK: - Puzzle 2
// --------------------

opcodeMap.removeAll()
while true {
    if let instruction = matchingInstructions.firstIndex(where: { $0.count == 1 }) {
        let opcodeIndex = matchingInstructions[instruction].first!
        opcodeMap[instruction] = Opcode.allCases[opcodeIndex]

        for index in 0..<matchingInstructions.count {
            matchingInstructions[index].remove(opcodeIndex)
        }
    } else {
        break
    }
}

let inputLines = input2.split(separator: "\n").map { String($0) }
var cpu = CPU(register: [0, 0, 0, 0], instruction: 0, A: 0, B: 0, C: 0, opcodeMap: opcodeMap)

for line in inputLines {
    let instruction = line.split(separator: " ").compactMap({ Int($0) })

    cpu.instruction = instruction[0]
    cpu.A = instruction[1]
    cpu.B = instruction[2]
    cpu.C = instruction[3]

    cpu.execute()
}

print("Puzzle 2 - The value in register 0 is: \(cpu.register[0])")
