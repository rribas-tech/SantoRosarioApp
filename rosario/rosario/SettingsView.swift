import SwiftUI

struct SettingsView: View {
    @AppStorage("appLanguage") private var appLanguage = ""
    @Environment(\.dismiss) private var dismiss

    private let supportedLanguages: [(code: String, name: String)] = [
        ("", "Sistema / System"),
        ("pt-BR", "Português (Brasil)"),
        ("en", "English"),
    ]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker(
                        String(localized: "settings.language"),
                        selection: $appLanguage
                    ) {
                        ForEach(supportedLanguages, id: \.code) { language in
                            Text(language.name).tag(language.code)
                        }
                    }
                } footer: {
                    Text(String(localized: "settings.language.footer"))
                }
            }
            .navigationTitle(String(localized: "settings.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "settings.done")) {
                        dismiss()
                    }
                }
            }
        }
        .onChange(of: appLanguage) {
            if appLanguage.isEmpty {
                UserDefaults.standard.removeObject(forKey: "AppleLanguages")
            } else {
                UserDefaults.standard.set([appLanguage], forKey: "AppleLanguages")
            }
        }
    }
}

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
}
