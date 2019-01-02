import Foundation

extension Array where Element: Unit {
    func units(of type: PartType) -> [Element] {
        return self.filter { $0.type == type && $0.hitPoints > 0 }
    }

    func cavernsInRange(in map: [[MapPart]]) -> [(x: Int, y: Int)] {
        var caverns = [(x: Int, y: Int)]()

        for unit in self {
            if map[unit.y - 1][unit.x].type == .cavern { caverns.append((x: unit.x, y: unit.y - 1)) }
            if map[unit.y][unit.x - 1].type == .cavern { caverns.append((x: unit.x - 1, y: unit.y)) }
            if map[unit.y][unit.x + 1].type == .cavern { caverns.append((x: unit.x + 1, y: unit.y)) }
            if map[unit.y + 1][unit.x].type == .cavern { caverns.append((x: unit.x, y: unit.y + 1)) }
        }

        return caverns
    }
}

func combatMap(from input: [String], elfAttackPower: Int = 3) -> [[MapPart]] {
    var map = [[MapPart]]()

    for (y, line) in input.enumerated() {
        var mapLine = [MapPart]()
        for (x, character) in line.enumerated() {
            switch character {
            case "#": mapLine.append(Wall())
            case ".": mapLine.append(Cavern())
            case "G": mapLine.append(Unit(type: .goblin, x: x, y: y))
            case "E": mapLine.append(Unit(type: .elf, x: x, y: y, attackPower: elfAttackPower))
            default: break
            }
        }
        map.append(mapLine)
    }

    return map
}

func distanceMap(for squares: [(x: Int, y: Int)], in map: [[MapPart]]) -> [[MapPart]] {
    var distanceMap = map

    func fillCoordinatesAround(x: Int, y: Int, with value: Int, in map: inout [[MapPart]], toCoordinate: (x: Int, y: Int)) {
        let coordinatesAround = [(x: x, y: y - 1), (x: x - 1, y: y), (x: x + 1, y: y), (x: x, y: y + 1)]

        for coordinate in coordinatesAround {
            switch map[coordinate.y][coordinate.x] {
            case is Cavern:
                map[coordinate.y][coordinate.x] = Distance(value: value, toCoordinate: toCoordinate)
                fillCoordinatesAround(x: coordinate.x, y: coordinate.y, with: value + 1, in: &map, toCoordinate: toCoordinate)
            case let distance as Distance:
                if distance.value > value {
                    map[coordinate.y][coordinate.x] = Distance(value: value, toCoordinate: toCoordinate)
                    fillCoordinatesAround(x: coordinate.x, y: coordinate.y, with: value + 1, in: &map, toCoordinate: toCoordinate)
                }
            default: break
            }
        }
    }

    for coordinate in squares {
        distanceMap[coordinate.y][coordinate.x] = Distance(value: 0, toCoordinate: coordinate)
        fillCoordinatesAround(x: coordinate.x, y: coordinate.y, with: 1, in: &distanceMap, toCoordinate: coordinate)
    }

    return distanceMap
}

func targetToAttack(from unit: Unit, targetType: PartType, map: [[MapPart]]) -> Unit? {
    var target: Unit?
    let coordinatesAround = [(x: unit.x, y: unit.y - 1), (x: unit.x - 1, y: unit.y), (x: unit.x + 1, y: unit.y), (x: unit.x, y: unit.y + 1)]

    for coordinate in coordinatesAround {
        if let possibleTarget = map[coordinate.y][coordinate.x] as? Unit {
            if possibleTarget.type == targetType && (target == nil || target!.hitPoints > possibleTarget.hitPoints) {
                target = possibleTarget
            }
        }
    }

    return target
}

func conductCombat(on combatMap: [[MapPart]], abortIfElfDies: Bool = false) -> Int {
    var rounds = 0
    var map = combatMap
    let units = map.flatMap({ $0 }).compactMap({ $0 as? Unit })

    combatLoop: while true {
        var unitsAlive = units.filter({ $0.hitPoints > 0 }).sorted { $0 < $1 }

        while !unitsAlive.isEmpty {
            let unit = unitsAlive.removeFirst()

            let targetType: PartType = unit.type == .elf ? .goblin : .elf
            let targets = units.units(of: targetType)

            if targets.count == 0 {
                break combatLoop
            }

            if targetToAttack(from: unit, targetType: targetType, map: map) == nil {
                let distMap = distanceMap(for: targets.cavernsInRange(in: map), in: map)
                let coordinatesAround = [(x: unit.x, y: unit.y - 1), (x: unit.x - 1, y: unit.y), (x: unit.x + 1, y: unit.y), (x: unit.x, y: unit.y + 1)]
                var moveToLocation: (x: Int, y: Int)?
                var distance = Distance(value: Int.max, toCoordinate: (x: Int.max, y: Int.max))

                for coordinate in coordinatesAround {
                    if let aDistance = distMap[coordinate.y][coordinate.x] as? Distance {
                        if aDistance < distance {
                            moveToLocation = coordinate
                            distance = aDistance
                        }
                    }
                }

                if let newLocation = moveToLocation {
                    map[unit.y][unit.x] = Cavern()
                    unit.x = newLocation.x
                    unit.y = newLocation.y
                    map[unit.y][unit.x] = unit
                }
            }

            if let target = targetToAttack(from: unit, targetType: targetType, map: map) {
                target.hitPoints -= unit.attackPower
                if target.hitPoints <= 0 {
                    if abortIfElfDies && target.type == .elf { return -1 }
                    map[target.y][target.x] = Cavern()
                    unitsAlive = unitsAlive.filter { $0.hitPoints > 0 }
                }
            }
        }

        rounds += 1
    }

    return rounds * map.flatMap({ $0 }).compactMap({ $0 as? Unit }).reduce(0, { $0 + $1.hitPoints })
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

let inputMap = input.split(separator: "\n").map { String($0) }
var outcome = conductCombat(on: combatMap(from: inputMap))

print("Puzzle 1 - The outcome of the combat is: \(outcome)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

var attackPower = 4
outcome = -1

while outcome == -1 {
    outcome = conductCombat(on: combatMap(from: inputMap, elfAttackPower: attackPower), abortIfElfDies: true)
    attackPower += 1
}

print("Puzzle 2 - The outcome of the combat is: \(outcome)")
