# Änderungsprotokoll

Alle bemerkenswerten Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
und dieses Projekt hält sich an [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.2.4] - 2026-01-18

### Hinzugefügt
- **IBM Quantum Ecosystem vollständige Lokalisierung**
  - Alle 12 Ecosystem-Projektnamen und -beschreibungen lokalisiert (EN, KO, JA, ZH, DE)
  - Kategorielabels (Maschinelles Lernen, Chemie, Optimierung, Hardware, Simulation, Forschung)
  - `QuantumEcosystemProject`-Modell refaktoriert zur Verwendung von `nameKey` und `descriptionKey`
  - `EcosystemCategory` Enum mit `localizationKey`-Eigenschaft
  - `EcosystemProjectCard`, `EcosystemProjectDetailSheet`, `EcosystemCodeExportSheet` lokalisiert

- **Abo-System komplett neu gestaltet**
  - Tab-basierte Vergleichs-UI (Vergleichen, Pro, Premium Tabs)
  - `SubscriptionPlan` Enum mit 4 verschiedenen Plänen (proMonthly, proYearly, premiumMonthly, premiumYearly)
  - Funktionsvergleichstabelle mit Free/Pro/Premium-Spalten
  - Planauswahlkarten mit Monatlich/Jährlich-Umschalter
  - Alle Abo-UI in 5 Sprachen lokalisiert

- **Abo-Info-Seite (Mehr-Tab)**
  - Neue `SubscriptionInfoView` mit Tier-Vergleich
  - Hero-Bereich mit Premium-Freischaltungsnachricht
  - Pro vs Premium Tier-Karten nebeneinander
  - Vollständige Funktionsliste mit Icons und Beschreibungen
  - Ein-Tipp-Zugang zu PaywallView
  - Neue Einstellungszeile im Mehr-Tab: "Abo-Info"
  - Alle Strings lokalisiert (EN, KO, JA, ZH, DE)

- **Neue Lokalisierungsschlüssel (5 Sprachen)**
  - `subscription.info.title`, `subscription.info.subtitle`, `subscription.info.choose_tier`
  - `subscription.info.best_value`, `subscription.info.pro.feature1-3`, `subscription.info.premium.feature1-3`
  - `subscription.info.all_features`, `subscription.info.feature.qpu/academy/industry/error/support`
  - `subscription.info.subscribe_now`, `subscription.info.cancel_anytime`
  - `ecosystem.category.*`, `ecosystem.project.*`, `ecosystem.project.*.desc`

### Behoben
- **Textabschneidung in Benefit-Beschreibungen**
  - `IndustryHubView.heroBenefitRow`: `lineLimit(1)` zu `fixedSize(horizontal: false, vertical: true)` geändert
  - `PresetsHubView.heroBenefitRow`: Gleiche Korrektur angewendet
  - Hero-Bereiche zeigen jetzt vollständigen Text in allen Sprachen ohne "..."-Abschneidung

### Geändert
- **Ecosystem-Projektmodell**: Verwendet jetzt Lokalisierungsschlüssel anstelle von hartcodierten englischen Strings
- **PaywallView**: Komplett neu geschrieben mit Tab-basiertem Abo-Vergleich
- **MoreHubView**: Abo-Info-Eintrag im Einstellungsbereich hinzugefügt

---

## [2.2.3] - 2026-01-18

### Hinzugefügt
- **Authentifizierungsbildschirm-Lokalisierung**
  - Login-, Anmeldungs-, Passwort-Zurücksetzen-Bildschirme vollständig lokalisiert
  - Alle Formularfelder (E-Mail, Benutzername, Passwort) lokalisiert
  - Fehlermeldungen und Validierungstext in 5 Sprachen
  - Auth-Bildschirme verwenden jetzt echtes App-Icon statt SF-Symbol

- **Premium-Abo-Paywall neu gestaltet**
  - Komplette UI-Überarbeitung mit Tier- und Periodenauswahl
  - Tier-Auswahl: Pro vs Premium mit visuellen Indikatoren
  - Periodenauswahl: Monatlich vs Jährlich mit 33% Rabatt-Badge
  - Dynamische Funktionslisten basierend auf ausgewähltem Tier
  - Lokalisierte Preise und Beschreibungen

- **Abo-Lokalisierungsschlüssel (5 Sprachen)**
  - `subscription.title`, `subscription.subtitle`, `subscription.choose_plan`
  - `subscription.pro/premium`, `subscription.monthly/yearly`
  - `subscription.pro.feature1-4`, `subscription.premium.feature1-5`
  - `subscription.pro/premium.desc_monthly/yearly`
  - `subscription.subscribe`, `subscription.restore`, `subscription.legal`

- **Industry-Karten-Lokalisierung**
  - Alle 6 Industry-Karten vollständig lokalisiert (Finanzen, Gesundheitswesen, Logistik, Energie, Fertigung, KI)
  - Industry-Benefit-Beschreibungen in allen Sprachen lokalisiert

### Geändert
- **Industry Hero-Bereich**: Hartcodierte Statistiken durch intuitive Benefit-Beschreibungen ersetzt
- **Circuits Hero-Bereich**: Hartcodierte Statistiken durch Benefit-Beschreibungen ersetzt
- **Academy Hero-Bereich**: Verwendet jetzt echtes App-Icon mit Schatteneffekt

---

## [2.2.1] - 2026-01-16

### Hinzugefügt
- **Echtzeit-Sprachumschaltung**
  - Sofortige UI-Aktualisierung ohne App-Neustart
  - `LocalizationManager` mit `@MainActor` lokalisierten Eigenschaften
  - MainActor-Isolationsprobleme in `QuantumHub` Enum behoben

- **Mehr-Tab Backend-Integration**
  - `UserStatsManager` zum Abrufen von Benutzerstatistiken vom Backend
  - `SafariWebView` für In-App-Web-Einstellungsseiten
  - Einstellungselemente (Benachrichtigungen, Erscheinungsbild, Datenschutz, Hilfe) → Web-URLs
  - Backend-verbundene Schnellstatistiken mit UserDefaults-Fallback

---

## [2.2.0] - 2026-01-13

### Hinzugefügt
- **Backend-Integration mit Apple App Store Server API v2**
  - `APIClient.swift`: Vollständige Backend-API-Kommunikationsschicht
  - JWT-basierte Authentifizierung mit Apple-Servern
  - Transaktionsverifikationsfluss von iOS zum Backend

- **StoreKit 2 Premium-System**
  - `PremiumManager.swift`: Vollständige StoreKit 2-Integration mit Backend-Verifikation
  - Automatische Transaktionsverifikation nach dem Kauf
  - Abo-Status-Persistenz und -Wiederherstellung

- **Deutsche Lokalisierung (de.lproj)**
  - Vollständige Übersetzung aller UI-Strings
  - Unterstützt jetzt 5 Sprachen: EN, KO, JA, ZH-Hans, DE

---

## [2.1.0] - 2026-01-06

### Hinzugefügt
- **QuantumExecutor-Protokoll** - Hybrid-Ausführungssystem
  - `LocalQuantumExecutor`: Lokale Simulation mit optionaler Fehlerkorrektur
  - `QuantumBridgeExecutor`: Echte Quantenhardware über IBM Quantum API
  - Einheitliche Schnittstelle für nahtlosen Wechsel zwischen lokaler und Cloud-Ausführung

- **Fehlertolerante Simulation** (Harvard-MIT 2025 Forschung)
  - Surface-Code-Fehlerkorrektur basierend auf Nature 2025-Publikationen
  - 448-Qubit fehlertolerante Architektur-Simulation
  - Unter 0,5% logische Fehlerrate-Modellierung

- **4-Hub-Navigation** (Apple HIG Integration)
  - `LabHubView.swift`: Steuerung + Messung + Info
  - `PresetsHubView.swift`: Presets + Beispiele
  - `FactoryHubView.swift`: Bridge (QPU-Verbindung)
  - `MoreHubView.swift`: Academy + Industry + Profil

---

[2.2.4]: https://github.com/Minapak/SwiftQuantum/compare/v2.2.3...v2.2.4
[2.2.3]: https://github.com/Minapak/SwiftQuantum/compare/v2.2.1...v2.2.3
[2.2.1]: https://github.com/Minapak/SwiftQuantum/compare/v2.2.0...v2.2.1
[2.2.0]: https://github.com/Minapak/SwiftQuantum/compare/v2.1.1...v2.2.0
[2.1.0]: https://github.com/Minapak/SwiftQuantum/compare/v2.0.0...v2.1.0
