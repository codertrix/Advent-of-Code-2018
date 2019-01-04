import Foundation

enum Opcode: String {
    case addr, addi, mulr, muli, banr, bani, borr, bori, setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr
}

struct CPU {
    var register = [0, 0, 0, 0, 0, 0]
    var instructionPointer = 0

    private var program = [(opcode: Opcode?, A: Int, B: Int, C: Int)]()
    private var ip = -1

    init(program: String) {
        for programLine in program.split(separator: "\n").map({ String($0) }) {
            let instruction = programLine.split(separator: " ")
            if instruction[0] == "#ip" {
                if let boundRegister = Int(instruction[1]) {
                    ip = boundRegister
                    continue
                }
            } else {
                self.program.append((Opcode(rawValue: String(instruction[0])), Int(instruction[1])!, Int(instruction[2])!, Int(instruction[3])!))
            }
        }
    }

    mutating func run() {
        runUntil(instructionPointer: Int.max)
    }

    mutating func runUntil(instructionPointer: Int) {
        while self.instructionPointer != instructionPointer {
            register[ip] = self.instructionPointer

            guard self.instructionPointer >= 0 && self.instructionPointer < program.count else { return }
            execute(instruction: program[self.instructionPointer])

            self.instructionPointer = register[ip] + 1
        }
    }

    private mutating func execute(instruction: (opcode: Opcode?, A: Int, B: Int, C: Int)) {
        if let opcode = instruction.opcode {
            switch opcode {
            case .addr: register[instruction.C] = register[instruction.A] + register[instruction.B]
            case .addi: register[instruction.C] = register[instruction.A] + instruction.B
            case .mulr: register[instruction.C] = register[instruction.A] * register[instruction.B]
            case .muli: register[instruction.C] = register[instruction.A] * instruction.B
            case .banr: register[instruction.C] = register[instruction.A] & register[instruction.B]
            case .bani: register[instruction.C] = register[instruction.A] & instruction.B
            case .borr: register[instruction.C] = register[instruction.A] | register[instruction.B]
            case .bori: register[instruction.C] = register[instruction.A] | instruction.B
            case .setr: register[instruction.C] = register[instruction.A]
            case .seti: register[instruction.C] = instruction.A
            case .gtir: register[instruction.C] = instruction.A > register[instruction.B] ? 1 : 0
            case .gtri: register[instruction.C] = register[instruction.A] > instruction.B ? 1 : 0
            case .gtrr: register[instruction.C] = register[instruction.A] > register[instruction.B] ? 1 : 0
            case .eqir: register[instruction.C] = instruction.A == register[instruction.B] ? 1 : 0
            case .eqri: register[instruction.C] = register[instruction.A] == instruction.B ? 1 : 0
            case .eqrr: register[instruction.C] = register[instruction.A] == register[instruction.B] ? 1 : 0
            }
        } else {
            fatalError("Bad instruction!")
        }
    }
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

var cpu = CPU(program: input)
cpu.runUntil(instructionPointer: 28)

print("Puzzle 1 - The value for register 0 is: \(cpu.register[1])")


// --------------------
//   MARK: - Puzzle 2
// --------------------

cpu = CPU(program: input)
var values: Set<Int> = []
var currentValue = 0
var lastValue = 0

while true {
    cpu.runUntil(instructionPointer: 28)
    currentValue = cpu.register[1]

    if values.contains(currentValue) {
        break
    }

    values.insert(currentValue)
    lastValue = currentValue
    cpu.instructionPointer = 6
}

print("Puzzle 2 - The value for register 0 is: \(lastValue)")
