import SwiftUI

struct RosaryGeometry {
    let beadPositions: [CGPoint]
    let chainSegments: [(CGPoint, CGPoint)]
    let crucifixCenter: CGPoint
    let medalCenter: CGPoint
}

enum RosaryShape {
    static let pendantCount = 7

    static func layout(beads: [Bead], in size: CGSize) -> RosaryGeometry {
        let loopCount = beads.count - pendantCount
        let cx = Double(size.width / 2)
        let radius = Double(min(size.width * 0.42, size.height * 0.30))
        let cy = Double(size.height) * 0.38
        let medalY = cy + radius

        var positions = Array(repeating: CGPoint.zero, count: beads.count)
        positions[6] = CGPoint(x: cx, y: medalY)

        let smallGap: Double = 26
        let largeGap: Double = 36
        var py = medalY
        py += largeGap; positions[5] = CGPoint(x: cx, y: py)
        py += smallGap; positions[4] = CGPoint(x: cx, y: py)
        py += smallGap; positions[3] = CGPoint(x: cx, y: py)
        py += smallGap; positions[2] = CGPoint(x: cx, y: py)
        py += largeGap; positions[1] = CGPoint(x: cx, y: py)
        py += largeGap; positions[0] = CGPoint(x: cx, y: py)

        let mysteryWeight = 2.5
        let smallWeight = 1.0
        let fullWeight = 4.0 * mysteryWeight + 50.0 * smallWeight + 1.5
        let anglePerUnit = 2.0 * .pi / fullWeight
        var angle = .pi / 2 + 0.75 * anglePerUnit

        for i in 0..<loopCount {
            let weight = beads[pendantCount + i].kind == .large ? mysteryWeight : smallWeight
            angle += weight / 2.0 * anglePerUnit
            positions[pendantCount + i] = CGPoint(
                x: cx + radius * cos(angle),
                y: cy + radius * sin(angle)
            )
            angle += weight / 2.0 * anglePerUnit
        }

        var chains: [(CGPoint, CGPoint)] = []

        for i in stride(from: 6, through: 1, by: -1) {
            chains.append((positions[i], positions[i - 1]))
        }

        chains.append((positions[6], positions[pendantCount]))

        for i in pendantCount..<(beads.count - 1) {
            chains.append((positions[i], positions[i + 1]))
        }

        chains.append((positions[beads.count - 1], positions[6]))

        return RosaryGeometry(
            beadPositions: positions,
            chainSegments: chains,
            crucifixCenter: positions[0],
            medalCenter: positions[6]
        )
    }
}
