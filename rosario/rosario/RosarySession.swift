import Foundation
import Observation

@MainActor
@Observable
final class RosarySession {
    let steps: [RosaryStep]
    var currentIndex: Int

    init() {
        self.steps = RosarySession.makeSimpleRosary()
        self.currentIndex = 0
    }

    var currentStep: RosaryStep {
        steps[currentIndex]
    }

    var progressText: String {
        "\(currentIndex + 1) de \(steps.count)"
    }

    var progressValue: Double {
        guard !steps.isEmpty else { return 0 }
        return Double(currentIndex + 1) / Double(steps.count)
    }

    var isFirstStep: Bool {
        currentIndex == 0
    }

    var isLastStep: Bool {
        currentIndex == steps.count - 1
    }

    func next() {
        guard currentIndex < steps.count - 1 else { return }
        currentIndex += 1
    }

    func previous() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
    }

    func restart() {
        currentIndex = 0
    }

    func goToStep(_ index: Int) {
        guard steps.indices.contains(index) else { return }
        currentIndex = index
    }

    private static func makeSimpleRosary() -> [RosaryStep] {
        var items: [RosaryStep] = []
        var id = 0

        func append(_ prayer: PrayerKind, _ label: String) {
            items.append(RosaryStep(id: id, prayer: prayer, label: label))
            id += 1
        }

        append(.signOfCross, "Sinal da Cruz")
        append(.apostlesCreed, "Cruz")
        append(.ourFather, "Conta grande")
        append(.hailMary, "Conta pequena 1")
        append(.hailMary, "Conta pequena 2")
        append(.hailMary, "Conta pequena 3")
        append(.gloryBe, "Entre contas")

        for decade in 1...5 {
            append(.ourFather, "Dezena \(decade) · Conta grande")

            for hail in 1...10 {
                append(.hailMary, "Dezena \(decade) · Conta \(hail)")
            }

            append(.gloryBe, "Dezena \(decade) · Final")
        }

        append(.hailHolyQueen, "Encerramento")

        return items
    }
}
