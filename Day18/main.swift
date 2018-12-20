import Foundation

enum Acre: Character {
    case open = ".", tree = "|", lumberyard = "#"
}

func adjacentsAround(x: Int, y: Int, in area: [[Acre]]) -> [Acre] {
    var acres = [Acre]()

    for yy in y - 1...y + 1 {
        for xx in x - 1...x + 1 {
            if x == xx && y == yy { continue }
            if xx >= 0 && yy >= 0 && yy < area.count && xx < area[yy].count {
                acres.append(area[yy][xx])
            }
        }
    }

    return acres
}

func newAcreFor(acre: Acre, withAdjacents acres: [Acre]) -> Acre {
    switch acre {
    case .open: return acres.filter({ $0 == .tree }).count >= 3 ? .tree : .open
    case .tree: return acres.filter({ $0 == .lumberyard }).count >= 3 ? .lumberyard : .tree
    case .lumberyard: return acres.contains(.lumberyard) && acres.contains(.tree) ? .lumberyard : .open
    }
}

func nextMagicStep(currentArea: [[Acre]], nextArea: inout [[Acre]]) {
    for (y, areaLine) in currentArea.enumerated() {
        for (x, acre) in areaLine.enumerated() {
            let adjacents = adjacentsAround(x: x, y: y, in: currentArea)
            nextArea[y][x] = newAcreFor(acre: acre, withAdjacents: adjacents)
        }
    }
}

func resourceValue(of area: [[Acre]], after minutes: Int) -> Int {
    var nextArea = area
    var pastAreas = [nextArea]

    for _ in 1...minutes {
        nextMagicStep(currentArea: pastAreas.last!, nextArea: &nextArea)

        if pastAreas.contains(nextArea) {
            let startRepeating = pastAreas.firstIndex(of: nextArea)!
            let interval = pastAreas.count - startRepeating
            let repeatCount = ((minutes - startRepeating + interval) / interval) * interval
            let areaIndex = pastAreas.count - (repeatCount + startRepeating) % minutes

            nextArea = pastAreas[areaIndex]
            break
        }

        pastAreas.append(nextArea)
    }

    let treesCount = nextArea.flatMap { $0 }.filter { $0 == .tree }.count
    let lumberyardsCount = nextArea.flatMap { $0 }.filter { $0 == .lumberyard }.count

    return treesCount * lumberyardsCount
}


var area = [[Acre]]()
let inputLines = input.split(separator: "\n").map { String($0) }

for inputLine in inputLines {
    var acreLine = [Acre]()
    for a in inputLine {
        guard let acre = Acre(rawValue: a) else { fatalError() }
        acreLine.append(acre)
    }
    area.append(acreLine)
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

print("Puzzle 1 - The total resource value is: \(resourceValue(of: area, after: 10))")


// --------------------
//   MARK: - Puzzle 2
// --------------------

print("Puzzle 2 - The total resource value is: \(resourceValue(of: area, after: 1_000_000_000))")
