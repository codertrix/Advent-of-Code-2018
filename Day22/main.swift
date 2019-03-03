import Foundation

let depth = 11541
let targetX = 14
let targetY = 778
let maxX = 50
let maxY = 1000


// --------------------
//   MARK: - Puzzle 1
// --------------------

var geoIndex = Array(repeating: Array(repeating: 0, count: maxX + 1), count: maxY + 1)
var erosionL = Array(repeating: Array(repeating: 0, count: maxX + 1), count: maxY + 1)

for y in 0...maxY {
    for x in 0...maxX {
        switch (x, y) {
        case (0, 0), (targetX, targetY): geoIndex[y][x] = 0
        case (_, 0): geoIndex[y][x] = x * 16807
        case (0, _): geoIndex[y][x] = y * 48271
        default: geoIndex[y][x] = erosionL[y - 1][x] * erosionL[y][x - 1]
        }
        erosionL[y][x] = (geoIndex[y][x] + depth) % 20183
    }
}

var riskLevel = 0

for y in 0...targetY {
    for x in 0...targetX {
        riskLevel += erosionL[y][x] % 3
    }
}

print("Puzzle 1 - The total risk level is: \(riskLevel)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

enum Tool: CaseIterable {
    case climbingGear, neither, torch
}

struct Square: Comparable, Equatable, Hashable {
    static func < (lhs: Square, rhs: Square) -> Bool {
        return lhs.minutes < rhs.minutes
    }

    static func == (lhs: Square, rhs: Square) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.tool == rhs.tool
    }

    let x: Int
    let y: Int
    let minutes: Int
    let tool: Tool

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(tool)
    }
}

private extension Int {
    var left: Int   { return (self * 2) + 1 }
    var right: Int  { return (self * 2) + 2 }
    var parent: Int { return (self - 1) / 2 }
}

class PriorityQueue<Element: Comparable> {
    private var queue = [Element]()
    public var isEmpty: Bool { return queue.count == 0 }


    func push(_ element: Element) {
        var childIndex = queue.count
        var parentIndex = childIndex.parent

        queue.append(element)

        while queue[parentIndex] > queue[childIndex] {
            queue.swapAt(childIndex, parentIndex)
            childIndex = parentIndex
            parentIndex = childIndex.parent
        }
    }

    func pop() -> Element? {
        guard let root = queue.first else { return nil }
        guard queue.count > 1 else {
            queue.removeLast()
            return root
        }

        queue[0] = queue.removeLast()

        var parentIndex = 0

        while true {
            var childIndex = parentIndex.left
            if childIndex >= queue.count { break }

            let rightIndex = parentIndex.right
            if rightIndex < queue.count && queue[rightIndex] < queue[childIndex] {
                childIndex = rightIndex
            }

            if queue[parentIndex] < queue[childIndex] { break }

            queue.swapAt(parentIndex, childIndex)
            parentIndex = childIndex
        }

        return root
    }
}

func isValid(tool: Tool, for type: Int) -> Bool {
    switch (type, tool) {
    case (0, .climbingGear), (0, .torch): return true
    case (1, .climbingGear), (1, .neither): return true
    case (2, .neither), (2, .torch): return true
    default: return false
    }
}

func neighbour(number: Int, for coordinate: (x: Int, y: Int)) -> (x: Int, y: Int) {
    switch number {
    case 0: return (coordinate.x, coordinate.y - 1)
    case 1: return (coordinate.x + 1, coordinate.y)
    case 2: return (coordinate.x, coordinate.y + 1)
    case 3: return (coordinate.x - 1, coordinate.y)
    default: return coordinate
    }
}

var seen: Set<Square> = []
var queue = PriorityQueue<Square>()

queue.push(Square(x: 0, y: 0, minutes: 0, tool: .torch))

while !queue.isEmpty {
    guard let square = queue.pop() else { fatalError() }

    if square.x == targetX && square.y == targetY && square.tool == .torch {
        print("Puzzle 2 - The target can be reached in \(square.minutes) minutes\n")
        break
    }

    if seen.contains(square) { continue }
    seen.insert(square)

    for tool in Tool.allCases {
        if square.tool == tool { continue }
        if isValid(tool: tool, for: erosionL[square.y][square.x] % 3) {
            //print("\(square.tool) - \(tool)")
            queue.push(Square(x: square.x, y: square.y, minutes: square.minutes + 7, tool: tool))
        }
    }

    for n in 0...3 {
        let (x, y) = neighbour(number: n, for: (square.x, square.y))
        if x < 0 || y < 0 || x > maxX || y > maxY { continue }
        if isValid(tool: square.tool, for: erosionL[y][x] % 3) {
            queue.push(Square(x: x, y: y, minutes: square.minutes + 1, tool: square.tool))
        }
    }
}
