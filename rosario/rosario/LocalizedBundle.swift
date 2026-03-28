import Foundation

enum LocalizedBundle {
    static func bundle(for locale: Locale) -> Bundle {
        let language = locale.language.languageCode?.identifier ?? "pt-BR"
        let region = locale.language.region?.identifier

        // Try language-region first (e.g. pt-BR), then language only (e.g. pt)
        let candidates: [String]
        if let region {
            candidates = ["\(language)-\(region)", language]
        } else {
            candidates = [language]
        }

        for candidate in candidates {
            if let path = Bundle.main.path(forResource: candidate, ofType: "lproj"),
               let bundle = Bundle(path: path) {
                return bundle
            }
        }

        return .main
    }

    static func string(_ key: String.LocalizationValue, locale: Locale) -> String {
        String(localized: key, bundle: bundle(for: locale))
    }
}
