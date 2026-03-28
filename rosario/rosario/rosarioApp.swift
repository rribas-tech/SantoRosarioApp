import SwiftUI

@main
struct RosarioApp: App {
    @AppStorage("appLanguage") private var appLanguage = ""

    var body: some Scene {
        WindowGroup {
            RosaryView()
                .preferredColorScheme(.dark)
                .environment(\.locale, locale)
        }
    }

    private var locale: Locale {
        appLanguage.isEmpty
            ? .current
            : Locale(identifier: appLanguage)
    }
}
