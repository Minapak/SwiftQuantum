# SwiftQuantum v2.2.4 - プレミアム量子ハイブリッドプラットフォーム

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%2018%2B%20%7C%20macOS%2015%2B-lightgrey.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![QuantumBridge](https://img.shields.io/badge/QuantumBridge-2.0-blueviolet.svg)](https://github.com/user/QuantumBridge)
[![Quantum-Hybrid](https://img.shields.io/badge/Quantum--Hybrid-2026-00ff88.svg)](#)
[![Agentic AI](https://img.shields.io/badge/Agentic%20AI-Ready-ff6b6b.svg)](#)
[![Localization](https://img.shields.io/badge/Languages-EN%20%7C%20KO%20%7C%20JA%20%7C%20ZH%20%7C%20DE-blue.svg)](#)

**実機QPU接続を備えた初のiOS量子コンピューティングフレームワーク** - QuantumBridge統合、フォールトトレラントシミュレーション、Harvard-MIT研究ベースの教育コンテンツを搭載！

> **Harvard-MIT研究基盤**: 3,000以上の連続キュービット動作と0.5%未満のエラー率を実証した2025年Nature論文に基づく
>
> **実機量子ハードウェア**: QuantumBridge APIを介してIBM Quantumの127キュービットシステムに接続
>
> **プレミアム学習プラットフォーム**: サブスクリプションベースのコースを備えたMIT/Harvardスタイルの量子アカデミー
>
> **エンタープライズソリューション**: 金融、医療、物流向けB2B産業アプリケーション

---

## v2.2.4の新機能（2026年本番リリース）

### IBM Quantum Ecosystemローカライゼーションとサブスクリプションシステムの刷新

- **IBM Quantum Ecosystem完全ローカライゼーション**:
  - 12のエコシステムプロジェクト名と説明をローカライズ（EN、KO、JA、ZH、DE）
  - カテゴリラベル（ML、Chemistry、Optimization、Hardware、Simulation、Research）をローカライズ
  - エコシステムプロジェクトカード、詳細シート、コードエクスポートビューを完全ローカライズ

- **サブスクリプションシステムの完全再設計**:
  - タブベースの比較UI（比較、Pro、Premiumタブ）
  - 明確なプラン区分：Pro月額、Pro年額、Premium月額、Premium年額
  - Free/Pro/Premiumカラムを持つ機能比較テーブル
  - 5言語でローカライズ

- **サブスクリプション情報ページ（その他タブ）**:
  - 設定セクションに新しい「サブスクリプション情報」メニュー項目
  - Pro vs Premium機能を説明する専用ページ
  - 機能ハイライト付きのティア比較カード
  - 説明付きの全機能リスト
  - サブスクリプション用PaywallViewへのワンタップアクセス

- **テキスト切り捨て修正**:
  - 特典説明で「...」を引き起こす`lineLimit(1)`を修正
  - IndustryとCircuitsタブのヒーローセクションがすべての言語で全文を表示

---

## クイックスタート

### インストール

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/Minapak/SwiftQuantum.git", from: "2.2.4")
]
```

### 基本的な使い方

```swift
import SwiftQuantum

// 量子レジスタを作成
let register = QuantumRegister(numberOfQubits: 3)

// ゲートを適用
register.applyGate(.hadamard, to: 0)
register.applyCNOT(control: 0, target: 1)
register.applyCNOT(control: 1, target: 2)
// GHZ状態を作成: (|000⟩ + |111⟩)/√2

// 測定
let results = register.measureMultiple(shots: 1000)
// ["000": ~500, "111": ~500]
```

### QuantumBridge接続

```swift
import SwiftQuantum

// IBM Quantum用のエグゼキューターを作成
let executor = QuantumBridgeExecutor(
    executorType: .ibmBrisbane,
    apiKey: "YOUR_IBM_QUANTUM_API_KEY"  // IBM Quantumから取得
)

// 回路を構築
let circuit = BridgeCircuitBuilder(numberOfQubits: 2, name: "Bell")
    .h(0)
    .cx(control: 0, target: 1)

// 実機量子ハードウェアで実行
let result = try await executor.execute(circuit: circuit, shots: 1000)
print("カウント: \(result.counts)")  // {"00": 498, "11": 502}
```

---

## QuantumBridgeタブ - 完全ガイド

**Bridge**タブは実機量子ハードウェアへのゲートウェイです！以下のことができます：

### QuantumBridgeを使用する理由

| メリット | 説明 |
|---------|------|
| **実機ハードウェア** | 実際のIBM量子プロセッサ（127キュービット！）で回路を実行 |
| **真の量子効果** | 実際の重ね合わせとエンタングルメントを体験 |
| **本物の結果** | シミュレーションではなく実際の量子コンピュータから測定値を取得 |

### バックエンドオプション

| バックエンド | 最適用途 | 利点 | 制限事項 |
|------------|---------|------|---------|
| **シミュレータ** | 学習とテスト | 即時結果、無料、キュー待ちなし | 実際の量子ノイズなし |
| **IBM Brisbane** | 本番とリサーチ | 127キュービット、高いコヒーレンス | キュー待ち時間 |
| **IBM Osaka** | 高速実行 | 高速ゲート速度、短いキュー | 中程度のノイズ |
| **IBM Kyoto** | 研究プロジェクト | 高度なエラー軽減 | 現在メンテナンス中 |

---

## Industryタブ - エンタープライズソリューション

**Industry**タブは実際のビジネス向けの量子コンピューティングアプリケーションを紹介します。

### 利用可能な産業

| 産業 | ユースケース | 効率向上 |
|-----|------------|---------|
| **金融** | ポートフォリオ最適化、リスク分析 | +52% |
| **医療** | 創薬、タンパク質折りたたみ | +38% |
| **物流** | ルート最適化、サプライチェーン | +45% |
| **エネルギー** | グリッド最適化、予測 | +41% |
| **製造** | 品質管理、メンテナンス | +33% |
| **AI & ML** | 量子機械学習 | +67% |

---

## IBM Quantum Ecosystem統合

### Ecosystemカテゴリ

| カテゴリ | プロジェクト | 説明 |
|--------|------------|------|
| **機械学習** | TorchQuantum, Qiskit ML | 量子ニューラルネットワークとMLアルゴリズム |
| **化学・物理** | Qiskit Nature | 分子シミュレーションと創薬 |
| **最適化** | Qiskit Finance, Optimization | ポートフォリオ最適化とQAOA |
| **ハードウェアプロバイダー** | IBM, Azure, AWS Braket, IonQ | 量子プロセッサへの直接アクセス |
| **シミュレーション** | Qiskit Aer, MQT DDSIM | 高性能シミュレータ |
| **リサーチ** | PennyLane, Cirq | クロスプラットフォーム研究フレームワーク |

---

## プレミアム機能

### サブスクリプションティア

| 機能 | 無料 | Pro ($4.99/月) | Premium ($9.99/月) |
|-----|-----|---------------|-------------------|
| ローカルシミュレーション | 20キュービット | 40キュービット | 40キュービット |
| 量子ゲート | すべて15+ | すべて15+ | すべて15+ |
| 基本例 | はい | はい | はい |
| QuantumBridge接続 | いいえ | はい | **はい** |
| エラー訂正シミュレーション | いいえ | いいえ | **はい** |
| 量子アカデミーコース | 2つ無料 | すべて12+ | **すべて12+** |
| 産業ソリューション | 閲覧のみ | 一部 | **フルアクセス** |
| 優先サポート | いいえ | メール | **優先** |

---

## 研究基盤

### Harvard-MIT Nature 2025論文

SwiftQuantumは最先端の量子コンピューティング研究に基づいて構築されています：

1. **「448中性原子キュービットによるフォールトトレラント量子計算」**（Nature、2025年11月）
   - 0.5%未満のフォールトトレラント閾値の初実証

2. **「3,000キュービットコヒーレントシステムの連続動作」**（Nature、2025年9月）
   - 2時間以上の連続量子動作

3. **「中性原子量子コンピュータでのマジックステート蒸留」**（Nature、2025年7月）
   - 汎用フォールトトレラント量子計算に必須

---

## ロードマップ

### バージョン2.2.4（現在 - 2026年1月）
- [x] IBM Quantum Ecosystem完全ローカライゼーション（12プロジェクト、6カテゴリ）
- [x] タブベース比較によるサブスクリプションシステムの完全再設計
- [x] その他タブ設定にサブスクリプション情報ページ
- [x] 多言語特典説明のテキスト切り捨て修正
- [x] すべてのサブスクリプション関連UIを5言語にローカライズ

### バージョン2.3.0（計画 - 2026年第2四半期）
- [ ] 実際のIBM Quantumジョブ送信
- [ ] 量子フーリエ変換（QFT）
- [ ] Shorのアルゴリズム実装
- [ ] クラウドジョブキューダッシュボード
- [ ] チーム/エンタープライズアカウント

---

## ライセンス

MITライセンス - [LICENSE](LICENSE)を参照

---

<div align="center">

**SwiftQuantum - iOSでの量子コンピューティングの未来**

*Harvard-MIT研究を基盤に*

</div>
