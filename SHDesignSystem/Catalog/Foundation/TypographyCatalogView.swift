//
//  TypographyCatalogView.swift
//  SHDesignSystem
//

import SwiftUI
import SHDesignSystemKit

struct TypographyCatalogView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SH.spacing.xl) {
                // Display
                typographySection("Display") {
                    typographyItem("Display Large", SH.typography.displayLarge)
                    typographyItem("Display Medium", SH.typography.displayMedium)
                    typographyItem("Display Small", SH.typography.displaySmall)
                }

                // Headline
                typographySection("Headline") {
                    typographyItem("Headline Large", SH.typography.headlineLarge)
                    typographyItem("Headline Medium", SH.typography.headlineMedium)
                    typographyItem("Headline Small", SH.typography.headlineSmall)
                }

                // Title
                typographySection("Title") {
                    typographyItem("Title Large", SH.typography.titleLarge)
                    typographyItem("Title Medium", SH.typography.titleMedium)
                    typographyItem("Title Small", SH.typography.titleSmall)
                }

                // Body
                typographySection("Body") {
                    typographyItem("Body Large", SH.typography.bodyLarge)
                    typographyItem("Body Medium", SH.typography.bodyMedium)
                    typographyItem("Body Small", SH.typography.bodySmall)
                }

                // Label
                typographySection("Label") {
                    typographyItem("Label Large", SH.typography.labelLarge)
                    typographyItem("Label Medium", SH.typography.labelMedium)
                    typographyItem("Label Small", SH.typography.labelSmall)
                }

                // Caption
                typographySection("Caption") {
                    typographyItem("Caption", SH.typography.caption)
                    typographyItem("Caption Small", SH.typography.captionSmall)
                }

                // SHLabel Examples
                SHCard(style: .outlined) {
                    VStack(alignment: .leading, spacing: SH.spacing.md) {
                        Text("SHLabel Component")
                            .font(SH.typography.titleSmall)
                            .foregroundStyle(SH.colors.textPrimary)

                        SHLabel("Display Style", style: .display)
                        SHLabel("Headline Style", style: .headline)
                        SHLabel("Title Style", style: .title)
                        SHLabel("Body Style", style: .body)
                        SHLabel("Caption Style", style: .caption)

                        SHDivider()

                        SHLabel("Accent Color", style: .title, color: .accent)
                        SHLabel("Secondary Color", style: .body, color: .secondary)

                        SHDivider()

                        SHIconLabel("Icon Label", icon: "star.fill", style: .title, color: .accent)
                    }
                }
            }
            .padding()
        }
        .background(SH.colors.background)
        .navigationTitle("Typography")
    }

    private func typographySection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: SH.spacing.sm) {
            Text(title)
                .font(SH.typography.labelMedium)
                .foregroundStyle(SH.colors.textSecondary)

            SHCard(style: .outlined) {
                VStack(alignment: .leading, spacing: SH.spacing.md) {
                    content()
                }
            }
        }
    }

    private func typographyItem(_ name: String, _ font: Font) -> some View {
        VStack(alignment: .leading, spacing: SH.spacing.xxs) {
            Text("가나다라마바사")
                .font(font)
                .foregroundStyle(SH.colors.textPrimary)

            Text(name)
                .font(SH.typography.captionSmall)
                .foregroundStyle(SH.colors.textTertiary)
        }
    }
}

#Preview {
    NavigationStack {
        TypographyCatalogView()
            .shTheme(.pastelMint)
    }
}
