import Darwin
import Foundation
import Tools

protocol QuestSolver {
	var numberOfParts: Int { get }

	var questNumber: Int { get }

	var expectedResults: [any Equatable] { get }

	func parseInput(forPart part: Int, rawString: String)

	func solvePart(_ part: Int) -> any Equatable
}

private func == (_ lhs: any Equatable, _ rhs: any Equatable) -> Bool {
	if let lhsAsString = lhs as? String, let rhsAsString = rhs as? String {
		lhsAsString == rhsAsString
	} else if let lhsAsInt = lhs as? Int, let rhsAsInt = rhs as? Int {
		lhsAsInt == rhsAsInt
	} else {
		fatalError()
	}
}

private func != (_ lhs: some Equatable, _ rhs: some Equatable) -> Bool {
	(lhs == rhs) == false
}

private struct Results {
	var partResults: [Bool] = []
}

private func solveQuest(_ solver: any QuestSolver) -> Results {
	print("Solving quest \(solver.questNumber):")

	var results: Results = .init()

	for part in 1 ... solver.numberOfParts {
		let startTime = mach_absolute_time()

		let result = solver.solvePart(part)
		let expectedResult = solver.expectedResults[part - 1]

		let formattedDuration = String(format: "%.6f", getSecondsFromMachTimer(duration: mach_absolute_time() - startTime))

		print(" -> part \(part): \(result). Solved in \(formattedDuration) seconds")

		results.partResults.append(result == expectedResult)

		if result != expectedResult {
			print(" -> ⛔️ part \(part) expected result is: \(expectedResult).")
		}
	}

	return results
}

func solveQuests(_ allQuests: [any QuestSolver], bundle: Bundle) {
	func getRawInputStringFor(quest: Int, part: Int, in bundle: Bundle) -> String {
		let fileURL = bundle.url(forResource: String(format: "Quest%02d.Part%02d", quest, part), withExtension: "txt", subdirectory: "Input")!

		return try! String(contentsOf: fileURL)
	}

	print("Parsing inputs")

	let quests: [any QuestSolver]

	quests = allQuests

	for quest in quests {
		for part in 1 ... quest.numberOfParts {
			quest.parseInput(forPart: part, rawString: getRawInputStringFor(quest: quest.questNumber, part: part, in: bundle))
		}
	}

	print("Start solving quests")

	let startTime = mach_absolute_time()

	var timesPerQuest: [Int: Double] = [:]
	var incorrectQuests: [Int] = []

	for quest in quests {
		let startTime = mach_absolute_time()

		let results = solveQuest(quest)

		timesPerQuest[quest.questNumber] = getSecondsFromMachTimer(duration: mach_absolute_time() - startTime)

		if results.partResults.contains(false) {
			incorrectQuests.append(quest.questNumber)
		}
	}

	let formattedDuration = String(format: "%.4f", getSecondsFromMachTimer(duration: mach_absolute_time() - startTime))

	print("⏱ Total running duration is \(formattedDuration) seconds")

	if incorrectQuests.isNotEmpty {
		print("⛔️ There are incorrect quests:")

		for quest in incorrectQuests {
			print(" -> Quest \(quest)")
		}
	}

	if timesPerQuest.count >= 3 {
		print("🐌 Slowest quests:")

		for (quest, duration) in timesPerQuest.sorted(by: { $0.value > $1.value }).prefix(upTo: 3) {
			print(String(format: " -> Quest \(quest) solved in %.4f seconds", duration))
		}
	}
}
