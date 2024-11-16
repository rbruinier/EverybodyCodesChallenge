import Foundation
import Tools

final class Quest03Solver: QuestSolver {
	let numberOfParts: Int = 3

	let expectedResults: [any Equatable] = [
		124,
		2668,
		10190,
	]

	let questNumber: Int = 3

	private var inputPart1: InputPart1!
	private var inputPart2: InputPart2!
	private var inputPart3: InputPart3!

	private enum Tile: String, CustomStringConvertible {
		case empty = "."
		case promising = "#"

		var description: String { rawValue }
	}

	private struct InputPart1 {
		let grid: Grid2D<Tile>
	}

	private struct InputPart2 {
		let grid: Grid2D<Tile>
	}

	private struct InputPart3 {
		let grid: Grid2D<Tile>
	}

	func solvePart(_ part: Int) -> any Equatable {
		switch part {
		case 1: solvePart1()
		case 2: solvePart2()
		case 3: solvePart3()
		default: fatalError()
		}
	}

	private func solveGrid(_ grid: Grid2D<Tile>, includeDiagonals: Bool) -> Int {
		let dimensions = grid.dimensions

		var depths: [[Int]] = [[]]

		var counter = 0
		for y in 0 ..< dimensions.height {
			depths.append([])

			for x in 0 ..< dimensions.width {
				depths[y].append(grid.tiles[y][x] == .promising ? 1 : 0)

				counter += grid.tiles[y][x] == .promising ? 1 : 0
			}
		}

		var currentLevel = 1
		while true {
			let oldCounter = counter

			var newDepths = depths

			for y in 1 ..< dimensions.height - 1 {
				for x in 1 ..< dimensions.width - 1 {
					if
						depths[y][x] == currentLevel,
						depths[y - 1][x] == currentLevel,
						depths[y + 1][x] == currentLevel,
						depths[y][x - 1] == currentLevel,
						depths[y][x + 1] == currentLevel,
						includeDiagonals ? depths[y - 1][x - 1] == currentLevel : true,
						includeDiagonals ? depths[y - 1][x + 1] == currentLevel : true,
						includeDiagonals ? depths[y + 1][x - 1] == currentLevel : true,
						includeDiagonals ? depths[y + 1][x + 1] == currentLevel : true
					{
						newDepths[y][x] = currentLevel + 1

						counter += 1
					}
				}
			}

			if counter == oldCounter {
				break
			}

			depths = newDepths

			currentLevel += 1
		}

		return counter
	}

	private func solvePart1() -> any Equatable {
		solveGrid(inputPart1.grid, includeDiagonals: false)
	}

	private func solvePart2() -> any Equatable {
		solveGrid(inputPart2.grid, includeDiagonals: false)
	}

	private func solvePart3() -> any Equatable {
		solveGrid(inputPart3.grid, includeDiagonals: true)
	}

	func parseInput(forPart part: Int, rawString: String) {
		switch part {
		case 1:
			inputPart1 = .init(grid: rawString.parseGrid2D())
		case 2:
			inputPart2 = .init(grid: rawString.parseGrid2D())
		case 3:
			inputPart3 = .init(grid: rawString.parseGrid2D())
		default:
			break
		}
	}
}
