import SwiftUI

struct RosaryGeometry {
    let beadPositions: [CGPoint]
    let chainSegments: [(CGPoint, CGPoint)]
    let crucifixCenter: CGPoint
    let medalCenter: CGPoint
}

enum RosaryShape {
    static func layout(beads: [Bead], in size: CGSize) -> RosaryGeometry {
        let loopBeadCount = beads.count - 6 // 55 beads in the loop

        // Ellipse parameters — centered horizontally, upper portion of screen
        let centerX = size.width / 2
        let ellipseRx = min(size.width * 0.38, 160.0)
        let ellipseRy = min(size.height * 0.28, 200.0)
        let ellipseCenterY = size.height * 0.38

        // Medal at bottom of ellipse
        let medalPoint = CGPoint(x: centerX, y: ellipseCenterY + ellipseRy)

        // Pendant: medal → 3 small → 1 large → crucifix (going downward)
        let pendantSpacing: CGFloat = 28
        let pendantTop = medalPoint.y + pendantSpacing

        // pendant order in beads array: [crucifix(0), large(1), small(2), small(3), small(4), medal(5)]
        // visual order top-to-bottom: medal(5), small(4), small(3), small(2), large(1), crucifix(0)
        var positions = Array(repeating: CGPoint.zero, count: beads.count)

        // Medal position (id=5)
        positions[5] = medalPoint

        // Pendant beads going down from medal
        let pendantOrder = [4, 3, 2, 1, 0] // small, small, small, large, crucifix
        for (i, beadID) in pendantOrder.enumerated() {
            positions[beadID] = CGPoint(
                x: centerX,
                y: pendantTop + CGFloat(i) * pendantSpacing
            )
        }

        let crucifixCenter = positions[0]

        // Loop beads (id 6..60) distributed along ellipse
        // Start from just right of bottom (medal), go clockwise
        // Angle 0 = right, π/2 = bottom, π = left, 3π/2 = top
        // Medal is at π/2 (bottom). We start just after and end just before.
        let startAngle = Double.pi / 2
        let totalAngle = 2.0 * Double.pi
        let step = totalAngle / Double(loopBeadCount + 1) // +1 for gap at medal

        for i in 0..<loopBeadCount {
            let beadID = 6 + i
            // Go clockwise: subtract angle (SwiftUI y-axis is inverted)
            let angle = startAngle - Double(i + 1) * step
            let x = centerX + ellipseRx * cos(angle)
            let y = ellipseCenterY - ellipseRy * sin(angle)
            positions[beadID] = CGPoint(x: x, y: y)
        }

        // Chain segments
        var chains: [(CGPoint, CGPoint)] = []

        // Pendant chain: medal → small4 → small3 → small2 → large1 → crucifix
        let pendantChainOrder = [5, 4, 3, 2, 1, 0]
        for i in 0..<(pendantChainOrder.count - 1) {
            chains.append((positions[pendantChainOrder[i]], positions[pendantChainOrder[i + 1]]))
        }

        // Medal to first loop bead
        chains.append((positions[5], positions[6]))

        // Loop chain: consecutive beads
        for i in 6..<(beads.count - 1) {
            chains.append((positions[i], positions[i + 1]))
        }

        // Last loop bead back to medal
        chains.append((positions[beads.count - 1], positions[5]))

        return RosaryGeometry(
            beadPositions: positions,
            chainSegments: chains,
            crucifixCenter: crucifixCenter,
            medalCenter: medalPoint
        )
    }
}
