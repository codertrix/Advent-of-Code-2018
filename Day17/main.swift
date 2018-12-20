import Foundation

let inputLines = input.split(separator: "\n").map { String($0) }
var clays = [(x: Int, y: Int)]()

for line in inputLines {
    let numbers = line.split(whereSeparator: { "=,.".contains($0) }).compactMap { Int($0) }
    for number in numbers[1]...numbers[2] {
        if line.hasPrefix("x") {
            clays.append((x: numbers[0], y: number))
        } else {
            clays.append((x: number, y: numbers[0]))
        }
    }
}

var minX = clays.min { $0.x < $1.x }!.x - 1
var maxX = clays.max { $0.x < $1.x }!.x + 1
var minY = clays.min { $0.y < $1.y }!.y
var maxY = clays.max { $0.y < $1.y }!.y
let spring = (x: 500 - minX, y: 0)

var scan = Array(repeating: Array<Character>(repeating: ".", count: maxX - minX + 1), count: maxY + 1)
scan[spring.y][spring.x] = "+"

for clay in clays {
    scan[clay.y][clay.x - minX] = "#"
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

func waterMoveDownFrom(x: Int, y: Int, in scan: inout [[Character]]) {
    let nextY = y + 1
    guard nextY < scan.count else { return }

    if scan[nextY][x] == "." {
        waterMoveDownFrom(x: x, y: nextY, in: &scan)
    }

    if scan[nextY][x] == "#" || scan[nextY][x] == "~" {
        let leftClay = findLeftClay(x: x, y: y, in: &scan)
        let rightClay = findRightClay(x: x, y: y, in: &scan)

        if leftClay >= 0 && rightClay < scan[y].count {
            for wx in leftClay + 1..<rightClay { scan[y][wx] = "~" }
        }
    } else {
        scan[nextY][x] = "|"
    }
}

func findLeftClay(x: Int, y: Int, in scan: inout [[Character]]) -> Int {
    let nextX = x - 1
    let nextY = y + 1
    guard nextX >= 0 else { return -1 }

    if !".|".contains(scan[nextY][nextX]) && ".|".contains(scan[y][nextX]) {
        scan[y][nextX] = "|"
        return findLeftClay(x: nextX, y: y, in: &scan)
    }

    if scan[y][nextX] == "#" { return nextX }
    if scan[y][nextX] == "." {
        scan[y][nextX] = "|"
        waterMoveDownFrom(x: nextX, y: y, in: &scan)
    }

    return -1
}

func findRightClay(x: Int, y: Int, in scan: inout [[Character]]) -> Int {
    let nextX = x + 1
    let nextY = y + 1
    guard nextX < scan[y].count else { return scan[y].count }

    if !".|".contains(scan[nextY][nextX]) && ".|".contains(scan[y][nextX]) {
        scan[y][nextX] = "|"
        return findRightClay(x: nextX, y: y, in: &scan)
    }

    if scan[y][nextX] == "#" { return nextX }
    if scan[y][nextX] == "." {
        scan[y][nextX] = "|"
        waterMoveDownFrom(x: nextX, y: y, in: &scan)
    }

    return scan[y].count
}

waterMoveDownFrom(x: spring.x, y: spring.y, in: &scan)

var movingWater = 0
var restingWater = 0

for y in minY..<scan.count {
    for tile in scan[y] {
        if tile == "|" { movingWater += 1 }
        if tile == "~" { restingWater += 1 }
    }
}

print("Puzzle 1 - The water can reach \(movingWater + restingWater) tiles")


// --------------------
//   MARK: - Puzzle 2
// --------------------

print("Puzzle 2 - \(restingWater) water tiles remain")
