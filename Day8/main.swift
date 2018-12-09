import Foundation

class Node {
    var children = [Node]()
    var metadata = [Int]()
}


let numbers = input.split(separator: " ").compactMap { Int($0) }
let numberCount = numbers.count


// --------------------
//   MARK: - Puzzle 1
// --------------------

var index = 0

func sumUpMetadata(node: Node) -> Int {
    var sum = 0
    if index > numberCount - 2 { return sum }

    let childCount = numbers[index]
    index += 1
    let metaCount = numbers[index]
    index += 1

    for _ in 0..<childCount {
        let childNode = Node()
        node.children.append(childNode)
        sum += sumUpMetadata(node: childNode)
    }

    for _ in 0..<metaCount {
        if index < numberCount {
            node.metadata.append(numbers[index])
            index += 1
        }
    }

    return node.metadata.reduce(sum, +)
}

let rootNode = Node()
let sumOfMetadata = sumUpMetadata(node: rootNode)

print("Puzzle 1 - The sum of all metadata entries is: \(sumOfMetadata)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

func valueOf(node: Node) -> Int {
    if node.children.isEmpty {
        return node.metadata.reduce(0, +)
    }

    var value = 0
    for child in node.metadata {
        if child - 1 < node.children.count {
            value += valueOf(node: node.children[child - 1])
        }
    }

    return value
}

let rootNodeValue = valueOf(node: rootNode)

print("Puzzle 2 - The value of the root node is: \(rootNodeValue)")
