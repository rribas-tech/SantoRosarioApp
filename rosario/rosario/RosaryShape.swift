import SwiftUI

struct RosaryGeometry {
    let beadPositions: [CGPoint]
    let chainSegments: [(CGPoint, CGPoint)]
    let crucifixCenter: CGPoint
    let medalCenter: CGPoint
}

enum RosaryShape {
    // Pendant has 7 elements: crucifix(0), large(1), small(2,3,4), large/1st mystery(5), medal(6)
    static let pendantCount = 7

    static func layout(beads: [Bead], in size: CGSize) -> RosaryGeometry {
        let loopCount = beads.count - Self.pendantCount

        let cx = Double(size.width / 2)
        let radius = Double(min(size.width * 0.42, size.height * 0.30))
        let cy = Double(size.height) * 0.38

        var positions = Array(repeating: CGPoint.zero, count: beads.count)

        // Medal at bottom of circle
        let medalY = cy + radius
        positions[6] = CGPoint(x: cx, y: medalY)

        // Pendant top-to-bottom: medal(6) → 1st mystery(5) → small(4,3,2) → large/Pai Nosso(1) → crucifix(0)
        let smallGap: Double = 26
        let largeGap: Double = 36
        var py = medalY
        py += largeGap;  positions[5] = CGPoint(x: cx, y: py) // 1st mystery
        py += smallGap;  positions[4] = CGPoint(x: cx, y: py) // Ave Maria
        py += smallGap;  positions[3] = CGPoint(x: cx, y: py) // Ave Maria
        py += smallGap;  positions[2] = CGPoint(x: cx, y: py) // Ave Maria
        py += largeGap;  positions[1] = CGPoint(x: cx, y: py) // Pai Nosso
        py += largeGap;  positions[0] = CGPoint(x: cx, y: py) // Crucifix
        let crucifixCenter = positions[0]

        // Loop: 54 beads (10s, M, 10s, M, 10s, M, 10s, M, 10s)
        // Mystery beads get extra angular space
        let mysteryWeight = 2.5
        let smallWeight = 1.0
        let totalWeight = 4.0 * mysteryWeight + 50.0 * smallWeight
        let gapWeight = 1.5
        let fullWeight = totalWeight + gapWeight

        let anglePerUnit = 2.0 * Double.pi / fullWeight
        var angle = Double.pi / 2 + gapWeight / 2.0 * anglePerUnit

        for i in 0..<loopCount {
            let bead = beads[Self.pendantCount + i]
            let weight = bead.kind == .large ? mysteryWeight : smallWeight
            angle += weight / 2.0 * anglePerUnit

            positions[Self.pendantCount + i] = CGPoint(
                x: cx + radius * cos(angle),
                y: cy + radius * sin(angle)
            )

            angle += weight / 2.0 * anglePerUnit
        }

        // Chain segments
        var chains: [(CGPoint, CGPoint)] = []

        // Pendant chain: medal(6) → mystery(5) → small(4) → small(3) → small(2) → large(1) → crucifix(0)
        let pendantOrder = [6, 5, 4, 3, 2, 1, 0]
        for i in 0..<(pendantOrder.count - 1) {
            chains.append((positions[pendantOrder[i]], positions[pendantOrder[i + 1]]))
        }

        // Medal to first loop bead
        let firstLoop = Self.pendantCount
        chains.append((positions[6], positions[firstLoop]))

        // Loop consecutive
        for i in firstLoop..<(beads.count - 1) {
            chains.append((positions[i], positions[i + 1]))
        }

        // Last to medal
        chains.append((positions[beads.count - 1], positions[6]))

        return RosaryGeometry(
            beadPositions: positions,
            chainSegments: chains,
            crucifixCenter: crucifixCenter,
            medalCenter: positions[6]
        )
    }
}
