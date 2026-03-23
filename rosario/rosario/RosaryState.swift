import Foundation
import Observation

@Observable
final class RosaryState {
    let beads = Bead.rosary
    let weekdayTitle = RosaryState.makeWeekdayTitle()
    let mysterySet = MysterySet.forDate()
    var selectedBeadID: Int?

    var mysteryOfDayDescription: String {
        "\(weekdayTitle): \(mysterySet.pluralTitle)"
    }

    func select(_ id: Int) {
        selectedBeadID = id
    }

    func focusContext(for beadID: Int) -> RosaryFocusContext {
        RosaryFocusContext(
            mysterySet: mysterySet,
            section: RosaryFocusSection.from(beadID: beadID),
            selectedBeadID: beadID
        )
    }

    private static func makeWeekdayTitle(date: Date = .now) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date).capitalized(with: formatter.locale)
    }
}
