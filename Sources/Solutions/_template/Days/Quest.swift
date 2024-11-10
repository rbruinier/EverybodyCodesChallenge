import Foundation
import Tools

final class QuestSolver: QuestSolver {
	let numberOfParts: Int = 3

	let expectedResults: [any Equatable] = [
		0,
		0,
		0
	]

	func solvePart(_ part: Int) -> any Equatable {
		switch part {
		case 1: solvePart1()
		case 2: solvePart2()
		case 3: solvePart3()
		default: fatalError()
		}
	}

	private func solvePart1() -> any Equatable {
		0
	}

	private func solvePart2() -> any Equatable {
		0
	}

	private func solvePart3() -> any Equatable {
		0
	}

	let questNumber: Int = 1

	private var inputPart1: InputPart1!
	private var inputPart2: InputPart2!
	private var inputPart3: InputPart3!

	private struct InputPart1 {
	}

	private struct InputPart2 {
	}
	
	private struct InputPart3 {
	}

	func parseInput(forPart part: Int, rawString: String) {
		switch part {
		case 1:
			inputPart1 = .init()
		case 2:
			inputPart2 = .init()
		case 3:
			inputPart3 = .init()
		default:
			break
		}
	}
}
