//
//  DeveloperModeManager.swift
//  SuperpositionVisualizer
//
//  Developer Mode for QA/QC Testing
//  Logs all button taps and interactions
//

import SwiftUI

// MARK: - Developer Mode Manager
@MainActor
class DeveloperModeManager: ObservableObject {
    static let shared = DeveloperModeManager()

    @Published var isEnabled: Bool = true  // 개발 모드 활성화
    @Published var tapLogs: [TapLogEntry] = []
    @Published var showLogOverlay: Bool = false

    struct TapLogEntry: Identifiable {
        let id = UUID()
        let timestamp: Date
        let screen: String
        let element: String
        let status: TapStatus
    }

    enum TapStatus: String {
        case success = "✅"
        case failed = "❌"
        case comingSoon = "⏳"
        case noAction = "⚠️"
    }

    func log(screen: String, element: String, status: TapStatus) {
        let entry = TapLogEntry(
            timestamp: Date(),
            screen: screen,
            element: element,
            status: status
        )
        tapLogs.insert(entry, at: 0)

        // 최대 100개 로그 유지
        if tapLogs.count > 100 {
            tapLogs.removeLast()
        }
    }

    func clearLogs() {
        tapLogs.removeAll()
    }

    func exportLogs() -> String {
        var report = "=== Developer Mode Tap Log ===\n"
        report += "Generated: \(Date())\n\n"

        for log in tapLogs.reversed() {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            let time = formatter.string(from: log.timestamp)
            report += "[\(time)] \(log.status.rawValue) [\(log.screen)] \(log.element)\n"
        }

        return report
    }

    // 테스트 통계
    var successCount: Int { tapLogs.filter { $0.status == .success }.count }
    var failedCount: Int { tapLogs.filter { $0.status == .failed }.count }
    var comingSoonCount: Int { tapLogs.filter { $0.status == .comingSoon }.count }
    var noActionCount: Int { tapLogs.filter { $0.status == .noAction }.count }
}

// MARK: - Developer Mode Badge
struct DeveloperModeBadge: View {
    @ObservedObject var devMode = DeveloperModeManager.shared

    var body: some View {
        if devMode.isEnabled {
            VStack {
                HStack {
                    Button(action: {
                        withAnimation(.spring()) {
                            devMode.showLogOverlay.toggle()
                        }
                    }) {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                                .overlay(
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 8, height: 8)
                                        .scaleEffect(1.5)
                                        .opacity(0.3)
                                )

                            Text("DEV MODE")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)

                            Text("[\(devMode.tapLogs.count)]")
                                .font(.system(size: 9, weight: .medium, design: .monospaced))
                                .foregroundColor(.yellow)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.9))
                        .clipShape(Capsule())
                    }

                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.top, 50)

                Spacer()
            }
        }
    }
}

// MARK: - Developer Log Overlay
struct DeveloperLogOverlay: View {
    @ObservedObject var devMode = DeveloperModeManager.shared
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.black.opacity(0.95)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Developer Mode Log")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .foregroundColor(.green)

                        Text("\(devMode.tapLogs.count) interactions logged")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(.white.opacity(0.6))
                    }

                    Spacer()

                    Button(action: { devMode.clearLogs() }) {
                        Text("Clear")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.orange)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.orange.opacity(0.2))
                            .clipShape(Capsule())
                    }

                    Button(action: { devMode.showLogOverlay = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                .padding()

                // Stats
                HStack(spacing: 20) {
                    statBadge("✅", count: devMode.successCount, label: "Success", color: .green)
                    statBadge("❌", count: devMode.failedCount, label: "Failed", color: .red)
                    statBadge("⏳", count: devMode.comingSoonCount, label: "Coming Soon", color: .orange)
                    statBadge("⚠️", count: devMode.noActionCount, label: "No Action", color: .yellow)
                }
                .padding(.horizontal)
                .padding(.bottom, 12)

                Divider()
                    .background(Color.green.opacity(0.3))

                // Log List
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 2) {
                        ForEach(devMode.tapLogs) { log in
                            logRow(log)
                        }
                    }
                    .padding()
                }
            }
        }
    }

    private func statBadge(_ emoji: String, count: Int, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Text(emoji)
                    .font(.system(size: 14))
                Text("\(count)")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(color)
            }
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
    }

    private func logRow(_ log: DeveloperModeManager.TapLogEntry) -> some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        let time = formatter.string(from: log.timestamp)

        return HStack(alignment: .top, spacing: 8) {
            Text(time)
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(.white.opacity(0.4))
                .frame(width: 80, alignment: .leading)

            Text(log.status.rawValue)
                .font(.system(size: 12))

            Text("[\(log.screen)]")
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundColor(.cyan)

            Text(log.element)
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(.white.opacity(0.8))

            Spacer()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(
            log.status == .failed ? Color.red.opacity(0.1) :
            log.status == .noAction ? Color.yellow.opacity(0.1) :
            Color.clear
        )
    }
}

// MARK: - Loggable Button Modifier
struct LoggableButton: ViewModifier {
    let screen: String
    let element: String
    let hasAction: Bool
    let isComingSoon: Bool

    @ObservedObject var devMode = DeveloperModeManager.shared

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        if devMode.isEnabled {
                            let status: DeveloperModeManager.TapStatus
                            if isComingSoon {
                                status = .comingSoon
                            } else if hasAction {
                                status = .success
                            } else {
                                status = .noAction
                            }
                            devMode.log(screen: screen, element: element, status: status)
                        }
                    }
            )
    }
}

extension View {
    func logTap(screen: String, element: String, hasAction: Bool = true, isComingSoon: Bool = false) -> some View {
        modifier(LoggableButton(screen: screen, element: element, hasAction: hasAction, isComingSoon: isComingSoon))
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        VStack {
            DeveloperModeBadge()
            Spacer()
        }
    }
}
