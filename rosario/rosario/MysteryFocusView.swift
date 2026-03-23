import SwiftUI

struct MysteryFocusView: View {
    let context: RosaryFocusContext

    @State private var activeSection: RosaryFocusSection
    @State private var selectedStep: FocusStep
    @State private var isPrayerExpanded = false

    init(context: RosaryFocusContext) {
        self.context = context
        let initialSection = context.section
        let initialBeadID = initialSection.beadIDs.contains(context.selectedBeadID)
            ? context.selectedBeadID
            : initialSection.defaultBeadID
        _activeSection = State(initialValue: context.section)
        _selectedStep = State(initialValue: .bead(initialBeadID))
    }

    private let beads = Bead.rosary
    private let gold = Color(red: 1.0, green: 0.84, blue: 0.0)

    private var content: FocusContent {
        activeSection.content(for: context.mysterySet)
    }

    private var focusBeads: [Bead] {
        activeSection.beadIDs.compactMap { beadID in
            beads.first(where: { $0.id == beadID })
        }
    }

    private var activeSectionIndex: Int {
        RosaryFocusSection.orderedSections.firstIndex(of: activeSection) ?? 0
    }

    private var currentSteps: [FocusStep] {
        steps(for: activeSection)
    }

    private var currentStepIndex: Int {
        currentSteps.firstIndex(of: selectedStep) ?? 0
    }

    private var currentFocusPrayer: FocusPrayer? {
        let p = prayer(for: selectedStep, in: activeSection)
        return p == .announceMystery ? nil : p
    }

    private var expandedPrayerText: String? {
        guard let prayer = currentFocusPrayer, let base = prayer.fullText else { return nil }
        if prayer == .gloryBe, case .mystery = activeSection {
            return base + "\n\nÓh! Meu Jesus, perdoai-nos, livrai-nos do fogo do inferno, levai as almas todas para o Céu e socorrei principalmente as que mais precisarem."
        }
        return base
    }

    private var currentPrayerLabel: String? {
        guard let currentPrayer = currentFocusPrayer else { return nil }

        if case .introduction = activeSection, case .bead(let id) = selectedStep {
            switch id {
            case 2: return "Ave Maria, Filha Bem Amada do Padre Eterno"
            case 3: return "Ave Maria, Mãe Admirável de Deus Filho"
            case 4: return "Ave Maria, Esposa Fidelíssima do Divino Espírito Santo"
            default: break
            }
        }

        if currentPrayer == .gloryBe, case .mystery = activeSection {
            return "Glória ao Pai e Jaculatória de Fátima"
        }

        return currentPrayer.rawValue
    }

    private var currentSelectedBeadID: Int? {
        if case let .bead(id) = selectedStep {
            return id
        }
        return nil
    }

    private var hasClosingChain: Bool {
        currentSteps.contains { step in
            if case .chain = step { return true }
            return false
        }
    }

    private var isClosingChainSelected: Bool {
        if case .chain = selectedStep {
            return true
        }
        return false
    }

    private var canMoveBackward: Bool {
        activeSectionIndex > 0 || currentStepIndex > 0
    }

    private var canMoveForward: Bool {
        activeSectionIndex < RosaryFocusSection.orderedSections.count - 1 ||
            currentStepIndex < currentSteps.count - 1
    }

    private var showsFooter: Bool {
        activeSection != .finale
    }

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
        VStack(alignment: .leading, spacing: 16) {
            Text(content.eyebrow)
                .font(.caption.weight(.semibold))
                .tracking(0.6)
                .foregroundStyle(gold)

            Text(content.title)
                .font(.system(size: 32, weight: .bold, design: .serif))
                .foregroundStyle(.white)

            Text(content.heroText)
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

    private var bottomPanel: some View {
        VStack(spacing: 14) {
            mysteryStrip
            navigationControls
        }
    }

    private var mysteryStrip: some View {
        VStack(alignment: .leading, spacing: currentPrayerLabel == nil ? 0 : 14) {
            if let currentPrayerLabel {
                VStack(spacing: 0) {
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                            isPrayerExpanded.toggle()
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Spacer()
                            Text(currentPrayerLabel)
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(isClosingChainSelected ? gold : .white.opacity(0.92))
                                .multilineTextAlignment(.center)
                            Image(systemName: "chevron.up")
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(.white.opacity(0.45))
                                .rotationEffect(.degrees(isPrayerExpanded ? 180 : 0))
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)

                    if isPrayerExpanded, let fullText = expandedPrayerText {
                        Text(fullText)
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
                    beadCount: focusBeads.count,
                    includesClosingChain: hasClosingChain
                )

                HStack(spacing: 0) {
                    ForEach(Array(focusBeads.enumerated()), id: \.element.id) { index, bead in
                        if index > 0 {
                            connector(width: metrics.connectorWidth)
                        }

                        focusBead(bead, metrics: metrics)
                            .frame(width: metrics.slotWidth, height: metrics.height)
                    }

                    if hasClosingChain {
                        closingChain(width: metrics.closingChainWidth)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: focusBeads.count > 8 ? 48 : 62)
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
                        gold.opacity(isClosingChainSelected ? 1.0 : 0.7),
                        gold.opacity(isClosingChainSelected ? 0.8 : 0.5),
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: width, height: isClosingChainSelected ? 3 : 2)
            .shadow(
                color: gold.opacity(isClosingChainSelected ? 0.45 : 0),
                radius: isClosingChainSelected ? 10 : 0
            )
    }

    private var navigationControls: some View {
        HStack(spacing: 12) {
            navigationButton(
                title: "Anterior",
                systemImage: "chevron.left",
                isEnabled: canMoveBackward
            ) {
                moveSelection(by: -1)
            }

            navigationButton(
                title: "Próxima",
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

    private func moveSelection(by offset: Int) {
        let targetIndex = currentStepIndex + offset

        if currentSteps.indices.contains(targetIndex) {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                isPrayerExpanded = false
                selectedStep = currentSteps[targetIndex]
            }
            return
        }

        let targetSectionIndex = activeSectionIndex + offset
        guard RosaryFocusSection.orderedSections.indices.contains(targetSectionIndex) else {
            return
        }

        let targetSection = RosaryFocusSection.orderedSections[targetSectionIndex]
        let targetSteps = steps(for: targetSection)

        withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
            isPrayerExpanded = false
            activeSection = targetSection
            selectedStep = offset > 0
                ? (targetSteps.first ?? .bead(targetSection.defaultBeadID))
                : (targetSteps.last ?? .bead(targetSection.defaultBeadID))
        }
    }

    private func steps(for section: RosaryFocusSection) -> [FocusStep] {
        let beadSteps = section.beadIDs.map(FocusStep.bead)
        switch section {
        case .introduction, .mystery:
            return beadSteps + [.chain(.gloryBe)]
        case .finale:
            return beadSteps
        }
    }

    private func prayer(for step: FocusStep, in section: RosaryFocusSection) -> FocusPrayer {
        switch section {
        case .introduction:
            switch step {
            case .bead(let id):
                switch id {
                case 0:
                    .creed
                case 1:
                    .ourFather
                case 2, 3, 4:
                    .hailMary
                default:
                    .announceMystery
                }
            case .chain(let prayer):
                prayer
            }
        case .mystery:
            switch step {
            case .bead(let id):
                if id == section.beadIDs.first {
                    .ourFather
                } else {
                    .hailMary
                }
            case .chain(let prayer):
                prayer
            }
        case .finale:
            .salveRainha
        }
    }

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
    private func focusBead(_ bead: Bead, metrics: StripMetrics) -> some View {
        if bead.kind == .crucifix {
            CrucifixView(
                isSelected: currentSelectedBeadID == bead.id,
                sizeScale: metrics.scale,
                minimumHitWidth: metrics.slotWidth,
                minimumHitHeight: metrics.height,
                selectionScale: 1.08
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isPrayerExpanded = false
                    selectedStep = .bead(bead.id)
                }
            }
        } else {
            BeadView(
                kind: bead.kind,
                isSelected: currentSelectedBeadID == bead.id,
                sizeScale: metrics.scale,
                minimumHitWidth: metrics.slotWidth,
                minimumHitHeight: metrics.height,
                selectionScale: 1.12
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isPrayerExpanded = false
                    selectedStep = .bead(bead.id)
                }
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

    private enum FocusStep: Hashable {
        case bead(Int)
        case chain(FocusPrayer)
    }

    private enum FocusPrayer: String, Hashable {
        case salveRainha = "Salve Rainha"
        case announceMystery = "Anúncio do Mistério"
        case creed = "Creio em Deus Pai"
        case ourFather = "Pai Nosso"
        case hailMary = "Ave Maria"
        case gloryBe = "Glória ao Pai"

        var fullText: String? {
            switch self {
            case .hailMary:
                "Ave Maria, cheia de graça, o Senhor é convosco. Bendita sois Vós entre as mulheres, bendito é o fruto de Vosso ventre, Jesus.\nSanta Maria, Mãe de Deus, rogai por nós, pecadores, agora e na hora de nossa morte. Amém."
            case .ourFather:
                "Pai Nosso, que estais no céu, santificado seja o Vosso Nome, venha a nós o Vosso Reino, seja feita a Vossa Vontade, assim na terra como no céu.\nO pão nosso de cada dia nos dai hoje, perdoai-nos as nossas ofensas, assim como nós perdoamos a quem nos tenha ofendido. E não nos deixeis cair em tentação, mas livrai-nos do mal. Amém."
            case .gloryBe:
                "Glória ao Pai, ao Filho e ao Espírito Santo, como era no princípio, agora e sempre. Amém."
            case .creed:
                "Creio em Deus Pai todo-poderoso, Criador do céu e da terra; e em Jesus Cristo, seu único Filho, nosso Senhor; que foi concebido pelo poder do Espírito Santo; nasceu da Virgem Maria; padeceu sob Pôncio Pilatos, foi crucificado, morto e sepultado; desceu à mansão dos mortos; ressuscitou ao terceiro dia; subiu aos céus, está sentado à direita de Deus Pai todo-poderoso, de onde há de vir a julgar os vivos e os mortos.\nCreio no Espírito Santo, na Santa Igreja Católica, na comunhão dos santos, na remissão dos pecados, na ressurreição da carne, na vida eterna. Amém."
            case .salveRainha:
                "Salve Rainha, Mãe de Misericórdia, vida, doçura e esperança nossa, salve! A Vós bradamos, os degredados filhos de Eva. A Vós suspiramos, gemendo e chorando neste vale de lágrimas.\nEia, pois, Advogada nossa, esses Vossos olhos misericordiosos a nós volvei, e, depois deste desterro, mostrai-nos a Jesus, bendito fruto de Vosso ventre, ó clemente, ó piedosa, ó doce sempre Virgem Maria.\nRogai por nós, santa Mãe de Deus,\nPara que sejamos dignos das promessas de Cristo.\nAmém."
            case .announceMystery:
                nil
            }
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
