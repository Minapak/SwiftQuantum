# SwiftQuantum iOS App - Vollständige Funktionsdokumentation

**Version**: 2.2.4
**Plattform**: iOS 18+ / macOS 15+
**Sprachen**: Englisch, Koreanisch, Japanisch, Chinesisch (vereinfacht), Deutsch

---

## Übersicht

SwiftQuantum ist eine Premium-Quantencomputing-Plattform für iOS, die lokale Simulation, echte IBM Quantum Hardware-Konnektivität und Bildungsinhalte kombiniert. Die App verwendet ein 4-Hub-Navigationssystem basierend auf den Apple Human Interface Guidelines.

### Navigationsstruktur

| Hub | Tab-Name | Symbol | Beschreibung |
|-----|----------|--------|--------------|
| 1 | Lab | `atom` | Quantenzustandskontrolle und -messung |
| 2 | Circuits | `square.grid.3x3` | Vorgefertigte Schaltkreisvorlagen und Builder |
| 3 | Factory | `cpu.fill` | QuantumBridge QPU-Verbindung |
| 4 | More | `ellipsis` | Academy, Industry, Profil, Einstellungen |

---

## Tab 1: Lab Hub

Der Lab Hub ist die zentrale Quantenexperimentierungsschnittstelle, die Steuerungs-, Mess- und Informationspanels kombiniert.

### 1.1 Steuerungspanel

**Zweck**: Quantenzustände durch Wahrscheinlichkeits- und Phasensteuerung manipulieren.

| Funktion | Beschreibung | Interaktion |
|----------|--------------|-------------|
| Wahrscheinlichkeitsregler | Passt |0⟩ und |1⟩ Wahrscheinlichkeitsamplituden an | Regler 0-100% ziehen |
| Phasenregler | Steuert relative Phase zwischen Zuständen | Regler 0-2π ziehen |
| Bloch-Kugel | 3D-Visualisierung des Qubit-Zustands | Drehen, Zoom-Gesten |
| Zustandsvektoranzeige | Zeigt α|0⟩ + β|1⟩ Notation | Nur lesen |

**Verfügbare Quantengatter**:

| Gatter | Symbol | Matrix | Effekt |
|--------|--------|--------|--------|
| Hadamard | H | 1/√2 [[1,1],[1,-1]] | Erzeugt Superposition |
| Pauli-X | X | [[0,1],[1,0]] | Bit-Flip (NOT) |
| Pauli-Y | Y | [[0,-i],[i,0]] | Bit + Phasen-Flip |
| Pauli-Z | Z | [[1,0],[0,-1]] | Phasen-Flip |
| S-Gatter | S | [[1,0],[0,i]] | π/2 Phase |
| T-Gatter | T | [[1,0],[0,e^(iπ/4)]] | π/8 Phase |

### 1.2 Messpanel

**Zweck**: Quantenmessungen durchführen und statistische Ergebnisse anzeigen.

| Funktion | Beschreibung | Ausgabe |
|----------|--------------|---------|
| Einzelschuss | Zustand zu |0⟩ oder |1⟩ kollabieren | Einzelergebnis |
| Mehrfachschuss | Mehrere Messungen ausführen | Histogramm |
| Schussanzahl | 10-10000 Schüsse konfigurieren | Regler |
| Ergebnisverlauf | Vergangene Messungen anzeigen | Scrollbare Liste |

---

## Tab 2: Circuits Hub (Presets)

Der Circuits Hub bietet vorgefertigte Quantenschaltkreisvorlagen und einen Schaltkreis-Builder.

### 2.1 Schnellstartbereich

**Zweck**: Ein-Tipp-Zugang zu gängigen Quantenschaltkreisen.

| Schaltkreis | Qubits | Beschreibung |
|-------------|--------|--------------|
| Bell-Zustand | 2 | Erzeugt maximal verschränktes Paar |
| GHZ-Zustand | 3 | Drei-Qubit-Verschränkung |
| Superposition | 1 | Einzelnes Qubit im |+⟩ Zustand |
| Bit-Flip | 1 | X-Gatter-Demonstration |

### 2.2 Schaltkreisvorlagen

**Vollständige Vorlagenbibliothek**:

| Vorlage | Qubits | Gatter | Schwierigkeit | Premium |
|---------|--------|--------|---------------|---------|
| Grundlegende Superposition | 1 | 1 | Anfänger | Kostenlos |
| Bell-Zustand | 2 | 2 | Anfänger | Kostenlos |
| GHZ-Zustand | 3 | 3 | Anfänger | Kostenlos |
| Phasenschätzung | 4 | 12 | Mittel | Pro |
| Grovers Algorithmus | 3 | 15 | Mittel | Pro |
| Quanten-Fourier-Transformation | 4 | 20 | Fortgeschritten | Premium |
| Shors Algorithmus (Demo) | 5 | 50+ | Fortgeschritten | Premium |

---

## Tab 3: Factory Hub (Bridge)

Der Factory Hub verbindet sich über QuantumBridge mit echten IBM Quantencomputern.

### 3.1 Verbindungsstatus

| Status | Symbol | Beschreibung |
|--------|--------|--------------|
| Verbunden | Grüner Punkt | Aktive Verbindung zum Backend |
| Getrennt | Grauer Punkt | Keine aktive Verbindung |
| Verbinde | Spinner | Verbindung wird hergestellt |
| Fehler | Roter Punkt | Verbindung fehlgeschlagen |

### 3.2 Backend-Auswahl

**Verfügbare Backends**:

| Backend | Qubits | Beste Verwendung | Wartezeit |
|---------|--------|-----------------|-----------|
| **Lokaler Simulator** | 20 | Testen | Sofort |
| **IBM Brisbane** | 127 | Produktion | 5-30 Min. |
| **IBM Osaka** | 127 | Schnelle Experimente | 2-15 Min. |
| **IBM Kyoto** | 127 | Forschung | 10-60 Min. |

### 3.3 Schnellaktionen

| Aktion | Beschreibung | Premium |
|--------|--------------|---------|
| **Bell-Zustand** | 2-Qubit-Verschränkung erstellen | Pro |
| **GHZ-Zustand** | 3-Qubit-Verschränkung erstellen | Pro |
| **QASM exportieren** | Schaltkreis als OpenQASM 3.0 kopieren | Kostenlos |
| **Dauermodus** | Alle 30 Sekunden automatisch wiederholen | Premium |

---

## Tab 4: More Hub

Der More Hub kombiniert Academy, Industry, Profil und Einstellungen.

### 4.1 Navigationskarten

| Karte | Untertitel | Badge | Ziel |
|-------|------------|-------|------|
| **Academy** | Quantencomputing lernen | N Fertig / Login | AcademyMarketingView |
| **Industry** | Enterprise-Lösungen | Premium | IndustryDetailView |
| **Profile** | Ihre Quantenreise | Admin / Login | ProfileDetailView |

### 4.2 Industry-Detailansicht

#### Industry-Lösungskarten

| Branche | Symbol | Effizienzsteigerung | Anwendungsfälle |
|---------|--------|---------------------|-----------------|
| **Finanzen** | chart.line.uptrend.xyaxis | +52% | Portfolio, Risiko, Betrug, HFT |
| **Gesundheitswesen** | cross.case.fill | +38% | Medikamentenentdeckung, Proteinfaltung |
| **Logistik** | truck.box.fill | +45% | Routenoptimierung, Lieferkette |
| **Energie** | bolt.fill | +41% | Netzoptimierung, Prognose |
| **Fertigung** | gearshape.2.fill | +33% | Qualitätskontrolle, Wartung |
| **KI & ML** | brain | +67% | Quanten-Neuronale-Netze |

### 4.3 Einstellungsbereich

| Einstellung | Symbol | Aktion |
|-------------|--------|--------|
| **Sprache** | globe | LanguageSelectionSheet öffnen |
| **Benachrichtigungen** | bell.fill | Web-Einstellungen öffnen |
| **Erscheinungsbild** | paintbrush.fill | Web-Einstellungen öffnen |
| **Datenschutz** | lock.fill | Datenschutzrichtlinie öffnen |
| **Tutorial zurücksetzen** | arrow.counterclockwise | Onboarding zurücksetzen |
| **Hilfe & Support** | questionmark.circle.fill | Support-Seite öffnen |
| **Abo-Info** | crown.fill | SubscriptionInfoView öffnen |

### 4.4 Abo-Info-Ansicht

**Zweck**: Pro vs Premium-Funktionen für Nicht-Abonnenten erklären.

| Bereich | Inhalt |
|---------|--------|
| **Hero** | Kronen-Symbol, Titel, Untertitel |
| **Tier-Karten** | Pro vs Premium nebeneinander |
| **Funktionsliste** | 5 Premium-Funktionen mit Beschreibungen |
| **CTA** | "Jetzt abonnieren"-Button → PaywallView |

---

## Abo-System

### PaywallView

**Tab-basierte UI**:

| Tab | Inhalt |
|-----|--------|
| **Vergleichen** | Funktionsvergleichstabelle (Free/Pro/Premium) |
| **Pro** | Pro-Plandetails und Kauf |
| **Premium** | Premium-Plandetails und Kauf |

**Funktionsvergleichstabelle**:

| Funktion | Kostenlos | Pro | Premium |
|----------|-----------|-----|---------|
| Quantenschaltkreise | ✓ | ✓ | ✓ |
| Lokale Simulation | ✓ | ✓ | ✓ |
| Academy (Basis) | ✓ | ✓ | ✓ |
| Academy (Voll) | - | ✓ | ✓ |
| Echter QPU-Zugang | - | ✓ | ✓ |
| Industrielösungen | - | - | ✓ |
| E-Mail-Support | - | ✓ | ✓ |
| Prioritäts-Support | - | - | ✓ |

---

## Authentifizierungssystem

### Login-Ansicht

| Feld | Validierung |
|------|-------------|
| E-Mail | E-Mail-Format erforderlich |
| Passwort | 8+ Zeichen |

**Aktionen**: Login, Passwort vergessen, Registrierungslink

### Registrierungsansicht

| Feld | Validierung |
|------|-------------|
| Benutzername | 3-20 Zeichen |
| E-Mail | E-Mail-Format erforderlich |
| Passwort | 8+ Zeichen, 1 Großbuchstabe, 1 Zahl |
| Passwort bestätigen | Muss übereinstimmen |

---

## Lokalisierung

### Unterstützte Sprachen

| Sprache | Code | Status |
|---------|------|--------|
| Englisch | en | Standard |
| Koreanisch | ko | Vollständig |
| Japanisch | ja | Vollständig |
| Chinesisch (vereinfacht) | zh-Hans | Vollständig |
| Deutsch | de | Vollständig |

---

## Technische Spezifikationen

### Mindestanforderungen

| Anforderung | Spezifikation |
|-------------|---------------|
| iOS-Version | 18.0+ |
| macOS-Version | 15.0+ |
| Swift-Version | 6.0 |
| Xcode-Version | 16.0+ |

---

## Versionshistorie

| Version | Datum | Highlights |
|---------|-------|------------|
| 2.2.4 | 2026-01-18 | Ecosystem-Lokalisierung, Abo-Neugestaltung |
| 2.2.3 | 2026-01-18 | Auth-Lokalisierung, Paywall-Neugestaltung |
| 2.2.2 | 2026-01-17 | Bridge-Info-Toggle, Build-Fixes |
| 2.2.1 | 2026-01-16 | Echtzeit-Lokalisierung, Backend-Integration |
| 2.2.0 | 2026-01-13 | StoreKit 2, Deutsche Lokalisierung |

---

*Dokumentation erstellt für SwiftQuantum v2.2.4*
