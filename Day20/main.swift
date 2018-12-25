import Foundation

struct Room {
    var x: Int
    var y: Int
    let path: String
}

func rooms(from input: String, startIndex index: inout String.Index, startPath: String = "", startX: Int = 0, startY: Int = 0) -> [Room] {
    var allRooms = [Room]()
    var path = startPath
    var x = startX
    var y = startY

    while index < input.endIndex {
        switch input[index] {
        case "N":
            y -= 2
            path.append(input[index])
            allRooms.append(Room(x: x, y: y, path: path))
        case "E":
            x += 2
            path.append(input[index])
            allRooms.append(Room(x: x, y: y, path: path))
        case "S":
            y += 2
            path.append(input[index])
            allRooms.append(Room(x: x, y: y, path: path))
        case "W":
            x -= 2
            path.append(input[index])
            allRooms.append(Room(x: x, y: y, path: path))
        case "(":
            index = input.index(after: index)
            allRooms.append(contentsOf: rooms(from: input, startIndex: &index, startPath: path, startX: x, startY: y))
        case "|":
            path = startPath
            x = startX
            y = startY
        case ")":
            return allRooms
        default:
            break
        }
        index = input.index(after: index)
    }

    return allRooms
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

var index = input.startIndex
var allRooms = rooms(from: input, startIndex: &index).sorted { $0.path.count < $1.path.count }

var largestNumberOfDoors = 0
var roomIndex = allRooms.count - 1

while true {
    largestNumberOfDoors = allRooms[roomIndex].path.count

    if let room = allRooms.first(where: { $0.x == allRooms[roomIndex].x && $0.y == allRooms[roomIndex].y }) {
        if room.path.count < largestNumberOfDoors {
            roomIndex -= 1
            continue
        }
    }

    break
}

print("Puzzle 1 - The largest number of doors is: \(largestNumberOfDoors)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

roomIndex = allRooms.firstIndex(where: { $0.path.count >= 1000 })!

let closerRooms = allRooms[0..<roomIndex]
var furtherRooms = allRooms[roomIndex...]

while roomIndex < furtherRooms.endIndex {
    if closerRooms.firstIndex(where: { $0.x == furtherRooms[roomIndex].x && $0.y == furtherRooms[roomIndex].y }) != nil {
        furtherRooms.remove(at: roomIndex)
    } else {
        var lastIndex = furtherRooms.endIndex
        while roomIndex != lastIndex {
            lastIndex = furtherRooms.lastIndex(where: { $0.x == furtherRooms[roomIndex].x && $0.y == furtherRooms[roomIndex].y })!
            if roomIndex != lastIndex {
                furtherRooms.remove(at: lastIndex)
            }
        }
        roomIndex += 1
    }
}

print("Puzzle 2 - \(furtherRooms.count) rooms have a shortest path with at least 1000 doors")
