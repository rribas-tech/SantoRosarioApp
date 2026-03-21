import SwiftUI

struct ChainView: View {
    let segments: [(CGPoint, CGPoint)]

    var body: some View {
        Canvas { context, _ in
            for (start, end) in segments {
                var path = Path()
                path.move(to: start)
                path.addLine(to: end)

                context.stroke(
                    path,
                    with: .linearGradient(
                        Gradient(colors: [
                            Color(red: 0.85, green: 0.65, blue: 0.13),
                            Color(red: 1.0, green: 0.84, blue: 0.0),
                            Color(red: 0.85, green: 0.65, blue: 0.13),
                        ]),
                        startPoint: start,
                        endPoint: end
                    ),
                    style: StrokeStyle(lineWidth: 2.0, lineCap: .round)
                )
            }
        }
        .allowsHitTesting(false)
    }
}
