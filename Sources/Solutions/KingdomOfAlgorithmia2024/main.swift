import Foundation

print("The Kingdom of Algorithmia (2024)")

let quests: [any QuestSolver] = [
//	Quest01Solver(),
//	Quest02Solver(),
//	Quest03Solver(),
//	Quest04Solver(),
//	Quest05Solver(),
//	Quest06Solver(),
	Quest07Solver(),
]

solveQuests(quests, bundle: .module)
