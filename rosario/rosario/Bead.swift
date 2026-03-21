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

        // Pendente (bottom to top): crucifixo, Pai Nosso, 3 Ave Marias, 1º Mistério, medalha
        add(.crucifix)  // 0
        add(.large)     // 1 - Pai Nosso
        add(.small)     // 2 - Ave Maria
        add(.small)     // 3 - Ave Maria
        add(.small)     // 4 - Ave Maria
        add(.large)     // 5 - 1º Mistério
        add(.medal)     // 6

        // Loop: 4 dezenas com mistério + 1 dezena final (volta à medalha)
        for decade in 1...5 {
            for _ in 1...10 {
                add(.small)
            }
            if decade < 5 {
                add(.large) // mistérios 2, 3, 4, 5
            }
        }

        return beads
    }
}
