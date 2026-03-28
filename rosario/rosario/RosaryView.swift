import SwiftUI

struct RosaryView: View {
    @State private var state = RosaryState()
    @State private var path: [RosaryFocusContext] = []
    @State private var isSettingsPresented = false

    private let gold = Color(red: 1.0, green: 0.84, blue: 0.0)

    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { proxy in
                let geometry = RosaryShape.layout(beads: state.beads, in: proxy.size)

                ZStack {
                    LinearGradient(
                        colors: [
                            Color(red: 0.08, green: 0.05, blue: 0.11),
                            Color(red: 0.12, green: 0.07, blue: 0.04),
                            Color(red: 0.04, green: 0.04, blue: 0.08),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                        .ignoresSafeArea()

                    ChainView(segments: geometry.chainSegments)

                    ForEach(state.beads) { bead in
                        let position = geometry.beadPositions[bead.id]
                        let selected = state.selectedBeadID == bead.id

                        if bead.kind == .crucifix {
                            CrucifixView(isSelected: selected) {
                                openFocus(for: bead.id)
                            }
                            .position(position)
                        } else {
                            BeadView(kind: bead.kind, isSelected: selected) {
                                openFocus(for: bead.id)
                            }
                            .position(position)
                        }
                    }
                }
            }
            .navigationTitle("Santo Rosário")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Santo Rosário")
                        .font(.system(size: 25, weight: .bold, design: .serif))
                        .foregroundStyle(.white)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isSettingsPresented = true
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
            }
            .sheet(isPresented: $isSettingsPresented) {
                SettingsView()
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .safeAreaInset(edge: .bottom) {
                mysteryOfDayCard
                    .padding(.horizontal, 18)
                    .padding(.bottom, 12)
            }
            .navigationDestination(for: RosaryFocusContext.self) { context in
                MysteryFocusView(context: context)
            }
        }
    }

    private var mysteryOfDayCard: some View {
        VStack(spacing: 8) {
            Text("Mistério do Dia")
                .font(.caption.weight(.semibold))
                .tracking(1.1)
                .foregroundStyle(gold)

            Text(state.mysteryOfDayDescription)
                .font(.system(size: 19, weight: .semibold, design: .serif))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(red: 0.11, green: 0.09, blue: 0.12).opacity(0.94))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.22), radius: 16, y: 8)
    }

    private func openFocus(for beadID: Int) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.78)) {
            state.select(beadID)
        }

        path = [state.focusContext(for: beadID)]
    }
}

#Preview {
    RosaryView()
}
