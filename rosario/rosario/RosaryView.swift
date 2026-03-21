import SwiftUI

struct RosaryView: View {
    @State private var state = RosaryState()

    var body: some View {
        GeometryReader { proxy in
            let geometry = RosaryShape.layout(beads: state.beads, in: proxy.size)

            ZStack {
                // Background
                Color(red: 0.04, green: 0.04, blue: 0.08)
                    .ignoresSafeArea()

                // Chain
                ChainView(segments: geometry.chainSegments)

                // Beads
                ForEach(state.beads) { bead in
                    let position = geometry.beadPositions[bead.id]
                    let isSelected = state.selectedBeadID == bead.id

                    switch bead.kind {
                    case .crucifix:
                        CrucifixView(isSelected: isSelected) {
                            withAnimation { state.select(bead.id) }
                        }
                        .position(position)

                    case .medal, .small, .large:
                        BeadView(kind: bead.kind, isSelected: isSelected) {
                            withAnimation { state.select(bead.id) }
                        }
                        .position(position)
                    }
                }
            }
        }
    }
}

#Preview {
    RosaryView()
}
