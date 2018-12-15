import Foundation

let input = "765071"

func createRecipe(elf1: inout Int, elf2: inout Int, scoreboard: inout [Int]) {
    let elf1Recipe = scoreboard[elf1]
    let elf2Recipe = scoreboard[elf2]
    let newRecipe = elf1Recipe + elf2Recipe

    if newRecipe > 9 {
        scoreboard.append(1)
    }
    scoreboard.append(newRecipe % 10)

    let count = scoreboard.count
    elf1 = (elf1 + elf1Recipe + 1 + count) % count
    elf2 = (elf2 + elf2Recipe + 1 + count) % count
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

let recipes = Int(input)!
var scoreboard = [3, 7]
var elf1 = 0
var elf2 = 1

while scoreboard.count < recipes + 10 {
    createRecipe(elf1: &elf1, elf2: &elf2, scoreboard: &scoreboard)
}

var scores = ""
for score in scoreboard[recipes..<recipes + 10] {
    scores.append("\(score)")
}

print("Puzzle 1 - The scores of the ten recipes after the number of recipes is: \(scores)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

let digits = input.utf8.map { Int($0 - 48) }
scoreboard = [3, 7]
elf1 = 0
elf2 = 1
var recipeCount = 0

mainLoop: while true {
    createRecipe(elf1: &elf1, elf2: &elf2, scoreboard: &scoreboard)
    while recipeCount <= scoreboard.count - digits.count {
        if Array(scoreboard[recipeCount..<recipeCount + digits.count]) == digits {
            break mainLoop
        }
        recipeCount += 1
    }
}

print("Puzzle 2 - The number of recipes to the left to the score sequence is: \(recipeCount)")
