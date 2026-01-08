//
//  ButtonCatalogView.swift
//  SHDesignSystem
//

import SwiftUI
import SHDesignSystemKit

struct ButtonCatalogView: View {
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SH.spacing.xl) {
                // Button Styles
                sectionHeader("Button Styles")

                ForEach(SHButtonStyle.allCases, id: \.self) { style in
                    SHCard(style: .outlined) {
                        VStack(alignment: .leading, spacing: SH.spacing.md) {
                            Text(style.displayName)
                                .font(SH.typography.labelMedium)
                                .foregroundStyle(SH.colors.textSecondary)

                            HStack(spacing: SH.spacing.md) {
                                SHButton("버튼", style: style) {}
                                SHButton("아이콘", icon: "star.fill", style: style) {}
                            }
                        }
                    }
                }

                // Button Sizes
                sectionHeader("Button Sizes")

                SHCard(style: .outlined) {
                    VStack(alignment: .leading, spacing: SH.spacing.md) {
                        ForEach(SHButtonSize.allCases, id: \.self) { size in
                            HStack {
                                Text(size.rawValue.capitalized)
                                    .font(SH.typography.labelMedium)
                                    .foregroundStyle(SH.colors.textSecondary)
                                    .frame(width: 80, alignment: .leading)

                                SHButton("버튼", size: size) {}
                            }
                        }
                    }
                }

                // Button States
                sectionHeader("Button States")

                SHCard(style: .outlined) {
                    VStack(alignment: .leading, spacing: SH.spacing.md) {
                        HStack(spacing: SH.spacing.md) {
                            VStack(spacing: SH.spacing.xs) {
                                SHButton("Normal") {}
                                Text("Normal")
                                    .font(SH.typography.captionSmall)
                                    .foregroundStyle(SH.colors.textTertiary)
                            }

                            VStack(spacing: SH.spacing.xs) {
                                SHButton("Disabled") {}
                                    .disabled(true)
                                Text("Disabled")
                                    .font(SH.typography.captionSmall)
                                    .foregroundStyle(SH.colors.textTertiary)
                            }

                            VStack(spacing: SH.spacing.xs) {
                                SHButton("Loading", isLoading: true) {}
                                Text("Loading")
                                    .font(SH.typography.captionSmall)
                                    .foregroundStyle(SH.colors.textTertiary)
                            }
                        }
                    }
                }

                // Full Width
                sectionHeader("Full Width")

                SHButton("Full Width Button", style: .primary, isFullWidth: true) {}
                SHButton("Full Width Ghost", icon: "arrow.right", style: .ghost, isFullWidth: true) {}

                // Icon Buttons
                sectionHeader("Icon Buttons")

                SHCard(style: .outlined) {
                    HStack(spacing: SH.spacing.lg) {
                        ForEach(SHButtonStyle.allCases, id: \.self) { style in
                            VStack(spacing: SH.spacing.xs) {
                                SHIconButton(icon: "heart.fill", style: style) {}
                                Text(style.displayName)
                                    .font(SH.typography.captionSmall)
                                    .foregroundStyle(SH.colors.textTertiary)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(SH.colors.background)
        .navigationTitle("Buttons")
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(SH.typography.titleSmall)
            .foregroundStyle(SH.colors.textPrimary)
    }
}

#Preview {
    NavigationStack {
        ButtonCatalogView()
            .shTheme(.pastelLavender)
    }
}
