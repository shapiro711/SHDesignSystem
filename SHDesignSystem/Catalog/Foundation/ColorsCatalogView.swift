//
//  ColorsCatalogView.swift
//  SHDesignSystem
//

import SwiftUI
import SHDesignSystemKit

struct ColorsCatalogView: View {
    @Environment(\.shTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: SH.spacing.xl) {
                // Pastel Palette
                colorSection("Pastel Palette") {
                    colorGrid([
                        ("Pink", SH.colors.pink),
                        ("Mint", SH.colors.mint),
                        ("Lavender", SH.colors.lavender),
                        ("Peach", SH.colors.peach),
                        ("Sky", SH.colors.sky),
                        ("Lemon", SH.colors.lemon),
                    ])
                }

                // Semantic Colors
                colorSection("Semantic Colors") {
                    colorGrid([
                        ("Primary", SH.colors.primary),
                        ("Secondary", SH.colors.secondary),
                        ("Accent", SH.colors.accent),
                    ])
                }

                // Background Colors
                colorSection("Background") {
                    colorGrid([
                        ("Background", SH.colors.background),
                        ("Surface", SH.colors.surface),
                        ("Elevated", SH.colors.surfaceElevated),
                    ])
                }

                // Text Colors
                colorSection("Text Colors") {
                    VStack(spacing: SH.spacing.sm) {
                        textColorRow("Primary", SH.colors.textPrimary)
                        textColorRow("Secondary", SH.colors.textSecondary)
                        textColorRow("Tertiary", SH.colors.textTertiary)
                    }
                }

                // State Colors
                colorSection("State Colors") {
                    colorGrid([
                        ("Success", SH.colors.success),
                        ("Warning", SH.colors.warning),
                        ("Error", SH.colors.error),
                        ("Info", SH.colors.info),
                    ])
                }

                // Glass Colors
                colorSection("Glass Colors") {
                    HStack(spacing: SH.spacing.md) {
                        glassPreview("Glass BG", SH.colors.glassBackground)
                        glassPreview("Glass Border", SH.colors.glassBorder)
                    }
                }
            }
            .padding()
        }
        .background(SH.colors.background)
        .navigationTitle("Colors")
    }

    private func colorSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: SH.spacing.md) {
            Text(title)
                .font(SH.typography.titleSmall)
                .foregroundStyle(SH.colors.textPrimary)
            content()
        }
    }

    private func colorGrid(_ colors: [(String, Color)]) -> some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: SH.spacing.md) {
            ForEach(colors, id: \.0) { name, color in
                colorItem(name, color)
            }
        }
    }

    private func colorItem(_ name: String, _ color: Color) -> some View {
        VStack(spacing: SH.spacing.xs) {
            RoundedRectangle(cornerRadius: SH.radius.lg, style: .continuous)
                .fill(color)
                .frame(height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: SH.radius.lg, style: .continuous)
                        .stroke(SH.colors.border, lineWidth: 1)
                )

            Text(name)
                .font(SH.typography.captionSmall)
                .foregroundStyle(SH.colors.textSecondary)
        }
    }

    private func textColorRow(_ name: String, _ color: Color) -> some View {
        HStack {
            Text(name)
                .font(SH.typography.bodyMedium)
                .foregroundStyle(color)

            Spacer()

            Circle()
                .fill(color)
                .frame(width: 24, height: 24)
        }
        .padding(SH.spacing.sm)
        .background(SH.colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: SH.radius.md, style: .continuous))
    }

    private func glassPreview(_ name: String, _ color: Color) -> some View {
        VStack(spacing: SH.spacing.xs) {
            ZStack {
                LinearGradient(
                    colors: [theme.primaryColor, theme.accentColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                RoundedRectangle(cornerRadius: SH.radius.lg, style: .continuous)
                    .fill(color)
                    .padding(SH.spacing.md)
            }
            .frame(height: 80)
            .clipShape(RoundedRectangle(cornerRadius: SH.radius.lg, style: .continuous))

            Text(name)
                .font(SH.typography.captionSmall)
                .foregroundStyle(SH.colors.textSecondary)
        }
    }
}

#Preview {
    NavigationStack {
        ColorsCatalogView()
            .shTheme(.pastelLavender)
    }
}
