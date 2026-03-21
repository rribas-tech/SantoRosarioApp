import SwiftUI

struct RosaryView: View {
    @State private var state = RosaryState()

    var body: some View {
        GeometryReader { proxy in
            let geometry = RosaryShape.layout(beads: state.beads, in: proxy.size)

            ZStack {
                Color(red: 0.04, green: 0.04, blue: 0.08)
                    .ignoresSafeArea()

                ChainView(segments: geometry.chainSegments)

                ForEach(state.beads) { bead in
                    let position = geometry.beadPositions[bead.id]
                    let selected = state.selectedBeadID == bead.id

                    if bead.kind == .crucifix {
                        CrucifixView(isSelected: selected) {
                            withAnimation { state.select(bead.id) }
                        }
                        .position(position)
                    } else {
                        BeadView(kind: bead.kind, isSelected: selected) {
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
