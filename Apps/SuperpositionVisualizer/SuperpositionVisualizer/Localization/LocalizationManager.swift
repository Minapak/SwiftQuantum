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
