//
//  LocalizationManager.swift
//  SuperpositionVisualizer
//
//  SwiftQuantum Language Management
//  Supports: English, Korean, Japanese, Chinese, German
//

import SwiftUI
import SwiftQuantum

// MARK: - Global Localization Helper
/// Global helper function for easy localization access
/// Usage: L("key.name") returns localized string
@MainActor
func L(_ key: String) -> String {
    return LocalizationManager.shared.string(forKey: key)
}

// MARK: - Supported Languages
enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case korean = "ko"
    case japanese = "ja"
    case chinese = "zh-Hans"
    case german = "de"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english: return "English"
        case .korean: return "한국어"
        case .japanese: return "日本語"
        case .chinese: return "中文"
        case .german: return "Deutsch"
        }
    }

    var flag: String {
        switch self {
        case .english: return "🇺🇸"
        case .korean: return "🇰🇷"
        case .japanese: return "🇯🇵"
        case .chinese: return "🇨🇳"
        case .german: return "🇩🇪"
        }
    }
}

// MARK: - Localization Manager
@MainActor
class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()

    @Published var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: languageKey)
            updateAppLanguage()
        }
    }

    private let languageKey = "SwiftQuantum_AppLanguage"

    private init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: languageKey),
           let language = AppLanguage(rawValue: savedLanguage) {
            currentLanguage = language
        } else {
            // Default to system language or English
            let systemLang = Locale.current.language.languageCode?.identifier ?? "en"
            currentLanguage = AppLanguage(rawValue: systemLang) ?? .english
        }
        // Sync with SwiftQuantum's localization system
        QuantumLocalization.shared.setLanguage(currentLanguage.rawValue)
    }

    func setLanguage(_ language: AppLanguage) {
        currentLanguage = language
    }

    private func updateAppLanguage() {
        UserDefaults.standard.set([currentLanguage.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        // Sync with SwiftQuantum's localization system
        QuantumLocalization.shared.setLanguage(currentLanguage.rawValue)
    }

    // MARK: - Localized Strings
    func localized(_ key: LocalizedStringKey) -> String {
        return strings[key] ?? key.defaultValue
    }

    // Get localized string for current language
    func string(for key: LocalizedStringKey) -> String {
        guard let languageStrings = localizedStrings[currentLanguage],
              let value = languageStrings[key] else {
            return localizedStrings[.english]?[key] ?? key.defaultValue
        }
        return value
    }

    // MARK: - Dynamic String Localization
    // For keys not in the enum, lookup from dynamicStrings dictionary
    func string(forKey key: String) -> String {
        guard let languageDict = dynamicLocalizedStrings[currentLanguage],
              let value = languageDict[key] else {
            return dynamicLocalizedStrings[.english]?[key] ?? key
        }
        return value
    }

    // MARK: - SwiftQuantum Package Localization
    // Use strings from SwiftQuantum's .lproj files
    func packageString(forKey key: String) -> String {
        return QuantumLocalization.shared.string(forKey: key)
    }

    // Dynamic localized strings for Hub views and other screens
    private let dynamicLocalizedStrings: [AppLanguage: [String: String]] = [
        .english: englishDynamicStrings,
        .korean: koreanDynamicStrings,
        .japanese: japaneseDynamicStrings,
        .chinese: chineseDynamicStrings,
        .german: germanDynamicStrings
    ]

    // All localized strings
    private var strings: [LocalizedStringKey: String] {
        localizedStrings[currentLanguage] ?? localizedStrings[.english] ?? [:]
    }

    private let localizedStrings: [AppLanguage: [LocalizedStringKey: String]] = [
        .english: englishStrings,
        .korean: koreanStrings,
        .japanese: japaneseStrings,
        .chinese: chineseStrings,
        .german: germanStrings
    ]
}

// MARK: - Localized String Keys
enum LocalizedStringKey: String {
    // Navigation
    case lab = "nav.lab"
    case circuits = "nav.circuits"
    case academy = "nav.academy"
    case industry = "nav.industry"
    case profile = "nav.profile"
    case more = "nav.more"

    // Tab Descriptions
    case labDescription = "nav.lab.description"
    case circuitsDescription = "nav.circuits.description"
    case bridgeDescription = "nav.bridge.description"
    case moreDescription = "nav.more.description"

    // Lab UI
    case control = "lab.control"
    case measure = "lab.measure"
    case probability = "lab.probability"
    case quantumGates = "lab.quantumGates"
    case hadamard = "lab.hadamard"
    case pauliX = "lab.pauliX"
    case pauliY = "lab.pauliY"
    case pauliZ = "lab.pauliZ"

    // Profile
    case settings = "profile.settings"
    case language = "profile.language"
    case notifications = "profile.notifications"
    case darkMode = "profile.darkMode"
    case premiumStatus = "profile.premiumStatus"
    case achievements = "profile.achievements"

    // Premium
    case upgrade = "premium.upgrade"
    case pro = "premium.pro"
    case premium = "premium.premium"
    case free = "premium.free"
    case subscribe = "premium.subscribe"
    case restorePurchases = "premium.restore"

    // Onboarding
    case welcome = "onboarding.welcome"
    case skip = "onboarding.skip"
    case next = "onboarding.next"
    case getStarted = "onboarding.getStarted"
    case selectLanguage = "onboarding.selectLanguage"

    // Onboarding Steps
    case onboardingSelectYour = "onboarding.selectYour"
    case onboardingLanguage = "onboarding.language"
    case onboardingLanguageDesc = "onboarding.languageDesc"
    case onboardingWelcomeTo = "onboarding.welcomeTo"
    case onboardingSwiftQuantum = "onboarding.swiftQuantum"
    case onboardingWelcomeDesc = "onboarding.welcomeDesc"
    case onboardingExperimentIn = "onboarding.experimentIn"
    case onboardingLabDesc = "onboarding.labDesc"
    case onboardingBuildWith = "onboarding.buildWith"
    case onboardingCircuitsDesc = "onboarding.circuitsDesc"
    case onboardingConnectVia = "onboarding.connectVia"
    case onboardingBridge = "onboarding.bridge"
    case onboardingBridgeDesc = "onboarding.bridgeDesc"

    // Common
    case done = "common.done"
    case cancel = "common.cancel"
    case save = "common.save"
    case active = "common.active"

    var defaultValue: String {
        switch self {
        case .lab: return "Lab"
        case .circuits: return "Circuits"
        case .academy: return "Academy"
        case .industry: return "Industry"
        case .profile: return "Profile"
        case .more: return "More"
        case .labDescription: return "Quantum Experiments"
        case .circuitsDescription: return "Circuit Builder"
        case .bridgeDescription: return "QPU Connection"
        case .moreDescription: return "Academy & More"
        case .control: return "Control"
        case .measure: return "Measure"
        case .probability: return "Probability"
        case .quantumGates: return "Quantum Gates"
        case .hadamard: return "Hadamard"
        case .pauliX: return "Pauli-X"
        case .pauliY: return "Pauli-Y"
        case .pauliZ: return "Pauli-Z"
        case .settings: return "Settings"
        case .language: return "Language"
        case .notifications: return "Notifications"
        case .darkMode: return "Dark Mode"
        case .premiumStatus: return "Premium Status"
        case .achievements: return "Achievements"
        case .upgrade: return "Upgrade"
        case .pro: return "Pro"
        case .premium: return "Premium"
        case .free: return "Free"
        case .subscribe: return "Subscribe"
        case .restorePurchases: return "Restore Purchases"
        case .welcome: return "Welcome to"
        case .skip: return "Skip"
        case .next: return "Next"
        case .getStarted: return "Get Started"
        case .selectLanguage: return "Select Language"
        case .onboardingSelectYour: return "Select Your"
        case .onboardingLanguage: return "Language"
        case .onboardingLanguageDesc: return "Choose your preferred language. You can change it anytime in Settings."
        case .onboardingWelcomeTo: return "Welcome to"
        case .onboardingSwiftQuantum: return "SwiftQuantum"
        case .onboardingWelcomeDesc: return "Explore quantum computing with interactive visualizations and real hardware connections."
        case .onboardingExperimentIn: return "Experiment in"
        case .onboardingLabDesc: return "Manipulate qubits on the Bloch Sphere. Apply gates like Hadamard (H) and measure results."
        case .onboardingBuildWith: return "Build with"
        case .onboardingCircuitsDesc: return "Build quantum circuits with Bell State, GHZ, Grover and more templates."
        case .onboardingConnectVia: return "Connect via"
        case .onboardingBridge: return "Bridge"
        case .onboardingBridgeDesc: return "Deploy circuits to real IBM Quantum computers with 127+ qubits."
        case .done: return "Done"
        case .cancel: return "Cancel"
        case .save: return "Save"
        case .active: return "Active"
        }
    }
}

// MARK: - English Strings
private let englishStrings: [LocalizedStringKey: String] = [
    .lab: "Lab",
    .circuits: "Circuits",
    .academy: "Academy",
    .industry: "Industry",
    .profile: "Profile",
    .more: "More",
    .labDescription: "Quantum Experiments",
    .circuitsDescription: "Circuit Builder",
    .bridgeDescription: "QPU Connection",
    .moreDescription: "Academy & More",
    .control: "Control",
    .measure: "Measure",
    .probability: "Probability",
    .quantumGates: "Quantum Gates",
    .hadamard: "Hadamard",
    .pauliX: "Pauli-X",
    .pauliY: "Pauli-Y",
    .pauliZ: "Pauli-Z",
    .settings: "Settings",
    .language: "Language",
    .notifications: "Notifications",
    .darkMode: "Dark Mode",
    .premiumStatus: "Premium Status",
    .achievements: "Achievements",
    .upgrade: "Upgrade",
    .pro: "Pro",
    .premium: "Premium",
    .free: "Free",
    .subscribe: "Subscribe",
    .restorePurchases: "Restore Purchases",
    .welcome: "Welcome to",
    .skip: "Skip",
    .next: "Next",
    .getStarted: "Get Started",
    .selectLanguage: "Select Language",
    .onboardingSelectYour: "Select Your",
    .onboardingLanguage: "Language",
    .onboardingLanguageDesc: "Choose your preferred language. You can change it anytime in Settings.",
    .onboardingWelcomeTo: "Welcome to",
    .onboardingSwiftQuantum: "SwiftQuantum",
    .onboardingWelcomeDesc: "Explore quantum computing with interactive visualizations and real hardware connections.",
    .onboardingExperimentIn: "Experiment in",
    .onboardingLabDesc: "Manipulate qubits on the Bloch Sphere. Apply gates like Hadamard (H) and measure results.",
    .onboardingBuildWith: "Build with",
    .onboardingCircuitsDesc: "Build quantum circuits with Bell State, GHZ, Grover and more templates.",
    .onboardingConnectVia: "Connect via",
    .onboardingBridge: "Bridge",
    .onboardingBridgeDesc: "Deploy circuits to real IBM Quantum computers with 127+ qubits.",
    .done: "Done",
    .cancel: "Cancel",
    .save: "Save",
    .active: "Active"
]

// MARK: - Korean Strings
private let koreanStrings: [LocalizedStringKey: String] = [
    .lab: "실험실",
    .circuits: "회로",
    .academy: "아카데미",
    .industry: "산업",
    .profile: "프로필",
    .more: "더보기",
    .labDescription: "양자 실험",
    .circuitsDescription: "회로 빌더",
    .bridgeDescription: "QPU 연결",
    .moreDescription: "아카데미 & 더보기",
    .control: "제어",
    .measure: "측정",
    .probability: "확률",
    .quantumGates: "양자 게이트",
    .hadamard: "하다마드",
    .pauliX: "Pauli-X",
    .pauliY: "Pauli-Y",
    .pauliZ: "Pauli-Z",
    .settings: "설정",
    .language: "언어",
    .notifications: "알림",
    .darkMode: "다크 모드",
    .premiumStatus: "프리미엄 상태",
    .achievements: "업적",
    .upgrade: "업그레이드",
    .pro: "Pro",
    .premium: "Premium",
    .free: "무료",
    .subscribe: "구독하기",
    .restorePurchases: "구매 복원",
    .welcome: "환영합니다",
    .skip: "건너뛰기",
    .next: "다음",
    .getStarted: "시작하기",
    .selectLanguage: "언어 선택",
    .onboardingSelectYour: "선택하세요",
    .onboardingLanguage: "언어",
    .onboardingLanguageDesc: "원하는 언어를 선택하세요. 설정에서 언제든지 변경할 수 있습니다.",
    .onboardingWelcomeTo: "환영합니다",
    .onboardingSwiftQuantum: "SwiftQuantum",
    .onboardingWelcomeDesc: "인터랙티브 시각화와 실제 하드웨어 연결로 양자 컴퓨팅을 탐험하세요.",
    .onboardingExperimentIn: "실험하세요",
    .onboardingLabDesc: "블로흐 구면에서 큐빗을 조작하세요. 하다마드(H) 게이트를 적용하고 결과를 측정하세요.",
    .onboardingBuildWith: "구축하세요",
    .onboardingCircuitsDesc: "벨 상태, GHZ, 그로버 등 다양한 템플릿으로 양자 회로를 구축하세요.",
    .onboardingConnectVia: "연결하기",
    .onboardingBridge: "브릿지",
    .onboardingBridgeDesc: "127+ 큐빗의 실제 IBM 양자 컴퓨터에 회로를 배포하세요.",
    .done: "완료",
    .cancel: "취소",
    .save: "저장",
    .active: "활성"
]

// MARK: - Japanese Strings
private let japaneseStrings: [LocalizedStringKey: String] = [
    .lab: "ラボ",
    .circuits: "回路",
    .academy: "アカデミー",
    .industry: "産業",
    .profile: "プロフィール",
    .more: "その他",
    .labDescription: "量子実験",
    .circuitsDescription: "回路ビルダー",
    .bridgeDescription: "QPU接続",
    .moreDescription: "アカデミー＆その他",
    .control: "制御",
    .measure: "測定",
    .probability: "確率",
    .quantumGates: "量子ゲート",
    .hadamard: "アダマール",
    .pauliX: "Pauli-X",
    .pauliY: "Pauli-Y",
    .pauliZ: "Pauli-Z",
    .settings: "設定",
    .language: "言語",
    .notifications: "通知",
    .darkMode: "ダークモード",
    .premiumStatus: "プレミアムステータス",
    .achievements: "実績",
    .upgrade: "アップグレード",
    .pro: "Pro",
    .premium: "Premium",
    .free: "無料",
    .subscribe: "購読する",
    .restorePurchases: "購入を復元",
    .welcome: "ようこそ",
    .skip: "スキップ",
    .next: "次へ",
    .getStarted: "始める",
    .selectLanguage: "言語を選択",
    .onboardingSelectYour: "選択してください",
    .onboardingLanguage: "言語",
    .onboardingLanguageDesc: "ご希望の言語を選択してください。設定でいつでも変更できます。",
    .onboardingWelcomeTo: "ようこそ",
    .onboardingSwiftQuantum: "SwiftQuantum",
    .onboardingWelcomeDesc: "インタラクティブな可視化と実際のハードウェア接続で量子コンピューティングを探索しましょう。",
    .onboardingExperimentIn: "実験する",
    .onboardingLabDesc: "ブロッホ球面でキュービットを操作しましょう。アダマール(H)ゲートを適用して結果を測定します。",
    .onboardingBuildWith: "構築する",
    .onboardingCircuitsDesc: "ベル状態、GHZ、グローバーなどのテンプレートで量子回路を構築します。",
    .onboardingConnectVia: "接続する",
    .onboardingBridge: "ブリッジ",
    .onboardingBridgeDesc: "127以上のキュービットを持つ実際のIBM量子コンピューターに回路をデプロイしましょう。",
    .done: "完了",
    .cancel: "キャンセル",
    .save: "保存",
    .active: "有効"
]

// MARK: - Chinese Strings
private let chineseStrings: [LocalizedStringKey: String] = [
    .lab: "实验室",
    .circuits: "电路",
    .academy: "学院",
    .industry: "行业",
    .profile: "个人资料",
    .more: "更多",
    .labDescription: "量子实验",
    .circuitsDescription: "电路构建器",
    .bridgeDescription: "QPU连接",
    .moreDescription: "学院和更多",
    .control: "控制",
    .measure: "测量",
    .probability: "概率",
    .quantumGates: "量子门",
    .hadamard: "哈达玛",
    .pauliX: "Pauli-X",
    .pauliY: "Pauli-Y",
    .pauliZ: "Pauli-Z",
    .settings: "设置",
    .language: "语言",
    .notifications: "通知",
    .darkMode: "深色模式",
    .premiumStatus: "高级状态",
    .achievements: "成就",
    .upgrade: "升级",
    .pro: "专业版",
    .premium: "高级版",
    .free: "免费",
    .subscribe: "订阅",
    .restorePurchases: "恢复购买",
    .welcome: "欢迎使用",
    .skip: "跳过",
    .next: "下一步",
    .getStarted: "开始使用",
    .selectLanguage: "选择语言",
    .onboardingSelectYour: "请选择",
    .onboardingLanguage: "语言",
    .onboardingLanguageDesc: "选择您喜欢的语言。您可以随时在设置中更改。",
    .onboardingWelcomeTo: "欢迎使用",
    .onboardingSwiftQuantum: "SwiftQuantum",
    .onboardingWelcomeDesc: "通过交互式可视化和真实硬件连接探索量子计算。",
    .onboardingExperimentIn: "实验于",
    .onboardingLabDesc: "在布洛赫球上操作量子比特。应用哈达玛(H)门并测量结果。",
    .onboardingBuildWith: "构建",
    .onboardingCircuitsDesc: "使用贝尔态、GHZ、Grover等模板构建量子电路。",
    .onboardingConnectVia: "连接到",
    .onboardingBridge: "桥接",
    .onboardingBridgeDesc: "将电路部署到具有127+量子比特的真实IBM量子计算机。",
    .done: "完成",
    .cancel: "取消",
    .save: "保存",
    .active: "活跃"
]

// MARK: - German Strings
private let germanStrings: [LocalizedStringKey: String] = [
    .lab: "Labor",
    .circuits: "Schaltkreise",
    .academy: "Akademie",
    .industry: "Industrie",
    .profile: "Profil",
    .more: "Mehr",
    .labDescription: "Quantenexperimente",
    .circuitsDescription: "Schaltkreis-Builder",
    .bridgeDescription: "QPU-Verbindung",
    .moreDescription: "Akademie & Mehr",
    .control: "Steuerung",
    .measure: "Messen",
    .probability: "Wahrscheinlichkeit",
    .quantumGates: "Quantengatter",
    .hadamard: "Hadamard",
    .pauliX: "Pauli-X",
    .pauliY: "Pauli-Y",
    .pauliZ: "Pauli-Z",
    .settings: "Einstellungen",
    .language: "Sprache",
    .notifications: "Benachrichtigungen",
    .darkMode: "Dunkelmodus",
    .premiumStatus: "Premium-Status",
    .achievements: "Erfolge",
    .upgrade: "Upgraden",
    .pro: "Pro",
    .premium: "Premium",
    .free: "Kostenlos",
    .subscribe: "Abonnieren",
    .restorePurchases: "Käufe wiederherstellen",
    .welcome: "Willkommen bei",
    .skip: "Überspringen",
    .next: "Weiter",
    .getStarted: "Los geht's",
    .selectLanguage: "Sprache auswählen",
    .onboardingSelectYour: "Wählen Sie Ihre",
    .onboardingLanguage: "Sprache",
    .onboardingLanguageDesc: "Wählen Sie Ihre bevorzugte Sprache. Sie können sie jederzeit in den Einstellungen ändern.",
    .onboardingWelcomeTo: "Willkommen bei",
    .onboardingSwiftQuantum: "SwiftQuantum",
    .onboardingWelcomeDesc: "Erkunden Sie Quantencomputing mit interaktiven Visualisierungen und echten Hardware-Verbindungen.",
    .onboardingExperimentIn: "Experimentieren im",
    .onboardingLabDesc: "Manipulieren Sie Qubits auf der Bloch-Kugel. Wenden Sie Gates wie Hadamard (H) an und messen Sie Ergebnisse.",
    .onboardingBuildWith: "Erstellen mit",
    .onboardingCircuitsDesc: "Erstellen Sie Quantenschaltkreise mit Bell, GHZ, Grover und mehr Vorlagen.",
    .onboardingConnectVia: "Verbinden über",
    .onboardingBridge: "Bridge",
    .onboardingBridgeDesc: "Deployen Sie Schaltkreise auf echten IBM Quantencomputern mit 127+ Qubits.",
    .done: "Fertig",
    .cancel: "Abbrechen",
    .save: "Speichern",
    .active: "Aktiv"
]

// MARK: - Language Selection Sheet
struct LanguageSelectionSheet: View {
    @ObservedObject var localization = LocalizationManager.shared
    @Environment(\.dismiss) var dismiss
    @State private var selectedLanguage: AppLanguage

    init() {
        _selectedLanguage = State(initialValue: LocalizationManager.shared.currentLanguage)
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 20) {
                    Text(localization.string(for: .selectLanguage))
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding(.top, 20)

                    VStack(spacing: 12) {
                        ForEach(AppLanguage.allCases) { language in
                            Button(action: {
                                selectedLanguage = language
                                localization.setLanguage(language)
                            }) {
                                HStack {
                                    Text(language.flag)
                                        .font(.title)

                                    Text(language.displayName)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.white)

                                    Spacer()

                                    if selectedLanguage == language {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 22))
                                            .foregroundColor(.green)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(selectedLanguage == language ?
                                              Color.white.opacity(0.15) :
                                              Color.white.opacity(0.05))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(selectedLanguage == language ?
                                                        Color.green.opacity(0.5) :
                                                        Color.clear, lineWidth: 1)
                                        )
                                )
                            }
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localization.string(for: .done)) {
                        dismiss()
                    }
                    .foregroundColor(.cyan)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    LanguageSelectionSheet()
}

// MARK: - Dynamic Localized Strings (English)
private let englishDynamicStrings: [String: String] = [
    // Bridge Tab - Introduction
    "bridge.why_use": "Why Use Bridge?",
    "bridge.connect_real": "Connect to real quantum computers",
    "bridge.learn_more": "Learn More",
    "bridge.benefit.hardware.title": "Real Hardware",
    "bridge.benefit.hardware.desc": "Access IBM Quantum computers with 127+ qubits",
    "bridge.benefit.quantum.title": "Quantum Advantage",
    "bridge.benefit.quantum.desc": "Run algorithms impossible on classical computers",
    "bridge.benefit.results.title": "Real Results",
    "bridge.benefit.results.desc": "Get actual quantum measurement data",

    // Bridge Tab - Connection
    "bridge.status.active": "Connection Active",
    "bridge.status.disconnected": "Disconnected",
    "bridge.connect": "Connect",
    "bridge.disconnect": "Disconnect",
    "executor.local": "Local Device",

    // Bridge Tab - Backend Selection
    "bridge.select_backend": "Select Backend",
    "bridge.select_backend.desc": "Choose the quantum processor for your circuit",
    "bridge.best_for": "Best for",
    "bridge.advantages": "Advantages",
    "bridge.limitations": "Limitations",

    // Backend Details
    "bridge.backend.simulator.title": "Local Simulator",
    "bridge.backend.simulator.best": "Testing & Development",
    "bridge.backend.simulator.adv1": "Instant results",
    "bridge.backend.simulator.adv2": "No queue wait",
    "bridge.backend.simulator.adv3": "Perfect fidelity",
    "bridge.backend.simulator.lim1": "Limited qubits (20)",
    "bridge.backend.simulator.lim2": "No real quantum effects",
    "bridge.backend.brisbane.title": "IBM Brisbane",
    "bridge.backend.brisbane.best": "Production workloads",
    "bridge.backend.brisbane.adv1": "High coherence time",
    "bridge.backend.brisbane.adv2": "Stable performance",
    "bridge.backend.osaka.title": "IBM Osaka",
    "bridge.backend.osaka.best": "Fast experiments",
    "bridge.backend.osaka.adv1": "Fast gate speed",
    "bridge.backend.osaka.adv2": "Low latency",
    "bridge.backend.osaka.lim1": "Higher error rate",
    "bridge.backend.kyoto.title": "IBM Kyoto",
    "bridge.backend.kyoto.best": "Research applications",
    "bridge.backend.kyoto.adv1": "Research grade",
    "bridge.backend.kyoto.adv2": "Advanced calibration",
    "bridge.backend.kyoto.lim1": "Frequent maintenance",
    "bridge.backend.kyoto.lim2": "Limited availability",
    "bridge.backend.qubits127": "127 qubits",
    "bridge.backend.queue_wait": "Queue wait times",
    "bridge.backend.limited_daily": "Limited daily runs",

    // Bridge Tab - Queue Status
    "bridge.queue.title": "Queue Status",
    "bridge.queue.pending": "Pending",
    "bridge.queue.running": "Running",
    "bridge.queue.est_wait": "Est. Wait",

    // Bridge Tab - Deploy
    "bridge.deploy.title": "Deploy Circuit",
    "bridge.deploy.hold": "Hold to Deploy",
    "bridge.deploy.deploying": "Deploying...",
    "bridge.deploy.hold_text": "Hold for 2 seconds to deploy your circuit",

    // Bridge Tab - Jobs
    "bridge.jobs.title": "Active Jobs",

    // Bridge Tab - Actions
    "bridge.actions.title": "Quick Actions",
    "bridge.actions.subtitle": "One-tap quantum operations",
    "bridge.action.bell": "Bell State",
    "bridge.action.bell.sub": "Quantum entanglement",
    "bridge.action.ghz": "GHZ State",
    "bridge.action.ghz.sub": "Multi-qubit entangle",
    "bridge.action.export": "Export QASM",
    "bridge.action.export.sub": "Get circuit code",
    "bridge.action.continuous": "Continuous",
    "bridge.action.continuous.sub": "Auto-repeat jobs",
    "bridge.action.stop_continuous": "Stop",
    "bridge.action.running": "Running...",

    // Bridge Tab - Continuous Mode
    "bridge.continuous.active": "Continuous Mode Active",
    "bridge.continuous.desc": "Circuits running automatically every 30 seconds",
    "bridge.continuous.runs": "runs",

    // Bridge Tab - Error Correction
    "bridge.ecc.title": "Error Correction",
    "bridge.ecc.status": "Status",
    "bridge.ecc.correcting": "Correcting errors...",
    "bridge.ecc.fidelity": "Fidelity",

    // Bridge Tab - QASM Export
    "bridge.qasm.title": "QASM Code",
    "bridge.qasm.copy": "Copy to Clipboard",
    "bridge.qasm.copied": "Copied!",
    "bridge.qasm.share": "Share",
    "bridge.qasm.what": "What is QASM?",
    "bridge.qasm.desc": "OpenQASM is a standard language for describing quantum circuits. You can use this code in IBM Quantum Lab or other platforms.",

    // Bridge Tab - API Key
    "bridge.apikey.title": "IBM Quantum API Key",
    "bridge.apikey.desc": "Enter your IBM Quantum API key to connect to real quantum computers",
    "bridge.apikey.placeholder": "Enter API Key",

    // Bridge Tab - Premium
    "bridge.premium.title": "Unlock Bridge",
    "bridge.premium.desc": "Access real IBM Quantum computers with SwiftQuantum Pro",
    "bridge.premium.feat1": "127+ qubit quantum computers",
    "bridge.premium.feat2": "Real quantum hardware access",
    "bridge.premium.feat3": "Priority queue placement",
    "bridge.premium.feat4": "Error correction support",
    "bridge.premium.feat5": "Unlimited daily runs",
    "bridge.premium.upgrade": "Upgrade to Pro",
    "bridge.premium.trial": "7-day free trial • Cancel anytime",

    // Circuits Tab - Main
    "circuits.title": "Circuit Builder",
    "circuits.subtitle": "Build and run quantum circuits",
    "circuits.stat.templates": "Templates",
    "circuits.stat.runs": "Runs",
    "circuits.stat.favorites": "Favorites",
    "circuits.quick.title": "Quick Start",
    "circuits.featured.title": "Featured Circuits",
    "circuits.templates.title": "All Templates",
    "circuits.recent.title": "Recent Runs",
    "circuits.recent.clear": "Clear",
    "circuits.qubits": "qubits",
    "circuits.gates": "gates",
    "circuits.detail.about": "About",
    "circuits.detail.gates": "Gates",
    "circuits.detail.run": "Run Circuit",
    "circuits.shots": "Shots",
    "circuits.running": "Running...",
    "circuits.run": "Run",
    "circuits.result": "Results",

    // Circuits Tab - Difficulty Levels
    "circuits.difficulty.beginner": "Beginner",
    "circuits.difficulty.intermediate": "Intermediate",
    "circuits.difficulty.advanced": "Advanced",

    // Circuits Tab - Premium
    "circuits.premium.title": "Premium Circuit",
    "circuits.premium.desc": "This circuit requires a Pro subscription to access.",
    "circuits.premium.unlock": "Unlock with Pro",
    "circuits.premium.features.title": "Pro Features",
    "circuits.premium.features.1": "All advanced circuits",
    "circuits.premium.features.2": "Real quantum hardware",
    "circuits.premium.features.3": "Priority support",
    "circuits.premium.feat1": "All advanced circuits",
    "circuits.premium.feat2": "Real quantum hardware access",
    "circuits.premium.feat3": "Priority queue placement",
    "circuits.premium.feat4": "Unlimited daily runs",
    "circuits.premium.feat5": "Premium support",
    "circuits.premium.upgrade": "Upgrade to Pro",
    "circuits.premium.trial": "7-day free trial • Cancel anytime",

    // Industry Tab
    "industry.use.finance": "Financial Modeling",
    "industry.use.pharma": "Drug Discovery",
    "industry.use.logistics": "Supply Chain",
    "industry.use.security": "Cryptography",
    "industry.legend.company": "Company",
    "industry.legend.tech": "Technology",
    "industry.legend.market": "Market",
    "industry.badge.leader": "Leader",
    "industry.badge.emerging": "Emerging",

    // More Tab
    "more.academy": "Academy",
    "more.academy.desc": "Learn quantum computing",
    "more.academy.subtitle": "Learn Quantum Computing",
    "more.industry.subtitle": "Enterprise Solutions",
    "more.profile.subtitle": "Your Quantum Journey",
    "more.settings": "Settings",
    "more.settings.desc": "Customize your experience",
    "more.about": "About",
    "more.about.desc": "App info & version",
    "more.help": "Help & Support",
    "more.help.desc": "Get assistance",
    "more.language": "Language",
    "more.language.desc": "Change app language",
    "more.notifications": "Notifications",
    "more.notifications.desc": "Manage alerts",
    "more.privacy": "Privacy",
    "more.privacy.desc": "Read our policy",
    "more.terms": "Terms of Service",
    "more.terms.desc": "Legal information",
    "more.rate": "Rate App",
    "more.rate.desc": "Leave a review",
    "more.share": "Share App",
    "more.share.desc": "Tell your friends",
    "more.feedback": "Send Feedback",
    "more.feedback.desc": "We'd love to hear from you",
    "more.premium.status": "Premium Status",
    "more.premium.active": "Active",
    "more.premium.upgrade": "Upgrade to Pro",
    "more.done": "Done",
    "more.login": "Login",
    "more.premium": "Premium",
    "more.admin": "Admin",
    "more.coming_soon": "Coming Soon",
    "more.coming_soon_message": "This feature will be available in a future update.",
    "more.ok": "OK",
    "more.reset_tutorial": "Reset Tutorial",
    "more.reset": "Reset",
    "more.cancel": "Cancel",
    "more.reset_message": "This will show the onboarding tutorial again when you restart the app.",
    "more.appearance": "Appearance",

    // Industry Tab
    "industry.title": "Industry Solutions",
    "industry.subtitle": "Quantum-powered business optimization",
    "industry.stat.efficiency": "Efficiency",
    "industry.stat.roi": "ROI",
    "industry.stat.clients": "Clients",
    "industry.efficiency": "efficiency",
    "industry.premium.title": "Enterprise Solutions Premium",
    "industry.premium.desc": "Unlock all industry solutions and quantum-powered business optimization",
    "industry.premium.upgrade": "Upgrade - $9.99/month",
    "industry.premium.trial": "7-day free trial included",
    "industry.get_started": "Get Started",
    "industry.pricing_soon": "Pricing Details Coming Soon",
    "industry.roi.title": "ROI Calculator",
    "industry.roi.estimate": "Estimate your quantum advantage",
    "industry.roi.subtitle": "Calculate your potential returns",
    "industry.roi.calculate": "Calculate ROI",
    "industry.roi.progress": "Based on Level 8 progress",
    "industry.roi.team_size": "Team Size",
    "industry.roi.budget": "Annual IT Budget",
    "industry.roi.calculate_btn": "Calculate ROI",
    "industry.roi.estimated_savings": "Estimated Annual Savings",
    "industry.roi.payback": "Payback Period",
    "industry.roi.projected": "Projected Annual Benefit",
    "industry.roi.calculate_data": "Calculate with your data",
    "industry.upgrade_enterprise": "Upgrade to Enterprise",
    "industry.get_premium": "Get Premium",
    "industry.trial": "Start your 7-day free trial",
    "industry.efficiency_gain": "Efficiency Gain",
    "industry.implementation": "Implementation",
    "industry.impl_weeks": "2-4 weeks",
    "industry.team_size": "Team Size",
    "industry.any_size": "Any Size",
    "industry.use_cases": "Key Use Cases",
    "industry.learn_more": "Learn More",
    "industry.legend.without": "Without Quantum",
    "industry.legend.with": "With Quantum Premium",
    "industry.choose_plan": "Choose Your Plan",
    "industry.badge.best": "Best Value",
    "industry.badge.popular": "Popular",
    "industry.compare.feature": "Feature",
    "industry.compare.pro": "Pro",
    "industry.compare.enterprise": "Enterprise",
    "industry.success_stories": "Success Stories",
    "industry.quantum_solutions": "Quantum Solutions",
    "industry.overview": "Overview",
    "industry.key_benefits": "Key Benefits",
    "industry.learn.ibm": "IBM Quantum Learning",
    "industry.learn.mit": "MIT xPRO Quantum Course",
    "industry.learn.roadmap": "IBM Quantum 2026 Roadmap",

    // Industry Use Cases
    "industry.use.finance.1": "Portfolio Optimization",
    "industry.use.finance.2": "Risk Assessment",
    "industry.use.finance.3": "Fraud Detection",
    "industry.use.finance.4": "High-Frequency Trading",
    "industry.use.health.1": "Drug Molecule Simulation",
    "industry.use.health.2": "Protein Folding",
    "industry.use.health.3": "Treatment Optimization",
    "industry.use.health.4": "Medical Imaging",
    "industry.use.logistics.1": "Route Optimization",
    "industry.use.logistics.2": "Warehouse Layout",
    "industry.use.logistics.3": "Supply Chain",
    "industry.use.logistics.4": "Delivery Scheduling",
    "industry.use.energy.1": "Grid Optimization",
    "industry.use.energy.2": "Demand Forecasting",
    "industry.use.energy.3": "Renewable Integration",
    "industry.use.energy.4": "Load Balancing",
    "industry.use.mfg.1": "Quality Control",
    "industry.use.mfg.2": "Predictive Maintenance",
    "industry.use.mfg.3": "Process Optimization",
    "industry.use.mfg.4": "Inventory Management",
    "industry.use.ai.1": "Quantum Neural Networks",
    "industry.use.ai.2": "Feature Selection",
    "industry.use.ai.3": "Optimization Problems",
    "industry.use.ai.4": "Generative Models",
    "industry.use.default.1": "Optimization",
    "industry.use.default.2": "Simulation",
    "industry.use.default.3": "Analysis",

    // Ecosystem Tab
    "ecosystem.title": "IBM Quantum Ecosystem",
    "ecosystem.subtitle": "Run real quantum projects from the ecosystem",
    "ecosystem.all": "All",
    "ecosystem.about": "About",
    "ecosystem.actions": "Quick Actions",
    "ecosystem.run_demo": "Run Demo Circuit",
    "ecosystem.running": "Running...",
    "ecosystem.export_code": "Export Sample Code",
    "ecosystem.view_github": "View on GitHub",
    "ecosystem.result": "Execution Result",
    "ecosystem.use_cases": "Use Cases",
    "ecosystem.sample_code": "Sample Code",
    "ecosystem.copy": "Copy to Clipboard",

    // Ecosystem Categories
    "ecosystem.category.ml": "Machine Learning",
    "ecosystem.category.chem": "Chemistry & Physics",
    "ecosystem.category.opt": "Optimization",
    "ecosystem.category.hw": "Hardware Providers",
    "ecosystem.category.sim": "Simulation",
    "ecosystem.category.research": "Research",

    // Ecosystem Project Names
    "ecosystem.project.torchquantum": "TorchQuantum",
    "ecosystem.project.qiskit_ml": "Qiskit ML",
    "ecosystem.project.qiskit_nature": "Qiskit Nature",
    "ecosystem.project.qiskit_finance": "Qiskit Finance",
    "ecosystem.project.qiskit_optimization": "Qiskit Optimization",
    "ecosystem.project.ibm_quantum": "IBM Quantum",
    "ecosystem.project.azure_quantum": "Azure Quantum",
    "ecosystem.project.aws_braket": "AWS Braket",
    "ecosystem.project.ionq": "IonQ",
    "ecosystem.project.qiskit_aer": "Qiskit Aer",
    "ecosystem.project.mqt_ddsim": "MQT DDSIM",
    "ecosystem.project.pennylane": "PennyLane",
    "ecosystem.project.cirq": "Cirq (Google)",

    // Ecosystem Project Descriptions
    "ecosystem.project.torchquantum.desc": "PyTorch-based quantum ML framework with GPU support. Build and train quantum neural networks seamlessly.",
    "ecosystem.project.qiskit_ml.desc": "Quantum Machine Learning module with variational algorithms, quantum kernels, and neural networks.",
    "ecosystem.project.qiskit_nature.desc": "Simulate molecular structures and chemical reactions. Quantum chemistry for drug discovery.",
    "ecosystem.project.qiskit_finance.desc": "Portfolio optimization, option pricing, and risk analysis using quantum algorithms.",
    "ecosystem.project.qiskit_optimization.desc": "Solve combinatorial optimization problems with QAOA, VQE, and Grover's algorithm.",
    "ecosystem.project.ibm_quantum.desc": "Access 127+ qubit Eagle processors. Brisbane, Osaka, Kyoto systems available.",
    "ecosystem.project.azure_quantum.desc": "Microsoft's quantum cloud with IonQ, Quantinuum, and Rigetti backends.",
    "ecosystem.project.aws_braket.desc": "Amazon's quantum service with IonQ, Rigetti, and OQC quantum hardware.",
    "ecosystem.project.ionq.desc": "Trapped-ion quantum computers with high gate fidelity and all-to-all connectivity.",
    "ecosystem.project.qiskit_aer.desc": "High-performance quantum circuit simulator with noise modeling and GPU acceleration.",
    "ecosystem.project.mqt_ddsim.desc": "Decision diagram-based quantum simulator for efficient large-scale simulations.",
    "ecosystem.project.pennylane.desc": "Cross-platform quantum ML library supporting multiple hardware backends.",
    "ecosystem.project.cirq.desc": "Google's quantum framework for NISQ algorithms and experiments.",

    // Industry Hero Benefits
    "industry.hero.benefit1": "Solve complex optimization problems in minutes, not days",
    "industry.hero.benefit2": "Run simulations impossible on classical computers",
    "industry.hero.benefit3": "Accelerate decision-making with quantum advantage",

    // Industry Detail Sheet
    "industry.detail.efficiency": "Efficiency",
    "industry.detail.weeks": "Weeks",
    "industry.detail.uptime": "Uptime",
    "industry.overview.finance": "Quantum computing transforms financial services with advanced portfolio optimization, real-time risk analysis, and sophisticated fraud detection capabilities.",
    "industry.overview.healthcare": "Healthcare benefits from molecular simulation for drug discovery, protein folding predictions, and personalized treatment optimization.",
    "industry.overview.logistics": "Supply chain management is revolutionized with quantum algorithms for route optimization, inventory management, and demand forecasting.",
    "industry.overview.energy": "Energy sector leverages quantum computing for smart grid optimization, renewable energy integration, and load balancing challenges.",
    "industry.overview.manufacturing": "Manufacturing operations benefit from quantum-enhanced quality control, predictive maintenance, and process optimization.",
    "industry.overview.ai": "AI/ML applications are accelerated with quantum neural networks, feature selection, and complex optimization problems.",
    "industry.overview.default": "This industry benefits from quantum computing through optimization, simulation, and advanced data analysis capabilities.",
    "industry.benefit.finance.1": "Portfolio optimization with quantum algorithms",
    "industry.benefit.finance.2": "Real-time risk assessment and pricing",
    "industry.benefit.finance.3": "Enhanced fraud detection patterns",
    "industry.benefit.finance.4": "High-frequency trading optimization",
    "industry.benefit.healthcare.1": "Drug molecule simulation and discovery",
    "industry.benefit.healthcare.2": "Protein folding prediction",
    "industry.benefit.healthcare.3": "Personalized treatment optimization",
    "industry.benefit.healthcare.4": "Medical imaging enhancement",
    "industry.benefit.logistics.1": "Global route optimization",
    "industry.benefit.logistics.2": "Warehouse layout optimization",
    "industry.benefit.logistics.3": "Supply chain resilience",
    "industry.benefit.logistics.4": "Dynamic delivery scheduling",
    "industry.benefit.energy.1": "Smart grid optimization",
    "industry.benefit.energy.2": "Demand forecasting accuracy",
    "industry.benefit.energy.3": "Renewable energy integration",
    "industry.benefit.energy.4": "Load balancing efficiency",
    "industry.benefit.manufacturing.1": "Advanced quality control",
    "industry.benefit.manufacturing.2": "Predictive maintenance",
    "industry.benefit.manufacturing.3": "Process optimization",
    "industry.benefit.manufacturing.4": "Inventory management",
    "industry.benefit.ai.1": "Quantum neural network training",
    "industry.benefit.ai.2": "Feature selection optimization",
    "industry.benefit.ai.3": "Complex problem solving",
    "industry.benefit.ai.4": "Generative model acceleration",
    "industry.benefit.default.1": "Process optimization",
    "industry.benefit.default.2": "Data analysis enhancement",
    "industry.benefit.default.3": "Decision support systems",
    "industry.benefit.default.4": "Simulation capabilities",

    // Industry Premium Sheet
    "industry.premium.feat.finance": "Real-time financial modeling & optimization",
    "industry.premium.feat.health": "Drug discovery molecular simulation",
    "industry.premium.feat.energy": "Smart grid & energy optimization",
    "industry.premium.feat.ai": "Quantum ML model training",
    "industry.premium.feat.roi": "ROI calculator & analytics dashboard",

    // Ecosystem Use Cases
    "ecosystem.usecase.ml.1": "Quantum Neural Networks",
    "ecosystem.usecase.ml.2": "Feature Selection",
    "ecosystem.usecase.ml.3": "Classification Problems",
    "ecosystem.usecase.ml.4": "Regression Analysis",
    "ecosystem.usecase.chem.1": "Molecular Simulation",
    "ecosystem.usecase.chem.2": "Energy Calculation",
    "ecosystem.usecase.chem.3": "Reaction Prediction",
    "ecosystem.usecase.chem.4": "Drug Discovery",
    "ecosystem.usecase.opt.1": "Combinatorial Optimization",
    "ecosystem.usecase.opt.2": "Portfolio Management",
    "ecosystem.usecase.opt.3": "Route Planning",
    "ecosystem.usecase.opt.4": "Resource Allocation",
    "ecosystem.usecase.hw.1": "Circuit Calibration",
    "ecosystem.usecase.hw.2": "Error Mitigation",
    "ecosystem.usecase.hw.3": "Noise Characterization",
    "ecosystem.usecase.hw.4": "Performance Benchmarking",
    "ecosystem.usecase.sim.1": "Physics Simulation",
    "ecosystem.usecase.sim.2": "Material Science",
    "ecosystem.usecase.sim.3": "Financial Modeling",
    "ecosystem.usecase.sim.4": "Climate Modeling",
    "ecosystem.usecase.research.1": "Algorithm Development",
    "ecosystem.usecase.research.2": "Error Correction",
    "ecosystem.usecase.research.3": "Quantum Advantage Studies",
    "ecosystem.usecase.research.4": "Theoretical Analysis",

    // Academy Marketing View
    "academy.done": "Done",
    "academy.hero.subtitle": "Master Quantum Computing",
    "academy.hero.reviews": "(2.4K Reviews)",
    "academy.features.title": "Why Learn with QuantumNative?",
    "academy.features.interactive.title": "Interactive Learning",
    "academy.features.interactive.desc": "Hands-on quantum circuits with real-time visualization",
    "academy.features.progress.title": "Track Progress",
    "academy.features.progress.desc": "XP points, achievements, and learning streaks",
    "academy.features.synced.title": "Synced Account",
    "academy.features.synced.desc": "Your progress syncs across SwiftQuantum apps",
    "academy.features.passport.title": "Career Passport",
    "academy.features.passport.desc": "Earn verifiable quantum computing credentials",
    "academy.courses.title": "12+ Courses Available",
    "academy.courses.basics": "Quantum Basics",
    "academy.courses.gates": "Quantum Gates",
    "academy.courses.entanglement": "Entanglement",
    "academy.courses.algorithms": "Algorithms",
    "academy.courses.free": "FREE",
    "academy.courses.lessons": "lessons",
    "academy.testimonial.quote": "QuantumNative made quantum computing accessible. I went from zero to building quantum algorithms in just 2 weeks!",
    "academy.testimonial.initials": "JK",
    "academy.testimonial.name": "James K.",
    "academy.testimonial.role": "Software Engineer",
    "academy.cta.download": "Download QuantumNative",
    "academy.cta.subtitle": "Free download · Premium courses available",

    // Profile
    "profile.title": "Profile",

    // Circuits Hero Benefits
    "circuits.hero.benefit1": "Build quantum circuits visually with drag and drop",
    "circuits.hero.benefit2": "Use pre-built templates for common algorithms",
    "circuits.hero.benefit3": "Run simulations and see results instantly",

    // Industry Card Titles & Benefits
    "industry.card.finance": "Finance",
    "industry.card.finance.benefit": "Portfolio optimization & risk analysis",
    "industry.card.healthcare": "Healthcare",
    "industry.card.healthcare.benefit": "Drug discovery acceleration",
    "industry.card.logistics": "Logistics",
    "industry.card.logistics.benefit": "Route optimization & scheduling",
    "industry.card.energy": "Energy",
    "industry.card.energy.benefit": "Grid optimization & forecasting",
    "industry.card.manufacturing": "Manufacturing",
    "industry.card.manufacturing.benefit": "Supply chain optimization",
    "industry.card.ai": "AI & ML",
    "industry.card.ai.benefit": "Quantum machine learning",

    // Auth - Login/SignUp
    "auth.welcome_back": "Welcome Back",
    "auth.create_account": "Create Account",
    "auth.reset_password": "Reset Password",
    "auth.email": "Email",
    "auth.username": "Username",
    "auth.password": "Password",
    "auth.password_min": "Password (min 6 characters)",
    "auth.confirm_password": "Confirm Password",
    "auth.login": "Login",
    "auth.signup": "Sign Up",
    "auth.forgot_password": "Forgot Password?",
    "auth.no_account": "Don't have an account?",
    "auth.have_account": "Already have an account?",
    "auth.passwords_match": "Passwords match",
    "auth.passwords_no_match": "Passwords don't match",
    "auth.send_reset": "Send Reset Link",
    "auth.back_to_login": "Back to Login",
    "auth.reset_instruction": "Enter your email address and we'll send you a link to reset your password.",

    // Subscription - Paywall
    "subscription.title": "Unlock SwiftQuantum",
    "subscription.subtitle": "Access the full power of quantum computing",
    "subscription.choose_plan": "Choose your plan",
    "subscription.close": "Close",
    "subscription.pro": "Pro",
    "subscription.premium": "Premium",
    "subscription.monthly": "Monthly",
    "subscription.yearly": "Yearly",
    "subscription.per_month": "/month",
    "subscription.per_year": "/year",
    "subscription.save_percent": "SAVE 33%",
    "subscription.recommended": "RECOMMENDED",
    "subscription.subscribe": "Subscribe",
    "subscription.restore": "Restore Purchases",
    "subscription.legal": "Subscription auto-renews unless cancelled 24 hours before the end of the current period.",
    "subscription.terms": "Terms of Use",
    "subscription.privacy": "Privacy Policy",
    "subscription.success_title": "Welcome to Premium!",
    "subscription.success_subtitle": "All features are now unlocked",
    "subscription.get_started": "Get Started",

    // Pro Features
    "subscription.pro.feature1": "All 12 Academy Courses",
    "subscription.pro.feature2": "40 Qubit Local Simulation",
    "subscription.pro.feature3": "Advanced Examples",
    "subscription.pro.feature4": "Email Support",
    "subscription.pro.desc_monthly": "Full academy access with extended simulation",
    "subscription.pro.desc_yearly": "Best value for learning quantum computing",

    // Premium Features
    "subscription.premium.feature1": "Everything in Pro",
    "subscription.premium.feature2": "QuantumBridge QPU Connection",
    "subscription.premium.feature3": "Error Correction Simulation",
    "subscription.premium.feature4": "Industry Solutions Access",
    "subscription.premium.feature5": "Priority Support",
    "subscription.premium.desc_monthly": "Full access with real quantum hardware",
    "subscription.premium.desc_yearly": "Complete quantum experience at best price",

    // Subscription Tabs & Comparison
    "subscription.tab.compare": "Compare",
    "subscription.tab.pro": "Pro",
    "subscription.tab.premium": "Premium",
    "subscription.features": "Features",
    "subscription.free": "Free",
    "subscription.select_plan": "Select a Plan",
    "subscription.compare.circuits": "Quantum Circuits",
    "subscription.compare.simulation": "Local Simulation",
    "subscription.compare.academy_basic": "Academy (Basic)",
    "subscription.compare.academy_full": "Academy (Full)",
    "subscription.compare.qpu_access": "Real QPU Access",
    "subscription.compare.industry": "Industry Solutions",
    "subscription.compare.support": "Email Support",
    "subscription.compare.priority": "Priority Support",
    "subscription.pro.subtitle": "Perfect for learning and experimentation",
    "subscription.premium.subtitle": "Complete quantum computing experience",

    // More Hub - Subscription Info
    "more.subscription_info": "Subscription Info",
    "more.subscription_info.subtitle": "Learn about Pro & Premium features",

    // Subscription Info Page
    "subscription.info.title": "Unlock Premium",
    "subscription.info.subtitle": "Get the most out of SwiftQuantum with Pro or Premium",
    "subscription.info.choose_tier": "Choose Your Tier",
    "subscription.info.best_value": "Best",
    "subscription.info.pro.feature1": "Real QPU Access",
    "subscription.info.pro.feature2": "All Circuit Templates",
    "subscription.info.pro.feature3": "Priority Support",
    "subscription.info.premium.feature1": "Everything in Pro",
    "subscription.info.premium.feature2": "Error Correction",
    "subscription.info.premium.feature3": "Industry Solutions",
    "subscription.info.all_features": "All Premium Features",
    "subscription.info.feature.qpu": "Real QPU Access",
    "subscription.info.feature.qpu.desc": "Run circuits on IBM Quantum computers with 127+ qubits",
    "subscription.info.feature.academy": "Quantum Academy",
    "subscription.info.feature.academy.desc": "Access all MIT/Harvard-style courses and lessons",
    "subscription.info.feature.industry": "Industry Solutions",
    "subscription.info.feature.industry.desc": "Enterprise quantum optimization for your business",
    "subscription.info.feature.error": "Error Correction",
    "subscription.info.feature.error.desc": "Surface code simulation and fault-tolerant computing",
    "subscription.info.feature.support": "Priority Support",
    "subscription.info.feature.support.desc": "Get faster responses from our quantum experts",
    "subscription.info.subscribe_now": "Subscribe Now",
    "subscription.info.cancel_anytime": "Cancel anytime. No commitment."
]

// MARK: - Dynamic Localized Strings (Korean)
private let koreanDynamicStrings: [String: String] = [
    // Bridge Tab - Introduction
    "bridge.why_use": "브릿지를 사용하는 이유",
    "bridge.connect_real": "실제 양자 컴퓨터에 연결",
    "bridge.learn_more": "더 알아보기",
    "bridge.benefit.hardware.title": "실제 하드웨어",
    "bridge.benefit.hardware.desc": "127개 이상의 큐빗을 가진 IBM 양자 컴퓨터 접속",
    "bridge.benefit.quantum.title": "양자 우위",
    "bridge.benefit.quantum.desc": "클래식 컴퓨터에서 불가능한 알고리즘 실행",
    "bridge.benefit.results.title": "실제 결과",
    "bridge.benefit.results.desc": "실제 양자 측정 데이터 획득",

    // Bridge Tab - Connection
    "bridge.status.active": "연결 활성화",
    "bridge.status.disconnected": "연결 끊김",
    "bridge.connect": "연결",
    "bridge.disconnect": "연결 해제",
    "executor.local": "로컬 디바이스",

    // Bridge Tab - Backend Selection
    "bridge.select_backend": "백엔드 선택",
    "bridge.select_backend.desc": "회로에 사용할 양자 프로세서를 선택하세요",
    "bridge.best_for": "최적 용도",
    "bridge.advantages": "장점",
    "bridge.limitations": "제한사항",

    // Backend Details
    "bridge.backend.simulator.title": "로컬 시뮬레이터",
    "bridge.backend.simulator.best": "테스트 및 개발",
    "bridge.backend.simulator.adv1": "즉각적인 결과",
    "bridge.backend.simulator.adv2": "대기 시간 없음",
    "bridge.backend.simulator.adv3": "완벽한 정확도",
    "bridge.backend.simulator.lim1": "제한된 큐빗 (20개)",
    "bridge.backend.simulator.lim2": "실제 양자 효과 없음",
    "bridge.backend.brisbane.title": "IBM 브리즈번",
    "bridge.backend.brisbane.best": "프로덕션 작업",
    "bridge.backend.brisbane.adv1": "높은 결맞음 시간",
    "bridge.backend.brisbane.adv2": "안정적인 성능",
    "bridge.backend.osaka.title": "IBM 오사카",
    "bridge.backend.osaka.best": "빠른 실험",
    "bridge.backend.osaka.adv1": "빠른 게이트 속도",
    "bridge.backend.osaka.adv2": "낮은 지연",
    "bridge.backend.osaka.lim1": "높은 오류율",
    "bridge.backend.kyoto.title": "IBM 교토",
    "bridge.backend.kyoto.best": "연구 응용",
    "bridge.backend.kyoto.adv1": "연구용 등급",
    "bridge.backend.kyoto.adv2": "고급 캘리브레이션",
    "bridge.backend.kyoto.lim1": "잦은 유지보수",
    "bridge.backend.kyoto.lim2": "제한된 가용성",
    "bridge.backend.qubits127": "127 큐빗",
    "bridge.backend.queue_wait": "대기열 대기 시간",
    "bridge.backend.limited_daily": "일일 제한된 실행",

    // Bridge Tab - Queue Status
    "bridge.queue.title": "대기열 상태",
    "bridge.queue.pending": "대기 중",
    "bridge.queue.running": "실행 중",
    "bridge.queue.est_wait": "예상 대기",

    // Bridge Tab - Deploy
    "bridge.deploy.title": "회로 배포",
    "bridge.deploy.hold": "길게 눌러 배포",
    "bridge.deploy.deploying": "배포 중...",
    "bridge.deploy.hold_text": "2초간 길게 눌러 회로를 배포하세요",

    // Bridge Tab - Jobs
    "bridge.jobs.title": "활성 작업",

    // Bridge Tab - Actions
    "bridge.actions.title": "빠른 작업",
    "bridge.actions.subtitle": "원터치 양자 연산",
    "bridge.action.bell": "벨 상태",
    "bridge.action.bell.sub": "양자 얽힘",
    "bridge.action.ghz": "GHZ 상태",
    "bridge.action.ghz.sub": "다중 큐빗 얽힘",
    "bridge.action.export": "QASM 내보내기",
    "bridge.action.export.sub": "회로 코드 받기",
    "bridge.action.continuous": "연속 모드",
    "bridge.action.continuous.sub": "자동 반복 작업",
    "bridge.action.stop_continuous": "중지",
    "bridge.action.running": "실행 중...",

    // Bridge Tab - Continuous Mode
    "bridge.continuous.active": "연속 모드 활성화",
    "bridge.continuous.desc": "30초마다 자동으로 회로 실행",
    "bridge.continuous.runs": "회 실행",

    // Bridge Tab - Error Correction
    "bridge.ecc.title": "오류 정정",
    "bridge.ecc.status": "상태",
    "bridge.ecc.correcting": "오류 정정 중...",
    "bridge.ecc.fidelity": "정확도",

    // Bridge Tab - QASM Export
    "bridge.qasm.title": "QASM 코드",
    "bridge.qasm.copy": "클립보드에 복사",
    "bridge.qasm.copied": "복사됨!",
    "bridge.qasm.share": "공유",
    "bridge.qasm.what": "QASM이란?",
    "bridge.qasm.desc": "OpenQASM은 양자 회로를 설명하는 표준 언어입니다. 이 코드를 IBM Quantum Lab 또는 다른 플랫폼에서 사용할 수 있습니다.",

    // Bridge Tab - API Key
    "bridge.apikey.title": "IBM Quantum API 키",
    "bridge.apikey.desc": "실제 양자 컴퓨터에 연결하려면 IBM Quantum API 키를 입력하세요",
    "bridge.apikey.placeholder": "API 키 입력",

    // Bridge Tab - Premium
    "bridge.premium.title": "브릿지 잠금 해제",
    "bridge.premium.desc": "SwiftQuantum Pro로 실제 IBM 양자 컴퓨터에 접속하세요",
    "bridge.premium.feat1": "127개 이상 큐빗 양자 컴퓨터",
    "bridge.premium.feat2": "실제 양자 하드웨어 접속",
    "bridge.premium.feat3": "우선 대기열 배치",
    "bridge.premium.feat4": "오류 정정 지원",
    "bridge.premium.feat5": "무제한 일일 실행",
    "bridge.premium.upgrade": "Pro로 업그레이드",
    "bridge.premium.trial": "7일 무료 체험 • 언제든 취소 가능",

    // Circuits Tab - Main
    "circuits.title": "회로 빌더",
    "circuits.subtitle": "양자 회로 구축 및 실행",
    "circuits.stat.templates": "템플릿",
    "circuits.stat.runs": "실행",
    "circuits.stat.favorites": "즐겨찾기",
    "circuits.quick.title": "빠른 시작",
    "circuits.featured.title": "추천 회로",
    "circuits.templates.title": "모든 템플릿",
    "circuits.recent.title": "최근 실행",
    "circuits.recent.clear": "삭제",
    "circuits.qubits": "큐빗",
    "circuits.gates": "게이트",
    "circuits.detail.about": "소개",
    "circuits.detail.gates": "게이트",
    "circuits.detail.run": "회로 실행",
    "circuits.shots": "샷 수",
    "circuits.running": "실행 중...",
    "circuits.run": "실행",
    "circuits.result": "결과",

    // Circuits Tab - Difficulty Levels
    "circuits.difficulty.beginner": "초급",
    "circuits.difficulty.intermediate": "중급",
    "circuits.difficulty.advanced": "고급",

    // Circuits Tab - Premium
    "circuits.premium.title": "프리미엄 회로",
    "circuits.premium.desc": "이 회로는 Pro 구독이 필요합니다.",
    "circuits.premium.unlock": "Pro로 잠금 해제",
    "circuits.premium.features.title": "Pro 기능",
    "circuits.premium.features.1": "모든 고급 회로",
    "circuits.premium.features.2": "실제 양자 하드웨어",
    "circuits.premium.features.3": "우선 지원",
    "circuits.premium.feat1": "모든 고급 회로",
    "circuits.premium.feat2": "실제 양자 하드웨어 접속",
    "circuits.premium.feat3": "우선 대기열 배치",
    "circuits.premium.feat4": "무제한 일일 실행",
    "circuits.premium.feat5": "프리미엄 지원",
    "circuits.premium.upgrade": "Pro로 업그레이드",
    "circuits.premium.trial": "7일 무료 체험 • 언제든 취소 가능",

    // Industry Tab
    "industry.use.finance": "금융 모델링",
    "industry.use.pharma": "신약 개발",
    "industry.use.logistics": "공급망",
    "industry.use.security": "암호화",
    "industry.legend.company": "회사",
    "industry.legend.tech": "기술",
    "industry.legend.market": "시장",
    "industry.badge.leader": "리더",
    "industry.badge.emerging": "신흥",

    // More Tab
    "more.academy": "아카데미",
    "more.academy.desc": "양자 컴퓨팅 배우기",
    "more.academy.subtitle": "양자 컴퓨팅 학습",
    "more.industry.subtitle": "기업 솔루션",
    "more.profile.subtitle": "나의 양자 여정",
    "more.settings": "설정",
    "more.settings.desc": "환경 설정 사용자화",
    "more.about": "정보",
    "more.about.desc": "앱 정보 및 버전",
    "more.help": "도움말 및 지원",
    "more.help.desc": "도움 받기",
    "more.language": "언어",
    "more.language.desc": "앱 언어 변경",
    "more.notifications": "알림",
    "more.notifications.desc": "알림 관리",
    "more.privacy": "개인정보 보호",
    "more.privacy.desc": "정책 읽기",
    "more.terms": "서비스 약관",
    "more.terms.desc": "법적 정보",
    "more.rate": "앱 평가",
    "more.rate.desc": "리뷰 남기기",
    "more.share": "앱 공유",
    "more.share.desc": "친구에게 알리기",
    "more.feedback": "피드백 보내기",
    "more.feedback.desc": "의견을 들려주세요",
    "more.premium.status": "프리미엄 상태",
    "more.premium.active": "활성화됨",
    "more.premium.upgrade": "Pro로 업그레이드",
    "more.done": "완료",
    "more.login": "로그인",
    "more.premium": "프리미엄",
    "more.admin": "관리자",
    "more.coming_soon": "준비 중",
    "more.coming_soon_message": "이 기능은 향후 업데이트에서 제공될 예정입니다.",
    "more.ok": "확인",
    "more.reset_tutorial": "튜토리얼 초기화",
    "more.reset": "초기화",
    "more.cancel": "취소",
    "more.reset_message": "앱을 재시작하면 온보딩 튜토리얼이 다시 표시됩니다.",
    "more.appearance": "외관",

    // Industry Tab Additional
    "industry.title": "산업 솔루션",
    "industry.subtitle": "양자 기반 비즈니스 최적화",
    "industry.stat.efficiency": "효율성",
    "industry.stat.roi": "ROI",
    "industry.stat.clients": "고객사",
    "industry.efficiency": "효율",
    "industry.premium.title": "엔터프라이즈 솔루션 프리미엄",
    "industry.premium.desc": "모든 산업 솔루션과 양자 기반 비즈니스 최적화 잠금 해제",
    "industry.premium.upgrade": "업그레이드 - 월 ₩12,900",
    "industry.premium.trial": "7일 무료 체험 포함",
    "industry.get_started": "시작하기",
    "industry.pricing_soon": "가격 정보 준비 중",
    "industry.roi.title": "ROI 계산기",
    "industry.roi.estimate": "양자 컴퓨팅 이점 추정",
    "industry.roi.subtitle": "잠재적 수익 계산",
    "industry.roi.calculate": "ROI 계산하기",
    "industry.roi.progress": "레벨 8 진행 상황 기반",
    "industry.roi.team_size": "팀 규모",
    "industry.roi.budget": "연간 IT 예산",
    "industry.roi.calculate_btn": "ROI 계산",
    "industry.roi.estimated_savings": "예상 연간 절감액",
    "industry.roi.payback": "투자회수",
    "industry.roi.projected": "예상 연간 이익",
    "industry.roi.calculate_data": "데이터로 계산하기",
    "industry.upgrade_enterprise": "엔터프라이즈로 업그레이드",
    "industry.get_premium": "프리미엄 이용하기",
    "industry.trial": "7일 무료 체험으로 시작하기",
    "industry.efficiency_gain": "효율성 향상",
    "industry.implementation": "구현 기간",
    "industry.impl_weeks": "2-4주",
    "industry.team_size": "팀 규모",
    "industry.any_size": "모든 규모",
    "industry.use_cases": "주요 활용 사례",
    "industry.learn_more": "더 알아보기",
    "industry.legend.without": "양자 없이",
    "industry.legend.with": "양자 프리미엄 포함",
    "industry.choose_plan": "플랜 선택",
    "industry.badge.best": "최고 가치",
    "industry.badge.popular": "인기",
    "industry.compare.feature": "기능",
    "industry.compare.pro": "프로",
    "industry.compare.enterprise": "엔터프라이즈",
    "industry.success_stories": "성공 사례",
    "industry.quantum_solutions": "양자 솔루션",
    "industry.overview": "개요",
    "industry.key_benefits": "주요 이점",
    "industry.learn.ibm": "IBM 양자 학습",
    "industry.learn.mit": "MIT xPRO 양자 과정",
    "industry.learn.roadmap": "IBM 양자 2026 로드맵",

    // Industry Use Cases
    "industry.use.finance.1": "포트폴리오 최적화",
    "industry.use.finance.2": "위험 평가",
    "industry.use.finance.3": "사기 탐지",
    "industry.use.finance.4": "고빈도 거래",
    "industry.use.health.1": "약물 분자 시뮬레이션",
    "industry.use.health.2": "단백질 접힘",
    "industry.use.health.3": "치료 최적화",
    "industry.use.health.4": "의료 영상",
    "industry.use.logistics.1": "경로 최적화",
    "industry.use.logistics.2": "창고 레이아웃",
    "industry.use.logistics.3": "공급망",
    "industry.use.logistics.4": "배송 일정",
    "industry.use.energy.1": "그리드 최적화",
    "industry.use.energy.2": "수요 예측",
    "industry.use.energy.3": "재생에너지 통합",
    "industry.use.energy.4": "부하 분산",
    "industry.use.mfg.1": "품질 관리",
    "industry.use.mfg.2": "예측 유지보수",
    "industry.use.mfg.3": "공정 최적화",
    "industry.use.mfg.4": "재고 관리",
    "industry.use.ai.1": "양자 신경망",
    "industry.use.ai.2": "특성 선택",
    "industry.use.ai.3": "최적화 문제",
    "industry.use.ai.4": "생성 모델",
    "industry.use.default.1": "최적화",
    "industry.use.default.2": "시뮬레이션",
    "industry.use.default.3": "분석",

    // Ecosystem Tab
    "ecosystem.title": "IBM Quantum Ecosystem",
    "ecosystem.subtitle": "에코시스템에서 실제 양자 프로젝트 실행",
    "ecosystem.all": "전체",
    "ecosystem.about": "소개",
    "ecosystem.actions": "빠른 작업",
    "ecosystem.run_demo": "데모 회로 실행",
    "ecosystem.running": "실행 중...",
    "ecosystem.export_code": "샘플 코드 내보내기",
    "ecosystem.view_github": "GitHub에서 보기",
    "ecosystem.result": "실행 결과",
    "ecosystem.use_cases": "사용 사례",
    "ecosystem.sample_code": "샘플 코드",
    "ecosystem.copy": "클립보드에 복사",

    // Ecosystem Categories
    "ecosystem.category.ml": "머신러닝",
    "ecosystem.category.chem": "화학 & 물리",
    "ecosystem.category.opt": "최적화",
    "ecosystem.category.hw": "하드웨어 제공자",
    "ecosystem.category.sim": "시뮬레이션",
    "ecosystem.category.research": "연구",

    // Ecosystem Project Names (Keep English names for recognition)
    "ecosystem.project.torchquantum": "TorchQuantum",
    "ecosystem.project.qiskit_ml": "Qiskit ML",
    "ecosystem.project.qiskit_nature": "Qiskit Nature",
    "ecosystem.project.qiskit_finance": "Qiskit Finance",
    "ecosystem.project.qiskit_optimization": "Qiskit Optimization",
    "ecosystem.project.ibm_quantum": "IBM Quantum",
    "ecosystem.project.azure_quantum": "Azure Quantum",
    "ecosystem.project.aws_braket": "AWS Braket",
    "ecosystem.project.ionq": "IonQ",
    "ecosystem.project.qiskit_aer": "Qiskit Aer",
    "ecosystem.project.mqt_ddsim": "MQT DDSIM",
    "ecosystem.project.pennylane": "PennyLane",
    "ecosystem.project.cirq": "Cirq (Google)",

    // Ecosystem Project Descriptions
    "ecosystem.project.torchquantum.desc": "GPU 지원 PyTorch 기반 양자 ML 프레임워크. 양자 신경망을 매끄럽게 구축하고 훈련합니다.",
    "ecosystem.project.qiskit_ml.desc": "변분 알고리즘, 양자 커널, 신경망을 포함한 양자 머신러닝 모듈입니다.",
    "ecosystem.project.qiskit_nature.desc": "분자 구조와 화학 반응을 시뮬레이션합니다. 신약 발견을 위한 양자 화학입니다.",
    "ecosystem.project.qiskit_finance.desc": "양자 알고리즘을 사용한 포트폴리오 최적화, 옵션 가격 책정, 위험 분석입니다.",
    "ecosystem.project.qiskit_optimization.desc": "QAOA, VQE, Grover 알고리즘으로 조합 최적화 문제를 해결합니다.",
    "ecosystem.project.ibm_quantum.desc": "127+ 큐비트 Eagle 프로세서에 액세스합니다. Brisbane, Osaka, Kyoto 시스템 사용 가능합니다.",
    "ecosystem.project.azure_quantum.desc": "IonQ, Quantinuum, Rigetti 백엔드를 갖춘 Microsoft의 양자 클라우드입니다.",
    "ecosystem.project.aws_braket.desc": "IonQ, Rigetti, OQC 양자 하드웨어를 갖춘 Amazon의 양자 서비스입니다.",
    "ecosystem.project.ionq.desc": "높은 게이트 충실도와 모든 연결성을 갖춘 트랩 이온 양자 컴퓨터입니다.",
    "ecosystem.project.qiskit_aer.desc": "노이즈 모델링 및 GPU 가속을 지원하는 고성능 양자 회로 시뮬레이터입니다.",
    "ecosystem.project.mqt_ddsim.desc": "효율적인 대규모 시뮬레이션을 위한 결정 다이어그램 기반 양자 시뮬레이터입니다.",
    "ecosystem.project.pennylane.desc": "여러 하드웨어 백엔드를 지원하는 크로스 플랫폼 양자 ML 라이브러리입니다.",
    "ecosystem.project.cirq.desc": "NISQ 알고리즘 및 실험을 위한 Google의 양자 프레임워크입니다.",

    // Industry Hero Benefits
    "industry.hero.benefit1": "복잡한 최적화 문제를 며칠이 아닌 몇 분 만에 해결",
    "industry.hero.benefit2": "기존 컴퓨터로는 불가능한 시뮬레이션 실행",
    "industry.hero.benefit3": "양자 우위로 의사결정 속도 가속화",

    // Industry Detail Sheet
    "industry.detail.efficiency": "효율성",
    "industry.detail.weeks": "주",
    "industry.detail.uptime": "가동률",
    "industry.overview.finance": "양자 컴퓨팅은 고급 포트폴리오 최적화, 실시간 위험 분석, 정교한 사기 탐지 기능으로 금융 서비스를 혁신합니다.",
    "industry.overview.healthcare": "의료 분야는 신약 발견을 위한 분자 시뮬레이션, 단백질 접힘 예측, 맞춤형 치료 최적화의 혜택을 받습니다.",
    "industry.overview.logistics": "공급망 관리는 경로 최적화, 재고 관리, 수요 예측을 위한 양자 알고리즘으로 혁신됩니다.",
    "industry.overview.energy": "에너지 분야는 스마트 그리드 최적화, 재생 에너지 통합, 부하 분산 문제에 양자 컴퓨팅을 활용합니다.",
    "industry.overview.manufacturing": "제조 운영은 양자 강화 품질 관리, 예측 유지보수, 공정 최적화의 혜택을 받습니다.",
    "industry.overview.ai": "AI/ML 애플리케이션은 양자 신경망, 특성 선택, 복잡한 최적화 문제로 가속화됩니다.",
    "industry.overview.default": "이 산업은 최적화, 시뮬레이션, 고급 데이터 분석 기능을 통해 양자 컴퓨팅의 혜택을 받습니다.",
    "industry.benefit.finance.1": "양자 알고리즘을 통한 포트폴리오 최적화",
    "industry.benefit.finance.2": "실시간 위험 평가 및 가격 책정",
    "industry.benefit.finance.3": "향상된 사기 탐지 패턴",
    "industry.benefit.finance.4": "고빈도 거래 최적화",
    "industry.benefit.healthcare.1": "약물 분자 시뮬레이션 및 발견",
    "industry.benefit.healthcare.2": "단백질 접힘 예측",
    "industry.benefit.healthcare.3": "맞춤형 치료 최적화",
    "industry.benefit.healthcare.4": "의료 영상 향상",
    "industry.benefit.logistics.1": "글로벌 경로 최적화",
    "industry.benefit.logistics.2": "창고 레이아웃 최적화",
    "industry.benefit.logistics.3": "공급망 탄력성",
    "industry.benefit.logistics.4": "동적 배송 일정",
    "industry.benefit.energy.1": "스마트 그리드 최적화",
    "industry.benefit.energy.2": "수요 예측 정확도",
    "industry.benefit.energy.3": "재생에너지 통합",
    "industry.benefit.energy.4": "부하 분산 효율성",
    "industry.benefit.manufacturing.1": "고급 품질 관리",
    "industry.benefit.manufacturing.2": "예측 유지보수",
    "industry.benefit.manufacturing.3": "공정 최적화",
    "industry.benefit.manufacturing.4": "재고 관리",
    "industry.benefit.ai.1": "양자 신경망 훈련",
    "industry.benefit.ai.2": "특성 선택 최적화",
    "industry.benefit.ai.3": "복잡한 문제 해결",
    "industry.benefit.ai.4": "생성 모델 가속화",
    "industry.benefit.default.1": "공정 최적화",
    "industry.benefit.default.2": "데이터 분석 향상",
    "industry.benefit.default.3": "의사결정 지원 시스템",
    "industry.benefit.default.4": "시뮬레이션 기능",

    // Industry Premium Sheet
    "industry.premium.feat.finance": "실시간 금융 모델링 및 최적화",
    "industry.premium.feat.health": "신약 발견 분자 시뮬레이션",
    "industry.premium.feat.energy": "스마트 그리드 및 에너지 최적화",
    "industry.premium.feat.ai": "양자 ML 모델 훈련",
    "industry.premium.feat.roi": "ROI 계산기 및 분석 대시보드",

    // Ecosystem Use Cases
    "ecosystem.usecase.ml.1": "양자 신경망",
    "ecosystem.usecase.ml.2": "특성 선택",
    "ecosystem.usecase.ml.3": "분류 문제",
    "ecosystem.usecase.ml.4": "회귀 분석",
    "ecosystem.usecase.chem.1": "분자 시뮬레이션",
    "ecosystem.usecase.chem.2": "에너지 계산",
    "ecosystem.usecase.chem.3": "반응 예측",
    "ecosystem.usecase.chem.4": "신약 발견",
    "ecosystem.usecase.opt.1": "조합 최적화",
    "ecosystem.usecase.opt.2": "포트폴리오 관리",
    "ecosystem.usecase.opt.3": "경로 계획",
    "ecosystem.usecase.opt.4": "자원 할당",
    "ecosystem.usecase.hw.1": "회로 캘리브레이션",
    "ecosystem.usecase.hw.2": "오류 완화",
    "ecosystem.usecase.hw.3": "노이즈 특성화",
    "ecosystem.usecase.hw.4": "성능 벤치마킹",
    "ecosystem.usecase.sim.1": "물리 시뮬레이션",
    "ecosystem.usecase.sim.2": "재료 과학",
    "ecosystem.usecase.sim.3": "금융 모델링",
    "ecosystem.usecase.sim.4": "기후 모델링",
    "ecosystem.usecase.research.1": "알고리즘 개발",
    "ecosystem.usecase.research.2": "오류 정정",
    "ecosystem.usecase.research.3": "양자 우위 연구",
    "ecosystem.usecase.research.4": "이론 분석",

    // Academy Marketing View
    "academy.done": "완료",
    "academy.hero.subtitle": "양자 컴퓨팅 마스터하기",
    "academy.hero.reviews": "(2.4천 리뷰)",
    "academy.features.title": "왜 QuantumNative로 배워야 할까요?",
    "academy.features.interactive.title": "인터랙티브 학습",
    "academy.features.interactive.desc": "실시간 시각화와 함께하는 실습 양자 회로",
    "academy.features.progress.title": "진도 추적",
    "academy.features.progress.desc": "경험치, 업적, 학습 연속 기록",
    "academy.features.synced.title": "동기화된 계정",
    "academy.features.synced.desc": "SwiftQuantum 앱 간 진도 동기화",
    "academy.features.passport.title": "커리어 패스포트",
    "academy.features.passport.desc": "검증 가능한 양자 컴퓨팅 자격증 획득",
    "academy.courses.title": "12개 이상의 코스 제공",
    "academy.courses.basics": "양자 기초",
    "academy.courses.gates": "양자 게이트",
    "academy.courses.entanglement": "얽힘",
    "academy.courses.algorithms": "알고리즘",
    "academy.courses.free": "무료",
    "academy.courses.lessons": "레슨",
    "academy.testimonial.quote": "QuantumNative 덕분에 양자 컴퓨팅을 쉽게 배울 수 있었어요. 단 2주 만에 양자 알고리즘을 구축할 수 있게 되었습니다!",
    "academy.testimonial.initials": "김민",
    "academy.testimonial.name": "김민준",
    "academy.testimonial.role": "소프트웨어 엔지니어",
    "academy.cta.download": "QuantumNative 다운로드",
    "academy.cta.subtitle": "무료 다운로드 · 프리미엄 코스 제공",

    // Profile
    "profile.title": "프로필",

    // Circuits Hero Benefits
    "circuits.hero.benefit1": "드래그 앤 드롭으로 시각적으로 양자 회로 구축",
    "circuits.hero.benefit2": "일반 알고리즘용 사전 제작 템플릿 사용",
    "circuits.hero.benefit3": "시뮬레이션 실행하고 즉시 결과 확인",

    // Industry Card Titles & Benefits
    "industry.card.finance": "금융",
    "industry.card.finance.benefit": "포트폴리오 최적화 및 리스크 분석",
    "industry.card.healthcare": "의료",
    "industry.card.healthcare.benefit": "신약 발견 가속화",
    "industry.card.logistics": "물류",
    "industry.card.logistics.benefit": "경로 최적화 및 스케줄링",
    "industry.card.energy": "에너지",
    "industry.card.energy.benefit": "그리드 최적화 및 예측",
    "industry.card.manufacturing": "제조",
    "industry.card.manufacturing.benefit": "공급망 최적화",
    "industry.card.ai": "AI & ML",
    "industry.card.ai.benefit": "양자 머신러닝",

    // Auth - Login/SignUp
    "auth.welcome_back": "다시 오신 것을 환영합니다",
    "auth.create_account": "계정 만들기",
    "auth.reset_password": "비밀번호 재설정",
    "auth.email": "이메일",
    "auth.username": "사용자 이름",
    "auth.password": "비밀번호",
    "auth.password_min": "비밀번호 (최소 6자)",
    "auth.confirm_password": "비밀번호 확인",
    "auth.login": "로그인",
    "auth.signup": "회원가입",
    "auth.forgot_password": "비밀번호를 잊으셨나요?",
    "auth.no_account": "계정이 없으신가요?",
    "auth.have_account": "이미 계정이 있으신가요?",
    "auth.passwords_match": "비밀번호가 일치합니다",
    "auth.passwords_no_match": "비밀번호가 일치하지 않습니다",
    "auth.send_reset": "재설정 링크 보내기",
    "auth.back_to_login": "로그인으로 돌아가기",
    "auth.reset_instruction": "이메일 주소를 입력하시면 비밀번호 재설정 링크를 보내드립니다.",

    // Subscription - Paywall
    "subscription.title": "SwiftQuantum 잠금 해제",
    "subscription.subtitle": "양자 컴퓨팅의 모든 기능에 접근하세요",
    "subscription.choose_plan": "플랜을 선택하세요",
    "subscription.close": "닫기",
    "subscription.pro": "Pro",
    "subscription.premium": "Premium",
    "subscription.monthly": "월간",
    "subscription.yearly": "연간",
    "subscription.per_month": "/월",
    "subscription.per_year": "/년",
    "subscription.save_percent": "33% 할인",
    "subscription.recommended": "추천",
    "subscription.subscribe": "구독하기",
    "subscription.restore": "구매 복원",
    "subscription.legal": "현재 기간 종료 24시간 전에 취소하지 않으면 구독이 자동 갱신됩니다.",
    "subscription.terms": "이용약관",
    "subscription.privacy": "개인정보 처리방침",
    "subscription.success_title": "Premium에 오신 것을 환영합니다!",
    "subscription.success_subtitle": "모든 기능이 잠금 해제되었습니다",
    "subscription.get_started": "시작하기",

    // Pro Features
    "subscription.pro.feature1": "아카데미 전체 12개 코스",
    "subscription.pro.feature2": "40큐비트 로컬 시뮬레이션",
    "subscription.pro.feature3": "고급 예제",
    "subscription.pro.feature4": "이메일 지원",
    "subscription.pro.desc_monthly": "확장 시뮬레이션과 전체 아카데미 접근",
    "subscription.pro.desc_yearly": "양자 컴퓨팅 학습에 최적의 가치",

    // Premium Features
    "subscription.premium.feature1": "Pro의 모든 기능 포함",
    "subscription.premium.feature2": "QuantumBridge QPU 연결",
    "subscription.premium.feature3": "오류 정정 시뮬레이션",
    "subscription.premium.feature4": "산업 솔루션 접근",
    "subscription.premium.feature5": "우선 지원",
    "subscription.premium.desc_monthly": "실제 양자 하드웨어 전체 접근",
    "subscription.premium.desc_yearly": "최적 가격의 완전한 양자 경험",

    // Subscription Tabs & Comparison
    "subscription.tab.compare": "비교",
    "subscription.tab.pro": "Pro",
    "subscription.tab.premium": "Premium",
    "subscription.features": "기능",
    "subscription.free": "무료",
    "subscription.select_plan": "플랜 선택",
    "subscription.compare.circuits": "양자 회로",
    "subscription.compare.simulation": "로컬 시뮬레이션",
    "subscription.compare.academy_basic": "아카데미 (기본)",
    "subscription.compare.academy_full": "아카데미 (전체)",
    "subscription.compare.qpu_access": "실제 QPU 접근",
    "subscription.compare.industry": "산업 솔루션",
    "subscription.compare.support": "이메일 지원",
    "subscription.compare.priority": "우선 지원",
    "subscription.pro.subtitle": "학습과 실험에 완벽",
    "subscription.premium.subtitle": "완전한 양자 컴퓨팅 경험",

    // More Hub - Subscription Info
    "more.subscription_info": "구독 알아보기",
    "more.subscription_info.subtitle": "Pro & Premium 기능 알아보기",

    // Subscription Info Page
    "subscription.info.title": "프리미엄 잠금 해제",
    "subscription.info.subtitle": "Pro 또는 Premium으로 SwiftQuantum을 최대한 활용하세요",
    "subscription.info.choose_tier": "플랜을 선택하세요",
    "subscription.info.best_value": "추천",
    "subscription.info.pro.feature1": "실제 QPU 접근",
    "subscription.info.pro.feature2": "모든 회로 템플릿",
    "subscription.info.pro.feature3": "우선 지원",
    "subscription.info.premium.feature1": "Pro의 모든 기능",
    "subscription.info.premium.feature2": "오류 정정",
    "subscription.info.premium.feature3": "산업 솔루션",
    "subscription.info.all_features": "모든 프리미엄 기능",
    "subscription.info.feature.qpu": "실제 QPU 접근",
    "subscription.info.feature.qpu.desc": "127개 이상의 큐빗을 가진 IBM 양자 컴퓨터에서 회로 실행",
    "subscription.info.feature.academy": "양자 아카데미",
    "subscription.info.feature.academy.desc": "MIT/Harvard 스타일 코스 및 레슨 전체 접근",
    "subscription.info.feature.industry": "산업 솔루션",
    "subscription.info.feature.industry.desc": "비즈니스를 위한 엔터프라이즈 양자 최적화",
    "subscription.info.feature.error": "오류 정정",
    "subscription.info.feature.error.desc": "서피스 코드 시뮬레이션 및 결함 허용 컴퓨팅",
    "subscription.info.feature.support": "우선 지원",
    "subscription.info.feature.support.desc": "양자 전문가로부터 빠른 답변 받기",
    "subscription.info.subscribe_now": "지금 구독하기",
    "subscription.info.cancel_anytime": "언제든 취소 가능. 약정 없음."
]

// MARK: - Dynamic Localized Strings (Japanese)
private let japaneseDynamicStrings: [String: String] = [
    // Bridge Tab - Introduction
    "bridge.why_use": "ブリッジを使う理由",
    "bridge.connect_real": "実際の量子コンピューターに接続",
    "bridge.learn_more": "詳細を見る",
    "bridge.benefit.hardware.title": "実機ハードウェア",
    "bridge.benefit.hardware.desc": "127以上のキュービットを持つIBM量子コンピューターにアクセス",
    "bridge.benefit.quantum.title": "量子優位性",
    "bridge.benefit.quantum.desc": "古典コンピューターでは不可能なアルゴリズムを実行",
    "bridge.benefit.results.title": "実際の結果",
    "bridge.benefit.results.desc": "実際の量子測定データを取得",

    // Bridge Tab - Connection
    "bridge.status.active": "接続中",
    "bridge.status.disconnected": "切断",
    "bridge.connect": "接続",
    "bridge.disconnect": "切断",
    "executor.local": "ローカルデバイス",

    // Bridge Tab - Backend Selection
    "bridge.select_backend": "バックエンドを選択",
    "bridge.select_backend.desc": "回路に使用する量子プロセッサーを選択",
    "bridge.best_for": "最適な用途",
    "bridge.advantages": "利点",
    "bridge.limitations": "制限事項",

    // Backend Details
    "bridge.backend.simulator.title": "ローカルシミュレーター",
    "bridge.backend.simulator.best": "テストと開発",
    "bridge.backend.simulator.adv1": "即座の結果",
    "bridge.backend.simulator.adv2": "待機時間なし",
    "bridge.backend.simulator.adv3": "完璧な精度",
    "bridge.backend.simulator.lim1": "制限されたキュービット (20)",
    "bridge.backend.simulator.lim2": "実際の量子効果なし",
    "bridge.backend.brisbane.title": "IBM ブリスベン",
    "bridge.backend.brisbane.best": "本番ワークロード",
    "bridge.backend.brisbane.adv1": "高いコヒーレンス時間",
    "bridge.backend.brisbane.adv2": "安定したパフォーマンス",
    "bridge.backend.osaka.title": "IBM 大阪",
    "bridge.backend.osaka.best": "高速実験",
    "bridge.backend.osaka.adv1": "高速ゲート",
    "bridge.backend.osaka.adv2": "低レイテンシー",
    "bridge.backend.osaka.lim1": "高いエラー率",
    "bridge.backend.kyoto.title": "IBM 京都",
    "bridge.backend.kyoto.best": "研究アプリケーション",
    "bridge.backend.kyoto.adv1": "研究グレード",
    "bridge.backend.kyoto.adv2": "高度なキャリブレーション",
    "bridge.backend.kyoto.lim1": "頻繁なメンテナンス",
    "bridge.backend.kyoto.lim2": "限られた可用性",
    "bridge.backend.qubits127": "127 キュービット",
    "bridge.backend.queue_wait": "キュー待機時間",
    "bridge.backend.limited_daily": "1日の実行制限",

    // Other keys...
    "bridge.queue.title": "キュー状態",
    "bridge.queue.pending": "保留中",
    "bridge.queue.running": "実行中",
    "bridge.queue.est_wait": "推定待機",
    "bridge.deploy.title": "回路をデプロイ",
    "bridge.deploy.hold": "長押しでデプロイ",
    "bridge.deploy.deploying": "デプロイ中...",
    "bridge.deploy.hold_text": "2秒間長押しして回路をデプロイ",
    "bridge.jobs.title": "アクティブなジョブ",
    "bridge.actions.title": "クイックアクション",
    "bridge.actions.subtitle": "ワンタップ量子操作",
    "bridge.action.bell": "ベル状態",
    "bridge.action.bell.sub": "量子もつれ",
    "bridge.action.ghz": "GHZ状態",
    "bridge.action.ghz.sub": "マルチキュービットもつれ",
    "bridge.action.export": "QASMエクスポート",
    "bridge.action.export.sub": "回路コードを取得",
    "bridge.action.continuous": "連続モード",
    "bridge.action.continuous.sub": "自動繰り返し",
    "bridge.action.stop_continuous": "停止",
    "bridge.action.running": "実行中...",
    "bridge.continuous.active": "連続モード有効",
    "bridge.continuous.desc": "30秒ごとに自動的に回路を実行",
    "bridge.continuous.runs": "回実行",
    "bridge.ecc.title": "誤り訂正",
    "bridge.ecc.status": "状態",
    "bridge.ecc.correcting": "エラー訂正中...",
    "bridge.ecc.fidelity": "忠実度",
    "bridge.qasm.title": "QASMコード",
    "bridge.qasm.copy": "クリップボードにコピー",
    "bridge.qasm.copied": "コピー完了!",
    "bridge.qasm.share": "共有",
    "bridge.qasm.what": "QASMとは?",
    "bridge.qasm.desc": "OpenQASMは量子回路を記述する標準言語です。このコードはIBM Quantum Labや他のプラットフォームで使用できます。",
    "bridge.apikey.title": "IBM Quantum APIキー",
    "bridge.apikey.desc": "実際の量子コンピューターに接続するにはIBM Quantum APIキーを入力してください",
    "bridge.apikey.placeholder": "APIキーを入力",
    "bridge.premium.title": "ブリッジをアンロック",
    "bridge.premium.desc": "SwiftQuantum ProでIBM量子コンピューターにアクセス",
    "bridge.premium.feat1": "127以上のキュービット量子コンピューター",
    "bridge.premium.feat2": "実機量子ハードウェアアクセス",
    "bridge.premium.feat3": "優先キュー配置",
    "bridge.premium.feat4": "誤り訂正サポート",
    "bridge.premium.feat5": "無制限の1日実行",
    "bridge.premium.upgrade": "Proにアップグレード",
    "bridge.premium.trial": "7日間無料トライアル・いつでもキャンセル可能",
    "circuits.difficulty.beginner": "初級",
    "circuits.difficulty.intermediate": "中級",
    "circuits.difficulty.advanced": "上級",
    "circuits.premium.title": "プレミアム回路",
    "circuits.premium.desc": "この回路にはProサブスクリプションが必要です。",
    "circuits.premium.unlock": "Proでアンロック",
    "circuits.premium.features.title": "Pro機能",
    "circuits.premium.features.1": "すべての上級回路",
    "circuits.premium.features.2": "実機量子ハードウェア",
    "circuits.premium.features.3": "優先サポート",
    "industry.use.finance": "金融モデリング",
    "industry.use.pharma": "創薬",
    "industry.use.logistics": "サプライチェーン",
    "industry.use.security": "暗号化",
    "industry.legend.company": "企業",
    "industry.legend.tech": "技術",
    "industry.legend.market": "市場",
    "industry.badge.leader": "リーダー",
    "industry.badge.emerging": "新興",
    "more.academy": "アカデミー",
    "more.academy.desc": "量子コンピューティングを学ぶ",
    "more.academy.subtitle": "量子コンピューティングを学ぶ",
    "more.industry.subtitle": "企業ソリューション",
    "more.profile.subtitle": "あなたの量子の旅",
    "more.settings": "設定",
    "more.settings.desc": "体験をカスタマイズ",
    "more.about": "アプリについて",
    "more.about.desc": "アプリ情報とバージョン",
    "more.help": "ヘルプとサポート",
    "more.help.desc": "サポートを受ける",
    "more.language": "言語",
    "more.language.desc": "アプリの言語を変更",
    "more.notifications": "通知",
    "more.notifications.desc": "アラートを管理",
    "more.privacy": "プライバシー",
    "more.privacy.desc": "ポリシーを読む",
    "more.terms": "利用規約",
    "more.terms.desc": "法的情報",
    "more.rate": "アプリを評価",
    "more.rate.desc": "レビューを書く",
    "more.share": "アプリを共有",
    "more.share.desc": "友達に教える",
    "more.feedback": "フィードバックを送信",
    "more.feedback.desc": "ご意見をお聞かせください",
    "more.premium.status": "プレミアムステータス",
    "more.premium.active": "有効",
    "more.premium.upgrade": "Proにアップグレード",
    "more.done": "完了",
    "more.login": "ログイン",
    "more.premium": "プレミアム",
    "more.admin": "管理者",
    "more.coming_soon": "近日公開",
    "more.coming_soon_message": "この機能は今後のアップデートで利用可能になります。",
    "more.ok": "OK",
    "more.reset_tutorial": "チュートリアルをリセット",
    "more.reset": "リセット",
    "more.cancel": "キャンセル",
    "more.reset_message": "アプリを再起動するとオンボーディングチュートリアルが再度表示されます。",
    "more.appearance": "外観",

    // Industry Tab Additional
    "industry.title": "産業ソリューション",
    "industry.subtitle": "量子パワードビジネス最適化",
    "industry.stat.efficiency": "効率",
    "industry.stat.roi": "ROI",
    "industry.stat.clients": "クライアント",
    "industry.efficiency": "効率",
    "industry.premium.title": "エンタープライズソリューションプレミアム",
    "industry.premium.desc": "すべての産業ソリューションと量子ビジネス最適化をアンロック",
    "industry.premium.upgrade": "アップグレード - ¥1,480/月",
    "industry.premium.trial": "7日間無料トライアル付き",
    "industry.get_started": "始める",
    "industry.pricing_soon": "価格詳細は近日公開",
    "industry.roi.title": "ROI計算機",
    "industry.roi.estimate": "量子アドバンテージを推定",
    "industry.roi.subtitle": "潜在的なリターンを計算",
    "industry.roi.calculate": "ROIを計算",
    "industry.roi.progress": "レベル8の進捗に基づく",
    "industry.roi.team_size": "チームサイズ",
    "industry.roi.budget": "年間IT予算",
    "industry.roi.calculate_btn": "ROIを計算",
    "industry.roi.estimated_savings": "推定年間節約額",
    "industry.roi.payback": "回収期間",
    "industry.roi.projected": "予想年間利益",
    "industry.roi.calculate_data": "データで計算",
    "industry.upgrade_enterprise": "エンタープライズにアップグレード",
    "industry.get_premium": "プレミアムを取得",
    "industry.trial": "7日間無料トライアルを開始",
    "industry.efficiency_gain": "効率向上",
    "industry.implementation": "導入期間",
    "industry.impl_weeks": "2-4週間",
    "industry.team_size": "チームサイズ",
    "industry.any_size": "あらゆる規模",
    "industry.use_cases": "主なユースケース",
    "industry.learn_more": "詳細を見る",
    "industry.legend.without": "量子なし",
    "industry.legend.with": "量子プレミアム付き",
    "industry.choose_plan": "プランを選択",
    "industry.badge.best": "最高価値",
    "industry.badge.popular": "人気",
    "industry.compare.feature": "機能",
    "industry.compare.pro": "プロ",
    "industry.compare.enterprise": "エンタープライズ",
    "industry.success_stories": "成功事例",
    "industry.quantum_solutions": "量子ソリューション",
    "industry.overview": "概要",
    "industry.key_benefits": "主な利点",
    "industry.learn.ibm": "IBM Quantum学習",
    "industry.learn.mit": "MIT xPRO量子コース",
    "industry.learn.roadmap": "IBM Quantum 2026ロードマップ",

    // Industry Use Cases
    "industry.use.finance.1": "ポートフォリオ最適化",
    "industry.use.finance.2": "リスク評価",
    "industry.use.finance.3": "詐欺検出",
    "industry.use.finance.4": "高頻度取引",
    "industry.use.health.1": "薬物分子シミュレーション",
    "industry.use.health.2": "タンパク質折りたたみ",
    "industry.use.health.3": "治療最適化",
    "industry.use.health.4": "医療画像",
    "industry.use.logistics.1": "ルート最適化",
    "industry.use.logistics.2": "倉庫レイアウト",
    "industry.use.logistics.3": "サプライチェーン",
    "industry.use.logistics.4": "配送スケジュール",
    "industry.use.energy.1": "グリッド最適化",
    "industry.use.energy.2": "需要予測",
    "industry.use.energy.3": "再生可能エネルギー統合",
    "industry.use.energy.4": "負荷分散",
    "industry.use.mfg.1": "品質管理",
    "industry.use.mfg.2": "予知保全",
    "industry.use.mfg.3": "プロセス最適化",
    "industry.use.mfg.4": "在庫管理",
    "industry.use.ai.1": "量子ニューラルネットワーク",
    "industry.use.ai.2": "特徴選択",
    "industry.use.ai.3": "最適化問題",
    "industry.use.ai.4": "生成モデル",
    "industry.use.default.1": "最適化",
    "industry.use.default.2": "シミュレーション",
    "industry.use.default.3": "分析",

    // Ecosystem Tab
    "ecosystem.title": "IBM Quantum Ecosystem",
    "ecosystem.subtitle": "エコシステムから実際の量子プロジェクトを実行",
    "ecosystem.all": "すべて",
    "ecosystem.about": "概要",
    "ecosystem.actions": "クイックアクション",
    "ecosystem.run_demo": "デモ回路を実行",
    "ecosystem.running": "実行中...",
    "ecosystem.export_code": "サンプルコードをエクスポート",
    "ecosystem.view_github": "GitHubで見る",
    "ecosystem.result": "実行結果",
    "ecosystem.use_cases": "ユースケース",
    "ecosystem.sample_code": "サンプルコード",
    "ecosystem.copy": "クリップボードにコピー",

    // Ecosystem Categories
    "ecosystem.category.ml": "機械学習",
    "ecosystem.category.chem": "化学・物理",
    "ecosystem.category.opt": "最適化",
    "ecosystem.category.hw": "ハードウェアプロバイダー",
    "ecosystem.category.sim": "シミュレーション",
    "ecosystem.category.research": "研究",

    // Ecosystem Project Names (Keep English names for recognition)
    "ecosystem.project.torchquantum": "TorchQuantum",
    "ecosystem.project.qiskit_ml": "Qiskit ML",
    "ecosystem.project.qiskit_nature": "Qiskit Nature",
    "ecosystem.project.qiskit_finance": "Qiskit Finance",
    "ecosystem.project.qiskit_optimization": "Qiskit Optimization",
    "ecosystem.project.ibm_quantum": "IBM Quantum",
    "ecosystem.project.azure_quantum": "Azure Quantum",
    "ecosystem.project.aws_braket": "AWS Braket",
    "ecosystem.project.ionq": "IonQ",
    "ecosystem.project.qiskit_aer": "Qiskit Aer",
    "ecosystem.project.mqt_ddsim": "MQT DDSIM",
    "ecosystem.project.pennylane": "PennyLane",
    "ecosystem.project.cirq": "Cirq (Google)",

    // Ecosystem Project Descriptions
    "ecosystem.project.torchquantum.desc": "GPU対応のPyTorchベース量子MLフレームワーク。量子ニューラルネットワークをシームレスに構築・訓練します。",
    "ecosystem.project.qiskit_ml.desc": "変分アルゴリズム、量子カーネル、ニューラルネットワークを含む量子機械学習モジュールです。",
    "ecosystem.project.qiskit_nature.desc": "分子構造と化学反応をシミュレートします。創薬のための量子化学です。",
    "ecosystem.project.qiskit_finance.desc": "量子アルゴリズムを使用したポートフォリオ最適化、オプション価格設定、リスク分析です。",
    "ecosystem.project.qiskit_optimization.desc": "QAOA、VQE、Groverアルゴリズムで組み合わせ最適化問題を解決します。",
    "ecosystem.project.ibm_quantum.desc": "127+量子ビットEagleプロセッサにアクセス。Brisbane、Osaka、Kyotoシステムが利用可能です。",
    "ecosystem.project.azure_quantum.desc": "IonQ、Quantinuum、Rigettiバックエンドを持つMicrosoftの量子クラウドです。",
    "ecosystem.project.aws_braket.desc": "IonQ、Rigetti、OQC量子ハードウェアを持つAmazonの量子サービスです。",
    "ecosystem.project.ionq.desc": "高いゲート忠実度と全対全接続性を持つイオントラップ量子コンピューターです。",
    "ecosystem.project.qiskit_aer.desc": "ノイズモデリングとGPU加速をサポートする高性能量子回路シミュレーターです。",
    "ecosystem.project.mqt_ddsim.desc": "効率的な大規模シミュレーションのための決定図ベースの量子シミュレーターです。",
    "ecosystem.project.pennylane.desc": "複数のハードウェアバックエンドをサポートするクロスプラットフォーム量子MLライブラリです。",
    "ecosystem.project.cirq.desc": "NISQアルゴリズムと実験のためのGoogleの量子フレームワークです。",

    // Industry Hero Benefits
    "industry.hero.benefit1": "複雑な最適化問題を数日ではなく数分で解決",
    "industry.hero.benefit2": "古典コンピューターでは不可能なシミュレーションを実行",
    "industry.hero.benefit3": "量子優位性で意思決定を加速",

    // Industry Detail Sheet
    "industry.detail.efficiency": "効率",
    "industry.detail.weeks": "週間",
    "industry.detail.uptime": "稼働率",
    "industry.overview.finance": "量子コンピューティングは、高度なポートフォリオ最適化、リアルタイムリスク分析、洗練された詐欺検出機能で金融サービスを変革します。",
    "industry.overview.healthcare": "医療分野は、創薬のための分子シミュレーション、タンパク質折りたたみ予測、個別化治療の最適化の恩恵を受けます。",
    "industry.overview.logistics": "サプライチェーン管理は、ルート最適化、在庫管理、需要予測のための量子アルゴリズムで革新されます。",
    "industry.overview.energy": "エネルギー分野は、スマートグリッド最適化、再生可能エネルギー統合、負荷分散の課題に量子コンピューティングを活用します。",
    "industry.overview.manufacturing": "製造業は、量子強化品質管理、予知保全、プロセス最適化の恩恵を受けます。",
    "industry.overview.ai": "AI/MLアプリケーションは、量子ニューラルネットワーク、特徴選択、複雑な最適化問題で加速されます。",
    "industry.overview.default": "この産業は、最適化、シミュレーション、高度なデータ分析機能を通じて量子コンピューティングの恩恵を受けます。",
    "industry.benefit.finance.1": "量子アルゴリズムによるポートフォリオ最適化",
    "industry.benefit.finance.2": "リアルタイムリスク評価と価格設定",
    "industry.benefit.finance.3": "強化された詐欺検出パターン",
    "industry.benefit.finance.4": "高頻度取引の最適化",
    "industry.benefit.healthcare.1": "薬物分子シミュレーションと発見",
    "industry.benefit.healthcare.2": "タンパク質折りたたみ予測",
    "industry.benefit.healthcare.3": "個別化治療の最適化",
    "industry.benefit.healthcare.4": "医療画像の強化",
    "industry.benefit.logistics.1": "グローバルルート最適化",
    "industry.benefit.logistics.2": "倉庫レイアウト最適化",
    "industry.benefit.logistics.3": "サプライチェーンの回復力",
    "industry.benefit.logistics.4": "動的配送スケジュール",
    "industry.benefit.energy.1": "スマートグリッド最適化",
    "industry.benefit.energy.2": "需要予測精度",
    "industry.benefit.energy.3": "再生可能エネルギー統合",
    "industry.benefit.energy.4": "負荷分散効率",
    "industry.benefit.manufacturing.1": "高度な品質管理",
    "industry.benefit.manufacturing.2": "予知保全",
    "industry.benefit.manufacturing.3": "プロセス最適化",
    "industry.benefit.manufacturing.4": "在庫管理",
    "industry.benefit.ai.1": "量子ニューラルネットワーク訓練",
    "industry.benefit.ai.2": "特徴選択の最適化",
    "industry.benefit.ai.3": "複雑な問題解決",
    "industry.benefit.ai.4": "生成モデルの加速",
    "industry.benefit.default.1": "プロセス最適化",
    "industry.benefit.default.2": "データ分析の強化",
    "industry.benefit.default.3": "意思決定支援システム",
    "industry.benefit.default.4": "シミュレーション機能",

    // Industry Premium Sheet
    "industry.premium.feat.finance": "リアルタイム金融モデリングと最適化",
    "industry.premium.feat.health": "創薬分子シミュレーション",
    "industry.premium.feat.energy": "スマートグリッドとエネルギー最適化",
    "industry.premium.feat.ai": "量子MLモデル訓練",
    "industry.premium.feat.roi": "ROI計算機と分析ダッシュボード",

    // Ecosystem Use Cases
    "ecosystem.usecase.ml.1": "量子ニューラルネットワーク",
    "ecosystem.usecase.ml.2": "特徴選択",
    "ecosystem.usecase.ml.3": "分類問題",
    "ecosystem.usecase.ml.4": "回帰分析",
    "ecosystem.usecase.chem.1": "分子シミュレーション",
    "ecosystem.usecase.chem.2": "エネルギー計算",
    "ecosystem.usecase.chem.3": "反応予測",
    "ecosystem.usecase.chem.4": "創薬",
    "ecosystem.usecase.opt.1": "組み合わせ最適化",
    "ecosystem.usecase.opt.2": "ポートフォリオ管理",
    "ecosystem.usecase.opt.3": "ルート計画",
    "ecosystem.usecase.opt.4": "リソース割り当て",
    "ecosystem.usecase.hw.1": "回路キャリブレーション",
    "ecosystem.usecase.hw.2": "エラー軽減",
    "ecosystem.usecase.hw.3": "ノイズ特性評価",
    "ecosystem.usecase.hw.4": "パフォーマンスベンチマーク",
    "ecosystem.usecase.sim.1": "物理シミュレーション",
    "ecosystem.usecase.sim.2": "材料科学",
    "ecosystem.usecase.sim.3": "金融モデリング",
    "ecosystem.usecase.sim.4": "気候モデリング",
    "ecosystem.usecase.research.1": "アルゴリズム開発",
    "ecosystem.usecase.research.2": "エラー訂正",
    "ecosystem.usecase.research.3": "量子優位性研究",
    "ecosystem.usecase.research.4": "理論分析",

    // Academy Marketing View
    "academy.done": "完了",
    "academy.hero.subtitle": "量子コンピューティングをマスター",
    "academy.hero.reviews": "(2.4Kレビュー)",
    "academy.features.title": "なぜQuantumNativeで学ぶのか?",
    "academy.features.interactive.title": "インタラクティブ学習",
    "academy.features.interactive.desc": "リアルタイム可視化付きの実践的な量子回路",
    "academy.features.progress.title": "進捗トラッキング",
    "academy.features.progress.desc": "経験値、実績、学習ストリーク",
    "academy.features.synced.title": "同期アカウント",
    "academy.features.synced.desc": "SwiftQuantumアプリ間で進捗を同期",
    "academy.features.passport.title": "キャリアパスポート",
    "academy.features.passport.desc": "検証可能な量子コンピューティング資格を取得",
    "academy.courses.title": "12以上のコースを提供",
    "academy.courses.basics": "量子基礎",
    "academy.courses.gates": "量子ゲート",
    "academy.courses.entanglement": "エンタングルメント",
    "academy.courses.algorithms": "アルゴリズム",
    "academy.courses.free": "無料",
    "academy.courses.lessons": "レッスン",
    "academy.testimonial.quote": "QuantumNativeのおかげで量子コンピューティングを身近に感じられました。わずか2週間で量子アルゴリズムを構築できるようになりました!",
    "academy.testimonial.initials": "田中",
    "academy.testimonial.name": "田中健一",
    "academy.testimonial.role": "ソフトウェアエンジニア",
    "academy.cta.download": "QuantumNativeをダウンロード",
    "academy.cta.subtitle": "無料ダウンロード・プレミアムコース提供中",

    // Profile
    "profile.title": "プロフィール",

    // Circuits Hero Benefits
    "circuits.hero.benefit1": "ドラッグ&ドロップで量子回路を視覚的に構築",
    "circuits.hero.benefit2": "一般的なアルゴリズム用の事前構築テンプレートを使用",
    "circuits.hero.benefit3": "シミュレーションを実行して即座に結果を確認",

    // Industry Card Titles & Benefits
    "industry.card.finance": "金融",
    "industry.card.finance.benefit": "ポートフォリオ最適化とリスク分析",
    "industry.card.healthcare": "医療",
    "industry.card.healthcare.benefit": "創薬加速",
    "industry.card.logistics": "物流",
    "industry.card.logistics.benefit": "ルート最適化とスケジューリング",
    "industry.card.energy": "エネルギー",
    "industry.card.energy.benefit": "グリッド最適化と予測",
    "industry.card.manufacturing": "製造",
    "industry.card.manufacturing.benefit": "サプライチェーン最適化",
    "industry.card.ai": "AI & ML",
    "industry.card.ai.benefit": "量子機械学習",

    // Auth - Login/SignUp
    "auth.welcome_back": "おかえりなさい",
    "auth.create_account": "アカウント作成",
    "auth.reset_password": "パスワードリセット",
    "auth.email": "メールアドレス",
    "auth.username": "ユーザー名",
    "auth.password": "パスワード",
    "auth.password_min": "パスワード（6文字以上）",
    "auth.confirm_password": "パスワード確認",
    "auth.login": "ログイン",
    "auth.signup": "新規登録",
    "auth.forgot_password": "パスワードをお忘れですか？",
    "auth.no_account": "アカウントをお持ちではありませんか？",
    "auth.have_account": "すでにアカウントをお持ちですか？",
    "auth.passwords_match": "パスワードが一致しました",
    "auth.passwords_no_match": "パスワードが一致しません",
    "auth.send_reset": "リセットリンクを送信",
    "auth.back_to_login": "ログインに戻る",
    "auth.reset_instruction": "メールアドレスを入力してください。パスワードリセットリンクをお送りします。",

    // Subscription - Paywall
    "subscription.title": "SwiftQuantumをアンロック",
    "subscription.subtitle": "量子コンピューティングの全機能にアクセス",
    "subscription.choose_plan": "プランを選択",
    "subscription.close": "閉じる",
    "subscription.pro": "Pro",
    "subscription.premium": "Premium",
    "subscription.monthly": "月額",
    "subscription.yearly": "年額",
    "subscription.per_month": "/月",
    "subscription.per_year": "/年",
    "subscription.save_percent": "33%オフ",
    "subscription.recommended": "おすすめ",
    "subscription.subscribe": "購読する",
    "subscription.restore": "購入を復元",
    "subscription.legal": "現在の期間終了の24時間前までにキャンセルしない限り、サブスクリプションは自動更新されます。",
    "subscription.terms": "利用規約",
    "subscription.privacy": "プライバシーポリシー",
    "subscription.success_title": "Premiumへようこそ！",
    "subscription.success_subtitle": "すべての機能がアンロックされました",
    "subscription.get_started": "始める",

    // Pro Features
    "subscription.pro.feature1": "アカデミー全12コース",
    "subscription.pro.feature2": "40量子ビットローカルシミュレーション",
    "subscription.pro.feature3": "高度な例題",
    "subscription.pro.feature4": "メールサポート",
    "subscription.pro.desc_monthly": "拡張シミュレーションと全アカデミーアクセス",
    "subscription.pro.desc_yearly": "量子コンピューティング学習に最適",

    // Premium Features
    "subscription.premium.feature1": "Proのすべての機能",
    "subscription.premium.feature2": "QuantumBridge QPU接続",
    "subscription.premium.feature3": "エラー訂正シミュレーション",
    "subscription.premium.feature4": "産業ソリューションアクセス",
    "subscription.premium.feature5": "優先サポート",
    "subscription.premium.desc_monthly": "実際の量子ハードウェアへのフルアクセス",
    "subscription.premium.desc_yearly": "最高の価格で完全な量子体験",

    // Subscription Tabs & Comparison
    "subscription.tab.compare": "比較",
    "subscription.tab.pro": "Pro",
    "subscription.tab.premium": "Premium",
    "subscription.features": "機能",
    "subscription.free": "無料",
    "subscription.select_plan": "プランを選択",
    "subscription.compare.circuits": "量子回路",
    "subscription.compare.simulation": "ローカルシミュレーション",
    "subscription.compare.academy_basic": "アカデミー (基本)",
    "subscription.compare.academy_full": "アカデミー (全部)",
    "subscription.compare.qpu_access": "実機QPUアクセス",
    "subscription.compare.industry": "産業ソリューション",
    "subscription.compare.support": "メールサポート",
    "subscription.compare.priority": "優先サポート",
    "subscription.pro.subtitle": "学習と実験に最適",
    "subscription.premium.subtitle": "完全な量子コンピューティング体験",

    // More Hub - Subscription Info
    "more.subscription_info": "サブスクリプション情報",
    "more.subscription_info.subtitle": "Pro & Premium機能を見る",

    // Subscription Info Page
    "subscription.info.title": "プレミアムを解除",
    "subscription.info.subtitle": "ProまたはPremiumでSwiftQuantumを最大限に活用",
    "subscription.info.choose_tier": "プランを選択",
    "subscription.info.best_value": "おすすめ",
    "subscription.info.pro.feature1": "実機QPUアクセス",
    "subscription.info.pro.feature2": "全回路テンプレート",
    "subscription.info.pro.feature3": "優先サポート",
    "subscription.info.premium.feature1": "Proの全機能",
    "subscription.info.premium.feature2": "エラー訂正",
    "subscription.info.premium.feature3": "産業ソリューション",
    "subscription.info.all_features": "全プレミアム機能",
    "subscription.info.feature.qpu": "実機QPUアクセス",
    "subscription.info.feature.qpu.desc": "127キュービット以上のIBM量子コンピューターで回路を実行",
    "subscription.info.feature.academy": "量子アカデミー",
    "subscription.info.feature.academy.desc": "MIT/Harvardスタイルの全コースとレッスンにアクセス",
    "subscription.info.feature.industry": "産業ソリューション",
    "subscription.info.feature.industry.desc": "ビジネス向けエンタープライズ量子最適化",
    "subscription.info.feature.error": "エラー訂正",
    "subscription.info.feature.error.desc": "表面コードシミュレーションとフォールトトレラント計算",
    "subscription.info.feature.support": "優先サポート",
    "subscription.info.feature.support.desc": "量子専門家からより迅速な回答を取得",
    "subscription.info.subscribe_now": "今すぐ登録",
    "subscription.info.cancel_anytime": "いつでもキャンセル可能。契約なし。"
]

// MARK: - Dynamic Localized Strings (Chinese)
private let chineseDynamicStrings: [String: String] = [
    "bridge.why_use": "为什么使用桥接?",
    "bridge.connect_real": "连接到真正的量子计算机",
    "bridge.learn_more": "了解更多",
    "bridge.benefit.hardware.title": "真实硬件",
    "bridge.benefit.hardware.desc": "访问127+量子比特的IBM量子计算机",
    "bridge.benefit.quantum.title": "量子优势",
    "bridge.benefit.quantum.desc": "运行经典计算机无法完成的算法",
    "bridge.benefit.results.title": "真实结果",
    "bridge.benefit.results.desc": "获取实际的量子测量数据",
    "bridge.status.active": "已连接",
    "bridge.status.disconnected": "已断开",
    "bridge.connect": "连接",
    "bridge.disconnect": "断开",
    "executor.local": "本地设备",
    "bridge.select_backend": "选择后端",
    "bridge.select_backend.desc": "为您的电路选择量子处理器",
    "bridge.best_for": "最适合",
    "bridge.advantages": "优势",
    "bridge.limitations": "限制",
    "bridge.backend.simulator.title": "本地模拟器",
    "bridge.backend.simulator.best": "测试与开发",
    "bridge.backend.simulator.adv1": "即时结果",
    "bridge.backend.simulator.adv2": "无需等待",
    "bridge.backend.simulator.adv3": "完美精度",
    "bridge.backend.simulator.lim1": "有限量子比特 (20)",
    "bridge.backend.simulator.lim2": "无真实量子效应",
    "bridge.backend.brisbane.title": "IBM 布里斯班",
    "bridge.backend.brisbane.best": "生产工作负载",
    "bridge.backend.brisbane.adv1": "高相干时间",
    "bridge.backend.brisbane.adv2": "稳定性能",
    "bridge.backend.osaka.title": "IBM 大阪",
    "bridge.backend.osaka.best": "快速实验",
    "bridge.backend.osaka.adv1": "快速门速度",
    "bridge.backend.osaka.adv2": "低延迟",
    "bridge.backend.osaka.lim1": "较高错误率",
    "bridge.backend.kyoto.title": "IBM 京都",
    "bridge.backend.kyoto.best": "研究应用",
    "bridge.backend.kyoto.adv1": "研究级",
    "bridge.backend.kyoto.adv2": "高级校准",
    "bridge.backend.kyoto.lim1": "频繁维护",
    "bridge.backend.kyoto.lim2": "可用性有限",
    "bridge.backend.qubits127": "127 量子比特",
    "bridge.backend.queue_wait": "队列等待时间",
    "bridge.backend.limited_daily": "每日运行有限",
    "bridge.queue.title": "队列状态",
    "bridge.queue.pending": "待处理",
    "bridge.queue.running": "运行中",
    "bridge.queue.est_wait": "预计等待",
    "bridge.deploy.title": "部署电路",
    "bridge.deploy.hold": "长按部署",
    "bridge.deploy.deploying": "部署中...",
    "bridge.deploy.hold_text": "长按2秒部署您的电路",
    "bridge.jobs.title": "活动任务",
    "bridge.actions.title": "快速操作",
    "bridge.actions.subtitle": "一键量子操作",
    "bridge.action.bell": "贝尔态",
    "bridge.action.bell.sub": "量子纠缠",
    "bridge.action.ghz": "GHZ态",
    "bridge.action.ghz.sub": "多量子比特纠缠",
    "bridge.action.export": "导出QASM",
    "bridge.action.export.sub": "获取电路代码",
    "bridge.action.continuous": "连续模式",
    "bridge.action.continuous.sub": "自动重复任务",
    "bridge.action.stop_continuous": "停止",
    "bridge.action.running": "运行中...",
    "bridge.continuous.active": "连续模式已启用",
    "bridge.continuous.desc": "每30秒自动运行电路",
    "bridge.continuous.runs": "次运行",
    "bridge.ecc.title": "纠错",
    "bridge.ecc.status": "状态",
    "bridge.ecc.correcting": "正在纠错...",
    "bridge.ecc.fidelity": "保真度",
    "bridge.qasm.title": "QASM代码",
    "bridge.qasm.copy": "复制到剪贴板",
    "bridge.qasm.copied": "已复制!",
    "bridge.qasm.share": "分享",
    "bridge.qasm.what": "什么是QASM?",
    "bridge.qasm.desc": "OpenQASM是描述量子电路的标准语言。您可以在IBM Quantum Lab或其他平台上使用此代码。",
    "bridge.apikey.title": "IBM Quantum API密钥",
    "bridge.apikey.desc": "输入您的IBM Quantum API密钥以连接到真正的量子计算机",
    "bridge.apikey.placeholder": "输入API密钥",
    "bridge.premium.title": "解锁桥接",
    "bridge.premium.desc": "使用SwiftQuantum Pro访问IBM量子计算机",
    "bridge.premium.feat1": "127+量子比特量子计算机",
    "bridge.premium.feat2": "真实量子硬件访问",
    "bridge.premium.feat3": "优先队列",
    "bridge.premium.feat4": "纠错支持",
    "bridge.premium.feat5": "无限每日运行",
    "bridge.premium.upgrade": "升级到Pro",
    "bridge.premium.trial": "7天免费试用 • 随时取消",
    "circuits.difficulty.beginner": "入门",
    "circuits.difficulty.intermediate": "中级",
    "circuits.difficulty.advanced": "高级",
    "circuits.premium.title": "高级电路",
    "circuits.premium.desc": "此电路需要Pro订阅。",
    "circuits.premium.unlock": "使用Pro解锁",
    "circuits.premium.features.title": "Pro功能",
    "circuits.premium.features.1": "所有高级电路",
    "circuits.premium.features.2": "真实量子硬件",
    "circuits.premium.features.3": "优先支持",
    "industry.use.finance": "金融建模",
    "industry.use.pharma": "药物研发",
    "industry.use.logistics": "供应链",
    "industry.use.security": "密码学",
    "industry.legend.company": "公司",
    "industry.legend.tech": "技术",
    "industry.legend.market": "市场",
    "industry.badge.leader": "领导者",
    "industry.badge.emerging": "新兴",
    "more.academy": "学院",
    "more.academy.desc": "学习量子计算",
    "more.academy.subtitle": "学习量子计算",
    "more.industry.subtitle": "企业解决方案",
    "more.profile.subtitle": "您的量子之旅",
    "more.settings": "设置",
    "more.settings.desc": "自定义体验",
    "more.about": "关于",
    "more.about.desc": "应用信息和版本",
    "more.help": "帮助与支持",
    "more.help.desc": "获取帮助",
    "more.language": "语言",
    "more.language.desc": "更改应用语言",
    "more.notifications": "通知",
    "more.notifications.desc": "管理提醒",
    "more.privacy": "隐私",
    "more.privacy.desc": "阅读我们的政策",
    "more.terms": "服务条款",
    "more.terms.desc": "法律信息",
    "more.rate": "评价应用",
    "more.rate.desc": "留下评论",
    "more.share": "分享应用",
    "more.share.desc": "告诉你的朋友",
    "more.feedback": "发送反馈",
    "more.feedback.desc": "我们很想听到您的意见",
    "more.premium.status": "高级状态",
    "more.premium.active": "已激活",
    "more.premium.upgrade": "升级到Pro",
    "more.done": "完成",
    "more.login": "登录",
    "more.premium": "高级版",
    "more.admin": "管理员",
    "more.coming_soon": "即将推出",
    "more.coming_soon_message": "此功能将在未来更新中推出。",
    "more.ok": "确定",
    "more.reset_tutorial": "重置教程",
    "more.reset": "重置",
    "more.cancel": "取消",
    "more.reset_message": "重启应用后将再次显示入门教程。",
    "more.appearance": "外观",

    // Industry Tab Additional
    "industry.title": "行业解决方案",
    "industry.subtitle": "量子驱动的业务优化",
    "industry.stat.efficiency": "效率",
    "industry.stat.roi": "投资回报率",
    "industry.stat.clients": "客户",
    "industry.efficiency": "效率",
    "industry.premium.title": "企业解决方案高级版",
    "industry.premium.desc": "解锁所有行业解决方案和量子业务优化",
    "industry.premium.upgrade": "升级 - ¥68/月",
    "industry.premium.trial": "包含7天免费试用",
    "industry.get_started": "开始使用",
    "industry.pricing_soon": "价格详情即将公布",
    "industry.roi.title": "投资回报率计算器",
    "industry.roi.estimate": "估算您的量子优势",
    "industry.roi.subtitle": "计算潜在回报",
    "industry.roi.calculate": "计算ROI",
    "industry.roi.progress": "基于8级进度",
    "industry.roi.team_size": "团队规模",
    "industry.roi.budget": "年度IT预算",
    "industry.roi.calculate_btn": "计算ROI",
    "industry.roi.estimated_savings": "预计年度节省",
    "industry.roi.payback": "回收期",
    "industry.roi.projected": "预计年度收益",
    "industry.roi.calculate_data": "用您的数据计算",
    "industry.upgrade_enterprise": "升级到企业版",
    "industry.get_premium": "获取高级版",
    "industry.trial": "开始7天免费试用",
    "industry.efficiency_gain": "效率提升",
    "industry.implementation": "实施周期",
    "industry.impl_weeks": "2-4周",
    "industry.team_size": "团队规模",
    "industry.any_size": "任意规模",
    "industry.use_cases": "主要用例",
    "industry.learn_more": "了解更多",
    "industry.legend.without": "无量子",
    "industry.legend.with": "量子高级版",
    "industry.choose_plan": "选择方案",
    "industry.badge.best": "最佳价值",
    "industry.badge.popular": "热门",
    "industry.compare.feature": "功能",
    "industry.compare.pro": "专业版",
    "industry.compare.enterprise": "企业版",
    "industry.success_stories": "成功案例",
    "industry.quantum_solutions": "量子解决方案",
    "industry.overview": "概述",
    "industry.key_benefits": "主要优势",
    "industry.learn.ibm": "IBM量子学习",
    "industry.learn.mit": "MIT xPRO量子课程",
    "industry.learn.roadmap": "IBM量子2026路线图",

    // Industry Use Cases
    "industry.use.finance.1": "投资组合优化",
    "industry.use.finance.2": "风险评估",
    "industry.use.finance.3": "欺诈检测",
    "industry.use.finance.4": "高频交易",
    "industry.use.health.1": "药物分子模拟",
    "industry.use.health.2": "蛋白质折叠",
    "industry.use.health.3": "治疗优化",
    "industry.use.health.4": "医学影像",
    "industry.use.logistics.1": "路线优化",
    "industry.use.logistics.2": "仓库布局",
    "industry.use.logistics.3": "供应链",
    "industry.use.logistics.4": "配送调度",
    "industry.use.energy.1": "电网优化",
    "industry.use.energy.2": "需求预测",
    "industry.use.energy.3": "可再生能源整合",
    "industry.use.energy.4": "负载均衡",
    "industry.use.mfg.1": "质量控制",
    "industry.use.mfg.2": "预测性维护",
    "industry.use.mfg.3": "流程优化",
    "industry.use.mfg.4": "库存管理",
    "industry.use.ai.1": "量子神经网络",
    "industry.use.ai.2": "特征选择",
    "industry.use.ai.3": "优化问题",
    "industry.use.ai.4": "生成模型",
    "industry.use.default.1": "优化",
    "industry.use.default.2": "模拟",
    "industry.use.default.3": "分析",

    // Ecosystem Tab
    "ecosystem.title": "IBM Quantum Ecosystem",
    "ecosystem.subtitle": "从生态系统运行真实量子项目",
    "ecosystem.all": "全部",
    "ecosystem.about": "关于",
    "ecosystem.actions": "快速操作",
    "ecosystem.run_demo": "运行演示电路",
    "ecosystem.running": "运行中...",
    "ecosystem.export_code": "导出示例代码",
    "ecosystem.view_github": "在GitHub上查看",
    "ecosystem.result": "执行结果",
    "ecosystem.use_cases": "用例",
    "ecosystem.sample_code": "示例代码",
    "ecosystem.copy": "复制到剪贴板",

    // Ecosystem Categories
    "ecosystem.category.ml": "机器学习",
    "ecosystem.category.chem": "化学与物理",
    "ecosystem.category.opt": "优化",
    "ecosystem.category.hw": "硬件提供商",
    "ecosystem.category.sim": "模拟",
    "ecosystem.category.research": "研究",

    // Ecosystem Project Names (Keep English names for recognition)
    "ecosystem.project.torchquantum": "TorchQuantum",
    "ecosystem.project.qiskit_ml": "Qiskit ML",
    "ecosystem.project.qiskit_nature": "Qiskit Nature",
    "ecosystem.project.qiskit_finance": "Qiskit Finance",
    "ecosystem.project.qiskit_optimization": "Qiskit Optimization",
    "ecosystem.project.ibm_quantum": "IBM Quantum",
    "ecosystem.project.azure_quantum": "Azure Quantum",
    "ecosystem.project.aws_braket": "AWS Braket",
    "ecosystem.project.ionq": "IonQ",
    "ecosystem.project.qiskit_aer": "Qiskit Aer",
    "ecosystem.project.mqt_ddsim": "MQT DDSIM",
    "ecosystem.project.pennylane": "PennyLane",
    "ecosystem.project.cirq": "Cirq (Google)",

    // Ecosystem Project Descriptions
    "ecosystem.project.torchquantum.desc": "支持GPU的基于PyTorch的量子ML框架。无缝构建和训练量子神经网络。",
    "ecosystem.project.qiskit_ml.desc": "包含变分算法、量子核和神经网络的量子机器学习模块。",
    "ecosystem.project.qiskit_nature.desc": "模拟分子结构和化学反应。用于药物发现的量子化学。",
    "ecosystem.project.qiskit_finance.desc": "使用量子算法进行投资组合优化、期权定价和风险分析。",
    "ecosystem.project.qiskit_optimization.desc": "使用QAOA、VQE和Grover算法解决组合优化问题。",
    "ecosystem.project.ibm_quantum.desc": "访问127+量子比特Eagle处理器。可使用Brisbane、Osaka、Kyoto系统。",
    "ecosystem.project.azure_quantum.desc": "微软的量子云，提供IonQ、Quantinuum和Rigetti后端。",
    "ecosystem.project.aws_braket.desc": "亚马逊的量子服务，提供IonQ、Rigetti和OQC量子硬件。",
    "ecosystem.project.ionq.desc": "具有高门保真度和全对全连接性的离子阱量子计算机。",
    "ecosystem.project.qiskit_aer.desc": "支持噪声建模和GPU加速的高性能量子电路模拟器。",
    "ecosystem.project.mqt_ddsim.desc": "用于高效大规模模拟的基于决策图的量子模拟器。",
    "ecosystem.project.pennylane.desc": "支持多种硬件后端的跨平台量子ML库。",
    "ecosystem.project.cirq.desc": "谷歌的NISQ算法和实验量子框架。",

    // Industry Hero Benefits
    "industry.hero.benefit1": "几分钟而非几天内解决复杂优化问题",
    "industry.hero.benefit2": "运行经典计算机无法完成的模拟",
    "industry.hero.benefit3": "利用量子优势加速决策",

    // Industry Detail Sheet
    "industry.detail.efficiency": "效率",
    "industry.detail.weeks": "周",
    "industry.detail.uptime": "运行时间",
    "industry.overview.finance": "量子计算通过高级投资组合优化、实时风险分析和精密欺诈检测功能改变金融服务。",
    "industry.overview.healthcare": "医疗保健受益于药物发现的分子模拟、蛋白质折叠预测和个性化治疗优化。",
    "industry.overview.logistics": "供应链管理通过路线优化、库存管理和需求预测的量子算法实现革新。",
    "industry.overview.energy": "能源行业利用量子计算进行智能电网优化、可再生能源整合和负载均衡挑战。",
    "industry.overview.manufacturing": "制造业受益于量子增强的质量控制、预测性维护和流程优化。",
    "industry.overview.ai": "AI/ML应用通过量子神经网络、特征选择和复杂优化问题得到加速。",
    "industry.overview.default": "该行业通过优化、模拟和高级数据分析功能受益于量子计算。",
    "industry.benefit.finance.1": "使用量子算法进行投资组合优化",
    "industry.benefit.finance.2": "实时风险评估和定价",
    "industry.benefit.finance.3": "增强的欺诈检测模式",
    "industry.benefit.finance.4": "高频交易优化",
    "industry.benefit.healthcare.1": "药物分子模拟和发现",
    "industry.benefit.healthcare.2": "蛋白质折叠预测",
    "industry.benefit.healthcare.3": "个性化治疗优化",
    "industry.benefit.healthcare.4": "医学影像增强",
    "industry.benefit.logistics.1": "全球路线优化",
    "industry.benefit.logistics.2": "仓库布局优化",
    "industry.benefit.logistics.3": "供应链弹性",
    "industry.benefit.logistics.4": "动态配送调度",
    "industry.benefit.energy.1": "智能电网优化",
    "industry.benefit.energy.2": "需求预测准确性",
    "industry.benefit.energy.3": "可再生能源整合",
    "industry.benefit.energy.4": "负载均衡效率",
    "industry.benefit.manufacturing.1": "高级质量控制",
    "industry.benefit.manufacturing.2": "预测性维护",
    "industry.benefit.manufacturing.3": "流程优化",
    "industry.benefit.manufacturing.4": "库存管理",
    "industry.benefit.ai.1": "量子神经网络训练",
    "industry.benefit.ai.2": "特征选择优化",
    "industry.benefit.ai.3": "复杂问题解决",
    "industry.benefit.ai.4": "生成模型加速",
    "industry.benefit.default.1": "流程优化",
    "industry.benefit.default.2": "数据分析增强",
    "industry.benefit.default.3": "决策支持系统",
    "industry.benefit.default.4": "模拟功能",

    // Industry Premium Sheet
    "industry.premium.feat.finance": "实时金融建模与优化",
    "industry.premium.feat.health": "药物发现分子模拟",
    "industry.premium.feat.energy": "智能电网与能源优化",
    "industry.premium.feat.ai": "量子ML模型训练",
    "industry.premium.feat.roi": "ROI计算器与分析仪表板",

    // Ecosystem Use Cases
    "ecosystem.usecase.ml.1": "量子神经网络",
    "ecosystem.usecase.ml.2": "特征选择",
    "ecosystem.usecase.ml.3": "分类问题",
    "ecosystem.usecase.ml.4": "回归分析",
    "ecosystem.usecase.chem.1": "分子模拟",
    "ecosystem.usecase.chem.2": "能量计算",
    "ecosystem.usecase.chem.3": "反应预测",
    "ecosystem.usecase.chem.4": "药物发现",
    "ecosystem.usecase.opt.1": "组合优化",
    "ecosystem.usecase.opt.2": "投资组合管理",
    "ecosystem.usecase.opt.3": "路线规划",
    "ecosystem.usecase.opt.4": "资源分配",
    "ecosystem.usecase.hw.1": "电路校准",
    "ecosystem.usecase.hw.2": "错误缓解",
    "ecosystem.usecase.hw.3": "噪声特性分析",
    "ecosystem.usecase.hw.4": "性能基准测试",
    "ecosystem.usecase.sim.1": "物理模拟",
    "ecosystem.usecase.sim.2": "材料科学",
    "ecosystem.usecase.sim.3": "金融建模",
    "ecosystem.usecase.sim.4": "气候建模",
    "ecosystem.usecase.research.1": "算法开发",
    "ecosystem.usecase.research.2": "错误纠正",
    "ecosystem.usecase.research.3": "量子优势研究",
    "ecosystem.usecase.research.4": "理论分析",

    // Academy Marketing View
    "academy.done": "完成",
    "academy.hero.subtitle": "掌握量子计算",
    "academy.hero.reviews": "(2.4K评论)",
    "academy.features.title": "为什么使用QuantumNative学习?",
    "academy.features.interactive.title": "互动学习",
    "academy.features.interactive.desc": "实时可视化的实践量子电路",
    "academy.features.progress.title": "进度跟踪",
    "academy.features.progress.desc": "经验值、成就和学习连续记录",
    "academy.features.synced.title": "同步账户",
    "academy.features.synced.desc": "您的进度在SwiftQuantum应用间同步",
    "academy.features.passport.title": "职业护照",
    "academy.features.passport.desc": "获得可验证的量子计算资质",
    "academy.courses.title": "12+课程可用",
    "academy.courses.basics": "量子基础",
    "academy.courses.gates": "量子门",
    "academy.courses.entanglement": "量子纠缠",
    "academy.courses.algorithms": "算法",
    "academy.courses.free": "免费",
    "academy.courses.lessons": "课程",
    "academy.testimonial.quote": "QuantumNative让量子计算变得触手可及。我在短短2周内就能从零开始构建量子算法!",
    "academy.testimonial.initials": "王明",
    "academy.testimonial.name": "王明华",
    "academy.testimonial.role": "软件工程师",
    "academy.cta.download": "下载QuantumNative",
    "academy.cta.subtitle": "免费下载 · 提供高级课程",

    // Profile
    "profile.title": "个人资料",

    // Circuits Hero Benefits
    "circuits.hero.benefit1": "拖放方式可视化构建量子电路",
    "circuits.hero.benefit2": "使用常见算法的预构建模板",
    "circuits.hero.benefit3": "运行模拟并即时查看结果",

    // Industry Card Titles & Benefits
    "industry.card.finance": "金融",
    "industry.card.finance.benefit": "投资组合优化与风险分析",
    "industry.card.healthcare": "医疗",
    "industry.card.healthcare.benefit": "药物发现加速",
    "industry.card.logistics": "物流",
    "industry.card.logistics.benefit": "路线优化与调度",
    "industry.card.energy": "能源",
    "industry.card.energy.benefit": "电网优化与预测",
    "industry.card.manufacturing": "制造",
    "industry.card.manufacturing.benefit": "供应链优化",
    "industry.card.ai": "AI & ML",
    "industry.card.ai.benefit": "量子机器学习",

    // Auth - Login/SignUp
    "auth.welcome_back": "欢迎回来",
    "auth.create_account": "创建账户",
    "auth.reset_password": "重置密码",
    "auth.email": "电子邮箱",
    "auth.username": "用户名",
    "auth.password": "密码",
    "auth.password_min": "密码（至少6个字符）",
    "auth.confirm_password": "确认密码",
    "auth.login": "登录",
    "auth.signup": "注册",
    "auth.forgot_password": "忘记密码？",
    "auth.no_account": "还没有账户？",
    "auth.have_account": "已有账户？",
    "auth.passwords_match": "密码一致",
    "auth.passwords_no_match": "密码不一致",
    "auth.send_reset": "发送重置链接",
    "auth.back_to_login": "返回登录",
    "auth.reset_instruction": "请输入您的电子邮箱地址，我们将向您发送密码重置链接。",

    // Subscription - Paywall
    "subscription.title": "解锁 SwiftQuantum",
    "subscription.subtitle": "获取量子计算的全部功能",
    "subscription.choose_plan": "选择您的计划",
    "subscription.close": "关闭",
    "subscription.pro": "Pro",
    "subscription.premium": "Premium",
    "subscription.monthly": "月付",
    "subscription.yearly": "年付",
    "subscription.per_month": "/月",
    "subscription.per_year": "/年",
    "subscription.save_percent": "节省33%",
    "subscription.recommended": "推荐",
    "subscription.subscribe": "订阅",
    "subscription.restore": "恢复购买",
    "subscription.legal": "订阅将自动续订，除非在当前期间结束前24小时取消。",
    "subscription.terms": "使用条款",
    "subscription.privacy": "隐私政策",
    "subscription.success_title": "欢迎加入 Premium！",
    "subscription.success_subtitle": "所有功能已解锁",
    "subscription.get_started": "开始使用",

    // Pro Features
    "subscription.pro.feature1": "全部12门学院课程",
    "subscription.pro.feature2": "40量子比特本地模拟",
    "subscription.pro.feature3": "高级示例",
    "subscription.pro.feature4": "邮件支持",
    "subscription.pro.desc_monthly": "扩展模拟和完整学院访问",
    "subscription.pro.desc_yearly": "学习量子计算的最佳价值",

    // Premium Features
    "subscription.premium.feature1": "包含Pro所有功能",
    "subscription.premium.feature2": "QuantumBridge QPU连接",
    "subscription.premium.feature3": "纠错模拟",
    "subscription.premium.feature4": "行业解决方案访问",
    "subscription.premium.feature5": "优先支持",
    "subscription.premium.desc_monthly": "完整访问真实量子硬件",
    "subscription.premium.desc_yearly": "以最优价格获得完整量子体验",

    // Subscription Tabs & Comparison
    "subscription.tab.compare": "比较",
    "subscription.tab.pro": "Pro",
    "subscription.tab.premium": "Premium",
    "subscription.features": "功能",
    "subscription.free": "免费",
    "subscription.select_plan": "选择计划",
    "subscription.compare.circuits": "量子电路",
    "subscription.compare.simulation": "本地模拟",
    "subscription.compare.academy_basic": "学院（基础）",
    "subscription.compare.academy_full": "学院（完整）",
    "subscription.compare.qpu_access": "真实QPU访问",
    "subscription.compare.industry": "行业解决方案",
    "subscription.compare.support": "邮件支持",
    "subscription.compare.priority": "优先支持",
    "subscription.pro.subtitle": "完美适合学习和实验",
    "subscription.premium.subtitle": "完整的量子计算体验",

    // More Hub - Subscription Info
    "more.subscription_info": "订阅信息",
    "more.subscription_info.subtitle": "了解Pro & Premium功能",

    // Subscription Info Page
    "subscription.info.title": "解锁高级版",
    "subscription.info.subtitle": "通过Pro或Premium充分利用SwiftQuantum",
    "subscription.info.choose_tier": "选择您的计划",
    "subscription.info.best_value": "推荐",
    "subscription.info.pro.feature1": "真实QPU访问",
    "subscription.info.pro.feature2": "所有电路模板",
    "subscription.info.pro.feature3": "优先支持",
    "subscription.info.premium.feature1": "Pro的所有功能",
    "subscription.info.premium.feature2": "错误纠正",
    "subscription.info.premium.feature3": "行业解决方案",
    "subscription.info.all_features": "所有高级功能",
    "subscription.info.feature.qpu": "真实QPU访问",
    "subscription.info.feature.qpu.desc": "在127+量子比特的IBM量子计算机上运行电路",
    "subscription.info.feature.academy": "量子学院",
    "subscription.info.feature.academy.desc": "访问所有MIT/Harvard风格的课程和教程",
    "subscription.info.feature.industry": "行业解决方案",
    "subscription.info.feature.industry.desc": "企业级量子优化解决方案",
    "subscription.info.feature.error": "错误纠正",
    "subscription.info.feature.error.desc": "表面码模拟和容错计算",
    "subscription.info.feature.support": "优先支持",
    "subscription.info.feature.support.desc": "从量子专家获得更快的回复",
    "subscription.info.subscribe_now": "立即订阅",
    "subscription.info.cancel_anytime": "随时取消。无需承诺。"
]

// MARK: - Dynamic Localized Strings (German)
private let germanDynamicStrings: [String: String] = [
    "bridge.why_use": "Warum Bridge verwenden?",
    "bridge.connect_real": "Mit echten Quantencomputern verbinden",
    "bridge.learn_more": "Mehr erfahren",
    "bridge.benefit.hardware.title": "Echte Hardware",
    "bridge.benefit.hardware.desc": "Zugriff auf IBM Quantencomputer mit 127+ Qubits",
    "bridge.benefit.quantum.title": "Quantenvorteil",
    "bridge.benefit.quantum.desc": "Algorithmen ausführen, die auf klassischen Computern unmöglich sind",
    "bridge.benefit.results.title": "Echte Ergebnisse",
    "bridge.benefit.results.desc": "Tatsächliche Quantenmessdaten erhalten",
    "bridge.status.active": "Verbunden",
    "bridge.status.disconnected": "Getrennt",
    "bridge.connect": "Verbinden",
    "bridge.disconnect": "Trennen",
    "executor.local": "Lokales Gerät",
    "bridge.select_backend": "Backend auswählen",
    "bridge.select_backend.desc": "Wählen Sie den Quantenprozessor für Ihren Schaltkreis",
    "bridge.best_for": "Am besten für",
    "bridge.advantages": "Vorteile",
    "bridge.limitations": "Einschränkungen",
    "bridge.backend.simulator.title": "Lokaler Simulator",
    "bridge.backend.simulator.best": "Tests & Entwicklung",
    "bridge.backend.simulator.adv1": "Sofortige Ergebnisse",
    "bridge.backend.simulator.adv2": "Keine Wartezeit",
    "bridge.backend.simulator.adv3": "Perfekte Genauigkeit",
    "bridge.backend.simulator.lim1": "Begrenzte Qubits (20)",
    "bridge.backend.simulator.lim2": "Keine echten Quanteneffekte",
    "bridge.backend.brisbane.title": "IBM Brisbane",
    "bridge.backend.brisbane.best": "Produktionsworkloads",
    "bridge.backend.brisbane.adv1": "Hohe Kohärenzzeit",
    "bridge.backend.brisbane.adv2": "Stabile Leistung",
    "bridge.backend.osaka.title": "IBM Osaka",
    "bridge.backend.osaka.best": "Schnelle Experimente",
    "bridge.backend.osaka.adv1": "Schnelle Gate-Geschwindigkeit",
    "bridge.backend.osaka.adv2": "Geringe Latenz",
    "bridge.backend.osaka.lim1": "Höhere Fehlerrate",
    "bridge.backend.kyoto.title": "IBM Kyoto",
    "bridge.backend.kyoto.best": "Forschungsanwendungen",
    "bridge.backend.kyoto.adv1": "Forschungsqualität",
    "bridge.backend.kyoto.adv2": "Erweiterte Kalibrierung",
    "bridge.backend.kyoto.lim1": "Häufige Wartung",
    "bridge.backend.kyoto.lim2": "Begrenzte Verfügbarkeit",
    "bridge.backend.qubits127": "127 Qubits",
    "bridge.backend.queue_wait": "Warteschlangenzeiten",
    "bridge.backend.limited_daily": "Begrenzte tägliche Läufe",
    "bridge.queue.title": "Warteschlangenstatus",
    "bridge.queue.pending": "Ausstehend",
    "bridge.queue.running": "Läuft",
    "bridge.queue.est_wait": "Geschätzte Wartezeit",
    "bridge.deploy.title": "Schaltkreis bereitstellen",
    "bridge.deploy.hold": "Halten zum Bereitstellen",
    "bridge.deploy.deploying": "Wird bereitgestellt...",
    "bridge.deploy.hold_text": "2 Sekunden halten, um Ihren Schaltkreis bereitzustellen",
    "bridge.jobs.title": "Aktive Jobs",
    "bridge.actions.title": "Schnellaktionen",
    "bridge.actions.subtitle": "Ein-Tipp-Quantenoperationen",
    "bridge.action.bell": "Bell-Zustand",
    "bridge.action.bell.sub": "Quantenverschränkung",
    "bridge.action.ghz": "GHZ-Zustand",
    "bridge.action.ghz.sub": "Multi-Qubit-Verschränkung",
    "bridge.action.export": "QASM exportieren",
    "bridge.action.export.sub": "Schaltkreiscode erhalten",
    "bridge.action.continuous": "Kontinuierlich",
    "bridge.action.continuous.sub": "Auto-Wiederholung",
    "bridge.action.stop_continuous": "Stoppen",
    "bridge.action.running": "Läuft...",
    "bridge.continuous.active": "Kontinuierlicher Modus aktiv",
    "bridge.continuous.desc": "Schaltkreise werden automatisch alle 30 Sekunden ausgeführt",
    "bridge.continuous.runs": "Läufe",
    "bridge.ecc.title": "Fehlerkorrektur",
    "bridge.ecc.status": "Status",
    "bridge.ecc.correcting": "Fehler werden korrigiert...",
    "bridge.ecc.fidelity": "Genauigkeit",
    "bridge.qasm.title": "QASM-Code",
    "bridge.qasm.copy": "In Zwischenablage kopieren",
    "bridge.qasm.copied": "Kopiert!",
    "bridge.qasm.share": "Teilen",
    "bridge.qasm.what": "Was ist QASM?",
    "bridge.qasm.desc": "OpenQASM ist eine Standardsprache zur Beschreibung von Quantenschaltkreisen. Sie können diesen Code in IBM Quantum Lab oder anderen Plattformen verwenden.",
    "bridge.apikey.title": "IBM Quantum API-Schlüssel",
    "bridge.apikey.desc": "Geben Sie Ihren IBM Quantum API-Schlüssel ein, um sich mit echten Quantencomputern zu verbinden",
    "bridge.apikey.placeholder": "API-Schlüssel eingeben",
    "bridge.premium.title": "Bridge freischalten",
    "bridge.premium.desc": "Greifen Sie mit SwiftQuantum Pro auf IBM Quantencomputer zu",
    "bridge.premium.feat1": "127+ Qubit Quantencomputer",
    "bridge.premium.feat2": "Echter Quantenhardware-Zugang",
    "bridge.premium.feat3": "Priorisierte Warteschlange",
    "bridge.premium.feat4": "Fehlerkorrektur-Unterstützung",
    "bridge.premium.feat5": "Unbegrenzte tägliche Läufe",
    "bridge.premium.upgrade": "Auf Pro upgraden",
    "bridge.premium.trial": "7-tägige kostenlose Testversion • Jederzeit kündbar",
    "circuits.difficulty.beginner": "Anfänger",
    "circuits.difficulty.intermediate": "Mittelstufe",
    "circuits.difficulty.advanced": "Fortgeschritten",
    "circuits.premium.title": "Premium-Schaltkreis",
    "circuits.premium.desc": "Dieser Schaltkreis erfordert ein Pro-Abonnement.",
    "circuits.premium.unlock": "Mit Pro freischalten",
    "circuits.premium.features.title": "Pro-Funktionen",
    "circuits.premium.features.1": "Alle fortgeschrittenen Schaltkreise",
    "circuits.premium.features.2": "Echte Quantenhardware",
    "circuits.premium.features.3": "Prioritäts-Support",
    "industry.use.finance": "Finanzmodellierung",
    "industry.use.pharma": "Arzneimittelentwicklung",
    "industry.use.logistics": "Lieferkette",
    "industry.use.security": "Kryptographie",
    "industry.legend.company": "Unternehmen",
    "industry.legend.tech": "Technologie",
    "industry.legend.market": "Markt",
    "industry.badge.leader": "Marktführer",
    "industry.badge.emerging": "Aufstrebend",
    "more.academy": "Akademie",
    "more.academy.desc": "Quantencomputing lernen",
    "more.academy.subtitle": "Quantencomputing lernen",
    "more.industry.subtitle": "Unternehmenslösungen",
    "more.profile.subtitle": "Ihre Quantenreise",
    "more.settings": "Einstellungen",
    "more.settings.desc": "Erfahrung anpassen",
    "more.about": "Über",
    "more.about.desc": "App-Infos & Version",
    "more.help": "Hilfe & Support",
    "more.help.desc": "Unterstützung erhalten",
    "more.language": "Sprache",
    "more.language.desc": "App-Sprache ändern",
    "more.notifications": "Benachrichtigungen",
    "more.notifications.desc": "Alarme verwalten",
    "more.privacy": "Datenschutz",
    "more.privacy.desc": "Richtlinie lesen",
    "more.terms": "Nutzungsbedingungen",
    "more.terms.desc": "Rechtliche Informationen",
    "more.rate": "App bewerten",
    "more.rate.desc": "Bewertung hinterlassen",
    "more.share": "App teilen",
    "more.share.desc": "Freunden erzählen",
    "more.feedback": "Feedback senden",
    "more.feedback.desc": "Wir freuen uns auf Ihre Meinung",
    "more.premium.status": "Premium-Status",
    "more.premium.active": "Aktiv",
    "more.premium.upgrade": "Auf Pro upgraden",
    "more.done": "Fertig",
    "more.login": "Anmelden",
    "more.premium": "Premium",
    "more.admin": "Admin",
    "more.coming_soon": "Demnächst",
    "more.coming_soon_message": "Diese Funktion wird in einem zukünftigen Update verfügbar sein.",
    "more.ok": "OK",
    "more.reset_tutorial": "Tutorial zurücksetzen",
    "more.reset": "Zurücksetzen",
    "more.cancel": "Abbrechen",
    "more.reset_message": "Das Onboarding-Tutorial wird beim Neustart der App erneut angezeigt.",
    "more.appearance": "Erscheinung",

    // Industry Tab Additional
    "industry.title": "Branchenlösungen",
    "industry.subtitle": "Quantengestützte Geschäftsoptimierung",
    "industry.stat.efficiency": "Effizienz",
    "industry.stat.roi": "ROI",
    "industry.stat.clients": "Kunden",
    "industry.efficiency": "Effizienz",
    "industry.premium.title": "Enterprise Solutions Premium",
    "industry.premium.desc": "Schalten Sie alle Branchenlösungen und quantengestützte Geschäftsoptimierung frei",
    "industry.premium.upgrade": "Upgraden - 9,99€/Monat",
    "industry.premium.trial": "7-tägige kostenlose Testversion inklusive",
    "industry.get_started": "Loslegen",
    "industry.pricing_soon": "Preisdetails demnächst",
    "industry.roi.title": "ROI-Rechner",
    "industry.roi.estimate": "Schätzen Sie Ihren Quantenvorteil",
    "industry.roi.subtitle": "Potenzielle Rendite berechnen",
    "industry.roi.calculate": "ROI berechnen",
    "industry.roi.progress": "Basierend auf Level-8-Fortschritt",
    "industry.roi.team_size": "Teamgröße",
    "industry.roi.budget": "Jährliches IT-Budget",
    "industry.roi.calculate_btn": "ROI berechnen",
    "industry.roi.estimated_savings": "Geschätzte jährliche Einsparungen",
    "industry.roi.payback": "Amortisationszeit",
    "industry.roi.projected": "Prognostizierter Jahresnutzen",
    "industry.roi.calculate_data": "Mit Ihren Daten berechnen",
    "industry.upgrade_enterprise": "Auf Enterprise upgraden",
    "industry.get_premium": "Premium holen",
    "industry.trial": "7-tägige kostenlose Testversion starten",
    "industry.efficiency_gain": "Effizienzsteigerung",
    "industry.implementation": "Implementierung",
    "industry.impl_weeks": "2-4 Wochen",
    "industry.team_size": "Teamgröße",
    "industry.any_size": "Jede Größe",
    "industry.use_cases": "Hauptanwendungsfälle",
    "industry.learn_more": "Mehr erfahren",
    "industry.legend.without": "Ohne Quantum",
    "industry.legend.with": "Mit Quantum Premium",
    "industry.choose_plan": "Plan wählen",
    "industry.badge.best": "Bester Wert",
    "industry.badge.popular": "Beliebt",
    "industry.compare.feature": "Funktion",
    "industry.compare.pro": "Pro",
    "industry.compare.enterprise": "Enterprise",
    "industry.success_stories": "Erfolgsgeschichten",
    "industry.quantum_solutions": "Quantenlösungen",
    "industry.overview": "Übersicht",
    "industry.key_benefits": "Hauptvorteile",
    "industry.learn.ibm": "IBM Quantum Lernen",
    "industry.learn.mit": "MIT xPRO Quantenkurs",
    "industry.learn.roadmap": "IBM Quantum 2026 Roadmap",

    // Industry Use Cases
    "industry.use.finance.1": "Portfolio-Optimierung",
    "industry.use.finance.2": "Risikobewertung",
    "industry.use.finance.3": "Betrugserkennung",
    "industry.use.finance.4": "Hochfrequenzhandel",
    "industry.use.health.1": "Arzneimittelmolekülsimulation",
    "industry.use.health.2": "Proteinfaltung",
    "industry.use.health.3": "Behandlungsoptimierung",
    "industry.use.health.4": "Medizinische Bildgebung",
    "industry.use.logistics.1": "Routenoptimierung",
    "industry.use.logistics.2": "Lagerlayout",
    "industry.use.logistics.3": "Lieferkette",
    "industry.use.logistics.4": "Lieferplanung",
    "industry.use.energy.1": "Netzoptimierung",
    "industry.use.energy.2": "Nachfrageprognose",
    "industry.use.energy.3": "Integration erneuerbarer Energien",
    "industry.use.energy.4": "Lastausgleich",
    "industry.use.mfg.1": "Qualitätskontrolle",
    "industry.use.mfg.2": "Vorausschauende Wartung",
    "industry.use.mfg.3": "Prozessoptimierung",
    "industry.use.mfg.4": "Bestandsverwaltung",
    "industry.use.ai.1": "Quanten-Neuronale Netze",
    "industry.use.ai.2": "Merkmalsauswahl",
    "industry.use.ai.3": "Optimierungsprobleme",
    "industry.use.ai.4": "Generative Modelle",
    "industry.use.default.1": "Optimierung",
    "industry.use.default.2": "Simulation",
    "industry.use.default.3": "Analyse",

    // Ecosystem Tab
    "ecosystem.title": "IBM Quantum Ecosystem",
    "ecosystem.subtitle": "Echte Quantenprojekte aus dem Ökosystem ausführen",
    "ecosystem.all": "Alle",
    "ecosystem.about": "Über",
    "ecosystem.actions": "Schnellaktionen",
    "ecosystem.run_demo": "Demo-Schaltkreis ausführen",
    "ecosystem.running": "Wird ausgeführt...",
    "ecosystem.export_code": "Beispielcode exportieren",
    "ecosystem.view_github": "Auf GitHub ansehen",
    "ecosystem.result": "Ausführungsergebnis",
    "ecosystem.use_cases": "Anwendungsfälle",
    "ecosystem.sample_code": "Beispielcode",
    "ecosystem.copy": "In Zwischenablage kopieren",

    // Ecosystem Categories
    "ecosystem.category.ml": "Maschinelles Lernen",
    "ecosystem.category.chem": "Chemie & Physik",
    "ecosystem.category.opt": "Optimierung",
    "ecosystem.category.hw": "Hardware-Anbieter",
    "ecosystem.category.sim": "Simulation",
    "ecosystem.category.research": "Forschung",

    // Ecosystem Project Names (Keep English names for recognition)
    "ecosystem.project.torchquantum": "TorchQuantum",
    "ecosystem.project.qiskit_ml": "Qiskit ML",
    "ecosystem.project.qiskit_nature": "Qiskit Nature",
    "ecosystem.project.qiskit_finance": "Qiskit Finance",
    "ecosystem.project.qiskit_optimization": "Qiskit Optimization",
    "ecosystem.project.ibm_quantum": "IBM Quantum",
    "ecosystem.project.azure_quantum": "Azure Quantum",
    "ecosystem.project.aws_braket": "AWS Braket",
    "ecosystem.project.ionq": "IonQ",
    "ecosystem.project.qiskit_aer": "Qiskit Aer",
    "ecosystem.project.mqt_ddsim": "MQT DDSIM",
    "ecosystem.project.pennylane": "PennyLane",
    "ecosystem.project.cirq": "Cirq (Google)",

    // Ecosystem Project Descriptions
    "ecosystem.project.torchquantum.desc": "PyTorch-basiertes Quanten-ML-Framework mit GPU-Unterstützung. Quanten-Neuronale-Netze nahtlos erstellen und trainieren.",
    "ecosystem.project.qiskit_ml.desc": "Quanten-Machine-Learning-Modul mit variationalen Algorithmen, Quantenkernen und neuronalen Netzen.",
    "ecosystem.project.qiskit_nature.desc": "Molekülstrukturen und chemische Reaktionen simulieren. Quantenchemie für die Medikamentenentdeckung.",
    "ecosystem.project.qiskit_finance.desc": "Portfoliooptimierung, Optionspreisgestaltung und Risikoanalyse mit Quantenalgorithmen.",
    "ecosystem.project.qiskit_optimization.desc": "Kombinatorische Optimierungsprobleme mit QAOA, VQE und Grovers Algorithmus lösen.",
    "ecosystem.project.ibm_quantum.desc": "Zugang zu 127+ Qubit Eagle-Prozessoren. Brisbane, Osaka, Kyoto Systeme verfügbar.",
    "ecosystem.project.azure_quantum.desc": "Microsofts Quanten-Cloud mit IonQ, Quantinuum und Rigetti Backends.",
    "ecosystem.project.aws_braket.desc": "Amazons Quantendienst mit IonQ, Rigetti und OQC Quantenhardware.",
    "ecosystem.project.ionq.desc": "Ionenfallen-Quantencomputer mit hoher Gate-Treue und All-to-All-Konnektivität.",
    "ecosystem.project.qiskit_aer.desc": "Hochleistungs-Quantenschaltkreissimulator mit Rauschmodellierung und GPU-Beschleunigung.",
    "ecosystem.project.mqt_ddsim.desc": "Entscheidungsdiagramm-basierter Quantensimulator für effiziente großmaßstäbliche Simulationen.",
    "ecosystem.project.pennylane.desc": "Plattformübergreifende Quanten-ML-Bibliothek mit Unterstützung mehrerer Hardware-Backends.",
    "ecosystem.project.cirq.desc": "Googles Quantenframework für NISQ-Algorithmen und Experimente.",

    // Industry Hero Benefits
    "industry.hero.benefit1": "Komplexe Optimierungsprobleme in Minuten statt Tagen lösen",
    "industry.hero.benefit2": "Simulationen ausführen, die auf klassischen Computern unmöglich sind",
    "industry.hero.benefit3": "Entscheidungsfindung mit Quantenvorteil beschleunigen",

    // Industry Detail Sheet
    "industry.detail.efficiency": "Effizienz",
    "industry.detail.weeks": "Wochen",
    "industry.detail.uptime": "Verfügbarkeit",
    "industry.overview.finance": "Quantencomputing transformiert Finanzdienstleistungen mit fortschrittlicher Portfoliooptimierung, Echtzeit-Risikoanalyse und ausgereifter Betrugserkennung.",
    "industry.overview.healthcare": "Das Gesundheitswesen profitiert von Molekülsimulation für Medikamentenentdeckung, Proteinfaltungsvorhersagen und personalisierter Behandlungsoptimierung.",
    "industry.overview.logistics": "Supply-Chain-Management wird durch Quantenalgorithmen für Routenoptimierung, Bestandsverwaltung und Nachfrageprognose revolutioniert.",
    "industry.overview.energy": "Der Energiesektor nutzt Quantencomputing für Smart-Grid-Optimierung, Integration erneuerbarer Energien und Lastausgleichsherausforderungen.",
    "industry.overview.manufacturing": "Fertigungsoperationen profitieren von quantenverstärkter Qualitätskontrolle, vorausschauender Wartung und Prozessoptimierung.",
    "industry.overview.ai": "AI/ML-Anwendungen werden durch Quanten-Neuronale Netze, Merkmalsauswahl und komplexe Optimierungsprobleme beschleunigt.",
    "industry.overview.default": "Diese Branche profitiert durch Optimierung, Simulation und fortgeschrittene Datenanalysefähigkeiten von Quantencomputing.",
    "industry.benefit.finance.1": "Portfoliooptimierung mit Quantenalgorithmen",
    "industry.benefit.finance.2": "Echtzeit-Risikobewertung und Preisgestaltung",
    "industry.benefit.finance.3": "Verbesserte Betrugserkennungsmuster",
    "industry.benefit.finance.4": "Hochfrequenzhandelsoptimierung",
    "industry.benefit.healthcare.1": "Arzneimittelmolekülsimulation und -entdeckung",
    "industry.benefit.healthcare.2": "Proteinfaltungsvorhersage",
    "industry.benefit.healthcare.3": "Personalisierte Behandlungsoptimierung",
    "industry.benefit.healthcare.4": "Medizinische Bildverbesserung",
    "industry.benefit.logistics.1": "Globale Routenoptimierung",
    "industry.benefit.logistics.2": "Lagerlayoutoptimierung",
    "industry.benefit.logistics.3": "Lieferkettenresilienz",
    "industry.benefit.logistics.4": "Dynamische Lieferplanung",
    "industry.benefit.energy.1": "Smart-Grid-Optimierung",
    "industry.benefit.energy.2": "Nachfrageprognosegenauigkeit",
    "industry.benefit.energy.3": "Integration erneuerbarer Energien",
    "industry.benefit.energy.4": "Lastausgleichseffizienz",
    "industry.benefit.manufacturing.1": "Fortgeschrittene Qualitätskontrolle",
    "industry.benefit.manufacturing.2": "Vorausschauende Wartung",
    "industry.benefit.manufacturing.3": "Prozessoptimierung",
    "industry.benefit.manufacturing.4": "Bestandsverwaltung",
    "industry.benefit.ai.1": "Quanten-Neuronales-Netz-Training",
    "industry.benefit.ai.2": "Merkmalsauswahloptimierung",
    "industry.benefit.ai.3": "Komplexe Problemlösung",
    "industry.benefit.ai.4": "Generative Modellbeschleunigung",
    "industry.benefit.default.1": "Prozessoptimierung",
    "industry.benefit.default.2": "Datenanalysenverbesserung",
    "industry.benefit.default.3": "Entscheidungsunterstützungssysteme",
    "industry.benefit.default.4": "Simulationsfähigkeiten",

    // Industry Premium Sheet
    "industry.premium.feat.finance": "Echtzeit-Finanzmodellierung und -optimierung",
    "industry.premium.feat.health": "Molekülsimulation für Medikamentenentdeckung",
    "industry.premium.feat.energy": "Smart-Grid und Energieoptimierung",
    "industry.premium.feat.ai": "Quanten-ML-Modelltraining",
    "industry.premium.feat.roi": "ROI-Rechner und Analyse-Dashboard",

    // Ecosystem Use Cases
    "ecosystem.usecase.ml.1": "Quanten-Neuronale Netze",
    "ecosystem.usecase.ml.2": "Merkmalsauswahl",
    "ecosystem.usecase.ml.3": "Klassifikationsprobleme",
    "ecosystem.usecase.ml.4": "Regressionsanalyse",
    "ecosystem.usecase.chem.1": "Molekülsimulation",
    "ecosystem.usecase.chem.2": "Energieberechnung",
    "ecosystem.usecase.chem.3": "Reaktionsvorhersage",
    "ecosystem.usecase.chem.4": "Medikamentenentdeckung",
    "ecosystem.usecase.opt.1": "Kombinatorische Optimierung",
    "ecosystem.usecase.opt.2": "Portfoliomanagement",
    "ecosystem.usecase.opt.3": "Routenplanung",
    "ecosystem.usecase.opt.4": "Ressourcenzuweisung",
    "ecosystem.usecase.hw.1": "Schaltkreiskalibrierung",
    "ecosystem.usecase.hw.2": "Fehlerminderung",
    "ecosystem.usecase.hw.3": "Rauschcharakterisierung",
    "ecosystem.usecase.hw.4": "Leistungs-Benchmarking",
    "ecosystem.usecase.sim.1": "Physiksimulation",
    "ecosystem.usecase.sim.2": "Materialwissenschaft",
    "ecosystem.usecase.sim.3": "Finanzmodellierung",
    "ecosystem.usecase.sim.4": "Klimamodellierung",
    "ecosystem.usecase.research.1": "Algorithmusentwicklung",
    "ecosystem.usecase.research.2": "Fehlerkorrektur",
    "ecosystem.usecase.research.3": "Quantenvorteilstudien",
    "ecosystem.usecase.research.4": "Theoretische Analyse",

    // Academy Marketing View
    "academy.done": "Fertig",
    "academy.hero.subtitle": "Quantencomputing meistern",
    "academy.hero.reviews": "(2,4K Bewertungen)",
    "academy.features.title": "Warum mit QuantumNative lernen?",
    "academy.features.interactive.title": "Interaktives Lernen",
    "academy.features.interactive.desc": "Praktische Quantenschaltkreise mit Echtzeit-Visualisierung",
    "academy.features.progress.title": "Fortschrittsverfolgung",
    "academy.features.progress.desc": "XP-Punkte, Erfolge und Lernsträhnen",
    "academy.features.synced.title": "Synchronisiertes Konto",
    "academy.features.synced.desc": "Ihr Fortschritt synchronisiert sich über SwiftQuantum-Apps",
    "academy.features.passport.title": "Karrierepass",
    "academy.features.passport.desc": "Verifizierbare Quantencomputing-Qualifikationen erwerben",
    "academy.courses.title": "12+ Kurse verfügbar",
    "academy.courses.basics": "Quantengrundlagen",
    "academy.courses.gates": "Quantengatter",
    "academy.courses.entanglement": "Verschränkung",
    "academy.courses.algorithms": "Algorithmen",
    "academy.courses.free": "KOSTENLOS",
    "academy.courses.lessons": "Lektionen",
    "academy.testimonial.quote": "QuantumNative hat Quantencomputing zugänglich gemacht. Ich bin in nur 2 Wochen von null zum Erstellen von Quantenalgorithmen gekommen!",
    "academy.testimonial.initials": "JK",
    "academy.testimonial.name": "Jonas K.",
    "academy.testimonial.role": "Softwareentwickler",
    "academy.cta.download": "QuantumNative herunterladen",
    "academy.cta.subtitle": "Kostenloser Download · Premium-Kurse verfügbar",

    // Profile
    "profile.title": "Profil",

    // Circuits Hero Benefits
    "circuits.hero.benefit1": "Quantenschaltkreise visuell per Drag & Drop erstellen",
    "circuits.hero.benefit2": "Vorgefertigte Vorlagen für gängige Algorithmen verwenden",
    "circuits.hero.benefit3": "Simulationen ausführen und Ergebnisse sofort sehen",

    // Industry Card Titles & Benefits
    "industry.card.finance": "Finanzen",
    "industry.card.finance.benefit": "Portfoliooptimierung & Risikoanalyse",
    "industry.card.healthcare": "Gesundheit",
    "industry.card.healthcare.benefit": "Arzneimittelentdeckung beschleunigen",
    "industry.card.logistics": "Logistik",
    "industry.card.logistics.benefit": "Routenoptimierung & Terminplanung",
    "industry.card.energy": "Energie",
    "industry.card.energy.benefit": "Netzoptimierung & Prognose",
    "industry.card.manufacturing": "Fertigung",
    "industry.card.manufacturing.benefit": "Lieferkettenoptimierung",
    "industry.card.ai": "AI & ML",
    "industry.card.ai.benefit": "Quanten-Maschinelles Lernen",

    // Auth - Login/SignUp
    "auth.welcome_back": "Willkommen zurück",
    "auth.create_account": "Konto erstellen",
    "auth.reset_password": "Passwort zurücksetzen",
    "auth.email": "E-Mail",
    "auth.username": "Benutzername",
    "auth.password": "Passwort",
    "auth.password_min": "Passwort (mind. 6 Zeichen)",
    "auth.confirm_password": "Passwort bestätigen",
    "auth.login": "Anmelden",
    "auth.signup": "Registrieren",
    "auth.forgot_password": "Passwort vergessen?",
    "auth.no_account": "Noch kein Konto?",
    "auth.have_account": "Bereits ein Konto?",
    "auth.passwords_match": "Passwörter stimmen überein",
    "auth.passwords_no_match": "Passwörter stimmen nicht überein",
    "auth.send_reset": "Reset-Link senden",
    "auth.back_to_login": "Zurück zur Anmeldung",
    "auth.reset_instruction": "Geben Sie Ihre E-Mail-Adresse ein und wir senden Ihnen einen Link zum Zurücksetzen Ihres Passworts.",

    // Subscription - Paywall
    "subscription.title": "SwiftQuantum freischalten",
    "subscription.subtitle": "Voller Zugang zur Quantencomputing-Leistung",
    "subscription.choose_plan": "Wählen Sie Ihren Plan",
    "subscription.close": "Schließen",
    "subscription.pro": "Pro",
    "subscription.premium": "Premium",
    "subscription.monthly": "Monatlich",
    "subscription.yearly": "Jährlich",
    "subscription.per_month": "/Monat",
    "subscription.per_year": "/Jahr",
    "subscription.save_percent": "33% SPAREN",
    "subscription.recommended": "EMPFOHLEN",
    "subscription.subscribe": "Abonnieren",
    "subscription.restore": "Käufe wiederherstellen",
    "subscription.legal": "Das Abonnement verlängert sich automatisch, sofern es nicht 24 Stunden vor Ablauf des aktuellen Zeitraums gekündigt wird.",
    "subscription.terms": "Nutzungsbedingungen",
    "subscription.privacy": "Datenschutz",
    "subscription.success_title": "Willkommen bei Premium!",
    "subscription.success_subtitle": "Alle Funktionen sind freigeschaltet",
    "subscription.get_started": "Loslegen",

    // Pro Features
    "subscription.pro.feature1": "Alle 12 Academy-Kurse",
    "subscription.pro.feature2": "40-Qubit Lokale Simulation",
    "subscription.pro.feature3": "Erweiterte Beispiele",
    "subscription.pro.feature4": "E-Mail-Support",
    "subscription.pro.desc_monthly": "Voller Academy-Zugang mit erweiterter Simulation",
    "subscription.pro.desc_yearly": "Bester Wert für Quantencomputing-Lernen",

    // Premium Features
    "subscription.premium.feature1": "Alles in Pro",
    "subscription.premium.feature2": "QuantumBridge QPU-Verbindung",
    "subscription.premium.feature3": "Fehlerkorrektur-Simulation",
    "subscription.premium.feature4": "Industrielösungen-Zugang",
    "subscription.premium.feature5": "Prioritäts-Support",
    "subscription.premium.desc_monthly": "Voller Zugang zu echter Quantenhardware",
    "subscription.premium.desc_yearly": "Komplettes Quantenerlebnis zum besten Preis",

    // Subscription Tabs & Comparison
    "subscription.tab.compare": "Vergleichen",
    "subscription.tab.pro": "Pro",
    "subscription.tab.premium": "Premium",
    "subscription.features": "Funktionen",
    "subscription.free": "Kostenlos",
    "subscription.select_plan": "Plan auswählen",
    "subscription.compare.circuits": "Quantenschaltkreise",
    "subscription.compare.simulation": "Lokale Simulation",
    "subscription.compare.academy_basic": "Academy (Basis)",
    "subscription.compare.academy_full": "Academy (Voll)",
    "subscription.compare.qpu_access": "Echter QPU-Zugang",
    "subscription.compare.industry": "Industrielösungen",
    "subscription.compare.support": "E-Mail-Support",
    "subscription.compare.priority": "Prioritäts-Support",
    "subscription.pro.subtitle": "Perfekt zum Lernen und Experimentieren",
    "subscription.premium.subtitle": "Komplettes Quantencomputing-Erlebnis",

    // More Hub - Subscription Info
    "more.subscription_info": "Abo-Info",
    "more.subscription_info.subtitle": "Pro & Premium Funktionen entdecken",

    // Subscription Info Page
    "subscription.info.title": "Premium freischalten",
    "subscription.info.subtitle": "Holen Sie das Beste aus SwiftQuantum mit Pro oder Premium",
    "subscription.info.choose_tier": "Wählen Sie Ihren Plan",
    "subscription.info.best_value": "Empfohlen",
    "subscription.info.pro.feature1": "Echter QPU-Zugang",
    "subscription.info.pro.feature2": "Alle Schaltkreis-Vorlagen",
    "subscription.info.pro.feature3": "Prioritäts-Support",
    "subscription.info.premium.feature1": "Alle Pro-Funktionen",
    "subscription.info.premium.feature2": "Fehlerkorrektur",
    "subscription.info.premium.feature3": "Industrielösungen",
    "subscription.info.all_features": "Alle Premium-Funktionen",
    "subscription.info.feature.qpu": "Echter QPU-Zugang",
    "subscription.info.feature.qpu.desc": "Schaltkreise auf IBM Quantencomputern mit 127+ Qubits ausführen",
    "subscription.info.feature.academy": "Quanten-Akademie",
    "subscription.info.feature.academy.desc": "Zugang zu allen MIT/Harvard-Kursen und Lektionen",
    "subscription.info.feature.industry": "Industrielösungen",
    "subscription.info.feature.industry.desc": "Enterprise-Quantenoptimierung für Ihr Unternehmen",
    "subscription.info.feature.error": "Fehlerkorrektur",
    "subscription.info.feature.error.desc": "Surface-Code-Simulation und fehlertolerantes Rechnen",
    "subscription.info.feature.support": "Prioritäts-Support",
    "subscription.info.feature.support.desc": "Schnellere Antworten von unseren Quantenexperten",
    "subscription.info.subscribe_now": "Jetzt abonnieren",
    "subscription.info.cancel_anytime": "Jederzeit kündbar. Keine Verpflichtung."
]
