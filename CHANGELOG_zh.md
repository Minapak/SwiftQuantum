# 更新日志

此项目的所有显著变更将记录在此文件中。

格式基于[Keep a Changelog](https://keepachangelog.com/en/1.0.0/)，
本项目遵循[Semantic Versioning](https://semver.org/spec/v2.0.0.html)。

---

## [2.2.4] - 2026-01-18

### 新增
- **IBM Quantum Ecosystem完全本地化**
  - 12个生态系统项目名称和描述已本地化（EN、KO、JA、ZH、DE）
  - 类别标签（机器学习、化学、优化、硬件、模拟、研究）
  - `QuantumEcosystemProject`模型重构为使用`nameKey`和`descriptionKey`
  - `EcosystemCategory`枚举添加`localizationKey`属性
  - `EcosystemProjectCard`、`EcosystemProjectDetailSheet`、`EcosystemCodeExportSheet`已本地化

- **订阅系统全面重设计**
  - 基于标签的比较UI（比较、Pro、Premium标签）
  - 具有4个不同计划的`SubscriptionPlan`枚举（proMonthly、proYearly、premiumMonthly、premiumYearly）
  - 带有Free/Pro/Premium列的功能比较表
  - 带有月/年切换的计划选择卡
  - 所有订阅UI本地化为5种语言

- **订阅信息页面（更多标签）**
  - 带有层级比较的新`SubscriptionInfoView`
  - 带有高级解锁消息的英雄部分
  - 并排显示的Pro vs Premium层级卡
  - 带有图标和描述的完整功能列表
  - 一键访问PaywallView
  - 更多标签中的新设置行："订阅信息"
  - 所有字符串已本地化（EN、KO、JA、ZH、DE）

- **新本地化键（5种语言）**
  - `subscription.info.title`、`subscription.info.subtitle`、`subscription.info.choose_tier`
  - `subscription.info.best_value`、`subscription.info.pro.feature1-3`、`subscription.info.premium.feature1-3`
  - `subscription.info.all_features`、`subscription.info.feature.qpu/academy/industry/error/support`
  - `subscription.info.subscribe_now`、`subscription.info.cancel_anytime`
  - `ecosystem.category.*`、`ecosystem.project.*`、`ecosystem.project.*.desc`

### 修复
- **福利描述中的文本截断**
  - `IndustryHubView.heroBenefitRow`：将`lineLimit(1)`更改为`fixedSize(horizontal: false, vertical: true)`
  - `PresetsHubView.heroBenefitRow`：应用相同修复
  - 英雄部分现在在所有语言中显示完整文本，无"..."截断

### 变更
- **Ecosystem项目模型**：现在使用本地化键而不是硬编码的英文字符串
- **PaywallView**：使用基于标签的订阅比较完全重写
- **MoreHubView**：在设置部分添加订阅信息条目

---

## [2.2.3] - 2026-01-18

### 新增
- **认证屏幕本地化**
  - 登录、注册、密码重置屏幕完全本地化
  - 所有表单字段（电子邮件、用户名、密码）已本地化
  - 错误消息和验证文本提供5种语言
  - 认证屏幕现在使用实际应用图标而不是SF符号

- **高级订阅付费墙重设计**
  - 带有层级和期限选择的完整UI改版
  - 层级选择：带有视觉指示器的Pro vs Premium
  - 期限选择：带有33%折扣徽章的月付 vs 年付
  - 基于所选层级的动态功能列表
  - 本地化的价格和描述

- **订阅本地化键（5种语言）**
  - `subscription.title`、`subscription.subtitle`、`subscription.choose_plan`
  - `subscription.pro/premium`、`subscription.monthly/yearly`
  - `subscription.pro.feature1-4`、`subscription.premium.feature1-5`
  - `subscription.pro/premium.desc_monthly/yearly`
  - `subscription.subscribe`、`subscription.restore`、`subscription.legal`

- **行业卡本地化**
  - 6张行业卡完全本地化（金融、医疗、物流、能源、制造、AI）
  - 行业福利描述已本地化为所有语言

### 变更
- **Industry英雄部分**：用直观的福利描述替换硬编码的统计数据
- **Circuits英雄部分**：用福利描述替换硬编码的统计数据
- **Academy英雄部分**：现在使用带有阴影效果的实际应用图标

---

## [2.2.1] - 2026-01-16

### 新增
- **实时语言切换**
  - 无需应用重启即可即时更新UI
  - 带有`@MainActor`本地化属性的`LocalizationManager`
  - 修复了`QuantumHub`枚举中的MainActor隔离问题

- **更多标签后端集成**
  - 从后端获取用户统计的`UserStatsManager`
  - 用于应用内网页设置页面的`SafariWebView`
  - 设置项（通知、外观、隐私、帮助）→网页URL
  - 带有UserDefaults回退的后端连接快速统计

---

## [2.2.0] - 2026-01-13

### 新增
- **Apple App Store Server API v2后端集成**
  - `APIClient.swift`：完整的后端API通信层
  - 与Apple服务器的JWT认证
  - 从iOS到后端的交易验证流程

- **StoreKit 2高级系统**
  - `PremiumManager.swift`：带有后端验证的完整StoreKit 2集成
  - 购买后自动交易验证
  - 订阅状态持久化和恢复

- **德语本地化（de.lproj）**
  - 所有UI字符串的完整翻译
  - 现在支持5种语言：EN、KO、JA、ZH-Hans、DE

---

## [2.1.0] - 2026-01-06

### 新增
- **QuantumExecutor协议** - 混合执行系统
  - `LocalQuantumExecutor`：带有可选错误纠正的本地模拟
  - `QuantumBridgeExecutor`：通过IBM Quantum API的真实量子硬件
  - 用于本地和云执行之间无缝切换的统一接口

- **容错模拟**（Harvard-MIT 2025研究）
  - 基于Nature 2025论文的表面码错误纠正
  - 448量子比特容错架构模拟
  - 低于0.5%的逻辑错误率建模

- **4-Hub导航**（Apple HIG整合）
  - `LabHubView.swift`：控制 + 测量 + 信息
  - `PresetsHubView.swift`：预设 + 示例
  - `FactoryHubView.swift`：Bridge（QPU连接）
  - `MoreHubView.swift`：Academy + Industry + 个人资料

---

[2.2.4]: https://github.com/Minapak/SwiftQuantum/compare/v2.2.3...v2.2.4
[2.2.3]: https://github.com/Minapak/SwiftQuantum/compare/v2.2.1...v2.2.3
[2.2.1]: https://github.com/Minapak/SwiftQuantum/compare/v2.2.0...v2.2.1
[2.2.0]: https://github.com/Minapak/SwiftQuantum/compare/v2.1.1...v2.2.0
[2.1.0]: https://github.com/Minapak/SwiftQuantum/compare/v2.0.0...v2.1.0
