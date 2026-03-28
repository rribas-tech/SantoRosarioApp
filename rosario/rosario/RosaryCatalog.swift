import Foundation

// MARK: - Prayer

struct Prayer: Hashable {
    let name: String
    let body: String
}

enum Prayers {
    static func credo(locale: Locale) -> Prayer {
        Prayer(
            name: LocalizedBundle.string("prayers.credo.name", locale: locale),
            body: LocalizedBundle.string("prayers.credo.body", locale: locale)
        )
    }

    static func paterNoster(locale: Locale) -> Prayer {
        Prayer(
            name: LocalizedBundle.string("prayers.paterNoster.name", locale: locale),
            body: LocalizedBundle.string("prayers.paterNoster.body", locale: locale)
        )
    }

    static func aveMaria(locale: Locale) -> Prayer {
        Prayer(
            name: LocalizedBundle.string("prayers.aveMaria.name", locale: locale),
            body: LocalizedBundle.string("prayers.aveMaria.body", locale: locale)
        )
    }

    static func gloriaPatri(locale: Locale) -> Prayer {
        Prayer(
            name: LocalizedBundle.string("prayers.gloriaPatri.name", locale: locale),
            body: LocalizedBundle.string("prayers.gloriaPatri.body", locale: locale)
        )
    }

    static func jaculatoriaFatima(locale: Locale) -> Prayer {
        Prayer(
            name: LocalizedBundle.string("prayers.jaculatoriaFatima.name", locale: locale),
            body: LocalizedBundle.string("prayers.jaculatoriaFatima.body", locale: locale)
        )
    }

    static func gloriaPatriEtFatima(locale: Locale) -> Prayer {
        Prayer(
            name: LocalizedBundle.string("prayers.gloriaPatriEtFatima.name", locale: locale),
            body: "\(gloriaPatri(locale: locale).body)\n\n\(jaculatoriaFatima(locale: locale).body)"
        )
    }

    static func salveRegina(locale: Locale) -> Prayer {
        Prayer(
            name: LocalizedBundle.string("prayers.salveRegina.name", locale: locale),
            body: LocalizedBundle.string("prayers.salveRegina.body", locale: locale)
        )
    }
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
    static var appLocale: Locale {
        let code = UserDefaults.standard.string(forKey: "appLanguage") ?? ""
        return code.isEmpty ? .current : Locale(identifier: code)
    }

    static var prayerLocale: Locale {
        let code = UserDefaults.standard.string(forKey: "prayerLanguage") ?? ""
        return code.isEmpty ? appLocale : Locale(identifier: code)
    }

    static var all: [RosaryMystery] { [joyful, sorrowful, glorious, luminous] }

    static func forDate(_ date: Date = .now, calendar: Calendar = .current) -> RosaryMystery {
        let weekday = calendar.component(.weekday, from: date)
        return all.first { $0.weekdays.contains(weekday) } ?? joyful
    }

    // MARK: Shared Steps

    private static var introduction: RosaryStep {
        let app = appLocale
        let prayer = prayerLocale
        return RosaryStep(
            name: LocalizedBundle.string("rosary.introduction.name", locale: app),
            title: LocalizedBundle.string("rosary.introduction.title", locale: app),
            scripture: LocalizedBundle.string("rosary.introduction.scripture", locale: app),
            beads: [
                StepBead(.crucifix, Prayers.credo(locale: prayer)),
                StepBead(.large, Prayers.paterNoster(locale: prayer)),
                StepBead(.small, Prayers.aveMaria(locale: prayer), title: LocalizedBundle.string("rosary.introduction.bead.aveMaria1", locale: app)),
                StepBead(.small, Prayers.aveMaria(locale: prayer), title: LocalizedBundle.string("rosary.introduction.bead.aveMaria2", locale: app)),
                StepBead(.small, Prayers.aveMaria(locale: prayer), title: LocalizedBundle.string("rosary.introduction.bead.aveMaria3", locale: app)),
                StepBead(.chain, Prayers.gloriaPatri(locale: prayer)),
            ]
        )
    }

    private static var finale: RosaryStep {
        let app = appLocale
        let prayer = prayerLocale
        return RosaryStep(
            name: LocalizedBundle.string("rosary.finale.name", locale: app),
            title: Prayers.salveRegina(locale: prayer).name,
            scripture: Prayers.salveRegina(locale: prayer).body
        )
    }

    private static func decade(
        name: String,
        title: String,
        scripture: String
    ) -> RosaryStep {
        let prayer = prayerLocale
        return RosaryStep(
            name: name,
            title: title,
            scripture: scripture,
            beads: [StepBead(.large, Prayers.paterNoster(locale: prayer))]
                + Array(repeating: StepBead(.small, Prayers.aveMaria(locale: prayer)), count: 10)
                + [StepBead(.chain, Prayers.gloriaPatriEtFatima(locale: prayer))]
        )
    }

    // MARK: Joyful — Monday, Saturday

    static var joyful: RosaryMystery {
        let app = appLocale
        return RosaryMystery(
            weekdays: [2, 7],
            name: LocalizedBundle.string("mysteries.joyful.name", locale: app),
            steps: [
                introduction,
                decade(
                    name: LocalizedBundle.string("mysteries.joyful.first.name", locale: app),
                    title: LocalizedBundle.string("mysteries.joyful.first.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.joyful.first.scripture", locale: app)
                ),
                decade(
                    name: LocalizedBundle.string("mysteries.joyful.second.name", locale: app),
                    title: LocalizedBundle.string("mysteries.joyful.second.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.joyful.second.scripture", locale: app)
                ),
                decade(
                    name: LocalizedBundle.string("mysteries.joyful.third.name", locale: app),
                    title: LocalizedBundle.string("mysteries.joyful.third.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.joyful.third.scripture", locale: app)
                ),
                decade(
                    name: LocalizedBundle.string("mysteries.joyful.fourth.name", locale: app),
                    title: LocalizedBundle.string("mysteries.joyful.fourth.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.joyful.fourth.scripture", locale: app)
                ),
                decade(
                    name: LocalizedBundle.string("mysteries.joyful.fifth.name", locale: app),
                    title: LocalizedBundle.string("mysteries.joyful.fifth.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.joyful.fifth.scripture", locale: app)
                ),
                finale,
            ]
        )
    }

    // MARK: Sorrowful — Tuesday, Friday

    static var sorrowful: RosaryMystery {
        let app = appLocale
        return RosaryMystery(
            weekdays: [3, 6],
            name: LocalizedBundle.string("mysteries.sorrowful.name", locale: app),
            steps: [
                introduction,
                decade(
                    name: LocalizedBundle.string("mysteries.sorrowful.first.name", locale: app),
                    title: LocalizedBundle.string("mysteries.sorrowful.first.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.sorrowful.first.scripture", locale: app)
                ),
                decade(
                    name: LocalizedBundle.string("mysteries.sorrowful.second.name", locale: app),
                    title: LocalizedBundle.string("mysteries.sorrowful.second.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.sorrowful.second.scripture", locale: app)
                ),
                decade(
                    name: LocalizedBundle.string("mysteries.sorrowful.third.name", locale: app),
                    title: LocalizedBundle.string("mysteries.sorrowful.third.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.sorrowful.third.scripture", locale: app)
                ),
                decade(
                    name: LocalizedBundle.string("mysteries.sorrowful.fourth.name", locale: app),
                    title: LocalizedBundle.string("mysteries.sorrowful.fourth.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.sorrowful.fourth.scripture", locale: app)
                ),
                decade(
                    name: LocalizedBundle.string("mysteries.sorrowful.fifth.name", locale: app),
                    title: LocalizedBundle.string("mysteries.sorrowful.fifth.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.sorrowful.fifth.scripture", locale: app)
                ),
                finale,
            ]
        )
    }

    // MARK: Glorious — Sunday, Wednesday

    static var glorious: RosaryMystery {
        let app = appLocale
        return RosaryMystery(
            weekdays: [1, 4],
            name: LocalizedBundle.string("mysteries.glorious.name", locale: app),
            steps: [
                introduction,
                decade(
                    name: LocalizedBundle.string("mysteries.glorious.first.name", locale: app),
                    title: LocalizedBundle.string("mysteries.glorious.first.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.glorious.first.scripture", locale: app)
                ),
                decade(
                    name: LocalizedBundle.string("mysteries.glorious.second.name", locale: app),
                    title: LocalizedBundle.string("mysteries.glorious.second.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.glorious.second.scripture", locale: app)
                ),
                decade(
                    name: LocalizedBundle.string("mysteries.glorious.third.name", locale: app),
                    title: LocalizedBundle.string("mysteries.glorious.third.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.glorious.third.scripture", locale: app)
                ),
                decade(
                    name: LocalizedBundle.string("mysteries.glorious.fourth.name", locale: app),
                    title: LocalizedBundle.string("mysteries.glorious.fourth.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.glorious.fourth.scripture", locale: app)
                ),
                decade(
                    name: LocalizedBundle.string("mysteries.glorious.fifth.name", locale: app),
                    title: LocalizedBundle.string("mysteries.glorious.fifth.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.glorious.fifth.scripture", locale: app)
                ),
                finale,
            ]
        )
    }

    // MARK: Luminous — Thursday

    static var luminous: RosaryMystery {
        let app = appLocale
        return RosaryMystery(
            weekdays: [5],
            name: LocalizedBundle.string("mysteries.luminous.name", locale: app),
            steps: [
                introduction,
                decade(
                    name: LocalizedBundle.string("mysteries.luminous.first.name", locale: app),
                    title: LocalizedBundle.string("mysteries.luminous.first.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.luminous.first.scripture", locale: app)
                ),
                decade(
                    name: LocalizedBundle.string("mysteries.luminous.second.name", locale: app),
                    title: LocalizedBundle.string("mysteries.luminous.second.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.luminous.second.scripture", locale: app)
                ),
                decade(
                    name: LocalizedBundle.string("mysteries.luminous.third.name", locale: app),
                    title: LocalizedBundle.string("mysteries.luminous.third.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.luminous.third.scripture", locale: app)
                ),
                decade(
                    name: LocalizedBundle.string("mysteries.luminous.fourth.name", locale: app),
                    title: LocalizedBundle.string("mysteries.luminous.fourth.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.luminous.fourth.scripture", locale: app)
                ),
                decade(
                    name: LocalizedBundle.string("mysteries.luminous.fifth.name", locale: app),
                    title: LocalizedBundle.string("mysteries.luminous.fifth.title", locale: app),
                    scripture: LocalizedBundle.string("mysteries.luminous.fifth.scripture", locale: app)
                ),
                finale,
            ]
        )
    }
}
