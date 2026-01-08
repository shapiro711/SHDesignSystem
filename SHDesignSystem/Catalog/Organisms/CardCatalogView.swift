//
//  CardCatalogView.swift
//  SHDesignSystem
//

import SwiftUI
import SHDesignSystemKit

struct CardCatalogView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SH.spacing.xl) {
                // Card Styles
                sectionHeader("Card Styles")

                ForEach(SHCardStyle.allCases, id: \.self) { style in
                    SHCard(style: style) {
                        VStack(alignment: .leading, spacing: SH.spacing.sm) {
                            Text(style.displayName)
                                .font(SH.typography.titleSmall)
                                .foregroundStyle(SH.colors.textPrimary)

                            Text("카드 내용이 들어갑니다. 다양한 컨텐츠를 담을 수 있습니다.")
                                .font(SH.typography.bodySmall)
                                .foregroundStyle(SH.colors.textSecondary)
                        }
                    }
                }

                // Tappable Card
                sectionHeader("Tappable Card")

                SHCard(style: .outlined, content: {
                    HStack {
                        VStack(alignment: .leading, spacing: SH.spacing.xxs) {
                            Text("탭 가능한 카드")
                                .font(SH.typography.titleSmall)
                            Text("클릭하면 액션이 실행됩니다")
                                .font(SH.typography.bodySmall)
                                .foregroundStyle(SH.colors.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(SH.colors.textTertiary)
                    }
                }, action: {})

                // Action Card
                sectionHeader("Action Cards")

                SHActionCard(title: "새 프로젝트", subtitle: "프로젝트를 시작해보세요", icon: "plus.circle.fill") {}
                SHActionCard(title: "설정", icon: "gear", style: .outlined) {}

                // Stats Card
                sectionHeader("Stats Cards")

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: SH.spacing.md) {
                    SHStatsCard(
                        title: "총 수익",
                        value: "₩1,234,567",
                        trend: .up("+12.5%"),
                        icon: "chart.line.uptrend.xyaxis"
                    )

                    SHStatsCard(
                        title: "방문자",
                        value: "8,234",
                        trend: .down("-3.2%"),
                        icon: "person.2.fill"
                    )

                    SHStatsCard(
                        title: "전환율",
                        value: "4.8%",
                        trend: .neutral("0%"),
                        icon: "arrow.triangle.2.circlepath"
                    )

                    SHStatsCard(
                        title: "평균 체류",
                        value: "3:42",
                        icon: "clock.fill"
                    )
                }

                // Complex Card Example
                sectionHeader("Complex Card")

                SHCard(style: .glass) {
                    VStack(alignment: .leading, spacing: SH.spacing.md) {
                        HStack {
                            SHCircledIcon("person.fill", size: .lg, style: .filled)

                            VStack(alignment: .leading, spacing: SH.spacing.xxxs) {
                                Text("김철수")
                                    .font(SH.typography.titleSmall)
                                Text("iOS Developer")
                                    .font(SH.typography.bodySmall)
                                    .foregroundStyle(SH.colors.textSecondary)
                            }

                            Spacer()

                            SHButton("팔로우", style: .primary, size: .small) {}
                        }

                        SHDivider()

                        HStack(spacing: SH.spacing.xl) {
                            statItem("게시물", "128")
                            statItem("팔로워", "1.2K")
                            statItem("팔로잉", "567")
                        }
                    }
                }

                // Image Card Preview (placeholder)
                sectionHeader("Image Card (Concept)")

                SHCard(style: .elevated, padding: 0) {
                    VStack(spacing: 0) {
                        // Placeholder for image
                        LinearGradient(
                            colors: [SH.colors.pink, SH.colors.lavender],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 160)

                        VStack(alignment: .leading, spacing: SH.spacing.xs) {
                            Text("이미지 카드")
                                .font(SH.typography.titleMedium)

                            Text("상단에 이미지가 들어가는 카드 형태입니다.")
                                .font(SH.typography.bodySmall)
                                .foregroundStyle(SH.colors.textSecondary)
                        }
                        .padding(SH.spacing.md)
                    }
                }
            }
            .padding()
        }
        .background(SH.colors.background)
        .navigationTitle("Cards")
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(SH.typography.titleSmall)
            .foregroundStyle(SH.colors.textPrimary)
    }

    private func statItem(_ label: String, _ value: String) -> some View {
        VStack(spacing: SH.spacing.xxxs) {
            Text(value)
                .font(SH.typography.titleSmall)
                .foregroundStyle(SH.colors.textPrimary)
            Text(label)
                .font(SH.typography.captionSmall)
                .foregroundStyle(SH.colors.textSecondary)
        }
    }
}

#Preview {
    NavigationStack {
        CardCatalogView()
            .shTheme(.pastelLavender)
    }
}
