import Foundation

let fixedPoints = input.split(separator: "\n").map { String($0).split(separator: ",").compactMap({ Int($0) }) }.map { ($0[0], $0[1], $0[2], $0[3]) }


// --------------------
//   MARK: - Puzzle 1
// --------------------

var constellations = [[(Int, Int, Int, Int)]]()

for point in fixedPoints {
    if constellations.isEmpty {
        constellations.append([point])
    } else {
        var constellationIndex = 0
        var constellationIndexes = [Int]()

        while constellationIndex < constellations.endIndex {
            for constellationPoint in constellations[constellationIndex] {
                let d0 = abs(constellationPoint.0 - point.0)
                let d1 = abs(constellationPoint.1 - point.1)
                let d2 = abs(constellationPoint.2 - point.2)
                let d3 = abs(constellationPoint.3 - point.3)

                if d0 + d1 + d2 + d3 <= 3 {
                    constellations[constellationIndex].append(point)
                    constellationIndexes.append(constellationIndex)
                    break
                }
            }
            constellationIndex += 1
        }

        if constellationIndexes.count > 1 {
            var constellation = [(Int, Int, Int, Int)]()

            for constellationIndex in constellationIndexes.reversed() {
                constellation.append(contentsOf: constellations.remove(at: constellationIndex))
            }

            constellations.append(constellation)
        }

        if constellationIndexes.isEmpty {
            constellations.append([point])
        }
    }
}

print("Puzzle 1 - The number of constellations is: \(constellations.count)")
