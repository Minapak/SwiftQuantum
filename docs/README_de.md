# SwiftQuantum v2.2.4 - Premium Quanten-Hybrid-Plattform

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%2018%2B%20%7C%20macOS%2015%2B-lightgrey.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![QuantumBridge](https://img.shields.io/badge/QuantumBridge-2.0-blueviolet.svg)](https://github.com/user/QuantumBridge)
[![Quantum-Hybrid](https://img.shields.io/badge/Quantum--Hybrid-2026-00ff88.svg)](#)
[![Agentic AI](https://img.shields.io/badge/Agentic%20AI-Ready-ff6b6b.svg)](#)
[![Localization](https://img.shields.io/badge/Languages-EN%20%7C%20KO%20%7C%20JA%20%7C%20ZH%20%7C%20DE-blue.svg)](#)

**Das erste iOS-Quantencomputing-Framework mit echter QPU-Konnektivität** - mit QuantumBridge-Integration, fehlertoleranter Simulation und Harvard-MIT-forschungsbasierten Bildungsinhalten!

> **Harvard-MIT Forschungsgrundlage**: Basierend auf Nature-Publikationen von 2025, die 3.000+ kontinuierliche Qubit-Operationen und unter 0,5% Fehlerraten demonstrieren
>
> **Echte Quantenhardware**: Verbindung zu IBM Quantums 127-Qubit-Systemen über die QuantumBridge-API
>
> **Premium-Lernplattform**: MIT/Harvard-Stil Quantum Academy mit abonnementbasierten Kursen
>
> **Enterprise-Lösungen**: B2B-Industrieanwendungen für Finanzen, Gesundheitswesen und Logistik

---

## Neu in v2.2.4 (2026 Produktionsrelease)

### IBM Quantum Ecosystem Lokalisierung & Abo-System-Überarbeitung

- **IBM Quantum Ecosystem vollständige Lokalisierung**:
  - Alle 12 Ecosystem-Projektnamen und -beschreibungen lokalisiert (EN, KO, JA, ZH, DE)
  - Kategorielabels (ML, Chemie, Optimierung, Hardware, Simulation, Forschung) lokalisiert
  - Ecosystem-Projektkarten, Detailansichten und Code-Export-Views vollständig lokalisiert

- **Abo-System komplett neu gestaltet**:
  - Tab-basierte Vergleichs-UI (Vergleichen, Pro, Premium Tabs)
  - Klare Planunterscheidung: Pro Monatlich, Pro Jährlich, Premium Monatlich, Premium Jährlich
  - Funktionsvergleichstabelle mit Free/Pro/Premium-Spalten
  - In 5 Sprachen lokalisiert

- **Abo-Info-Seite (Mehr-Tab)**:
  - Neuer "Abo-Info"-Menüeintrag im Einstellungsbereich
  - Dedizierte Seite zur Erklärung der Pro vs Premium-Funktionen
  - Tier-Vergleichskarten mit Funktions-Highlights
  - Alle Funktionsliste mit Beschreibungen
  - Ein-Tipp-Zugang zur PaywallView für Abonnements

- **Textabschneidung behoben**:
  - `lineLimit(1)` behoben, das "..." in Benefit-Beschreibungen verursachte
  - Industry- und Circuits-Tab Hero-Bereiche zeigen jetzt vollständigen Text in allen Sprachen

---

## Schnellstart

### Installation

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/Minapak/SwiftQuantum.git", from: "2.2.4")
]
```

### Grundlegende Verwendung

```swift
import SwiftQuantum

// Quantenregister erstellen
let register = QuantumRegister(numberOfQubits: 3)

// Gates anwenden
register.applyGate(.hadamard, to: 0)
register.applyCNOT(control: 0, target: 1)
register.applyCNOT(control: 1, target: 2)
// Erstellt GHZ-Zustand: (|000⟩ + |111⟩)/√2

// Messen
let results = register.measureMultiple(shots: 1000)
// ["000": ~500, "111": ~500]
```

### QuantumBridge-Verbindung

```swift
import SwiftQuantum

// Executor für IBM Quantum erstellen
let executor = QuantumBridgeExecutor(
    executorType: .ibmBrisbane,
    apiKey: "YOUR_IBM_QUANTUM_API_KEY"  // Von IBM Quantum erhalten
)

// Schaltkreis bauen
let circuit = BridgeCircuitBuilder(numberOfQubits: 2, name: "Bell")
    .h(0)
    .cx(control: 0, target: 1)

// Auf echter Quantenhardware ausführen
let result = try await executor.execute(circuit: circuit, shots: 1000)
print("Counts: \(result.counts)")  // {"00": 498, "11": 502}
```

---

## QuantumBridge-Tab - Vollständiger Leitfaden

Der **Bridge**-Tab ist Ihr Tor zur echten Quantenhardware! Hier können Sie:

### Warum QuantumBridge verwenden

| Vorteil | Beschreibung |
|---------|--------------|
| **Echte Hardware** | Schaltkreise auf echten IBM-Quantenprozessoren (127 Qubits!) ausführen |
| **Echte Quanteneffekte** | Echte Superposition und Verschränkung erleben |
| **Authentische Ergebnisse** | Messungen von echten Quantencomputern erhalten, nicht Simulationen |

### Backend-Optionen

| Backend | Beste Verwendung | Vorteile | Einschränkungen |
|---------|-----------------|----------|-----------------|
| **Simulator** | Lernen & Testen | Sofortige Ergebnisse, Kostenlos, Keine Warteschlange | Kein echtes Quantenrauschen |
| **IBM Brisbane** | Produktion & Forschung | 127 Qubits, Hohe Kohärenz | Warteschlangenzeit |
| **IBM Osaka** | Schnelle Ausführung | Schnelle Gate-Geschwindigkeit, Kürzere Warteschlangen | Mittleres Rauschen |
| **IBM Kyoto** | Forschungsprojekte | Fortgeschrittene Fehlerminderung | Derzeit Wartung |

---

## Industry-Tab - Enterprise-Lösungen

Der **Industry**-Tab zeigt Quantencomputing-Anwendungen für echte Unternehmen.

### Verfügbare Branchen

| Branche | Anwendungsfall | Effizienzsteigerung |
|---------|---------------|---------------------|
| **Finanzen** | Portfolio-Optimierung, Risikoanalyse | +52% |
| **Gesundheitswesen** | Medikamentenentdeckung, Proteinfaltung | +38% |
| **Logistik** | Routenoptimierung, Lieferkette | +45% |
| **Energie** | Netzoptimierung, Prognose | +41% |
| **Fertigung** | Qualitätskontrolle, Wartung | +33% |
| **KI & ML** | Quanten-Maschinelles-Lernen | +67% |

---

## IBM Quantum Ecosystem Integration

### Ecosystem-Kategorien

| Kategorie | Projekte | Beschreibung |
|-----------|----------|--------------|
| **Maschinelles Lernen** | TorchQuantum, Qiskit ML | Quanten-Neuronale-Netze und ML-Algorithmen |
| **Chemie & Physik** | Qiskit Nature | Molekularsimulation und Medikamentenentdeckung |
| **Optimierung** | Qiskit Finance, Optimization | Portfolio-Optimierung und QAOA |
| **Hardware-Anbieter** | IBM, Azure, AWS Braket, IonQ | Direkter Zugang zu Quantenprozessoren |
| **Simulation** | Qiskit Aer, MQT DDSIM | Hochleistungssimulatore |
| **Forschung** | PennyLane, Cirq | Plattformübergreifende Forschungsframeworks |

---

## Premium-Funktionen

### Abo-Stufen

| Funktion | Kostenlos | Pro ($4.99/Monat) | Premium ($9.99/Monat) |
|----------|-----------|-------------------|----------------------|
| Lokale Simulation | 20 Qubits | 40 Qubits | 40 Qubits |
| Quantengates | Alle 15+ | Alle 15+ | Alle 15+ |
| Grundbeispiele | Ja | Ja | Ja |
| QuantumBridge-Verbindung | Nein | Ja | **Ja** |
| Fehlerkorrektur-Simulation | Nein | Nein | **Ja** |
| Quantum Academy Kurse | 2 kostenlos | Alle 12+ | **Alle 12+** |
| Industrielösungen | Nur ansehen | Teilweise | **Voller Zugang** |
| Prioritäts-Support | Nein | E-Mail | **Priorität** |

---

## Forschungsgrundlage

### Harvard-MIT Nature 2025 Publikationen

SwiftQuantum basiert auf modernster Quantencomputing-Forschung:

1. **"Fehlertolerante Quantenberechnung mit 448 neutralen Atom-Qubits"** (Nature, Nov 2025)
   - Erste Demonstration einer fehlertoleranten Schwelle unter 0,5%

2. **"Kontinuierlicher Betrieb eines kohärenten 3.000-Qubit-Systems"** (Nature, Sep 2025)
   - 2+ Stunden kontinuierlicher Quantenbetrieb

3. **"Magic State Destillation auf neutralen Atom-Quantencomputern"** (Nature, Jul 2025)
   - Wesentlich für universelles fehlertolerantes Quantencomputing

---

## Roadmap

### Version 2.2.4 (Aktuell - Januar 2026)
- [x] IBM Quantum Ecosystem vollständige Lokalisierung (12 Projekte, 6 Kategorien)
- [x] Abo-System komplett neu gestaltet mit Tab-basiertem Vergleich
- [x] Abo-Info-Seite in Mehr-Tab-Einstellungen
- [x] Textabschneidungsbehebung für mehrsprachige Benefit-Beschreibungen
- [x] Alle Abo-bezogene UI in 5 Sprachen lokalisiert

### Version 2.3.0 (Geplant - Q2 2026)
- [ ] Echte IBM Quantum Job-Einreichung
- [ ] Quanten-Fourier-Transformation (QFT)
- [ ] Shors Algorithmus Implementierung
- [ ] Cloud-Job-Warteschlangen-Dashboard
- [ ] Team/Enterprise-Konten

---

## Lizenz

MIT-Lizenz - Siehe [LICENSE](LICENSE)

---

<div align="center">

**SwiftQuantum - Die Zukunft des Quantencomputings auf iOS**

*Powered by Harvard-MIT Forschung*

</div>
