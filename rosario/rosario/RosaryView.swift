import SwiftUI

struct RosaryView: View {
    @State private var session = RosarySession()

    var body: some View {
        NavigationStack {
            ZStack {
                background

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        headerCard
                        rosaryCard
                        prayerCard
                        controls
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Rosario Virtual")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var background: some View {
        LinearGradient(
            colors: [
                Color(red: 0.95, green: 0.96, blue: 0.98),
                Color(red: 0.89, green: 0.91, blue: 0.95)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Acompanhe sua oração com serenidade.")
                .font(.headline)

            ProgressView(value: session.progressValue)
                .tint(.blue)

            HStack {
                Text(session.currentStep.prayer.title)
                    .font(.subheadline.weight(.semibold))

                Spacer()

                Text(session.progressText)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.35), lineWidth: 1)
        }
    }

    private var rosaryCard: some View {
        VStack(spacing: 14) {
            Text(session.currentStep.label)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            GeometryReader { proxy in
                let size = min(proxy.size.width, 360)
                let layout = RosaryLayout.make(count: session.steps.count, width: size)

                ZStack {
                    ForEach(layout.lineSegments.indices, id: \.self) { index in
                        let segment = layout.lineSegments[index]
                        let start = layout.points[segment.0]
                        let end = layout.points[segment.1]

                        Path { path in
                            path.move(to: start)
                            path.addLine(to: end)
                        }
                        .stroke(
                            Color.white.opacity(0.42),
                            style: StrokeStyle(
                                lineWidth: 3,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                    }

                    ForEach(session.steps.indices, id: \.self) { index in
                        let point = layout.points[index]
                        let isCurrent = session.currentIndex == index
                        let isPast = index < session.currentIndex
                        let prayer = session.steps[index].prayer

                        beadView(
                            prayer: prayer,
                            isCurrent: isCurrent,
                            isPast: isPast
                        )
                        .frame(
                            width: beadSize(for: prayer, isCurrent: isCurrent),
                            height: beadSize(for: prayer, isCurrent: isCurrent)
                        )
                        .position(point)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                                if isCurrent {
                                    session.next()
                                } else {
                                    session.goToStep(index)
                                }
                            }
                        }
                        .accessibilityLabel(Text(session.steps[index].label))
                        .accessibilityHint(
                            Text(isCurrent ? "Avança para a próxima oração" : "Vai para esta conta")
                        )
                    }

                    crossView()
                        .position(layout.crossPoint)
                }
                .frame(width: size, height: layout.height)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: 560)
        }
        .padding(18)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.4), lineWidth: 1)
        }
    }

    private var prayerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(session.currentStep.prayer.title)
                .font(.title3.weight(.semibold))

            Text(session.currentStep.prayer.prayerText)
                .font(.body)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.35), lineWidth: 1)
        }
    }

    private var controls: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.spring(response: 0.32, dampingFraction: 0.85)) {
                    session.previous()
                }
            } label: {
                Label("Anterior", systemImage: "chevron.left")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .disabled(session.isFirstStep)

            Button {
                withAnimation(.spring(response: 0.32, dampingFraction: 0.85)) {
                    if session.isLastStep {
                        session.restart()
                    } else {
                        session.next()
                    }
                }
            } label: {
                Label(
                    session.isLastStep ? "Reiniciar" : "Próximo",
                    systemImage: session.isLastStep ? "arrow.counterclockwise" : "chevron.right"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }

    private func beadView(
        prayer: PrayerKind,
        isCurrent: Bool,
        isPast: Bool
    ) -> some View {
        let baseFill = beadColor(for: prayer, isPast: isPast)
        let glowOpacity = isCurrent ? 0.36 : 0.0

        return ZStack {
            Circle()
                .fill(baseFill)

            Circle()
                .stroke(
                    Color.white.opacity(isCurrent ? 0.85 : 0.28),
                    lineWidth: isCurrent ? 2.2 : 1
                )

            Circle()
                .fill(.white.opacity(0.12))
                .padding(isCurrent ? 4 : 3)
                .blur(radius: isCurrent ? 1.5 : 0.5)
        }
        .shadow(color: Color.white.opacity(glowOpacity), radius: isCurrent ? 16 : 0)
        .shadow(color: .black.opacity(isCurrent ? 0.16 : 0.08), radius: isCurrent ? 14 : 6, y: isCurrent ? 8 : 4)
        .scaleEffect(isCurrent ? 1.16 : 1.0)
        .animation(.spring(response: 0.32, dampingFraction: 0.82), value: isCurrent)
    }

    private func beadColor(
        for prayer: PrayerKind,
        isPast: Bool
    ) -> Color {
        switch prayer {
            case .signOfCross, .apostlesCreed:
                return isPast
                ? Color(red: 0.36, green: 0.47, blue: 0.73)
                : Color(red: 0.48, green: 0.59, blue: 0.86)

            case .ourFather:
                return isPast
                ? Color(red: 0.62, green: 0.51, blue: 0.24)
                : Color(red: 0.77, green: 0.66, blue: 0.35)

            case .hailMary:
                return isPast
                ? Color(red: 0.43, green: 0.56, blue: 0.70)
                : Color(red: 0.60, green: 0.73, blue: 0.86)

            case .gloryBe:
                return isPast
                ? Color(red: 0.53, green: 0.41, blue: 0.63)
                : Color(red: 0.66, green: 0.53, blue: 0.78)

            case .hailHolyQueen:
                return isPast
                ? Color(red: 0.60, green: 0.31, blue: 0.31)
                : Color(red: 0.79, green: 0.42, blue: 0.42)
        }
    }

    private func beadSize(
        for prayer: PrayerKind,
        isCurrent: Bool
    ) -> CGFloat {
        let base: CGFloat

        switch prayer {
            case .signOfCross, .apostlesCreed:
                base = 14
            case .ourFather:
                base = 18
            case .hailMary:
                base = 13
            case .gloryBe:
                base = 15
            case .hailHolyQueen:
                base = 20
        }

        return isCurrent ? base + 3 : base
    }

    @ViewBuilder
    private func crossView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color(red: 0.76, green: 0.66, blue: 0.39))
                .frame(width: 14, height: 54)

            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color(red: 0.76, green: 0.66, blue: 0.39))
                .frame(width: 34, height: 12)
                .offset(y: -10)
        }
        .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
    }
}

private enum RosaryLayout {
    struct Result {
        let points: [CGPoint]
        let lineSegments: [(Int, Int)]
        let crossPoint: CGPoint
        let height: CGFloat
    }

    static func make(count: Int, width: CGFloat) -> Result {
        let centerX = width / 2
        let centerY: CGFloat = 170
        let radius = min(width * 0.34, 118)

        let loopCount = max(count - 8, 12)
        let chainCount = count - loopCount

        var points: [CGPoint] = []

        let startAngle = 230.0 * Double.pi / 180.0
        let endAngle = -50.0 * Double.pi / 180.0

        if loopCount > 1 {
            for index in 0..<loopCount {
                let t = Double(index) / Double(loopCount - 1)
                let angle = startAngle + (endAngle - startAngle) * t
                let x = centerX + cos(angle) * radius
                let y = centerY + sin(angle) * radius
                points.append(CGPoint(x: x, y: y))
            }
        } else {
            points.append(CGPoint(x: centerX, y: centerY))
        }

        let chainStart = points.last ?? CGPoint(x: centerX, y: centerY + radius)

        if chainCount > 0 {
            for index in 0..<chainCount {
                let step = CGFloat(index + 1)
                let x = chainStart.x - min(step * 2.2, 12)
                let y = chainStart.y + step * 26
                points.append(CGPoint(x: x, y: y))
            }
        }

        let lineSegments = Array((0..<(max(points.count - 1, 0))).map { ($0, $0 + 1) })
        let crossPoint = CGPoint(
            x: points.last?.x ?? centerX,
            y: (points.last?.y ?? centerY) + 34
        )
        let height = max((points.last?.y ?? centerY) + 90, 520)

        return Result(
            points: points,
            lineSegments: lineSegments,
            crossPoint: crossPoint,
            height: height
        )
    }
}

#Preview {
    RosaryView()
}
