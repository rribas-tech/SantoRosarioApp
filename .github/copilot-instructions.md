# Santo Rosário — Project Rules

## Code

- Swift 6 patterns only: `@Observable`, `@State`, no Combine, no `ObservableObject`
- `@MainActor` default isolation via build settings — do not annotate manually
- Minimal code: no unnecessary abstractions, helpers, or wrappers
- Robust by simplicity: avoid edge cases by design, not by handling them
- English for code, Portuguese (pt-BR) for user-facing strings

## Architecture

- Flat file structure under `rosario/rosario/`
- Each file has one clear responsibility
- No third-party dependencies

## Official References

- https://developer.apple.com/documentation/swift/adoptingswift6
- https://www.swift.org/migration/documentation/migrationguide/
- https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass
- https://developer.apple.com/documentation/technologyoverviews/interface-fundamentals
- https://developer.apple.com/documentation/technologyoverviews/swiftui
- https://developer.apple.com/documentation/technologyoverviews/games
- https://developer.apple.com/documentation/swiftui/preparing-views-for-localization
