import SwiftUI

struct CrucifixView: View {
    let isSelected: Bool
    var sizeScale: CGFloat = 1.0
    var minimumHitWidth: CGFloat? = nil
    var minimumHitHeight: CGFloat? = nil
    var selectionScale: CGFloat = 1.2
    let onTap: () -> Void

    private static let gradient = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.88, blue: 0.40),
            Color(red: 0.85, green: 0.65, blue: 0.13),
            Color(red: 0.65, green: 0.50, blue: 0.10),
        ],
        startPoint: .leading,
        endPoint: .trailing
    )

    private static let gold = Color(red: 1, green: 0.84, blue: 0)

    private var frameWidth: CGFloat {
        max(26 * sizeScale, minimumHitWidth ?? 0)
    }

    private var frameHeight: CGFloat {
        max(40 * sizeScale, minimumHitHeight ?? 0)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(Self.gradient)
                .frame(width: 10 * sizeScale, height: 40 * sizeScale)

            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(Self.gradient)
                .frame(width: 26 * sizeScale, height: 8 * sizeScale)
                .offset(y: -8 * sizeScale)
        }
        .frame(width: frameWidth, height: frameHeight)
        .contentShape(Rectangle())
        .shadow(color: .black.opacity(0.5), radius: 4, y: 3)
        .shadow(color: Self.gold.opacity(isSelected ? 0.9 : 0), radius: isSelected ? 14 : 0)
        .scaleEffect(isSelected ? selectionScale : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .onTapGesture(perform: onTap)
    }
}
