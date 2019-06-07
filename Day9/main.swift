import Foundation

class Marble {
    let value: Int
    weak var prevMarble: Marble!
    var nextMarble: Marble!

    init(value: Int, prevMarble: Marble? = nil, nextMarble: Marble? = nil) {
        self.value = value
        self.prevMarble = prevMarble
        self.nextMarble = nextMarble
    }
}


let players = 458
let marbles = 71307

func playMarbleGame(playerCount: Int, marbleCount: Int) -> Int {
    var playerScores = Array(repeating: 0, count: playerCount)
    var currentMarble = Marble(value: 0)

    currentMarble.nextMarble = currentMarble
    currentMarble.prevMarble = currentMarble

    for marbleValue in 1...marbleCount {
        let currentPlayer = marbleValue % playerCount

        if marbleValue % 23 == 0 {
            for _ in 1...7 { currentMarble = currentMarble.prevMarble }

            playerScores[currentPlayer] += marbleValue
            playerScores[currentPlayer] += currentMarble.value

            currentMarble.nextMarble.prevMarble = currentMarble.prevMarble
            currentMarble.prevMarble.nextMarble = currentMarble.nextMarble
            currentMarble = currentMarble.nextMarble

            continue
        }

        currentMarble = currentMarble.nextMarble

        let newMarble = Marble(value: marbleValue, prevMarble: currentMarble, nextMarble: currentMarble.nextMarble)
        newMarble.nextMarble.prevMarble = newMarble
        currentMarble.nextMarble = newMarble

        currentMarble = newMarble
    }

    // Prevent a memory leak
    // currentMarble.prevMarble.nextMarble = nil

    return playerScores.max()!
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

var winningElfScore = playMarbleGame(playerCount: players, marbleCount: marbles)

print("Puzzle 1 - The winning Elf's score is: \(winningElfScore)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

winningElfScore = playMarbleGame(playerCount: players, marbleCount: marbles * 100)

print("Puzzle 2 - The winning Elf's score with last marble 100 times larger is: \(winningElfScore)")
