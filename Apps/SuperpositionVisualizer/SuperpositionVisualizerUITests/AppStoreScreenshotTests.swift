//
//  AppStoreScreenshotTests.swift
//  SuperpositionVisualizerUITests
//
//  Created for App Store Connect screenshot capture
//  Captures screenshots in all 5 supported languages
//

import XCTest

final class AppStoreScreenshotTests: XCTestCase {

    let app = XCUIApplication()

    // Supported languages
    let languages = ["en", "ko", "ja", "zh-Hans", "de"]

    override func setUpWithError() throws {
        continueAfterFailure = false

        // Skip onboarding
        app.launchArguments += ["-hasCompletedOnboarding", "YES"]
        app.launchArguments += ["-useNewUI", "YES"]
    }

    override func tearDownWithError() throws {
        // Cleanup
    }

    // MARK: - Screenshot Capture for All Languages

    @MainActor
    func testCaptureAllScreenshots() throws {
        for language in languages {
            // Set language
            app.launchArguments = ["-AppleLanguages", "(\(language))"]
            app.launchArguments += ["-hasCompletedOnboarding", "YES"]
            app.launchArguments += ["-useNewUI", "YES"]
            app.launch()

            // Wait for app to load
            sleep(2)

            // Capture Lab screen
            captureScreenshot(name: "01_Lab", language: language)

            // Tap Presets tab
            let presetsTab = app.buttons["Presets"]
            if presetsTab.exists {
                presetsTab.tap()
                sleep(1)
                captureScreenshot(name: "02_Presets", language: language)
            }

            // Tap Bridge tab
            let bridgeTab = app.buttons["Bridge"]
            if bridgeTab.exists {
                bridgeTab.tap()
                sleep(1)
                captureScreenshot(name: "03_Bridge", language: language)
            }

            // Tap More tab
            let moreTab = app.buttons["More"]
            if moreTab.exists {
                moreTab.tap()
                sleep(1)
                captureScreenshot(name: "04_More", language: language)
            }

            // Go back to Lab and show Measure mode
            let labTab = app.buttons["Lab"]
            if labTab.exists {
                labTab.tap()
                sleep(1)

                // Try to tap Measure button
                let measureButton = app.buttons["Measure"]
                if measureButton.exists {
                    measureButton.tap()
                    sleep(1)
                    captureScreenshot(name: "05_Measure", language: language)
                }
            }

            app.terminate()
        }
    }

    // MARK: - Single Language Tests (for faster iteration)

    @MainActor
    func testCaptureEnglishScreenshots() throws {
        captureScreenshotsForLanguage("en")
    }

    @MainActor
    func testCaptureKoreanScreenshots() throws {
        captureScreenshotsForLanguage("ko")
    }

    @MainActor
    func testCaptureJapaneseScreenshots() throws {
        captureScreenshotsForLanguage("ja")
    }

    @MainActor
    func testCaptureChineseScreenshots() throws {
        captureScreenshotsForLanguage("zh-Hans")
    }

    @MainActor
    func testCaptureGermanScreenshots() throws {
        captureScreenshotsForLanguage("de")
    }

    // MARK: - Helper Methods

    private func captureScreenshotsForLanguage(_ language: String) {
        app.launchArguments = ["-AppleLanguages", "(\(language))"]
        app.launchArguments += ["-hasCompletedOnboarding", "YES"]
        app.launchArguments += ["-useNewUI", "YES"]
        app.launch()

        sleep(2)

        // Capture all main screens
        captureScreenshot(name: "01_Lab", language: language)

        // Navigate through tabs
        tapTabAndCapture(tabName: "Presets", screenshotName: "02_Presets", language: language)
        tapTabAndCapture(tabName: "Bridge", screenshotName: "03_Bridge", language: language)
        tapTabAndCapture(tabName: "More", screenshotName: "04_More", language: language)

        // Back to Lab for Measure
        tapTabAndCapture(tabName: "Lab", screenshotName: "05_Lab_Control", language: language)
    }

    private func tapTabAndCapture(tabName: String, screenshotName: String, language: String) {
        // Try different ways to find the tab
        let tab = app.buttons[tabName]
        let tabBar = app.tabBars.buttons[tabName]

        if tab.exists {
            tab.tap()
        } else if tabBar.exists {
            tabBar.tap()
        }

        sleep(1)
        captureScreenshot(name: screenshotName, language: language)
    }

    private func captureScreenshot(name: String, language: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "\(language)_\(name)"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
