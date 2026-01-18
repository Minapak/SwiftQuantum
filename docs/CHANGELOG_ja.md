# 変更履歴

このプロジェクトのすべての注目すべき変更がこのファイルに記録されます。

フォーマットは[Keep a Changelog](https://keepachangelog.com/en/1.0.0/)に基づいており、
このプロジェクトは[Semantic Versioning](https://semver.org/spec/v2.0.0.html)に準拠しています。

---

## [2.2.4] - 2026-01-18

### 追加
- **IBM Quantum Ecosystem完全ローカライゼーション**
  - 12のエコシステムプロジェクト名と説明をローカライズ（EN、KO、JA、ZH、DE）
  - カテゴリラベル（機械学習、化学、最適化、ハードウェア、シミュレーション、リサーチ）
  - `QuantumEcosystemProject`モデルを`nameKey`と`descriptionKey`を使用するようにリファクタリング
  - `EcosystemCategory` enumに`localizationKey`プロパティ追加
  - `EcosystemProjectCard`、`EcosystemProjectDetailSheet`、`EcosystemCodeExportSheet`をローカライズ

- **サブスクリプションシステムの完全再設計**
  - タブベースの比較UI（比較、Pro、Premiumタブ）
  - 4つの異なるプランを持つ`SubscriptionPlan` enum（proMonthly、proYearly、premiumMonthly、premiumYearly）
  - Free/Pro/Premiumカラムを持つ機能比較テーブル
  - 月額/年額トグル付きプラン選択カード
  - すべてのサブスクリプションUIを5言語にローカライズ

- **サブスクリプション情報ページ（その他タブ）**
  - ティア比較付きの新しい`SubscriptionInfoView`
  - プレミアム解除メッセージ付きヒーローセクション
  - Pro vs Premiumティアカードを並べて表示
  - アイコンと説明付きの全機能リスト
  - PaywallViewへのワンタップアクセス
  - その他タブの新しい設定行：「サブスクリプション情報」
  - すべての文字列をローカライズ（EN、KO、JA、ZH、DE）

- **新しいローカライゼーションキー（5言語）**
  - `subscription.info.title`、`subscription.info.subtitle`、`subscription.info.choose_tier`
  - `subscription.info.best_value`、`subscription.info.pro.feature1-3`、`subscription.info.premium.feature1-3`
  - `subscription.info.all_features`、`subscription.info.feature.qpu/academy/industry/error/support`
  - `subscription.info.subscribe_now`、`subscription.info.cancel_anytime`
  - `ecosystem.category.*`、`ecosystem.project.*`、`ecosystem.project.*.desc`

### 修正
- **特典説明のテキスト切り捨て**
  - `IndustryHubView.heroBenefitRow`：`lineLimit(1)`を`fixedSize(horizontal: false, vertical: true)`に変更
  - `PresetsHubView.heroBenefitRow`：同じ修正を適用
  - ヒーローセクションが「...」切り捨てなしですべての言語で全文を表示

### 変更
- **Ecosystemプロジェクトモデル**：ハードコードされた英語文字列の代わりにローカライゼーションキーを使用
- **PaywallView**：タブベースのサブスクリプション比較で完全に書き直し
- **MoreHubView**：設定セクションにサブスクリプション情報エントリを追加

---

## [2.2.3] - 2026-01-18

### 追加
- **認証画面ローカライゼーション**
  - ログイン、サインアップ、パスワードリセット画面を完全ローカライズ
  - すべてのフォームフィールド（メール、ユーザー名、パスワード）をローカライズ
  - エラーメッセージと検証テキストを5言語で提供
  - 認証画面でSFシンボルの代わりに実際のアプリアイコンを使用

- **プレミアムサブスクリプションペイウォール再設計**
  - ティアと期間選択を備えた完全なUI刷新
  - ティア選択：視覚的インジケーター付きのPro vs Premium
  - 期間選択：33%割引バッジ付きの月額 vs 年額
  - 選択したティアに基づく動的機能リスト
  - ローカライズされた価格と説明

- **サブスクリプションローカライゼーションキー（5言語）**
  - `subscription.title`、`subscription.subtitle`、`subscription.choose_plan`
  - `subscription.pro/premium`、`subscription.monthly/yearly`
  - `subscription.pro.feature1-4`、`subscription.premium.feature1-5`
  - `subscription.pro/premium.desc_monthly/yearly`
  - `subscription.subscribe`、`subscription.restore`、`subscription.legal`

- **Industryカードローカライゼーション**
  - 6つのインダストリーカードを完全ローカライズ（金融、医療、物流、エネルギー、製造、AI）
  - インダストリー特典の説明をすべての言語にローカライズ

### 変更
- **Industryヒーローセクション**：ハードコードされた統計を直感的な特典説明に置き換え
- **Circuitsヒーローセクション**：ハードコードされた統計を特典説明に置き換え
- **Academyヒーローセクション**：シャドウ効果付きの実際のアプリアイコンを使用

---

## [2.2.1] - 2026-01-16

### 追加
- **リアルタイム言語切り替え**
  - アプリ再起動なしで即時UI更新
  - `@MainActor`ローカライズプロパティを持つ`LocalizationManager`
  - `QuantumHub` enumのMainActor分離問題を修正

- **その他タブバックエンド統合**
  - バックエンドからユーザー統計を取得する`UserStatsManager`
  - アプリ内ウェブ設定ページ用の`SafariWebView`
  - 設定項目（通知、外観、プライバシー、ヘルプ）→ウェブURL
  - UserDefaultsフォールバック付きバックエンド接続クイック統計

---

## [2.2.0] - 2026-01-13

### 追加
- **Apple App Store Server API v2によるバックエンド統合**
  - `APIClient.swift`：完全なバックエンドAPI通信レイヤー
  - Appleサーバーとのjwt認証
  - iOSからバックエンドへのトランザクション検証フロー

- **StoreKit 2プレミアムシステム**
  - `PremiumManager.swift`：バックエンド検証付きの完全なStoreKit 2統合
  - 購入後の自動トランザクション検証
  - サブスクリプション状態の永続化と復元

- **ドイツ語ローカライゼーション（de.lproj）**
  - すべてのUI文字列の完全翻訳
  - 現在5言語をサポート：EN、KO、JA、ZH-Hans、DE

---

## [2.1.0] - 2026-01-06

### 追加
- **QuantumExecutorプロトコル** - ハイブリッド実行システム
  - `LocalQuantumExecutor`：オプションのエラー訂正付きローカルシミュレーション
  - `QuantumBridgeExecutor`：IBM Quantum APIを介した実機量子ハードウェア
  - ローカルとクラウド実行間のシームレスな切り替えのための統一インターフェース

- **フォールトトレラントシミュレーション**（Harvard-MIT 2025リサーチ）
  - Nature 2025論文に基づく表面コードエラー訂正
  - 448キュービットフォールトトレラントアーキテクチャシミュレーション
  - 0.5%未満の論理エラー率モデリング

- **4-Hubナビゲーション**（Apple HIG統合）
  - `LabHubView.swift`：コントロール + 測定 + 情報
  - `PresetsHubView.swift`：プリセット + 例
  - `FactoryHubView.swift`：Bridge（QPU接続）
  - `MoreHubView.swift`：Academy + Industry + プロフィール

---

[2.2.4]: https://github.com/Minapak/SwiftQuantum/compare/v2.2.3...v2.2.4
[2.2.3]: https://github.com/Minapak/SwiftQuantum/compare/v2.2.1...v2.2.3
[2.2.1]: https://github.com/Minapak/SwiftQuantum/compare/v2.2.0...v2.2.1
[2.2.0]: https://github.com/Minapak/SwiftQuantum/compare/v2.1.1...v2.2.0
[2.1.0]: https://github.com/Minapak/SwiftQuantum/compare/v2.0.0...v2.1.0
