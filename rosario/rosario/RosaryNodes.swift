import SpriteKit

enum RosaryNodes {

    static func chain(segments: [(CGPoint, CGPoint)]) -> SKShapeNode {
        let path = CGMutablePath()
        for (start, end) in segments {
            path.move(to: start)
            path.addLine(to: end)
        }
        let node = SKShapeNode(path: path)
        node.strokeColor = UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 1)
        node.lineWidth = 2.0
        node.lineCap = .round
        node.isUserInteractionEnabled = false
        node.zPosition = 0
        return node
    }

    static func bead(radius: CGFloat) -> SKShapeNode {
        let node = SKShapeNode(circleOfRadius: radius)
        node.fillColor = UIColor(red: 0.50, green: 0.09, blue: 0.06, alpha: 1)
        node.strokeColor = UIColor(red: 0.30, green: 0.04, blue: 0.02, alpha: 1)
        node.lineWidth = 1.0
        node.zPosition = 1

        let highlight = SKShapeNode(circleOfRadius: radius * 0.45)
        highlight.fillColor = UIColor(white: 1.0, alpha: 0.25)
        highlight.strokeColor = .clear
        highlight.position = CGPoint(x: -radius * 0.2, y: radius * 0.2)
        highlight.zPosition = 0.1
        node.addChild(highlight)

        return node
    }

    static func medal() -> SKShapeNode {
        let w: CGFloat = 24
        let h: CGFloat = 30
        let path = CGPath(ellipseIn: CGRect(x: -w / 2, y: -h / 2, width: w, height: h), transform: nil)
        let node = SKShapeNode(path: path)
        node.fillColor = UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 1)
        node.strokeColor = UIColor(red: 0.70, green: 0.50, blue: 0.10, alpha: 1)
        node.lineWidth = 1.2
        node.zPosition = 1

        let highlightPath = CGPath(ellipseIn: CGRect(x: -w * 0.3, y: 0, width: w * 0.5, height: h * 0.35), transform: nil)
        let highlight = SKShapeNode(path: highlightPath)
        highlight.fillColor = UIColor(white: 1.0, alpha: 0.3)
        highlight.strokeColor = .clear
        highlight.zPosition = 0.1
        node.addChild(highlight)

        return node
    }

    static func crucifix() -> SKNode {
        let container = SKNode()
        container.zPosition = 1

        let gold = UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 1)
        let stroke = UIColor(red: 0.65, green: 0.50, blue: 0.10, alpha: 1)

        let vertical = SKShapeNode(rectOf: CGSize(width: 10, height: 40), cornerRadius: 3)
        vertical.fillColor = gold
        vertical.strokeColor = stroke
        vertical.lineWidth = 0.5
        container.addChild(vertical)

        let horizontal = SKShapeNode(rectOf: CGSize(width: 26, height: 8), cornerRadius: 3)
        horizontal.fillColor = gold
        horizontal.strokeColor = stroke
        horizontal.lineWidth = 0.5
        horizontal.position = CGPoint(x: 0, y: 8)
        container.addChild(horizontal)

        return container
    }

    static func selectionGlow() -> SKShapeNode {
        let gold = UIColor(red: 1, green: 0.84, blue: 0, alpha: 1)
        let glow = SKShapeNode(circleOfRadius: 18)
        glow.fillColor = gold.withAlphaComponent(0.15)
        glow.strokeColor = gold.withAlphaComponent(0.4)
        glow.glowWidth = 6
        glow.name = "glow"
        glow.zPosition = -0.1
        return glow
    }
}
