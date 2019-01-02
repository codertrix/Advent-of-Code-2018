import Foundation

enum PartType: Character {
    case wall = "#", cavern = ".", goblin = "G", elf = "E", distance = "0"
}

protocol MapPart {
    var type: PartType { get }
}

struct Wall: MapPart {
    let type: PartType = .wall
}

struct Cavern: MapPart {
    let type: PartType = .cavern
}

struct Distance: MapPart {
    let type: PartType = .distance
    let value: Int
    let toCoordinate: (x: Int, y: Int)

    init(value: Int, toCoordinate: (x: Int, y: Int)) {
        self.value = value
        self.toCoordinate = toCoordinate
    }

    static func < (lhs: Distance, rhs: Distance) -> Bool {
        if lhs.value == rhs.value {
            return lhs.toCoordinate.y < rhs.toCoordinate.y || (lhs.toCoordinate.y == rhs.toCoordinate.y && lhs.toCoordinate.x < rhs.toCoordinate.x)
        }

        return lhs.value < rhs.value
    }
}

class Unit: MapPart {
    let type: PartType
    var x: Int
    var y: Int
    var attackPower: Int
    var hitPoints = 200

    init(type: PartType, x: Int, y: Int, attackPower: Int = 3) {
        self.type = type
        self.x = x
        self.y = y
        self.attackPower = attackPower
    }

    static func < (lhs: Unit, rhs: Unit) -> Bool {
        return lhs.y < rhs.y || (lhs.y == rhs.y && lhs.x < rhs.x)
    }
}
