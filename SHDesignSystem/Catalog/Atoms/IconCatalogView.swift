//
//  IconCatalogView.swift
//  SHDesignSystem
//

import SwiftUI
import SHDesignSystemKit

struct IconCatalogView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SH.spacing.xl) {
                // Icon Sizes
                sectionHeader("Icon Sizes")

                SHCard(style: .outlined) {
                    HStack(spacing: SH.spacing.lg) {
                        ForEach(SHIconSize.allCases, id: \.self) { size in
                            VStack(spacing: SH.spacing.xs) {
                                SHIcon("star.fill", size: size)
                                Text(size.displayName)
                                    .font(SH.typography.captionSmall)
                                    .foregroundStyle(SH.colors.textTertiary)
                            }
                        }
                    }
                }

                // Icon Weights
                sectionHeader("Icon Weights")

                SHCard(style: .outlined) {
                    HStack(spacing: SH.spacing.xl) {
                        iconWeight("Light", .light)
                        iconWeight("Regular", .regular)
                        iconWeight("Medium", .medium)
                        iconWeight("Semibold", .semibold)
                        iconWeight("Bold", .bold)
                    }
                }

                // Themed Icons
                sectionHeader("Themed Icons")

                SHCard(style: .outlined) {
                    HStack(spacing: SH.spacing.xl) {
                        VStack(spacing: SH.spacing.xs) {
                            SHThemedIcon("star.fill", size: .lg)
                            Text("Primary")
                                .font(SH.typography.captionSmall)
                                .foregroundStyle(SH.colors.textTertiary)
                        }

                        VStack(spacing: SH.spacing.xs) {
                            SHThemedIcon("heart.fill", size: .lg, useAccent: true)
                            Text("Accent")
                                .font(SH.typography.captionSmall)
                                .foregroundStyle(SH.colors.textTertiary)
                        }
                    }
                }

                // Circled Icons
                sectionHeader("Circled Icons")

                SHCard(style: .outlined) {
                    VStack(spacing: SH.spacing.lg) {
                        // Styles
                        HStack(spacing: SH.spacing.xl) {
                            VStack(spacing: SH.spacing.xs) {
                                SHCircledIcon("star.fill", size: .lg, style: .filled)
                                Text("Filled")
                                    .font(SH.typography.captionSmall)
                                    .foregroundStyle(SH.colors.textTertiary)
                            }

                            VStack(spacing: SH.spacing.xs) {
                                SHCircledIcon("star.fill", size: .lg, style: .outlined)
                                Text("Outlined")
                                    .font(SH.typography.captionSmall)
                                    .foregroundStyle(SH.colors.textTertiary)
                            }

                            VStack(spacing: SH.spacing.xs) {
                                SHCircledIcon("star.fill", size: .lg, style: .glass)
                                Text("Glass")
                                    .font(SH.typography.captionSmall)
                                    .foregroundStyle(SH.colors.textTertiary)
                            }
                        }

                        SHDivider()

                        // Sizes
                        HStack(spacing: SH.spacing.lg) {
                            SHCircledIcon("bell.fill", size: .sm, style: .filled)
                            SHCircledIcon("bell.fill", size: .md, style: .filled)
                            SHCircledIcon("bell.fill", size: .lg, style: .filled)
                            SHCircledIcon("bell.fill", size: .xl, style: .filled)
                        }
                    }
                }

                // Icon Samples
                sectionHeader("Sample Icons")

                SHCard(style: .outlined) {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: SH.spacing.lg) {
                        ForEach(sampleIcons, id: \.self) { icon in
                            VStack(spacing: SH.spacing.xxs) {
                                SHIcon(icon, size: .lg)
                                Text(icon)
                                    .font(SH.typography.captionSmall)
                                    .foregroundStyle(SH.colors.textTertiary)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(SH.colors.background)
        .navigationTitle("Icons")
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(SH.typography.titleSmall)
            .foregroundStyle(SH.colors.textPrimary)
    }

    private func iconWeight(_ name: String, _ weight: SHIconWeight) -> some View {
        VStack(spacing: SH.spacing.xs) {
            SHIcon("star.fill", size: .lg, weight: weight)
            Text(name)
                .font(SH.typography.captionSmall)
                .foregroundStyle(SH.colors.textTertiary)
        }
    }

    private var sampleIcons: [String] {
        [
            "house.fill",
            "heart.fill",
            "star.fill",
            "bell.fill",
            "gear",
            "person.fill",
            "magnifyingglass",
            "envelope.fill",
            "phone.fill",
            "camera.fill"
        ]
    }
}

#Preview {
    NavigationStack {
        IconCatalogView()
            .shTheme(.pastelPink)
    }
}
