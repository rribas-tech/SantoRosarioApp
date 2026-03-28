import SwiftUI

struct SettingsView: View {
    @AppStorage("appLanguage") private var appLanguage = ""
    @AppStorage("prayerLanguage") private var prayerLanguage = ""
    @Environment(\.dismiss) private var dismiss

    private let supportedLanguages: [(code: String, name: String)] = [
        ("", "Sistema / System"),
        ("pt-BR", "Português (Brasil)"),
        ("en", "English"),
        ("it", "Italiano"),
    ]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker(
                        LocalizedBundle.string("settings.language.app", locale: RosaryCatalog.appLocale),
                        selection: $appLanguage
                    ) {
                        ForEach(supportedLanguages, id: \.code) { language in
                            Text(language.name).tag(language.code)
                        }
                    }
                } footer: {
                    Text(LocalizedBundle.string("settings.language.app.footer", locale: RosaryCatalog.appLocale))
                }

                Section {
                    Picker(
                        LocalizedBundle.string("settings.language.prayer", locale: RosaryCatalog.appLocale),
                        selection: $prayerLanguage
                    ) {
                        ForEach(supportedLanguages, id: \.code) { language in
                            Text(language.name).tag(language.code)
                        }
                    }
                } footer: {
                    Text(LocalizedBundle.string("settings.language.prayer.footer", locale: RosaryCatalog.appLocale))
                }
            }
            .navigationTitle(LocalizedBundle.string("settings.title", locale: RosaryCatalog.appLocale))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(LocalizedBundle.string("settings.done", locale: RosaryCatalog.appLocale)) {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
}
