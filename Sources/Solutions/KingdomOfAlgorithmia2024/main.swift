import Foundation

print("The Kingdom of Algorithmia (2024)")

let quests: [any QuestSolver] = [
	Quest01Solver(),
]

solveQuests(quests, bundle: .module)
