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

    static func makeRosary() -> [Bead] {
        var beads: [Bead] = []
        var id = 0

        func add(_ kind: BeadKind) {
            beads.append(Bead(id: id, kind: kind))
            id += 1
        }

        // Pendente (bottom to top): crucifixo, 1 grande, 3 pequenas, medalha
        add(.crucifix)  // 0
        add(.large)     // 1 - Pai Nosso
        add(.small)     // 2 - Ave Maria
        add(.small)     // 3 - Ave Maria
        add(.small)     // 4 - Ave Maria
        add(.medal)     // 5

        // Loop: 5 dezenas, cada uma precedida por 1 pedra grande (mistério)
        for _ in 1...5 {
            add(.large)
            for _ in 1...10 {
                add(.small)
            }
        }

        return beads
    }
}
