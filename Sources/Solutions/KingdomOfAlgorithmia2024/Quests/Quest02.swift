import Foundation
import Tools

extension String {
	func occurences(of search: String) -> Int {
		guard !search.isEmpty else {
			return 0
		}

		let shrunk = replacingOccurrences(of: search, with: "")

		return (count - shrunk.count) / search.count
	}
}

final class Quest02Solver: QuestSolver {
	let numberOfParts: Int = 3

	let expectedResults: [any Equatable] = [
		34,
		5165,
		12076,
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
		var result = 0

		for word in inputPart1.words {
			result += inputPart1.line.occurences(of: word)
		}

		return result
	}

	private func solvePart2() -> any Equatable {
		var result = 0

		var words = inputPart2.words

		words.append(contentsOf: words.map { String($0.reversed()) })

		for line in inputPart2.lines {
			var symbolIndices: Set<Int> = []

			for word in words {
				var currentIndex = line.startIndex

				while let range = line[currentIndex ..< line.endIndex].range(of: word) {
					currentIndex = line.index(after: range.lowerBound)

					let lowerBound = line.distance(from: line.startIndex, to: range.lowerBound)
					let upperBound = line.distance(from: line.startIndex, to: range.upperBound)

					for index in lowerBound ..< upperBound {
						symbolIndices.insert(index)
					}
				}
			}

			result += symbolIndices.count
		}

		return result
	}

	private func solvePart3() -> any Equatable {
		var words = inputPart3.words

		words.append(contentsOf: words.map { String($0.reversed()) })

		let asciiWords: [[UInt8]] = words.map { $0.map(\.asciiValue!) }

		var scales: [Point2D: UInt8] = [:]

		for (y, line) in inputPart3.lines.enumerated() {
			for (x, character) in line.enumerated() {
				scales[.init(x: x, y: y)] = character.asciiValue
			}
		}

		let maxX = scales.keys.map(\.x).max()!
		let maxY = scales.keys.map(\.y).max()!

		var symbolPoints: Set<Point2D> = []

		// horizontal - wraps
		for y in 0 ... maxY {
			for word in asciiWords {
				scanLoop: for currentIndex in 0 ... maxX {
					for i in 0 ..< word.count {
						if word[i] != scales[.init(x: (currentIndex + i) % (maxX + 1), y: y)] {
							continue scanLoop
						}
					}

					for i in 0 ..< word.count {
						symbolPoints.insert(.init(x: (currentIndex + i) % (maxX + 1), y: y))
					}
				}
			}
		}

		// vertical - does not wrap
		for x in 0 ... maxX {
			for word in asciiWords {
				scanLoop: for currentIndex in 0 ..< maxX - word.count {
					for i in 0 ..< word.count {
						if word[i] != scales[.init(x: x, y: currentIndex + i)] {
							continue scanLoop
						}
					}

					for i in 0 ..< word.count {
						symbolPoints.insert(.init(x: x, y: currentIndex + i))
					}
				}
			}
		}

		return symbolPoints.count
	}

	let questNumber: Int = 2

	private var inputPart1: InputPart1!
	private var inputPart2: InputPart2!
	private var inputPart3: InputPart3!

	private struct InputPart1 {
		let words: [String]
		let line: String
	}

	private struct InputPart2 {
		let words: [String]
		let lines: [String]
	}

	private struct InputPart3 {
		let words: [String]
		let lines: [String]
	}

	func parseInput(forPart part: Int, rawString: String) {
		let lines = rawString.allLines()

		switch part {
		case 1:
			let words = lines[0].replacingOccurrences(of: "WORDS:", with: "").components(separatedBy: ",")
			let line = lines[1]

			inputPart1 = .init(words: words, line: line)
		case 2:
			let words = lines[0].replacingOccurrences(of: "WORDS:", with: "").components(separatedBy: ",")
			let lines = Array(lines[1 ..< lines.endIndex])

			inputPart2 = .init(words: words, lines: lines)
		case 3:
			let words = lines[0].replacingOccurrences(of: "WORDS:", with: "").components(separatedBy: ",")
			let lines = Array(lines[1 ..< lines.endIndex])

			inputPart3 = .init(words: words, lines: lines)
		default:
			break
		}
	}
}
