import Foundation
import Tools

final class Quest04Solver: QuestSolver {
	let numberOfParts: Int = 3

	let expectedResults: [any Equatable] = [
		84,
		919_880,
		129_441_494,
	]

	let questNumber: Int = 4

	private var inputPart1: InputPart1!
	private var inputPart2: InputPart2!
	private var inputPart3: InputPart3!

	private struct InputPart1 {
		let nails: [Int]
	}

	private struct InputPart2 {
		let nails: [Int]
	}

	private struct InputPart3 {
		let nails: [Int]
	}

	func solvePart(_ part: Int) -> any Equatable {
		switch part {
		case 1: solvePart1()
		case 2: solvePart2()
		case 3: solvePart3()
		default: fatalError()
		}
	}

	private func solvePart1() -> any Equatable {
		let nails = inputPart1.nails

		let lowest = nails.min()!

		return nails.reduce(0) { $0 + ($1 - lowest) }
	}

	private func solvePart2() -> any Equatable {
		let nails = inputPart2.nails

		let lowest = nails.min()!

		return nails.reduce(0) { $0 + ($1 - lowest) }
	}

	private func solvePart3() -> any Equatable {
		let nails = inputPart3.nails

		let median = nails.sorted()[nails.count / 2]

		return nails.reduce(0) { $0 + abs($1 - median) }
	}

	func parseInput(forPart part: Int, rawString: String) {
		switch part {
		case 1:
			inputPart1 = .init(nails: rawString.allLines().map { Int($0)! })
		case 2:
			inputPart2 = .init(nails: rawString.allLines().map { Int($0)! })
		case 3:
			inputPart3 = .init(nails: rawString.allLines().map { Int($0)! })
		default:
			break
		}
	}
}
