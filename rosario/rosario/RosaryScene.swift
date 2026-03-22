import SpriteKit

final class RosaryScene: SKScene {
    let state: RosaryState
    private var beadNodes: [Int: SKNode] = [:]
    private var previousSelectedID: Int?

    init(state: RosaryState, size: CGSize) {
        self.state = state
        super.init(size: size)
        scaleMode = .resizeFill
        backgroundColor = UIColor(red: 0.04, green: 0.04, blue: 0.08, alpha: 1)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func didMove(to view: SKView) {
        buildScene()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        guard !children.isEmpty else { return }
        removeAllChildren()
        beadNodes.removeAll()
        previousSelectedID = nil
        buildScene()
    }

    private func buildScene() {
        let geometry = RosaryShape.layout(beads: state.beads, in: size)

        addChild(RosaryNodes.chain(segments: geometry.chainSegments))

        for bead in state.beads {
            let node: SKNode = switch bead.kind {
            case .crucifix: RosaryNodes.crucifix()
            case .medal:    RosaryNodes.medal()
            case .small:    RosaryNodes.bead(radius: 7)
            case .large:    RosaryNodes.bead(radius: 11)
            }

            node.position = geometry.beadPositions[bead.id]
            node.name = "bead-\(bead.id)"
            addChild(node)
            beadNodes[bead.id] = node

            if state.selectedBeadID == bead.id {
                applySelection(true, to: node, animated: false)
                previousSelectedID = bead.id
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let hit = nodes(at: location)

        let tapped = hit.first { $0.name?.hasPrefix("bead-") == true }
            ?? hit.first { $0.parent?.name?.hasPrefix("bead-") == true }?.parent

        guard let tapped, let name = tapped.name,
              let idStr = name.split(separator: "-").last,
              let id = Int(idStr) else { return }

        state.select(id)
        updateSelection(animated: true)
    }

    private func applySelection(_ selected: Bool, to node: SKNode, animated: Bool) {
        node.removeAllActions()
        node.childNode(withName: "glow")?.removeFromParent()

        let scale: CGFloat = selected ? 1.3 : 1.0
        if animated {
            node.run(.scale(to: scale, duration: 0.2))
        } else {
            node.setScale(scale)
        }

        if selected {
            node.addChild(RosaryNodes.selectionGlow())
        }
    }

    private func updateSelection(animated: Bool) {
        if let oldID = previousSelectedID, let oldNode = beadNodes[oldID] {
            applySelection(false, to: oldNode, animated: animated)
        }
        if let newID = state.selectedBeadID, let newNode = beadNodes[newID] {
            applySelection(true, to: newNode, animated: animated)
        }
        previousSelectedID = state.selectedBeadID
    }
}
