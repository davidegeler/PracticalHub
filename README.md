# PracticalHub (iOS)

SwiftUI + MVVM App mit 3 Tabs:
- Daily: Gym/Schule Übersicht
- Links: Schnellzugriff auf wichtige Webseiten
- LoL: Riot-API-Integration (über Proxy)

## Build
- Xcode 15/16+, iOS 17+
- Konfiguration: `Resources/Config.xcconfig`
  - `API_BASE_URL = https://<dein-proxy>`
- In `Info` (Target) existiert Key `API_BASE_URL` mit Wert `$(API_BASE_URL)`.

## Roadmap
- [ ] SwiftData für Links
- [ ] EventKit im Daily-Tab
- [ ] Swift Charts im LoL-Tab
- [ ] FastAPI-Proxy mit Cache/Rate-Limit
