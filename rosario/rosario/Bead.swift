import Foundation

enum BeadKind {
    case small
    case large
    case crucifix
    case medal
}

struct Bead: Identifiable {
    let id: Int
    let kind: BeadKind

    static let rosary = makeRosary()

    static func makeRosary() -> [Bead] {
        var beads: [Bead] = []
        var id = 0

        func add(_ kind: BeadKind) {
            beads.append(Bead(id: id, kind: kind))
            id += 1
        }

        add(.crucifix)
        add(.large)
        add(.small)
        add(.small)
        add(.small)
        add(.large)
        add(.medal)

        for decade in 1...5 {
            for _ in 1...10 { add(.small) }
            if decade < 5 { add(.large) }
        }

        return beads
    }
}
