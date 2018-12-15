import Foundation

struct Cart {
    enum Direction {
        case up, down, left, right
    }

    private enum Turn {
        case left, straight, right
    }

    var location: (x: Int, y: Int)
    var direction: Direction
    private var nextTurn = Turn.left

    init(location: (x: Int, y: Int), direction: Direction) {
        self.location = location
        self.direction = direction
    }

    mutating func advance() {
        switch direction {
        case .up: location.y -= 1
        case .down: location.y += 1
        case .left: location.x -= 1
        case .right: location.x += 1
        }
    }

    mutating func turn(for trackPart: String) {
        switch trackPart {
        case "/":
            switch direction {
            case .up: direction = .right
            case .down: direction = .left
            case .left: direction = .down
            case .right: direction = .up
            }
        case "\\":
            switch direction {
            case .up: direction = .left
            case .down: direction = .right
            case .left: direction = .up
            case .right: direction = .down
            }
        case "+":
            switch nextTurn {
            case .left:
                switch direction {
                case .up: direction = .left
                case .down: direction = .right
                case .left: direction = .down
                case .right: direction = .up
                }
                nextTurn = .straight
            case .straight:
                nextTurn = .right
            case .right:
                switch direction {
                case .up: direction = .right
                case .down: direction = .left
                case .left: direction = .up
                case .right: direction = .down
                }
                nextTurn = .left
            }
        default:
            break
        }
    }
}


let trackMap = input.split(separator: "\n").map { String($0).map({ String($0) }) }

func cartsIn(trackMap: [[String]]) -> [Cart] {
    var carts = [Cart]()

    for (y, line) in trackMap.enumerated() {
        for (x, character) in line.enumerated() {
            switch character {
            case "^": carts.append(Cart(location: (x, y), direction: .up))
            case "v": carts.append(Cart(location: (x, y), direction: .down))
            case "<": carts.append(Cart(location: (x, y), direction: .left))
            case ">": carts.append(Cart(location: (x, y), direction: .right))
            default: break
            }
        }
    }

    return carts
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

func findCrash(trackMap: [[String]], carts: [Cart]) -> (x: Int, y: Int) {
    var currentCarts = carts
    while true {
        currentCarts.sort { (cart1, cart2) -> Bool in
            if cart1.location.y == cart2.location.y {
                return cart1.location.x < cart2.location.x
            }
            return cart1.location.y < cart2.location.y
        }

        for cartNumber in 0..<currentCarts.count {
            currentCarts[cartNumber].advance()
            let location = currentCarts[cartNumber].location
            currentCarts[cartNumber].turn(for: trackMap[location.y][location.x])

            let crashedCarts = currentCarts.filter({ $0.location == location })
            if crashedCarts.count > 1 {
                return location
            }
        }
    }
}

var carts = cartsIn(trackMap: trackMap)
var crashLocation = findCrash(trackMap: trackMap, carts: carts)

print("Puzzle 1 - The location of the first crash is: \(crashLocation)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

func lastCart(trackMap: [[String]], carts: [Cart]) -> Cart {
    var currentCarts = carts

    while true {
        currentCarts.sort { (cart1, cart2) -> Bool in
            if cart1.location.y == cart2.location.y {
                return cart1.location.x < cart2.location.x
            }
            return cart1.location.y < cart2.location.y
        }

        var cartIndex = 0
        while cartIndex < currentCarts.count {
            currentCarts[cartIndex].advance()
            let location = currentCarts[cartIndex].location
            currentCarts[cartIndex].turn(for: trackMap[location.y][location.x])

            let crashedCarts = currentCarts.filter { $0.location == location }
            if crashedCarts.count > 1 {
                crashedCarts.forEach { (cart) in
                    let index = currentCarts.firstIndex(where: { $0.location == cart.location })!
                    currentCarts.remove(at: index)
                    if index <= cartIndex {
                        cartIndex -= 1
                    }
                }
            }

            cartIndex += 1
        }

        if currentCarts.count == 1 {
            return currentCarts[0]
        }
    }
}

carts = cartsIn(trackMap: trackMap)
let cart = lastCart(trackMap: trackMap, carts: carts)

print("Puzzle 2 - The location of the last cart is: \(cart.location)")
