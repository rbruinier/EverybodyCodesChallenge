import Foundation
import Tools

final class Quest07Solver: QuestSolver {
	let numberOfParts: Int = 3

	let expectedResults: [any Equatable] = [
		"BCGDKIHAE",
		"FAIKHBEJG",
		5839,
	]

	let questNumber: Int = 7

	private enum Segment: String {
		case start = "S"
		case increase = "+"
		case decrease = "-"
		case maintain = "="
	}

	private struct Player {
		var name: String
		var segments: [Segment]
	}

	private var inputPart1: InputPart1!
	private var inputPart2: InputPart2!
	private var inputPart3: InputPart3!

	private struct InputPart1 {
		let players: [Player]
	}

	private struct InputPart2 {
		let players: [Player]
	}

	private struct InputPart3 {
		let players: [Player]
	}

	func solvePart(_ part: Int) -> any Equatable {
		switch part {
		case 1: solvePart1()
		case 2: solvePart2()
		case 3: solvePart3()
		default: fatalError()
		}
	}

	private func segmentPermutations(allSegments: inout [[Segment]], segments: [Segment], remainingIncrements: Int, remainingDecrements: Int, remainingMaintainments: Int) {
		if segments.count == 11 {
			allSegments.append(segments)

			return
		}

		if remainingIncrements > 0 {
			segmentPermutations(allSegments: &allSegments, segments: segments + [.increase], remainingIncrements: remainingIncrements - 1, remainingDecrements: remainingDecrements, remainingMaintainments: remainingMaintainments)
		}

		if remainingDecrements > 0 {
			segmentPermutations(allSegments: &allSegments, segments: segments + [.decrease], remainingIncrements: remainingIncrements, remainingDecrements: remainingDecrements - 1, remainingMaintainments: remainingMaintainments)
		}

		if remainingMaintainments > 0 {
			segmentPermutations(allSegments: &allSegments, segments: segments + [.maintain], remainingIncrements: remainingIncrements, remainingDecrements: remainingDecrements, remainingMaintainments: remainingMaintainments - 1)
		}
	}

	private func essenceFor(segments: [Segment], track: [Segment], loops: Int) -> Int {
		var power = 10
		var essence = 0

		var segmentIndex = 0

		for _ in 0 ..< loops {
			for trackSegment in track {
				switch trackSegment {
				case .start,
				     .maintain:
					switch segments[segmentIndex % segments.count] {
					case .start: break
					case .increase: power += 1
					case .decrease: power -= 1
					case .maintain: break
					}
				case .increase: power += 1
				case .decrease: power -= 1
				}

				essence += power

				segmentIndex += 1
			}
		}

		return essence
	}

	private func solvePart1() -> any Equatable {
		let players = inputPart1.players

		var playerEssence: [String: Int] = [:]

		for player in players {
			var power = 10
			var essence = 0

			for segmentIndex in 0 ..< 10 {
				switch player.segments[segmentIndex % player.segments.count] {
				case .increase: power += 1
				case .decrease: power -= 1
				case .maintain: break
				case .start: preconditionFailure()
				}

				essence += power
			}

			playerEssence[player.name] = essence
		}

		return playerEssence.sorted(by: { $0.value > $1.value }).map(\.key).joined()
	}

	private func solvePart2() -> any Equatable {
		let rawTrack = """
		S-=++=-==++=++=-=+=-=+=+=--=-=++=-==++=-+=-=+=-=+=+=++=-+==++=++=-=-=--
		-                                                                     -
		=                                                                     =
		+                                                                     +
		=                                                                     +
		+                                                                     =
		=                                                                     =
		-                                                                     -
		--==++++==+=+++-=+=-=+=-+-=+-=+-=+=-=+=--=+++=++=+++==++==--=+=++==+++-
		"""

		let track = parseTrack(rawTrack)

		let players = inputPart2.players

		var playerEssence: [String: Int] = [:]

		for player in players {
			playerEssence[player.name] = essenceFor(segments: player.segments, track: track, loops: 10)
		}

		return playerEssence.sorted(by: { $0.value > $1.value }).map(\.key).joined()
	}

	private func solvePart3() -> any Equatable {
		let rawTrack = """
		S+= +=-== +=++=     =+=+=--=    =-= ++=     +=-  =+=++=-+==+ =++=-=-=--
		- + +   + =   =     =      =   == = - -     - =  =         =-=        -
		= + + +-- =-= ==-==-= --++ +  == == = +     - =  =    ==++=    =++=-=++
		+ + + =     +         =  + + == == ++ =     = =  ==   =   = =++=
		= = + + +== +==     =++ == =+=  =  +  +==-=++ =   =++ --= + =
		+ ==- = + =   = =+= =   =       ++--          +     =   = = =--= ==++==
		=     ==- ==+-- = = = ++= +=--      ==+ ==--= +--+=-= ==- ==   =+=    =
		-               = = = =   +  +  ==+ = = +   =        ++    =          -
		-               = + + =   +  -  = + = = +   =        +     =          -
		--==++++==+=+++-= =-= =-+-=  =+-= =-= =--   +=++=+++==     -=+=++==+++-
		"""

		let track = parseTrack(rawTrack)

		let opponentSegments = inputPart3.players.first!.segments

		// no need to do all 2024 loops:
		// 11 segments, 340 path elements. take least common multiple and divide by track length to find number of loops when cycle repeats (11)
		let numberOfLoopsInRepeatingCycle = Math.leastCommonMultiple(for: [track.count, opponentSegments.count]) / track.count

		let opponentEssence = essenceFor(segments: opponentSegments, track: track, loops: numberOfLoopsInRepeatingCycle)

		var permutations: [[Segment]] = []

		segmentPermutations(allSegments: &permutations, segments: [], remainingIncrements: 5, remainingDecrements: 3, remainingMaintainments: 3)

		var winningPermutations: Set<[Segment]> = []

		for permutation in permutations {
			let essence = essenceFor(segments: permutation, track: track, loops: numberOfLoopsInRepeatingCycle)

			if essence > opponentEssence {
				winningPermutations.insert(permutation)
			}
		}

		return winningPermutations.count
	}

	private func parseTrack(_ rawString: String) -> [Segment] {
		var position: Point2D = .zero
		var direction: Direction = .east

		let lines = rawString.allLines()

		var track: [Segment] = []

		var visitedPoints: Set<Point2D> = []

		while track.last != .start {
			let previousPosition = position

			if visitedPoints.contains(position.moved(to: direction)) {
				direction = direction.turned(degrees: .ninety)

				continue
			}

			position = position.moved(to: direction)

			guard
				let line = lines[safe: position.y],
				let character = line.map({ String($0) })[safe: position.x],
				character != " "
			else {
				direction = direction.turned(degrees: .ninety)

				position = previousPosition

				continue
			}

			track.append(Segment(rawValue: character)!)

			visitedPoints.insert(position)
		}

		return track
	}

	func parseInput(forPart part: Int, rawString: String) {
		var players: [Player] = []

		for line in rawString.allLines() {
			let split = line.split(separator: ":")

			let name = String(split[0])
			let segments = String(split[1]).components(separatedBy: ",").map { Segment(rawValue: $0)! }

			players.append(Player(name: name, segments: segments))
		}

		switch part {
		case 1:
			inputPart1 = .init(players: players)
		case 2:
			inputPart2 = .init(players: players)
		case 3:
			inputPart3 = .init(players: players)
		default:
			break
		}
	}
}
