//
//  QuantumLocalizedStrings.swift
//  SwiftQuantum v2.1.0 - Localization Support
//
//  Created by Eunmin Park on 2026-01-08.
//  Copyright © 2026 iOS Quantum Engineering. All rights reserved.
//
//  Provides type-safe access to localized strings
//  Default language: English (primary)
//  Supported languages: English, Korean, Japanese, Chinese (Simplified)
//

import Foundation

// MARK: - Localization Manager

/// Manages localization for SwiftQuantum
/// English is the default and primary language
public final class QuantumLocalization: @unchecked Sendable {

    /// Shared instance for localization
    public static let shared = QuantumLocalization()

    /// Current language code
    public private(set) var currentLanguageCode: String

    /// Supported language codes
    public static let supportedLanguages = ["en", "ko", "ja", "zh-Hans", "de"]

    /// Main bundle for localized resources
    private let mainBundle: Bundle

    /// Current language-specific bundle
    private var languageBundle: Bundle

    private init() {
        self.mainBundle = Bundle.module

        // Get saved language from UserDefaults, or use system language
        let savedLanguage = UserDefaults.standard.string(forKey: "SwiftQuantum_AppLanguage")
        let systemLangCode: String
        if #available(iOS 16, macOS 13, *) {
            systemLangCode = Locale.current.language.languageCode?.identifier ?? "en"
        } else {
            systemLangCode = Locale.current.languageCode ?? "en"
        }

        let langCode = savedLanguage ?? systemLangCode

        if QuantumLocalization.supportedLanguages.contains(langCode) {
            self.currentLanguageCode = langCode
        } else {
            self.currentLanguageCode = "en"
        }

        // Load the language-specific bundle
        self.languageBundle = Self.loadLanguageBundle(for: currentLanguageCode, from: mainBundle)
    }

    /// Loads the bundle for a specific language
    private static func loadLanguageBundle(for languageCode: String, from mainBundle: Bundle) -> Bundle {
        // Try to find the .lproj folder for this language
        let lprojName = languageCode == "zh-Hans" ? "zh-Hans" : languageCode

        if let path = mainBundle.path(forResource: lprojName, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle
        }

        // Fallback to English
        if let path = mainBundle.path(forResource: "en", ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle
        }

        // Last resort: use main bundle
        return mainBundle
    }

    /// Sets the current language
    /// - Parameter languageCode: Language code (e.g., "en", "ko", "ja", "zh-Hans", "de")
    public func setLanguage(_ languageCode: String) {
        if QuantumLocalization.supportedLanguages.contains(languageCode) {
            currentLanguageCode = languageCode
        } else {
            currentLanguageCode = "en"
        }
        // Reload the language bundle
        languageBundle = Self.loadLanguageBundle(for: currentLanguageCode, from: mainBundle)
    }

    /// Refreshes the language from UserDefaults (call when app becomes active or language changes)
    public func refreshLanguage() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "SwiftQuantum_AppLanguage"),
           QuantumLocalization.supportedLanguages.contains(savedLanguage) {
            if savedLanguage != currentLanguageCode {
                setLanguage(savedLanguage)
            }
        }
    }

    /// Gets a localized string
    /// - Parameter key: Localization key
    /// - Returns: Localized string or key if not found
    public func string(forKey key: String) -> String {
        // First try the language-specific bundle
        let result = NSLocalizedString(key, tableName: "Localizable", bundle: languageBundle, value: key, comment: "")
        return result
    }

    /// Gets a localized string with format arguments
    /// - Parameters:
    ///   - key: Localization key
    ///   - arguments: Format arguments
    /// - Returns: Formatted localized string
    public func string(forKey key: String, arguments: CVarArg...) -> String {
        let format = string(forKey: key)
        return String(format: format, arguments: arguments)
    }
}

// MARK: - Localized String Keys

/// Type-safe localized string keys for SwiftQuantum
public enum LocalizedKey: String, Sendable {

    // MARK: Core Framework
    case swiftquantumName = "swiftquantum.name"
    case swiftquantumVersion = "swiftquantum.version"
    case swiftquantumTagline = "swiftquantum.tagline"
    case swiftquantumCopyright = "swiftquantum.copyright"

    // MARK: Marketing
    case marketingHeadline = "marketing.headline"
    case marketingSubheadline = "marketing.subheadline"
    case marketingCatchphrase = "marketing.catchphrase"

    // MARK: Authority
    case authorityHarvardMIT = "authority.harvard_mit"
    case authorityFaultTolerant = "authority.fault_tolerant"
    case authorityContinuousOperation = "authority.continuous_operation"
    case authorityRealHardware = "authority.real_hardware"

    // MARK: Technical
    case techSimdOptimized = "tech.simd_optimized"
    case techAppleSilicon = "tech.apple_silicon"
    case techPerformance = "tech.performance"
    case techQubitsSupported = "tech.qubits_supported"
    case techGatesAvailable = "tech.gates_available"

    // MARK: Push Notifications
    case pushDecoherenceWarning = "push.decoherence_warning"
    case pushQuantumIntuitionDecay = "push.quantum_intuition_decay"
    case pushSuperpositionCollapse = "push.superposition_collapse"
    case pushEntanglementFading = "push.entanglement_fading"
    case pushBellPairAlert = "push.bell_pair_alert"

    // MARK: Loading Messages
    case loadingHarvardSync = "loading.harvard_sync"
    case loadingNeutralAtom = "loading.neutral_atom"
    case loadingSurfaceCode = "loading.surface_code"
    case loadingMagicState = "loading.magic_state"
    case loadingBlochSphere = "loading.bloch_sphere"
    case loadingTensorProduct = "loading.tensor_product"
    case loadingEigenvalue = "loading.eigenvalue"
    case loadingUnitary = "loading.unitary"
    case loadingFidelity = "loading.fidelity"
    case loadingIBMQuantum = "loading.ibm_quantum"

    // MARK: Achievements
    case achievementQuantumArchitect = "achievement.quantum_architect"
    case achievementCongratulations = "achievement.congratulations"
    case achievementEntanglementMaster = "achievement.entanglement_master"
    case achievementEntanglementDesc = "achievement.entanglement_desc"
    case achievementErrorCorrector = "achievement.error_corrector"
    case achievementErrorCorrectorDesc = "achievement.error_corrector_desc"
    case achievementGroverChampion = "achievement.grover_champion"
    case achievementGroverDesc = "achievement.grover_desc"

    // MARK: Paywall
    case paywallHeadline = "paywall.headline"
    case paywallDescription = "paywall.description"
    case paywallButton = "paywall.button"
    case paywallPriceMonthly = "paywall.price_monthly"
    case paywallPriceYearly = "paywall.price_yearly"

    // MARK: States
    case stateZero = "state.zero"
    case stateOne = "state.one"
    case statePlus = "state.plus"
    case stateMinus = "state.minus"
    case stateBell = "state.bell"
    case stateGHZ = "state.ghz"

    // MARK: Gates
    case gateHadamard = "gate.hadamard"
    case gateHadamardDesc = "gate.hadamard_desc"
    case gatePauliX = "gate.pauli_x"
    case gatePauliXDesc = "gate.pauli_x_desc"
    case gateCNOT = "gate.cnot"
    case gateCNOTDesc = "gate.cnot_desc"

    // MARK: Algorithms
    case algorithmBell = "algorithm.bell"
    case algorithmBellDesc = "algorithm.bell_desc"
    case algorithmDeutschJozsa = "algorithm.deutsch_jozsa"
    case algorithmDeutschJozsaDesc = "algorithm.deutsch_jozsa_desc"
    case algorithmGrover = "algorithm.grover"
    case algorithmGroverDesc = "algorithm.grover_desc"

    // MARK: UI
    case uiRun = "ui.run"
    case uiSimulate = "ui.simulate"
    case uiMeasure = "ui.measure"
    case uiReset = "ui.reset"
    case uiExport = "ui.export"
    case uiSettings = "ui.settings"
    case uiHelp = "ui.help"
    case uiAbout = "ui.about"

    // MARK: Errors
    case errorCircuitTooLarge = "error.circuit_too_large"
    case errorInvalidGate = "error.invalid_gate"
    case errorNotNormalized = "error.not_normalized"
    case errorConnectionFailed = "error.connection_failed"
    case errorAPIKeyInvalid = "error.api_key_invalid"

    // MARK: Success
    case successCircuitExecuted = "success.circuit_executed"
    case successJobSubmitted = "success.job_submitted"
    case successConnectionEstablished = "success.connection_established"

    /// Gets the localized string for this key
    public var localized: String {
        return QuantumLocalization.shared.string(forKey: rawValue)
    }
}

// MARK: - String Extension for Localization

extension String {

    /// Returns the localized version of this string using SwiftQuantum's localization
    public var quantumLocalized: String {
        return QuantumLocalization.shared.string(forKey: self)
    }
}

// MARK: - Loading Message Provider

/// Provides random loading messages for UI
public struct LoadingMessageProvider {

    /// All loading message keys
    private static let loadingKeys: [LocalizedKey] = [
        .loadingHarvardSync,
        .loadingNeutralAtom,
        .loadingSurfaceCode,
        .loadingMagicState,
        .loadingBlochSphere,
        .loadingTensorProduct,
        .loadingEigenvalue,
        .loadingUnitary,
        .loadingFidelity,
        .loadingIBMQuantum
    ]

    /// Returns a random localized loading message
    public static func randomMessage() -> String {
        let key = loadingKeys.randomElement() ?? .loadingHarvardSync
        return key.localized
    }

    /// Returns all loading messages
    public static func allMessages() -> [String] {
        return loadingKeys.map { $0.localized }
    }
}

// MARK: - Push Notification Messages

/// Provides push notification messages
public struct PushNotificationMessages {

    /// All push notification keys
    private static let pushKeys: [LocalizedKey] = [
        .pushDecoherenceWarning,
        .pushQuantumIntuitionDecay,
        .pushSuperpositionCollapse,
        .pushEntanglementFading,
        .pushBellPairAlert
    ]

    /// Returns a random localized push notification message
    public static func randomMessage() -> String {
        let key = pushKeys.randomElement() ?? .pushDecoherenceWarning
        return key.localized
    }

    /// Returns the decoherence warning message
    public static var decoherenceWarning: String {
        return LocalizedKey.pushDecoherenceWarning.localized
    }

    /// Returns all push notification messages
    public static func allMessages() -> [String] {
        return pushKeys.map { $0.localized }
    }
}

// MARK: - Achievement Messages

/// Provides achievement messages
public struct AchievementMessages {

    /// Creates a quantum architect achievement message
    public static var quantumArchitect: (title: String, description: String) {
        return (
            LocalizedKey.achievementQuantumArchitect.localized,
            LocalizedKey.achievementCongratulations.localized
        )
    }

    /// Creates an entanglement master achievement message
    public static var entanglementMaster: (title: String, description: String) {
        return (
            LocalizedKey.achievementEntanglementMaster.localized,
            LocalizedKey.achievementEntanglementDesc.localized
        )
    }

    /// Creates an error corrector achievement message
    public static var errorCorrector: (title: String, description: String) {
        return (
            LocalizedKey.achievementErrorCorrector.localized,
            LocalizedKey.achievementErrorCorrectorDesc.localized
        )
    }

    /// Creates a Grover champion achievement message
    public static var groverChampion: (title: String, description: String) {
        return (
            LocalizedKey.achievementGroverChampion.localized,
            LocalizedKey.achievementGroverDesc.localized
        )
    }
}

// MARK: - Paywall Messages

/// Provides paywall messages
public struct PaywallMessages {

    /// Headline for paywall
    public static var headline: String {
        return LocalizedKey.paywallHeadline.localized
    }

    /// Description for paywall
    public static var description: String {
        return LocalizedKey.paywallDescription.localized
    }

    /// Button text for paywall
    public static var buttonText: String {
        return LocalizedKey.paywallButton.localized
    }

    /// Monthly price text
    public static var monthlyPrice: String {
        return LocalizedKey.paywallPriceMonthly.localized
    }

    /// Yearly price text
    public static var yearlyPrice: String {
        return LocalizedKey.paywallPriceYearly.localized
    }
}
