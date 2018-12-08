import Foundation

struct Coordinate {
    let x: Int
    let y: Int
    var isFinite = true
    var areaSize = 0

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

let inputValues = input.split(separator: "\n").map { String($0) }
var coordinates = inputValues.map { $0.split(whereSeparator: { ", ".contains($0) }).compactMap { Int($0) } }.map { Coordinate(x: $0[0], y: $0[1]) }

let maxX = coordinates.max { $0.x < $1.x }!.x
let maxY = coordinates.max { $0.y < $1.y }!.y

// Puzzle 2
var area10000 = 0

for y in 0...maxY {
    for x in 0...maxX {
        // Puzzle 1
        let distances = coordinates.map { abs($0.x - x) + abs($0.y - y) }
        let minmum = distances.min()!
        let firstIndex = distances.firstIndex(of: minmum)!
        let lastIndex = distances.lastIndex(of: minmum)!

        if firstIndex == lastIndex {
            coordinates[firstIndex].areaSize += 1
            if [0, maxX].contains(x) || [0, maxY].contains(y) { coordinates[firstIndex].isFinite = false }
        }

        // Puzzle 2
        if distances.reduce(0, +) < 10000 {
            area10000 += 1
        }
    }
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

let largestArea = coordinates.filter { $0.isFinite }.max { $0.areaSize < $1.areaSize }?.areaSize
print("Puzzle 1 - The largest size is: \(largestArea!)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

print("Puzzle 2 - The size of the region with a distance less than 10000 to all locations is: \(area10000)")
