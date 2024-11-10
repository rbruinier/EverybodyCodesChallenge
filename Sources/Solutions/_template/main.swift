import Foundation

print("TODO")

let quests: [any QuestSolver] = [
	Quest01Solver(),
]

solveQuests(quests, bundle: .module)
