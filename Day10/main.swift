import Foundation

struct Point {
    var x: Int
    var y: Int
    let dx: Int
    let dy: Int
}


let inputLines = input.split(separator: "\n").map { String($0).split { "<>, ".contains($0) } }
var points = inputLines.map { Point(x: Int($0[1])!, y: Int($0[2])!, dx: Int($0[4])!, dy: Int($0[5])!) }

func expansionOf(points: [Point]) -> (minX: Int, maxX: Int, minY: Int, maxY: Int) {
    let minX = points.min { $0.x < $1.x }!.x
    let maxX = points.max { $0.x < $1.x }!.x
    let minY = points.min { $0.y < $1.y }!.y
    let maxY = points.max { $0.y < $1.y }!.y

    return (minX, maxX, minY, maxY)
}


// --------------------------
//   MARK: - Puzzle 1 and 2
// --------------------------

var seconds = 0

var expansion = expansionOf(points: points)
var delta = (x: expansion.maxX - expansion.minX, y: expansion.maxY - expansion.minY)
var lastDelta = delta

while true {
    let newPoints = points.map {  Point(x: $0.x + $0.dx, y: $0.y + $0.dy, dx: $0.dx, dy: $0.dy) }

    expansion = expansionOf(points: newPoints)
    delta.x = expansion.maxX - expansion.minX
    delta.y = expansion.maxY - expansion.minY

    if lastDelta.x < delta.x || lastDelta.y < delta.y {
        break
    }

    lastDelta = delta
    seconds += 1
    points = newPoints
}

expansion = expansionOf(points: points)

print("Puzzle 1:\n")

for y in expansion.minY...expansion.maxY {
    var line = ""
    for x in expansion.minX...expansion.maxX {
        if points.contains(where: { $0.x == x && $0.y == y }) {
            line += "#"
        } else {
            line += " "
        }
    }
    print(line)
}

print("\nPuzzle 2 - Seconds: \(seconds)")
