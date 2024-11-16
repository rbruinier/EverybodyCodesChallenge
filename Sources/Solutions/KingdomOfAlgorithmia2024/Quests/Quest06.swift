import Foundation
import Tools

final class Quest06Solver: QuestSolver {
	let numberOfParts: Int = 3

	let expectedResults: [any Equatable] = [
		"RRBSDGVPJHKG@",
		"RFBMNWSHLW@",
		"RPPLHWXLKSTB@",
	]

	let questNumber: Int = 6

	private var inputPart1: InputPart1!
	private var inputPart2: InputPart2!
	private var inputPart3: InputPart3!

	private struct InputPart1 {
		let nodes: [String: [String]]
	}

	private struct InputPart2 {
		let nodes: [String: [String]]
	}

	private struct InputPart3 {
		let nodes: [String: [String]]
	}

	func solvePart(_ part: Int) -> any Equatable {
		switch part {
		case 1: solvePart1()
		case 2: solvePart2()
		case 3: solvePart3()
		default: fatalError()
		}
	}

	private func solve(nodes: [String: [String]], useFirstLetter: Bool) -> String {
		var visitedPaths: [Int: [String]] = [:]

		for (label, children) in nodes.sorted(by: { $0.key < $1.key }) {
			guard children.contains("@") else {
				continue
			}

			var parentLabel = label
			var path = "\(useFirstLetter ? label[0] : label)@"
			var pathLength = 0

			while let nextParent = nodes.first(where: { $0.value.contains(parentLabel) })?.key {
				path = (useFirstLetter ? nextParent[0] : nextParent) + path
				parentLabel = nextParent
				pathLength += 1
			}

			visitedPaths[pathLength, default: []].append(path)
		}

		return visitedPaths.first(where: { $0.value.count == 1 })!.value[0]
	}

	private func solvePart1() -> any Equatable {
		solve(nodes: inputPart1.nodes, useFirstLetter: false)
	}

	private func solvePart2() -> any Equatable {
		solve(nodes: inputPart2.nodes, useFirstLetter: true)
	}

	private func solvePart3() -> any Equatable {
		var nodes = inputPart3.nodes

		nodes.removeValue(forKey: "ANT")
		nodes.removeValue(forKey: "BUG")

		return solve(nodes: nodes, useFirstLetter: true)
	}

	func parseInput(forPart part: Int, rawString: String) {
		var nodes: [String: [String]] = [:]

		for line in rawString.allLines() {
			let split = line.split(separator: ":")

			let label = String(split[0])
			let children = String(split[1]).components(separatedBy: ",")

			nodes[label] = children
		}

		switch part {
		case 1:
			inputPart1 = .init(nodes: nodes)
		case 2:
			inputPart2 = .init(nodes: nodes)
		case 3:
			inputPart3 = .init(nodes: nodes)
		default:
			break
		}
	}
}
