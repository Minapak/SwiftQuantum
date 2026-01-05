//
//  IndustrySolutionsView.swift
//  SuperpositionVisualizer - SwiftQuantum v2.1.0
//
//  Created by Eunmin Park on 2026-01-06.
//  Copyright (c) 2026 iOS Quantum Engineering. All rights reserved.
//
//  Tab 6 Replacement: Industry Solutions (B2B)
//  Financial optimization, drug discovery, logistics, and more
//

import SwiftUI

// MARK: - Industry Solutions View

struct IndustrySolutionsView: View {
    @StateObject private var viewModel = IndustrySolutionsViewModel()
    @State private var selectedSolution: IndustrySolution?
    @State private var showPremiumAlert = false

    var body: some View {
        ZStack {
            // Premium dark gradient
            LinearGradient(
                colors: [
                    Color(red: 0.03, green: 0.03, blue: 0.1),
                    Color(red: 0.08, green: 0.05, blue: 0.15)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    industryHeader

                    // Featured solutions
                    featuredSolutions

                    // Solution categories
                    solutionCategories

                    // Case studies
                    caseStudiesSection

                    // Contact CTA
                    enterpriseContactCTA
                }
                .padding()
            }
        }
        .sheet(item: $selectedSolution) { solution in
            SolutionDetailView(solution: solution)
        }
        .alert("Premium Feature", isPresented: $showPremiumAlert) {
            Button("Learn More", role: .cancel) {}
            Button("Upgrade") {}
        } message: {
            Text("This solution requires QuantumBridge Premium. Upgrade to access enterprise features.")
        }
    }

    // MARK: - Industry Header

    private var industryHeader: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "building.2.fill")
                    .font(.system(size: 32))
                    .foregroundColor(QuantumPremiumColors.cyberneticBlue)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Industry Solutions")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Quantum-Powered Enterprise Applications")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                // B2B badge
                Text("B2B")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(QuantumPremiumColors.neonGreen)
                    .cornerRadius(8)
            }

            // Stats bar
            HStack(spacing: 20) {
                IndustryStatBadge(value: "127", label: "Qubits", icon: "cpu")
                IndustryStatBadge(value: "10x", label: "Speedup", icon: "bolt")
                IndustryStatBadge(value: "99.5%", label: "Fidelity", icon: "checkmark.seal")
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    QuantumPremiumColors.cyberneticBlue.opacity(0.15),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
    }

    // MARK: - Featured Solutions

    private var featuredSolutions: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Featured Solutions")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()

                Text("Enterprise Ready")
                    .font(.caption)
                    .foregroundColor(QuantumPremiumColors.neonGreen)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.featuredSolutions) { solution in
                        FeaturedSolutionCard(solution: solution)
                            .onTapGesture {
                                selectedSolution = solution
                            }
                    }
                }
            }
        }
    }

    // MARK: - Solution Categories

    private var solutionCategories: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Industry Categories")
                .font(.headline)
                .foregroundColor(.white)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(viewModel.categories) { category in
                    CategoryCard(category: category)
                        .onTapGesture {
                            // Show category solutions
                        }
                }
            }
        }
    }

    // MARK: - Case Studies Section

    private var caseStudiesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Case Studies")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()

                Button(action: {}) {
                    Text("View All")
                        .font(.caption)
                        .foregroundColor(QuantumPremiumColors.cyberneticBlue)
                }
            }

            ForEach(viewModel.caseStudies) { caseStudy in
                CaseStudyCard(caseStudy: caseStudy)
            }
        }
    }

    // MARK: - Enterprise Contact CTA

    private var enterpriseContactCTA: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "person.2.fill")
                    .font(.title)
                    .foregroundColor(QuantumPremiumColors.cyberneticBlue)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Enterprise Solutions")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("Custom quantum solutions for your business")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()
            }

            Text("Our team of quantum experts can help design and implement custom solutions tailored to your specific industry challenges.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.leading)

            HStack(spacing: 12) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "envelope")
                        Text("Contact Sales")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(QuantumPremiumColors.cyberneticBlue)
                    .cornerRadius(10)
                }

                Button(action: {}) {
                    HStack {
                        Image(systemName: "calendar")
                        Text("Schedule Demo")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    QuantumPremiumColors.cyberneticBlue.opacity(0.2),
                    Color.purple.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(QuantumPremiumColors.cyberneticBlue.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

// MARK: - Industry Stat Badge

struct IndustryStatBadge: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(QuantumPremiumColors.cyberneticBlue)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(label)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Featured Solution Card

struct FeaturedSolutionCard: View {
    let solution: IndustrySolution

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon and badge
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(solution.color.opacity(0.2))
                        .frame(width: 50, height: 50)

                    Image(systemName: solution.icon)
                        .font(.title2)
                        .foregroundColor(solution.color)
                }

                Spacer()

                if solution.isNew {
                    Text("NEW")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(QuantumPremiumColors.neonGreen)
                        .cornerRadius(6)
                }
            }

            // Title and description
            Text(solution.title)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(2)

            Text(solution.shortDescription)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(3)

            Spacer()

            // Stats
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text(solution.implementationTime)
                        .font(.caption2)
                }
                .foregroundColor(.white.opacity(0.5))

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill")
                        .font(.caption2)
                    Text(solution.speedup)
                        .font(.caption2)
                }
                .foregroundColor(solution.color)
            }
        }
        .frame(width: 200, height: 200)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}

// MARK: - Category Card

struct CategoryCard: View {
    let category: IndustryCategory

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(category.color.opacity(0.2))
                    .frame(width: 44, height: 44)

                Image(systemName: category.icon)
                    .font(.title3)
                    .foregroundColor(category.color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(category.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text("\(category.solutionCount) solutions")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.white.opacity(0.3))
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - Case Study Card

struct CaseStudyCard: View {
    let caseStudy: CaseStudy

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Company icon placeholder
                RoundedRectangle(cornerRadius: 8)
                    .fill(caseStudy.color.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(caseStudy.company.prefix(1)))
                            .font(.headline)
                            .foregroundColor(caseStudy.color)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(caseStudy.company)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Text(caseStudy.industry)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }

                Spacer()

                Text(caseStudy.result)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(QuantumPremiumColors.neonGreen)
            }

            Text(caseStudy.description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(2)

            // Tags
            HStack(spacing: 8) {
                ForEach(caseStudy.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(6)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - Solution Detail View

struct SolutionDetailView: View {
    let solution: IndustrySolution
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(solution.color.opacity(0.2))
                                        .frame(width: 60, height: 60)

                                    Image(systemName: solution.icon)
                                        .font(.title)
                                        .foregroundColor(solution.color)
                                }

                                Spacer()

                                if solution.isNew {
                                    Text("NEW")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(QuantumPremiumColors.neonGreen)
                                        .cornerRadius(8)
                                }
                            }

                            Text(solution.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text(solution.shortDescription)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding()

                        // Key metrics
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Key Metrics")
                                .font(.headline)
                                .foregroundColor(.white)

                            HStack(spacing: 16) {
                                MetricCard(title: "Speedup", value: solution.speedup, icon: "bolt.fill", color: .orange)
                                MetricCard(title: "Time", value: solution.implementationTime, icon: "clock", color: .blue)
                                MetricCard(title: "ROI", value: "3x", icon: "chart.line.uptrend.xyaxis", color: .green)
                            }
                        }
                        .padding()

                        // Use cases
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Use Cases")
                                .font(.headline)
                                .foregroundColor(.white)

                            ForEach(solution.useCases, id: \.self) { useCase in
                                HStack(spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(QuantumPremiumColors.neonGreen)

                                    Text(useCase)
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                        }
                        .padding()

                        // CTA
                        VStack(spacing: 12) {
                            Button(action: {}) {
                                Text("Request Demo")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(QuantumPremiumColors.cyberneticBlue)
                                    .cornerRadius(12)
                            }

                            Button(action: {}) {
                                Text("Download Whitepaper")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(12)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)

            Text(value)
                .font(.headline)
                .foregroundColor(.white)

            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - View Model

@MainActor
class IndustrySolutionsViewModel: ObservableObject {
    @Published var featuredSolutions: [IndustrySolution] = []
    @Published var categories: [IndustryCategory] = []
    @Published var caseStudies: [CaseStudy] = []

    init() {
        setupData()
    }

    private func setupData() {
        featuredSolutions = [
            IndustrySolution(
                title: "Portfolio Optimization",
                shortDescription: "Optimize investment portfolios using quantum annealing for maximum returns with minimal risk",
                icon: "chart.pie.fill",
                color: .blue,
                speedup: "100x",
                implementationTime: "4 weeks",
                isNew: true,
                useCases: [
                    "Asset allocation optimization",
                    "Risk management",
                    "Derivatives pricing",
                    "Arbitrage detection"
                ]
            ),
            IndustrySolution(
                title: "Drug Discovery",
                shortDescription: "Accelerate molecular simulation for drug candidate screening using quantum chemistry",
                icon: "pills.fill",
                color: .green,
                speedup: "1000x",
                implementationTime: "8 weeks",
                isNew: true,
                useCases: [
                    "Molecular dynamics simulation",
                    "Protein folding prediction",
                    "Drug-target interaction",
                    "Toxicity screening"
                ]
            ),
            IndustrySolution(
                title: "Supply Chain",
                shortDescription: "Optimize logistics and supply chain operations with quantum-enhanced routing",
                icon: "shippingbox.fill",
                color: .orange,
                speedup: "50x",
                implementationTime: "6 weeks",
                isNew: false,
                useCases: [
                    "Vehicle routing optimization",
                    "Inventory management",
                    "Demand forecasting",
                    "Warehouse optimization"
                ]
            ),
            IndustrySolution(
                title: "Fraud Detection",
                shortDescription: "Detect financial fraud in real-time using quantum machine learning",
                icon: "shield.fill",
                color: .red,
                speedup: "10x",
                implementationTime: "3 weeks",
                isNew: false,
                useCases: [
                    "Transaction monitoring",
                    "Pattern recognition",
                    "Anomaly detection",
                    "Risk scoring"
                ]
            )
        ]

        categories = [
            IndustryCategory(name: "Finance", icon: "dollarsign.circle.fill", color: .blue, solutionCount: 8),
            IndustryCategory(name: "Healthcare", icon: "heart.fill", color: .red, solutionCount: 6),
            IndustryCategory(name: "Logistics", icon: "truck.box.fill", color: .orange, solutionCount: 5),
            IndustryCategory(name: "Energy", icon: "bolt.fill", color: .yellow, solutionCount: 4),
            IndustryCategory(name: "Manufacturing", icon: "gear", color: .gray, solutionCount: 4),
            IndustryCategory(name: "Security", icon: "lock.shield.fill", color: .purple, solutionCount: 3)
        ]

        caseStudies = [
            CaseStudy(
                company: "Global Bank Corp",
                industry: "Finance",
                description: "Reduced portfolio optimization time from 2 hours to 3 minutes using quantum annealing",
                result: "40x faster",
                color: .blue,
                tags: ["Portfolio", "Optimization", "QAOA"]
            ),
            CaseStudy(
                company: "BioTech Labs",
                industry: "Healthcare",
                description: "Identified 3 new drug candidates in 6 months using quantum molecular simulation",
                result: "10x efficiency",
                color: .green,
                tags: ["Drug Discovery", "VQE", "Chemistry"]
            ),
            CaseStudy(
                company: "LogiTrans Inc",
                industry: "Logistics",
                description: "Optimized delivery routes across 500 cities, reducing fuel costs by 23%",
                result: "23% savings",
                color: .orange,
                tags: ["Routing", "TSP", "Optimization"]
            )
        ]
    }
}

// MARK: - Models

struct IndustrySolution: Identifiable {
    let id = UUID()
    let title: String
    let shortDescription: String
    let icon: String
    let color: Color
    let speedup: String
    let implementationTime: String
    let isNew: Bool
    let useCases: [String]
}

struct IndustryCategory: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let solutionCount: Int
}

struct CaseStudy: Identifiable {
    let id = UUID()
    let company: String
    let industry: String
    let description: String
    let result: String
    let color: Color
    let tags: [String]
}

// MARK: - Preview

struct IndustrySolutionsView_Previews: PreviewProvider {
    static var previews: some View {
        IndustrySolutionsView()
            .preferredColorScheme(.dark)
    }
}
