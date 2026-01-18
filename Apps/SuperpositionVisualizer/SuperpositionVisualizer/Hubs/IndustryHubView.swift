import SwiftUI
import SwiftQuantum

// MARK: - Industry Hub - "The Value"
// Premium Solution Showcase
// 3D 아이소매트릭 스타일 산업 아이콘, Gold-Orange 배지
// 앵커링 효과를 위한 플랜 비교, 수익 예측 그래프

struct IndustryHubView: View {
    @StateObject private var viewModel = IndustryHubViewModel()
    @ObservedObject var premiumManager = PremiumManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    @State private var selectedIndustry: HorizonIndustrySolution?
    @State private var showPricingSheet = false
    @State private var showCaseStudy = false
    @State private var showPremiumSheet = false
    @State private var showIndustryDetail = false
    @State private var showROICalculator = false
    @State private var selectedEcosystemProject: QuantumEcosystemProject?
    @State private var showEcosystemDetail = false
    @State private var selectedEcosystemCategory: QuantumEcosystemProject.EcosystemCategory?

    // Localization helper
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hero Section (Simplified)
                heroSection

                // Selected Industry Detail (if selected)
                if let industry = selectedIndustry {
                    selectedIndustryDetail(industry)
                }

                // Industry Solutions Grid
                industrySolutionsGrid

                // IBM Quantum Ecosystem Section
                ecosystemSection

                // Quick ROI Calculator Card
                quickROICard

                // Simple CTA Section
                simpleCTASection

                Spacer(minLength: 120)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .sheet(isPresented: $showPricingSheet) {
            PricingDetailSheet()
        }
        .sheet(isPresented: $showPremiumSheet) {
            IndustryPremiumSheet()
        }
        .sheet(isPresented: $showROICalculator) {
            ROICalculatorSheet(viewModel: viewModel)
        }
        .sheet(isPresented: $showIndustryDetail) {
            if let industry = selectedIndustry {
                IndustryDetailSheet(industry: industry)
            }
        }
        .sheet(isPresented: $showEcosystemDetail) {
            if let project = selectedEcosystemProject {
                EcosystemProjectDetailSheet(project: project)
            }
        }
    }

    // MARK: - IBM Quantum Ecosystem Section
    private var ecosystemSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Image(systemName: "network")
                            .font(.system(size: 16))
                            .foregroundStyle(QuantumHorizonColors.quantumCyan)
                        Text(L("ecosystem.title"))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Text(L("ecosystem.subtitle"))
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
                Spacer()
            }

            // Category Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    // All category button
                    Button(action: {
                        withAnimation(.spring()) {
                            selectedEcosystemCategory = nil
                        }
                    }) {
                        Text(L("ecosystem.all"))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(selectedEcosystemCategory == nil ? .black : .white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                selectedEcosystemCategory == nil ?
                                QuantumHorizonColors.quantumCyan :
                                Color.white.opacity(0.1)
                            )
                            .clipShape(Capsule())
                    }

                    ForEach(QuantumEcosystemProject.EcosystemCategory.allCases, id: \.self) { category in
                        Button(action: {
                            withAnimation(.spring()) {
                                selectedEcosystemCategory = category
                            }
                        }) {
                            Text(category.rawValue)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(selectedEcosystemCategory == category ? .black : .white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    selectedEcosystemCategory == category ?
                                    QuantumHorizonColors.quantumCyan :
                                    Color.white.opacity(0.1)
                                )
                                .clipShape(Capsule())
                        }
                    }
                }
            }

            // Ecosystem Projects Grid
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 12) {
                ForEach(filteredEcosystemProjects) { project in
                    EcosystemProjectCard(
                        project: project,
                        isPremiumUser: premiumManager.isPremium
                    )
                    .onTapGesture {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        if !project.isPremium || premiumManager.isPremium {
                            DeveloperModeManager.shared.log(screen: "Industry", element: "Ecosystem: \(project.name)", status: .success)
                            selectedEcosystemProject = project
                            showEcosystemDetail = true
                        } else {
                            DeveloperModeManager.shared.log(screen: "Industry", element: "Ecosystem: \(project.name) (Premium)", status: .comingSoon)
                            showPremiumSheet = true
                        }
                    }
                }
            }
        }
    }

    private var filteredEcosystemProjects: [QuantumEcosystemProject] {
        if let category = selectedEcosystemCategory {
            return viewModel.ecosystemProjects.filter { $0.category == category }
        }
        return viewModel.ecosystemProjects
    }

    // MARK: - Quick ROI Card
    private var quickROICard: some View {
        BentoCard(size: .medium) {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(L("industry.roi.title"))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Text(L("industry.roi.subtitle"))
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.5))
                    }

                    Spacer()

                    Text("~$\(Int(viewModel.projectedAnnualGain))K/year")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(QuantumHorizonColors.goldCelebration)
                }

                Button(action: {
                    DeveloperModeManager.shared.log(screen: "Industry", element: "Calculate ROI", status: .success)
                    showROICalculator = true
                }) {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                        Text(L("industry.roi.calculate"))
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(QuantumHorizonColors.quantumPurple.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }

    // MARK: - Simple CTA Section
    private var simpleCTASection: some View {
        VStack(spacing: 12) {
            Button(action: {
                if premiumManager.isPremium {
                    showPricingSheet = true
                } else {
                    showPremiumSheet = true
                }
            }) {
                HStack {
                    Image(systemName: premiumManager.isPremium ? "crown.fill" : "star.fill")
                    Text(premiumManager.isPremium ? L("industry.upgrade_enterprise") : L("industry.get_premium"))
                }
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(QuantumHorizonColors.goldCelebration)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            Text(L("industry.trial"))
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.4))
        }
    }

    // MARK: - Selected Industry Detail Card
    private func selectedIndustryDetail(_ industry: HorizonIndustrySolution) -> some View {
        BentoCard(size: .medium) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(industry.color.opacity(0.2))
                            .frame(width: 50, height: 50)
                        Image(systemName: industry.icon)
                            .font(.system(size: 24))
                            .foregroundColor(industry.color)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(L(industry.nameKey))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        Text(L(industry.benefitKey))
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                    }

                    Spacer()

                    Button(action: {
                        withAnimation(.spring()) {
                            selectedIndustry = nil
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white.opacity(0.4))
                    }
                }

                // Industry Details
                VStack(alignment: .leading, spacing: 10) {
                    industryDetailRow(icon: "chart.line.uptrend.xyaxis", title: L("industry.efficiency_gain"), value: "+\(industry.efficiencyGain)%")
                    industryDetailRow(icon: "clock.fill", title: L("industry.implementation"), value: L("industry.impl_weeks"))
                    industryDetailRow(icon: "person.3.fill", title: L("industry.team_size"), value: L("industry.any_size"))
                }

                // Use Cases
                VStack(alignment: .leading, spacing: 8) {
                    Text(L("industry.use_cases"))
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))

                    ForEach(getUseCases(for: industry.name), id: \.self) { useCase in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(industry.color)
                                .frame(width: 6, height: 6)
                            Text(useCase)
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }

                // Action Button
                Button(action: {
                    DeveloperModeManager.shared.log(screen: "Industry", element: "Learn More: \(industry.name)", status: .success)
                    showIndustryDetail = true
                }) {
                    HStack {
                        Image(systemName: "book.fill")
                        Text(L("industry.learn_more"))
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(industry.color.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }

    private func industryDetailRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(QuantumHorizonColors.quantumGold)
                .frame(width: 20)

            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.6))

            Spacer()

            Text(value)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
        }
    }

    private func getUseCases(for industry: String) -> [String] {
        switch industry {
        case "Finance":
            return [L("industry.use.finance.1"), L("industry.use.finance.2"), L("industry.use.finance.3"), L("industry.use.finance.4")]
        case "Healthcare":
            return [L("industry.use.health.1"), L("industry.use.health.2"), L("industry.use.health.3"), L("industry.use.health.4")]
        case "Logistics":
            return [L("industry.use.logistics.1"), L("industry.use.logistics.2"), L("industry.use.logistics.3"), L("industry.use.logistics.4")]
        case "Energy":
            return [L("industry.use.energy.1"), L("industry.use.energy.2"), L("industry.use.energy.3"), L("industry.use.energy.4")]
        case "Manufacturing":
            return [L("industry.use.mfg.1"), L("industry.use.mfg.2"), L("industry.use.mfg.3"), L("industry.use.mfg.4")]
        case "AI & ML":
            return [L("industry.use.ai.1"), L("industry.use.ai.2"), L("industry.use.ai.3"), L("industry.use.ai.4")]
        default:
            return [L("industry.use.default.1"), L("industry.use.default.2"), L("industry.use.default.3")]
        }
    }

    // MARK: - Hero Section (Simplified)
    private var heroSection: some View {
        BentoCard(size: .medium) {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    // Simple Icon
                    ZStack {
                        Circle()
                            .fill(QuantumHorizonColors.quantumGold.opacity(0.2))
                            .frame(width: 60, height: 60)

                        Image(systemName: "building.2.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(QuantumHorizonColors.goldCelebration)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(L("industry.title"))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)

                        Text(L("industry.subtitle"))
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.6))
                    }

                    Spacer()
                }

                // Key Benefits Row - More intuitive description
                VStack(spacing: 10) {
                    heroBenefitRow(
                        icon: "bolt.fill",
                        text: L("industry.hero.benefit1"),
                        color: QuantumHorizonColors.quantumCyan
                    )
                    heroBenefitRow(
                        icon: "cpu",
                        text: L("industry.hero.benefit2"),
                        color: QuantumHorizonColors.quantumPurple
                    )
                    heroBenefitRow(
                        icon: "chart.line.uptrend.xyaxis",
                        text: L("industry.hero.benefit3"),
                        color: QuantumHorizonColors.quantumGold
                    )
                }
            }
        }
    }

    private func heroBenefitRow(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(color)
                .frame(width: 18)

            Text(text)
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 8)

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 11))
                .foregroundColor(QuantumHorizonColors.quantumGreen.opacity(0.7))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    // MARK: - Industry Solutions Grid
    private var industrySolutionsGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L("industry.title"))
                .font(QuantumHorizonTypography.sectionTitle(18))
                .foregroundColor(.white)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                ForEach(viewModel.industries) { industry in
                    HorizonIndustrySolutionCard(
                        industry: industry,
                        isSelected: selectedIndustry?.id == industry.id,
                        isPremiumUser: premiumManager.isPremium
                    )
                    .onTapGesture {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        if !industry.isPremium || premiumManager.isPremium {
                            DeveloperModeManager.shared.log(screen: "Industry", element: "Solution: \(industry.name)", status: .success)
                            withAnimation(.spring()) {
                                selectedIndustry = industry
                            }
                        } else {
                            DeveloperModeManager.shared.log(screen: "Industry", element: "Solution: \(industry.name) (Premium)", status: .comingSoon)
                            showPremiumSheet = true
                        }
                    }
                }
            }
        }
    }

    // MARK: - ROI Prediction Section
    private var roiPredictionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(L("industry.roi.title"))
                    .font(QuantumHorizonTypography.sectionTitle(18))
                    .foregroundColor(.white)

                Spacer()

                // User's learning progress badge
                HStack(spacing: 6) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 12))
                    Text(L("industry.roi.progress"))
                        .font(.system(size: 11))
                }
                .foregroundColor(QuantumHorizonColors.quantumGreen)
            }

            BentoCard(size: .medium) {
                VStack(spacing: 16) {
                    // Graph
                    ROIPredictionGraph(
                        currentValue: viewModel.currentROI,
                        projectedValue: viewModel.projectedROI
                    )
                    .frame(height: 140)

                    // Legend
                    HStack(spacing: 20) {
                        legendItem(color: .white.opacity(0.4), label: L("industry.legend.without"))
                        legendItem(color: QuantumHorizonColors.quantumGold, label: L("industry.legend.with"))
                    }

                    // Projected Gain
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(L("industry.roi.projected"))
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.5))

                            Text("$\(viewModel.projectedAnnualGain, specifier: "%.0f")K")
                                .font(QuantumHorizonTypography.statNumber(28))
                                .foregroundStyle(QuantumHorizonColors.goldCelebration)
                        }

                        Spacer()

                        // Calculate button
                        Button(action: {
                            DeveloperModeManager.shared.log(screen: "Industry", element: "Calculate ROI Button", status: .success)
                            showROICalculator = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "function")
                                Text(L("industry.roi.calculate_data"))
                            }
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(QuantumHorizonColors.quantumPurple.opacity(0.3))
                            .clipShape(Capsule())
                        }
                    }
                }
            }
        }
    }

    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: 16, height: 4)

            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.6))
        }
    }

    // MARK: - Pricing Section (Anchoring Effect)
    private var pricingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L("industry.choose_plan"))
                .font(QuantumHorizonTypography.sectionTitle(18))
                .foregroundColor(.white)

            // Enterprise Plan (shown first for anchoring)
            HorizonPricingPlanCard(
                plan: viewModel.enterprisePlan,
                isHighlighted: false,
                badge: L("industry.badge.best")
            ) {
                if premiumManager.isPremium {
                    // Already premium - show contact enterprise
                    showPricingSheet = true
                } else {
                    showPremiumSheet = true
                }
            }

            // Pro Plan
            HorizonPricingPlanCard(
                plan: viewModel.proPlan,
                isHighlighted: true,
                badge: L("industry.badge.popular")
            ) {
                if premiumManager.isPremium {
                    // Already premium
                    showPricingSheet = true
                } else {
                    showPremiumSheet = true
                }
            }

            // Comparison table
            comparisonTable
        }
    }

    private var comparisonTable: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(L("industry.compare.feature"))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(L("industry.compare.pro"))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(QuantumHorizonColors.quantumPurple)
                    .frame(width: 60)

                Text(L("industry.compare.enterprise"))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(QuantumHorizonColors.quantumGold)
                    .frame(width: 70)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)

            Divider()
                .background(Color.white.opacity(0.1))

            // Features
            ForEach(viewModel.comparisonFeatures, id: \.name) { feature in
                HStack {
                    Text(feature.name)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: feature.proIncluded ? "checkmark.circle.fill" : "minus.circle")
                        .font(.system(size: 14))
                        .foregroundColor(feature.proIncluded ? QuantumHorizonColors.quantumGreen : .white.opacity(0.3))
                        .frame(width: 60)

                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(QuantumHorizonColors.quantumGreen)
                        .frame(width: 70)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)

                if feature.name != viewModel.comparisonFeatures.last?.name {
                    Divider()
                        .background(Color.white.opacity(0.05))
                }
            }
        }
        .glassmorphism(intensity: 0.06, cornerRadius: 16)
    }

    // MARK: - Success Stories Section
    private var successStoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L("industry.success_stories"))
                .font(QuantumHorizonTypography.sectionTitle(18))
                .foregroundColor(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(viewModel.successStories) { story in
                        HorizonSuccessStoryCard(story: story)
                    }
                }
            }
        }
    }
}

// MARK: - Isometric Building View
struct IsometricBuildingView: View {
    @State private var offset: CGFloat = 0

    var body: some View {
        ZStack {
            // Building layers
            ForEach(0..<4, id: \.self) { index in
                IsometricCube(
                    width: CGFloat(60 - index * 10),
                    height: CGFloat(20 + index * 5),
                    color: QuantumHorizonColors.quantumGold.opacity(0.3 + Double(index) * 0.15)
                )
                .offset(y: -CGFloat(index * 20) + offset)
            }

            // Floating quantum particles
            ForEach(0..<5, id: \.self) { index in
                Circle()
                    .fill(QuantumHorizonColors.quantumCyan)
                    .frame(width: 4, height: 4)
                    .offset(
                        x: CGFloat.random(in: -40...40),
                        y: CGFloat.random(in: -50...0) + offset * 0.5
                    )
                    .opacity(Double.random(in: 0.3...0.8))
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                offset = -5
            }
        }
    }
}

struct IsometricCube: View {
    let width: CGFloat
    let height: CGFloat
    let color: Color

    var body: some View {
        ZStack {
            // Top face
            Path { path in
                path.move(to: CGPoint(x: width / 2, y: 0))
                path.addLine(to: CGPoint(x: width, y: height / 4))
                path.addLine(to: CGPoint(x: width / 2, y: height / 2))
                path.addLine(to: CGPoint(x: 0, y: height / 4))
                path.closeSubpath()
            }
            .fill(color)

            // Left face
            Path { path in
                path.move(to: CGPoint(x: 0, y: height / 4))
                path.addLine(to: CGPoint(x: width / 2, y: height / 2))
                path.addLine(to: CGPoint(x: width / 2, y: height))
                path.addLine(to: CGPoint(x: 0, y: height * 0.75))
                path.closeSubpath()
            }
            .fill(color.opacity(0.7))

            // Right face
            Path { path in
                path.move(to: CGPoint(x: width / 2, y: height / 2))
                path.addLine(to: CGPoint(x: width, y: height / 4))
                path.addLine(to: CGPoint(x: width, y: height * 0.75))
                path.addLine(to: CGPoint(x: width / 2, y: height))
                path.closeSubpath()
            }
            .fill(color.opacity(0.5))
        }
        .frame(width: width, height: height)
    }
}

// MARK: - Industry Solution Card
struct HorizonIndustrySolutionCard: View {
    let industry: HorizonIndustrySolution
    let isSelected: Bool
    var isPremiumUser: Bool = false
    @ObservedObject var localization = LocalizationManager.shared

    // Localization helper
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                // Icon background
                RoundedRectangle(cornerRadius: 16)
                    .fill(industry.color.opacity(0.15))
                    .frame(width: 56, height: 56)

                Image(systemName: industry.icon)
                    .font(.system(size: 26, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [industry.color, industry.color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Premium badge (shows lock if not premium user, crown if premium user)
                if industry.isPremium && !isPremiumUser {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.orange)
                        .padding(4)
                        .background(Color.black.opacity(0.8))
                        .clipShape(Circle())
                        .offset(x: 22, y: -22)
                } else if industry.isPremium && isPremiumUser {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(QuantumHorizonColors.goldCelebration)
                        .padding(4)
                        .background(Color.black.opacity(0.8))
                        .clipShape(Circle())
                        .offset(x: 22, y: -22)
                }
            }

            VStack(spacing: 4) {
                Text(L(industry.nameKey))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)

                Text(L(industry.benefitKey))
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.5))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }

            // Efficiency gain
            HStack(spacing: 4) {
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 10))
                Text("\(industry.efficiencyGain)% \(L("industry.efficiency"))")
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(QuantumHorizonColors.quantumGreen)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .glassmorphism(intensity: isSelected ? 0.15 : 0.08, cornerRadius: 20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? industry.color : Color.clear, lineWidth: 2)
        )
        .opacity(industry.isPremium && !isPremiumUser ? 0.7 : 1.0)
    }
}

// MARK: - ROI Prediction Graph
struct ROIPredictionGraph: View {
    let currentValue: Double
    let projectedValue: Double

    @State private var animationProgress: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height

            ZStack {
                // Grid lines
                ForEach(0..<5, id: \.self) { index in
                    Path { path in
                        let y = height * CGFloat(index) / 4
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
                }

                // Without quantum (baseline)
                Path { path in
                    path.move(to: CGPoint(x: 0, y: height * 0.7))
                    path.addLine(to: CGPoint(x: width, y: height * 0.6))
                }
                .stroke(Color.white.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5]))

                // With quantum (growth curve)
                Path { path in
                    path.move(to: CGPoint(x: 0, y: height * 0.7))

                    // Bezier curve for growth
                    path.addCurve(
                        to: CGPoint(x: width * animationProgress, y: height * 0.2),
                        control1: CGPoint(x: width * 0.3, y: height * 0.6),
                        control2: CGPoint(x: width * 0.6, y: height * 0.3)
                    )
                }
                .stroke(QuantumHorizonColors.goldCelebration, lineWidth: 3)
                .shadow(color: QuantumHorizonColors.quantumGold.opacity(0.5), radius: 8)

                // End point indicator
                if animationProgress > 0.9 {
                    Circle()
                        .fill(QuantumHorizonColors.quantumGold)
                        .frame(width: 12, height: 12)
                        .position(x: width, y: height * 0.2)
                        .pulsingGlow(color: QuantumHorizonColors.quantumGold, radius: 10)
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 1.5).delay(0.3)) {
                    animationProgress = 1.0
                }
            }
        }
    }
}

// MARK: - Pricing Plan Card
struct HorizonPricingPlanCard: View {
    let plan: HorizonPricingPlan
    let isHighlighted: Bool
    let badge: String?
    var onGetStarted: () -> Void = {}
    @ObservedObject var localization = LocalizationManager.shared

    // Localization helper
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    if let badge = badge {
                        Text(badge)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(isHighlighted ? QuantumHorizonColors.quantumPurple : QuantumHorizonColors.quantumGold)
                            .clipShape(Capsule())
                    }

                    Text(plan.name)
                        .font(QuantumHorizonTypography.sectionTitle(20))
                        .foregroundColor(.white)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("$")
                            .font(.system(size: 16, weight: .medium))
                        Text("\(plan.price)")
                            .font(QuantumHorizonTypography.statNumber(32))
                    }
                    .foregroundStyle(isHighlighted ? QuantumHorizonColors.miamiSunset : QuantumHorizonColors.goldCelebration)

                    Text("/month")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
            }

            Divider()
                .background(Color.white.opacity(0.1))

            // Features
            VStack(alignment: .leading, spacing: 10) {
                ForEach(plan.features.prefix(4), id: \.self) { feature in
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(QuantumHorizonColors.quantumGreen)

                        Text(feature)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }

            // CTA Button
            Button(action: {
                DeveloperModeManager.shared.log(screen: "Industry", element: "Pricing: \(plan.name) Get Started", status: .success)
                onGetStarted()
            }) {
                Text(L("industry.get_started"))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        isHighlighted ?
                        AnyShapeStyle(QuantumHorizonColors.miamiSunset) :
                        AnyShapeStyle(Color.white.opacity(0.1))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(SpringButtonStyle())
        }
        .padding(20)
        .glassmorphism(intensity: isHighlighted ? 0.12 : 0.06, cornerRadius: 20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    isHighlighted ?
                    QuantumHorizonColors.quantumPurple.opacity(0.5) :
                    Color.clear,
                    lineWidth: 1.5
                )
        )
    }
}

// MARK: - Success Story Card
struct HorizonSuccessStoryCard: View {
    let story: HorizonSuccessStory

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Company logo placeholder
            HStack {
                Circle()
                    .fill(story.color.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(story.company.prefix(1)))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(story.color)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(story.company)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)

                    Text(story.industry)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.5))
                }
            }

            Text("\"\(story.quote)\"")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(3)
                .italic()

            // Result
            HStack(spacing: 4) {
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 11))
                Text(story.result)
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundColor(QuantumHorizonColors.quantumGreen)
        }
        .padding(16)
        .frame(width: 260)
        .glassmorphism(intensity: 0.08, cornerRadius: 16)
    }
}

// MARK: - Models
struct HorizonIndustrySolution: Identifiable {
    let id = UUID()
    let nameKey: String      // Localization key for name
    let icon: String
    let benefitKey: String   // Localization key for benefit
    let efficiencyGain: Int
    let color: Color
    let isPremium: Bool

    // For backward compatibility, keep name as computed property
    var name: String { nameKey }
}

// MARK: - IBM Quantum Ecosystem Project Model
struct QuantumEcosystemProject: Identifiable {
    let id = UUID()
    let nameKey: String
    let category: EcosystemCategory
    let descriptionKey: String
    let icon: String
    let color: Color
    let stars: Int?
    let githubUrl: String?
    let isPremium: Bool

    enum EcosystemCategory: String, CaseIterable {
        case machineLearning
        case chemistry
        case optimization
        case hardware
        case simulation
        case research

        var localizationKey: String {
            switch self {
            case .machineLearning: return "ecosystem.category.ml"
            case .chemistry: return "ecosystem.category.chem"
            case .optimization: return "ecosystem.category.opt"
            case .hardware: return "ecosystem.category.hw"
            case .simulation: return "ecosystem.category.sim"
            case .research: return "ecosystem.category.research"
            }
        }
    }
}

struct HorizonPricingPlan {
    let name: String
    let price: Int
    let features: [String]
}

struct HorizonComparisonFeature {
    let name: String
    let proIncluded: Bool
}

struct HorizonSuccessStory: Identifiable {
    let id = UUID()
    let company: String
    let industry: String
    let quote: String
    let result: String
    let color: Color
}

// MARK: - Industry Hub ViewModel
@MainActor
class IndustryHubViewModel: ObservableObject {
    @Published var industries: [HorizonIndustrySolution] = []
    @Published var ecosystemProjects: [QuantumEcosystemProject] = []
    @Published var currentROI: Double = 15000
    @Published var projectedROI: Double = 85000
    @Published var projectedAnnualGain: Double = 127.5

    let proPlan = HorizonPricingPlan(
        name: "Pro",
        price: 29,
        features: [
            "Advanced quantum algorithms",
            "50 QPU minutes/month",
            "Email support",
            "Basic analytics"
        ]
    )

    let enterprisePlan = HorizonPricingPlan(
        name: "Enterprise",
        price: 199,
        features: [
            "Unlimited quantum access",
            "Custom algorithm development",
            "24/7 priority support",
            "Advanced analytics & ROI tracking"
        ]
    )

    let comparisonFeatures: [HorizonComparisonFeature] = [
        HorizonComparisonFeature(name: "Quantum Hardware Access", proIncluded: true),
        HorizonComparisonFeature(name: "Custom Algorithms", proIncluded: false),
        HorizonComparisonFeature(name: "Priority Support", proIncluded: false),
        HorizonComparisonFeature(name: "ROI Dashboard", proIncluded: true),
        HorizonComparisonFeature(name: "Team Collaboration", proIncluded: false),
        HorizonComparisonFeature(name: "SLA Guarantee", proIncluded: false)
    ]

    @Published var successStories: [HorizonSuccessStory] = []

    init() {
        setupData()
        setupEcosystemProjects()
    }

    private func setupData() {
        industries = [
            HorizonIndustrySolution(nameKey: "industry.card.finance", icon: "chart.line.uptrend.xyaxis", benefitKey: "industry.card.finance.benefit", efficiencyGain: 52, color: .green, isPremium: true),
            HorizonIndustrySolution(nameKey: "industry.card.healthcare", icon: "cross.circle.fill", benefitKey: "industry.card.healthcare.benefit", efficiencyGain: 38, color: .red, isPremium: true),
            HorizonIndustrySolution(nameKey: "industry.card.logistics", icon: "shippingbox.fill", benefitKey: "industry.card.logistics.benefit", efficiencyGain: 45, color: .orange, isPremium: false),
            HorizonIndustrySolution(nameKey: "industry.card.energy", icon: "bolt.fill", benefitKey: "industry.card.energy.benefit", efficiencyGain: 41, color: .yellow, isPremium: true),
            HorizonIndustrySolution(nameKey: "industry.card.manufacturing", icon: "gear.circle.fill", benefitKey: "industry.card.manufacturing.benefit", efficiencyGain: 33, color: .purple, isPremium: false),
            HorizonIndustrySolution(nameKey: "industry.card.ai", icon: "brain.head.profile", benefitKey: "industry.card.ai.benefit", efficiencyGain: 67, color: QuantumHorizonColors.quantumCyan, isPremium: true)
        ]

        successStories = [
            HorizonSuccessStory(company: "GlobalBank", industry: "Finance", quote: "Quantum optimization reduced our risk exposure by 40% while increasing returns.", result: "40% risk reduction", color: .green),
            HorizonSuccessStory(company: "PharmaCorp", industry: "Healthcare", quote: "Drug candidate screening time cut from months to days.", result: "85% faster discovery", color: .red),
            HorizonSuccessStory(company: "LogiFlow", industry: "Logistics", quote: "Fleet routing optimization saved us $2.3M annually.", result: "$2.3M annual savings", color: .orange)
        ]
    }

    // MARK: - IBM Quantum Ecosystem Projects Setup
    private func setupEcosystemProjects() {
        ecosystemProjects = [
            // Machine Learning
            QuantumEcosystemProject(
                nameKey: "ecosystem.project.torchquantum",
                category: .machineLearning,
                descriptionKey: "ecosystem.project.torchquantum.desc",
                icon: "brain.fill",
                color: .orange,
                stars: 1591,
                githubUrl: "https://github.com/mit-han-lab/torchquantum",
                isPremium: false
            ),
            QuantumEcosystemProject(
                nameKey: "ecosystem.project.qiskit_ml",
                category: .machineLearning,
                descriptionKey: "ecosystem.project.qiskit_ml.desc",
                icon: "cpu.fill",
                color: .blue,
                stars: 928,
                githubUrl: "https://github.com/qiskit-community/qiskit-machine-learning",
                isPremium: true
            ),

            // Chemistry & Physics
            QuantumEcosystemProject(
                nameKey: "ecosystem.project.qiskit_nature",
                category: .chemistry,
                descriptionKey: "ecosystem.project.qiskit_nature.desc",
                icon: "atom",
                color: .green,
                stars: 372,
                githubUrl: "https://github.com/qiskit-community/qiskit-nature",
                isPremium: true
            ),

            // Optimization
            QuantumEcosystemProject(
                nameKey: "ecosystem.project.qiskit_finance",
                category: .optimization,
                descriptionKey: "ecosystem.project.qiskit_finance.desc",
                icon: "chart.line.uptrend.xyaxis",
                color: .green,
                stars: 302,
                githubUrl: "https://github.com/qiskit-community/qiskit-finance",
                isPremium: true
            ),
            QuantumEcosystemProject(
                nameKey: "ecosystem.project.qiskit_optimization",
                category: .optimization,
                descriptionKey: "ecosystem.project.qiskit_optimization.desc",
                icon: "gearshape.2.fill",
                color: .purple,
                stars: 272,
                githubUrl: "https://github.com/qiskit-community/qiskit-optimization",
                isPremium: true
            ),

            // Hardware Providers
            QuantumEcosystemProject(
                nameKey: "ecosystem.project.ibm_quantum",
                category: .hardware,
                descriptionKey: "ecosystem.project.ibm_quantum.desc",
                icon: "server.rack",
                color: .blue,
                stars: nil,
                githubUrl: nil,
                isPremium: true
            ),
            QuantumEcosystemProject(
                nameKey: "ecosystem.project.azure_quantum",
                category: .hardware,
                descriptionKey: "ecosystem.project.azure_quantum.desc",
                icon: "cloud.fill",
                color: .cyan,
                stars: nil,
                githubUrl: nil,
                isPremium: true
            ),
            QuantumEcosystemProject(
                nameKey: "ecosystem.project.aws_braket",
                category: .hardware,
                descriptionKey: "ecosystem.project.aws_braket.desc",
                icon: "arrow.triangle.branch",
                color: .orange,
                stars: nil,
                githubUrl: nil,
                isPremium: true
            ),
            QuantumEcosystemProject(
                nameKey: "ecosystem.project.ionq",
                category: .hardware,
                descriptionKey: "ecosystem.project.ionq.desc",
                icon: "bolt.circle.fill",
                color: .purple,
                stars: nil,
                githubUrl: nil,
                isPremium: true
            ),

            // Simulation
            QuantumEcosystemProject(
                nameKey: "ecosystem.project.qiskit_aer",
                category: .simulation,
                descriptionKey: "ecosystem.project.qiskit_aer.desc",
                icon: "waveform.path",
                color: .indigo,
                stars: 629,
                githubUrl: "https://github.com/Qiskit/qiskit-aer",
                isPremium: false
            ),
            QuantumEcosystemProject(
                nameKey: "ecosystem.project.mqt_ddsim",
                category: .simulation,
                descriptionKey: "ecosystem.project.mqt_ddsim.desc",
                icon: "square.grid.3x3.fill",
                color: .teal,
                stars: 156,
                githubUrl: "https://github.com/cda-tum/mqt-ddsim",
                isPremium: false
            ),

            // Research
            QuantumEcosystemProject(
                nameKey: "ecosystem.project.pennylane",
                category: .research,
                descriptionKey: "ecosystem.project.pennylane.desc",
                icon: "doc.text.magnifyingglass",
                color: .pink,
                stars: nil,
                githubUrl: "https://github.com/PennyLaneAI/pennylane",
                isPremium: false
            ),
            QuantumEcosystemProject(
                nameKey: "ecosystem.project.cirq",
                category: .research,
                descriptionKey: "ecosystem.project.cirq.desc",
                icon: "circle.hexagongrid.fill",
                color: .red,
                stars: nil,
                githubUrl: "https://github.com/quantumlib/Cirq",
                isPremium: false
            )
        ]
    }
}

// MARK: - Pricing Detail Sheet
struct PricingDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var localization = LocalizationManager.shared

    // Localization helper
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    var body: some View {
        ZStack {
            QuantumHorizonBackground()

            VStack {
                // Close button
                HStack {
                    Spacer()
                    Button(action: {
                        DeveloperModeManager.shared.log(screen: "Pricing Detail", element: "Close Button", status: .success)
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                .padding()

                Spacer()

                Text(L("industry.pricing_soon"))
                    .font(QuantumHorizonTypography.sectionTitle())
                    .foregroundColor(.white)

                Spacer()
            }
        }
    }
}

// MARK: - Industry Premium Sheet
struct IndustryPremiumSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var premiumManager = PremiumManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    @State private var showSuccessView = false

    // Localization helper
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    var body: some View {
        ZStack {
            QuantumHorizonBackground()

            if showSuccessView {
                UpgradeSuccessView(isPresented: $showSuccessView)
                    .transition(.opacity)
                    .onDisappear {
                        dismiss()
                    }
            } else {
                VStack(spacing: 24) {
                    // Close button
                    HStack {
                        Spacer()
                        Button(action: {
                            DeveloperModeManager.shared.log(screen: "Industry Premium", element: "Close Button", status: .success)
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }

                    // Crown icon
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(QuantumHorizonColors.goldCelebration)

                    Text(L("industry.premium.title"))
                        .font(QuantumHorizonTypography.sectionTitle(24))
                        .foregroundColor(.white)

                    Text(L("industry.premium.desc"))
                        .font(QuantumHorizonTypography.body(14))
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)

                    // Features list
                    VStack(alignment: .leading, spacing: 12) {
                        premiumFeatureRow(L("industry.premium.feat.finance"))
                        premiumFeatureRow(L("industry.premium.feat.health"))
                        premiumFeatureRow(L("industry.premium.feat.energy"))
                        premiumFeatureRow(L("industry.premium.feat.ai"))
                        premiumFeatureRow(L("industry.premium.feat.roi"))
                    }
                    .padding()
                    .glassmorphism(intensity: 0.08, cornerRadius: 16)

                    // Upgrade button
                    Button(action: {
                        DeveloperModeManager.shared.log(screen: "Industry Premium", element: "Upgrade Button - ACTIVATED", status: .success)
                        premiumManager.upgradeToPremium()
                        withAnimation {
                            showSuccessView = true
                        }
                    }) {
                        Text(L("industry.premium.upgrade"))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(QuantumHorizonColors.goldCelebration)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Text(L("industry.premium.trial"))
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.4))

                    Spacer()
                }
                .padding(24)
            }
        }
    }

    private func premiumFeatureRow(_ text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(QuantumHorizonColors.quantumGold)

            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

// MARK: - ROI Calculator Sheet
struct ROICalculatorSheet: View {
    @ObservedObject var viewModel: IndustryHubViewModel
    @Environment(\.dismiss) var dismiss
    @ObservedObject var localization = LocalizationManager.shared
    @State private var companySize: Double = 100
    @State private var annualBudget: Double = 500000
    @State private var selectedIndustry = "Finance"
    @State private var showResult = false

    // Localization helper
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    let industries = ["Finance", "Healthcare", "Logistics", "Energy", "Manufacturing", "AI & ML"]

    var calculatedROI: Double {
        let baseROI = annualBudget * 0.15  // 15% base
        let sizeMultiplier = min(companySize / 50, 3)  // Scale with company size
        let industryMultiplier: Double = {
            switch selectedIndustry {
            case "Finance": return 1.4
            case "Healthcare": return 1.2
            case "AI & ML": return 1.5
            case "Energy": return 1.3
            default: return 1.0
            }
        }()
        return baseROI * sizeMultiplier * industryMultiplier
    }

    var body: some View {
        ZStack {
            QuantumHorizonBackground()

            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(L("industry.roi.title"))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        Text(L("industry.roi.estimate"))
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }

                ScrollView {
                    VStack(spacing: 20) {
                        // Industry Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text(L("industry.title"))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(industries, id: \.self) { industry in
                                        Button(action: { selectedIndustry = industry }) {
                                            Text(industry)
                                                .font(.system(size: 13, weight: .medium))
                                                .foregroundColor(selectedIndustry == industry ? .black : .white)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(
                                                    selectedIndustry == industry ?
                                                    QuantumHorizonColors.quantumGold :
                                                    Color.white.opacity(0.1)
                                                )
                                                .clipShape(Capsule())
                                        }
                                    }
                                }
                            }
                        }

                        // Company Size Slider
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(L("industry.roi.team_size"))
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                                Spacer()
                                Text("\(Int(companySize)) people")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(QuantumHorizonColors.quantumCyan)
                            }

                            Slider(value: $companySize, in: 10...1000, step: 10)
                                .accentColor(QuantumHorizonColors.quantumCyan)
                        }
                        .padding()
                        .glassmorphism(intensity: 0.06, cornerRadius: 12)

                        // Annual Budget Slider
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(L("industry.roi.budget"))
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                                Spacer()
                                Text("$\(Int(annualBudget / 1000))K")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(QuantumHorizonColors.quantumCyan)
                            }

                            Slider(value: $annualBudget, in: 50000...10000000, step: 50000)
                                .accentColor(QuantumHorizonColors.quantumCyan)
                        }
                        .padding()
                        .glassmorphism(intensity: 0.06, cornerRadius: 12)

                        // Calculate Button
                        Button(action: {
                            withAnimation(.spring()) {
                                showResult = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                Text(L("industry.roi.calculate_btn"))
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(QuantumHorizonColors.miamiSunset)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }

                        // Result Section
                        if showResult {
                            VStack(spacing: 16) {
                                Text(L("industry.roi.estimated_savings"))
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.6))

                                Text("$\(Int(calculatedROI / 1000))K")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundStyle(QuantumHorizonColors.goldCelebration)

                                HStack(spacing: 20) {
                                    VStack {
                                        Text("ROI")
                                            .font(.system(size: 11))
                                            .foregroundColor(.white.opacity(0.5))
                                        Text("\(Int(calculatedROI / annualBudget * 100))%")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(QuantumHorizonColors.quantumGreen)
                                    }

                                    VStack {
                                        Text(L("industry.roi.payback"))
                                            .font(.system(size: 11))
                                            .foregroundColor(.white.opacity(0.5))
                                        Text("< 6 months")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                }

                                Text("*Based on industry benchmarks and your inputs")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                            .padding(20)
                            .glassmorphism(intensity: 0.1, cornerRadius: 16)
                            .transition(.opacity.combined(with: .scale))
                        }
                    }
                }

                Spacer()
            }
            .padding(24)
        }
    }
}

// MARK: - Industry Detail Sheet
struct IndustryDetailSheet: View {
    let industry: HorizonIndustrySolution
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            QuantumHorizonBackground()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        ZStack {
                            Circle()
                                .fill(industry.color.opacity(0.2))
                                .frame(width: 60, height: 60)
                            Image(systemName: industry.icon)
                                .font(.system(size: 28))
                                .foregroundColor(industry.color)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(industry.name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            Text(L("industry.quantum_solutions"))
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.6))
                        }

                        Spacer()

                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }

                    // Overview
                    VStack(alignment: .leading, spacing: 12) {
                        Text(L("industry.overview"))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)

                        Text(getIndustryOverview(industry.name))
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                            .lineSpacing(4)
                    }
                    .padding()
                    .glassmorphism(intensity: 0.06, cornerRadius: 16)

                    // Key Benefits
                    VStack(alignment: .leading, spacing: 12) {
                        Text(L("industry.key_benefits"))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)

                        ForEach(getIndustryBenefits(industry.name), id: \.self) { benefit in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(QuantumHorizonColors.quantumGreen)
                                Text(benefit)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                    .padding()
                    .glassmorphism(intensity: 0.06, cornerRadius: 16)

                    // Stats
                    HStack(spacing: 20) {
                        statCard(value: "+\(industry.efficiencyGain)%", label: L("industry.detail.efficiency"), color: QuantumHorizonColors.quantumGreen)
                        statCard(value: "2-4", label: L("industry.detail.weeks"), color: QuantumHorizonColors.quantumCyan)
                        statCard(value: "99.9%", label: L("industry.detail.uptime"), color: QuantumHorizonColors.quantumGold)
                    }

                    // CTA Buttons - Link to official learning resources
                    VStack(spacing: 12) {
                        // IBM Quantum Learning (Official Platform)
                        Button(action: {
                            if let url = URL(string: "https://quantum.cloud.ibm.com/learning/en") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "atom")
                                Text(L("industry.learn.ibm"))
                            }
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    colors: [Color(red: 0.2, green: 0.4, blue: 0.8), Color(red: 0.4, green: 0.2, blue: 0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        // MIT xPRO Quantum Computing
                        Button(action: {
                            if let url = URL(string: "https://xpro.mit.edu/programs/program-v1:xPRO+QCF/") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "building.columns.fill")
                                Text(L("industry.learn.mit"))
                            }
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(red: 0.6, green: 0.1, blue: 0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        // IBM Quantum 2026 Roadmap
                        Button(action: {
                            if let url = URL(string: "https://www.ibm.com/roadmaps/quantum/2026/") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "map.fill")
                                Text(L("industry.learn.roadmap"))
                            }
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(QuantumHorizonColors.goldCelebration)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }

                    Spacer(minLength: 50)
                }
                .padding(24)
            }
        }
    }

    private func statCard(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .glassmorphism(intensity: 0.08, cornerRadius: 12)
    }

    private func getIndustryOverview(_ name: String) -> String {
        switch name {
        case "Finance":
            return L("industry.overview.finance")
        case "Healthcare":
            return L("industry.overview.healthcare")
        case "Logistics":
            return L("industry.overview.logistics")
        case "Energy":
            return L("industry.overview.energy")
        case "Manufacturing":
            return L("industry.overview.manufacturing")
        case "AI & ML":
            return L("industry.overview.ai")
        default:
            return L("industry.overview.default")
        }
    }

    private func getIndustryBenefits(_ name: String) -> [String] {
        switch name {
        case "Finance":
            return [L("industry.benefit.finance.1"), L("industry.benefit.finance.2"), L("industry.benefit.finance.3"), L("industry.benefit.finance.4")]
        case "Healthcare":
            return [L("industry.benefit.health.1"), L("industry.benefit.health.2"), L("industry.benefit.health.3"), L("industry.benefit.health.4")]
        case "Logistics":
            return [L("industry.benefit.logistics.1"), L("industry.benefit.logistics.2"), L("industry.benefit.logistics.3"), L("industry.benefit.logistics.4")]
        case "Energy":
            return [L("industry.benefit.energy.1"), L("industry.benefit.energy.2"), L("industry.benefit.energy.3"), L("industry.benefit.energy.4")]
        case "Manufacturing":
            return [L("industry.benefit.mfg.1"), L("industry.benefit.mfg.2"), L("industry.benefit.mfg.3"), L("industry.benefit.mfg.4")]
        case "AI & ML":
            return [L("industry.benefit.ai.1"), L("industry.benefit.ai.2"), L("industry.benefit.ai.3"), L("industry.benefit.ai.4")]
        default:
            return [L("industry.benefit.default.1"), L("industry.benefit.default.2"), L("industry.benefit.default.3")]
        }
    }
}

// MARK: - Ecosystem Project Card
struct EcosystemProjectCard: View {
    let project: QuantumEcosystemProject
    var isPremiumUser: Bool = false
    @ObservedObject var localization = LocalizationManager.shared

    // Localization helper
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    var body: some View {
        HStack(spacing: 14) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(project.color.opacity(0.15))
                    .frame(width: 50, height: 50)

                Image(systemName: project.icon)
                    .font(.system(size: 22))
                    .foregroundColor(project.color)
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(L(project.nameKey))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)

                    if project.isPremium && !isPremiumUser {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.orange)
                    } else if project.isPremium && isPremiumUser {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(QuantumHorizonColors.goldCelebration)
                    }

                    Spacer()

                    if let stars = project.stars {
                        HStack(spacing: 3) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                            Text("\(stars)")
                                .font(.system(size: 11))
                        }
                        .foregroundColor(.yellow)
                    }
                }

                Text(L(project.descriptionKey))
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)

                // Category badge
                Text(L(project.category.localizationKey))
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(project.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(project.color.opacity(0.15))
                    .clipShape(Capsule())
            }

            // Arrow
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.3))
        }
        .padding(14)
        .glassmorphism(intensity: 0.08, cornerRadius: 16)
        .opacity(project.isPremium && !isPremiumUser ? 0.7 : 1.0)
    }
}

// MARK: - Ecosystem Project Detail Sheet
struct EcosystemProjectDetailSheet: View {
    let project: QuantumEcosystemProject
    @Environment(\.dismiss) var dismiss
    @ObservedObject var localization = LocalizationManager.shared
    @State private var isRunning = false
    @State private var runResult: String?
    @State private var showCodeExport = false

    // Localization helper
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    var body: some View {
        ZStack {
            QuantumHorizonBackground()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        ZStack {
                            Circle()
                                .fill(project.color.opacity(0.2))
                                .frame(width: 60, height: 60)
                            Image(systemName: project.icon)
                                .font(.system(size: 28))
                                .foregroundColor(project.color)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(L(project.nameKey))
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)

                            HStack(spacing: 8) {
                                Text(L(project.category.localizationKey))
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(project.color)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(project.color.opacity(0.15))
                                    .clipShape(Capsule())

                                if let stars = project.stars {
                                    HStack(spacing: 3) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 11))
                                        Text("\(stars)")
                                            .font(.system(size: 12, weight: .medium))
                                    }
                                    .foregroundColor(.yellow)
                                }
                            }
                        }

                        Spacer()

                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }

                    // Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text(L("ecosystem.about"))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)

                        Text(L(project.descriptionKey))
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                            .lineSpacing(4)
                    }
                    .padding()
                    .glassmorphism(intensity: 0.06, cornerRadius: 16)

                    // Quick Actions
                    VStack(alignment: .leading, spacing: 12) {
                        Text(L("ecosystem.actions"))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)

                        // Run Demo Button
                        Button(action: runDemo) {
                            HStack {
                                if isRunning {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "play.fill")
                                }
                                Text(isRunning ? L("ecosystem.running") : L("ecosystem.run_demo"))
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(project.color.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(isRunning)

                        // Export Code Button
                        Button(action: { showCodeExport = true }) {
                            HStack {
                                Image(systemName: "doc.text.fill")
                                Text(L("ecosystem.export_code"))
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        // GitHub Link
                        if let githubUrl = project.githubUrl {
                            Button(action: {
                                if let url = URL(string: githubUrl) {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                HStack {
                                    Image(systemName: "link")
                                    Text(L("ecosystem.view_github"))
                                }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.white.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding()
                    .glassmorphism(intensity: 0.06, cornerRadius: 16)

                    // Run Result
                    if let result = runResult {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(QuantumHorizonColors.quantumGreen)
                                Text(L("ecosystem.result"))
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            Text(result)
                                .font(.system(size: 13, design: .monospaced))
                                .foregroundColor(.white.opacity(0.8))
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.black.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding()
                        .glassmorphism(intensity: 0.08, cornerRadius: 16)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }

                    // Use Cases
                    VStack(alignment: .leading, spacing: 12) {
                        Text(L("ecosystem.use_cases"))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)

                        ForEach(getUseCases(), id: \.self) { useCase in
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(QuantumHorizonColors.quantumGreen)
                                    .font(.system(size: 14))
                                Text(useCase)
                                    .font(.system(size: 13))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                    .padding()
                    .glassmorphism(intensity: 0.06, cornerRadius: 16)

                    Spacer(minLength: 50)
                }
                .padding(24)
            }
        }
        .sheet(isPresented: $showCodeExport) {
            EcosystemCodeExportSheet(project: project)
        }
    }

    private func runDemo() {
        isRunning = true
        DeveloperModeManager.shared.log(screen: "Ecosystem Detail", element: "Run Demo: \(project.name)", status: .success)

        // Simulate running the demo
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring()) {
                runResult = generateDemoResult()
                isRunning = false
            }
        }
    }

    private func generateDemoResult() -> String {
        let projectName = L(project.nameKey)
        switch project.category {
        case .machineLearning:
            return """
            🧠 Quantum Neural Network Demo
            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            Model: 4-qubit variational classifier
            Layers: 3 quantum layers
            Parameters: 24 trainable weights
            Training accuracy: 94.2%
            Inference time: 0.023s
            """
        case .chemistry:
            return """
            ⚛️ Molecular Simulation Demo
            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            Molecule: H₂ (Hydrogen)
            Basis: STO-3G
            Qubits used: 4
            Ground state energy: -1.137 Ha
            Calculation time: 0.156s
            """
        case .optimization:
            return """
            📊 Portfolio Optimization Demo
            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            Assets: 5 stocks
            Algorithm: QAOA (p=2)
            Optimal allocation found
            Expected return: +12.3%
            Risk (VaR): 4.2%
            """
        case .hardware:
            return """
            🖥️ Hardware Connection Demo
            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            Backend: \(projectName)
            Status: ✅ Connected
            Queue position: #3
            Estimated wait: ~2 min
            Available qubits: 127
            """
        case .simulation:
            return """
            🌊 Quantum Simulation Demo
            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            Circuit: Bell State
            Qubits: 2
            Shots: 1000
            Results: {"00": 498, "11": 502}
            Fidelity: 99.8%
            """
        case .research:
            return """
            🔬 Research Framework Demo
            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            Framework: \(projectName)
            Mode: Hybrid quantum-classical
            Gradient method: Parameter-shift
            Optimization: Adam
            Convergence: 50 iterations
            """
        }
    }

    private func getUseCases() -> [String] {
        switch project.category {
        case .machineLearning:
            return [L("ecosystem.usecase.ml.1"), L("ecosystem.usecase.ml.2"), L("ecosystem.usecase.ml.3"), L("ecosystem.usecase.ml.4")]
        case .chemistry:
            return [L("ecosystem.usecase.chem.1"), L("ecosystem.usecase.chem.2"), L("ecosystem.usecase.chem.3"), L("ecosystem.usecase.chem.4")]
        case .optimization:
            return [L("ecosystem.usecase.opt.1"), L("ecosystem.usecase.opt.2"), L("ecosystem.usecase.opt.3"), L("ecosystem.usecase.opt.4")]
        case .hardware:
            return [L("ecosystem.usecase.hw.1"), L("ecosystem.usecase.hw.2"), L("ecosystem.usecase.hw.3"), L("ecosystem.usecase.hw.4")]
        case .simulation:
            return [L("ecosystem.usecase.sim.1"), L("ecosystem.usecase.sim.2"), L("ecosystem.usecase.sim.3"), L("ecosystem.usecase.sim.4")]
        case .research:
            return [L("ecosystem.usecase.research.1"), L("ecosystem.usecase.research.2"), L("ecosystem.usecase.research.3"), L("ecosystem.usecase.research.4")]
        }
    }
}

// MARK: - Ecosystem Code Export Sheet
struct EcosystemCodeExportSheet: View {
    let project: QuantumEcosystemProject
    @Environment(\.dismiss) var dismiss
    @ObservedObject var localization = LocalizationManager.shared
    @State private var copied = false

    // Localization helper
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    private var projectName: String {
        return L(project.nameKey)
    }

    var sampleCode: String {
        switch project.category {
        case .machineLearning:
            return """
            # \(projectName) - Sample Code
            import torch
            from torchquantum import QuantumDevice, QuantumCircuit

            # Create quantum device with 4 qubits
            dev = QuantumDevice(n_wires=4)

            # Build quantum neural network layer
            qc = QuantumCircuit(n_wires=4)
            qc.h(wires=0)
            qc.cnot(wires=[0, 1])
            qc.ry(wires=2, params=0.5)
            qc.cnot(wires=[2, 3])

            # Execute and measure
            dev.forward(qc)
            result = dev.measure()
            print(f"Measurement: {result}")
            """
        case .chemistry:
            return """
            # \(projectName) - Sample Code
            from qiskit_nature.second_q.drivers import PySCFDriver
            from qiskit_nature.second_q.mappers import JordanWignerMapper

            # Define H2 molecule
            driver = PySCFDriver(atom="H 0 0 0; H 0 0 0.735")
            problem = driver.run()

            # Map to qubit operators
            mapper = JordanWignerMapper()
            qubit_op = mapper.map(problem.second_q_ops())

            # Run VQE for ground state
            from qiskit.algorithms import VQE
            vqe = VQE(ansatz=problem.ansatz)
            result = vqe.compute_minimum_eigenvalue(qubit_op)
            print(f"Ground state energy: {result.eigenvalue}")
            """
        case .optimization:
            return """
            # \(projectName) - Sample Code
            from qiskit_optimization import QuadraticProgram
            from qiskit_optimization.algorithms import MinimumEigenOptimizer
            from qiskit.algorithms import QAOA

            # Define optimization problem
            qp = QuadraticProgram()
            qp.binary_var('x')
            qp.binary_var('y')
            qp.minimize(linear={'x': 1, 'y': 2})

            # Solve with QAOA
            qaoa = QAOA(reps=2)
            optimizer = MinimumEigenOptimizer(qaoa)
            result = optimizer.solve(qp)
            print(f"Optimal solution: {result.x}")
            """
        case .hardware:
            return """
            # \(projectName) - Connection Code
            from qiskit_ibm_runtime import QiskitRuntimeService

            # Initialize service
            service = QiskitRuntimeService(
                channel="ibm_quantum",
                token="YOUR_API_TOKEN"
            )

            # Get backend
            backend = service.backend("\(projectName.lowercased().replacingOccurrences(of: " ", with: "_"))")
            print(f"Backend: {backend.name}")
            print(f"Qubits: {backend.num_qubits}")
            print(f"Status: {backend.status()}")
            """
        case .simulation:
            return """
            # \(projectName) - Sample Code
            from qiskit import QuantumCircuit
            from qiskit_aer import AerSimulator

            # Create Bell state circuit
            qc = QuantumCircuit(2, 2)
            qc.h(0)
            qc.cx(0, 1)
            qc.measure([0, 1], [0, 1])

            # Run on Aer simulator
            simulator = AerSimulator()
            job = simulator.run(qc, shots=1000)
            result = job.result()
            counts = result.get_counts()
            print(f"Results: {counts}")
            """
        case .research:
            return """
            # \(projectName) - Sample Code
            import pennylane as qml
            import numpy as np

            # Create quantum device
            dev = qml.device("default.qubit", wires=2)

            @qml.qnode(dev)
            def circuit(params):
                qml.RX(params[0], wires=0)
                qml.RY(params[1], wires=1)
                qml.CNOT(wires=[0, 1])
                return qml.expval(qml.PauliZ(0))

            # Optimize circuit
            params = np.array([0.5, 0.1])
            opt = qml.GradientDescentOptimizer(stepsize=0.4)
            for _ in range(100):
                params = opt.step(circuit, params)
            print(f"Optimized params: {params}")
            """
        }
    }

    var body: some View {
        ZStack {
            QuantumHorizonBackground()

            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(L("ecosystem.sample_code"))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        Text(projectName)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }

                // Code View
                ScrollView {
                    Text(sampleCode)
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(.white.opacity(0.9))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color.black.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Copy Button
                Button(action: {
                    UIPasteboard.general.string = sampleCode
                    copied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        copied = false
                    }
                }) {
                    HStack {
                        Image(systemName: copied ? "checkmark" : "doc.on.doc")
                        Text(copied ? L("bridge.qasm.copied") : L("ecosystem.copy"))
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(QuantumHorizonColors.quantumCyan)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(24)
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        QuantumHorizonBackground()
        IndustryHubView()
    }
    .preferredColorScheme(.dark)
}
