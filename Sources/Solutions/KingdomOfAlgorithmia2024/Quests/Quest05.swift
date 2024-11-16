import Foundation
import Tools

final class Quest05Solver: QuestSolver {
	let numberOfParts: Int = 3

	let expectedResults: [any Equatable] = [
		2252,
		21_202_068_741_084,
		4_747_374_010_031_000,
	]

	let questNumber: Int = 5

	private var inputPart1: InputPart1!
	private var inputPart2: InputPart2!
	private var inputPart3: InputPart3!

	private struct InputPart1 {
		let columns: [[Int]]
	}

	private struct InputPart2 {
		let columns: [[Int]]
	}

	private struct InputPart3 {
		let columns: [[Int]]
	}

	func solvePart(_ part: Int) -> any Equatable {
		switch part {
		case 1: solvePart1()
		case 2: solvePart2()
		case 3: solvePart3()
		default: fatalError()
		}
	}

	private func solveRound(columns: inout [[Int]], columnIndex: Int) {
		let nextColumnIndex = (columnIndex + 1) % columns.count

		let clapperNumber = columns[columnIndex].removeFirst()

		let position = clapperNumber % (columns[nextColumnIndex].count * 2)

		if position == 0 {
			columns[nextColumnIndex].insert(clapperNumber, at: 1)
		} else if position <= columns[nextColumnIndex].count {
			columns[nextColumnIndex].insert(clapperNumber, at: position - 1)
		} else {
			let remainingPosition = position - columns[nextColumnIndex].count

			columns[nextColumnIndex].insert(clapperNumber, at: columns[nextColumnIndex].count - 1 - remainingPosition)
		}
	}

	private func solvePart1() -> any Equatable {
		var columns = inputPart1.columns

		var currentColumnIndex = 0
		for round in 1 ... 10 {
			solveRound(columns: &columns, columnIndex: currentColumnIndex)

			currentColumnIndex = (currentColumnIndex + 1) % columns.count

			if round == 10 {
				var currentNumber = 0

				for column in columns {
					currentNumber = (currentNumber * 10) + column[0]
				}

				return currentNumber
			}
		}

		preconditionFailure()
	}

	private func solvePart2() -> any Equatable {
		var columns = inputPart2.columns

		var shoutedNumbers: [Int: Int] = [:]

		var currentColumnIndex = 0
		var round = 1
		while true {
			solveRound(columns: &columns, columnIndex: currentColumnIndex)

			currentColumnIndex = (currentColumnIndex + 1) % columns.count

			var currentNumberAsString = ""

			for column in columns {
				currentNumberAsString += String(column[0])
			}

			let currentNumber = Int(currentNumberAsString)!

			shoutedNumbers[currentNumber, default: 0] += 1

			if shoutedNumbers[currentNumber]! == 2024 {
				return round * currentNumber
			}

			round += 1
		}

		preconditionFailure()
	}

	private func solvePart3() -> any Equatable {
		var columns = inputPart3.columns

		var maxNumber = 0

		var currentColumnIndex = 0
		for _ in 1 ... 100 {
			solveRound(columns: &columns, columnIndex: currentColumnIndex)

			currentColumnIndex = (currentColumnIndex + 1) % columns.count

			var currentNumberAsString = ""

			for column in columns {
				currentNumberAsString += String(column[0])
			}

			let currentNumber = Int(currentNumberAsString)!

			maxNumber = max(maxNumber, currentNumber)
		}

		return maxNumber
	}

	func parseInput(forPart part: Int, rawString: String) {
		func parseColumns(rawString: String) -> [[Int]] {
			let rowsAsLines = rawString.allLines()

			var columns: [[Int]] = []

			for (rowIndex, rowAsLine) in rowsAsLines.enumerated() {
				for (index, number) in rowAsLine.components(separatedBy: " ").map({ Int($0)! }).enumerated() {
					if rowIndex == 0 {
						columns.append([])
					}

					columns[index].append(number)
				}
			}

			return columns
		}

		switch part {
		case 1:
			inputPart1 = .init(columns: parseColumns(rawString: rawString))
		case 2:
			inputPart2 = .init(columns: parseColumns(rawString: rawString))
		case 3:
			inputPart3 = .init(columns: parseColumns(rawString: rawString))
		default:
			break
		}
	}
}
