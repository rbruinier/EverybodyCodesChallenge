import Foundation
import Tools

final class Quest01Solver: QuestSolver {
	let numberOfParts: Int = 3

	let expectedResults: [any Equatable] = [
		1437,
		5669,
		28073,
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
		inputPart1.enemies.reduce(into: 0) { result, enemy in
			result += enemy.potions
		}
	}

	private func solvePart2() -> any Equatable {
		inputPart2.pairs.reduce(into: 0) { result, pair in
			result += pair.potions
		}
	}

	private func solvePart3() -> any Equatable {
		inputPart3.trios.reduce(into: 0) { result, trio in
			result += trio.potions
		}
	}

	let questNumber: Int = 1

	enum Enemy: String {
		case ancientAnt = "A"
		case badassBeetle = "B"
		case creepyCockroach = "C"
		case diabolicalDragonfly = "D"

		var potions: Int {
			switch self {
			case .ancientAnt: 0
			case .badassBeetle: 1
			case .creepyCockroach: 3
			case .diabolicalDragonfly: 5
			}
		}
	}

	struct Pair {
		let a: Enemy?
		let b: Enemy?

		var actualEnemies: [Enemy] {
			[a, b].compactMap { $0 }
		}

		var potions: Int {
			let basePotions = actualEnemies.map(\.potions).reduce(0, +)

			return basePotions + ((actualEnemies.count - 1) * actualEnemies.count)
		}
	}

	struct Trio {
		let a: Enemy?
		let b: Enemy?
		let c: Enemy?

		var actualEnemies: [Enemy] {
			[a, b, c].compactMap { $0 }
		}

		var potions: Int {
			let basePotions = actualEnemies.map(\.potions).reduce(0, +)

			return basePotions + ((actualEnemies.count - 1) * actualEnemies.count)
		}
	}

	private var inputPart1: InputPart1!
	private var inputPart2: InputPart2!
	private var inputPart3: InputPart3!

	private struct InputPart1 {
		let enemies: [Enemy]
	}

	private struct InputPart2 {
		let pairs: [Pair]
	}

	private struct InputPart3 {
		let trios: [Trio]
	}

	func parseInput(forPart part: Int, rawString: String) {
		switch part {
		case 1:
			inputPart1 = .init(enemies: rawString.allLines().first!.map {
				Enemy(rawValue: String($0))!
			})
		case 2:
			let line = rawString.allLines().first!

			var pairs: [Pair] = []

			for index in stride(from: 0, to: line.count, by: 2) {
				let a = line[index]
				let b = line[index + 1]

				pairs.append(.init(a: Enemy(rawValue: String(a)), b: Enemy(rawValue: String(b))))
			}

			inputPart2 = .init(pairs: pairs)
		case 3:
			let line = rawString.allLines().first!

			var trios: [Trio] = []

			for index in stride(from: 0, to: line.count, by: 3) {
				let a = line[index]
				let b = line[index + 1]
				let c = line[index + 2]

				trios.append(.init(a: Enemy(rawValue: String(a)), b: Enemy(rawValue: String(b)), c: Enemy(rawValue: String(c))))
			}

			inputPart3 = .init(trios: trios)
		default:
			break
		}
	}
}
