import SwiftUI

struct MysteryFocusView: View {
    let mystery: RosaryMystery

    @State private var stepIndex: Int
    @State private var beadIndex: Int
    @State private var isPrayerExpanded = false

    init(context: RosaryFocusContext) {
        self.mystery = context.mystery
        _stepIndex = State(initialValue: context.stepIndex)
        _beadIndex = State(initialValue: context.beadIndex)
    }

    private let gold = Color(red: 1.0, green: 0.84, blue: 0.0)

    private var currentStep: RosaryStep {
        mystery.steps[stepIndex]
    }

    private var currentBead: StepBead? {
        let beads = currentStep.beads
        return beads.indices.contains(beadIndex) ? beads[beadIndex] : nil
    }

    private var isChainSelected: Bool {
        currentBead?.icon == .chain
    }

    private var canMoveBackward: Bool {
        stepIndex > 0 || beadIndex > 0
    }

    private var canMoveForward: Bool {
        let beads = currentStep.beads
        return stepIndex < mystery.steps.count - 1 || beadIndex < beads.count - 1
    }

    private var showsFooter: Bool {
        !currentStep.beads.isEmpty
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                hero
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 32)
        }
        .background(background.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .safeAreaInset(edge: .bottom) {
            if showsFooter {
                bottomPanel
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                    .padding(.bottom, 12)
            }
        }
    }

    private var hero: some View {
        let step = currentStep
        return VStack(alignment: .leading, spacing: 16) {
            Text(step.name)
                .font(.caption.weight(.semibold))
                .tracking(0.6)
                .foregroundStyle(gold)

            Text(step.title)
                .font(.system(size: 32, weight: .bold, design: .serif))
                .foregroundStyle(.white)

            Text(step.scripture)
                .font(.system(size: 19, weight: .regular, design: .serif))
                .foregroundStyle(.white.opacity(0.92))
                .lineSpacing(8)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.31, green: 0.19, blue: 0.07),
                            Color(red: 0.15, green: 0.08, blue: 0.12),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(alignment: .topTrailing) {
                    Circle()
                        .fill(Color.white.opacity(0.10))
                        .frame(width: 120, height: 120)
                        .blur(radius: 20)
                        .offset(x: 30, y: -35)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                }
        )
        .shadow(color: .black.opacity(0.28), radius: 18, y: 12)
    }

    // MARK: - Bottom Panel

    private var bottomPanel: some View {
        VStack(spacing: 14) {
            beadStrip
            navigationControls
        }
    }

    private var beadStrip: some View {
        let stepBeads = currentStep.beads
        let visualBeads = stepBeads.enumerated().filter { $0.element.icon != .chain }
        let hasChain = stepBeads.last?.icon == .chain
        let label = currentBead?.displayTitle

        return VStack(alignment: .leading, spacing: label == nil ? 0 : 14) {
            if let label {
                VStack(spacing: 0) {
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                            isPrayerExpanded.toggle()
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Spacer()
                            Text(label)
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(isChainSelected ? gold : .white.opacity(0.92))
                                .multilineTextAlignment(.center)
                            Image(systemName: "chevron.up")
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(.white.opacity(0.45))
                                .rotationEffect(.degrees(isPrayerExpanded ? 180 : 0))
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)

                    if isPrayerExpanded, let body = currentBead?.prayer.body {
                        Text(body)
                            .font(.system(size: 16, weight: .regular, design: .serif))
                            .foregroundStyle(.white.opacity(0.85))
                            .lineSpacing(6)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 14)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
            }

            GeometryReader { proxy in
                let metrics = stripMetrics(
                    for: proxy.size.width,
                    beadCount: visualBeads.count,
                    includesClosingChain: hasChain
                )

                HStack(spacing: 0) {
                    ForEach(Array(visualBeads.enumerated()), id: \.offset) { visualIdx, item in
                        if visualIdx > 0 {
                            connector(width: metrics.connectorWidth)
                        }

                        focusBead(item.element, at: item.offset, metrics: metrics)
                            .frame(width: metrics.slotWidth, height: metrics.height)
                    }

                    if hasChain {
                        closingChain(width: metrics.closingChainWidth)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: visualBeads.count > 8 ? 48 : 62)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(red: 0.12, green: 0.10, blue: 0.13).opacity(0.98))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        }
    }

    private func connector(width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 999, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0.85, green: 0.65, blue: 0.13),
                        gold,
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: width, height: 2)
    }

    private func closingChain(width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 999, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        gold.opacity(isChainSelected ? 1.0 : 0.7),
                        gold.opacity(isChainSelected ? 0.8 : 0.5),
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: width, height: isChainSelected ? 3 : 2)
            .shadow(
                color: gold.opacity(isChainSelected ? 0.45 : 0),
                radius: isChainSelected ? 10 : 0
            )
    }

    private var navigationControls: some View {
        HStack(spacing: 12) {
            navigationButton(
                title: String(localized: "Anterior"),
                systemImage: "chevron.left",
                isEnabled: canMoveBackward
            ) {
                moveSelection(by: -1)
            }

            navigationButton(
                title: String(localized: "Próxima"),
                systemImage: "chevron.right",
                isEnabled: canMoveForward,
                iconOnTrailingEdge: true
            ) {
                moveSelection(by: 1)
            }
        }
    }

    private func navigationButton(
        title: String,
        systemImage: String,
        isEnabled: Bool,
        iconOnTrailingEdge: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if !iconOnTrailingEdge {
                    Image(systemName: systemImage)
                }

                Text(title)
                    .font(.headline.weight(.semibold))

                if iconOnTrailingEdge {
                    Image(systemName: systemImage)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .foregroundStyle(isEnabled ? Color.white : Color.white.opacity(0.35))
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isEnabled ? Color.white.opacity(0.12) : Color.white.opacity(0.05))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        isEnabled ? Color.white.opacity(0.10) : Color.white.opacity(0.06),
                        lineWidth: 1
                    )
            }
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }

    // MARK: - Selection

    private func selectBead(_ idx: Int, response: CGFloat = 0.3, damping: CGFloat = 0.7) {
        withAnimation(.spring(response: response, dampingFraction: damping)) {
            isPrayerExpanded = false
            beadIndex = idx
        }
    }

    private func moveSelection(by offset: Int) {
        let targetBead = beadIndex + offset

        if currentStep.beads.indices.contains(targetBead) {
            selectBead(targetBead, response: 0.28, damping: 0.8)
            return
        }

        let targetStep = stepIndex + offset
        guard mystery.steps.indices.contains(targetStep) else { return }

        let nextStep = mystery.steps[targetStep]
        withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
            isPrayerExpanded = false
            stepIndex = targetStep
            beadIndex = offset > 0 ? 0 : max(nextStep.beads.count - 1, 0)
        }
    }

    // MARK: - Bead Rendering

    private func stripMetrics(
        for width: CGFloat,
        beadCount: Int,
        includesClosingChain: Bool
    ) -> StripMetrics {
        let safeCount = max(beadCount, 1)
        let connectorCount = max(safeCount - 1, 0)
        let maxSlotWidth: CGFloat = safeCount > 8 ? 24 : 30
        let minConnectorWidth: CGFloat = safeCount > 8 ? 2 : 8
        let closingChainWidth: CGFloat = includesClosingChain ? (safeCount > 8 ? 18 : 26) : 0
        let availableWidth = max(width, 1)
        let slotWidth = min(
            maxSlotWidth,
            (availableWidth - closingChainWidth - CGFloat(connectorCount) * minConnectorWidth) / CGFloat(safeCount)
        )
        let connectorWidth = connectorCount > 0
            ? max(1, (availableWidth - closingChainWidth - CGFloat(safeCount) * slotWidth) / CGFloat(connectorCount))
            : 0
        let scale = min(1.0, max(0.74, slotWidth / 28))
        let height: CGFloat = safeCount > 8 ? 48 : 62

        return StripMetrics(
            slotWidth: slotWidth,
            connectorWidth: connectorWidth,
            closingChainWidth: closingChainWidth,
            scale: scale,
            height: height
        )
    }

    @ViewBuilder
    private func focusBead(_ stepBead: StepBead, at idx: Int, metrics: StripMetrics) -> some View {
        let isSelected = beadIndex == idx

        if stepBead.icon == .crucifix {
            CrucifixView(
                isSelected: isSelected,
                sizeScale: metrics.scale,
                minimumHitWidth: metrics.slotWidth,
                minimumHitHeight: metrics.height,
                selectionScale: 1.08
            ) {
                selectBead(idx)
            }
        } else {
            BeadView(
                kind: stepBead.icon == .large ? .large : stepBead.icon == .medal ? .medal : .small,
                isSelected: isSelected,
                sizeScale: metrics.scale,
                minimumHitWidth: metrics.slotWidth,
                minimumHitHeight: metrics.height,
                selectionScale: 1.12
            ) {
                selectBead(idx)
            }
        }
    }

    private var background: some View {
        LinearGradient(
            colors: [
                Color(red: 0.06, green: 0.05, blue: 0.10),
                Color(red: 0.12, green: 0.06, blue: 0.04),
                Color(red: 0.04, green: 0.04, blue: 0.08),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay {
            RadialGradient(
                colors: [
                    Color(red: 1.0, green: 0.77, blue: 0.30).opacity(0.10),
                    .clear,
                ],
                center: .top,
                startRadius: 10,
                endRadius: 320
            )
        }
    }

    private struct StripMetrics {
        let slotWidth: CGFloat
        let connectorWidth: CGFloat
        let closingChainWidth: CGFloat
        let scale: CGFloat
        let height: CGFloat
    }
}
