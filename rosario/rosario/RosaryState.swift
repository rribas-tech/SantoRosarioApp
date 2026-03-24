import Foundation
import Observation

@Observable
final class RosaryState {
    let beads = Bead.rosary
    let weekdayTitle = RosaryState.makeWeekdayTitle()
    let mystery = RosaryCatalog.forDate()
    var selectedBeadID: Int?

    var mysteryOfDayDescription: String {
        "\(weekdayTitle): \(mystery.name)"
    }

    func select(_ id: Int) {
        selectedBeadID = id
    }

    func focusContext(for beadID: Int) -> RosaryFocusContext {
        let pos = RosaryCatalog.stepPosition(forPhysicalBead: beadID)
        return RosaryFocusContext(
            mystery: mystery,
            stepIndex: pos.stepIndex,
            beadIndex: pos.beadIndex
        )
    }

    private static func makeWeekdayTitle(date: Date = .now) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date).capitalized(with: formatter.locale)
    }
}
