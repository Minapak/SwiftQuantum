import SwiftUI

// MARK: - Industry Hub - "The Value"
// Premium Solution Showcase
// 3D 아이소매트릭 스타일 산업 아이콘, Gold-Orange 배지
// 앵커링 효과를 위한 플랜 비교, 수익 예측 그래프

struct IndustryHubView: View {
    @StateObject private var viewModel = IndustryHubViewModel()
    @State private var selectedIndustry: HorizonIndustrySolution?
    @State private var showPricingSheet = false
    @State private var showCaseStudy = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hero Section
                heroSection

                // Industry Solutions Grid
                industrySolutionsGrid

                // ROI Prediction Graph
                roiPredictionSection

                // Pricing Plans (Anchoring Effect)
                pricingSection

                // Success Stories
                successStoriesSection

                Spacer(minLength: 120)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .sheet(isPresented: $showPricingSheet) {
            PricingDetailSheet()
        }
    }

    // MARK: - Hero Section
    private var heroSection: some View {
        BentoCard(size: .large) {
            VStack(spacing: 20) {
                // Isometric illustration
                ZStack {
                    // Background glow
                    Circle()
                        .fill(QuantumHorizonColors.quantumGold.opacity(0.15))
                        .frame(width: 120, height: 120)
                        .blur(radius: 30)

                    // Isometric building stack
                    IsometricBuildingView()
                        .frame(width: 100, height: 100)
                }

                VStack(spacing: 8) {
                    Text("Enterprise Quantum Solutions")
                        .font(QuantumHorizonTypography.sectionTitle(22))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text("Transform your business with quantum-powered optimization and analytics")
                        .font(QuantumHorizonTypography.body(14))
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }

                // Quick Stats
                HStack(spacing: 20) {
                    quickStat(value: "47%", label: "Avg. Efficiency Gain")
                    quickStat(value: "2.3x", label: "ROI Improvement")
                    quickStat(value: "500+", label: "Enterprise Clients")
                }
            }
        }
    }

    private func quickStat(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(QuantumHorizonTypography.statNumber(24))
                .foregroundStyle(QuantumHorizonColors.goldCelebration)

            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
                .lineLimit(1)
        }
    }

    // MARK: - Industry Solutions Grid
    private var industrySolutionsGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Industry Solutions")
                .font(QuantumHorizonTypography.sectionTitle(18))
                .foregroundColor(.white)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                ForEach(viewModel.industries) { industry in
                    HorizonIndustrySolutionCard(
                        industry: industry,
                        isSelected: selectedIndustry?.id == industry.id
                    )
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedIndustry = industry
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
                Text("ROI Prediction")
                    .font(QuantumHorizonTypography.sectionTitle(18))
                    .foregroundColor(.white)

                Spacer()

                // User's learning progress badge
                HStack(spacing: 6) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 12))
                    Text("Based on your Level 8 progress")
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
                        legendItem(color: .white.opacity(0.4), label: "Without Quantum")
                        legendItem(color: QuantumHorizonColors.quantumGold, label: "With Quantum Premium")
                    }

                    // Projected Gain
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Projected Annual Gain")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.5))

                            Text("$\(viewModel.projectedAnnualGain, specifier: "%.0f")K")
                                .font(QuantumHorizonTypography.statNumber(28))
                                .foregroundStyle(QuantumHorizonColors.goldCelebration)
                        }

                        Spacer()

                        // Calculate button
                        Button(action: {}) {
                            HStack(spacing: 6) {
                                Image(systemName: "function")
                                Text("Calculate for your data")
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
            Text("Choose Your Plan")
                .font(QuantumHorizonTypography.sectionTitle(18))
                .foregroundColor(.white)

            // Enterprise Plan (shown first for anchoring)
            HorizonPricingPlanCard(
                plan: viewModel.enterprisePlan,
                isHighlighted: false,
                badge: "BEST VALUE"
            )

            // Pro Plan
            HorizonPricingPlanCard(
                plan: viewModel.proPlan,
                isHighlighted: true,
                badge: "POPULAR"
            )

            // Comparison table
            comparisonTable
        }
    }

    private var comparisonTable: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Feature")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Pro")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(QuantumHorizonColors.quantumPurple)
                    .frame(width: 60)

                Text("Enterprise")
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
            Text("Success Stories")
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

                // Premium badge
                if industry.isPremium {
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
                Text(industry.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)

                Text(industry.benefit)
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.5))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }

            // Efficiency gain
            HStack(spacing: 4) {
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 10))
                Text("\(industry.efficiencyGain)% efficiency")
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
            Button(action: {}) {
                Text("Get Started")
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
    let name: String
    let icon: String
    let benefit: String
    let efficiencyGain: Int
    let color: Color
    let isPremium: Bool
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
    }

    private func setupData() {
        industries = [
            HorizonIndustrySolution(name: "Finance", icon: "chart.line.uptrend.xyaxis", benefit: "Portfolio optimization & risk analysis", efficiencyGain: 52, color: .green, isPremium: true),
            HorizonIndustrySolution(name: "Healthcare", icon: "cross.circle.fill", benefit: "Drug discovery acceleration", efficiencyGain: 38, color: .red, isPremium: true),
            HorizonIndustrySolution(name: "Logistics", icon: "shippingbox.fill", benefit: "Route optimization & scheduling", efficiencyGain: 45, color: .orange, isPremium: false),
            HorizonIndustrySolution(name: "Energy", icon: "bolt.fill", benefit: "Grid optimization & forecasting", efficiencyGain: 41, color: .yellow, isPremium: true),
            HorizonIndustrySolution(name: "Manufacturing", icon: "gear.circle.fill", benefit: "Supply chain optimization", efficiencyGain: 33, color: .purple, isPremium: false),
            HorizonIndustrySolution(name: "AI & ML", icon: "brain.head.profile", benefit: "Quantum machine learning", efficiencyGain: 67, color: QuantumHorizonColors.quantumCyan, isPremium: true)
        ]

        successStories = [
            HorizonSuccessStory(company: "GlobalBank", industry: "Finance", quote: "Quantum optimization reduced our risk exposure by 40% while increasing returns.", result: "40% risk reduction", color: .green),
            HorizonSuccessStory(company: "PharmaCorp", industry: "Healthcare", quote: "Drug candidate screening time cut from months to days.", result: "85% faster discovery", color: .red),
            HorizonSuccessStory(company: "LogiFlow", industry: "Logistics", quote: "Fleet routing optimization saved us $2.3M annually.", result: "$2.3M annual savings", color: .orange)
        ]
    }
}

// MARK: - Pricing Detail Sheet
struct PricingDetailSheet: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            QuantumHorizonBackground()

            VStack {
                // Close button
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                .padding()

                Spacer()

                Text("Pricing Details Coming Soon")
                    .font(QuantumHorizonTypography.sectionTitle())
                    .foregroundColor(.white)

                Spacer()
            }
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
