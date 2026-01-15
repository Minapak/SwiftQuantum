//
//  LocalizationManager.swift
//  SuperpositionVisualizer
//
//  SwiftQuantum Language Management
//  Supports: English, Korean, Japanese, Chinese, German
//

import SwiftUI

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
    }

    func setLanguage(_ language: AppLanguage) {
        currentLanguage = language
    }

    private func updateAppLanguage() {
        UserDefaults.standard.set([currentLanguage.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
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
    case presets = "nav.presets"
    case academy = "nav.academy"
    case industry = "nav.industry"
    case profile = "nav.profile"
    case more = "nav.more"

    // Tab Descriptions
    case labDescription = "nav.lab.description"
    case presetsDescription = "nav.presets.description"
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
    case onboardingLoad = "onboarding.load"
    case onboardingPresetsDesc = "onboarding.presetsDesc"
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
        case .presets: return "Presets"
        case .academy: return "Academy"
        case .industry: return "Industry"
        case .profile: return "Profile"
        case .more: return "More"
        case .labDescription: return "Quantum Experiments"
        case .presetsDescription: return "Saved States"
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
        case .onboardingLoad: return "Load"
        case .onboardingPresetsDesc: return "Explore famous quantum states like Bell pairs and GHZ states with one tap."
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
    .presets: "Presets",
    .academy: "Academy",
    .industry: "Industry",
    .profile: "Profile",
    .more: "More",
    .labDescription: "Quantum Experiments",
    .presetsDescription: "Saved States",
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
    .onboardingLoad: "Load",
    .onboardingPresetsDesc: "Explore famous quantum states like Bell pairs and GHZ states with one tap.",
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
    .presets: "프리셋",
    .academy: "아카데미",
    .industry: "산업",
    .profile: "프로필",
    .more: "더보기",
    .labDescription: "양자 실험",
    .presetsDescription: "저장된 상태",
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
    .onboardingLoad: "불러오기",
    .onboardingPresetsDesc: "벨 상태, GHZ 상태 등 유명한 양자 상태를 한 번의 탭으로 탐험하세요.",
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
    .presets: "プリセット",
    .academy: "アカデミー",
    .industry: "産業",
    .profile: "プロフィール",
    .more: "その他",
    .labDescription: "量子実験",
    .presetsDescription: "保存された状態",
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
    .onboardingLoad: "読み込む",
    .onboardingPresetsDesc: "ベル状態やGHZ状態などの有名な量子状態をワンタップで探索できます。",
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
    .presets: "预设",
    .academy: "学院",
    .industry: "行业",
    .profile: "个人资料",
    .more: "更多",
    .labDescription: "量子实验",
    .presetsDescription: "已保存状态",
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
    .onboardingLoad: "加载",
    .onboardingPresetsDesc: "一键探索贝尔态和GHZ态等著名量子态。",
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
    .presets: "Voreinstellungen",
    .academy: "Akademie",
    .industry: "Industrie",
    .profile: "Profil",
    .more: "Mehr",
    .labDescription: "Quantenexperimente",
    .presetsDescription: "Gespeicherte Zustände",
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
    .onboardingLoad: "Laden",
    .onboardingPresetsDesc: "Entdecken Sie berühmte Quantenzustände wie Bell-Paare und GHZ-Zustände mit einem Tippen.",
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
