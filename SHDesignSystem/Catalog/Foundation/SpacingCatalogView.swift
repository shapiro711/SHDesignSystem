//
//  SpacingCatalogView.swift
//  SHDesignSystem
//

import SwiftUI
import SHDesignSystemKit

struct SpacingCatalogView: View {
    @Environment(\.shTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SH.spacing.xl) {
                // Spacing
                spacingSection

                // Radius
                radiusSection
            }
            .padding()
        }
        .background(SH.colors.background)
        .navigationTitle("Spacing & Radius")
    }

    private var spacingSection: some View {
        VStack(alignment: .leading, spacing: SH.spacing.md) {
            Text("Spacing")
                .font(SH.typography.titleSmall)
                .foregroundStyle(SH.colors.textPrimary)

            SHCard(style: .outlined) {
                VStack(alignment: .leading, spacing: SH.spacing.md) {
                    spacingRow("xxxs", SH.spacing.xxxs)
                    spacingRow("xxs", SH.spacing.xxs)
                    spacingRow("xs", SH.spacing.xs)
                    spacingRow("sm", SH.spacing.sm)
                    spacingRow("md", SH.spacing.md)
                    spacingRow("lg", SH.spacing.lg)
                    spacingRow("xl", SH.spacing.xl)
                    spacingRow("xxl", SH.spacing.xxl)
                    spacingRow("xxxl", SH.spacing.xxxl)
                }
            }
        }
    }

    private func spacingRow(_ name: String, _ value: CGFloat) -> some View {
        HStack(spacing: SH.spacing.md) {
            Text(name)
                .font(SH.typography.labelMedium)
                .foregroundStyle(SH.colors.textPrimary)
                .frame(width: 50, alignment: .leading)

            Text("\(Int(value))pt")
                .font(SH.typography.caption)
                .foregroundStyle(SH.colors.textSecondary)
                .frame(width: 40, alignment: .leading)

            RoundedRectangle(cornerRadius: SH.radius.xs, style: .continuous)
                .fill(theme.primaryColor)
                .frame(width: value * 3, height: 20)

            Spacer()
        }
    }

    private var radiusSection: some View {
        VStack(alignment: .leading, spacing: SH.spacing.md) {
            Text("Radius")
                .font(SH.typography.titleSmall)
                .foregroundStyle(SH.colors.textPrimary)

            SHCard(style: .outlined) {
                VStack(spacing: SH.spacing.lg) {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: SH.spacing.md) {
                        radiusItem("xs", SH.radius.xs)
                        radiusItem("sm", SH.radius.sm)
                        radiusItem("md", SH.radius.md)
                        radiusItem("lg", SH.radius.lg)
                        radiusItem("xl", SH.radius.xl)
                        radiusItem("xxl", SH.radius.xxl)
                        radiusItem("xxxl", SH.radius.xxxl)
                        radiusItem("full", SH.radius.full, isCircle: true)
                    }
                }
            }

            // Comparison
            Text("비교")
                .font(SH.typography.labelMedium)
                .foregroundStyle(SH.colors.textSecondary)
                .padding(.top, SH.spacing.md)

            HStack(spacing: SH.spacing.md) {
                comparisonCard("Sharp", 0)
                comparisonCard("Soft", SH.radius.lg)
                comparisonCard("Rounded", SH.radius.xxl)
            }
        }
    }

    private func radiusItem(_ name: String, _ value: CGFloat, isCircle: Bool = false) -> some View {
        VStack(spacing: SH.spacing.xs) {
            if isCircle {
                Circle()
                    .fill(theme.primaryColor.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(theme.primaryColor, lineWidth: 2)
                    )
            } else {
                RoundedRectangle(cornerRadius: value, style: .continuous)
                    .fill(theme.primaryColor.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: value, style: .continuous)
                            .stroke(theme.primaryColor, lineWidth: 2)
                    )
            }

            VStack(spacing: 2) {
                Text(name)
                    .font(SH.typography.labelSmall)
                    .foregroundStyle(SH.colors.textPrimary)

                Text("\(Int(min(value, 999)))pt")
                    .font(SH.typography.captionSmall)
                    .foregroundStyle(SH.colors.textTertiary)
            }
        }
    }

    private func comparisonCard(_ name: String, _ radius: CGFloat) -> some View {
        VStack(spacing: SH.spacing.xs) {
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(theme.primaryColor)
                .frame(height: 80)

            Text(name)
                .font(SH.typography.captionSmall)
                .foregroundStyle(SH.colors.textSecondary)
        }
    }
}

#Preview {
    NavigationStack {
        SpacingCatalogView()
            .shTheme(.pastelPink)
    }
}
