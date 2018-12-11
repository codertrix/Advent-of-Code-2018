import Foundation

let gridSerialNumber = 1723

func powerLevelAt(x: Int, y: Int, serialNumber: Int) -> Int {
    let rackID = x + 10
    return ((rackID * y + serialNumber) * rackID) % 1000 / 100 - 5
}

var fuelCells = Array(repeating: Array(repeating: 0, count: 301), count: 301)

for y in 1...300 {
    for x in 1...300 {
        fuelCells[x][y] = powerLevelAt(x: x, y: y, serialNumber: gridSerialNumber)
    }
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

func topLeftFor(squareSize: Int = 3) -> (x: Int, y: Int, totalPower: Int) {
    let size = squareSize - 1
    var topLeft = (x: 0, y: 0, totalPower: Int.min)

    for y in 1...300 - size {
        for x in 1...300 - size {
            var totalPower = 0
            for dx in 0...size {
                totalPower += fuelCells[x + dx][y...y + size].reduce(0, +)
            }
            if totalPower > topLeft.totalPower {
                topLeft = (x, y, totalPower)
            }
        }
    }
    return topLeft
}

var largestTopLeft = topLeftFor()

print("Puzzle 1 - The largest total power of a 3x3 square is at: \(largestTopLeft.x),\(largestTopLeft.y)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

var topLefts = [Int: (x: Int, y: Int, totalPower: Int)]()

DispatchQueue.concurrentPerform(iterations: 300) {
    topLefts[$0 + 1] = topLeftFor(squareSize: $0 + 1)
}

let largestSize = topLefts.max(by: { $0.value.totalPower < $1.value.totalPower })!

print("Puzzle 2 - The X,Y,size identifier of the square with the largest total power is: \(largestSize.value.x),\(largestSize.value.y),\(largestSize.key)")
