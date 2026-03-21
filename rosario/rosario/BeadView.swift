import SwiftUI

struct BeadView: View {
    let kind: BeadKind
    let isSelected: Bool
    let onTap: () -> Void

    private var size: CGFloat {
        switch kind {
        case .small: 14
        case .large: 20
        case .medal: 22
        case .crucifix: 0 // handled by CrucifixView
        }
    }

    var body: some View {
        if kind == .medal {
            medalBody
        } else {
            beadBody
        }
    }

    private var beadBody: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Color(red: 0.72, green: 0.16, blue: 0.10),
                        Color(red: 0.50, green: 0.09, blue: 0.06),
                        Color(red: 0.30, green: 0.04, blue: 0.02),
                    ],
                    center: .init(x: 0.35, y: 0.30),
                    startRadius: 0,
                    endRadius: size * 0.6
                )
            )
            .overlay {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white.opacity(0.45), .clear],
                            center: .init(x: 0.30, y: 0.25),
                            startRadius: 0,
                            endRadius: size * 0.35
                        )
                    )
            }
            .frame(width: size, height: size)
            .shadow(color: .black.opacity(0.6), radius: 3, y: 2)
            .shadow(
                color: Color(red: 1, green: 0.84, blue: 0).opacity(isSelected ? 0.9 : 0),
                radius: isSelected ? 12 : 0
            )
            .scaleEffect(isSelected ? 1.3 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            .onTapGesture(perform: onTap)
    }

    private var medalBody: some View {
        Ellipse()
            .fill(
                RadialGradient(
                    colors: [
                        Color(red: 1.0, green: 0.88, blue: 0.40),
                        Color(red: 0.85, green: 0.65, blue: 0.13),
                        Color(red: 0.60, green: 0.45, blue: 0.08),
                    ],
                    center: .init(x: 0.4, y: 0.35),
                    startRadius: 0,
                    endRadius: size * 0.6
                )
            )
            .overlay {
                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [.white.opacity(0.5), .clear],
                            center: .init(x: 0.30, y: 0.25),
                            startRadius: 0,
                            endRadius: size * 0.3
                        )
                    )
            }
            .overlay {
                Ellipse()
                    .stroke(Color(red: 0.70, green: 0.50, blue: 0.10), lineWidth: 1.2)
            }
            .frame(width: size, height: size * 1.25)
            .shadow(color: .black.opacity(0.5), radius: 3, y: 2)
            .shadow(
                color: Color(red: 1, green: 0.84, blue: 0).opacity(isSelected ? 0.9 : 0),
                radius: isSelected ? 12 : 0
            )
            .scaleEffect(isSelected ? 1.2 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            .onTapGesture(perform: onTap)
    }
}
