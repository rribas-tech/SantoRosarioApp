import Foundation

// MARK: - Prayer

struct Prayer: Hashable {
    let name: String
    let body: String
}

enum Prayers {
    static let credo = Prayer(
        name: String(localized: "prayers.credo.name"),
        body: String(localized: "prayers.credo.body")
    )

    static let paterNoster = Prayer(
        name: String(localized: "prayers.paterNoster.name"),
        body: String(localized: "prayers.paterNoster.body")
    )

    static let aveMaria = Prayer(
        name: String(localized: "prayers.aveMaria.name"),
        body: String(localized: "prayers.aveMaria.body")
    )

    static let gloriaPatri = Prayer(
        name: String(localized: "prayers.gloriaPatri.name"),
        body: String(localized: "prayers.gloriaPatri.body")
    )

    static let jaculatoriaFatima = Prayer(
        name: String(localized: "prayers.jaculatoriaFatima.name"),
        body: String(localized: "prayers.jaculatoriaFatima.body")
    )

    static let gloriaPatriEtFatima = Prayer(
        name: String(localized: "prayers.gloriaPatriEtFatima.name"),
        body: "\(gloriaPatri.body)\n\n\(jaculatoriaFatima.body)"
    )

    static let salveRegina = Prayer(
        name: String(localized: "prayers.salveRegina.name"),
        body: String(localized: "prayers.salveRegina.body")
    )
}

// MARK: - Data Types

enum BeadIcon: Hashable {
    case crucifix
    case large
    case small
    case medal
    case chain
}

struct StepBead: Hashable {
    let icon: BeadIcon
    let prayer: Prayer
    let title: String?

    init(_ icon: BeadIcon, _ prayer: Prayer, title: String? = nil) {
        self.icon = icon
        self.prayer = prayer
        self.title = title
    }

    var displayTitle: String { title ?? prayer.name }
}

struct RosaryStep: Identifiable, Hashable {
    let name: String
    let title: String
    let scripture: String
    let beads: [StepBead]

    var id: String { name }

    init(name: String, title: String, scripture: String, beads: [StepBead] = []) {
        self.name = name
        self.title = title
        self.scripture = scripture
        self.beads = beads
    }
}

struct RosaryMystery: Identifiable, Hashable {
    let weekdays: [Int]
    let name: String
    let steps: [RosaryStep]

    var id: String { name }
}

// MARK: - Navigation Context

struct RosaryFocusContext: Hashable {
    let mystery: RosaryMystery
    let stepIndex: Int
    let beadIndex: Int
}

// MARK: - Physical Bead Mapping

extension RosaryCatalog {
    static func stepPosition(forPhysicalBead beadID: Int) -> (stepIndex: Int, beadIndex: Int) {
        if beadID <= 4 { return (0, beadID) }
        if beadID == 5 { return (1, 0) }
        if beadID == 6 { return (6, 0) }
        if beadID <= 16 { return (1, beadID - 6) }
        let offset = beadID - 17
        return (offset / 11 + 2, offset % 11)
    }
}

// MARK: - Catalog

enum RosaryCatalog {
    static let all: [RosaryMystery] = [joyful, sorrowful, glorious, luminous]

    static func forDate(_ date: Date = .now, calendar: Calendar = .current) -> RosaryMystery {
        let weekday = calendar.component(.weekday, from: date)
        return all.first { $0.weekdays.contains(weekday) } ?? joyful
    }

    // MARK: Shared Steps

    private static let introduction = RosaryStep(
        name: String(localized: "rosary.introduction.name"),
        title: String(localized: "rosary.introduction.title"),
        scripture: String(localized: "rosary.introduction.scripture"),
        beads: [
            StepBead(.crucifix, Prayers.credo),
            StepBead(.large, Prayers.paterNoster),
            StepBead(.small, Prayers.aveMaria, title: String(localized: "rosary.introduction.bead.aveMaria1")),
            StepBead(.small, Prayers.aveMaria, title: String(localized: "rosary.introduction.bead.aveMaria2")),
            StepBead(.small, Prayers.aveMaria, title: String(localized: "rosary.introduction.bead.aveMaria3")),
            StepBead(.chain, Prayers.gloriaPatri),
        ]
    )

    private static let finale = RosaryStep(
        name: String(localized: "rosary.finale.name"),
        title: Prayers.salveRegina.name,
        scripture: Prayers.salveRegina.body
    )

    private static func decade(
        name: String,
        title: String,
        scripture: String
    ) -> RosaryStep {
        RosaryStep(
            name: name,
            title: title,
            scripture: scripture,
            beads: [StepBead(.large, Prayers.paterNoster)]
                + Array(repeating: StepBead(.small, Prayers.aveMaria), count: 10)
                + [StepBead(.chain, Prayers.gloriaPatriEtFatima)]
        )
    }

    // MARK: Joyful — Monday, Saturday

    static let joyful = RosaryMystery(
        weekdays: [2, 7],
        name: String(localized: "mysteries.joyful.name"),
        steps: [
            introduction,
            decade(
                name: String(localized: "mysteries.joyful.first.name"),
                title: String(localized: "mysteries.joyful.first.title"),
                scripture: String(localized: "mysteries.joyful.first.scripture")
            ),
            decade(
                name: String(localized: "mysteries.joyful.second.name"),
                title: String(localized: "mysteries.joyful.second.title"),
                scripture: String(localized: "mysteries.joyful.second.scripture")
            ),
            decade(
                name: String(localized: "mysteries.joyful.third.name"),
                title: String(localized: "mysteries.joyful.third.title"),
                scripture: String(localized: "mysteries.joyful.third.scripture")
            ),
            decade(
                name: String(localized: "mysteries.joyful.fourth.name"),
                title: String(localized: "mysteries.joyful.fourth.title"),
                scripture: String(localized: "mysteries.joyful.fourth.scripture")
            ),
            decade(
                name: String(localized: "mysteries.joyful.fifth.name"),
                title: String(localized: "mysteries.joyful.fifth.title"),
                scripture: String(localized: "mysteries.joyful.fifth.scripture")
            ),
            finale,
        ]
    )

    // MARK: Sorrowful — Tuesday, Friday

    static let sorrowful = RosaryMystery(
        weekdays: [3, 6],
        name: String(localized: "mysteries.sorrowful.name"),
        steps: [
            introduction,
            decade(
                name: String(localized: "mysteries.sorrowful.first.name"),
                title: String(localized: "mysteries.sorrowful.first.title"),
                scripture: String(localized: "mysteries.sorrowful.first.scripture")
            ),
            decade(
                name: String(localized: "mysteries.sorrowful.second.name"),
                title: String(localized: "mysteries.sorrowful.second.title"),
                scripture: String(localized: "mysteries.sorrowful.second.scripture")
            ),
            decade(
                name: String(localized: "mysteries.sorrowful.third.name"),
                title: String(localized: "mysteries.sorrowful.third.title"),
                scripture: String(localized: "mysteries.sorrowful.third.scripture")
            ),
            decade(
                name: String(localized: "mysteries.sorrowful.fourth.name"),
                title: String(localized: "mysteries.sorrowful.fourth.title"),
                scripture: String(localized: "mysteries.sorrowful.fourth.scripture")
            ),
            decade(
                name: String(localized: "mysteries.sorrowful.fifth.name"),
                title: String(localized: "mysteries.sorrowful.fifth.title"),
                scripture: String(localized: "mysteries.sorrowful.fifth.scripture")
            ),
            finale,
        ]
    )

    // MARK: Glorious — Sunday, Wednesday

    static let glorious = RosaryMystery(
        weekdays: [1, 4],
        name: String(localized: "mysteries.glorious.name"),
        steps: [
            introduction,
            decade(
                name: String(localized: "mysteries.glorious.first.name"),
                title: String(localized: "mysteries.glorious.first.title"),
                scripture: String(localized: "mysteries.glorious.first.scripture")
            ),
            decade(
                name: String(localized: "mysteries.glorious.second.name"),
                title: String(localized: "mysteries.glorious.second.title"),
                scripture: String(localized: "mysteries.glorious.second.scripture")
            ),
            decade(
                name: String(localized: "mysteries.glorious.third.name"),
                title: String(localized: "mysteries.glorious.third.title"),
                scripture: String(localized: "mysteries.glorious.third.scripture")
            ),
            decade(
                name: String(localized: "mysteries.glorious.fourth.name"),
                title: String(localized: "mysteries.glorious.fourth.title"),
                scripture: String(localized: "mysteries.glorious.fourth.scripture")
            ),
            decade(
                name: String(localized: "mysteries.glorious.fifth.name"),
                title: String(localized: "mysteries.glorious.fifth.title"),
                scripture: String(localized: "mysteries.glorious.fifth.scripture")
            ),
            finale,
        ]
    )

    // MARK: Luminous — Thursday

    static let luminous = RosaryMystery(
        weekdays: [5],
        name: String(localized: "mysteries.luminous.name"),
        steps: [
            introduction,
            decade(
                name: String(localized: "mysteries.luminous.first.name"),
                title: String(localized: "mysteries.luminous.first.title"),
                scripture: String(localized: "mysteries.luminous.first.scripture")
            ),
            decade(
                name: String(localized: "mysteries.luminous.second.name"),
                title: String(localized: "mysteries.luminous.second.title"),
                scripture: String(localized: "mysteries.luminous.second.scripture")
            ),
            decade(
                name: String(localized: "mysteries.luminous.third.name"),
                title: String(localized: "mysteries.luminous.third.title"),
                scripture: String(localized: "mysteries.luminous.third.scripture")
            ),
            decade(
                name: String(localized: "mysteries.luminous.fourth.name"),
                title: String(localized: "mysteries.luminous.fourth.title"),
                scripture: String(localized: "mysteries.luminous.fourth.scripture")
            ),
            decade(
                name: String(localized: "mysteries.luminous.fifth.name"),
                title: String(localized: "mysteries.luminous.fifth.title"),
                scripture: String(localized: "mysteries.luminous.fifth.scripture")
            ),
            finale,
        ]
    )
}
