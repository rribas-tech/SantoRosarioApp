import Foundation

// MARK: - Prayer

struct Prayer: Hashable {
    let name: String
    let body: String
}

enum Prayers {
    static let credo = Prayer(
        name: String(localized: "orationes.credo.name"),
        body: String(localized: "orationes.credo.body")
    )

    static let paterNoster = Prayer(
        name: String(localized: "orationes.paterNoster.name"),
        body: String(localized: "orationes.paterNoster.body")
    )

    static let aveMaria = Prayer(
        name: String(localized: "orationes.aveMaria.name"),
        body: String(localized: "orationes.aveMaria.body")
    )

    static let gloriaPatri = Prayer(
        name: String(localized: "orationes.gloriaPatri.name"),
        body: String(localized: "orationes.gloriaPatri.body")
    )

    static let jaculatoriaFatima = Prayer(
        name: String(localized: "orationes.jaculatoriaFatima.name"),
        body: String(localized: "orationes.jaculatoriaFatima.body")
    )

    static let gloriaPatriEtFatima = Prayer(
        name: String(localized: "orationes.gloriaPatriEtFatima.name"),
        body: "\(gloriaPatri.body)\n\n\(jaculatoriaFatima.body)"
    )

    static let salveRegina = Prayer(
        name: String(localized: "orationes.salveRegina.name"),
        body: String(localized: "orationes.salveRegina.body")
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
        name: String(localized: "rosarium.introductio.name"),
        title: String(localized: "rosarium.introductio.title"),
        scripture: String(localized: "rosarium.introductio.scripture"),
        beads: [
            StepBead(.crucifix, Prayers.credo),
            StepBead(.large, Prayers.paterNoster),
            StepBead(.small, Prayers.aveMaria, title: String(localized: "rosarium.introductio.aveMaria1")),
            StepBead(.small, Prayers.aveMaria, title: String(localized: "rosarium.introductio.aveMaria2")),
            StepBead(.small, Prayers.aveMaria, title: String(localized: "rosarium.introductio.aveMaria3")),
            StepBead(.chain, Prayers.gloriaPatri),
        ]
    )

    private static let finale = RosaryStep(
        name: String(localized: "rosarium.conclusio.name"),
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

    // MARK: Gaudii — Monday, Saturday

    static let joyful = RosaryMystery(
        weekdays: [2, 7],
        name: String(localized: "mysteria.gaudii.name"),
        steps: [
            introduction,
            decade(
                name: String(localized: "mysteria.gaudii.primum.name"),
                title: String(localized: "mysteria.gaudii.primum.title"),
                scripture: String(localized: "mysteria.gaudii.primum.scripture")
            ),
            decade(
                name: String(localized: "mysteria.gaudii.secundum.name"),
                title: String(localized: "mysteria.gaudii.secundum.title"),
                scripture: String(localized: "mysteria.gaudii.secundum.scripture")
            ),
            decade(
                name: String(localized: "mysteria.gaudii.tertium.name"),
                title: String(localized: "mysteria.gaudii.tertium.title"),
                scripture: String(localized: "mysteria.gaudii.tertium.scripture")
            ),
            decade(
                name: String(localized: "mysteria.gaudii.quartum.name"),
                title: String(localized: "mysteria.gaudii.quartum.title"),
                scripture: String(localized: "mysteria.gaudii.quartum.scripture")
            ),
            decade(
                name: String(localized: "mysteria.gaudii.quintum.name"),
                title: String(localized: "mysteria.gaudii.quintum.title"),
                scripture: String(localized: "mysteria.gaudii.quintum.scripture")
            ),
            finale,
        ]
    )

    // MARK: Doloris — Tuesday, Friday

    static let sorrowful = RosaryMystery(
        weekdays: [3, 6],
        name: String(localized: "mysteria.doloris.name"),
        steps: [
            introduction,
            decade(
                name: String(localized: "mysteria.doloris.primum.name"),
                title: String(localized: "mysteria.doloris.primum.title"),
                scripture: String(localized: "mysteria.doloris.primum.scripture")
            ),
            decade(
                name: String(localized: "mysteria.doloris.secundum.name"),
                title: String(localized: "mysteria.doloris.secundum.title"),
                scripture: String(localized: "mysteria.doloris.secundum.scripture")
            ),
            decade(
                name: String(localized: "mysteria.doloris.tertium.name"),
                title: String(localized: "mysteria.doloris.tertium.title"),
                scripture: String(localized: "mysteria.doloris.tertium.scripture")
            ),
            decade(
                name: String(localized: "mysteria.doloris.quartum.name"),
                title: String(localized: "mysteria.doloris.quartum.title"),
                scripture: String(localized: "mysteria.doloris.quartum.scripture")
            ),
            decade(
                name: String(localized: "mysteria.doloris.quintum.name"),
                title: String(localized: "mysteria.doloris.quintum.title"),
                scripture: String(localized: "mysteria.doloris.quintum.scripture")
            ),
            finale,
        ]
    )

    // MARK: Gloriae — Sunday, Wednesday

    static let glorious = RosaryMystery(
        weekdays: [1, 4],
        name: String(localized: "mysteria.gloriae.name"),
        steps: [
            introduction,
            decade(
                name: String(localized: "mysteria.gloriae.primum.name"),
                title: String(localized: "mysteria.gloriae.primum.title"),
                scripture: String(localized: "mysteria.gloriae.primum.scripture")
            ),
            decade(
                name: String(localized: "mysteria.gloriae.secundum.name"),
                title: String(localized: "mysteria.gloriae.secundum.title"),
                scripture: String(localized: "mysteria.gloriae.secundum.scripture")
            ),
            decade(
                name: String(localized: "mysteria.gloriae.tertium.name"),
                title: String(localized: "mysteria.gloriae.tertium.title"),
                scripture: String(localized: "mysteria.gloriae.tertium.scripture")
            ),
            decade(
                name: String(localized: "mysteria.gloriae.quartum.name"),
                title: String(localized: "mysteria.gloriae.quartum.title"),
                scripture: String(localized: "mysteria.gloriae.quartum.scripture")
            ),
            decade(
                name: String(localized: "mysteria.gloriae.quintum.name"),
                title: String(localized: "mysteria.gloriae.quintum.title"),
                scripture: String(localized: "mysteria.gloriae.quintum.scripture")
            ),
            finale,
        ]
    )

    // MARK: Lucis — Thursday

    static let luminous = RosaryMystery(
        weekdays: [5],
        name: String(localized: "mysteria.lucis.name"),
        steps: [
            introduction,
            decade(
                name: String(localized: "mysteria.lucis.primum.name"),
                title: String(localized: "mysteria.lucis.primum.title"),
                scripture: String(localized: "mysteria.lucis.primum.scripture")
            ),
            decade(
                name: String(localized: "mysteria.lucis.secundum.name"),
                title: String(localized: "mysteria.lucis.secundum.title"),
                scripture: String(localized: "mysteria.lucis.secundum.scripture")
            ),
            decade(
                name: String(localized: "mysteria.lucis.tertium.name"),
                title: String(localized: "mysteria.lucis.tertium.title"),
                scripture: String(localized: "mysteria.lucis.tertium.scripture")
            ),
            decade(
                name: String(localized: "mysteria.lucis.quartum.name"),
                title: String(localized: "mysteria.lucis.quartum.title"),
                scripture: String(localized: "mysteria.lucis.quartum.scripture")
            ),
            decade(
                name: String(localized: "mysteria.lucis.quintum.name"),
                title: String(localized: "mysteria.lucis.quintum.title"),
                scripture: String(localized: "mysteria.lucis.quintum.scripture")
            ),
            finale,
        ]
    )
}
