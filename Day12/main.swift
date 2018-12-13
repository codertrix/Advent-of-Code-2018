import Foundation

let lines = notes.split(separator: "\n").map { String($0) }
var potsPlantMapping = Array(repeating: false, count: 32)

lines.forEach { (line) in
    let lineInNumbers = line.map({ $0 == "#" ? 1 : 0 })
    if lineInNumbers.last == 1 {
        potsPlantMapping[lineInNumbers[0..<5].reduce(0, { $0 << 1 + $1 })] = true
    }
}

func initialPlants() -> [Int: Bool] {
    var plants = [Int: Bool]()

    for (index, value) in initialState.enumerated() {
        if value == "#" { plants[index] = true }
    }

    return plants
}

func nextGeneration(of plants: [Int: Bool], mapping: [Bool]) -> [Int: Bool] {
    var newPlants = [Int: Bool]()

    for index in plants.keys.min()! - 3...plants.keys.max()! + 3 {
        var mappingIndex = plants[index - 2] ?? false ? 16 : 0
        mappingIndex += plants[index - 1] ?? false ? 8 :0
        mappingIndex += plants[index] ?? false ? 4 : 0
        mappingIndex += plants[index + 1] ?? false ? 2 : 0
        mappingIndex += plants[index + 2] ?? false ? 1 : 0

        if mapping[mappingIndex] { newPlants[index] = true }
    }

    return newPlants
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

var plants = initialPlants()

for _ in 1...20 {
    plants = nextGeneration(of: plants, mapping: potsPlantMapping)
}

var sumOfPotNumbers = plants.keys.reduce(0, +)

print("Puzzle 1 - The sum of the numbers of all pots which contain a plant is: \(sumOfPotNumbers)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

plants = initialPlants()
var offset = 0

for count in 1...50_000_000_000 {
    sumOfPotNumbers = plants.keys.reduce(0, { $0 + $1 })
    plants = nextGeneration(of: plants, mapping: potsPlantMapping)

    let newSumOfPotNumbers = plants.keys.reduce(0, { $0 + $1 - 1 })
    if sumOfPotNumbers == newSumOfPotNumbers {
        offset = 50_000_000_000 - count
        break
    }
    sumOfPotNumbers = newSumOfPotNumbers
}

sumOfPotNumbers = plants.keys.reduce(0, { $0 + $1 + offset })

print("Puzzle 2 - The sum of the numbers of all pots which contain a plant is: \(sumOfPotNumbers)")
